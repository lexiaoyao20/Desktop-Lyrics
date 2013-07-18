//
//  DLBaiduAPIXMLParseOperation.m
//  Desktop Lyrics
//
//  Created by subo on 7/12/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import "DLBaiduAPIXMLParseOperation.h"
#import "DLDataDefine.h"

NSString const * DLBaiDuAPIXMLParseDidFinishNotification = @"BaiDuAPIXMLParseDidFinish";

@implementation DLBaiduAPIXMLParseOperation

@synthesize delegate = _delegate;
@synthesize requestURL = _requestURL;
@synthesize lrcsURLList = _lrcsURLList;
@synthesize songsURLList = _songsURLList;

- (id)initWithRequestURL:(NSURL *)url {
    self = [super init];
    if (self && url) {
        self.requestURL = url;
        _lrcCount = 0;
        _lrcsURLList = [[NSMutableArray alloc] init];
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
    
    [super dealloc];
}

- (void)main {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSError *error = nil;
    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:_requestURL options:NSDataReadingMappedIfSafe error:&error];
    if (error) {
        [self endParseWithError:error];
    }
    
    if (!xmlDoc || ![xmlDoc rootElement]) {
        error = [NSError errorWithDomain:DLXMLParseErrorDomain code:DataIsNil userInfo:nil] ;
        [self endParseWithError:error];
    }
    
    if (error == nil) {
        for(NSXMLElement *element in [[xmlDoc rootElement] children]) {
            if ([self isCancelled]) {
                break;
            }
            
            if ([[element name] isEqualToString:@"url"]) {
                NSXMLElement *lycidElement = [[element elementsForName:@"lrcid"] objectAtIndex:0];
                if (!lycidElement) {
                    continue;
                }
                
                long lycid = [[lycidElement stringValue] longLongValue];
                
                if (lycid == 0) {
                    continue;
                }
                
                long lycDir = lycid / 100;
                NSString *lrcLocation = [NSString stringWithFormat:@"%@/%ld/%ld.lrc",kLRCDownloadPrefix,lycDir,lycid];
                NSString *encodeString = [lrcLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                if (!encodeString) {
                    continue;
                }
                
                NSURL *lrcURL = [NSURL URLWithString:encodeString];
                if (lrcURL) {
                    [_lrcsURLList addObject:lrcURL];
                }
                
                //解析歌曲下载地址
                [self parseSongWithXMLElement:element];
            }
    }
        
        if ([_lrcsURLList count] == 0) {
            NSError *error = [NSError errorWithDomain:DLXMLParseErrorDomain code:CannotFindLRC userInfo:nil] ;
            [self endParseWithError:error];
        }
        else {
            [self endParseWithError:nil];
        }
    }
    [xmlDoc release];
    [pool release];
}

- (void)parseSongWithXMLElement:(NSXMLElement *)element {
    NSArray *encodeArray = [element elementsForName:@"encode"];
    NSArray *decodeArray = [element elementsForName:@"decode"];
    
    if (!encodeArray || decodeArray) {
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
        
        NSString *temp = [encodeSong substringToIndex:range.location - 1];
        
        NSString *songLocation = [temp stringByAppendingString:decondeSong];
        NSURL *songURL = [NSURL URLWithString:[songLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if (songURL) {
            [_songsURLList addObject:songURL];
        }
    }
}

- (void)endParseWithError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(baiduXMLParseDidFinished:error:)]) {
        [_delegate baiduXMLParseDidFinished:self error:error];
    }
}

@end
