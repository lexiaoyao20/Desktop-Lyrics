//
//  DLBaiduAPIXMLParseOperation.h
//  Desktop Lyrics
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
}

@property (nonatomic,assign) id<BaiDuAPIXMLParseDelegate> delegate;
@property (nonatomic,retain) NSURL *requestURL;
@property (nonatomic,readonly) NSArray *lrcsURLList;

- (id)initWithRequestURL:(NSURL *)url;

@end

@protocol BaiDuAPIXMLParseDelegate <NSObject>

- (void)baiduXMLParseDidFinished:(DLBaiduAPIXMLParseOperation *)sender error:(NSError *)error;

@end