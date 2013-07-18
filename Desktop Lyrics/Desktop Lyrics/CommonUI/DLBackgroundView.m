//
//  DLBackgroundView.m
//  Desktop Lyrics
//
//  Created by bo su on 13-7-18.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import "DLBackgroundView.h"
#import "NSImage+Gradient.h"

@implementation DLBackgroundView


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [_backgroundColor release];     _backgroundColor = nil;
    [_gradientColorArray release];  _gradientColorArray = nil;
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (_backgroundColor) {
        [_backgroundColor set];
        NSRectFill(self.bounds);
    }
}

@dynamic backgroundColor;

- (NSColor *)backgroundColor {
    return _backgroundColor;
}

- (void)setBackgroundColor:(NSColor *)aColor {
    [aColor retain];
    [_backgroundColor release];
    _backgroundColor = aColor;
    
    [self setNeedsDisplay:YES];
}

@dynamic gradientColorArray;

- (NSArray *)gradientColorArray {
    return _gradientColorArray;
}

- (void)setGradientColorArray:(NSArray *)colorArray {
    [colorArray retain];
    [_gradientColorArray release];
    _gradientColorArray = colorArray;
    
    NSImage *image = [NSImage gradientImageWithColors:_gradientColorArray imageSize:self.frame.size];
    if (image) {
        NSColor *gradientColor = [NSColor colorWithPatternImage:image];
        if (gradientColor) {
            [self setBackgroundColor:gradientColor];
        }
    }
}

@end
