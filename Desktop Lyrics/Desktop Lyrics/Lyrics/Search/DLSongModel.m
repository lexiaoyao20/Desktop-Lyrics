//
//  DLSongModel.m
//  Desktop Lyrics
//
//  Created by bo su on 13-7-18.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import "DLSongModel.h"


@implementation DLSongModel

@synthesize title = _title;
@synthesize artist = _artist;
@synthesize downloadURL = _downloadURL;

- (DLSongModel *)initWithTitle:(NSString *)title artist:(NSString *)artist {
    if (self = [super init]) {
        self.title = title;
        self.artist = artist;
    }
    
    return self;
}

- (void)dealloc
{
    [_title release];   _title = nil;
    [_artist release];  _title = nil;
    [_downloadURL release]; _downloadURL = nil;
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"title:%@\n artist:%@\n downloadURL:%@",_title,_artist,_downloadURL];
}

@end
