//
//  AppDelegate.m
//  DrawGradientText
//
//  Created by subo on 7/30/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [gradientTextView setContent:@"富士山下"];
}

@end
