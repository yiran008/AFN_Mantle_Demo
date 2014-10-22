//
//  BBUserManagement.h
//  pregnancy
//
//  Created by Jun Wang on 12-3-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest+BBDebug.h"
#import "BBConfigureAPI.h"

@interface BBUserRequest : NSObject

+ (ASIFormDataRequest *)registerWithEmail:(NSString *)theEmail withPassword:(NSString *)thePassword withNickname:(NSString *)theNickname;

+ (ASIFormDataRequest *)registerNicknameCheck:(NSString *)theNickname;
+ (ASIFormDataRequest *)registerEmailCheck:(NSString *)theEmail;

+ (ASIFormDataRequest *)modifyUserInfo:(NSString *)addressCity;

+ (ASIFormDataRequest *)modifyUserDueDate:(NSDate *)theDueDate;

+ (ASIFormDataRequest *)modifyUserDueDate:(NSDate *)theDueDate changeToStatus:(NSString*)babyStatus;

+ (ASIFormDataRequest *)statisticsDueDate:(NSDate *)theDueDate;

+ (ASIFormDataRequest *)pregnancyCookie;

+ (ASIFormDataRequest *)modifyUserInfoGender:(NSString *)gender;

+ (ASIFormDataRequest *)modifyUserInfoNickName:(NSString *)nickName;

+ (ASIFormDataRequest *)getUserDueDate;

//力美广告对接
+ (ASIFormDataRequest *)adverteActivateByLimei;
//多盟广告对接
+ (ASIFormDataRequest *)adverteActivateByDomob;

//验证手机号
+ (ASIFormDataRequest *)registerNumberCheck:(NSString *)phoneNumber;

//手机注册
+ (ASIFormDataRequest *)registerWithNumber:(NSString *)phoneNumber withPassword:(NSString *)password withRegiterCode:(NSString *)registerCode;
//获取注册码
+ (ASIFormDataRequest *)getPhoneRegisterCode:(NSString*)phoneNumber;

+ (ASIFormDataRequest *)getPhoneRegisterSMSCode:(NSString*)phoneNumber withValidate:(NSString*)validate;

+ (ASIFormDataRequest *)getUserInfoWithID:(NSString *)userID param:(NSMutableString *)param;

+ (ASIFormDataRequest *)reportSendRequest:(NSString *)topicId withReplyId:(NSString *)replyID withReportType:(NSString*)reportType;

+ (ASIFormDataRequest *)babyboxUserID:(NSString *)userId withPhoneNumber:(NSString *)phoneNumber;

@end
