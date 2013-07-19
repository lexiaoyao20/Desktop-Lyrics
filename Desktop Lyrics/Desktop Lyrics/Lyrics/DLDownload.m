//
//  DLDownload.m
//  Desktop Lyrics
//
//  Created by subo on 7/13/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import "DLDownload.h"

#define kTHDownLoadTask_TempSuffix  @".TempDownload"

@interface DLDownload ()

@property (nonatomic,copy) NSString *destPath;
@property (nonatomic,copy) NSString *tempPath;

@end

@implementation DLDownload

@synthesize downloadURL = _downloadURL;
@synthesize fileName    = _fileName;
@synthesize savePath    = _savePath;
@synthesize fileSize    = _fileSize;
@synthesize delegate    = _delegate;

@synthesize destPath = _destPath;
@synthesize tempPath = _tempPath;

- (id)initWithDownloadURL:(NSURL *)aURL {
    if (self = [super init]) {
        self.downloadURL = aURL;
    }
    
    return self;
}

- (void)dealloc {
    [_downloadURL release];
    [_fileName release];
    [_savePath release];
    [_destPath release];
    [_tempPath release];
    if (_urlConnection) {
        [_urlConnection cancel];
        SafeReleaseObj(_urlConnection);
    }
    
    if (_fileHandle) {
        [_fileHandle closeFile];
        SafeReleaseObj(_fileHandle);
    }
    
    [super dealloc];
}

- (void)start {
    if(!_downloadURL) {
        if(_delegate && [_delegate respondsToSelector:@selector(downloadDidFaild:didFailWithError:)]) {
            NSError *error = [NSError errorWithDomain:@"URL can't be nil." code:kERInvalidURL userInfo:nil];
            [_delegate downloadDidFaild:self didFailWithError:error];
            return;
        }
    }
    
    if(!_fileName) {
        NSString *urlStr = [_downloadURL absoluteString];
        self.fileName = [urlStr lastPathComponent];
        if ([_fileName length] > 255)
            self.fileName = [_fileName substringFromIndex:[_fileName length] - 255];
    }
    
    if (!_savePath) {
        NSArray  *downloadPaths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
        NSString *downloadDir = [downloadPaths objectAtIndex:0];
        self.savePath = downloadDir;
    }
    
    //目标地址与缓存地址
    self.destPath = [_savePath stringByAppendingPathComponent:_fileName];
    self.tempPath = [_destPath stringByAppendingString:kTHDownLoadTask_TempSuffix];
    
    //处理如果文件已经存在的情况
    if ([[NSFileManager defaultManager] fileExistsAtPath:_destPath])
    {
        if (_delegate && [_delegate shouldOverwriteExistFile:_destPath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:_destPath error:nil];
        }else
        {
            if ([_delegate respondsToSelector:@selector(downloadProgressDidChange:progress:)])
                [_delegate downloadProgressDidChange:self progress:100];
            
            if ([_delegate respondsToSelector:@selector(downloadFinished:)])
                [_delegate downloadDidFinished:self];
            return;
        }
    }
    
    //缓存文件不存在，则创建缓存文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:_tempPath])
    {
        BOOL createSucces = [[NSFileManager defaultManager] createFileAtPath:_tempPath contents:nil attributes:nil];
        if (!createSucces)
        {
            if ([_delegate respondsToSelector:@selector(downloadDidFaild:didFailWithError:)])
            {
                NSError *error = [NSError errorWithDomain:@"Temporary File can't be create!" code:kERCannotCreateTempFile userInfo:nil];
                [_delegate downloadDidFaild:self didFailWithError:error];
            }
            return;
        }
    }
    
    [_fileHandle closeFile];
    [_fileHandle release];  _fileHandle = nil;
    _fileHandle = [[NSFileHandle fileHandleForWritingAtPath:_tempPath] retain];
    //续传位置
    _offset = [_fileHandle seekToEndOfFile];
    NSString *range = [NSString stringWithFormat:@"bytes=%llu-",_offset];
    
    //设置下载的一些属性
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_downloadURL];
    [request addValue:range forHTTPHeaderField:@"Range"];
    [_urlConnection cancel];
    [_urlConnection release]; _urlConnection = nil;
    _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    [request release];
}

- (void)stop {
    [_urlConnection cancel];
    [_urlConnection release];
    _urlConnection = nil;
    [_fileHandle closeFile];
    [_fileHandle release];
    _fileHandle = nil;
}

- (NSString *)description {
    return [_downloadURL absoluteString];
}

#pragma mark -
#pragma mark ......:::::: NSURLConnectionDelegate :::::::......

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response expectedContentLength] > 0)
        _fileSize = (unsigned long long)[response expectedContentLength] + _offset;
        
        
        if ([_delegate respondsToSelector:@selector(downloadDidStart:didReceiveResponseHeaders:)])
        {
            [_delegate downloadDidStart:self didReceiveResponseHeaders:response];
        }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)aData
{
    [_fileHandle writeData:aData];
    _offset = [_fileHandle offsetInFile];
    
    if ([_delegate respondsToSelector:@selector(downloadProgressDidChange:progress:)])
    {
        float progress = _offset * 100.0 / _fileSize;
        [_delegate downloadProgressDidChange:self progress:progress];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_fileHandle closeFile];
    if ([_delegate respondsToSelector:@selector(downloadDidFaild:didFailWithError:)])
    {
		[_delegate downloadDidFaild:self didFailWithError:error];
	}
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_fileHandle closeFile];
    [[NSFileManager defaultManager] moveItemAtPath:_tempPath toPath:_destPath error:nil];
	if ([_delegate respondsToSelector:@selector(downloadDidFinished:)])
    {
		[_delegate downloadDidFinished:self];
	}
}

@end
