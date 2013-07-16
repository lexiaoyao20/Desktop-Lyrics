//
//  DLiTunesControlObserver.h
//  iTunesControl
//
//  Created by bo su on 13-7-4.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTunes.h"

@protocol DLiTunesControlObserver <NSObject>

@optional
/**
 * @method
 * @abstract 开始播放
 * @discussion 首次播放或者歌曲切换开始播放
 * @result void
 */
- (void)iTunesTracksChanged:(iTunesTrack *)track;

- (void)iTunesPlayDidPaused:(iTunesTrack *)track;

- (void)iTunesPlayDidResumed:(iTunesTrack *)track;

- (void)iTunesPlayDidStoped;

/**
 * @method
 * @abstract 播放进度改变通知
 * @discussion 每隔一定的时间返回一次当前播放进度
 * @param progress 当前播放进度
 * @param track 当前播放的文件
 * @result void
 */
- (void)iTunesTrack:(iTunesTrack *)track didChangedProgress:(double)progress;

/**
 * @method
 * @abstract iTunes已经退出
 * @result void
 */

- (void)iTunesDidQuit; 

@end
