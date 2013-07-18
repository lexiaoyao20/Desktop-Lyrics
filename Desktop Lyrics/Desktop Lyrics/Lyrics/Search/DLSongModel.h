//
//  DLSongModel.h
//  Desktop Lyrics
//
//  Created by bo su on 13-7-18.
//  Copyright (c) 2013年 subo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLSongModel : NSObject {
    NSString *_title;
    NSString *_artist;
    NSURL    *_downloadURL;
}

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *artist;
@property (nonatomic,retain) NSURL *downloadURL;

- (DLSongModel *)initWithTitle:(NSString *)title artist:(NSString *)artist;

@end
