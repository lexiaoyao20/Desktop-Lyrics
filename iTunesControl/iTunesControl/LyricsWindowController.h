//
//  LyricsWindowController.h
//  iTunesControl
//
//  Created by bo su on 13-7-9.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DLiTunesControlObserver.h"

@class DLiTunesManager;
@class LyricsView;

@interface LyricsWindowController : NSWindowController<DLiTunesControlObserver> {
    IBOutlet LyricsView *lyricView;
}

- (id)initWithiTunesManager:(DLiTunesManager *)iTunesManager;

- (void)setLyricString:(NSString *)lyric;

@end
