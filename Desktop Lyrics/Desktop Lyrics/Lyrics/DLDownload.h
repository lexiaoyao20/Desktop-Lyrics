//
//  DLDownload.h
//  Desktop Lyrics
//
//  Created by subo on 7/13/13.
//  Copyright (c) 2013 subo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLDownloadDelegate;

enum {
    kERInvalidURL = 0x100,
    kERCannotCreateTempFile = 0x101
};

@interface DLDownload : NSObject {
    NSURL       *_downloadURL;
    NSString    *_fileName;
    NSString    *_savePath;
    
    id<DLDownloadDelegate> _delegate;
    
    unsigned long long _fileSize;
    
@private
    NSString        *_destPath;                 //目标路径
    NSString        *_tempPath;                 //临时路径
    NSFileHandle    *_fileHandle;
    NSURLConnection *_urlConnection;
    unsigned long long _offset;
}

//下载地址
@property (nonatomic,retain)    NSURL       *downloadURL;
//下载的文件名，默认为下载原文件名
@property (nonatomic,copy)      NSString    *fileName;
//下载文件保存路径，
@property (nonatomic,copy)      NSString    *savePath;

@property (nonatomic,readonly)  unsigned long long fileSize;   //下载文件的大小

@property (nonatomic,assign)    id<DLDownloadDelegate>    delegate;

- (id)initWithDownloadURL:(NSURL *)aURL;

/**
 * 开始下载
 *
 * @param
 * @returns void
 */
- (void)start;

/**
 * 停止下载
 *
 * @param
 * @returns void
 */
- (void)stop;

/**
 * 结束及清空下载，清空后，下次下载相同的文件，不会断点续传
 *
 * @param
 * @returns void
 */
//- (void)clear;

@end

@protocol DLDownloadDelegate <NSObject>

//是否需要覆盖已经存在的文件
- (BOOL)shouldOverwriteExistFile:(NSString *)filePath;

@optional

//下载开始(responseHeaders为服务器返回的下载文件的信息)
- (void)downloadDidStart:(DLDownload *)aDownload didReceiveResponseHeaders:(NSURLResponse *)responseHeaders;
//下载失败
- (void)downloadDidFaild:(DLDownload *)aDownload didFailWithError:(NSError *)error;
//下载结束
- (void)downloadDidFinished:(DLDownload *)aDownload;
//更新下载的进度 -- 进度范围为0 - 100
- (void)downloadProgressDidChange:(DLDownload *)aDownload progress:(double)newProgress;


@end

