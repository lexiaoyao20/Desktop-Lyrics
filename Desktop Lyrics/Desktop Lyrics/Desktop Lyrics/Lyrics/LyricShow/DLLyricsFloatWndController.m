//
//  DLLyricsFloatWndController.m
//  Desktop Lyrics
//
//  Created by subo on 7/4/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import "DLLyricsFloatWndController.h"
#import "DLiTunesControl.h"
#import "DLLyricsView.h"
#import "DLDataDefine.h"

@interface DLLyricsFloatWndController ()

- (void)showFloatWindow ;

@end

@implementation DLLyricsFloatWndController

- (id)initWithiTunesControl:(DLiTunesControl *)iTunesControl {
    self = [super initWithWindowNibName:@"FloatLyricWindow" owner:self];
    if (iTunesControl && self) {
        _iTunesControl = [iTunesControl retain];
        [_iTunesControl addiTunesObserver:self];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self initWindowSize];
}

- (void)setLyricsString:(NSString *)aString withTimeLength:(int)length {
    [_lyricsView showLyric:aString withTimeLength:length];
}

- (void)initWindowSize {
    NSScreen *mainScreen = [NSScreen mainScreen];
    float x = [mainScreen visibleFrame].size.width * 0.1;
    float y = [mainScreen visibleFrame].origin.y + 10;
    float width = [mainScreen visibleFrame].size.width * 0.8;
    NSRect frame = NSMakeRect(x, y, width, self.window.frame.size.height);
    [self.window setFrame:frame display:YES];
}

#pragma mark -
#pragma mark .....:::::: iTunes Observer ::::::.....

/**
 * @method
 * @abstract 开始播放
 * @discussion 首次播放或者歌曲切换开始播放
 * @result void
 */
- (void)iTunesTracksChanged:(iTunesTrack *)track {
    [_lyricsView stopShowLyric];
    [self showFloatWindow];
}

- (void)iTunesPlayDidPaused:(iTunesTrack *)track {
    [_lyricsView pauseShowLyric];
}

- (void)iTunesPlayDidResumed:(iTunesTrack *)track {
    [self showFloatWindow];
    [_lyricsView resumeShowLyric];
}

- (void)iTunesPlayDidStoped {
    [_lyricsView stopShowLyric];
}

- (void)iTunesTrack:(iTunesTrack *)track didChangedProgress:(double)progress {
    [self showFloatWindow];
}

- (void)iTunesDidQuit {
    [_lyricsView stopShowLyric];
}

- (void)showFloatWindow {
    BOOL canShowFloatWindow = [[NSUserDefaults standardUserDefaults] boolForKey:kUDKShowFloatWindow];
    if (![self.window isVisible] && canShowFloatWindow) {
        [self.window orderFront:nil];
    }
}

@end
