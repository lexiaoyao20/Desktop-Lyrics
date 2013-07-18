//
//  DLLyricsStorage.m
//  Desktop Lyrics
//
//  Created by subo on 7/10/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import "DLLyricsStorage.h"
#import "DLDataDefine.h"


@interface DLLyricsStorage ()

- (NSString *)findLocalLyricWithTitle:(NSString *)title artist:(NSString *)artist ;


@end

@implementation DLLyricsStorage

/**
 * @method
 * @abstract 寻找本地的歌词文件
 * @discussion 根据歌曲信息来寻找本地匹配的歌词文件，先从歌曲文件路径去寻找歌词文件，没有找到的话再从歌词文件默认保存路径去找
 * @param track 歌曲信息
 * @result NSString 找到了返回歌词文件的位置，没有找到则返回 nil
 */
- (NSString *)findLocalLyricWithTrack:(iTunesTrack *)track {
    NSString *lyricPath = nil;
    iTunesFileTrack *fileTrack = [track get];
    NSString *trackPath = [[fileTrack location] path];
    
    if (trackPath) {
        NSString *fileName = [[trackPath lastPathComponent] stringByDeletingPathExtension];
        NSString *trackDir = [trackPath stringByDeletingLastPathComponent];
        lyricPath = [trackDir stringByAppendingPathComponent:
                    [NSString stringWithFormat:@"%@%@",fileName,LRCPATHEXTENSION]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:lyricPath]) {
            return lyricPath;
        }
    }
    
    return [self findLocalLyricWithTitle:[[track name] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] artist:[[track artist] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

#pragma mark -
#pragma mark .....:::::: Pirvate Method ::::::.....

//从歌词文件的默认保存路径寻找歌词文件
- (NSString *)findLocalLyricWithTitle:(NSString *)title artist:(NSString *)artist {
    NSString *lrcFileName = [NSString stringWithFormat:@"%@-%@%@", artist,title,LRCPATHEXTENSION];
    NSString *lyricSavePath = [[NSUserDefaults standardUserDefaults] objectForKey:kUDKLyricFileSavePath];
    NSString *lyricPath = [lyricSavePath stringByAppendingPathComponent:lrcFileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:lyricPath]) {
        return lyricPath;
    }
    
    return nil;
}

@end
