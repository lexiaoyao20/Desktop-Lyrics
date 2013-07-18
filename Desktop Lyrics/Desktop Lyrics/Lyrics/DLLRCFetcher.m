//
//  DLLRCFetcher.m
//  Desktop Lyrics
//
//  Created by subo on 7/12/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import "DLLRCFetcher.h"
#import "DLDataDefine.h"
#import "DLBaiduAPIXMLParseOperation.h"

@interface DLLRCFetcher ()

- (void)startDownloadWithURL:(NSURL *)downloadURl;

@end

@implementation DLLRCFetcher 

@synthesize delegate = _delegate;
@synthesize lrcFilePath = _lrcFilePath;

- (id)initWithArtist:(NSString *)artist title:(NSString *)title {
    self = [super init];
    if (self && artist && title) {
        self.artist = artist;
        self.title = title;
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    else {
        SafeReleaseObj(self);
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_artist release];
    [_title release];
    [_operationQueue release];
    [_lrcFilePath release];
    [_download release];
    [super dealloc];
}

- (void)start {
    NSString *query = [NSString stringWithFormat:kDLBaiDuAPISearchLyricsURL,self.title,self.artist];
    NSString *encodeQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"query:%@",encodeQuery);
    NSURL *url = [NSURL URLWithString:encodeQuery];
	assert(url != nil);
    assert([[[url scheme] lowercaseString] isEqual:@"http"] || [[[url scheme] lowercaseString] isEqual:@"https"]);
    
    DLBaiduAPIXMLParseOperation *xmlParseOp = [[DLBaiduAPIXMLParseOperation alloc] initWithRequestURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(baiduXMLParseDidFinished:)
                                                 name:DLBaiDuAPIXMLParseDidFinishNotification
                                               object:xmlParseOp];
    [_operationQueue addOperation:xmlParseOp];
    SafeReleaseObj(xmlParseOp);
}

- (void)stop {
    [_operationQueue cancelAllOperations];
    if (_download) {
        [_download stop];
    }
}

@dynamic artist;
- (NSString *)artist {
    return _artist;
}

- (void)setArtist:(NSString *)artist {
    artist = [artist stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [artist copy];
    [_artist release];
    _artist = artist;
}

@dynamic title;
- (NSString *)title {
    return _title;
}

- (void)setTitle:(NSString *)title {
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [title copy];
    [_title release];
    _title = title;
}

#pragma mark -
#pragma mark .....:::::: Private Method ::::::..... 

- (void)startDownloadWithURL:(NSURL *)downloadURl {
    NSAssert(downloadURl, @"artist or title is nil");
    if (_download) {
        SafeReleaseObj(_download)
    }
    
    _download = [[DLDownload alloc] initWithDownloadURL:downloadURl];
    [_download setDelegate:self];
    NSString *lrcFileName = [NSString stringWithFormat:@"%@-%@%@", self.artist,self.title,LRCPATHEXTENSION];
    NSString *lrcSavePath = [[NSUserDefaults standardUserDefaults] objectForKey:kUDKLyricFileSavePath];
    [_download setFileName:lrcFileName];
    [_download setSavePath:lrcSavePath];
    [_download start];
}


#pragma mark -
#pragma mark ......:::::: Notifications :::::::......

- (void)baiduXMLParseDidFinished:(NSNotification *)no {
    NSError *error = [[no userInfo] objectForKey:DLErrorKey];
    if (error) {
        [self fetcherFinishedWithError:error];
        return;
    }
    
    NSArray *lrcsList = [[no userInfo] objectForKey:DLLRCURLListKey];
    if (!lrcsList || [lrcsList count] <= 0) {
        error = [NSError errorWithDomain:DLXMLParseErrorDomain code:CannotFindLRC userInfo:nil] ;
        [self fetcherFinishedWithError:error];
        return;
    }
    
    NSLog(@"lrcsList:%@",lrcsList);
    [self performSelector:@selector(startDownloadWithURL:)
                 onThread:[NSThread mainThread]
               withObject:[lrcsList objectAtIndex:0]
            waitUntilDone:NO];
}

#pragma mark -
#pragma mark .....:::::: implementation  DLDownloadDelegate ::::::.....

//下载失败
- (void)downloadDidFaild:(DLDownload *)aDownload didFailWithError:(NSError *)error {
    [self fetcherFinishedWithError:error];
}

//下载结束
- (void)downloadDidFinished:(DLDownload *)aDownload {
    NSString *downloadFilePath = [[aDownload.savePath stringByAppendingPathComponent:aDownload.fileName] retain];
    [_lrcFilePath release];
    _lrcFilePath = downloadFilePath;
    
    [self fetcherFinishedWithError:nil];
}

- (void)fetcherFinishedWithError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(lrcFetcherDidFinished:error:)]) {
        [_delegate lrcFetcherDidFinished:self error:error];
    }
}

@end
