//
//  LrcTokensPool.h
//  lrcParser
//
//  Created by zhili hu on 1/25/11.
//  Copyright 2011 zhili hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UniversalDetector;

@interface LrcTokensPool : NSObject {
	NSString *path_;
	NSMutableArray *lyricPool_;
	NSMutableDictionary *attributes_;
	UniversalDetector *detector_; 
}

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *artist;
@property (nonatomic, readonly) NSString *album;
@property (nonatomic, readonly) NSString *lrcauther;
@property (nonatomic, readonly) NSArray *lyrics;
@property (nonatomic, readonly) int offset;

- (id)initWithFilePath:(NSString *)path;
- (BOOL)parseLyrics;
- (NSString*)getLyricsByTime:(int)trackTime;
- (NSString*)getLyricsByTime:(int)trackTime lyricsID:(NSUInteger *)lyid;
- (id)initWithFilePathAndParseLyrics:(NSString *)path;
- (NSString*)getLyricsByID:(int)lyid;

- (BOOL)isLRCDidParsed:(NSString *)lrcPath;

- (void)clearTokensPool;

/**
 * @method
 * @abstract 计算当前显示的歌词与下一句要显示的歌词的时间间隔
 * @param NSUInteger 歌词ID  fileDuration: 文件总时长
 * @result int 返回两者时间间隔
 */
- (int)timeDifferenceByID:(NSUInteger)lyid duration:(int)fileDuration;

@end
