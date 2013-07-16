//
//  DLLyricsStatusBar.m
//  Desktop Lyrics
//
//  Created by subo on 7/4/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import "DLLyricsStatusBar.h"
#import "DLLyricsFloatWndController.h"
#import "DLLyricsStorage.h"
#import "LrcTokensPool.h"
#import "DLDataDefine.h"
#import "DLAboutWindowController.h"

@interface DLLyricsStatusBar ()

- (void)startParseLrcFile:(NSString *)lrcFilePath ;

@end

@implementation DLLyricsStatusBar

- (id)initWithiTunesControl:(DLiTunesControl *)iTunesControl {
    self = [super init];
    if (self && [NSBundle loadNibNamed:@"StatusBar" owner:self]) {
        _iTunesControl = [iTunesControl retain];
        [iTunesControl addiTunesObserver:self];
        _lyricsFloatWndCtrl = [[DLLyricsFloatWndController alloc] initWithiTunesControl:iTunesControl];
        _lyricsStorage = [[DLLyricsStorage alloc] init];
        _prevLrcItemId = -1;
    }
    else {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)dealloc
{
    SafeReleaseObj(_iTunesControl);
    SafeReleaseObj(_lyricsItem);
    SafeReleaseObj(_lyricsFloatWndCtrl);
    SafeReleaseObj(_lyricsStorage);
    SafeReleaseObj(_tokensPool);
    [super dealloc];
}

- (void)awakeFromNib {
    //添加一个StatusBar到系统的StatusBar
    NSStatusBar *systemStatuBbar = [NSStatusBar systemStatusBar];
    _lyricsItem = [[systemStatuBbar statusItemWithLength:NSVariableStatusItemLength] retain];
    [_lyricsItem setTitle:NSLocalizedString(@"Desktop Lyrics", @"")];
    [_lyricsItem setHighlightMode:YES];
    [_lyricsItem setMenu:_appMenu];
}

- (IBAction)togglePlayPause:(id)sender {
    [_iTunesControl togglePlayPause];
}

- (IBAction)playPrevious:(id)sender {
    [_iTunesControl playPrevious];
}

- (IBAction)playNext:(id)sender {
    [_iTunesControl playNext];
}

- (IBAction)quit:(id)sender {
    [NSApp terminate:self];
}

- (IBAction)showOrHideFloatWindow:(id)sender {
    
    if ([_lyricsFloatWndCtrl.window isVisible]) {
        [_lyricsFloatWndCtrl.window orderOut:nil];
        [sender setTitle:@"显示桌面歌词"];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUDKShowFloatWindow];
    }
    else {
        [_lyricsFloatWndCtrl.window orderFront:nil];
        [sender setTitle:@"隐藏桌面歌词"];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUDKShowFloatWindow];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)showAboutWindow:(id)sender {
    if (!_aboutWndCtrl) {
        _aboutWndCtrl = [[DLAboutWindowController alloc] init];
    }
    [_aboutWndCtrl.window makeKeyAndOrderFront:nil];
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
    if (_tokensPool) {
        [_tokensPool clearTokensPool];
    }
    _prevLrcItemId = -1;
    [_playPauseMenuItem setTitle:NSLocalizedString(@"暂停", @"暂停")];
    
    NSString *lyricPath = [_lyricsStorage findLocalLyricWithTrack:track];
    if (lyricPath) {
        [self startParseLrcFile:lyricPath];
    }
    else {  //在本地没有找到歌词文件，则自动去搜索下载...
        if (_lrcFetcher) {
            [_lrcFetcher stop];
            SafeReleaseObj(_lrcFetcher);
        }
        
        _lrcFetcher = [[DLLRCFetcher alloc] initWithArtist:track.artist title:track.name];
        [_lrcFetcher setDelegate:self];
        [_lrcFetcher start];
    }
}

- (void)iTunesPlayDidPaused:(iTunesTrack *)track {
    [_playPauseMenuItem setTitle:NSLocalizedString(@"播放", @"播放")];
}

- (void)iTunesPlayDidResumed:(iTunesTrack *)track {
    [_playPauseMenuItem setTitle:NSLocalizedString(@"暂停", @"暂停")];
}

- (void)iTunesPlayDidStoped {
    _prevLrcItemId = -1;
    [_playPauseMenuItem setTitle:NSLocalizedString(@"播放", @"播放")];
}

- (void)iTunesTrack:(iTunesTrack *)track didChangedProgress:(double)progress {
    NSString *lyricPath = [_lyricsStorage findLocalLyricWithTrack:track];
    if (lyricPath) {
        if (!_tokensPool || ![_tokensPool isLRCDidParsed:lyricPath]) {
            [self startParseLrcFile:lyricPath];
        }
    }
    else {  //在本地没有找到歌词文件，则自动去搜索下载...
        if (!_lrcFetcher) {
            _lrcFetcher = [[DLLRCFetcher alloc] initWithArtist:track.artist title:track.name];
            [_lrcFetcher setDelegate:self];
            [_lrcFetcher start];
        }
    }
    
    if (!_tokensPool || [[_tokensPool lyrics] count] == 0) {
        return;
    }
    
    NSUInteger currentLyricsId;
    NSString *lyric = [_tokensPool getLyricsByTime:(int)(progress * 1000) lyricsID: &currentLyricsId];

    if (_prevLrcItemId != currentLyricsId && currentLyricsId != NSNotFound) {
        _prevLrcItemId = currentLyricsId;
        
        int timeDiff = [_tokensPool timeDifferenceByID:currentLyricsId duration:(int)([track duration] * 1000)];
        NSLog(@"lyric:%@  timeDiff:%d",lyric,timeDiff);
        if (timeDiff != -1) {
            [_lyricsFloatWndCtrl setLyricsString:lyric withTimeLength:timeDiff];
        }
        else{
            [_lyricsFloatWndCtrl setLyricsString:@"" withTimeLength:1];
        }
    }
}

- (void)iTunesDidQuit {
    
}

#pragma mark -
#pragma mark .....:::::: Valid Menu ::::::.....

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    BOOL result = YES;
    SEL action = [menuItem action];
    if (action == @selector(togglePlayPause:) ||
        action == @selector(playPrevious:)    ||
        action == @selector(playNext:)) {
        result = [_iTunesControl isRunning];
    }
    else if (action == @selector(showOrHideFloatWindow:)) {
        result = [_iTunesControl isRunning] && ([_iTunesControl playerState] == iTunesEPlSPlaying || [_iTunesControl playerState] == iTunesEPlSPaused);
        BOOL canShowFloatWindow = [[NSUserDefaults standardUserDefaults] boolForKey:kUDKShowFloatWindow];
        if (canShowFloatWindow) {
            [menuItem setTitle:@"隐藏桌面歌词"];
        }
        else {
            [menuItem setTitle:@"显示桌面歌词"];
        }
    }
    
    return result;
}

#pragma mark -
#pragma mark .....:::::: implementation LRCFetcherDelegate ::::::.....

- (void)lrcFetcherDidFinished:(DLLRCFetcher *)sender error:(NSError *)error {
    if (error) {
        NSLog(@"Fetcher Error:%@",error);
        return;
    }
    
    NSString *lrcFilePath = [sender lrcFilePath];
    [self startParseLrcFile:lrcFilePath];
    SafeReleaseObj(_lrcFetcher);
}

#pragma mark -
#pragma mark .....:::::: Private Method ::::::.....

- (void)startParseLrcFile:(NSString *)lrcFilePath {
    NSAssert(lrcFilePath, @"lrcFilePath is nil");
    if (_tokensPool) {
        SafeReleaseObj(_tokensPool);
    }
    _tokensPool = [[LrcTokensPool alloc] initWithFilePathAndParseLyrics:lrcFilePath];
}

@end
