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
#import "DLSongModel.h"
#import "NSString+Additions.h"

@interface DLSearchWindowController ()

- (void)setDataSource:(NSArray *)aDataSource ;
- (void)downloadWithSongModel:(DLSongModel *)songModel;

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    [_tableView setDataSource:self];
    [_tableView setUsesAlternatingRowBackgroundColors:YES];
    [_tableView setDoubleAction:@selector(tableViewDoubleClicked:)];
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
    [self setDataSource:nil];
}

- (IBAction)startSearch:(id)sender {
    NSString *title = [[_titleTxt stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *artist = [[_artistTxt stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([title isEqualToString:@""]) {
        return;
    }
    
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    
    NSString *query = [NSString stringWithFormat:kDLBaiDuAPISearchLyricsURL,title,artist];
    if (_searchType == SearchSongs) {
        query = [NSString stringWithFormat:kDLBaiDuAPISearchLyricsURL,title,artist];
    }
    
    NSString *encodeQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"query:%@",encodeQuery);
    NSURL *url = [NSURL URLWithString:encodeQuery];
    
    DLBaiduAPIXMLParseOperation *xmlParseOp = [[DLBaiduAPIXMLParseOperation alloc] initWithRequestURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(baiduXMLParseDidFinished:)
                                                 name:DLBaiDuAPIXMLParseDidFinishNotification
                                               object:xmlParseOp];
    [_operationQueue addOperation:xmlParseOp];

    SafeReleaseObj(xmlParseOp);
}

- (IBAction)startDownload:(id)sender {
    
    NSInteger selectedRow = [_tableView selectedRow];
    if (selectedRow == -1 || selectedRow == NSNotFound || !_dataSource) {
        return;
    }
    
    DLSongModel *songModel = [_dataSource objectAtIndex:selectedRow];
    [self downloadWithSongModel:songModel];
    [self.window orderOut:nil];
}

- (IBAction)cancel:(id)sender {
    [_operationQueue cancelAllOperations];
    if (_download) {
        [_download stop];
    }
    [self.window orderOut:nil];
}

- (void)tableViewDoubleClicked:(id)sender {
    NSInteger rowNumber = [_tableView clickedRow];
    if (rowNumber != -1 && _dataSource) {
        DLSongModel *songModel = [_dataSource objectAtIndex:rowNumber];
        if (songModel) {
            [self downloadWithSongModel:songModel];
            [self.window orderOut:nil];
        }
    }
}

#pragma mark -
#pragma mark ......:::::: implementation BaiDuAPIXMLParseDelegate :::::::......

- (void)baiduXMLParseDidFinished:(NSNotification *)no {
    NSError *error = [[no userInfo] objectForKey:DLErrorKey];
    if (error) {
        [NSAlert alertWithError:error];
        [self setDataSource:nil];
        return;
    }
    
    NSArray *songInfoList = nil;
    NSString *fileType = nil;
    
    if (_searchType == SearchLyrics) {
        songInfoList = [[no userInfo] objectForKey:DLLRCURLListKey];
        fileType = LRCPATHEXTENSION;
    }
    else if (_searchType == SearchSongs) {
        songInfoList = [[no userInfo] objectForKey:DLSongsURLListKey];
        fileType = [[no userInfo] objectForKey:DLSongFileTypeKey];
        if (!fileType) {
            fileType = @".mp3";
        }
    }
    
    if (!songInfoList || [songInfoList count] == 0) {
        [self setDataSource:nil];
        return;
    }
    
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    NSString *title = [[_titleTxt stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *artist = [[_artistTxt stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    for (NSURL *lrcURL in songInfoList) {
        
        DLSongModel *songModel = [[DLSongModel alloc] initWithTitle:title
                                                             artist:artist];
        [songModel setDownloadURL:lrcURL];
        [songModel setFileType:fileType];
        [tempList addObject:songModel];
        SafeReleaseObj(songModel);
    }
    [self setDataSource:tempList];
    SafeReleaseObj(tempList);
}

#pragma mark -
#pragma mark ......:::::: implementation DLDownloadDelegate :::::::......

//下载失败
- (void)downloadDidFaild:(DLDownload *)aDownload didFailWithError:(NSError *)error {
    NSLog(@"download file:%@ failed. Error:%@",[aDownload fileName],error);
}

//下载结束
- (void)downloadDidFinished:(DLDownload *)aDownload {
    NSLog(@"download successful");
    NSString *downloadFilePath = [aDownload.savePath stringByAppendingPathComponent:aDownload.fileName] ;
    
    if (_searchType == SearchSongs) {
        iTunesTrack *track = [_iTunesControl addFile:downloadFilePath];
        if (track == nil) {
            NSLog(@"文件添加到iTunes失败，无效文件");
        }
    }
    else {
        
    }
}

//是否需要覆盖已经存在的文件
- (BOOL)shouldOverwriteExistFile:(NSString *)filePath {
    return YES;
}

#pragma mark -
#pragma mark ......:::::: implementation NSTableViewDataSource :::::::......

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (!_dataSource) {
        return 0;
    }
    
    return [_dataSource count];
}

/* This method is required for the "Cell Based" TableView, and is optional for the "View Based" TableView. If implemented in the latter case, the value will be set to the view at a given row/column if the view responds to -setObjectValue: (such as NSControl and NSTableCellView).
 */
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (!_dataSource) {
        return nil;
    }
    
    if ([[tableColumn identifier] isEqualToString:@"index"]) {
        return [NSNumber numberWithInteger:(row + 1)];
    }
    else if ([[tableColumn identifier] isEqualToString:@"songName"]) {
        DLSongModel *song = [_dataSource objectAtIndex:row];
        return [song title];
    }
    else {
        DLSongModel *song = [_dataSource objectAtIndex:row];
        return song.artist;
    }
}

#pragma mark -
#pragma mark .....:::::: Private Method ::::::.....

- (void)setDataSource:(NSArray *)aDataSource {
    [aDataSource retain];
    [_dataSource release];
    _dataSource = aDataSource;
    [_tableView reloadData];
}

- (void)downloadWithSongModel:(DLSongModel *)songModel {
    NSAssert(songModel.downloadURL, @"artist or title is nil");
    if (_download) {
        SafeReleaseObj(_download)
    }
    
    _download = [[DLDownload alloc] initWithDownloadURL:songModel.downloadURL];
    [_download setDelegate:self]; 
    
    NSLog(@"DownloadURL:%@",songModel.downloadURL);
    
    NSString *fileName = [NSString fileNameWithTitle:songModel.title artist:songModel.artist pathExtention:songModel.fileType];
    NSString *fileSavePath = [[NSUserDefaults standardUserDefaults] objectForKey:kUDKLyricFileSavePath];
    [_download setFileName:fileName];
    [_download setSavePath:fileSavePath];
    [_download start];
}

@end
