//
//  BBMessageRequest.m
//  pregnancy
//
//  Created by Jun Wang on 12-4-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBMessageRequest.h"
#import "BBDeviceUtility.h"

@implementation BBMessageRequest

+ (ASIFormDataRequest *)numberOfUnreadMessage
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/session_message/get_user_unread_message_count",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)topicMsgListWithStart:(NSInteger)start withLimit:(NSInteger)limit
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/session_message/get_user_notice_list",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setGetValue:[NSString stringWithFormat:@"%d", start] forKey:@"start"];
    [request setGetValue:[NSString stringWithFormat:@"%d", limit] forKey:@"limit"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)sendMessage:(NSString *)theUID withMessageContent:(NSString *)theMessageContent;
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/session_message/send_user_message",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:theMessageContent forKey:MESSAGE_CONTENT_KEY];
    [request setPostValue:theUID forKey:MESSAGE_USER_ENCODE_ID_KEY];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    
    ASI_DEFAULT_INFO_POST
    
    return request;
}

+ (ASIFormDataRequest *)userChatInfoUserEncodeId:(NSString *)userEncodeId withStart:(NSInteger)start withLimit:(NSInteger)limit
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/session_message/message_list",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:userEncodeId forKey:USER_ENCODE_ID_KEY];
    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setGetValue:[NSString stringWithFormat:@"%d", start] forKey:START_KEY];
    [request setGetValue:[NSString stringWithFormat:@"%d", limit] forKey:LIMIT_KEY];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)userChatUserList{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/session_message/user_list",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setGetValue:[NSString stringWithFormat:@"%d", 0] forKey:START_KEY];
    [request setGetValue:[NSString stringWithFormat:@"%d", 100] forKey:LIMIT_KEY];
    
    ASI_DEFAULT_INFO_GET
    
    return request;

}
+ (ASIFormDataRequest *)deleteChatInfoMessages:(NSString *)messageIds
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/session_message/del_message",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    
    [request setGetValue:messageIds forKey:@"message_ids"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}


+ (ASIFormDataRequest *)deleteUserChatUserList:(NSString *)userEncodeID{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/session_message/del_all_user_message",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setGetValue:userEncodeID forKey:@"user_encode_id"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
    
}

+ (ASIFormDataRequest *)uploadLogToBabytree:(NSString *)refcode
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://log.babytree.com/rd/rd.php?refcode=%@", refcode]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)feedListwithStart:(NSInteger)page withEndTime:(NSString *)theEndTime
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_newevent/get_events", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    [request setGetValue:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"pg"];
    [request setGetValue:[NSString stringWithFormat:@"%d", 20] forKey:@"limit"];
    [request setPostValue:[BBUser getLoginString] forKey:@"login_string"];
    [request setGetValue: theEndTime forKey:@"end_ts"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

@end