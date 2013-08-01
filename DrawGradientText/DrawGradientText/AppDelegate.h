//
//  AppDelegate.h
//  DrawGradientText
//
//  Created by subo on 7/30/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyGradientTextView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet MyGradientTextView *gradientTextView;
}

@property (assign) IBOutlet NSWindow *window;

@end
