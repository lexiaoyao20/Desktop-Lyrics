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

//__attribute__  这个关键字是GCC 编译器对标准的扩展，它用来修饰函数属性，变量属性，类型属性
//__attribute__ ((constructor)) 所修饰的方法会在 main() 之前执行
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

//__attribute__ ((destructor)) 所修饰的方法会在main()执行结束之后执行
__attribute__ ((destructor))
static void finalizer() {
    NSArray *runningAppList = [NSRunningApplication runningApplicationsWithBundleIdentifier:DESKTOPLYRICSIDENTIFY];
    
    if (runningAppList && [runningAppList count] > 0) {
        NSRunningApplication *runningApp = [runningAppList objectAtIndex:0];
        [runningApp terminate];
    }
}