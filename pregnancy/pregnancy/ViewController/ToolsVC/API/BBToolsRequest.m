//
//  BBToolsRequest.m
//  pregnancy
//
//  Created by liumiao on 4/25/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBToolsRequest.h"
#import "BBDeviceUtility.h"

@implementation BBToolsRequest

+ (ASIFormDataRequest *)getToolsListRequest:(NSString*)type
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_other/get_tool_list",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:type forKey:@"tool_type"];
    if([BBUser isLogin])
    {
        [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

@end
