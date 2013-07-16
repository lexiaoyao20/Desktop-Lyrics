//
//  DLLyricsStorage.h
//  Desktop Lyrics
//
//  Created by subo on 7/10/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTunes.h"

@interface DLLyricsStorage : NSObject

/**
 * @method
 * @abstract 寻找本地的歌词文件
 * @discussion 根据歌曲信息来寻找本地匹配的歌词文件
 * @param track 歌曲信息
 * @result NSString 找到了返回歌词文件的路径，没有找到则返回 nil
 */
- (NSString *)findLocalLyricWithTrack:(iTunesTrack *)track;

@end
