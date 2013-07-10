//
//  LyricsView.m
//  iTunesControl
//
//  Created by bo su on 13-7-9.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import "LyricsView.h"
#import "NSColor+CGColor.h"

#define DefaultFontName @"Verdana"
#define DefaultFontSize 32

@implementation LyricsView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _attr = [[NSDictionary alloc] initWithObjectsAndKeys:[NSFont labelFontOfSize:38],NSFontNameAttribute, nil];
        [self setWantsLayer:YES];
        _lyricLayer = [[CATextLayer layer] retain];
        
        _lyricLayer.font = DefaultFontName;
        _lyricLayer.fontSize = DefaultFontSize;
        _lyricLayer.backgroundColor = [[NSColor clearColor] CGColor];
        _lyricLayer.shadowColor = [[NSColor clearColor] CGColor];
        _lyricLayer.shadowOffset = CGSizeMake(1, 1);
        _lyricLayer.shadowOpacity = 0.9;
        _lyricLayer.shadowRadius = 10;
        _lyricLayer.string = NULL;
        _lyricLayer.alignmentMode = kCAAlignmentCenter;
        
        self.lyricKoroOKColor = [NSColor orangeColor];
    }
    
    return self;
}

- (void)dealloc
{
    [_lyricLayer release];
    [_attr release];
    [_lyricKoroOKColor release];
    [_lyricForegroundColor release];
    [super dealloc];
}

- (void)awakeFromNib {
    [self.layer addSublayer:_lyricLayer];
    _lyricLayer.frame = self.layer.frame;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (!_lyricString) {
        return;
    }
}

@dynamic lyricForegroundColor;

- (NSColor *)lyricForegroundColor {
    return _lyricForegroundColor;
}

- (void)setLyricForegroundColor:(NSColor *)aColor {
    [aColor retain];
    [_lyricForegroundColor release];
    _lyricForegroundColor = aColor;
    
    
}

@dynamic lyricKoroOKColor;
- (NSColor *)lyricKoroOKColor {
    return _lyricKoroOKColor;
}

- (void)setLyricKoroOKColor:(NSColor *)aColor {
    [aColor retain];
    [_lyricKoroOKColor release];
    _lyricKoroOKColor = aColor;
}

@dynamic lyricString;
- (NSString *)lyricString {
    return _lyricString;
}

- (void)setLyricString:(NSString *)lyricString {
    [lyricString retain];
    [_lyricString release];
    _lyricString = lyricString;
    
    _lyricLayer.string = lyricString;
    
    int len = [lyricString length];
    
    if (mutaString) {
        [mutaString release];
        mutaString = nil;
    }
    
    if (mutaString==NULL) {
        mutaString = [[NSMutableAttributedString alloc] initWithString:lyricString];
    }

    [mutaString addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, len)];
    [mutaString addAttribute:NSLigatureAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, len)];
    [mutaString addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithInt:-3] range:NSMakeRange(0, len)];
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)_lyricLayer.font, 
                                             _lyricLayer.fontSize,
                                             NULL);
    [mutaString addAttribute:(NSString *)(kCTFontAttributeName) 
                       value:(id)fontRef 
                       range:NSMakeRange(0, len)];
    CFRelease(fontRef);
    
    if ([_timer isValid]) {
        [_timer invalidate];
        [_timer release];
        _timer = nil;
    }
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"foregroundColor"];
//    [animation setFromValue:[NSColor whiteColor]];
//    [animation setToValue:[NSColor orangeColor]];
//    [animation setDuration:2];
//    [_lyricLayer addAnimation:animation forKey:@"foregroundColor"];
    
    if (_timer == nil) {
        location = 0;
        _timer = [[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(hilightcolortimer) userInfo:nil repeats:YES] retain];
    }
    
//	timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:0.01 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
//	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)hilightcolortimer
{
    if (location >= _lyricString.length) {
        if (_timer!=nil) {
            [_timer invalidate];
            _timer = nil;
        }
        return;
    }
    
    NSRange range = NSMakeRange(location, 1);
    NSString *hilightChar = [_lyricString substringWithRange:range];
    NSMutableAttributedString *hilightString = [[[NSMutableAttributedString alloc] initWithString:hilightChar] autorelease];
    [hilightString addAttribute:NSForegroundColorAttributeName
                          value:self.lyricKoroOKColor
                          range:NSMakeRange(0, 1)];
    [hilightString addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithInt:-3] range:NSMakeRange(0, 1)];
    CTFontRef ctFont2 = CTFontCreateWithName((CFStringRef)_lyricLayer.font, 
                                             _lyricLayer.fontSize,
                                             NULL);
    [hilightString addAttribute:(NSString *)(kCTFontAttributeName) 
                          value:(id)ctFont2 
                          range:NSMakeRange(0, 1)];
    
    CFRelease(ctFont2);
    
    [mutaString replaceCharactersInRange:range withAttributedString:hilightString];
    location++;
    _lyricLayer.string = NULL;
    _lyricLayer.string = mutaString;
}

- (void)showLyric:(NSString *)lyric withTimeLength:(double)timeLength {

}

-(void)timerFired:(NSTimer*)timer {
    [self setNeedsDisplay:YES];
}

@end
