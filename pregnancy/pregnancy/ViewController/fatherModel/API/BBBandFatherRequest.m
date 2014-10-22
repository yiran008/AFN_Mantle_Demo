//
//  BBBandFatherRequest.m
//  pregnancy
//
//  Created by mac on 13-5-23.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBBandFatherRequest.h"
#import "BBUser.h"
#import "BBDeviceUtility.h"
#import "BBLocation.h"

#define BBBANDFATHERREQUEST_GETBINDSTATUS   @"/api/mobile_father/bind_status"
#define BBBANDFATHERREQUEST_UNBIND          @"/api/mobile_father/unbind"

@implementation BBBandFatherRequest

+ (ASIFormDataRequest *)bindStatus
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BABYTREE_URL_SERVER, BBBANDFATHERREQUEST_GETBINDSTATUS]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"0" forKey:FATHER_GENDER_KEY];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)unBind
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BABYTREE_URL_SERVER, BBBANDFATHERREQUEST_UNBIND]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"0" forKey:FATHER_GENDER_KEY];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    
  ASI_DEFAULT_INFO_GET
    
    return request;
}

@end
