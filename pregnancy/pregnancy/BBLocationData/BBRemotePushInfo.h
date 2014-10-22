//
//  BBDeviceInfo.h
//  parenting
//
//  Created by Wang Jun on 12-9-19.
//  Copyright (c) 2012年 Babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBRemotePushInfo : NSObject

//用户设备Token信息
+ (NSString *)getUserDeviceToken;
+ (void)setUserDeviceToken:(NSString *)theToken;
//是否注册苹果APNS服务器
+ (BOOL)isRegisterPushToApple;
+ (void)setIsRegisterPushToApple:(BOOL)theBOOL;
//是否注册宝宝树推送服务器
+ (BOOL)isRegisterPushToBabytree;
+ (void)setIsRegisterPushToBabytree:(BOOL)theBOOL;

@end
