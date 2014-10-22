//
//  BBStatistic.m
//  pregnancy
//
//  Created by liumiao on 8/28/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBStatistic.h"
#import "BBStatisticRequest.h"

#define STATISTIC_DATA_AREA_LOCAL @"Statistic_data_area_local"
#define STATISTIC_DATA_AREA_UPLOAD @"Statistic_data_area_upload"

#define MAX_DATA_SIZE (2097152)

static BBStatistic *statisticSingleton = nil;

@interface BBStatistic()
@property (nonatomic,strong)NSOperationQueue* s_AddStatisticQueue;
@property (nonatomic,strong)ASIFormDataRequest *s_UploadDataRequest;
@end


@implementation BBStatistic

+ (BBStatistic*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statisticSingleton = [[BBStatistic alloc] init];
    });
    
    return statisticSingleton;
}

- (id)init
{
    if(self = [super init])
    {
        _s_AddStatisticQueue = [[NSOperationQueue alloc]init];
        _s_AddStatisticQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

-(void)dealloc
{
    [_s_UploadDataRequest clearDelegatesAndCancel];
}

+ (void)visitType:(NSString*)contentType contentId:(NSString*)contentId
{
    [self visitType:contentType contentId:contentId date:[NSDate date]];
}

+ (void)visitType:(NSString*)contentType contentId:(NSString*)contentId date:(NSDate*)date
{
    NSDate *tsDate = date;
    if (![tsDate isNotEmpty])
    {
        tsDate = [NSDate date];
    }
    NSTimeInterval time = [tsDate timeIntervalSince1970];
    NSString *ts = [NSString stringWithFormat:@"%0.f",time];
    
    if (![contentId isNotEmpty])
    {
        return;
    }
    
    NSString *content = [NSString stringWithFormat:@"%@,%@,%@;",contentType,contentId,ts];
    
    [[BBStatistic sharedInstance]storeStatisticData:content];
}

-(void)storeStatisticData:(NSString *)content
{
    if ([content isNotEmpty])
    {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(storeDataOperation:) object:content];
        [self.s_AddStatisticQueue addOperation:operation];
    }
}

-(void)storeDataOperation:(NSString*)content
{
    if ([content isNotEmpty])
    {
        NSString *storedContent = [[NSUserDefaults standardUserDefaults]objectForKey:STATISTIC_DATA_AREA_LOCAL];
        if ([storedContent isNotEmpty])
        {
            if ([storedContent length] < MAX_DATA_SIZE)
            {
                storedContent = [storedContent stringByAppendingString:content];
                [[NSUserDefaults standardUserDefaults]setObject:storedContent forKey:STATISTIC_DATA_AREA_LOCAL];
            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setObject:content forKey:STATISTIC_DATA_AREA_LOCAL];
        }
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"store string %@",[[NSUserDefaults standardUserDefaults]objectForKey:STATISTIC_DATA_AREA_LOCAL]);
    }
}

- (void)sendStatisticData
{
    [self.s_AddStatisticQueue setSuspended:YES];
    NSString *uploadStatistic = [[NSUserDefaults standardUserDefaults]objectForKey:STATISTIC_DATA_AREA_UPLOAD];
    if ([uploadStatistic isNotEmpty])
    {
        [self uploadStatisticData:uploadStatistic];
    }
    else
    {
        NSString *localStatistic = [[NSUserDefaults standardUserDefaults]objectForKey:STATISTIC_DATA_AREA_LOCAL];
        if ([localStatistic isNotEmpty] && [localStatistic length] < MAX_DATA_SIZE)
        {
            [[NSUserDefaults standardUserDefaults]setObject:localStatistic forKey:STATISTIC_DATA_AREA_UPLOAD];
            [self uploadStatisticData:localStatistic];
        }
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:STATISTIC_DATA_AREA_LOCAL];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [self.s_AddStatisticQueue setSuspended:NO];
}

- (void)uploadStatisticData:(NSString *)uploadContent
{
    [self.s_UploadDataRequest clearDelegatesAndCancel];
    self.s_UploadDataRequest = [BBStatisticRequest statisticRequestWithContent:uploadContent];
    [self.s_UploadDataRequest setDidFinishSelector:@selector(sendStatisticDataRequestFinish:)];
    [self.s_UploadDataRequest setDidFailSelector:@selector(sendStatisticDataRequestFail:)];
    [self.s_UploadDataRequest setDelegate:self];
    [self.s_UploadDataRequest setShouldContinueWhenAppEntersBackground:YES];
    [self.s_UploadDataRequest startAsynchronous];
}

- (void)sendStatisticDataRequestFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"])
    {
        [self clearUploadStatistic];
    }
}

- (void)sendStatisticDataRequestFail:(ASIFormDataRequest *)request
{
    
}

#pragma mark- 清空上传区统计数据

- (void)clearUploadStatistic
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:STATISTIC_DATA_AREA_UPLOAD];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
