//
//  BBAdRequest.m
//  pregnancy
//
//  Created by liumiao on 5/4/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBAdRequest.h"

@implementation BBAdRequest

/*
 字段	是否必传	类型、范围	说明
 app_id	必传	string	来源
 zone_type	必传	string	广告位类型
 login_string	选传	string	用户授权token
 bpreg_brithday	选传	string	宝宝出生日期
 '2014-01-31'
 lat	选传	string	经度116.404
 lon	选传	string	纬度39.915
 
 app_id来源	说明
 pregnancy	快乐孕期
 lama	快乐辣妈
 
 zone_type名称(pregnancy)	说明
 welcome	启动画面
 index_banner	首页轮播
 topic_detail	帖子详情
 knowleage_tip	关爱提醒(知识提醒)
 grow_logo	宝宝发育
 knowleage_detail	知识详情(每日知识页+独立知识页)
 ask_detail	问答详情
 */
+ (ASIFormDataRequest *)getAdRequestForZoneType:(AdZoneType)zoneType
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/ad/show",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSString *adZoneType = @"";
    switch (zoneType) {
        case AdZoneTypeStartImage:
            adZoneType = @"welcome";
            break;
        case AdZoneTypeIndexBanner:
            adZoneType = @"index_banner";
            break;
        case AdZoneTypeCareRemind:
            adZoneType = @"knowleage_tip";
            break;
        case AdZoneTypeBabyGrowLogo:
            adZoneType = @"grow_logo";
            break;
        case AdZoneTypeTopicDetail:
            adZoneType = @"topic_detail";
            break;
        default:
            break;
    }
    if ([BBUser isLogin]) {
        [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
    {
        //1为备孕状态，其它为非备孕状态
        [request setPostValue:@"1" forKey:@"is_prepare"];
    }
    else
    {
        [request setPostValue:@"0" forKey:@"is_prepare"];
    }
    [request setGetValue:@"pregnancy" forKey:@"app_id"];
    [request setGetValue:adZoneType forKey:@"zone_type"];
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)getNewBannerAdRequestForTypeId:(NSString*)appTypeId
{
    ASIFormDataRequest *request =[BBAdRequest getAdRequestForZoneType:AdZoneTypeIndexBanner];
    [request setGetValue:[NSString stringWithFormat:@"%.0f", [[BBPregnancyInfo dateOfPregnancy] timeIntervalSince1970]] forKey:@"birthday_ts"];
    [request setPostValue:@"head" forKey:@"banner_pos"];
    if (appTypeId)
    {
        [request setPostValue:appTypeId forKey:@"app_type_id"];
    }
    return request;
}

+ (ASIFormDataRequest *)getRemindAdRequestWithIDs:(NSString *)IDs
{
    ASIFormDataRequest *request =[BBAdRequest getAdRequestForZoneType:AdZoneTypeCareRemind];
    if (IDs)
    {
        [request setGetValue:IDs forKey:@"tip_ids"];
    }
    return request;
}

/*
 字段	是否必传	类型、范围	说明
 app_id	必传	string	来源
 data	必传	string	广告数据
 */
+ (ASIFormDataRequest *)sendAdPVRequestWithData:(NSString*)data
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/ad/view",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:data forKey:@"data"];
    ASI_DEFAULT_INFO_POST
    return request;
}
@end
