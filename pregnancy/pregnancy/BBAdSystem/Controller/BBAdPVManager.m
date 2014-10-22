//
//  BBAdPVManager.m
//  pregnancy
//
//  Created by liumiao on 5/5/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBAdPVManager.h"
#import "BBAdRequest.h"

/*设计原则，存储区B负责记录PV展示数，待上传的统计数据放在存储区A
  每次上传都合并B和A的数据并更新到A，上传
  上传成功后会清空存储区A
 */
#define PV_LOCAL_DATA_AREA_A @"Pv_local_data_area_a"
#define PV_LOCAL_DATA_AREA_B @"Pv_local_data_area_b"

//2*1024*1024 2M作为PV回传数据的限制，当更新数据区A的时候，如果数据区A里面的数据已经超过2M，将暂不更新
#define MAX_DATA_SIZE (2097152)

static BBAdPVManager *adPVManager = nil;
@interface BBAdPVManager()
@property (nonatomic,strong)NSOperationQueue* s_AddPVQueue;
@property (nonatomic,strong)ASIFormDataRequest *s_UploadPVRequest;
@end
@implementation BBAdPVManager

#pragma mark - Public Method

+ (BBAdPVManager*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        adPVManager = [[BBAdPVManager alloc] init];
    });
    
    return adPVManager;
}

- (id) init
{
    if(self = [super init])
    {
        _s_AddPVQueue = [[NSOperationQueue alloc]init];
        _s_AddPVQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

-(void)dealloc
{
    [_s_UploadPVRequest clearDelegatesAndCancel];
}
#pragma mark- 增加本地计数
- (void)addLocalPVForAd:(NSDictionary*)data
{
    if ([[UIApplication sharedApplication]applicationState]!= UIApplicationStateBackground)
    {
        //PV记录到B存储区
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(storeAdPVData:) object:data];
        [self.s_AddPVQueue addOperation:operation];
    }
}

- (void)addLocalPVForAdModel:(BBAdModel*)data
{
    //PV记录到B存储区
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (data.adBannerID)
    {
        [dict setString:data.adBannerID forKey:AD_DICT_BANNERID_KEY];
    }
    if (data.adZoneID)
    {
        [dict setString:data.adZoneID forKey:AD_DICT_ZONEID_KEY];
    }
    if (data.adMonitor)
    {
        [dict setString:data.adMonitor forKey:AD_DICT_MONITOR_KEY];
    }
    if (data.adServer)
    {
        [dict setString:data.adServer forKey:AD_DICT_SERVER_KEY];
    }
    [self addLocalPVForAd:dict];
}


//以逗号分隔每个广告记录，以分号分隔广告记录中的字段 ad_bannerid;ad_zoneid;ad_server;ad_pv;create_ts,
//123;888;1;5;1388505600,124;889;2;6;1388505700,..

-(void)storeAdPVData:(NSDictionary*)pvData
{
    if ([pvData isNotEmpty])
    {
        NSString *bannerId = [pvData stringForKey:AD_DICT_BANNERID_KEY];
        
        NSString *zoneId = [pvData stringForKey:AD_DICT_ZONEID_KEY];
        
        NSString *server = [pvData stringForKey:AD_DICT_SERVER_KEY];
        
        if (!([bannerId isNotEmpty] && [zoneId isNotEmpty] && [server isNotEmpty]))
        {
            return;
        }
        NSString *monitorUrl = [pvData stringForKey:AD_DICT_MONITOR_KEY];
        
        NSString *key = [NSString stringWithFormat:@"%@;%@;%@;",bannerId,zoneId,server];
        NSDictionary *oriData =[[NSUserDefaults standardUserDefaults]dictionaryForKey:PV_LOCAL_DATA_AREA_B];
        NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
        if (oriData)
        {
            [data addEntriesFromDictionary:oriData];
        }
        NSString *pvValue = [data stringForKey:key];
        if (pvValue)
        {
            NSArray *pvArray = [pvValue componentsSeparatedByString:@";"];
            if ([pvArray count]==2)
            {
                NSString *pvCount = [pvArray objectAtIndex:0];
                pvCount = [NSString stringWithFormat:@"%d",[pvCount integerValue]+1];
                if (pvCount >0)
                {
                    pvValue = [NSString stringWithFormat:@"%@;%@",pvCount,[pvArray objectAtIndex:1]];
                    [data setString:pvValue forKey:key];
                    [[NSUserDefaults standardUserDefaults]safeSetContainer:data forKey:PV_LOCAL_DATA_AREA_B];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [self sendMonitorRequest:monitorUrl];
                }
            }
        }
        else
        {
            NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
            pvValue = [NSString stringWithFormat:@"1;%0.f",ts];
            [data setString:pvValue forKey:key];
            [[NSUserDefaults standardUserDefaults]safeSetContainer:data forKey:PV_LOCAL_DATA_AREA_B];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self sendMonitorRequest:monitorUrl];
        }
    }
}

#pragma mark- 发送检测链接
-(void)sendMonitorRequest:(NSString*)url
{
    if ([url isNotEmpty])
    {
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        [request startAsynchronous];
    }
}

#pragma mark- 发送计数
- (void)sendLocalAdPV
{
    //合并存储区A和存储区B的PV数据，并上传
    NSString *uploadString = nil;
    [self.s_AddPVQueue setSuspended:YES];

    NSArray *aPVData = [[NSUserDefaults standardUserDefaults]arrayForKey:PV_LOCAL_DATA_AREA_A];
    if ([aPVData isNotEmpty])
    {
        uploadString = [aPVData componentsJoinedByString:@","];
        [self uploadAdPV:uploadString];
    }
    else
    {
        NSDictionary *bPVData = [[NSUserDefaults standardUserDefaults]dictionaryForKey:PV_LOCAL_DATA_AREA_B];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        for (NSString *key in [bPVData allKeys])
        {
            NSString *value = [bPVData stringForKey:key];
            if (value)
            {
                NSString *onePV = [NSString stringWithFormat:@"%@%@",key,value];
                [resultArray addObject:onePV];
            }
        }
        uploadString = [resultArray componentsJoinedByString:@","];
        if ([uploadString isNotEmpty] && [uploadString length] < MAX_DATA_SIZE)
        {
            [self uploadAdPV:uploadString];
            [[NSUserDefaults standardUserDefaults]safeSetContainer:resultArray forKey:PV_LOCAL_DATA_AREA_A];
        }
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:PV_LOCAL_DATA_AREA_B];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [self.s_AddPVQueue setSuspended:NO];
}
-(void)uploadAdPV:(NSString*)uploadString
{
    //上传成功，清空A存储区
    [self.s_UploadPVRequest clearDelegatesAndCancel];
    self.s_UploadPVRequest = [BBAdRequest sendAdPVRequestWithData:uploadString];
    [self.s_UploadPVRequest setDidFinishSelector:@selector(uploadPVRequestFinish:)];
    [self.s_UploadPVRequest setDidFailSelector:@selector(uploadPVRequestFail:)];
    [self.s_UploadPVRequest setDelegate:self];
    [self.s_UploadPVRequest setShouldContinueWhenAppEntersBackground:YES];
    [self.s_UploadPVRequest startAsynchronous];
}
#pragma mark- 发送计数Request Delegate
- (void)uploadPVRequestFinish:(ASIFormDataRequest *)request
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
        [self clearUploadPV];
    }
}

- (void)uploadPVRequestFail:(ASIFormDataRequest *)request
{
    
}

#pragma mark- 清空计数
- (void)clearUploadPV
{
    //清空A存储区
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:PV_LOCAL_DATA_AREA_A];
    [[NSUserDefaults standardUserDefaults]synchronize];
}



@end
