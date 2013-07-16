//
//  DLLyricsView.m
//  Desktop Lyrics
//
//  Created by subo on 7/8/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import "DLLyricsView.h"
#import "NSColor+CGColor.h"

#define ShowLRCTimeInterval (1.0 / 30.0)
#define DefaultFontName @"Verdana"
#define DefaultFontSize 32

@implementation DLLyricsView

@synthesize lyricForegroundColor = _lyricForegroundColor;
@synthesize lyricKoroOKColor = _lyricKoroOKColor;
@synthesize lyricString = _lyricString;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setWantsLayer:YES];
        
        self.lyricKoroOKColor = [NSColor orangeColor];
        self.lyricForegroundColor = [NSColor greenColor];
        _textRender = [[VOutTextRender alloc] init];
        _showTotalCount = INT_MAX;
    }
    
    return self;
}

- (void)dealloc
{
    [_lyricKoroOKColor release];
    [_lyricForegroundColor release];
    if (_timer) {
        [_timer invalidate];
        SafeReleaseObj(_timer);
    }
    SafeReleaseObj(_lyricString);
    SafeReleaseObj(_context);
    [super dealloc];
}

- (void)drawRect:(NSRect)rectangle
{
    float   t;
    CGRect  cg = CGRectMake(NSMinX(rectangle), NSMinY(rectangle),
                            NSWidth(rectangle), NSHeight(rectangle));
 //   CFTimeInterval time = CFAbsoluteTimeGetCurrent() - _startShowLyricsInterval;

    t = (float)_showedCount / (float)_showTotalCount;
    ++_showedCount;
 
    if (t > 1) {
        return;
    }
    if(_context == nil)
    {
        _context = [CIContext contextWithCGContext:
                   [[NSGraphicsContext currentContext] graphicsPort]
                                          options: nil];
        [_context retain];
    }
    
    if(_transition == nil)
        [self setupTransition];
    
    //歌词居中显示
    CIImage *image = [self imageForTransition: t];
//    NSLog(@"image size:(%f,%f)",[image extent].size.width,[image extent].size.height);
    NSPoint drawPoint;
    drawPoint.x = (self.frame.size.width - [image extent].size.width) / 2;
    drawPoint.y = cg.origin.y;
    [_context drawImage: image
               atPoint: drawPoint
              fromRect: cg];
}

- (void)setSourceImage: (CIImage *)source
{
    [source retain];
    [_sourceImage release];
    _sourceImage = source;
}

- (void)setTargetImage: (CIImage *)target
{
    [target retain];
    [_targetImage release];
    _targetImage = target;
}

- (void)timerFired: (id)sender
{
//    [self setNeedsDisplay: YES];
    [self display];
}

- (void)stopShowLyric {
    [self pauseShowLyric];
    _showedCount = 1;
    [self showLyric:@"" withTimeLength:1];
}

- (void)pauseShowLyric {
    if ([_timer isValid]) {
        [_timer invalidate];
        SafeReleaseObj(_timer);
    }
}

- (void)resumeShowLyric {
    [self pauseShowLyric];
    [self startTimer];
}

- (void)startTimer {
    _timer = [[NSTimer alloc] initWithFireDate:[NSDate date]
                                      interval:ShowLRCTimeInterval
                                        target:self
                                      selector:@selector(timerFired:)
                                      userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer: _timer
                                 forMode: NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer: _timer
                                 forMode: NSEventTrackingRunLoopMode];
}

- (void)showLyric:(NSString *)lyric withTimeLength:(double)timeLength {
    if (lyric == nil) {
        lyric = @"";
    }
    [lyric retain];
    [_lyricString release];
    _lyricString = lyric;
    
    [_textRender setValue:self.lyricForegroundColor forKey:NSForegroundColorAttributeName];
    NSData *imageDate = [[_textRender render:_lyricString] TIFFRepresentation];
    CIImage *image = [[CIImage alloc] initWithData:imageDate];
    [self setSourceImage:image];
    SafeReleaseObj(image);
    
    [_textRender setValue:self.lyricKoroOKColor forKey:NSForegroundColorAttributeName];
    imageDate = [[_textRender render:_lyricString] TIFFRepresentation];
    image = [[CIImage alloc] initWithData:imageDate];
    [self setTargetImage:image];
    SafeReleaseObj(image);
    
    [_transition setValue: _sourceImage  forKey: @"inputImage"];
    [_transition setValue: _targetImage  forKey: @"inputTargetImage"];
    [self refreshInputExtent];
    
    if ([_timer isValid]) {
        [_timer invalidate];
        SafeReleaseObj(_timer);
    }
//    _startShowLyricsInterval = CFAbsoluteTimeGetCurrent();
    //如果timeLength=5，也就是说在5s内要显示完一句歌词，而刷新绘制的计时器的时间间隔是1/30s（即33毫秒）,就是1秒要刷新绘制33次，
    //那么5秒就要刷新 5 * 33 次
    _showTotalCount = (1.0 / (ShowLRCTimeInterval * 1000)) * timeLength;
    _showedCount = 1;
    [self startTimer];
}

#pragma mark -
#pragma mark .....:::::: 卡拉ok效果设置 ::::::.....

- (void)setupTransition
{
    if (_transition) {
        [_transition release];
        _transition = nil;
    }
    CIVector  *extent;
    float      w,h;
    
    w      = self.frame.size.width;
    h      = self.frame.size.height;
    
    extent = [CIVector vectorWithX: 0  Y: 0  Z: w  W: h];
    
    _transition  = [[CIFilter filterWithName: @"CISwipeTransition"] retain];
    [_transition setDefaults];
    NSArray		*filterKeys = [_transition inputKeys];
    NSDictionary	*filterAttributes = [_transition attributes];
    if(filterKeys)
    {
        NSEnumerator	*enumerator = [filterKeys objectEnumerator];
        NSString		*currentKey;
        NSDictionary	*currentInputAttributes;
        
        while(currentKey = [enumerator nextObject])
        {
            if([currentKey compare:@"inputExtent"] == NSOrderedSame)		    // set the rendering extent to the size of the thumbnail
                [_transition setValue:extent forKey:currentKey];
            else if ([currentKey compare:@"inputWidth"] == NSOrderedSame) {
                [_transition setValue:[NSNumber numberWithInt:1] forKey:currentKey];
            }
            else {
                currentInputAttributes = [filterAttributes objectForKey:currentKey];
                
                NSString		    *classType = [currentInputAttributes objectForKey:kCIAttributeClass];
                
                if([classType compare:@"CIImage"] == NSOrderedSame)
                {
                    if([currentKey compare:@"inputShadingImage"] == NSOrderedSame){	// if there is a shading image, use our shading image
                        
                    }
                    else if ([currentKey compare:@"inputBacksideImage"] == NSOrderedSame){	// this is for the page curl transition
                    }
                    else
                        [_transition setValue:_sourceImage forKey:currentKey];
                }
            }
        }
    }
}

//每传入新的字符串都得刷新下inputExtent，否则取图会不准
- (void)refreshInputExtent {
    CIVector  *extent;
    float      w,h;
    if (_sourceImage) {
        w      = [_sourceImage extent].size.width;
        h      = [_sourceImage extent].size.height;
    }
    else {
        w      = self.frame.size.width;
        h      = self.frame.size.height;
    }
    
    
    extent = [CIVector vectorWithX: 0  Y: 0  Z: w  W: h];
    [_transition setValue:extent forKey:@"inputExtent"];
}

- (CIImage *)imageForTransition: (float)t
{
    float inputTime = 0.5*(1-cos(fmodf(t, 1.0f) * M_PI));
    
    [_transition setValue: [NSNumber numberWithFloat:
                            inputTime]
                   forKey: @"inputTime"];
    
    _crop = [CIFilter filterWithName: @"CICrop"
                       keysAndValues: @"inputImage",
             [_transition valueForKey: @"outputImage"],
             @"inputRectangle", [CIVector vectorWithX: 0  Y: 0
                                                    Z: [_sourceImage extent].size.width
                                                    W: [_sourceImage extent].size.height],
             nil];
    return [_crop valueForKey: @"outputImage"];
}

@end
