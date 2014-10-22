//
//  BBAppInfo.h
//  pregnancy
//
//  Created by Wang Jun on 12-9-13.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBGuideDB.h"
#define ENABLE_SCORE_KEY @"enableScoreKey"

#define ENABLE_SHOW_PERSONAL_PAGE @"enableShowPersonalPage"
#define ENABLE_SHOW_FORUM_PAGE @"enableShowForumPage"
#define ENABLE_SHOW_CREATE_PAGE @"enableShowCreatePage"
#define ENABLE_SHOW_REPLY_PAGE @"enableShowReplyPage"
#define ENABLE_SHOW_SWITCH_PARENTING @"enableShowSwitchParenting"

#define ENABLE_UPDATE_TOPIC_COLLECT @"enableUpdateTopicCollect"
#define IS_FIRST_LAUNCH_KEY @"isFirstLaunchKey"
#define NEED_DOWNLOAD_BANNER_DATA @"needDownloadBannerData"

#define ENABLE_SHOW_SKIP_HOSPITAL_SETTING @"enableShowSkipHospitalSetting"

#define ENABLE_SHOW_SETTING_HOSPITAL_REMIND @"enalbeShowSettingHospitalRemind"

#define ENABLE_SHOW_VERSION_UPDATE_GUIDE_IMAGE @"enableShowVersionUpdateGuideImage"
#define ENABLE_REGISTER_SWITCH_PARETING_LOCAL_NOTIFICATION @"enableRegisterSwitchParentingLocalNotification"

#define NIFHR_MODE_STATUS @"nightModeStatus"
#define GO_SCORE_STATUS @"goScoreStatus"

#define ACTION_DATA @"actionData"

@interface BBAppInfo : NSObject

+ (BOOL)enableScore;

+ (void)setEnableScoreToNO;

+ (BOOL)enableShowHomePageGuideImage;

+ (BOOL)enableShowPersonalPageGuideImage;

+ (BOOL)enableShowTopicPageGuideImage;

+ (BOOL)enableShowForumPageGuideImage;

+ (BOOL)enableShowCreateTopicPageGuideImage;

+ (BOOL)enableShowReplyTopicPageGuideImage;

+ (BOOL)enableShowSwitchParentingGuideImage;

+ (void)setEnableShowSwitchParentingGuide:(BOOL)theBool;

+ (BOOL)isFirstLaunch;

+ (void)setNeedDownloadBannerData:(BOOL)theBool;

+ (BOOL)needDownloadBannerData;

+ (BOOL)enableShowSkipSelectHospital;

+ (BOOL)enableShowSettingHospitalRemind;


+ (void)setEnableShowVersionUpdateGuideImage:(BOOL)guideStatus;
+ (BOOL)enableShowVersionUpdateGuideImage;

+ (BOOL)enableShowLocalNotificationSwitchParenting;

+ (void)setNightModeStatus:(BOOL)nightModeStatus;

+ (BOOL)nightModeStatus;

+ (void)setGoScoreStatus:(BOOL)goScoreStatus;

+ (BOOL)goScoreStatus;

+ (BOOL)enableQuechao;

+ (BOOL)enableShowTaxiMainPageGuideImage;

+ (NSString *)getCurrentVersion;
+ (BOOL)needUpdateNewVersion;
+ (NSString *)getAppStoreVersion;
+ (void)setAppStoreVersion:(NSString *)version;
+ (BOOL)enableShowCommunityMainPageGuideImage;
+ (BOOL)enableShowCommunityAddPageGuideImage;

+ (void)setRemoteNotificationType;

+ (BOOL)needRegisterNoticeLocationLaunchAPP;


+ (BOOL)needRegisterNoticeLocationBabyBorn;
+ (void)setRegisterNoticeLocationBabyBorn:(BOOL)noticeBool;

//存储当前APP的版本号
+(void)setAppCurrentVersion;
+(NSString*)getAPPCurrentVersion;


@end
