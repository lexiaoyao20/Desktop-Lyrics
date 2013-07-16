//
//  DLiTunesControl.h
//  iTunesControl
//
//  Created by bo su on 13-7-4.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTunes.h"
#import "DLiTunesControlObserver.h"

@class DLiTunesControlNotifier;

@interface DLiTunesControl : NSObject {
    NewiTunesApplication            *_iTunes;
    DLiTunesControlNotifier         *_notifier;
    NSString                        *_previousTrackFilePath;
    NSTimer                         *_checkPlayTimer;
}

@property (nonatomic,readonly) iTunesEPlS playerState;                  //iTunes 播放状态
@property (nonatomic,readonly) iTunesTrack *currentTrack;              //当前播放歌曲


- (BOOL)isRunning;

/**
 * @method
 * @abstract 播放、暂停之间切换
 * @discussion 当前为播放状态，调用此方法会切换到暂停状态；若当前为暂停状态，调用此方法会切换到播放状态
 * @result void
 */
- (void)togglePlayPause;

- (void)stop;

- (void)playPrevious;

- (void)playNext;

/**
 * @method
 * @abstract 当前播放进度
 * @discussion 播放位置
 * @result double
 */
- (double)playProgress;

#pragma mark -
#pragma mark ......:::::: Observer Manager :::::::......

/*!
 @method
 @abstract 添加iTunes观察者
 @discussion 观察者对象必须实现DLiTunesControlObserver协议,iTunes的改变通过协议返回给上层的对象
 @param observer 要添加的观察器
 @result void
 */
- (void)addiTunesObserver:(id<DLiTunesControlObserver>)observer;

/*!
 @method
 @abstract 移除iTunes观察者
 @discussion 外面添加进来的观察者在不用的时候必须手动从这里移除，否则可能出现内存泄露
 @param observer 要移除的观察器
 @result void
 */
- (void)removeiTunesObserver:(id<DLiTunesControlObserver>)observer;

@end
