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
#import "DLDownload.h"

@class DLBackgroundView;


@interface DLSearchWindowController : NSWindowController<NSTableViewDataSource,DLDownloadDelegate> {
    IBOutlet DLBackgroundView   *_backgroundView;
    IBOutlet NSTextField        *_titleTxt;
    IBOutlet NSTextField        *_artistTxt;
    IBOutlet NSButton           *_searchBtn;
    IBOutlet NSTableView        *_tableView;
    
    DLiTunesControl             *_iTunesControl;
    DLDownload                  *_download;
    
    DLSearchType                _searchType;
    
    NSOperationQueue            *_operationQueue;
    NSArray                     *_dataSource;
}

@property (nonatomic) DLSearchType searchType;

- (id)initWithiTunesControl:(DLiTunesControl *)control;

- (void)showWindowWithTitle:(NSString *)title artist:(NSString *)artist;

- (IBAction)startSearch:(id)sender;

- (IBAction)startDownload:(id)sender;

- (IBAction)cancel:(id)sender;

@end
