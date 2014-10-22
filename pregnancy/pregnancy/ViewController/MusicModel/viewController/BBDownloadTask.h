//
//  BBDownloadTask.h
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol DownloadDelegate;

@interface BBDownloadTask : NSObject
@property (nonatomic, strong)   NSDictionary            *musicDic;
@property (nonatomic, assign)   long long               fileSize;
@property (nonatomic, assign)   long long               downloadSize;
@property (nonatomic, assign)   id<DownloadDelegate>    delegate;


- (void)startDownload:(NSString *)downloadUrl;
- (void)pauseDownload;

- (id)initWithDic:(NSDictionary *)dic;
@end

@protocol DownloadDelegate <NSObject>

- (void)downLoadDidFinish:(BBDownloadTask *)task;
- (void)downloadDidFail:(BBDownloadTask *)task;
- (void)downloadProcess:(BBDownloadTask *)task;
- (void)downloadSize:(BBDownloadTask *)task;
- (void)downloadFileSize:(BBDownloadTask *)task;
@end
