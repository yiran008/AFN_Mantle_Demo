//
//  BBDownloadManager.h
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBDownloadTask.h"
#import "BBMusicViewController.h"

typedef enum {
    unkownDownloadType          = 0,
    DownloadInWAN      = 1,
    NotDownloadInWAN    = 2
}DownloadInWANType;

@interface BBDownloadManager : NSObject<DownloadDelegate>{
    NSMutableArray      *downloadingVideos;     //已经加入下载队列的音频，无论是完成、等待、失败、下载中
    BOOL                isCanceled;           
    
}

@property (nonatomic, retain)   NSMutableArray      *downloadingVideos;
@property (nonatomic, retain)   BBDownloadTask      *downloadingTask;
@property (nonatomic, retain)   BBMusicViewController    *musicViewController;
@property (nonatomic, assign)   NetworkStatus       netStatus;
@property (nonatomic, assign)   BOOL                isBackFromBackground;

+ (BBDownloadManager *)sharedInstance;
- (void)resetMusicStatusWithDic:(NSDictionary *)dic;
- (void)restartDownload;
- (void)downloadWithUrl:(NSString *)str;
- (void)getMusicNeedDownloadWithCategoryID:(NSString *)categoryid;
- (void)addDownloadMusic:(NSDictionary *)dic;
@end
