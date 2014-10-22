//
//  HMTopicDetailRequest.m
//  lama
//
//  Created by songxf on 13-12-27.
//  Copyright (c) 2013年 babytree. All rights reserved.
//
#import "HMApiRequest.h"

@implementation HMApiRequest (HMTopicDetailRequest)

//+ (ASIFormDataRequest *)requestNewTopicDetail:(NSString *)topicID withCurentPage:(NSString*)page withIsUserType:(NSString *)isType
//{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/get_topic_data", BABYTREE_URL_SERVER]];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request setGetValue:topicID forKey:@"topic_id"];
//    [request setGetValue:page forKey:@"pg"];
//    [request setGetValue:isType forKey:@"b"];
//    [request setGetValue:@"1" forKey:@"emoji"];
//    if ([BBUser isLogin])
//    {
//        [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
//    }
//    if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
//    {
//        //1为备孕状态，其它为非备孕状态
//        [request setGetValue:@"1" forKey:@"is_prepare"];
//    }
//    else
//    {
//        [request setGetValue:@"0" forKey:@"is_prepare"];
//    }
//    ASI_DEFAULT_INFO_GET
//
//    return request;
//}

+ (ASIFormDataRequest *)requestNewTopicDetail:(NSString *)topicID withCurentPage:(NSString*)page orReplyId:(NSString *) replyId withIsUserType:(NSString *)isType
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/get_topic_data", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:topicID forKey:@"topic_id"];
    [request setGetValue:page forKey:@"pg"];
    [request setGetValue:isType forKey:@"b"];
    if ([replyId isNotEmpty])
    {
        [request setGetValue:replyId forKey:@"reply_id"];
    }
    [request setGetValue:@"1" forKey:@"emoji"];
    if ([BBUser isLogin])
    {
        [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
    {
        [request setGetValue:@"1" forKey:@"is_prepare"];
    }
    else
    {
        [request setGetValue:@"0" forKey:@"is_prepare"];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)reportSendRequest:(NSString *)topicId withReplyId:(NSString *)replyID withReportType:(NSString*)reportType
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/report", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    
    if ([topicId isNotEmpty])
    {
        [request setGetValue:topicId forKey:@"discuz_id"];
    }
    else if ([replyID isNotEmpty])
    {
        [request setGetValue:replyID forKey:@"response_id"];
    }
    [request setGetValue:reportType forKey:@"type_id"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)collectTopicAction:(BOOL)theBool withTopicID:(NSString *)topicID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/fav_topic", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    if (theBool == YES)
    {
        [request setGetValue:@"add" forKey:@"act"];
    }
    else
    {
        [request setGetValue:@"del" forKey:@"act"];
    }
    [request setGetValue:topicID forKey:@"id"];
    
    ASI_DEFAULT_INFO_GET

    return request;
}

+ (ASIFormDataRequest *)delTopicAction:(NSString *)topicID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/delete",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setGetValue:topicID forKey:@"topic_id"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)delMyReply:(NSString *)replyID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/delete_reply", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:replyID forKey:@"reply_id"];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];

    ASI_DEFAULT_INFO_GET

    return request;
}

@end