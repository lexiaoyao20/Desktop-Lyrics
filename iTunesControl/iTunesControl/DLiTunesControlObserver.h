//
//  DLiTunesControlObserver.h
//  iTunesControl
//
//  Created by bo su on 13-7-4.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLiTunesControlObserver <NSObject>

@optional
/**
 * @method
 * @abstract 开始播放
 * @discussion 首次播放或者歌曲切换开始播放
 * @result void
 */
- (void)iTunesPlayDidStarted;

/**
 * @method
 * @abstract <#这里可以写一些关于这个方法的一些简要描述#>
 * @discussion <#这里可以具体写写这个方法如何使用，注意点之类的。如果你是设计一个抽象类或者一个共通类给给其他类继承的话，建议在这里具体描述一下怎样使用这个方法 #>
 * @param text <#文字 (这里把这个方法需要的参数列出来)#>
 * @param error <#错误参照#>
 * @result <#返回结果#>
 */
- (void)iTunesPlayDidPaused;

- (void)iTunesPlayDidResumed;

- (void)iTunesPlayDidStoped;

@end
