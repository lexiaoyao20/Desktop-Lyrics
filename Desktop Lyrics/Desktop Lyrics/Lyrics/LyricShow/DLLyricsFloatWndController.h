//
//  DLLyricsFloatWndController.h
//  Desktop Lyrics
//
//  Created by subo on 7/4/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DLiTunesControlObserver.h"

@class DLLyricsView;
@class DLiTunesControl;

@interface DLLyricsFloatWndController : NSWindowController<DLiTunesControlObserver> {
    IBOutlet DLLyricsView *_lyricsView;
    
    DLiTunesControl *_iTunesControl;
}

- (id)initWithiTunesControl:(DLiTunesControl *)iTunesControl;

- (void)setLyricsString:(NSString *)aString withTimeLength:(int)length;

@end
