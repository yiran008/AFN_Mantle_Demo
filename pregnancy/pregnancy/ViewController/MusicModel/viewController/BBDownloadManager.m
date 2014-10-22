//
//  BBDownloadManager.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBDownloadManager.h"
#import "BBMusicDB.h"
#import "BBMusicViewController.h"

@interface BBDownloadManager ()
@property (nonatomic, assign) DownloadInWANType shouldDownloadInWAN;
@end

@implementation BBDownloadManager
@synthesize downloadingVideos;

- (void)getMusicNeedDownloadWithCategoryID:(NSString *)categoryid
{
    
}

- (void)addDownloadMusic:(NSDictionary *)dic
{
    for (int i = 0; i < [self.downloadingVideos count]; i++) {
        NSDictionary *downloadingDic = [self.downloadingVideos objectAtIndex:i];
        if ([[downloadingDic stringForKey:MUSIC_ID] isEqualToString:[dic stringForKey:MUSIC_ID]]) {
            [self resetMusicStatusWithDic:dic];
            return;
        }
    }
    if ([BBMusicDB insertMusicWithDic:dic]) {
        [downloadingVideos addObject:dic];
        [self resetMusicStatusWithDic:dic];
    }
}

- (void)resetMusicStatusWithDic:(NSDictionary *)dic
{
    if ([dic intForKey:MUSIC_STATUS] == DOWNLOAD_PRE) {
        [self setDownloadStatus:DOWNLOAD_WAIT withMusicID:[dic stringForKey:MUSIC_ID]];
        [BBMusicDB setDownloadStauts:DOWNLOAD_WAIT withMusicID:[dic stringForKey:MUSIC_ID]];
        if (self.musicViewController) {
            [self.musicViewController setDownloadStatus:DOWNLOAD_WAIT withMusicInfo:(NSMutableDictionary *)dic];

        }
    }else if([dic intForKey:MUSIC_STATUS] == DOWNLOAD_PASUE)
    {
        [self setDownloadStatus:DOWNLOAD_WAIT withMusicID:[dic stringForKey:MUSIC_ID]];
        [BBMusicDB setDownloadStauts:DOWNLOAD_WAIT withMusicID:[dic stringForKey:MUSIC_ID]];
        if (self.musicViewController) {
            [self.musicViewController setDownloadStatus:DOWNLOAD_WAIT withMusicInfo:(NSMutableDictionary *)dic];

        }
        
    }
    else if([dic intForKey:MUSIC_STATUS] == DOWNLOAD_FAIL)
    {
        [self setDownloadStatus:DOWNLOAD_WAIT withMusicID:[dic stringForKey:MUSIC_ID]];
        [BBMusicDB setDownloadStauts:DOWNLOAD_WAIT withMusicID:[dic stringForKey:MUSIC_ID]];
        if (self.musicViewController) {
            [self.musicViewController setDownloadStatus:DOWNLOAD_WAIT withMusicInfo:(NSMutableDictionary *)dic];

        }
        
    }else if([dic intForKey:MUSIC_STATUS] == DOWNLOAD_DOWNLOADING)
    {
        [self setDownloadStatus:DOWNLOAD_PASUE withMusicID:[dic stringForKey:MUSIC_ID]];
        [BBMusicDB setDownloadStauts:DOWNLOAD_PASUE withMusicID:[dic stringForKey:MUSIC_ID]];
        if (self.musicViewController) {
            [self.musicViewController setDownloadStatus:DOWNLOAD_PASUE withMusicInfo:(NSMutableDictionary *)dic];
        }
        [self pauseDownloadTask];
        
        
    }
    
    if (![self hasVideoDownloading]) {
        [self continueNextDownloadTask];
    }
}



- (void)downloadWithUrl:(NSString *)str
{
    for (NSDictionary *dic in downloadingVideos) {
        if ([[dic stringForKey:MUSIC_DOWNLOADURL] isEqualToString:str]) {
            [self resetMusicStatusWithDic:dic];
        }
    }
}

- (void)setDownloadStatus:(int)downloadStatus withMusicID:(NSString *)video_id
{
    for (NSDictionary *dic  in downloadingVideos) {
        if ([[dic stringForKey:MUSIC_ID] isEqualToString:video_id]) {
            [dic setValue:[NSNumber numberWithInt:downloadStatus] forKey:MUSIC_STATUS];
            return;
        }
    }
}

- (void)startDownloadTask:(NSDictionary *)dic {

    [self setDownloadStatus:DOWNLOAD_DOWNLOADING withMusicID:[dic stringForKey:MUSIC_ID]];
    [BBMusicDB setDownloadStauts:DOWNLOAD_DOWNLOADING withMusicID:[dic stringForKey:MUSIC_ID]];
    if (self.musicViewController) {
        [self.musicViewController setDownloadStatus:DOWNLOAD_DOWNLOADING withMusicInfo:(NSMutableDictionary *)dic];
    }
    
    if (self.shouldDownloadInWAN != DownloadInWAN && self.netStatus == ReachableViaWWAN) {
        [self showAlertWithStatus:ReachableViaWWAN];
        return;
    }

    BBDownloadTask *downloadTask = [[[BBDownloadTask alloc] initWithDic:dic] autorelease];
    downloadTask.delegate = self;
    self.downloadingTask = downloadTask;
    [downloadTask startDownload:[dic stringForKey:MUSIC_DOWNLOADURL]];
}

- (void)pauseDownloadTask
{
    if (self.downloadingTask) {
        [self.downloadingTask pauseDownload];
        self.downloadingTask = nil;
    }
}

- (void)downLoadDidFinish:(BBDownloadTask *)task
{
    NSDictionary *musicTypeInfo = self.musicViewController.musicTypeInfo;
    if([musicTypeInfo isNotEmpty])
    {
        if([[musicTypeInfo stringForKey:@"type" ] isEqualToString:@"1"])
        {
            [MobClick event:@"music_v2" label:@"下载成功数量-胎教音乐"];
        }
        else if([[musicTypeInfo stringForKey:@"type" ] isEqualToString:@"2"])
        {
            [MobClick event:@"music_v2" label:@"下载成功数量-早教音乐"];
        }
    }
    
    [self setDownloadStatus:DOWNLOAD_FINISH withMusicID:[task.musicDic stringForKey:MUSIC_ID]];
    [BBMusicDB setDownloadStauts:DOWNLOAD_FINISH withMusicID:[task.musicDic stringForKey:MUSIC_ID]];
    if (self.musicViewController) {
        [self.musicViewController setDownloadStatus:DOWNLOAD_FINISH withMusicInfo:(NSMutableDictionary *)task.musicDic];
    }
    for (NSDictionary *dic  in downloadingVideos) {
        if ([[dic stringForKey:MUSIC_ID] isEqualToString:[task.musicDic stringForKey:MUSIC_ID]]) {
            [downloadingVideos removeObject:dic];
            break;
        }
    }
    self.downloadingTask = nil;
    [self continueNextDownloadTask];
}

- (void)enterForeground
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    self.netStatus = [reachability currentReachabilityStatus];
    
    if (self.musicViewController) {
        if (self.netStatus == ReachableViaWiFi) {
            [self restartDownload];
            return;
        }
    
        if(self.netStatus == ReachableViaWWAN) {
            [self showAlertWithStatus:ReachableViaWWAN];
        }
    }else {
        self.isBackFromBackground = YES;

    }
}

- (void)restartDownload
{
    isCanceled = NO;
    if ([self hasVideoDownloading] && self.downloadingTask == nil) {
        NSDictionary *dic = [self getDownloadingVideo];
        [self startDownloadTask:dic];
        return;
    }
    
    [self continueNextDownloadTask];
}

- (void)continueNextDownloadTask {
    if ([self hasWaitDownloadVideo]) {
        NSMutableDictionary *dic = [self getNextWaitingDownloadVideo];
        if (dic) {
            [self startDownloadTask:dic];
        }
    }
}
- (void)downloadDidFail:(BBDownloadTask *)task
{
    [self setDownloadStatus:DOWNLOAD_FAIL withMusicID:[task.musicDic stringForKey:MUSIC_ID]];
    [BBMusicDB setDownloadStauts:DOWNLOAD_FAIL withMusicID:[task.musicDic stringForKey:MUSIC_ID]];
    if (self.musicViewController) {
        [self.musicViewController setDownloadStatus:DOWNLOAD_FAIL withMusicInfo:(NSMutableDictionary *)task.musicDic];
    }
    self.downloadingTask = nil;
    if (self.netStatus == NotReachable) {
        [AlertUtil showAlert:nil withMessage:@"请打开网络！"];
    }
    [self continueNextDownloadTask];
}
- (void)downloadProcess:(BBDownloadTask *)task
{
    
}
- (void)downloadSize:(BBDownloadTask *)task
{

}

- (void)downloadFileSize:(BBDownloadTask *)task
{
    
}



#pragma mark download manager



- (BOOL)hasVideoDownloading {
    BOOL flag = NO;
    for (int i = 0; i < [downloadingVideos count]; i++) {
        NSMutableDictionary *dic = [downloadingVideos objectAtIndex:i];
        if ([dic intForKey:MUSIC_STATUS] == DOWNLOAD_DOWNLOADING) {
            flag = YES;
        }
    }
    
    return flag;
}

- (BOOL)hasWaitDownloadVideo {
    BOOL flag = NO;
    for (int i = 0; i < [downloadingVideos count]; i++) {
        NSMutableDictionary *dic = [downloadingVideos objectAtIndex:i];
        if ([dic intForKey:MUSIC_STATUS] == DOWNLOAD_WAIT) {
            flag = YES;
        }
    }
    return flag;
}

- (NSMutableDictionary *)getNextWaitingDownloadVideo {
    for (int i = 0; i < [downloadingVideos count]; i++) {
        NSMutableDictionary *dic = [downloadingVideos objectAtIndex:i];
        if ([dic intForKey:MUSIC_STATUS] == DOWNLOAD_WAIT) {
            return dic;
        }
    }
    return nil;
}

- (NSMutableDictionary *)getDownloadingVideo {
    for (int i = 0; i < [downloadingVideos count]; i++) {
        NSMutableDictionary *dic = [downloadingVideos objectAtIndex:i];
        if ([dic intForKey:MUSIC_STATUS] == DOWNLOAD_DOWNLOADING) {
            return dic;
        }
    }
    return nil;
}


/*****************
 - (void)cancelAllDownloadTask
 当网络断开或者在2g/3g网络下时，调用该函数取消正在下载的视频。
 *****************/

- (void)cancelAllDownloadTask {
    [self pauseDownloadTask];
    isCanceled = YES;
}

- (void)failAllDownloadTask {
    for (int i = 0; i < [self.downloadingVideos count]; i++) {
        NSMutableDictionary *dic = [self.downloadingVideos objectAtIndex:i];
        [self setDownloadStatus:DOWNLOAD_FAIL withMusicID:[dic stringForKey:MUSIC_ID]];
        [BBMusicDB setDownloadStauts:DOWNLOAD_FAIL withMusicID:[dic stringForKey:MUSIC_ID]];
        if (self.musicViewController) {
            [self.musicViewController setDownloadStatus:DOWNLOAD_FAIL withMusicInfo:dic];
        }
    }
}

- (void)getDownloadMusic
{
   self.downloadingVideos = [BBMusicDB getDownLoadMusic];
//    self.downloadedVideos = [[NSMutableArray alloc] init];
}

#pragma mark detail with network status change

//网络变化时调用该方法
- (void)networkStatusChanged:(NSNotification *)notification {
    NSLog(@"网络变化");
    Reachability * reach = [notification object];
    NetworkStatus networkStatus = [reach currentReachabilityStatus];
    self.netStatus = networkStatus;
    switch (networkStatus) {
        case NotReachable:
            [self showAlertWithStatus:NotReachable];
            break;
        case ReachableViaWWAN:
            self.shouldDownloadInWAN = unkownDownloadType;
            [self showAlertWithStatus:ReachableViaWWAN];
            break;
        case ReachableViaWiFi:
            self.shouldDownloadInWAN = unkownDownloadType;
            if (isCanceled) {
                [self restartDownload];
            }
            break;
        default:
            break;
    }
}

//判断是否有视频正在下载或者等待下载
- (BOOL)hasVideoNeedDownload {
    BOOL flag = NO;
    if ([self hasWaitDownloadVideo] || [self hasVideoDownloading]) {
        flag = YES;
    }
    return flag;
}

//网络状态发生变化时弹出提示
- (void)showAlertWithStatus:(int)status {
    
    if ([self hasVideoNeedDownload]) {//在这里判断是不是有视频正在下载或者等待下载，如果有给出提示,没有什么也不做.
        if (status == NotReachable) {
            [self cancelAllDownloadTask];
            [self failAllDownloadTask];
            [AlertUtil showAlert:nil withMessage:@"网络已断开，请检查网络状态"];
        }else if(status == ReachableViaWWAN) {
            [self cancelAllDownloadTask];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"现在你处于2g/3g网络,继续下载可能会产生流量费用，是否继续下载你的视频？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
            [alert show];
            [alert release];
        }else {
            
        }
    }else {
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            self.shouldDownloadInWAN = NotDownloadInWAN;
            [self failAllDownloadTask];
            break;
        case 1:
            self.shouldDownloadInWAN = DownloadInWAN;
            [self restartDownload];
            break;
            
        default:
            break;
    }
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseDownloadTask) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self addObserver];
        [self getDownloadMusic];
    }
    return self;
}

#pragma mark downloadmanager initial

- (void)initData {
    isCanceled = NO;
    self.netStatus = ReachableViaWiFi;
    self.shouldDownloadInWAN = unkownDownloadType;
}


#pragma mark create singleton instance

+ (BBDownloadManager *)sharedInstance {
    static BBDownloadManager  *downloadManagerInstance = nil;
    @synchronized(self) {
        if (downloadManagerInstance == nil) {
            downloadManagerInstance = [[BBDownloadManager alloc] init];
        }
       return downloadManagerInstance;
    }
}



- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;
}

- (id)autorelease {
    return self;
}

- (oneway void)release {
    
}


@end
