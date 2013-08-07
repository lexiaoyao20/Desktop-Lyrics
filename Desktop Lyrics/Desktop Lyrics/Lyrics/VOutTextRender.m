//
//  VOutTextRender.m
//  PlayerView
//
//  Created by ws ws on 5/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "VOutTextRender.h"
#import "NSImage+Gradient.h"

NSString const * GradientColorKey = @"GradientColor";

@implementation VOutTextRender

@synthesize gradientColorArray = _gradientColorArray;

- (id)init {
    self = [super init];
    
    if (self) {
        _textStorage = nil;
        _textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(NSIntegerMax, NSIntegerMax)];
        _layoutManager = [[NSLayoutManager alloc] init];
        
        [_layoutManager setHyphenationFactor:0.0] ;
        [_layoutManager setUsesScreenFonts:NO];
        
        [_layoutManager addTextContainer:_textContainer];
        
        [self initDefaultAttributes];
    }
    return self;
}

- (void)dealloc {
    [_textStorage release];
    _textStorage = nil;
    
    [_textContainer release];
    _textContainer = nil;
    
    [_layoutManager release];
    _layoutManager = nil;
    
    [_textAttributeds release];
    _textAttributeds = nil;
    
    SafeReleaseObj(_gradientColorArray);
    
    [super dealloc];
}

- (void)initDefaultAttributes {
    if (_textAttributeds) {
        [_textAttributeds release];
        _textAttributeds = nil;
    }
    
    _textAttributeds = [[NSMutableDictionary alloc] init];
        //Lucida Grande
    [_textAttributeds setValue:[NSFont fontWithName:@"HelveticaNeue-Bold" size:48] forKey:NSFontAttributeName];
    [_textAttributeds setValue:[NSColor greenColor] forKey:NSForegroundColorAttributeName];
    [_textAttributeds setValue:[NSNumber numberWithFloat:-0.1] forKey:NSStrokeWidthAttributeName];//轮廓宽度
    [_textAttributeds setValue:[NSColor blackColor] forKey:NSStrokeColorAttributeName];//轮廓颜色
    
    NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowColor: [NSColor blackColor]];
	[shadow setShadowBlurRadius: 1.5];
	[shadow setShadowOffset: NSMakeSize( -1.5, 1.5)];
    [_textAttributeds setValue:shadow forKey:NSShadowAttributeName];
    SafeReleaseObj(shadow);
    
    NSMutableParagraphStyle* paraStyle = [[NSMutableParagraphStyle alloc] init];
	[paraStyle setAlignment:NSCenterTextAlignment];
	[paraStyle setLineBreakMode:NSLineBreakByWordWrapping];
	[_textAttributeds setValue:paraStyle forKey:NSParagraphStyleAttributeName];
    [paraStyle release];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && key) {
        [_textAttributeds setValue:value forKey:key];
    }
}

- (void)setGradientColorArrary:(NSColor *)colorArr {
    
}

- (void)updateTextContent:(NSString *)aString {
    
    if (!_textAttributeds) {
        [self initDefaultAttributes];
    }
    
    if (_textStorage) {
        [_textStorage release]; _textStorage = nil;
    }
    
    _textStorage = [[NSTextStorage alloc] initWithString:aString attributes:_textAttributeds];
}

- (NSSize)caculateRepSize {
    
    // force text layout
//    [_layoutManager glyphRangeForTextContainer:_textContainer];
//    
//	return NSIntegralRect([_layoutManager usedRectForTextContainer:_textContainer]).size;
    return [_content sizeWithAttributes:_textAttributeds];
}

- (NSBitmapImageRep *)createRep:(NSSize)repSize {
    
    NSBitmapImageRep * bitmapRep = nil;

    if (repSize.width > 0 && repSize.height > 0) {
        
        int pixelsWide = repSize.width, pixelsHigh = repSize.height; 
        CGContextRef ctx = NULL;
        
        bitmapRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes: nil  // Nil pointer makes the kit allocate the pixel buffer for us.
         pixelsWide: pixelsWide  // The compiler will convert these to integers, but I just wanted to  make it quite explicit
         pixelsHigh: pixelsHigh //
         bitsPerSample: 8
         samplesPerPixel: 4  // Four samples, that is: RGBA
         hasAlpha: YES
         isPlanar: NO  // The math can be simpler with planar images, but performance suffers..
         colorSpaceName: NSCalibratedRGBColorSpace  // A calibrated color space gets us ColorSync for free.
         bytesPerRow: pixelsWide * 4      // Passing zero means "you figure it out."
         bitsPerPixel: 32];  // This must agree with bitsPerSample and samplesPerPixel.;
        
        if (bitmapRep) {
            ctx = CGBitmapContextCreate([bitmapRep bitmapData], [bitmapRep size].width, [bitmapRep size].height, [bitmapRep bitsPerSample], [bitmapRep bytesPerRow], [[bitmapRep colorSpace] CGColorSpace], kCGImageAlphaPremultipliedLast);
        }
        
        if (ctx) {
            
            if (_gradientColorArray) {
                NSImage *colorImage = [NSImage gradientImageWithColors:_gradientColorArray imageSize:repSize];
                NSColor *foregroundColor = [NSColor colorWithPatternImage:colorImage];
                if (foregroundColor) {
                    [_textAttributeds setValue:foregroundColor forKey:NSForegroundColorAttributeName];
                }
            }
            
            NSGraphicsContext *nsGraphicsContext;
            nsGraphicsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx
                                                                           flipped:YES];
            [NSGraphicsContext saveGraphicsState];
            [NSGraphicsContext setCurrentContext:nsGraphicsContext];
            
            [nsGraphicsContext setShouldAntialias:YES];
            
//            NSRange glyphRange = [_layoutManager
//                                  glyphRangeForTextContainer:_textContainer];
//            
            NSAffineTransform *transform = [NSAffineTransform transform];
            [transform translateXBy:0 yBy:pixelsHigh];
            [transform scaleXBy:1.0 yBy:-1.0];
            [transform concat];
//            
//            [_layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:NSZeroPoint];
            [_content drawInRect:NSMakeRect(0, 0, pixelsWide, pixelsHigh) withAttributes:_textAttributeds];
                        
            [NSGraphicsContext restoreGraphicsState];            
        }
        
        if (ctx) {
            CGContextRelease(ctx); ctx = nil;
        }
    }
    
    return [bitmapRep autorelease];
}

- (NSBitmapImageRep *)render:(NSString *)context {
    [context retain];
    [_content release];
    _content = context;
    
    NSBitmapImageRep * image = nil;
    NSSize imageSize = NSZeroSize;
    
    @synchronized (@"VOutTextRender_Rendering") {
        
//        [self updateTextContent:context];
//        
//        [_textStorage addLayoutManager:_layoutManager];
        
        imageSize = [self caculateRepSize];
        
        image = [self createRep:imageSize];
    }
    
    return image ; 
}

@end
