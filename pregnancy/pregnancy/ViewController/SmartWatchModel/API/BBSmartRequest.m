//
//  BBSmartRequest.m
//  pregnancy
//
//  Created by whl on 13-11-14.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBSmartRequest.h"

@implementation BBSmartRequest

+ (ASIFormDataRequest *)smartWatchWeight:(NSString *)dateMonth
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_watch/get_report",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:@"weight" forKey:@"type"];
    [request setPostValue:dateMonth   forKey:@"date_month"];
    [request setPostValue:@"600"   forKey:@"width"];
    [request setPostValue:@"300"   forKey:@"height"];
#if USE_SMARTWATCH_MODEL
    ASI_DEFAULT_INFO_POST
#endif
    return request;
}


+ (ASIFormDataRequest *)smartWatchContraction:(NSString *)pageStr
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_watch/get_report",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:@"contraction" forKey:@"type"];
    [request setPostValue:pageStr   forKey:@"page"];
    [request setPostValue:@"600"   forKey:@"width"];
    [request setPostValue:@"300"   forKey:@"height"];
#if USE_SMARTWATCH_MODEL
    ASI_DEFAULT_INFO_POST
#endif
    return request;
}

+ (ASIFormDataRequest *)smartWatchWalk:(NSString *)dateMonth
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_watch/get_report",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:@"walk" forKey:@"type"];
    [request setPostValue:dateMonth   forKey:@"date_month"];
    [request setPostValue:@"600"   forKey:@"width"];
    [request setPostValue:@"300"   forKey:@"height"];
#if USE_SMARTWATCH_MODEL
    ASI_DEFAULT_INFO_POST
#endif
    return request;
}
+ (ASIFormDataRequest *)smartWatchFetalMove:(NSString *)dateMonth withValueType:(BOOL)isMonth
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_watch/get_report",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:@"fetalmove" forKey:@"type"];
    if (isMonth) {
        [request setPostValue:dateMonth   forKey:@"date_month"];
    }else{
        [request setPostValue:dateMonth     forKey:@"date_week"];
    }
    [request setPostValue:@"600"   forKey:@"width"];
    [request setPostValue:@"300"   forKey:@"height"];
#if USE_SMARTWATCH_MODEL
    ASI_DEFAULT_INFO_POST
#endif
    return request;
}

+ (ASIFormDataRequest *)relieveWatchBinding
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_watch/unbind",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:[BBUser smartWatchCode] forKey:@"bluetooth_mac"];
#if USE_SMARTWATCH_MODEL
    ASI_DEFAULT_INFO_POST
#endif
    return request;
}

+ (ASIFormDataRequest *)bindStatus
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_watch/get_bind_info",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
#if USE_SMARTWATCH_MODEL
    ASI_DEFAULT_INFO_POST
#endif
    return request;
}

+ (ASIFormDataRequest *)bindWatch:(NSString *)bluetoothMac
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_watch/bind",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:bluetoothMac forKey:@"bluetooth_mac"];
#if USE_SMARTWATCH_MODEL
    ASI_DEFAULT_INFO_POST
#endif
    return request;
}
@end
