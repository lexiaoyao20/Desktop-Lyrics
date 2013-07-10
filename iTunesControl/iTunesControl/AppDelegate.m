//
//  AppDelegate.m
//  iTunesControl
//
//  Created by subo on 3/7/13.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import "AppDelegate.h"
#import "RegexKitLite.h"


@implementation AppDelegate

@synthesize window;

- (void)dealloc
{
    [super dealloc];
}

- (void)awakeFromNib {
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    iTunes = [[SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"] retain];
    lyrics = [[NSMutableArray alloc] init];

    iTunesManager = [DLiTunesManager defaultManager];
    [iTunesManager addiTunesObserver:self];
    
    lyricWndCtrl = [[LyricsWindowController alloc] initWithiTunesManager:iTunesManager];
    [lyricWndCtrl.window orderFront:nil];
    
    lyricPath = @"/Users/subo/Music/芊芊.lrc";
    lrcTokensPool = [[LrcTokensPool alloc] initWithFilePathAndParseLyrics:lyricPath];
    prevLrcItemId = -1;
    
 //   [NSThread detachNewThreadSelector:@selector(iTunesMonitoringThread) toTarget:self withObject:nil];
}

- (IBAction)pause:(id)sender {
    [iTunesManager togglePlayPause];
}

- (IBAction)playPrevious:(id)sender {
    [iTunesManager playPrevious];
}

- (IBAction)playNext:(id)sender {
    [iTunesManager playNext];
}

- (void)startLRCTimer {

	//[self stopLRCTimer];
	lrcTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(lrcRoller:) userInfo:nil repeats:YES];
	//[lrcTimer retain];
}


// Stop the timer; prevent future loads until startTimer is called again
- (void)stopLRCTimer {
    if (lrcTimer) {
        [lrcTimer invalidate];
        [lrcTimer release];
        lrcTimer = nil;
    }
}

- (void)iTunesMonitoringThread {
    while (![iTunesManager isRunning])
    {
        //if iTunes is not running, we should wait for it rather than launch it
        //once iTunes is launched, this loop will stop
        sleep(1);
    }
    unsigned long currentPlayerPosition = 0;
    unsigned long PlayerPosition = 0;   
    while (true) {
        @autoreleasepool {
            currentPlayerPosition += 100;
            usleep(100000); //1000微秒 = 1毫秒
            if (![iTunesManager isRunning])
            {
                [[NSApplication sharedApplication] terminate:self];
                //exit(0); //现在不通过Helper结束DynamicLyrics了，因为SandBox的缘故，我又懒得弄NSConnection，直接自己退出=。=
            }
            if ([iTunesManager isRunning] && [iTunesManager playerState] == iTunesEPlSPlaying) {
                PlayerPosition = [iTunesManager playProgress];
                if ((currentPlayerPosition / 1000) != PlayerPosition)
                    currentPlayerPosition = PlayerPosition * 1000;
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                
                NSLog(@"PlayerPosition:%ld",PlayerPosition);
                [dict setObject:@"iTunesPosition" forKey:@"Type"];
                [dict setObject:[NSString stringWithFormat:@"%lu",currentPlayerPosition] forKey:@"currentPlayerPosition"];
                [self performSelectorOnMainThread:@selector(WorkingThread:) withObject:dict waitUntilDone:YES];
                
            }
            else {
                sleep(1);
            }
        }
    }
}


#pragma mark -
#pragma mark ......:::::: Observer :::::::......
- (void)lrcRoller:(NSTimer *)aTimer {
    if ([iTunesManager isRunning] && [iTunesManager playerState] == iTunesEPlSPlaying) {
        NSUInteger currentLyricsId;
        double currentTime = [iTunesManager playProgress];
        
        NSString *lyric = [lrcTokensPool getLyricsByTime:(int)currentTime lyricsID: &currentLyricsId];
        if (prevLrcItemId != currentLyricsId) {
            prevLrcItemId = currentLyricsId;
            [lyricWndCtrl setLyricString:lyric];
        }
    }
    
}

- (void)iTunesPlayDidStarted {
    [playBtn_ setTitle:@"暂停"];
    [self stopLRCTimer];
    [self startLRCTimer];
}

- (void)iTunesPlayDidPaused {
    [playBtn_ setTitle:@"播放"];
}

- (void)iTunesPlayDidResumed {
    [playBtn_ setTitle:@"暂停"];
}

- (void)iTunesPlayDidStoped {
    [playBtn_ setTitle:@"播放"];
}

@end
