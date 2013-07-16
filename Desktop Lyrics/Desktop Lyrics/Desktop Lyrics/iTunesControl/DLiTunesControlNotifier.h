//
//  DLiTunesControlNotifier.h
//  iTunesControl
//
//  Created by bo su on 13-7-4.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLiTunesControlObserver.h"


@interface DLiTunesControlNotifier : NSObject<DLiTunesControlObserver> {
    NSMutableArray *_observers;         //观察者列表
}

/*!
 @method
 @abstract 添加iTunes播放观察者
 @discussion 观察者对象必须实现DLiTunesControlObserver协议,iTunes播放状态的改变通过协议返回给上层的对象
 @param observer 要添加的观察器
 @result void
 */
- (void)addiTunesObserver:(id<DLiTunesControlObserver>)observer ;

/*!
 @method
 @abstract 移除iTunes播放观察者
 @discussion 外面添加进来的观察者在不用的时候必须手动从这里移除，否则可能出现内存泄露
 @param observer 要移除的观察器
 @result void
 */
- (void)removeiTunesObserver:(id<DLiTunesControlObserver>)observer ;

@end
