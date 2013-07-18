//
//  DLAboutWindowController.m
//  Desktop Lyrics
//
//  Created by subo on 7/16/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import "DLAboutWindowController.h"
#import "DLBackgroundView.h"

@interface DLAboutWindowController ()

@end

@implementation DLAboutWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"About" owner:self];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    //清新绿
    NSArray *colorArray = [NSArray arrayWithObjects:[NSColor colorWithDeviceRed:163/255.0 green:217/255.0 blue:91/255.0 alpha:1.0],
                           [NSColor colorWithDeviceRed:156/255.0 green:232/255.0 blue:16/255.0 alpha:1],
                           [NSColor colorWithDeviceRed:182/255.0 green:224/255.0 blue:158/255.0 alpha:1.0],nil];
    [_backgroundView setGradientColorArray:colorArray];
}

@end
