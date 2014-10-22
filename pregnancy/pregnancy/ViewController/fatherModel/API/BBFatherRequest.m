//
//  BBFatherRequest.m
//  pregnancy
//
//  Created by songxf on 13-5-23.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBFatherRequest.h"
#import "BBUser.h"

@implementation BBFatherRequest

+ (ASIFormDataRequest *)getASIFormDataRequestWithFunctionName:(NSString *)fun_name
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_father/%@",BABYTREE_URL_SERVER,fun_name]];
    return [ASIFormDataRequest requestWithURL:url];
}

+ (ASIFormDataRequest *)bindUser:(NSString *)code;
{
    ASIFormDataRequest *request = [self getASIFormDataRequestWithFunctionName:@"bind"];
    [request setPostValue:code forKey:FATHER_CODE_KEY];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    
    ASI_DEFAULT_INFO_POST
    
    return request;
}


+ (ASIFormDataRequest *)unbindUser;
{
    ASIFormDataRequest *request = [self getASIFormDataRequestWithFunctionName:@"unbind"];
    NSString *uid= [BBUser getLoginString];
    [request setPostValue:uid forKey:LOGIN_STRING];
    [request setPostValue:FATHER_GENDER forKey:FATHER_GENDER_KEY];
    
    ASI_DEFAULT_INFO_POST
    
    return request;
}

@end