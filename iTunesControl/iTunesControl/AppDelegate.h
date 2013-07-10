//
//  AppDelegate.h
//  iTunesControl
//
//  Created by subo on 3/7/13.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iTunes.h"
#import "DLiTunesManager.h"
#import "LyricsWindowController.h"
#import "LrcTokensPool.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,DLiTunesControlObserver> {
    IBOutlet NSButton *playBtn_;
    iTunesApplication *iTunes;
    DLiTunesManager *iTunesManager;
    LyricsWindowController *lyricWndCtrl;
    LrcTokensPool   *lrcTokensPool;
    
    NSMutableArray *lyrics;
    NSString *lyricPath;
    
    NSTimer *lrcTimer;
    
    NSUInteger prevLrcItemId;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)pause:(id)sender;

- (IBAction)playPrevious:(id)sender;

- (IBAction)playNext:(id)sender;

@end
