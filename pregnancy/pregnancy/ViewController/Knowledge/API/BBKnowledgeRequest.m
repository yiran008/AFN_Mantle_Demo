//
//  BBKnowledgeRequest.m
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBKnowledgeRequest.h"

@implementation BBKnowledgeRequest
+ (ASIFormDataRequest *)collectKnowledgeWithID:(NSString *)ID isDelete:(BOOL)isDelete
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_knowledge/collect_knowledge",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBUser isLogin]) {
        [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    if (ID) {
        [request setGetValue:ID forKey:@"knowledge_id"];
        [request setGetValue:isDelete?@"delete":@"add" forKey:@"action"];
    }
    ASI_DEFAULT_INFO_GET
    [request setGetValue:@"pregnancy" forKey:@"app_id"];
    return request;
}

+ (ASIFormDataRequest *)getCollectedWithID:(NSString *)ID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_knowledge/collect_status",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBUser isLogin]) {
        [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    if (ID) {
        [request setGetValue:ID forKey:@"knowledge_id"];
    }
    ASI_DEFAULT_INFO_GET
    [request setGetValue:@"pregnancy" forKey:@"app_id"];
    return request;
}
@end
