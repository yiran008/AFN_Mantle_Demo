//
//  AFNRequest.m
//  afn_mantle_overcoat
//
//  Created by liumiao on 10/24/14.
//  Copyright (c) 2014 liumiao. All rights reserved.
//

#import "AFNRequest.h"


#define BABYTREE_URL @"http://www.babytree.com"


@implementation AFNRequest

#pragma mark- 初始化实例方法
/*
 +(AFHTTPRequestOperationManager*)afnManagerWithBaseURL:(NSString *)baseURL
 +(AFHTTPRequestOperationManager*)babytreeManager
 ...
 这几个初始化方法也可以写成宏，不过更推荐写成方法（swift你懂的）
 这几个方法不推荐公开，推荐为每一个api写一个方法，期望对外公开的只是一个API方法列表
 */
+(BBHTTPRequestOperationManager*)afnManagerWithBaseURL:(NSString *)baseURL
{
    //该处可以针对baseURL做一些判断，空，非法等
    BBHTTPRequestOperationManager* manager = [[BBHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:baseURL]];
    return manager;
}

+(BBHTTPRequestOperationManager*)babytreeManager
{
    return [self afnManagerWithBaseURL:BABYTREE_URL];
}


#pragma mark- API列表

+(BBHTTPRequestOperationManager*)api_UserNameSearchParam:(NSDictionary*)param completion:(AFNCompletionBlock)completion
{
    BBHTTPRequestOperationManager* manager = [self babytreeManager];
    [manager GET:@"api/mobile_search/search_user" parameters:param
      completion:completion];
    return manager;
}



@end
