//
//  BBApp.h
//  pregnancy
//
//  Created by 柏旭 肖 on 12-5-31.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest+BBDebug.h"

@interface BBApp : NSObject

+ (void)setProjectCategory:(NSString *)theCategory;
+ (NSString *)getProjectCategory;

+ (void)setEnableInputInviteCode:(BOOL)theBool;
+ (BOOL)enableInputInviteCode;


+ (BOOL)getAdvertisingByLimeiStatus;
+ (void)setAdvertisingByLimeiStatus:(BOOL)statusBool;
+ (BOOL)getAdvertisingByDomobStatus;
+ (void)setAdvertisingByDomobStatus:(BOOL)statusBool;

+ (void)setAppLaunchStatus:(BOOL)statusBool;
+ (BOOL)getAppLaunchStatus;

@end
