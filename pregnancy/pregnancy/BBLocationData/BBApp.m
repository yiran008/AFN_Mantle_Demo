//
//  BBApp.m
//  pregnancy
//
//  Created by 柏旭 肖 on 12-5-31.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBApp.h"
#import "BBConfigureAPI.h"
#import "BBDeviceUtility.h"

#define APP_PROJECT_CATEGORY @"appProjectCategory"

#define APP_ENABLE_INPUT_INVITE_CODE @"appEnableInputInviteCode"

#define APP_ADVERTE_ACTIVATE_BY_LIMEI @"AppAdverteActivateByLimei"

#define APP_ADVERTE_ACTIVATE_BY_DOMOB @"AppAdverteActivateByDomob"

#define APP_LAUNCH_STATUS @"appLaunchStatus"

@implementation BBApp

+ (void)setProjectCategory:(NSString *)theCategory
{
    if (!([theCategory isKindOfClass:[NSString class]] || theCategory == nil)) {
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:theCategory forKey:APP_PROJECT_CATEGORY];
    [userDefaults synchronize];
}

+ (NSString *)getProjectCategory
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:APP_PROJECT_CATEGORY] == nil) {
        return @"0";
    } else {
        return [userDefaults objectForKey:APP_PROJECT_CATEGORY];
    }
}

+ (void)setEnableInputInviteCode:(BOOL)theBool
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:theBool forKey:APP_ENABLE_INPUT_INVITE_CODE];
}

+ (BOOL)enableInputInviteCode
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:APP_ENABLE_INPUT_INVITE_CODE];
}

+ (void)setAdvertisingByLimeiStatus:(BOOL)statusBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (statusBool == YES) {
        [defaults setObject:@"YES" forKey:APP_ADVERTE_ACTIVATE_BY_LIMEI];
    } else {
        [defaults setObject:@"NO" forKey:APP_ADVERTE_ACTIVATE_BY_LIMEI];
    }
    [defaults synchronize];

}

+ (BOOL)getAdvertisingByLimeiStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:APP_ADVERTE_ACTIVATE_BY_LIMEI] isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)setAdvertisingByDomobStatus:(BOOL)statusBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (statusBool == YES) {
        [defaults setObject:@"YES" forKey:APP_ADVERTE_ACTIVATE_BY_DOMOB];
    } else {
        [defaults setObject:@"NO" forKey:APP_ADVERTE_ACTIVATE_BY_DOMOB];
    }
    [defaults synchronize];
    
}

+ (BOOL)getAdvertisingByDomobStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:APP_ADVERTE_ACTIVATE_BY_DOMOB] isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)setAppLaunchStatus:(BOOL)statusBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (statusBool == YES) {
        [defaults setObject:@"YES" forKey:APP_LAUNCH_STATUS];
    } else {
        [defaults setObject:@"NO" forKey:APP_LAUNCH_STATUS];
    }
    [defaults synchronize];
    
}

+ (BOOL)getAppLaunchStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:APP_LAUNCH_STATUS] isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

@end
