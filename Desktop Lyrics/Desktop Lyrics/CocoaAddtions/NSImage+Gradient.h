//
//  NSImage+Gradient.h
//  Desktop Lyrics
//
//  Created by bo su on 13-7-18.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Gradient)

/**
 * @method
 * @abstract 生成渐进色背景图片
 * @discussion 
 * @param gradientColors 渐进色数组  imageSize：要生成的图片的大小
 * @result NSImage :返回生成的图片
 */
+ (NSImage *)gradientImageWithColors:(NSArray *)gradientColors imageSize:(NSSize)imageSize;

@end
