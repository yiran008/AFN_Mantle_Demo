//
//  BBTaxiLocationData.m
//  pregnancy
//
//  Created by whl on 13-12-12.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBTaxiLocationData.h"
#define APP_DISCLAIMER @"appDisclaimer"
#define USER_TAXI_PHONENUMBER @"userTaxiPhoneNumber"
#define USER_CALLBACK_TIMER @"userCallBackTimer"
#define TAXI_APPLY_WORD @"taxiApplyWord"
#define TAXI_PARTNER @"taxiPartner"
#define TAXI_CURRENT_LATITUDE   @"taxiCurrentLatitude"
#define TAXI_CURRENT_LONGITUDE  @"taxiCurrentLongitude"
#define TAXI_PARTNER_TITLE @"taxiPartnerTitle"

@implementation BBTaxiLocationData

+ (void)setDisclaimerStatus:(BOOL)statusBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (statusBool == YES) {
        [defaults setObject:@"YES" forKey:APP_DISCLAIMER];
    } else {
        [defaults setObject:@"NO" forKey:APP_DISCLAIMER];
    }
    [defaults synchronize];
}

+ (BOOL)getDisclaimerStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:APP_DISCLAIMER] isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)setUserTaxiPhoneNumber:(NSString *)phoneNumber {
    if (!([phoneNumber isKindOfClass:[NSString class]] || phoneNumber == nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults setObject:phoneNumber forKey:USER_TAXI_PHONENUMBER];
}

+ (NSString *)getUserTaxiPhoneNumber {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_TAXI_PHONENUMBER];
}


+ (void)setCallBackTimerString:(NSString *)callBackTimer
{
    if (!([callBackTimer isKindOfClass:[NSString class]] || callBackTimer == nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults setObject:callBackTimer forKey:USER_CALLBACK_TIMER];
}
+ (NSString *)getCallBackTimerString{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_CALLBACK_TIMER];
}


+ (void)setAppleWordString:(NSString *)applyWord
{
    if (!([applyWord isKindOfClass:[NSString class]] || applyWord == nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults setObject:applyWord forKey:TAXI_APPLY_WORD];
}
+ (NSString *)getAppleWordString

{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:TAXI_APPLY_WORD];
}

+ (void)setTaxiPartnerData:(NSArray *)list
{
    if (!([list isKindOfClass:[NSArray class]] || list == nil)) {
        return;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault safeSetContainer:list forKey:TAXI_PARTNER];
    [userDefault synchronize];
}

+ (NSArray*)getTaxiPartnerData
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *obj = [userDefault objectForKey:TAXI_PARTNER];
    if (obj==nil||![obj isKindOfClass:[NSArray class]]) {
        return [[[NSArray alloc]init]autorelease];
    }
    return obj;
}



+ (void)setCurrentLongitudeString:(NSString *)longitude
{
    if (!([longitude isKindOfClass:[NSString class]] || longitude == nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults setObject:longitude forKey:TAXI_CURRENT_LONGITUDE];
}
+ (NSString *)getCurrentLongitudeString

{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:TAXI_CURRENT_LONGITUDE];
}

+ (void)setCurrentLatitudeString:(NSString *)latitude
{
    if (!([latitude isKindOfClass:[NSString class]] || latitude == nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults setObject:latitude forKey:TAXI_CURRENT_LATITUDE];
}
+ (NSString *)getCurrentLatitudeString

{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:TAXI_CURRENT_LATITUDE];
}

+ (void)setTaxiPartnerTitle:(NSString *)partnerTitle
{
    if (!([partnerTitle isKindOfClass:[NSString class]] || partnerTitle == nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults setObject:partnerTitle forKey:TAXI_PARTNER_TITLE];
}
+ (NSString *)getTaxiPartnerTitle

{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:TAXI_PARTNER_TITLE];
}


+ (BOOL)enableShowTaxiMainPageGuideImage
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:ENABLE_SHOW_TAXI_MAINHOME_PAGE] == nil) {
        [userDefault setObject:@"NO" forKey:ENABLE_SHOW_TAXI_MAINHOME_PAGE];
        return YES;
    }
    return NO;
}

@end
