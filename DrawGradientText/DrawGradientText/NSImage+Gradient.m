//
//  NSImage+Gradient.m
//  Desktop Lyrics
//
//  Created by bo su on 13-7-18.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import "NSImage+Gradient.h"

@implementation NSImage (Gradient)

+ (NSImage *)gradientImageWithColors:(NSArray *)gradientColors imageSize:(NSSize)imageSize {
    if (gradientColors == nil || NSEqualSizes(imageSize, NSZeroSize)) {
        return nil;
    }
    
    NSBitmapImageRep * bitmapRep = nil;
    NSImage *image = nil;
    
    if (imageSize.width > 0 && imageSize.height > 0) {
        
        int pixelsWide = imageSize.width, pixelsHigh = imageSize.height; 
        CGContextRef ctx = NULL;
        
        bitmapRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes: nil  // Nil pointer makes the kit allocate the pixel buffer for us.
                                                            pixelsWide: pixelsWide  // The compiler will convert these to integers, but I just wanted to  make it quite explicit
                                                            pixelsHigh: pixelsHigh //
                                                         bitsPerSample: 8
                                                       samplesPerPixel: 4  // Four samples, that is: RGBA
                                                              hasAlpha: YES
                                                              isPlanar: NO  // The math can be simpler with planar images, but performance suffers..
                                                        colorSpaceName: NSCalibratedRGBColorSpace  // A calibrated color space gets us ColorSync for free.
                                                           bytesPerRow: pixelsWide * 4     
                                                          bitsPerPixel: 32];  // This must agree with bitsPerSample and samplesPerPixel.;
        
        if (bitmapRep) {
            ctx = CGBitmapContextCreate([bitmapRep bitmapData], [bitmapRep size].width, [bitmapRep size].height, [bitmapRep bitsPerSample], [bitmapRep bytesPerRow], [[bitmapRep colorSpace] CGColorSpace], kCGImageAlphaPremultipliedLast);
        }
        
        if (ctx) {
            CGContextSaveGState(ctx);
            //draw gradient    
            CGGradientRef gradient;
            CGColorSpaceRef rgbColorspace;
            
            //set uniform distribution of color locations
            size_t num_locations = [gradientColors count];
            CGFloat locations[num_locations];
            for (int k=0; k<num_locations; k++) {
                locations[k] = k / (CGFloat)(num_locations - 1); //we need the locations to start at 0.0 and end at 1.0, equaly filling the domain
            }
            
            //create c array from color array
            CGFloat components[num_locations * 4];
            for (int i=0; i<num_locations; i++) {
                NSColor *color = [gradientColors objectAtIndex:i];
                //                NSAssert(color.canProvideRGBComponents, @"Color components could not be extracted from StyleLabel gradient colors.");
                components[4*i+0] = [color redComponent];
                components[4*i+1] = [color greenComponent];
                components[4*i+2] = [color blueComponent];
                components[4*i+3] = [color alphaComponent];
            }
            
            rgbColorspace = CGColorSpaceCreateDeviceRGB();
            gradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
            CGPoint topCenter = CGPointMake(0, 0);
            CGPoint bottomCenter = CGPointMake(0, imageSize.height);
            CGContextDrawLinearGradient(ctx, gradient, topCenter, bottomCenter, 0);
            
            CGGradientRelease(gradient);
            CGColorSpaceRelease(rgbColorspace); 
            
            // pop context 
            CGContextRestoreGState(ctx);							
        }
        
        if (ctx) {
            CGContextRelease(ctx); ctx = nil;
        }
    }
    
    if (bitmapRep) {
        image = [[NSImage alloc] initWithData:[bitmapRep TIFFRepresentation]];
        [bitmapRep release]; bitmapRep = nil;
    }
    
    return [image autorelease];
}

@end
