//
//  AppDelegate.h
//  Desktop Lyrics
//
//  Created by subo on 7/2/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DLLyricsStatusBar.h"
#import "DLiTunesControl.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    DLLyricsStatusBar *_lyricsStatusBar;
    DLiTunesControl *_iTunesControl;
}


@end
