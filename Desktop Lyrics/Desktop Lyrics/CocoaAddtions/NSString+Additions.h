//
//  NSString+Additions.h
//  Desktop Lyrics
//
//  Created by bo su on 13-7-19.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FileName)

+ (NSString *)fileNameWithTitle:(NSString *)title artist:(NSString *)artist pathExtention:(NSString *)pathExtention;

@end
