//
//  BBStatisticRequest.m
//  pregnancy
//
//  Created by liumiao on 9/12/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBStatisticRequest.h"

#import <sys/utsname.h>

@implementation BBStatisticRequest
+ (ASIFormDataRequest *)statisticRequestWithContent:(NSString *)content
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_statistics/content_click",BABYTREE_URL_SERVER]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    [request setPostValue:[self deviceModel] forKey:@"device_model"];
    [request setPostValue:content forKey:@"content"];
    if ([BBUser isLogin])
    {
        [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    
    ASI_DEFAULT_INFO_POST
    
    return request;
}

+ (NSString *)deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

@end
