//
//  VOutTextRender.h
//  PlayerView
//
//  Created by ws ws on 5/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VOutTextRender : NSObject {
    NSTextContainer * _textContainer;
    NSTextStorage   * _textStorage;
    NSLayoutManager * _layoutManager;
    
    NSMutableDictionary * _textAttributeds;
    NSString *_content;
}

- (NSBitmapImageRep *)render:(NSString *)context;

/**
 * @method
 * @abstract 设置歌词样式的各个属性
 * @discussion 属性可以是字体，字体颜色...
 * @param value 要设置的值
 * @param key 键值 在NSAttributedString.h文件有所有键值的定义
 * @result 
 */
- (void)setValue:(id)value forKey:(NSString *)key;

@end

