//
//  NSColor+CGColor.m
//  iTunesControl
//
//  Created by bo su on 13-7-9.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import "NSColor+CGColor.h"

@implementation NSColor (CGColor)

+ (NSColor *)colorWithCGColor:(CGColorRef)aColorRef {
    if (aColorRef == NULL) {
        return nil;
    }
    
    return [NSColor colorWithCIColor:[CIColor colorWithCGColor:aColorRef]];
}

- (CGColorRef)CGColor {
    const NSInteger numberOfComponents = [self numberOfComponents];
    CGFloat components[numberOfComponents];
    CGColorSpaceRef colorSpare = [[self colorSpace] CGColorSpace];
    
    [self getComponents:(CGFloat *)&components];
    
    return (CGColorRef)[(id)CGColorCreate(colorSpare, components) autorelease];
}

@end
