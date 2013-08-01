//
//  PluginController.m
//  Desktop Lyrics
//
//  Created by bo su on 13-7-31.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import "PluginController.h"

#define DESKTOPLYRICSIDENTIFY @"com.myCompany.Desktop-Lyrics"
#define APPNAME               @"Desktop Lyrics"



@implementation PluginController


@end

__attribute__ ((constructor))
static void initialize(){
    NSArray *runningAppList = [NSRunningApplication runningApplicationsWithBundleIdentifier:DESKTOPLYRICSIDENTIFY];

    if (runningAppList == nil || [runningAppList count] == 0) {
        BOOL hasLaunched = NO;
        NSString *appPath = [NSString stringWithFormat:@"/Applications/%@.app",APPNAME];
        if ([[NSFileManager defaultManager] fileExistsAtPath:appPath]) {
            hasLaunched = [[NSWorkspace sharedWorkspace] openFile:appPath];
        }
        
        if (!hasLaunched) {
            [[NSWorkspace sharedWorkspace] launchApplication:APPNAME];
        }
    }
}

__attribute__ ((destructor))
static void finalizer() {
    NSArray *runningAppList = [NSRunningApplication runningApplicationsWithBundleIdentifier:DESKTOPLYRICSIDENTIFY];
    
    if (runningAppList && [runningAppList count] > 0) {
        NSRunningApplication *runningApp = [runningAppList objectAtIndex:0];
        [runningApp terminate];
    }
}