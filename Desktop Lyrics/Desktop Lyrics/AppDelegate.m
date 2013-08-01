//
//  AppDelegate.m
//  Desktop Lyrics
//
//  Created by subo on 7/2/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import "AppDelegate.h"
#import "DLDataDefine.h"

#define PluginName @"Desktop Lyrics for iTunes.bundle"

@interface AppDelegate ()

- (BOOL)isPluginHadInstalled ;

@end

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
					   lyricSavePath, kUDKLyricFileSavePath,
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
    [self inStalliTunesPlugin];
    
    _iTunesControl = [[DLiTunesControl alloc] init];
    _lyricsStatusBar = [[DLLyricsStatusBar alloc] initWithiTunesControl:_iTunesControl];
}

#pragma mark -
#pragma mark ......:::::: Private Method :::::::......

- (BOOL)isPluginHadInstalled {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if (paths && [paths count] > 0) {
        NSString *iTunesPluginDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"iTunes/iTunes Plug-ins"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:iTunesPluginDir]) {
            //iTunes 插件目录不存在，就不进行安装
            return YES;
        }
        
        NSString *iTunesPluginPath = [[iTunesPluginDir stringByAppendingPathComponent:PluginName] stringByStandardizingPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:iTunesPluginPath]) {
            return YES;
        }
        
        return NO;
    }
    
    return YES;
}

- (void)inStalliTunesPlugin {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if (paths && [paths count] > 0) {
        NSString *iTunesPluginDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"iTunes/iTunes Plug-ins"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:iTunesPluginDir]) {
            //iTunes 插件目录不存在，就不进行安装
            return ;
        }
        
        NSString *iTunesPluginPath = [[iTunesPluginDir stringByAppendingPathComponent:PluginName] stringByStandardizingPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:iTunesPluginPath]) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setAlertStyle:NSInformationalAlertStyle];
            [alert setMessageText:@"Do you want to install plugin for iTunes?"];
            [alert addButtonWithTitle:@"YES"];
            [alert addButtonWithTitle:@"NO"];
            [alert setIcon:[NSImage imageNamed:@"icon"]];
            
            NSInteger result = [alert runModal];
            if (result == NSAlertFirstButtonReturn) {
                NSString *contentPath = [[NSBundle mainBundle] pathForResource:@"Desktop Lyrics for iTunes" ofType:@"bundle"];
                
                [[NSFileManager defaultManager] copyItemAtPath:contentPath toPath:iTunesPluginPath error:nil];
            }
            
            [alert release];
        }
    }
}

@end