//
//  BBMainPageRequest.m
//  pregnancy
//
//  Created by liumiao on 4/9/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBMainPageRequest.h"


@implementation BBMainPageRequest
+ (ASIFormDataRequest *)recommendTopic{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_recommend/get_recommend_topic",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBUser isLogin]) {
        [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
    {
        [request setGetValue:@"1" forKey:@"baby_status"];
    }
    else if ([BBUser getNewUserRoleState] == BBUserRoleStatePregnant)
    {
        [request setGetValue:@"2" forKey:@"baby_status"];
    }
    else
    {
        [request setGetValue:@"3" forKey:@"baby_status"];
    }
    [request setGetValue:@"0" forKey:START_KEY];
    [request setGetValue:@"1" forKey:LIMIT_KEY];
    ASI_DEFAULT_INFO_GET
    [request setGetValue:@"pregnancy" forKey:@"app_id"];
    return request;
}

+ (ASIFormDataRequest *)topBanner:(NSString *)appTypeId{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/advertising/get_banner_list",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBUser isLogin]) {
        [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    [request setGetValue:[NSString stringWithFormat:@"%.0f", [[BBPregnancyInfo dateOfPregnancy] timeIntervalSince1970]] forKey:@"birthday_ts"];
    [request setGetValue:@"head" forKey:@"banner_pos"];
    [request setGetValue:appTypeId forKey:@"app_type_id"];
    ASI_DEFAULT_INFO_GET
    return request;
}

+ (ASIFormDataRequest *)getBannerAdvertisement
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/advertising/get_banner_list",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[NSString stringWithFormat:@"%.0f", [[BBPregnancyInfo dateOfPregnancy] timeIntervalSince1970]] forKey:@"birthday_ts"];
    ASI_DEFAULT_INFO_GET

    return request;
}

+ (ASIFormDataRequest *)getMallHasNewItemStatus:(NSString *)lastTS
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/theme/get_new_count",BABYTREE_MALL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBUser isLogin]) {
        [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    if (lastTS)
    {
        [request setGetValue:lastTS forKey:@"last_ts"];
    }
    else
    {
        [request setGetValue:@"0" forKey:@"last_ts"];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)addPreValueRequest
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_upgrade/promo",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBUser isLogin]) {
        [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}
@end
