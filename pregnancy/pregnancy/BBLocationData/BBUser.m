//
//  User.m
//  ask
//
//  Created by ilike1980 on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BBUser.h"
#import "BBRemotePushInfo.h"
#import "BBHospitalRequest.h"
#import "BBRefreshPersonalTopicList.h"
#import "BBCookie.h"
#import "BBTimeUtility.h"
#import "NoticeUtil.h"
#import "BBPasteboardTool.h"
#import "BBTaxiLocationData.h"
#import "BBSupportTopicDetail.h"
#import "BBToolOpreation.h"

#define USER_EMAIL_KEY (@"babytree_email")
#define USER_PASSWORD_KEY (@"babytree_password")

#define USER_LOGIN_STRING_KEY (@"babytree_login_string")
#define USER_NICKNAME_KEY (@"babytree_nickname")
#define USER_ENC_ID_KEY (@"babytree_enc_id")
#define USER_AVATAR_URL_KEY (@"babytree_avatar_url")
#define USER_TOP_BG_URL_KEY (@"babytree_top_bg_url")
#define USER_TOP_BG_TITLE_KEY (@"babytree_top_bg_title")
#define USER_TOP_BG_LINK_KEY (@"babytree_top_bg_link")
#define USER_TOP_BG_TOPIC_ID_KEY (@"babytree_top_bg_topic_id")
#define USER_ENABLE_CHANGE_NAME_KEY (@"enable_change_name")
#define USER_EMAIL_ACCOUNT_KEY (@"email_account")
#define USER_LOCAL_AVATAR_KEY (@"userLocalAvatar")
#define USER_NEED_UPLOAD_AVATAR_KEY (@"needUploadAvatar")
#define USER_NEED_GET_GOP_BG_KEY (@"needGetTopBg")
#define USER_NEED_SYNCHRONIZE_DUE_DATE_KEY @"needSynchronizeDueDateKey"
#define USER_CHECK_DUE_DATE_STATUS_KEY @"checkDueDateStatus"
#define USER_NEED_SYNCHRONIZE_STATISTICS_DUE_DATE_KEY @"needSynchronizeStatisticsDueDate"

#define USER_DEVICE_MAC_ADDRESS (@"deviceMacAddress")
#define USER_DEVICE_TOKEN (@"deviceToken")

#define USER_IS_LOADING_DEVICE_TOKEN (@"isLoadingDeviceToken")
#define USER_IS_REGISTER_PUSH (@"isRegisterPush")

#define USER_GENDER_KEY @"userGenderKey"
#define USER_LOCATION_KEY @"userLocationKey"
#define USER_REGISTER_TIME_KEY @"userRegisterTimeKey"
#define USER_ONLY_CITY_KEY @"userOnlyCityKey"


#define USER_COOKIE_KEY @"pregnancyCookie"

#define USER_BABY_BIRTHDAY @"userBabyBirthdayTimeKey"
// 育儿提醒次数
#define BABYBORN_REMIND_NUM @"babyBornRemindNum"
// 育儿今日提醒次数
#define BABYBORN_TODAY_REMIND_NUM @"babyBornTodayRemindNum"
// 育儿提醒日期
#define BABYBORN_REMIND_TIME  @"babyBorn_remind_time"
// 感动页显示 1：显示 0：不显示
#define MOVED_PAGE_SHOW @"moved_page_show"
#define MOVED_PHTOTID @"moved_photoid"
// 下载新版本 是否需要请求加孕气
#define ADD_PREGNANCY_VALUE @"add_pregnancy_value"

#define USER_TODAY_SIGN_STATE @"todaySignState"
#define USER_NEED_RECOMMEND_TOPIC (@"needRecommendTopic")
#define USER_NEED_REFRESH_ACTION_DATA (@"needRefreshActionData")
#define USER_RECOMMEND_TOPIC_ARRAY (@"recommendTopicArray")
#define USER_BANNER_ARRAY (@"bannerArray")
#define USER_NEED_REFRESH_NOTIFICATION_LIST (@"needRefreshNotificationList")
#define USER_KNOWNLEDGE_UPDATA_TS (@"knowledgeUpdataTS")

#define SMART_WATCH_CODE (@"smart_watch_code")

#define USER_COMMUNITY_ADD (@"community_mylist.plist")

#define USER_LEVEL_NUM (@"user_level_num")

#define USER_NEW_ROLE_STATE_KEY (@"userNewRoleStateKey")

#define IS_CURRENT_USER_FATHER_KEY (@"isCurrentUserFatherKey")

#define USER_LAST_UNREAD_SIXIN_COUNT (@"userLastUnreadSiXinCount")

#define USER_LAST_UNREAD_TONGZHI_COUNT (@"userLastUnreadTongZhiCount")

#define USER_NEW_FANS_COUNT (@"userNewFansCount")

#define USER_BAND_FATHER_STATUS (@"userBandFatherStatus")


// 爸爸绑定邀请码
#define USER_BIND_FATHER_CODE @"userBandFatherCode"

#define USER_KNOWLEDGE_COLLECTS (@"knowlegde_collects.plist")

#define USER_MORECIRCLE_LAST_CLASS_ID       @"MoreCircleLastClassId"

#define USER_BAND_FATHER_NOTICE @"userBandFatherNotice"
#define USER_AD_REMIND_LOGO       @"useradremindlogo"

#define USER_AD_REMIND_ADS       @"useradremindads.plist"

#define USER_MID_BANNER_ARRAY (@"userMidBannerArray")


//上次获取特卖点标时间戳
#define LAST_QUERY_MALL_STATUS_KEY (@"lastQueryMallStatusKey")

//每个tabbar点标显示状态
#define ALL_TABBAR_STATUS_KEY (@"allTabbarStatusKey")

#define USER_NEED_SYNCHRONIZE_PREPARE_DUE_DATE_KEY @"needSynchronizePrepareDueDateKey"

@implementation BBUser

+ (NSString *)getTopBgUrl
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_TOP_BG_URL_KEY];
}

+ (NSString *)getTopBgTopicId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_TOP_BG_TOPIC_ID_KEY];
}

+ (NSString *)getTopBgLink
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_TOP_BG_LINK_KEY];
}

+ (NSString *)getTopBgTitle
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_TOP_BG_TITLE_KEY];
}

+ (NSString *)getAvatarUrl
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_AVATAR_URL_KEY];
}

+ (NSString *)getLoginString
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_LOGIN_STRING_KEY];
}

+ (NSString *)getNickname
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_NICKNAME_KEY];
}

+ (NSString *)getEncId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_ENC_ID_KEY];
}

+ (NSString *)getPassword
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_PASSWORD_KEY];
}

+ (NSString *)getGender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_GENDER_KEY];
}

+ (void)setGender:(NSString *)gender
{
    if (!([gender isKindOfClass:[NSString class]]||gender==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:gender forKey:USER_GENDER_KEY];
}

+ (NSString *)getLocation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_LOCATION_KEY];
}

+ (void)setLocation:(NSString *)location
{
    if (!([location isKindOfClass:[NSString class]]||location==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:location forKey:USER_LOCATION_KEY];
}

+ (NSString *)getRegisterTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_REGISTER_TIME_KEY];
}

+ (void)setRegisterTime:(NSString *)registerTime
{
    if (!([registerTime isKindOfClass:[NSString class]]||registerTime==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'年'MM'月'dd'日"];
    [defaults setObject:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[registerTime doubleValue]]] forKey:USER_REGISTER_TIME_KEY];
    [defaults synchronize];
}

+ (NSString *)getBabyBirthday
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_BABY_BIRTHDAY];
}

+ (void)setBabyBirthday:(NSString *)birthdayTime
{
    if (!([birthdayTime isKindOfClass:[NSString class]]||birthdayTime==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:birthdayTime forKey:USER_BABY_BIRTHDAY];
    [defaults synchronize];
}

+ (void)setAvatarUrl:(NSString *)url
{
    if (!([url isKindOfClass:[NSString class]]||url==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:url forKey:USER_AVATAR_URL_KEY];
    [defaults synchronize];
}

+ (void)setTopBg:(NSString *)url
{
    if (!([url isKindOfClass:[NSString class]]||url==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:url forKey:USER_TOP_BG_URL_KEY];
}
+ (void)setTopBgUrl:(NSString *)url
{
    if (!([url isKindOfClass:[NSString class]]||url==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:url forKey:USER_TOP_BG_URL_KEY];
}
+ (void)setTopBgLink:(NSString *)url
{
    if (!([url isKindOfClass:[NSString class]]||url==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:url forKey:USER_TOP_BG_LINK_KEY];
}
+ (void)setTopBgTopicId:(NSString *)url
{
    if (!([url isKindOfClass:[NSString class]]||url==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:url forKey:USER_TOP_BG_TOPIC_ID_KEY];
}
+ (void)setTopBgTitle:(NSString *)url
{
    if (!([url isKindOfClass:[NSString class]]||url==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:url forKey:USER_TOP_BG_TITLE_KEY];
}


+ (void)setLoginString:(NSString *)loginString
{
    if (!([loginString isKindOfClass:[NSString class]]||loginString==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:loginString forKey:USER_LOGIN_STRING_KEY];
    [defaults synchronize];
    
    //登录状态切换
    [BBRefreshPersonalTopicList setNeedRefreshPersonalCenter:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_WEBVIEW object:nil userInfo:nil];
    
    [((BBAppDelegate *)[[UIApplication sharedApplication] delegate]).m_mainTabbar hideTipPointWithIndex:2];
    
    //登录成功
    if ([loginString isNotEmpty])
    {
        if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
        {
            [BBUser setNeedSynchronizePrepareDueDate:YES];
            BBAppDelegate *appDelegate = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate synchronizePrepareDueDate];
        }
        
        // 登录 注册 版本升级成功，需要发请求给用户加孕气
        [BBUser setNeedAddPreValue:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_MORECIRCLE_LOGIN_STATE object:nil];
}

+ (void)setNickname:(NSString *)nickname
{
    if (!([nickname isKindOfClass:[NSString class]]||nickname==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nickname forKey:USER_NICKNAME_KEY];
}

+ (void)setEncodeID:(NSString *)encodeID
{
    if (!([encodeID isKindOfClass:[NSString class]]||encodeID==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodeID forKey:USER_ENC_ID_KEY];
}

+ (void)setPassword:(NSString *)password
{
    if (!([password isKindOfClass:[NSString class]]||password==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:password forKey:USER_PASSWORD_KEY];
}

+ (BOOL)isLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (nil != [defaults objectForKey:USER_LOGIN_STRING_KEY]) {

        return YES;
    }
    return NO;
}

+ (void)logout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:nil forKey:USER_LOGIN_STRING_KEY];
    [BBUser setLoginString:nil];
    [defaults setObject:nil forKey:USER_NICKNAME_KEY];
    [defaults setObject:nil forKey:USER_ENC_ID_KEY];
    [defaults setObject:nil forKey:USER_EMAIL_KEY];
    [defaults setObject:nil forKey:USER_AVATAR_URL_KEY];
    [defaults setObject:nil forKey:USER_GENDER_KEY];
    [defaults setObject:nil forKey:USER_ENABLE_CHANGE_NAME_KEY];
    [defaults setObject:nil forKey:USER_LOCATION_KEY];
    [defaults setObject:nil forKey:USER_COOKIE_KEY];
    [defaults setObject:nil forKey:USER_TODAY_SIGN_STATE];
    [defaults setObject:nil forKey:USER_LOCAL_AVATAR_KEY];
    [BBToolOpreation clearToolActionDataOfType:ToolPageTypeTool];
    [BBToolOpreation clearToolActionDataOfType:ToolPageTypeMain];
    [BBUser setUserUnreadSiXinCount:0];
    [BBUser setUserUnreadTongZhiCount:0];
    [BBUser setUserNewFansCount:0];
    
    [BBUser setSmartWatchCode:nil];
    [BBUser setNeedUploadAvatar:NO];
    [BBUser setNeedRefreshNotificationList:YES];
    [BBHospitalRequest setHospitalCategory:nil];
    [BBHospitalRequest setAddedHospitalName:nil];
    [BBHospitalRequest setPostSetHospital:nil];
    [BBCookie cleanPregnancyCookie];
    [NoticeUtil cancelCustomLocationNoti:@"BBMotherBindingNoti"];
    [BBPasteboardTool removeLoginInfoPasteboard];
    [BBTaxiLocationData setUserTaxiPhoneNumber:nil];
    [BBTaxiLocationData setCallBackTimerString:nil];
    [BBUser setBandFatherStatus:NO];
    [BBUser setLocation:nil];
    [BBUser setCurrentUserBabyFather:NO];
    [BBUser setNeedAddPreValue:NO];
}

+ (NSString *)getEmailAccount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_EMAIL_ACCOUNT_KEY];
}

+ (void)setEmailAccount:(NSString *)theEmailAccount
{
    if (!([theEmailAccount isKindOfClass:[NSString class]]||theEmailAccount==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:theEmailAccount forKey:USER_EMAIL_ACCOUNT_KEY];
}

+ (NSString *)getLocalAvatar
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_LOCAL_AVATAR_KEY];
}

+ (void)setLocalAvatar:(NSString *)theLocalAvatar
{
    if (!([theLocalAvatar isKindOfClass:[NSString class]]||theLocalAvatar==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:theLocalAvatar forKey:USER_LOCAL_AVATAR_KEY];
    [defaults synchronize];
}

+ (BOOL)needUploadAvatar
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:USER_NEED_UPLOAD_AVATAR_KEY] isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)setNeedUploadAvatar:(BOOL)theBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (theBool == YES) {
        [defaults setObject:@"YES" forKey:USER_NEED_UPLOAD_AVATAR_KEY];
    } else {
        [defaults setObject:@"NO" forKey:USER_NEED_UPLOAD_AVATAR_KEY];
    }
    [defaults synchronize];
}

+ (BOOL)needGetTopBg
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:USER_NEED_GET_GOP_BG_KEY] isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}
+ (void)setNeedGetTopBg:(BOOL)theBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (theBool == YES) {
        [defaults setObject:@"YES" forKey:USER_NEED_GET_GOP_BG_KEY];
    } else {
        [defaults setObject:@"NO" forKey:USER_NEED_GET_GOP_BG_KEY];
    }
}

+ (BOOL)checkDueDateStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:USER_CHECK_DUE_DATE_STATUS_KEY] isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
}

+ (void)setCheckDueDateStatus:(BOOL)theBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (theBool == YES) {
        [defaults setObject:@"YES" forKey:USER_CHECK_DUE_DATE_STATUS_KEY];
    } else {
        [defaults setObject:@"NO" forKey:USER_CHECK_DUE_DATE_STATUS_KEY];
    }
}

+ (BOOL)needSynchronizeDueDate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:USER_NEED_SYNCHRONIZE_DUE_DATE_KEY] isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
}

+ (void)setNeedSynchronizeDueDate:(BOOL)theBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (theBool == YES) {
        [defaults setObject:@"YES" forKey:USER_NEED_SYNCHRONIZE_DUE_DATE_KEY];
    } else {
        [defaults setObject:@"NO" forKey:USER_NEED_SYNCHRONIZE_DUE_DATE_KEY];
    }
}

+ (BOOL)needSynchronizeStatisticsDueDate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:USER_NEED_SYNCHRONIZE_STATISTICS_DUE_DATE_KEY] isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
}

+ (void)setNeedSynchronizeStatisticsDueDate:(BOOL)theBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (theBool == YES) {
        [defaults setObject:@"YES" forKey:USER_NEED_SYNCHRONIZE_STATISTICS_DUE_DATE_KEY];
    } else {
        [defaults setObject:@"NO" forKey:USER_NEED_SYNCHRONIZE_STATISTICS_DUE_DATE_KEY];
    }
    [defaults synchronize];
}
//Cookie
+ (NSString *)localCookie
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_COOKIE_KEY];
}

+ (void)localCookie:(NSString *)theCookie
{
    if (!([theCookie isKindOfClass:[NSString class]]||theCookie==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:theCookie forKey:USER_COOKIE_KEY];
}

+ (NSInteger)getBabyBornReminderNum
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:BABYBORN_REMIND_NUM];
}

+ (void)setBabyBornReminderNum:(NSInteger)num
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:num forKey:BABYBORN_REMIND_NUM];
    [defaults synchronize];
}


+ (NSInteger)getBabyBornTodayReminderNum
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:BABYBORN_TODAY_REMIND_NUM];
}

+ (void)setBabyBornTodayReminderNum:(NSInteger)num
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:num forKey:BABYBORN_TODAY_REMIND_NUM];
    [defaults synchronize];
}

+ (NSDate *)getBabyBornReminderTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:BABYBORN_REMIND_TIME];
}
+ (void)setBabyBornReminderTime:(NSDate *)reminderTime
{
    if (!([reminderTime isKindOfClass:[NSDate class]]||reminderTime==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:reminderTime forKey:BABYBORN_REMIND_TIME];
    [defaults synchronize];
}

+ (NSInteger)needShowMovedPage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:MOVED_PAGE_SHOW];
}

+ (void)setNeedShowMovedPage:(NSInteger)isShow
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:isShow forKey:MOVED_PAGE_SHOW];
    [defaults synchronize];
}

// 感动页显示图片id
+ (NSString *)getMovedPagePhotoID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:MOVED_PHTOTID];
}
+ (void)setMovedPagePhotoID:(NSString *)photoID
{
    if (!([photoID isKindOfClass:[NSString class]]||photoID==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:photoID forKey:MOVED_PHTOTID];
    [defaults synchronize];
}


+ (BOOL)needAddPreValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:ADD_PREGNANCY_VALUE];
}

+ (void)setNeedAddPreValue:(BOOL)theBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:theBool forKey:ADD_PREGNANCY_VALUE];
    [defaults synchronize];
}

+ (BOOL)todaySignState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:USER_TODAY_SIGN_STATE] isEqualToString:[BBTimeUtility stringDateWithFormat:@"yyyy-MM-dd"]]) {
        return YES;
    }
    return NO;
}

+ (void)setTodaySignState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[BBTimeUtility stringDateWithFormat:@"yyyy-MM-dd"] forKey:USER_TODAY_SIGN_STATE];
    [defaults synchronize];
}

+ (BOOL)needRefreshActionData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:USER_NEED_REFRESH_ACTION_DATA] isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)setNeedRefreshActionData:(BOOL)theBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (theBool == YES) {
        [defaults setObject:@"YES" forKey:USER_NEED_REFRESH_ACTION_DATA];
    } else {
        [defaults setObject:@"NO" forKey:USER_NEED_REFRESH_ACTION_DATA];
    }
    [defaults synchronize];
}

+ (BOOL)needRecommendTopic
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:USER_NEED_RECOMMEND_TOPIC] isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)setNeedRecommendTopic:(BOOL)theBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (theBool == YES) {
        [defaults setObject:@"YES" forKey:USER_NEED_RECOMMEND_TOPIC];
    } else {
        [defaults setObject:@"NO" forKey:USER_NEED_RECOMMEND_TOPIC];
    }
    [defaults synchronize];
}

+ (void)setRecommendTopicArray:(NSArray *)recommendTopicArray
{
    if (!([recommendTopicArray isKindOfClass:[NSArray class]]||recommendTopicArray==nil)) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults safeSetContainer:recommendTopicArray forKey:USER_RECOMMEND_TOPIC_ARRAY];
    [userDefaults synchronize];
}

+ (NSArray *)recommendTopicArray
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:USER_RECOMMEND_TOPIC_ARRAY];
}

+ (void)setBannerArray:(NSArray *)bannerArray
{
    if (!([bannerArray isKindOfClass:[NSArray class]]||bannerArray==nil)) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults safeSetContainer:bannerArray forKey:USER_BANNER_ARRAY];
    [userDefaults synchronize];
}

+ (NSArray *)bannerArray
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:USER_BANNER_ARRAY];
}

+ (BOOL)needRefreshNotificationList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:USER_NEED_REFRESH_NOTIFICATION_LIST] isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)setNeedRefreshNotificationList:(BOOL)theBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (theBool == YES) {
        [defaults setObject:@"YES" forKey:USER_NEED_REFRESH_NOTIFICATION_LIST];
    } else {
        [defaults setObject:@"NO" forKey:USER_NEED_REFRESH_NOTIFICATION_LIST];
    }
    [defaults synchronize];
}

+ (NSString *)smartWatchCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:SMART_WATCH_CODE];
}

+ (void)setSmartWatchCode:(NSString *)smartWatchCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([smartWatchCode isEqualToString:@""]) {
         [defaults setObject:nil forKey:SMART_WATCH_CODE];
    }else{
         [defaults setObject:smartWatchCode forKey:SMART_WATCH_CODE];
    }
    [defaults synchronize];
}

+ (NSString *)getPregnencyPlistPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"pregnancy"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    return path;
}

+ (NSMutableArray *)getAddedCommunitys
{
    NSString * path = [[BBUser getPregnencyPlistPath] stringByAppendingPathComponent:USER_COMMUNITY_ADD];
    return [NSMutableArray arrayWithContentsOfFile:path];
}

+ (void)setAddedCommunitys:(NSMutableArray *)arr
{

    NSString * path = [[BBUser getPregnencyPlistPath] stringByAppendingPathComponent:USER_COMMUNITY_ADD];
    [arr writeToFile:path atomically:NO];
}

+ (void)setUserLevel:(NSString *)str
{
    if (str && [str isKindOfClass:[NSString class]]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:str forKey:USER_LEVEL_NUM];
        [userDefaults synchronize];
    }
}

+ (NSString *)getUserLevel
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_LEVEL_NUM];
}

+ (BOOL)isUseNewRoleState
{
    if([[NSUserDefaults standardUserDefaults]objectForKey:USER_NEW_ROLE_STATE_KEY]!=nil)
    {
        return YES;
    }
    return NO;
}

+ (void)setNewUserRoleState:(BBUserRoleState)roleState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (roleState == BBUserRoleStateNone)
    {
        [defaults setObject:@"0" forKey:USER_NEW_ROLE_STATE_KEY];
    }
    else if(roleState == BBUserRoleStatePrepare)
    {
        [defaults setObject:@"1" forKey:USER_NEW_ROLE_STATE_KEY];
    }
    else if(roleState == BBUserRoleStatePregnant)
    {
        [defaults setObject:@"2" forKey:USER_NEW_ROLE_STATE_KEY];
    }
    else if(roleState == BBUserRoleStateHasBaby)
    {
        [defaults setObject:@"3" forKey:USER_NEW_ROLE_STATE_KEY];
    }
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:USER_ROLE_CHANGED_NOTIFICATION object:nil userInfo:nil];
    
    //用户转换角色的时候会调整关爱提醒的本地push
    [NoticeUtil resetNewRemindLocalNotifications];
}

+ (BBUserRoleState)getNewUserRoleState
{
    NSString *roleState = [[NSUserDefaults standardUserDefaults]objectForKey:USER_NEW_ROLE_STATE_KEY];
    if (roleState == nil || [roleState isEqualToString:@"0"])
    {
        return BBUserRoleStateNone;
    }
    else if ([roleState isEqualToString:@"1"])
    {
        return BBUserRoleStatePrepare;
    }
    else if ([roleState isEqualToString:@"2"])
    {
        return BBUserRoleStatePregnant;
    }
    else if ([roleState isEqualToString:@"3"])
    {
        return BBUserRoleStateHasBaby;
    }
    return BBUserRoleStateNone;
}

+ (BOOL)isCurrentUserBabyFather
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:IS_CURRENT_USER_FATHER_KEY];
}

+ (void)setCurrentUserBabyFather:(BOOL)isFather
{
    [[NSUserDefaults standardUserDefaults]setBool:isFather forKey:IS_CURRENT_USER_FATHER_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSInteger)getUserUnreadSiXinCount
{
    NSInteger lastUnreadSiXinCount = [[NSUserDefaults standardUserDefaults]integerForKey:USER_LAST_UNREAD_SIXIN_COUNT];
    return lastUnreadSiXinCount;
}

+ (void)setUserUnreadSiXinCount:(NSInteger)count
{
    [[NSUserDefaults standardUserDefaults]setInteger:count forKey:USER_LAST_UNREAD_SIXIN_COUNT];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSInteger)getUserUnreadTongZhiCount
{
    NSInteger lastUnreadTongZhiCount = [[NSUserDefaults standardUserDefaults]integerForKey:USER_LAST_UNREAD_TONGZHI_COUNT];
    return lastUnreadTongZhiCount;
}

+ (void)setUserUnreadTongZhiCount:(NSInteger)count
{
    [[NSUserDefaults standardUserDefaults]setInteger:count forKey:USER_LAST_UNREAD_TONGZHI_COUNT];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSInteger)getUserNewFansCount
{
    NSInteger userNewFansCount = [[NSUserDefaults standardUserDefaults]integerForKey:USER_NEW_FANS_COUNT];
    return userNewFansCount;
}

+ (void)setUserNewFansCount:(NSInteger)count
{
    [[NSUserDefaults standardUserDefaults]setInteger:count forKey:USER_NEW_FANS_COUNT];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (BOOL)isBandFatherStatus
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:USER_BAND_FATHER_STATUS];
}

+ (void)setBandFatherStatus:(BOOL)bandStatus
{
    [[NSUserDefaults standardUserDefaults]setBool:bandStatus forKey:USER_BAND_FATHER_STATUS];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


+ (NSString *)getKnowledgeUpdataTS
{
    return [[NSUserDefaults standardUserDefaults]stringForKey:USER_KNOWNLEDGE_UPDATA_TS];
}

+ (void)setKnowledgeUpdataTS:(NSString *)bandStatus
{
    [[NSUserDefaults standardUserDefaults]setObject :bandStatus forKey:USER_KNOWNLEDGE_UPDATA_TS];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


// 爸爸绑定邀请码
+ (NSString *)getPapaBindCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_BIND_FATHER_CODE];
}

+ (void)setPapaBindCode:(NSString *)bindCode
{
    
    if (!([bindCode isKindOfClass:[NSString class]]||bindCode==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:bindCode forKey:USER_BIND_FATHER_CODE];
    [defaults synchronize];
}

//知识收藏本地字典
+ (NSMutableDictionary *)getKnowledgeCollects
{
    NSString * path = [[BBUser getPregnencyPlistPath] stringByAppendingPathComponent:USER_KNOWLEDGE_COLLECTS];
    return [NSMutableDictionary dictionaryWithContentsOfFile:path];
}

// moreCircle category backup
+ (NSString *)moreCircleCategory
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastClassID = [defaults objectForKey:USER_MORECIRCLE_LAST_CLASS_ID];
    return lastClassID;
}

+ (void )setMoreCircleCategory:(NSString *)category;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:category forKey:USER_MORECIRCLE_LAST_CLASS_ID];
    
    [defaults synchronize];
}

+ (void)setKnowledgeCollects:(NSMutableDictionary *)dic
{
    NSString * path = [[BBUser getPregnencyPlistPath] stringByAppendingPathComponent:USER_KNOWLEDGE_COLLECTS];
    [dic writeToFile:path atomically:NO];
}


//是否需要注册绑定准爸爸提醒
+ (BOOL)needBandFatherNotice
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:USER_BAND_FATHER_NOTICE] isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)setNeedBandFatherNotice:(BOOL)bandBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (bandBool == YES) {
        [defaults setObject:@"YES" forKey:USER_BAND_FATHER_NOTICE];
    } else {
        [defaults setObject:@"NO" forKey:USER_BAND_FATHER_NOTICE];
    }
    [defaults synchronize];
}

+ (NSDictionary *)getRemindLogoData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *data = [defaults objectForKey:USER_AD_REMIND_LOGO];
    return data;
}

+ (void )setRemindLogoData:(NSDictionary *)data
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults safeSetContainer:data forKey:USER_AD_REMIND_LOGO];
    [defaults synchronize];
}

+ (void)removeRemindLogoData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:USER_AD_REMIND_LOGO];
    [defaults synchronize];
}

+ (NSArray *)getRemindAds
{
    NSString * path = [[BBUser getPregnencyPlistPath] stringByAppendingPathComponent:USER_AD_REMIND_ADS];
    return [NSArray arrayWithContentsOfFile:path];
}

+ (void)setRemindAds:(NSArray *)arr
{
    NSString * path = [[BBUser getPregnencyPlistPath] stringByAppendingPathComponent:USER_AD_REMIND_ADS];
    [arr writeToFile:path atomically:NO];
}

+ (void)setMidBannerArray:(NSArray *)midBannerArray
{
    if (!([midBannerArray isKindOfClass:[NSArray class]]||midBannerArray==nil)) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults safeSetContainer:midBannerArray forKey:USER_MID_BANNER_ARRAY];
    [userDefaults synchronize];
}

+ (NSArray *)midBannerArray
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:USER_MID_BANNER_ARRAY];
}


+ (NSString *)getUserOnlyCity
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_ONLY_CITY_KEY];
}

+ (void)setUserOnlyCity:(NSString *)city
{
    if (![city isNotEmpty]) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:city forKey:USER_ONLY_CITY_KEY];
}

//特卖点标状态上次获取ts
+ (void)setLastQueryMallStatusTS:(NSString *)lastTS
{
    if (!([lastTS isKindOfClass:[NSString class]]||lastTS==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:lastTS forKey:LAST_QUERY_MALL_STATUS_KEY];
    [defaults synchronize];
}

+ (NSString*)getLastQueryMallStatusTS
{
    NSString *lastTS = [[NSUserDefaults standardUserDefaults]stringForKey:LAST_QUERY_MALL_STATUS_KEY];
    if (lastTS)
    {
        return lastTS;
    }
    else
    {
        return @"0";
    }
    
}

//每个tab点标显示状态
+ (void)setTabbarIndex:(NSInteger)tabIndex Status:(BOOL)isShow
{
    NSString *key = [NSString stringWithFormat:@"%d",tabIndex];
    NSDictionary *oldStatusDict = [[NSUserDefaults standardUserDefaults]dictionaryForKey:ALL_TABBAR_STATUS_KEY];
    NSMutableDictionary *statusDict = [NSMutableDictionary dictionaryWithDictionary:oldStatusDict];
    [statusDict setBool:isShow forKey:key];
    [[NSUserDefaults standardUserDefaults]safeSetContainer:statusDict forKey:ALL_TABBAR_STATUS_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (BOOL)getTabbarStatusForIndex:(NSInteger)tabIndex
{
    NSString *key = [NSString stringWithFormat:@"%d",tabIndex];
    NSDictionary *oldStatusDict = [[NSUserDefaults standardUserDefaults]dictionaryForKey:ALL_TABBAR_STATUS_KEY];
    if ([oldStatusDict isDictionaryAndNotEmpty] && [oldStatusDict boolForKey:key])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (BOOL)needSynchronizePrepareDueDate
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:USER_NEED_SYNCHRONIZE_PREPARE_DUE_DATE_KEY];
}

+ (void)setNeedSynchronizePrepareDueDate:(BOOL)theBool
{
    [[NSUserDefaults standardUserDefaults] setBool:theBool forKey:USER_NEED_SYNCHRONIZE_PREPARE_DUE_DATE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
