//
//  DLLyricsView.h
//  Desktop Lyrics
//
//  Created by subo on 7/8/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "VOutTextRender.h"

@interface DLLyricsView : NSView {
    NSColor         *_lyricForegroundColor;
    NSColor         *_lyricKoroOKColor;
    
    CIFilter *_transition;
    CIContext *_context;
    
    CIImage *_sourceImage;
    CIImage *_targetImage;
    
    NSString *_lyricString;
    VOutTextRender *_textRender;
    NSTimer *_timer;
    
    //下面这两个变量用于歌词同步
    int _showedCount;                       //一句歌词已显示次数
    int _showTotalCount;                    //一句歌词一共要显示的次数
    
    CIFilter  *_crop;
    CFTimeInterval _startShowLyricsInterval;
    
    float inputTime_;
}

@property (retain) NSColor *lyricForegroundColor;       //歌词字体颜色
@property (retain) NSColor *lyricKoroOKColor;           //歌词卡拉OK字体颜色
@property (nonatomic,retain) NSString *lyricString;

- (void)setFontName:(NSString *)fontName;
- (void)setFontSize:(int)size;

/**
 * @method
 * @abstract 显示一句歌词
 * @discussion 指定时间段内显示一句歌词
 * @param timeLength 时间间隔 单位为毫秒
 * @result void
 */
- (void)showLyric:(NSString *)lyric withTimeLength:(double)timeLength;

- (void)stopShowLyric;

- (void)pauseShowLyric;

- (void)resumeShowLyric;

@end
