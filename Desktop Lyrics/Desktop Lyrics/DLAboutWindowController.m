//
//  DLAboutWindowController.m
//  Desktop Lyrics
//
//  Created by subo on 7/16/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import "DLAboutWindowController.h"

@interface DLAboutWindowController ()

@end

@implementation DLAboutWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"About" owner:self];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
