//
//  BBUserManagement.m
//  pregnancy
//
//  Created by Jun Wang on 12-3-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBUserRequest.h"
#import "BBUser.h"
#import "BBDeviceUtility.h"
#import "BBLocation.h"
#import "NSString+MD5.h"
#import "ASIFormDataRequest+BBDebug.h"
#import <AdSupport/AdSupport.h>
#import "BBPregnancyInfo.h"
#import "BBValidateUtility.h"
#import "OpenUDID.h"
#import "BBFatherInfo.h"

@implementation BBUserRequest

+ (ASIFormDataRequest *)registerWithEmail:(NSString *)theEmail withPassword:(NSString *)thePassword withNickname:(NSString *)theNickname
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/register",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:theEmail forKey:EMAIL_KEY];
    [request setPostValue:thePassword forKey:PASSWORD_KEY];
    [request setPostValue:theNickname forKey:NICKNAME_KEY];
    if ([BBUser isCurrentUserBabyFather] && [[BBFatherInfo getFatherUID] isNotEmpty]) {
        [request setPostValue:[BBFatherInfo getFatherUID] forKey:@"father_login_string"];
         [BBFatherInfo setFatherUID:nil];
    }
    ASI_DEFAULT_INFO_POST
    
    return request;
}

+ (ASIFormDataRequest *)registerWithNumber:(NSString *)phoneNumber withPassword:(NSString *)password withRegiterCode:(NSString *)registerCode
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/phone_number_register",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:phoneNumber forKey:PHONE_NUMBER_KEY];
    [request setPostValue:password forKey:PASSWORD_KEY];
    [request setPostValue:registerCode forKey:PHONE_REGISRER_KEY];
    if ([BBUser isCurrentUserBabyFather] && [[BBFatherInfo getFatherUID] isNotEmpty]) {
        [request setPostValue:[BBFatherInfo getFatherUID] forKey:@"father_login_string"];
        [BBFatherInfo setFatherUID:nil];
    }
    
    ASI_DEFAULT_INFO_POST
    
    return request;
}

+ (ASIFormDataRequest *)registerNicknameCheck:(NSString *)theNickname
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/user_register_check",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:theNickname forKey:NICKNAME_KEY];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)registerEmailCheck:(NSString *)theEmail
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/user_register_check",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:theEmail forKey:EMAIL_KEY];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}
+ (ASIFormDataRequest *)registerNumberCheck:(NSString *)phoneNumber
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/user_register_check",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:phoneNumber forKey:PHONE_NUMBER_KEY];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)modifyUserInfo:(NSString *)addressCity 
{  
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/set_user_info",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    if ([addressCity length] != 0) {
        [request setPostValue:addressCity forKey:@"location"];
    }
    
    ASI_DEFAULT_INFO_POST
    
    return request;
}

+ (ASIFormDataRequest *)modifyUserInfoGender:(NSString *)gender
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/set_user_info",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    if ([gender length] != 0) {
        [request setPostValue:gender forKey:@"gender"];
    }
    
    ASI_DEFAULT_INFO_POST
    
    return request;
}

+ (ASIFormDataRequest *)modifyUserInfoNickName:(NSString *)nickName
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/set_user_info",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    if ([nickName length] != 0) {
        [request setPostValue:nickName forKey:@"nickname"];
    }
    
    ASI_DEFAULT_INFO_POST
    
    return request;
}


+ (ASIFormDataRequest *)modifyUserDueDate:(NSDate *)theDueDate
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/set_user_info",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy'-'M'-'d"];
    [request setPostValue:[dateFormatter stringFromDate:theDueDate] forKey:@"baby_birthday"];
    
    ASI_DEFAULT_INFO_POST
    
    return request;
}

+ (ASIFormDataRequest *)statisticsDueDate:(NSDate *)theDueDate
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_statistics/update_user_status",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBUser isLogin]) {
        [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy'-'M'-'d"];
    [request setPostValue:[dateFormatter stringFromDate:theDueDate] forKey:@"baby_birthday"];
    
    ASI_DEFAULT_INFO_POST
    
    return request;
}

+ (ASIFormDataRequest *)pregnancyCookie
{    
    ASIFormDataRequest *request;
    
    if ([BBUser localCookie]==nil) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/check_login_by_login_string",BABYTREE_URL_SERVER]];
        request = [ASIFormDataRequest requestWithURL:url];
        [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    }
    else {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/check_login_by_cookie",BABYTREE_URL_SERVER]];
        request = [ASIFormDataRequest requestWithURL:url];
        [request setGetValue:[BBUser localCookie] forKey:COOKIE];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)getUserDueDate
{
    NSString *userInfo = @"babybirthday";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/get_user_info",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getEncId] forKey:@"enc_user_id"];
    [request setGetValue:userInfo forKey:@"data_types"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)adverteActivateByLimei
{
    NSString *adverteMD = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
         adverteMD = [NSString stringWithFormat:@"%@%@",[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],@"pregnancy_limei_babytree+20131014"];
    }else{
        adverteMD = [NSString stringWithFormat:@"%@%@",[BBDeviceUtility macAddress],@"pregnancy_limei_babytree+20131014"];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/advertising/activate",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:@"pregnancy" forKey:@"app_id"];
    [request setGetValue:[adverteMD MD5] forKey:@"enc_udid"];
    [request setGetValue:@"limei" forKey:@"source"];
    [request setGetValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];
    return request;
}

+ (ASIFormDataRequest *)adverteActivateByDomob
{
    NSString *adverteMD = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        adverteMD = [NSString stringWithFormat:@"%@%@",[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],@"pregnancy_domob_babytree+20131014"];
    }else{
        adverteMD = [NSString stringWithFormat:@"%@%@",[BBDeviceUtility macAddressWithColon],@"pregnancy_domob_babytree+20131014"];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/advertising/activate",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:@"pregnancy" forKey:@"app_id"];
    [request setGetValue:[adverteMD MD5] forKey:@"enc_udid"];
    [request setGetValue:@"domob" forKey:@"source"];
    [request setGetValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];
    return request;
}

+ (ASIFormDataRequest *)getPhoneRegisterCode:(NSString*)phoneNumber
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/get_register_code",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:@"auth_code" forKey:ACTION_KEY];
    [request setGetValue:phoneNumber forKey:PHONE_NUMBER_KEY];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)getPhoneRegisterSMSCode:(NSString*)phoneNumber withValidate:(NSString*)validate
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/get_register_code",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:@"message_code" forKey:ACTION_KEY];
    [request setGetValue:phoneNumber forKey:PHONE_NUMBER_KEY];
    [request setGetValue:validate forKey:@"auth_code"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)getUserInfoWithID:(NSString *)userID param:(NSMutableString *)param
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/get_user_info",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    if ([userID isEqualToString:[BBUser getEncId]])
    {
        //对于个人获取收藏帖子数
        [param appendString:@",collection_count"];
        
    }else {
        [request setPostValue:userID forKey:@"enc_user_id"];
    }
    
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:param forKey:@"data_types"];
    
    ASI_DEFAULT_INFO_POST
    
    return request;
}

+ (ASIFormDataRequest *)reportSendRequest:(NSString *)topicId withReplyId:(NSString *)replyID withReportType:(NSString*)reportType
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/report", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    
    if ([topicId isNotEmpty])
    {
        [request setGetValue:topicId forKey:@"discuz_id"];
    }
    else if ([replyID isNotEmpty])
    {
        [request setGetValue:replyID forKey:@"response_id"];
    }
    [request setGetValue:reportType forKey:@"type_id"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)babyboxUserID:(NSString *)userId withPhoneNumber:(NSString *)phoneNumber
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/babybox/create", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:userId forKey:LOGIN_STRING_KEY];
    [request setGetValue:phoneNumber forKey:@"phone_number"];
    ASI_DEFAULT_INFO_GET
    return request;
}

@end
