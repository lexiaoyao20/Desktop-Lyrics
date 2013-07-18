//
//  DLBackgroundView.h
//  Desktop Lyrics
//
//  Created by bo su on 13-7-18.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DLBackgroundView : NSView {
    NSColor *_backgroundColor;
    
    NSArray *_gradientColorArray;
}

@property (nonatomic,retain) NSColor *backgroundColor;
@property (nonatomic,retain) NSArray *gradientColorArray;

@end
