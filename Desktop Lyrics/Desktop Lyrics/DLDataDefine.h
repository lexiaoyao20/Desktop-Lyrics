//
//  DLDataDefine.h
//  Desktop Lyrics
//
//  Created by subo on 7/10/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LRCPATHEXTENSION @".lrc"

extern NSString * const kUDKLyricFileSavePath;

//是否显示桌面歌词
extern NSString * const kUDKShowFloatWindow;

#pragma mark -
#pragma mark ......:::::: API Define :::::::......

//百度歌词搜索API
extern NSString * const kDLBaiDuAPISearchLyricsURL;

extern NSString * const kDLBaiDuAPISearchSongsURL;

//歌词URL前缀
extern NSString * const kLRCDownloadPrefix;

#pragma mark -
#pragma mark ......:::::: Other :::::::......

//搜索类型
enum  {
    SearchLyrics = 0x10,
    SearchSongs
};
typedef NSInteger DLSearchType;

#pragma mark -
#pragma mark ......:::::: Error Define :::::::......

//错误域名
extern NSString * const DLXMLParseErrorDomain;

//错误编码
enum  {
    DataIsNil = 0,
    CannotFindLRC
};
typedef NSInteger DLXMLParseErrorCode;
