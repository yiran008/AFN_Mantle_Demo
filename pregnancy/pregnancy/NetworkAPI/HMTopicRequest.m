//
//  HMTopicRequest.m
//  lama
//
//  Created by Heyanyang on 13-6-22.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMApiRequest.h"

@implementation HMApiRequest (HMTopicRequest)

// 关注辣妈话题
//+ (ASIFormDataRequest *)focusMomTopicListwithStart:(NSInteger)page withEndTime:(NSString *)theEndTime
//{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_newevent/get_events", BABYTREE_URL_SERVER]];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    //翻页各种字段名
//    //[request setGetValue:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"page"];
//    [request setGetValue:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"pg"];
//    //[request setGetValue:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"start"];
//    //[request setGetValue:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"current_page"];
//    
//    [request setGetValue:[NSString stringWithFormat:@"%d", 20] forKey:@"limit"];
//    [request setGetValue: [BBUser getLoginString] forKey:@"login_string"];
//    [request setGetValue: theEndTime forKey:@"end_ts"];
//    
//    ASI_DEFAULT_INFO_GET
//
//    return request;
//}

// 进入某个圈的话题列表
+ (ASIFormDataRequest *)theCircleTopicListwithStart:(NSInteger)page withGroupID:(NSString *)theGroupID listType:(NSInteger)theTypeOfTopic defaultType:(NSInteger)theDefaultType;
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/get_group_discuz_list", BABYTREE_URL_SERVER]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBUser isLogin]) {
        [request setGetValue: [BBUser getLoginString] forKey:@"login_string"];
    }
    [request setGetValue:theGroupID forKey:@"group_id"];
    //翻页各种字段名
    [request setGetValue:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"page"];
    [request setGetValue:[NSString stringWithFormat:@"%d", 20] forKey:@"limit"];
    [request setGetValue:[NSString stringWithFormat:@"%d", 1] forKey:@"has_group_info"];
    
    if (theTypeOfTopic == POPLIST_LASTREPLY)
    {
        [request setGetValue:@"last_response_ts" forKey:@"orderby"];
    }
    else if (theTypeOfTopic == POPLIST_NEWEST)
    {
        [request setGetValue:@"create_ts" forKey:@"orderby"];
    }
    else if (theTypeOfTopic == POPLIST_ONLYGOOD)
    {
        [request setGetValue:@"1" forKey:@"is_elite"];
    }
    else if (theTypeOfTopic == POPLIST_ONLYCITY)
    {
        [request setGetValue:[BBUser getUserOnlyCity] forKey:@"province_id"];
    }
    
    [request setGetValue:[NSString stringWithFormat:@"%ld", (long)theDefaultType] forKey:@"default_type"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

// 进入某个圈的话题列表- 返回数据为文字形式或者是图片形式
//+ (ASIFormDataRequest *)theCircleTopicListTextOrPicwithStart:(NSInteger)page withGroupID:(NSString *)theGroupID withTypeOfTopic:(NSInteger)theTypeOfTopic withGettype:(NSInteger)theGettype
//{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/get_group_datalist", BABYTREE_URL_SERVER]];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    
//    [request setGetValue: [BBUser getLoginString] forKey:@"login_string"];
//    [request setGetValue:theGroupID forKey:@"group_id"];
//    [request setGetValue:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"page"];
//    [request setGetValue:[NSString stringWithFormat:@"%d", 20] forKey:@"limit"];
//    [request setGetValue:[NSString stringWithFormat:@"%d", 1] forKey:@"has_group_info"];
//    [request setGetValue:[NSString stringWithFormat:@"%ld", (long)theGettype] forKey:@"gettype"];
//    
//    if (theTypeOfTopic == POPLIST_LASTREPLY)
//    {
//        [request setGetValue:@"last_response_ts" forKey:@"orderby"];
//    }
//    else if (theTypeOfTopic == POPLIST_NEWEST)
//    {
//        [request setGetValue:@"create_ts" forKey:@"orderby"];
//    }
//    else if (theTypeOfTopic == POPLIST_ONLYGOOD)
//    {
//        [request setGetValue:@"1" forKey:@"is_elite"];
//    }
//    
//    ASI_DEFAULT_INFO_GET
//    
//    return request;
//}

// 喜欢
+ (ASIFormDataRequest *)lovetTopicWithID:(NSString *)topicId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/set_praise", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setGetValue: [BBUser getLoginString] forKey:@"login_string"];
    [request setGetValue:topicId forKey:@"topic_id"];

    ASI_DEFAULT_INFO_GET
    
    return request;

}

// 活动数据
//+ (ASIFormDataRequest *)huodongRequestWithStatr:(NSInteger)start limit:(NSInteger)limit
//{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_operation/get_exciting_activity", BABYTREE_URL_SERVER]];
//
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request setGetValue:[NSString stringWithFormat:@"%ld",(long)start] forKey:START_KEY];
//    [request setGetValue:[NSString stringWithFormat:@"%ld",(long)limit] forKey:LIMIT_KEY];
//
//    ASI_DEFAULT_INFO_GET
//
//    return request;
//
//}

// 加精话题
//+ (ASIFormDataRequest *)eliteTopicRequesWithStart:(NSInteger)start limit:(NSInteger)limit
//{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_operation/get_elite_recommend", BABYTREE_URL_SERVER]];
//
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request setPostValue:[NSString stringWithFormat:@"%ld",(long)start] forKey:START_KEY];
//    [request setPostValue:[NSString stringWithFormat:@"%ld",(long)limit] forKey:LIMIT_KEY];
//
//    ASI_DEFAULT_INFO_GET
//
//    return request;
//}

// 发现
//+ (ASIFormDataRequest *)discoverReques
//{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_operation/get_discover_page", BABYTREE_URL_SERVER]];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//
//    ASI_DEFAULT_INFO_GET
//
//    return request;
//}

// 从服务器获取辣妈达人列表
//+ (ASIFormDataRequest *)getLamaDarenData:(NSInteger)page
//{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_recommend/get_recommend_user?page=%ld&limit=20", BABYTREE_URL_SERVER, (long)page]];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//
//    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
//
//    ASI_DEFAULT_INFO_GET
//
//    return request;
//}

@end