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

@protocol BaiDuAPIXMLParseDelegate ;

@interface DLBaiduAPIXMLParseOperation : NSOperation {
    id<BaiDuAPIXMLParseDelegate> _delegate;
    NSURL *_requestURL;
    
    NSInteger  _lrcCount;
    NSMutableArray *_lrcsURLList;
    NSMutableArray *_songsURLList;
}

@property (nonatomic,assign) id<BaiDuAPIXMLParseDelegate> delegate;
@property (nonatomic,retain) NSURL *requestURL;
@property (nonatomic,readonly) NSArray *lrcsURLList;
@property (nonatomic,readonly) NSMutableArray *songsURLList;

- (id)initWithRequestURL:(NSURL *)url;

@end

@protocol BaiDuAPIXMLParseDelegate <NSObject>

- (void)baiduXMLParseDidFinished:(DLBaiduAPIXMLParseOperation *)sender error:(NSError *)error;

@end

extern NSString const * DLBaiDuAPIXMLParseDidFinishNotification;