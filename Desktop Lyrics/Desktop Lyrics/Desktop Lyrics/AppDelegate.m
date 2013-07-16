//
//  AppDelegate.m
//  Desktop Lyrics
//
//  Created by subo on 7/2/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import "AppDelegate.h"
#import "DLDataDefine.h"

@implementation AppDelegate

+ (void)initialize {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, YES);
    NSString *musicDirectory = [paths objectAtIndex:0];
    NSString *lyricSavePath = [musicDirectory stringByAppendingPathComponent:@"Desktop Lyrics"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:lyricSavePath]) {
        if(![[NSFileManager defaultManager] createDirectoryAtPath:lyricSavePath withIntermediateDirectories:YES attributes:nil error:NULL]) {
            NSLog(@"Error: Create folder failed %@", lyricSavePath);
            return;
        }
    }
    
    [[NSUserDefaults standardUserDefaults]
	 registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
					   lyricSavePath, kLyricFileSavePath,
                       [NSNumber numberWithBool:YES],kUDKShowFloatWindow,
					   nil]];
}

- (void)dealloc
{
    SafeReleaseObj(_iTunesControl);
    SafeReleaseObj(_lyricsStatusBar);
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _iTunesControl = [[DLiTunesControl alloc] init];
    _lyricsStatusBar = [[DLLyricsStatusBar alloc] initWithiTunesControl:_iTunesControl];
}

@end