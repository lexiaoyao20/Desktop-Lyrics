//
//  DLSearchWindowController.h
//  Desktop Lyrics
//
//  Created by bo su on 13-7-18.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DLiTunesControl.h"
#import "DLDataDefine.h"


@class DLBackgroundView;


@interface DLSearchWindowController : NSWindowController<NSTableViewDataSource> {
    IBOutlet DLBackgroundView   *_backgroundView;
    IBOutlet NSTextField        *_titleTxt;
    IBOutlet NSTextField        *_artistTxt;
    IBOutlet NSButton           *_searchBtn;
    IBOutlet NSTableView        *_tableView;
    
    DLiTunesControl             *_iTunesControl;
    
    DLSearchType                _searchType;
    
    NSOperationQueue            *_operationQueue;
    NSArray                     *_dataSource;
}

@property (nonatomic) DLSearchType searchType;

- (id)initWithiTunesControl:(DLiTunesControl *)control;

- (void)showWindowWithTitle:(NSString *)title artist:(NSString *)artist;

- (IBAction)startSearch:(id)sender;

@end
