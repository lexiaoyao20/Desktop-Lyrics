//
//  MyGradientTextView.m
//  DrawGradientText
//
//  Created by subo on 7/30/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import "MyGradientTextView.h"
#import "NSImage+Gradient.h"

@implementation MyGradientTextView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textAttr = [[NSMutableDictionary alloc] init];
        //Lucida Grande
        [_textAttr setValue:[NSFont fontWithName:@"HelveticaNeue-Bold" size:75] forKey:NSFontAttributeName];
        [_textAttr setValue:[NSColor greenColor] forKey:NSForegroundColorAttributeName];
//        [_textAttr setValue:[NSNumber numberWithFloat:-1] forKey:NSStrokeWidthAttributeName];//轮廓宽度
        [_textAttr setValue:[NSColor blackColor] forKey:NSStrokeColorAttributeName];//轮廓颜色
        
        NSShadow *shadow = [[NSShadow alloc] init];
        [shadow setShadowColor: [NSColor blackColor]];
        [shadow setShadowBlurRadius: 1];
        [shadow setShadowOffset: NSMakeSize( 0, -1)];
        [_textAttr setValue:shadow forKey:NSShadowAttributeName];
        [shadow release];
        
        NSMutableParagraphStyle* paraStyle = [[NSMutableParagraphStyle alloc] init];
        [paraStyle setAlignment:NSCenterTextAlignment];
        [paraStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [_textAttr setValue:paraStyle forKey:NSParagraphStyleAttributeName];
        [paraStyle release];
    }
    
    return self;
}

- (void)dealloc
{
    [_content release];
    [_textAttr release];

    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (_content) {
        NSSize textSize = [_content sizeWithAttributes:_textAttr];
        NSArray *colorArray = [NSArray arrayWithObjects:
                      [NSColor colorWithDeviceRed:255/255.0 green:128/255.0 blue:0/255.0 alpha:1.0],
                      [NSColor colorWithDeviceRed:255/255.0 green:210/255.0 blue:79/255.0 alpha:1.0],
                      [NSColor colorWithDeviceRed:140/255.0 green:198/255.0 blue:63/255.0 alpha:1.0],nil];
        //关键在这里了
        NSImage *graidentImage = [NSImage gradientImageWithColors:colorArray imageSize:textSize];
        NSColor *textColor = [NSColor colorWithPatternImage:graidentImage];
        
        [_textAttr setValue:textColor forKey:NSForegroundColorAttributeName];
        
        NSRect drawRect = NSMakeRect(NSMinX(self.bounds), NSMinY(self.bounds), textSize.width, textSize.height);
        [_content drawInRect:drawRect withAttributes:_textAttr];
    }
}

- (void)setContent:(NSString *)content {
    [content retain];
    [_content release];
    _content = content;
    
    [self setNeedsDisplay:YES];
}

@end
