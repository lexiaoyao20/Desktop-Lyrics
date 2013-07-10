//
//  LyricsView.h
//  iTunesControl
//
//  Created by bo su on 13-7-9.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface LyricsView : NSView {
    NSString *_lyricString;
    NSDictionary *_attr;
    
    NSTimer *_timer;
    
    CATextLayer *_lyricLayer;
    NSInteger location;
    
    NSColor *_lyricForegroundColor;
    NSColor *_lyricKoroOKColor;
    
    NSMutableAttributedString *mutaString;
}

@property (retain) NSColor *lyricForegroundColor;
@property (retain) NSColor *lyricKoroOKColor;


- (void)setFontName:(NSString *)fontName;
- (void)setFontSize:(int)size;

@property (nonatomic,copy) NSString *lyricString;

- (void)showLyric:(NSString *)lyric withTimeLength:(double)timeLength;

@end
