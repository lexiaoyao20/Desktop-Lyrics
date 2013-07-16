//
//  DLiTunesControlNotifier.m
//  iTunesControl
//
//  Created by bo su on 13-7-4.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import "DLiTunesControlNotifier.h"

@implementation DLiTunesControlNotifier

- (id)init
{
    self = [super init];
    if (self) {
        _observers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    SafeReleaseObj(_observers);
    [super dealloc];
}

/*!
 @method
 @abstract 添加iTunes播放观察者
 @discussion 观察者对象必须实现DLiTunesControlObserver协议,iTunes播放状态的改变通过协议返回给上层的对象
 @param observer 要添加的观察器
 @result void
 */
- (void)addiTunesObserver:(id<DLiTunesControlObserver>)observer {
    if (observer) {
        [_observers addObject:observer];
    }
}

/*!
 @method
 @abstract 移除iTunes播放观察者
 @discussion 外面添加进来的观察者在不用的时候必须手动从这里移除，否则可能出现内存泄露
 @param observer 要移除的观察器
 @result void
 */
- (void)removeiTunesObserver:(id<DLiTunesControlObserver>)observer {
    [_observers removeObject:observer];
}

//所有观察者的方法都这这里执行
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    for (id<DLiTunesControlObserver> observer in _observers) {
        if (observer && [observer respondsToSelector:[anInvocation selector]]) {
            [anInvocation invokeWithTarget:observer] ;
        }
    }
}

@end
