//
//  DLSongModel.m
//  Desktop Lyrics
//
//  Created by bo su on 13-7-18.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import "DLSongModel.h"
#import "DLDataDefine.h"


@implementation DLSongModel

@synthesize title = _title;
@synthesize artist = _artist;
@synthesize downloadURL = _downloadURL;
@synthesize fileType = _fileType;

- (DLSongModel *)initWithTitle:(NSString *)title artist:(NSString *)artist {
    if (self = [super init]) {
        self.title = title;
        self.artist = artist;
        self.fileType = LRCPATHEXTENSION;
    }
    
    return self;
}

- (void)dealloc
{
    [_title release];   _title = nil;
    [_artist release];  _title = nil;
    [_downloadURL release]; _downloadURL = nil;
    [_fileType release];    _fileType = nil;
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"title:%@\n artist:%@\n downloadURL:%@",_title,_artist,_downloadURL];
}

@end
