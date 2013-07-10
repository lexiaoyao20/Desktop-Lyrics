//
//  DLiTunesManager.m
//  iTunesControl
//
//  Created by bo su on 13-7-4.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import "DLiTunesManager.h"
#import "DLiTunesControlNotifier.h"

#define TIMEOUT 10

@interface DLiTunesManager ()

@property (nonatomic,retain) iTunesTrack *iTunesCurrentTrack;

@end

@implementation DLiTunesManager

@synthesize iTunesCurrentTrack;

#pragma mark -
#pragma mark ......:::::: 单件 :::::::......
static DLiTunesManager *shareInstance;

static NSString *iTunesPlayInfoNotification = @"com.apple.iTunes.playerInfo";

+ (DLiTunesManager *)defaultManager {
    if (shareInstance == nil) {
        shareInstance = [[super allocWithZone:NULL] init];
    }
    
    return shareInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self defaultManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax; //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease {
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _iTunes = [[SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"] retain];
        [_iTunes setTimeout:TIMEOUT];
        _notifier = [[DLiTunesControlNotifier alloc] init];
        self.iTunesCurrentTrack = nil;

        [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                                   selector:@selector(iTunesPlayInfoChanged:) 
                                                                       name:iTunesPlayInfoNotification 
                                                                     object:nil];
    }
    return self;
}

- (void)dealloc
{
    SafeReleaseObj(_iTunes);
    SafeReleaseObj(_notifier);
    SafeReleaseObj(_iTunesCurrentTrack);
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark -
#pragma mark ......:::::: iTunes Control :::::::......

- (BOOL)isRunning {
    return [_iTunes isRunning];
}

/**
 * @method
 * @abstract 播放、暂停之间切换
 * @discussion 当前为播放状态，调用此方法会切换到暂停状态；若当前为暂停状态，调用此方法会切换到播放状态
 * @result void
 */
- (void)togglePlayPause {
    if ([_iTunes isRunning]) {
        [_iTunes playpause];
    }
}

- (void)stop {
    if ([_iTunes isRunning]) {
        [_iTunes stop];
    }
}

- (void)playPrevious {
    if ([_iTunes isRunning]) {
        [_iTunes backTrack];
    }
}

- (void)playNext {
    if ([_iTunes isRunning]) {
        [_iTunes nextTrack];
    }
}

/**
 * @method
 * @abstract 当前播放进度
 * @discussion 播放位置
 * @result void
 */
- (double)playProgress {
    return [_iTunes playerPosition];
}

@dynamic playerState;
- (iTunesEPlS)playerState {
    return [_iTunes playerState];
}

#pragma mark -
#pragma mark ......:::::: Observer Manager :::::::......

/*!
 @method
 @abstract 添加iTunes观察者
 @discussion 观察者对象必须实现DLiTunesControlObserver协议,iTunes的改变通过协议返回给上层的对象
 @param observer 要添加的观察器
 @result void
 */
- (void)addiTunesObserver:(id<DLiTunesControlObserver>)observer {
    [_notifier addiTunesObserver:observer];
}

/*!
 @method
 @abstract 移除iTunes观察者
 @discussion 外面添加进来的观察者在不用的时候必须手动从这里移除，否则可能出现内存泄露
 @param observer 要移除的观察器
 @result void
 */
- (void)removeiTunesObserver:(id<DLiTunesControlObserver>)observer {
    [_notifier removeiTunesObserver:observer];
}

#pragma mark -
#pragma mark ......:::::: Track Info :::::::......

@dynamic currentTrack;
- (iTunesTrack *)currentTrack {
    return [_iTunes currentTrack];
}
            
#pragma mark -
#pragma mark ......:::::: iTunes PlayInfo Notification :::::::......
//iTunes通知分发中心
- (void)iTunesPlayInfoChanged:(NSNotification *)notification {
    NSString *playState = [[notification userInfo] objectForKey:@"Player State"];
    
    if ([playState isEqualToString:@"Playing"]) {
        if (self.iTunesCurrentTrack == self.currentTrack) {
            NSLog(@"iTunesPlayDidResumed");
            [_notifier iTunesPlayDidResumed];
        }
        else {
            NSLog(@"iTunesPlayDidStarted");
            [_notifier iTunesPlayDidStarted];
            self.iTunesCurrentTrack = self.currentTrack;
        }
    }
    else if ([playState isEqualToString:@"Paused"]) {
        NSLog(@"iTunesPlayDidPaused");
        [_notifier iTunesPlayDidPaused];
    }
    else if ([playState isEqualToString:@"Stopped"]) {
        NSLog(@"iTunesPlayDidStoped");
        [_notifier iTunesPlayDidStoped];
    }
}
@end
