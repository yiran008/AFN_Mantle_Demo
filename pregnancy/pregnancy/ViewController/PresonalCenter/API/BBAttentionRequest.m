//
//  BBAttentionRequest.m
//  pregnancy
//
//  Created by MacBook on 14-9-1.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBAttentionRequest.h"

@implementation BBAttentionRequest

// 添加关注
+ (ASIFormDataRequest *)addFollow:(NSString *)u_id
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_follow/follow_user",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    
    if (u_id != nil)
    {
        [request setGetValue:u_id forKey:@"f_uid"];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

// 取消关注
+ (ASIFormDataRequest *)cancelFollow:(NSString *)u_id
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_follow/cancer_follow",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    
    if (u_id != nil)
    {
        [request setGetValue:u_id forKey:@"f_uid"];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}


// 关注列表
+ (ASIFormDataRequest *)getFollowingList:(NSString *)u_id page:(NSInteger)pg limit:(NSInteger)limit
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_follow/get_following_list",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setGetValue:[NSString stringWithFormat:@"%ld",(long)pg] forKey:@"pg"];
    [request setGetValue:[NSString stringWithFormat:@"%ld",(long)limit] forKey:@"limit"];
    
    if (u_id != nil)
    {
        [request setGetValue:u_id forKey:@"enc_user_id"];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

// 粉丝列表
+ (ASIFormDataRequest *)getFollowedList:(NSString *)u_id page:(NSInteger)pg limit:(NSInteger)limit
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_follow/get_followed_list",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setGetValue:[NSString stringWithFormat:@"%ld",(long)pg] forKey:@"pg"];
    [request setGetValue:[NSString stringWithFormat:@"%ld",(long)limit] forKey:@"limit"];
    
    if (u_id != nil)
    {
        [request setGetValue:u_id forKey:@"enc_user_id"];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

@end
