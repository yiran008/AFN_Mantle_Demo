//
//  BBUpdataRequest.m
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBUpdataRequest.h"

@implementation BBUpdataRequest
+ (ASIFormDataRequest *)updataKnowledgeWithTS:(NSString *)ts
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_knowledge/sync_knowledge",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBUser isLogin]) {
        [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    if (ts) {
        [request setGetValue:ts forKey:@"update_ts"];
    }else
    {
        [request setGetValue:@"0" forKey:@"update_ts"];
    }
    ASI_DEFAULT_INFO_GET
    [request setGetValue:@"pregnancy" forKey:@"app_id"];
    return request;
}
@end
