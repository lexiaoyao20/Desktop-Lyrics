//
//  DLLyricsStatusBar.h
//  Desktop Lyrics
//
//  Created by subo on 7/4/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLiTunesControl.h"
#import "DLLRCFetcher.h"

@class DLLyricsFloatWndController;
@class DLLyricsStorage;
@class LrcTokensPool;
@class DLAboutWindowController;
@class DLSearchWindowController;

@interface DLLyricsStatusBar : NSObject<DLiTunesControlObserver,NSMenuDelegate,LRCFetcherDelegate> {
    IBOutlet NSMenu *_appMenu;
    IBOutlet NSMenuItem *_playPauseMenuItem;
    
    NSStatusItem *_lyricsItem;
    DLiTunesControl *_iTunesControl;
    DLLyricsFloatWndController  *_lyricsFloatWndCtrl;
    DLAboutWindowController     *_aboutWndCtrl;
    DLLyricsStorage *_lyricsStorage;
    LrcTokensPool *_tokensPool;
    DLLRCFetcher *_lrcFetcher;
    DLSearchWindowController    *_searchWndCtrl;
    
    NSUInteger _prevLrcItemId;
}

- (id)initWithiTunesControl:(DLiTunesControl *)iTunesControl;

- (IBAction)togglePlayPause:(id)sender;

- (IBAction)playPrevious:(id)sender;

- (IBAction)playNext:(id)sender;

- (IBAction)quit:(id)sender;

- (IBAction)showOrHideFloatWindow:(id)sender;

- (IBAction)showAboutWindow:(id)sender;

- (IBAction)showSearchLyricsWindow:(id)sender;

- (IBAction)showSearchSongsWindow:(id)sender;

@end
