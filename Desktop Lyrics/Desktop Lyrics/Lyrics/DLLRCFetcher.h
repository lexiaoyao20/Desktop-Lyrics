//
//  DLLRCFetcher.h
//  Desktop Lyrics
//  歌词抓取
//  Created by subo on 7/12/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLBaiduAPIXMLParseOperation.h"
#import "DLDownload.h"

@protocol LRCFetcherDelegate;

@interface DLLRCFetcher : NSObject<BaiDuAPIXMLParseDelegate,DLDownloadDelegate> {
    NSOperationQueue *_operationQueue;
    NSString *_artist;
    NSString *_title;
    DLDownload *_download;
    id<LRCFetcherDelegate> _delegate;
    NSString *_lrcFilePath;
}

@property (nonatomic,assign) id<LRCFetcherDelegate> delegate;
@property (nonatomic,copy) NSString *artist;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,readonly) NSString *lrcFilePath;

- (id)initWithArtist:(NSString *)artist title:(NSString *)title;

- (void)start;
- (void)stop;

@end

@protocol LRCFetcherDelegate <NSObject>

- (void)lrcFetcherDidFinished:(DLLRCFetcher *)sender error:(NSError *)error;

@end
