//
//  BBLoginAndRegisterRequest.m
//  pregnancy
//
//  Created by whl on 14-4-8.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBLoginAndRegisterRequest.h"
#import "BBUser.h"
#import "BBFatherInfo.h"

@implementation BBLoginAndRegisterRequest

+ (ASIFormDataRequest *)loginWithEmail:(NSString *)theEmail withPassword:(NSString *)thePassword
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/login",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBValidateUtility checkPhoneNumInput:theEmail])
    {
        [request setPostValue:theEmail forKey:PHONE_NUMBER_KEY];
    }
    else
    {
        [request setPostValue:theEmail forKey:EMAIL_KEY];
    }
    [request setPostValue:thePassword forKey:PASSWORD_KEY];
    
    if ([BBUser isCurrentUserBabyFather] && [[BBFatherInfo getFatherUID] isNotEmpty])
    {
        [request setPostValue:[BBFatherInfo getFatherUID] forKey:@"father_login_string"];
         [BBFatherInfo setFatherUID:nil];
    }
    
    ASI_DEFAULT_INFO_POST
    
    return request;
}

@end
