//
//  BBPrizeRequest.m
//  pregnancy
//
//  Created by babytree on 12-12-3.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBPrizeRequest.h"
#import "BBUser.h"
#import "BBDeviceUtility.h"
#import "BBPregnancyInfo.h"

@implementation BBPrizeRequest

+ (ASIFormDataRequest *)prizeUserInfo
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/yunqi_mobile/user_info",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getLoginString] forKey:@"login_string"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)prizeSign
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/yunqi_mobile/checkin",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getLoginString] forKey:@"login_string"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)popLayerRequest
{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://chenlehui.babytree-dev.com/api/mobile_activity/get_qiandao_activity_info"]];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getLoginString] forKey:@"login_string"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

@end
