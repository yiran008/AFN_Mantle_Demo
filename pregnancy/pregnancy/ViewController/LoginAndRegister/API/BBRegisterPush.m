//
//  BBRegisterPush.m
//  pregnancy
//
//  Created by Jun Wang on 12-5-17.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBRegisterPush.h"
#import "BBUser.h"
#import "BBDeviceUtility.h"
#import "BBLocation.h"
#import "ASIFormDataRequest+BBDebug.h"

@implementation BBRegisterPush

+ (ASIFormDataRequest *)registerPushNofitycation:(NSString *)deviceToken
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_info/set_apn",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBUser isLogin] == YES)
    {
        [request setPostValue:[BBUser getLoginString] forKey:@"token"];
    }
    else
    {
        [request setPostValue:@"u1591872179_5d683f29950827bd702728288de7aa26_1337249944" forKey:@"token"];
    }
    [request setPostValue:deviceToken forKey:@"apn_token"];
    ASI_DEFAULT_INFO_POST
    return request;
}

@end
