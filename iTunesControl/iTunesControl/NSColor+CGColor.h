//
//  NSColor+CGColor.h
//  iTunesControl
//
//  Created by bo su on 13-7-9.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (CGColor)

+ (NSColor *)colorWithCGColor:(CGColorRef)aColorRef;

- (CGColorRef)CGColor ;

@end
