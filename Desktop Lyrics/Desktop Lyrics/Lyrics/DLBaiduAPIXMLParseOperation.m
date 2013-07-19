//
//  DLBaiduAPIXMLParseOperation.m
//  Desktop Lyrics
//
//  Created by subo on 7/12/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import "DLBaiduAPIXMLParseOperation.h"
#import "DLDataDefine.h"

NSString * DLBaiDuAPIXMLParseDidFinishNotification = @"BaiDuAPIXMLParseDidFinish";
NSString const * DLLRCURLListKey = @"LRCURLListKey";
NSString const * DLSongsURLListKey = @"SongsURLListKey";
NSString const * DLErrorKey = @"ErrorKey";
NSString const * DLSongFileTypeKey = @"SongFileTypeKey";


@interface DLBaiduAPIXMLParseOperation ()

//解析歌词下载地址
- (void)parseLyricsWithXMLElement:(NSXMLElement *)element;

//解析歌曲下载地址
- (void)parseSongWithXMLElement:(NSXMLElement *)element ;

- (void)setFileType:(NSString *)aType;

@end

@implementation DLBaiduAPIXMLParseOperation


@synthesize requestURL = _requestURL;
@synthesize lrcsURLList = _lrcsURLList;
@synthesize songsURLList = _songsURLList;
@synthesize fileType = _fileType;

- (id)initWithRequestURL:(NSURL *)url {
    self = [super init];
    if (self && url) {
        self.requestURL = url;
        _searchCount = 0;
        _lrcsURLList = [[NSMutableArray alloc] init];
        _songsURLList = [[NSMutableArray alloc] init];
    }
    else {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)dealloc
{
    [_lrcsURLList release];
    [_requestURL release];
    [_songsURLList release];
    [_fileType release];
    
    [super dealloc];
}

- (void)main {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSError *error = nil;
    NSDictionary *userInfo = nil;
    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:_requestURL options:NSDataReadingMappedIfSafe error:&error];
    
    if (error) {
        userInfo = [NSDictionary dictionaryWithObject:error forKey:DLErrorKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:DLBaiDuAPIXMLParseDidFinishNotification
                                                            object:self
                                                          userInfo:userInfo];
    }
    
    if (!xmlDoc || ![xmlDoc rootElement]) {
        error = [NSError errorWithDomain:DLXMLParseErrorDomain code:DataIsNil userInfo:nil] ;
        userInfo = [NSDictionary dictionaryWithObject:error forKey:DLErrorKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:DLBaiDuAPIXMLParseDidFinishNotification
                                                            object:self
                                                          userInfo:userInfo];
    }
    
    if (error == nil) {
        for(NSXMLElement *element in [[xmlDoc rootElement] children]) {
            if ([self isCancelled]) {
                break;
            }
            
            if ([[element name] isEqualToString:@"count"]) {
                _searchCount = [[element stringValue] intValue];
                if (_searchCount <= 0) {
                    error = [NSError errorWithDomain:DLXMLParseErrorDomain code:SearchFailed userInfo:nil] ;
                    userInfo = [NSDictionary dictionaryWithObject:error forKey:DLErrorKey];
                    [[NSNotificationCenter defaultCenter] postNotificationName:DLBaiDuAPIXMLParseDidFinishNotification
                                                                        object:self
                                                                      userInfo:userInfo];
                    break;
                }
            }
            else if ([[element name] isEqualToString:@"url"]) {
                //解析歌词下载地址
                [self parseLyricsWithXMLElement:element];
                
                //解析歌曲下载地址
                [self parseSongWithXMLElement:element];
            }
            else if ([[element name] isEqualToString:@"p2p"]) {
                NSArray *typeList = [element elementsForName:@"type"];
                if (typeList && [typeList count] > 0) {
                    [self setFileType:[NSString stringWithFormat:@".%@",[[typeList objectAtIndex:0] stringValue]]];
                }
            }
        }
        
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:_lrcsURLList,DLLRCURLListKey,
                    _songsURLList,DLSongsURLListKey, 
                    _fileType,DLSongFileTypeKey,nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:DLBaiDuAPIXMLParseDidFinishNotification
                                                            object:self
                                                          userInfo:userInfo];
    }
    [xmlDoc release];
    [pool release];
}

#pragma mark -
#pragma mark ......:::::: Private Method :::::::......

- (void)parseLyricsWithXMLElement:(NSXMLElement *)element {
    NSArray *lrcIDArray = [element elementsForName:@"lrcid"];
    if (!lrcIDArray || [lrcIDArray count] == 0) {
        return;
    }
    
    NSXMLElement *lycidElement = [lrcIDArray objectAtIndex:0];
    if (!lycidElement) {
        return;
    }
    
    long lycid = (long)[[lycidElement stringValue] longLongValue];
    
    if (lycid == 0) {
        return;
    }
    
    long lycDir = lycid / 100;
    NSString *lrcLocation = [NSString stringWithFormat:@"%@/%ld/%ld.lrc",kLRCDownloadPrefix,lycDir,lycid];
    NSString *encodeString = [lrcLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (!encodeString) {
        return;
    }
    
    NSURL *lrcURL = [NSURL URLWithString:encodeString];
    if (lrcURL) {
        [_lrcsURLList addObject:lrcURL];
    }
}

- (void)parseSongWithXMLElement:(NSXMLElement *)element {
    NSArray *encodeArray = [element elementsForName:@"encode"];
    NSArray *decodeArray = [element elementsForName:@"decode"];
    
    if (!encodeArray || !decodeArray) {
        return;
    }
    
    NSXMLElement *encodeElement = [encodeArray objectAtIndex:0];
    NSXMLElement *decodeElement = [decodeArray objectAtIndex:0];
    if (encodeElement && decodeElement) {
        NSString *encodeSong = [encodeElement stringValue];
        NSString *decondeSong = [decodeElement stringValue];
        NSRange range = [encodeSong rangeOfString:@"/" options:NSBackwardsSearch];
        
        if (range.location == NSNotFound || range.location < 1) {
            return;
        }
        
        NSString *temp = [encodeSong substringToIndex:range.location + 1];
        
        NSString *songLocation = [temp stringByAppendingString:decondeSong];
        NSURL *songURL = [NSURL URLWithString:[songLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if (songURL) {
            [_songsURLList addObject:songURL];
        }
    }
}

- (void)setFileType:(NSString *)aType {
    [aType retain];
    [_fileType release];
    _fileType = aType;
}

@end
