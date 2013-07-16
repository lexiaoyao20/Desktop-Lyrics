//
//  DLLyricsFloatWindow.m
//  Desktop Lyrics
//
//  Created by subo on 7/3/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import "DLLyricsFloatWindow.h"

@implementation DLLyricsFloatWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag {
    self = [super initWithContentRect:contentRect
							styleMask:NSBorderlessWindowMask
							  backing:bufferingType
								defer:flag];
    if (self) {
        [self setBackgroundColor:[NSColor clearColor]];
        [self setOpaque:NO];
        [self setHasShadow:NO];
        [self setHidesOnDeactivate:NO];
        [self setCollectionBehavior:NSWindowCollectionBehaviorManaged];
        [self setLevel:NSFloatingWindowLevel];
        [self setIgnoresMouseEvents:YES];
    }
    
    return self;
}

- (BOOL)canBecomeKeyWindow {
    return NO;
}

@end
