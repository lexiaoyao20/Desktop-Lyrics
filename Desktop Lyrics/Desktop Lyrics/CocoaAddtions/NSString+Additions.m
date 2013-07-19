//
//  NSString+Additions.m
//  Desktop Lyrics
//
//  Created by bo su on 13-7-19.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (FileName)

+ (NSString *)fileNameWithTitle:(NSString *)title artist:(NSString *)artist pathExtention:(NSString *)pathExtention {
    if (artist == nil || [artist isEqualToString:@""]) {
        return [NSString stringWithFormat:@"%@%@",title,pathExtention];
    }
    return [NSString stringWithFormat:@"%@-%@%@", artist,title,pathExtention];
}

@end
