//
//  BBTimeConvert.m
//  pregnancy
//
//  Created by Jun Wang on 12-3-27.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBPregnancyInfo.h"

#define PREGNANCY_DATE_CYCLE @"pregnancyDateCycle"

static NSDateFormatter *sharedDateFormatter = nil;

@implementation BBPregnancyInfo

//使用静态NSDateFormatter，减少每次NSDateFormatter初始化耗时，提高速度

+ (NSString *)stringOfDate:(NSDate*)date format:(NSString*)format
{
    return [self stringOfDate:date format:format timeZone:nil locale:nil];
}

+ (NSDate *)dateOfString:(NSString*)dateStr format:(NSString*)format
{
    return [self dateOfString:dateStr format:format timeZone:nil locale:nil];
}

+ (NSString *)stringOfDate:(NSDate*)date format:(NSString*)format timeZone:(NSTimeZone*)zone locale:(NSLocale *)locale
{
    @synchronized (sharedDateFormatter)
    {
        if (!sharedDateFormatter)
        {
            sharedDateFormatter = [[NSDateFormatter alloc]init];
        }
        //设置或显示重置NSDateFormatter状态
        [sharedDateFormatter setDateFormat:format];
        
        if (zone)
        {
            [sharedDateFormatter setTimeZone:zone];
        }
        else
        {
            [sharedDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        }
        
        if (locale)
        {
            [sharedDateFormatter setLocale:locale];
        }
        else
        {
            [sharedDateFormatter setLocale:[NSLocale currentLocale]];
        }
        
        return [sharedDateFormatter stringFromDate:date];
    }
}

+ (NSDate *)dateOfString:(NSString*)dateStr format:(NSString*)format timeZone:(NSTimeZone*)zone locale:(NSLocale *)locale
{
    @synchronized (sharedDateFormatter)
    {
        if (!sharedDateFormatter)
        {
            sharedDateFormatter = [[NSDateFormatter alloc]init];
        }
        //设置或显示重置NSDateFormatter状态
        [sharedDateFormatter setDateFormat:format];
        
        if (zone)
        {
            [sharedDateFormatter setTimeZone:zone];
        }
        else
        {
            [sharedDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        }
        
        if (locale)
        {
            [sharedDateFormatter setLocale:locale];
        }
        else
        {
            [sharedDateFormatter setLocale:[NSLocale currentLocale]];
        }
        
        return [sharedDateFormatter dateFromString:dateStr];
    }
}

//返回今天的0点0分0秒。
+ (NSDate *)currentDate
{
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    NSTimeZone* beijingzone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];        
    NSDate *now= [NSDate date];
    NSDate *day = [NSDate dateWithTimeInterval:([beijingzone secondsFromGMT] - [localzone secondsFromGMT]) sinceDate:now];
    day = [day dateAtStartOfDay];

    return day;
}

//返回今天往后推280天的0点0分0秒。
+ (NSDate *)dateLastWeek
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDateComponents *dateCom = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:currentDate];
    NSTimeInterval timeInterval = dateCom.hour*3600+dateCom.minute*60+dateCom.second;
    return [NSDate dateWithTimeInterval:-timeInterval+3600*24*280 sinceDate:currentDate];
}

//根据参数date，去掉小时、分钟、秒数，然后设置为预产期。
+ (void)setPregnancyTimeWithDueDate:(NSDate *)theDueDate
{
    if (!([theDueDate isKindOfClass:[NSDate class]]||theDueDate==nil)) {
        return;
    }

    NSString *text = [self stringOfDate:theDueDate format:@"yyyy-MM-dd" timeZone:TIMEZONE_BEIJING locale:nil];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:text forKey:PREGNANCY_TIME_KEY];
    [userDefault synchronize];
    
    //发送预产期更改通知
    [[NSNotificationCenter defaultCenter]postNotificationName:USER_PREGNANCY_DATE_CHANGED_NOTIFICATION object:nil userInfo:nil];
    
    //用户修改预产期会调整关爱提醒的本地push
    [NoticeUtil resetNewRemindLocalNotifications];
  }

//根据参数date，去掉小时、分钟、秒数，往后推280天，然后设置为预产期。
+ (void)setPregnancyTimeWithMenstrualDate:(NSDate *)theMenstrualDate withCycle:(NSInteger)cycle
{
    
    if (!([theMenstrualDate isKindOfClass:[NSDate class]]||theMenstrualDate==nil)) {
        return;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDateComponents *dateCom = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:theMenstrualDate];
    NSTimeInterval timeInterval = dateCom.hour*3600+dateCom.minute*60+dateCom.second;
    NSDate *dueDate = [[NSDate alloc] initWithTimeInterval:-timeInterval+3600*24*(280+cycle-28) sinceDate:theMenstrualDate];
    
    NSString *text = [self stringOfDate:dueDate format:@"yyyy-MM-dd" timeZone:TIMEZONE_BEIJING locale:nil];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:text forKey:PREGNANCY_TIME_KEY];
    [userDefault setObject:[NSString stringWithFormat:@"%d", cycle] forKey:PREGNANCY_DATE_CYCLE];
    [userDefault synchronize];
    
    //发送预产期更改通知
    [[NSNotificationCenter defaultCenter]postNotificationName:USER_PREGNANCY_DATE_CHANGED_NOTIFICATION object:nil userInfo:nil];
    
    //用户修改预产期会调整关爱提醒的本地push
    [NoticeUtil resetNewRemindLocalNotifications];
}

//返回用户今天是怀孕第几天
+ (NSInteger)daysOfPregnancy
{
     NSDate *dueDate = [self dateOfPregnancy];
    //如果现在用户是怀孕状态，则返回预产期
    if ([BBUser getNewUserRoleState]==BBUserRoleStatePregnant)
    {
        if ([dueDate compare:[self currentDate]] == NSOrderedDescending)
        {
            NSInteger pregancyDays = 280 - [dueDate timeIntervalSinceDate:[self currentDate]]/3600/24;
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
            return 280;
        }

    }
    //如果现在是育儿状态，则返回宝宝已经多少天了
    else //[BBUser getNewUserRoleState] == BBUserRoleStateHasBaby
    {
        NSInteger bornDays = [[self currentDate] timeIntervalSinceDate:dueDate]/3600/24 + 1;
        if (bornDays < 1)
        {
            return 1;
        }
        else
        {
            return bornDays;
        }
    }
    
}

//返回用户设置的预产期
+ (NSDate *)dateOfPregnancy
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    id due = [userDefault objectForKey:PREGNANCY_TIME_KEY];
    NSString *dueDateStr = nil;
    if ([due isKindOfClass:[NSString class]])
    {
        dueDateStr = due;
    }
    else
    {
        return due;
    }

    NSDate *dueDate = [self dateOfString:dueDateStr format:@"yyyy-MM-dd 00:00:00 +800"];
    
    return dueDate;
}

+ (NSString *)pregnancyCycle
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:PREGNANCY_DATE_CYCLE] != nil) {
        return [userDefault objectForKey:PREGNANCY_DATE_CYCLE];
    } else {
        return @"28";
    }
}
//根据圈子名称判断是否是自己预产期对应的圈子
+ (BOOL)isMyAgeCommunity:(NSString *)communityTitle
{
    NSDate *date = [self dateOfPregnancy];

    BOOL isMyAge = [communityTitle isEqualToString:[self stringOfDate:date format:@"yyyy'年'M'月同龄圈'"]];
    if (!isMyAge)
    {
        //防止08月的格式，防止那个0
        isMyAge = [communityTitle isEqualToString:[self stringOfDate:date format:@"yyyy'年'MM'月同龄圈'"]];
    }
    return  isMyAge;
}

//根据参数预产期日期，格式化输出日期
+ (NSString *)pregnancyDateByStringWithDate:(NSDate *)thePregnancyDate
{
    if (!([thePregnancyDate isKindOfClass:[NSDate class]]||thePregnancyDate==nil)) {
        return nil;
    }
    
    return [self stringOfDate:thePregnancyDate format:@"yyyy'年'MM'月'dd'日" timeZone:nil locale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
}

//根据参数月经日期，格式化输出此日期往后推279天的日期
+ (NSString *)calculateDueDateByMenstrualDate:(NSDate *)theMenstrualDate 
{
    if (!([theMenstrualDate isKindOfClass:[NSDate class]]||theMenstrualDate==nil)) {
        return nil;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateCom = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:theMenstrualDate];
    [dateCom setHour:0];
    [dateCom setMinute:0];
    [dateCom setSecond:0];
    NSDate *dueDate = [NSDate dateWithTimeInterval:3600*24*279 sinceDate:[calendar dateFromComponents:dateCom]];
    return [self stringOfDate:dueDate format:@"yyyy'年'MM'月'dd'日" timeZone:nil locale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
}

//根据参数怀孕天数和保存的预产期，格式化输出日期
+ (NSString *)pregancyDateByStringWithDays:(NSString *)theDays
{
    if (!([theDays isKindOfClass:[NSString class]]||theDays==nil)) {
        return nil;
    }
    NSDate *outputDate = [NSDate dateWithTimeInterval:-(281-[theDays intValue])*3600*24 sinceDate:[self dateOfPregnancy]];
    return [self stringOfDate:outputDate format:@"EE          M'月'd'日" timeZone:nil locale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
}

//格式化输出预产期
+ (NSString *)pregancyDateByString
{
    NSDate *date = [self dateOfPregnancy];
    return [self stringOfDate:date format:@"yyyy'年'MM'月'dd'日" timeZone:nil locale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
}
//格式化输出预产期yyyy-MM-dd
+ (NSString *)pregancyDateYMDByString
{
    NSDate *date = [self dateOfPregnancy];
    return [self stringOfDate:date format:@"yyyy-MM-dd" timeZone:nil locale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
}

//格式化输出预产期
+ (NSString *)pregancyDateByYMString
{
    NSDate *date = [self dateOfPregnancy];
    return [self stringOfDate:date format:@"yyyyMM" timeZone:nil locale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
}

+ (NSString *)pregancyDateYMDByStringForAPI
{
    if ([BBUser getNewUserRoleState] == BBUserRoleStateNone) {
        return @"2100-01-02";
    }
    if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare) {
        return @"2100-01-01";
    }
    return [self pregancyDateYMDByString];
}

//是否设置过预产期
+ (BOOL)isSetDueDate
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:PREGNANCY_TIME_KEY] == nil) {
        return NO;
    }
    return YES;
}

+ (NSInteger)discussCount
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:PREGNANCY_DISCUSS_COUNT_KEY] == nil) {
        return 0;
    }
    return [[userDefault objectForKey:PREGNANCY_DISCUSS_COUNT_KEY] intValue];
}

+ (void)setDiscussCount:(NSString *)theDiscussCount
{
    if (!([theDiscussCount isKindOfClass:[NSString class]]||theDiscussCount==nil)) {
        return;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:theDiscussCount forKey:PREGNANCY_DISCUSS_COUNT_KEY];
}

+ (NSInteger)startWeek
{
    return 0;
}


+(void)setNotiCount:(NSInteger)notiCount
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:notiCount forKey:PREG_NOTI_KEY];
    [userDefault synchronize];
}

+(NSInteger)getNotiCount
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:PREG_NOTI_KEY] == nil) {
        return 0;
    }
    return [[userDefault objectForKey:PREG_NOTI_KEY] intValue];
}


+(void)setRemindAlert:(NSInteger)remindTimes
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:remindTimes forKey:REMIND_ALERT_KEY];
    [userDefault synchronize];
}

+(NSInteger)getRemindAlert
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:REMIND_ALERT_KEY] == nil) {
        return 0;
    }
    return [[userDefault objectForKey:REMIND_ALERT_KEY] intValue];
}

+(int)pregnanyMonthsFromWeek:(int)week
{
    int month = (week-1)/4+1;
    if (month > 10) {
        month = 10-month;
    }
    return month;
}

+ (NSString *)stringOfBabyBornDateBySpecifiedFormat:(NSString *)specifiedFormat
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDate *bornDate = [userDefault objectForKey:PREGNANCY_TIME_KEY];
    return [self stringOfDate:bornDate format:specifiedFormat timeZone:nil locale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
}

+ (NSString *)pregnanyClientAndStatus
{
    if([BBUser getNewUserRoleState] ==BBUserRoleStateNone){
        return @"0";
    }
    int type = ([BBUser isCurrentUserBabyFather]?1:0)*3;
    if([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
    {
        type++;
    }else if([BBUser getNewUserRoleState] == BBUserRoleStatePregnant)
    {
        type = type +2;
    }else
    {
        type = type +3;
    }
    return [NSString stringWithFormat:@"%d",type];
}

+ (NSDate*)defaultDueDateForUserRoleState:(BBUserRoleState)userRoleState
{
    if(userRoleState == BBUserRoleStatePrepare)
    {
        return [NSDate dateWithTimeInterval:86400*300 sinceDate:[NSDate date]];
    }
    else if (userRoleState == BBUserRoleStatePregnant)
    {
        return [NSDate dateWithTimeInterval:86400*258 sinceDate:[NSDate date]];
    }
    else if(userRoleState == BBUserRoleStateHasBaby)
    {
        return [NSDate date];
    }
    else
    {
        return [NSDate date];
    }
}
@end
