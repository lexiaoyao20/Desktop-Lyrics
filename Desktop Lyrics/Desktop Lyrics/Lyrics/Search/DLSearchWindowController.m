//
//  DLSearchWindowController.m
//  Desktop Lyrics
//
//  Created by bo su on 13-7-18.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import "DLSearchWindowController.h"
#import "DLBackgroundView.h"
#import "NSImage+Gradient.h"
#import "DLDataDefine.h"
#import "DLBaiduAPIXMLParseOperation.h"

@interface DLSearchWindowController ()

@end

@implementation DLSearchWindowController

@synthesize searchType = _searchType;

- (id)initWithiTunesControl:(DLiTunesControl *)control {
    self = [super initWithWindowNibName:@"SearchWindow" owner:self];
    if (self) {
        _iTunesControl = [control retain];
    }
    
    return self;
}

- (void)dealloc
{
    [_iTunesControl release];  _iTunesControl = nil;
    [_operationQueue release]; _operationQueue = nil;
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)awakeFromNib {
    [_tableView setDataSource:self];
    //清新绿
    NSArray *colorArray = [NSArray arrayWithObjects:[NSColor colorWithDeviceRed:163/255.0 green:217/255.0 blue:91/255.0 alpha:1.0], 
                           [NSColor colorWithDeviceRed:156/255.0 green:232/255.0 blue:16/255.0 alpha:1],
                           [NSColor colorWithDeviceRed:182/255.0 green:224/255.0 blue:158/255.0 alpha:1.0],nil];
    [_backgroundView setGradientColorArray:colorArray];
}

- (void)showWindowWithTitle:(NSString *)title artist:(NSString *)artist {
    [self.window orderFront:nil];
    
    switch (_searchType) {
        case SearchLyrics:
            self.window.title = @"歌词搜索";
            break;
        case SearchSongs:
            self.window.title = @"歌曲搜索";
            break;
        default:
            break;
    }
    
    [_titleTxt setStringValue:title == nil ? @"" : title];
    [_artistTxt setStringValue:artist == nil ? @"" : artist];
}

- (IBAction)startSearch:(id)sender {
    if ([[_artistTxt stringValue] isEqualToString:@""] || [[_titleTxt stringValue] isEqualToString:@""]) {
        return;
    }
    
    if (_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    
    NSString *query = [NSString stringWithFormat:kDLBaiDuAPISearchLyricsURL,[_titleTxt stringValue],[_artistTxt stringValue]];
    if (_searchType == SearchSongs) {
        query = [NSString stringWithFormat:kDLBaiDuAPISearchSongsURL,[_titleTxt stringValue],[_artistTxt stringValue]];
    }
    
    NSString *encodeQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"query:%@",encodeQuery);
    NSURL *url = [NSURL URLWithString:encodeQuery];
    
    DLBaiduAPIXMLParseOperation *xmlParseOp = [[DLBaiduAPIXMLParseOperation alloc] initWithRequestURL:url];
    [xmlParseOp setDelegate:self];
    [_operationQueue addOperation:xmlParseOp];
    SafeReleaseObj(xmlParseOp);
}

#pragma mark -
#pragma mark ......:::::: implementation BaiDuAPIXMLParseDelegate :::::::......

- (void)baiduXMLParseDidFinished:(DLBaiduAPIXMLParseOperation *)sender error:(NSError *)error {
    
}

#pragma mark -
#pragma mark ......:::::: implementation NSTableViewDataSource :::::::......

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {

}

/* This method is required for the "Cell Based" TableView, and is optional for the "View Based" TableView. If implemented in the latter case, the value will be set to the view at a given row/column if the view responds to -setObjectValue: (such as NSControl and NSTableCellView).
 */
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

}

@end
