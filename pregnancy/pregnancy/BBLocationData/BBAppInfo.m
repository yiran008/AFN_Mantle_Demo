//
//  BBAppInfo.m
//  pregnancy
//
//  Created by Wang Jun on 12-9-13.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBAppInfo.h"
//#import "BBTopicDB.h"
#import "BBPregnancyInfo.h"
//#import "BBHospitalRequest.h"
#import "BBUser.h"
#import "MobClick.h"



#define REGISTER_LOCATION_LAUNCH_APP @"needRegisterNoticeLocationLaunchAPP"

#define REGISTER_LOCATION_BABYBORN @"needRegisterNoticeLocationBabyBorn"

#define PREGNANCY_APP_CURRENT_VERSION @"pregnancyAppCurrentVersion"


@implementation BBAppInfo

+ (BOOL)enableScore
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![[userDefault objectForKey:ENABLE_SCORE_KEY] isEqualToString:@"NO"]) {
        if ([[MobClick getConfigParams:@"evaluate"] isEqualToString:@"on"]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

+ (void)setEnableScoreToNO
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"NO" forKey:ENABLE_SCORE_KEY];
}

+ (BOOL)enableShowHomePageGuideImage
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:ENABLE_SHOW_HOME_PAGE] == nil) {
        [userDefault setObject:@"NO" forKey:ENABLE_SHOW_HOME_PAGE];
        return YES;
    }
    return NO;
}

+ (BOOL)enableShowCommunityMainPageGuideImage
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:ENABLE_SHOW_COMMUNITY_MAIN] == nil) {
        [userDefault setObject:@"NO" forKey:ENABLE_SHOW_COMMUNITY_MAIN];
        return YES;
    }
    return NO;
}

+ (BOOL)enableShowCommunityAddPageGuideImage
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:ENABLE_SHOW_COMMUNITY_ADD] == nil) {
        [userDefault setObject:@"NO" forKey:ENABLE_SHOW_COMMUNITY_ADD];
        return YES;
    }
    return NO;
}

+ (BOOL)enableShowPersonalPageGuideImage
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:ENABLE_SHOW_PERSONAL_PAGE] == nil) {
        [userDefault setObject:@"NO" forKey:ENABLE_SHOW_PERSONAL_PAGE];
        return YES;
    }
    return NO;
}

+ (BOOL)enableShowTopicPageGuideImage
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:ENABLE_SHOW_TOPIC_PAGE] == nil) {
        [userDefault setObject:@"NO" forKey:ENABLE_SHOW_TOPIC_PAGE];
        return YES;
    }
    return NO;
}

+ (BOOL)enableShowForumPageGuideImage
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:ENABLE_SHOW_FORUM_PAGE] == nil) {
        [userDefault setObject:@"NO" forKey:ENABLE_SHOW_FORUM_PAGE];
        return YES;
    }
    return NO;
}

+ (BOOL)enableShowCreateTopicPageGuideImage
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:ENABLE_SHOW_CREATE_PAGE] == nil) {
        [userDefault setObject:@"NO" forKey:ENABLE_SHOW_CREATE_PAGE];
        return YES;
    }
    return NO;
}

+ (BOOL)enableShowReplyTopicPageGuideImage
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:ENABLE_SHOW_REPLY_PAGE] == nil) {
        [userDefault setObject:@"NO" forKey:ENABLE_SHOW_REPLY_PAGE];
        return YES;
    }
    return NO;
}

+ (BOOL)enableShowSwitchParentingGuideImage
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:ENABLE_SHOW_SWITCH_PARENTING] == nil) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)setEnableShowSwitchParentingGuide:(BOOL)theBool
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (theBool) {
        [userDefault setObject:@"YES" forKey:ENABLE_SHOW_SWITCH_PARENTING];
    } else {
        [userDefault setObject:@"NO" forKey:ENABLE_SHOW_SWITCH_PARENTING];
    }
}

+ (BOOL)isFirstLaunch
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:IS_FIRST_LAUNCH_KEY] == nil) {
        [userDefault setObject:@"NO" forKey:IS_FIRST_LAUNCH_KEY];
        return YES;
    }
    return NO;
}

+ (void)setNeedDownloadBannerData:(BOOL)theBool
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:theBool forKey:NEED_DOWNLOAD_BANNER_DATA];
    [userDefault synchronize];
}

+ (BOOL)needDownloadBannerData
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:NEED_DOWNLOAD_BANNER_DATA];
}

+ (BOOL)enableShowSkipSelectHospital
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:ENABLE_SHOW_SKIP_HOSPITAL_SETTING] == nil) {
        [userDefault setObject:@"NO" forKey:ENABLE_SHOW_SKIP_HOSPITAL_SETTING];
        return YES;
    }
    return NO;
}

+ (BOOL)enableShowSettingHospitalRemind
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
   // if ([userDefault objectForKey:ENABLE_SHOW_SETTING_HOSPITAL_REMIND] == nil && [BBPregnancyInfo daysOfPregnancy] >= 12*7 && [BBHospitalRequest getHospitalCategory] == nil && [BBUser isLogin]) {
        [userDefault setObject:@"NO" forKey:ENABLE_SHOW_SETTING_HOSPITAL_REMIND];
        return YES;
   // }
   // return NO;
}

+ (void)setEnableShowVersionUpdateGuideImage:(BOOL)guideStatus
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (guideStatus) {
        [userDefault setObject:@"YES" forKey:ENABLE_SHOW_VERSION_UPDATE_GUIDE_IMAGE];
    } else {
        [userDefault setObject:@"NO" forKey:ENABLE_SHOW_VERSION_UPDATE_GUIDE_IMAGE];
    }
}

+ (BOOL)enableShowVersionUpdateGuideImage
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:ENABLE_SHOW_VERSION_UPDATE_GUIDE_IMAGE] == nil || [[userDefault objectForKey:ENABLE_SHOW_VERSION_UPDATE_GUIDE_IMAGE]isEqualToString:@"NO"]) {
        return NO;
    }
    return YES;
    
}

+ (BOOL)enableShowLocalNotificationSwitchParenting
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:ENABLE_REGISTER_SWITCH_PARETING_LOCAL_NOTIFICATION] == nil) {
        [userDefault setObject:@"NO" forKey:ENABLE_REGISTER_SWITCH_PARETING_LOCAL_NOTIFICATION];
        return YES;
    }
    return NO;
}

+ (void)setNightModeStatus:(BOOL)nightModeStatus{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (nightModeStatus) {
        [userDefault setObject:@"YES" forKey:NIFHR_MODE_STATUS];
    } else {
        [userDefault setObject:@"NO" forKey:NIFHR_MODE_STATUS];
    }
}

+ (BOOL)nightModeStatus{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:NIFHR_MODE_STATUS] == nil || [[userDefault objectForKey:NIFHR_MODE_STATUS]isEqualToString:@"NO"]) {
        return NO;
    }
    return YES;
}

+ (void)setGoScoreStatus:(BOOL)goScoreStatus{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (goScoreStatus) {
        [userDefault setObject:@"YES" forKey:GO_SCORE_STATUS];
    } else {
        [userDefault setObject:@"NO" forKey:GO_SCORE_STATUS];
    }
}

+ (BOOL)goScoreStatus{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:GO_SCORE_STATUS] == nil || [[userDefault objectForKey:GO_SCORE_STATUS]isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)enableQuechao
{
    if ([[MobClick getConfigParams:@"quechao"] isEqualToString:@"off"])
    {
        return NO;
    }
    else
    {
        return YES;
    }
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

+ (NSString *)getCurrentVersion
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return currentVersion;
}

+ (BOOL)needUpdateNewVersion
{
    NSString *currentVersion = [self getCurrentVersion];
    NSString *appVersion = [self getAppStoreVersion];
    if ([appVersion compare:currentVersion options:NSCaseInsensitiveSearch] == NSOrderedDescending)
    {// 降序有更新
        return YES;
    }
    return NO;
}

+ (NSString *)getAppStoreVersion
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *cache = nil;
    cache = [defaults objectForKey:@"version_appstore_pregnancy"];
    if ([cache isNotEmpty])
    {
        return cache;
    }
    else
    {
        NSString *currentVersion = [self getCurrentVersion];
        [self setAppStoreVersion:currentVersion];
        return currentVersion;
    }
}

+ (void)setAppStoreVersion:(NSString *)version
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:version forKey:@"version_appstore_pregnancy"];
    [defaults synchronize];
}

+ (void)setRemoteNotificationType
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"hasSetRemoteNotification"] isNotEmpty]) {
        
    }else {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        NSString *remoteType = [NSString stringWithFormat:@"%d",type];
        [defaults setObject:remoteType forKey:@"hasSetRemoteNotification"];
//        if (type == 4) {
//        }else {
//        }
    }
}


+ (BOOL)needRegisterNoticeLocationLaunchAPP
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:REGISTER_LOCATION_LAUNCH_APP] == nil) {
        [userDefault setObject:@"NO" forKey:REGISTER_LOCATION_LAUNCH_APP];
        return YES;
    }
    return NO;
}


+ (BOOL)needRegisterNoticeLocationBabyBorn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:REGISTER_LOCATION_BABYBORN] isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)setRegisterNoticeLocationBabyBorn:(BOOL)noticeBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (noticeBool == YES) {
        [defaults setObject:@"YES" forKey:REGISTER_LOCATION_BABYBORN];
    } else {
        [defaults setObject:@"NO" forKey:REGISTER_LOCATION_BABYBORN];
    }
    [defaults synchronize];
}

+(void)setAppCurrentVersion
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    if (currentVersion)
    {
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:PREGNANCY_APP_CURRENT_VERSION];
        [[NSUserDefaults standardUserDefaults] synchronize];   
    }
}

+(NSString*)getAPPCurrentVersion
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:PREGNANCY_APP_CURRENT_VERSION];
}
@end
