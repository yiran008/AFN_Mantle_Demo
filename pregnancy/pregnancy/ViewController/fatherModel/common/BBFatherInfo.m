//
//  BBFatherInfo.m
//  pregnancy
//
//  Created by songxf on 13-5-21.
//  Copyright (c) 2013年 babytree. All rights reserved.
//
#import "BBFatherInfo.h"
#import "BBApp.h"
#import "BBUser.h"
#import "BBPregnancyInfo.h"

@implementation BBFatherInfo

+ (NSString *)getFatherUID
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:FATHER_UID_KEY];
}

+ (void)setFatherUID:(NSString *)f_uid
{
    if (!([f_uid isKindOfClass:[NSString class]]||f_uid==nil)) {
        return;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:f_uid forKey:FATHER_UID_KEY];
    [userDefault synchronize];
}


+ (NSString *)getFatherEncodeId
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:FATHER_ENCODE_ID_KEY];

}

+ (void)setFatherEncodeId:(NSString *)uid
{
    if (!([uid isKindOfClass:[NSString class]]||uid==nil)) {
        return;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:uid forKey:FATHER_ENCODE_ID_KEY];
    [userDefault synchronize];
}

// 返回今天的0点0分0秒。
+ (NSString *)getMotherUID
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:MOTHER_UID_KEY];
}

+ (void)setMotherUID:(NSString *)m_uid
{
    if (!([m_uid isKindOfClass:[NSString class]]||m_uid==nil)) {
        return;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:m_uid forKey:MOTHER_UID_KEY];
    [userDefault synchronize];
}

// 返回今天的0点0分0秒。
+ (NSDate *)currentDate
{
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    NSTimeZone* beijingzone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];    
    NSDate *now= [NSDate date];
    NSDate *day = [NSDate dateWithTimeInterval:([beijingzone secondsFromGMT] - [localzone secondsFromGMT]) sinceDate:now];
    day = [day dateAtStartOfDay];
    
    return day;
}

+ (void)setBabyPregnancyTime:(NSString *)dateStr
{
    if (!([dateStr isKindOfClass:[NSString class]]||dateStr==nil)) {
        return;
    }
    if (!dateStr || [dateStr isEqualToString:@""]) {
        return;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:dateStr forKey:BABY_PREGNANCY_TIME_KEY];
    [userDefault synchronize];
}

// 设置孩子预产期
+ (void)setBabyPregnancyTimeWithMenstrualDate:(NSDate *)date
{
    if (!([date isKindOfClass:[NSDate class]]||date==nil)) {
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:TIMEZONE_BEIJING];
    NSString *text = [dateFormatter stringFromDate:date];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:text forKey:BABY_PREGNANCY_TIME_KEY];
    [userDefault synchronize];
}

// 返回用户今天是怀孕第几天
+ (NSInteger)daysOfPregnancy
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if (![userDefault objectForKey:BABY_PREGNANCY_TIME_KEY])
    {
        return DEFAULT_DAYS_PREGNANCY;
    }
    NSDate *dueDate = [self dateOfPregnancy];

    if ([dueDate compare:[self currentDate]] == NSOrderedAscending)
    {
        return 282;
    }
    else if ([dueDate compare:[self currentDate]] == NSOrderedDescending)
    {
        NSInteger pregancyDays = 281 - [dueDate timeIntervalSinceDate:[self currentDate]]/3600/24;
        
        if (pregancyDays < 1)
        {
            return 1;
        }
        else
        {
            return pregancyDays;
        }
    }
    else
    {
        return 281;
    }
}

//根据参数怀孕天数和保存的预产期，格式化输出日期
+ (NSString *)pregancyDateByStringWithDays:(NSString *)theDays
{
    NSDate *outputDate = [NSDate dateWithTimeInterval:-(281-[theDays intValue])*3600*24 sinceDate:[self dateOfPregnancy]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"EE          M'月'd'日"];
    return [dateFormatter stringFromDate:outputDate];
}

// 返回用户设置的预产期
+ (NSDate *)dateOfPregnancy
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    id due = [userDefault objectForKey:BABY_PREGNANCY_TIME_KEY];
    
    if (due == nil)
    {
        due = [NSDate dateWithDaysFromNow:(280-DEFAULT_DAYS_PREGNANCY)];
        [self setBabyPregnancyTimeWithMenstrualDate:due ];
        [userDefault synchronize];
    }
    
    NSString *dueDateStr = nil;
    if ([due isKindOfClass:[NSString class]])
    {
        dueDateStr = due;
    }
    else
    {
        return due;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00 +800"];
    NSDate *dueDate = [dateFormatter dateFromString:dueDateStr];
    
    return dueDate;
}

// 爸爸绑定邀请码
+ (NSString *)getPapaBindCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_PAPA_BIND_CODE];
}

+ (void)setPapaBindCode:(NSString *)bindCode
{
    
    if (!([bindCode isKindOfClass:[NSString class]]||bindCode==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:bindCode forKey:USER_PAPA_BIND_CODE];
    [defaults synchronize];
}

// 备份的绑定状态，在无法获得服务器状态时使用
+ (BOOL)getPapaBindStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *status = [defaults objectForKey:USER_PAPA_BIND_STATUS];
    
    if (status)
    {
        return [status boolValue];
    }
    
    return NO;
}

+ (void)setPapaBindStatus:(BOOL)bindStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:bindStatus] forKey:USER_PAPA_BIND_STATUS];
    [defaults synchronize];
}

// 爸爸添加的孕气值
+ (NSString *)getPapaYunqi
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *yunqi = [defaults objectForKey:USER_PAPA_YUNQI];
    
    if (!stringIsEmpty(yunqi))
    {
        return yunqi;
    }
    
    return @"0";
}

+ (void)setPapaYunqi:(NSString *)yunqi
{
    
    if (!([yunqi isKindOfClass:[NSString class]]||yunqi==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (stringIsEmpty(yunqi))
    {
        [defaults setObject:@"0" forKey:USER_PAPA_YUNQI];
    }
    else
    {
        [defaults setObject:yunqi forKey:USER_PAPA_YUNQI];
    }
    [defaults synchronize];
}

+ (NSInteger)getChoseRoleState;
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    // 还没有选择
    if ([userDefault objectForKey:STATE_ABOUT_CHOSE_ROLE] == nil || [[userDefault objectForKey:STATE_ABOUT_CHOSE_ROLE] isEqualToString:@"0"])
    {
        return 0;
    }
    
    // 选择了爸爸
    if ([[userDefault objectForKey:STATE_ABOUT_CHOSE_ROLE] isEqualToString:@"1"]||[[userDefault objectForKey:STATE_ABOUT_CHOSE_ROLE] isEqualToString:@"YES"])
    {
        return 1;
    }
    
    // 选择了妈妈
    if ([[userDefault objectForKey:STATE_ABOUT_CHOSE_ROLE] isEqualToString:@"2"] || [[userDefault objectForKey:STATE_ABOUT_CHOSE_ROLE] isEqualToString:@"NO"])
    {
        return 2;
    }
    
    return 3;
}

// 用户选择角色后，记忆不再显示选择界面
+ (void)setShowChoseRole:(NSInteger)choseRoleState
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (choseRoleState==0)
    {
        [BBApp setProjectCategory:@"0"];
        [userDefault setObject:@"0" forKey:STATE_ABOUT_CHOSE_ROLE];
    }
    else if (choseRoleState==1)
    {
        [userDefault setObject:@"1" forKey:STATE_ABOUT_CHOSE_ROLE];
    }
    else if (choseRoleState==2)
    {
        [userDefault setObject:@"2" forKey:STATE_ABOUT_CHOSE_ROLE];
    }
    else if (choseRoleState==3)
    {
        [userDefault setObject:@"3" forKey:STATE_ABOUT_CHOSE_ROLE];
    }
    [userDefault synchronize];
}

// 用户选择角色清除
+ (void)clearRoleState
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:STATE_ABOUT_CHOSE_ROLE];
    [userDefault synchronize];
}

+ (NSString *)getInviteCode
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:INVITE_CODE_OF_FATHER];
}

+ (void)setInviteCode:(NSString *)code
{
    if (!([code isKindOfClass:[NSString class]]||code==nil)) {
        return;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:code forKey:INVITE_CODE_OF_FATHER];
    [userDefault synchronize];
}

+ (void)setBackGroundImageURL:(NSString *)url
{
    if (!([url isKindOfClass:[NSString class]]||url==nil)) {
        return;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:url forKey:BACKGROUND_IMAGE_URL];
    [userDefault synchronize];
}

+ (NSString *)getBackGroundImageURL
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:BACKGROUND_IMAGE_URL];
}

+ (void)clearLocalData
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:nil forKey:TASK_CONTENT_TODAY];
    [userDefault setValue:nil forKey:BACKGROUND_IMAGE_URL];
    [userDefault setValue:nil forKey:INVITE_CODE_OF_FATHER];
    [userDefault setValue:nil forKey:BABY_PREGNANCY_TIME_KEY];
    [userDefault setValue:nil forKey:FATHER_UID_KEY];
    [userDefault setValue:nil forKey:MOTHER_UID_KEY];
    [userDefault setValue:nil forKey:FATHER_ENCODE_ID_KEY];
    [userDefault synchronize];
}

+ (void)clearMamaData
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:nil forKey:USER_PAPA_BIND_CODE];
    [userDefault setObject:[NSNumber numberWithBool:NO] forKey:USER_PAPA_BIND_STATUS];
    [BBUser logout];
    
    [userDefault synchronize];
}

+ (void)setActionTag:(NSString *)tag
{
    if (!([tag isKindOfClass:[NSString class]]||tag==nil)) {
        return;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:tag forKey:FATHER_CHANGE_STATUS_ACTION];
    [userDefault synchronize];
}
+ (NSString *)getActionTag
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:FATHER_CHANGE_STATUS_ACTION];
}

@end
