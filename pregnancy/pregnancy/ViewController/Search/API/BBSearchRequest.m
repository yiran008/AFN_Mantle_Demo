//
//  BBSearchRequest.m
//  pregnancy
//
//  Created by yxy on 14-4-15.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBSearchRequest.h"

@implementation BBSearchRequest

// 搜索帖子列表
+ (ASIFormDataRequest *)searchTopicList:(NSString *)key page:(NSInteger)pg
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_search/search_topic",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[NSString stringWithFormat:@"%ld",(long)pg] forKey:@"pg"];
    [request setGetValue:key forKey:@"q"];
    
    if([BBUser isLogin])
    {
       [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    
     ASI_DEFAULT_INFO_GET
    
    return request;
}

// 搜索知识列表
+ (ASIFormDataRequest *)searchKnowledgeList:(NSString *)key page:(NSInteger)pg
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_search/search_knowledge",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[NSString stringWithFormat:@"%ld",(long)pg] forKey:@"pg"];
    [request setGetValue:key forKey:@"q"];
   
    if([BBUser isLogin])
    {
        [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

// 搜索用户列表
+ (ASIFormDataRequest *)searchUserList:(NSString *)key page:(NSInteger)pg
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_search/search_user",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[NSString stringWithFormat:@"%ld",(long)pg] forKey:@"pg"];
    [request setGetValue:key forKey:@"q"];
   
    if([BBUser isLogin])
    {
        [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}


@end
