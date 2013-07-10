//
//  LyricsWindowController.m
//  iTunesControl
//
//  Created by bo su on 13-7-9.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import "LyricsWindowController.h"
#import "DLiTunesManager.h"
#import "LyricsView.h"


@interface LyricsWindowController ()

@end

@implementation LyricsWindowController

- (id)initWithiTunesManager:(DLiTunesManager *)iTunesManager {
    self = [super initWithWindowNibName:@"LyricsWindow" owner:self];
    if ( iTunesManager && self) {
        [iTunesManager addiTunesObserver:self];
    }
    else {
        [self release]; self = nil;
    }
    
    return self;
}

- (void)setLyricString:(NSString *)lyric {
    [lyricView setLyricString:lyric];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

@end
