//
//  BBThirdUserRequest.m
//  pregnancy
//
//  Created by 柏旭 肖 on 12-7-5.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBThirdUserRequest.h"
#import "BBLocation.h"
#import "BBDeviceUtility.h"
#import "ASIFormDataRequest+BBDebug.h"
#import "BBUser.h"
#import "BBFatherInfo.h"

@implementation BBThirdUserRequest

+ (ASIFormDataRequest *)thirdPartLogin:(NSString *)authToken withType:(NSString *)authType withUID:(NSString *)uid
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/third_part_login",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:authToken forKey:@"token"];
    [request setPostValue:authType forKey:@"type"];
    [request setPostValue:uid forKey:@"open_id"];
    if ([BBUser isCurrentUserBabyFather] && [[BBFatherInfo getFatherUID] isNotEmpty])
    {
        [request setPostValue:[BBFatherInfo getFatherUID] forKey:@"father_login_string"];
         [BBFatherInfo setFatherUID:nil];
    }
     ASI_DEFAULT_INFO_POST
    
    return request;
}

+ (ASIFormDataRequest *)thirdPartBindingNewUser:(NSString *)authToken withType:(NSString *)authType withNickname:(NSString *)name withEmail:(NSString *)email withBabyBirthday:(NSString *)babyBirthday withUID:(NSString *)uid
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/third_part_reg",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:authToken forKey:@"token"];
    [request setPostValue:authType forKey:@"type"];
    [request setPostValue:name forKey:@"nickname"];
    [request setPostValue:email forKey:@"email"];
    [request setPostValue:uid forKey:@"open_id"];
    [request setPostValue:babyBirthday forKey:@"babybirthday_ts"];
    if ([BBUser isCurrentUserBabyFather] && [[BBFatherInfo getFatherUID] isNotEmpty])
    {
        [request setPostValue:[BBFatherInfo getFatherUID] forKey:@"father_login_string"];
         [BBFatherInfo setFatherUID:nil];
    }
     ASI_DEFAULT_INFO_POST
    
    return request;
}

@end
