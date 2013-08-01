//
//  MyGradientTextView.h
//  DrawGradientText
//
//  Created by subo on 7/30/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyGradientTextView : NSView {
    NSString *_content;
    
    NSMutableDictionary *_textAttr;
}

- (void)setContent:(NSString *)content;

@end
