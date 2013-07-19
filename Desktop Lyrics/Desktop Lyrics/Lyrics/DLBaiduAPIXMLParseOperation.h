//
//  DLBaiduAPIXMLParseOperation.h
//  Desktop Lyrics
//  
//  歌词下载地址与歌曲下载地址解析逻辑参见： http://www.cnblogs.com/huomiao/archive/2009/12/30/1635965.html
//
//  Created by subo on 7/12/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DLBaiduAPIXMLParseOperation : NSOperation {
    NSURL *_requestURL;
    
    NSInteger  _searchCount;
    NSMutableArray *_lrcsURLList;
    NSMutableArray *_songsURLList;
    NSString *_fileType;
}

@property (nonatomic,retain) NSURL *requestURL;
@property (nonatomic,readonly) NSArray *lrcsURLList;
@property (nonatomic,readonly) NSMutableArray *songsURLList;
@property (nonatomic,readonly) NSString *fileType;

- (id)initWithRequestURL:(NSURL *)url;

@end

extern NSString * DLBaiDuAPIXMLParseDidFinishNotification;

//Keys
extern NSString const * DLLRCURLListKey ;
extern NSString const * DLSongsURLListKey;
extern NSString const * DLErrorKey;
extern NSString const * DLSongFileTypeKey;

