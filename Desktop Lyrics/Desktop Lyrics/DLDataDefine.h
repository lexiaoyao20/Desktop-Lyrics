//
//  DLDataDefine.h
//  Desktop Lyrics
//
//  Created by subo on 7/10/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LRCPATHEXTENSION @".lrc"

extern NSString * const kLyricFileSavePath;

//是否显示桌面歌词
extern NSString * const kUDKShowFloatWindow;

//百度搜索API
extern NSString * const kLRCBaiDuAPISearchURL;
//歌词保持URL前缀
extern NSString * const kLRCDownloadPrefix;

extern NSString * const DLXMLParseErrorDomain;

enum  {
    DataIsNil = 0,
    CannotFindLRC
};
typedef NSInteger DLXMLParseErrorCode;