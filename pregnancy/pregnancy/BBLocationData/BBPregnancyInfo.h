//
//  BBTimeConvert.h
//  pregnancy
//
//  Created by Jun Wang on 12-3-27.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBUser.h"

#define PREGNANCY_TIME_KEY @"pregnancyTimeKey"

#define PREGNANCY_DISCUSS_COUNT_KEY @"discussTopicCount"

#define PREG_NOTI_KEY @"preg_noti"

#define REMIND_ALERT_KEY @"remind_alert"

#define USER_PREGNANCY_DATE_CHANGED_NOTIFICATION @"USER_PREGNANCY_DATE_CHANGED_NOTIFICATION"

#define MAX_PREGMENT_DAYS 280

@interface BBPregnancyInfo : NSObject

+ (NSDate *)currentDate;

+ (void)setPregnancyTimeWithDueDate:(NSDate *)theDueDate;

+ (void)setPregnancyTimeWithMenstrualDate:(NSDate *)theMenstrualDate withCycle:(NSInteger)cycle;

+ (NSInteger)daysOfPregnancy;

+ (NSDate *)dateOfPregnancy;

+ (NSString *)pregnancyCycle;

//根据圈子名称判断是否是自己预产期对应的圈子
+ (BOOL)isMyAgeCommunity:(NSString *)communityTitle;

+ (NSString *)pregnancyDateByStringWithDate:(NSDate *)thePregnancyDate;

+ (NSString *)pregancyDateByStringWithDays:(NSString *)theDays;

+ (NSString *)pregancyDateByString;

+ (NSString *)pregancyDateYMDByString;

+ (NSString *)pregancyDateYMDByStringForAPI;

+ (NSString *)calculateDueDateByMenstrualDate:(NSDate *)theMenstrualDate;

+ (NSString *)pregancyDateByYMString;

+ (BOOL)isSetDueDate;

+ (NSInteger)discussCount;

+ (void)setDiscussCount:(NSString *)theDiscussCount;

+ (NSInteger)startWeek;


+(void)setNotiCount:(NSInteger)notiCount;
+(NSInteger)getNotiCount;



+(void)setRemindAlert:(NSInteger)remindTimes;

+(NSInteger)getRemindAlert;

//通过怀孕周数计算月份
+(int)pregnanyMonthsFromWeek:(int)week;

+ (NSString *)stringOfBabyBornDateBySpecifiedFormat:(NSString *)specifiedFormat;

+ (NSString *)pregnanyClientAndStatus;

+ (NSString *)stringOfDate:(NSDate*)date format:(NSString*)format;

+ (NSDate *)dateOfString:(NSString*)dateStr format:(NSString*)format;

+ (NSString *)stringOfDate:(NSDate*)date format:(NSString*)format timeZone:(NSTimeZone*)zone locale:(NSLocale *)locale;

+ (NSDate *)dateOfString:(NSString*)dateStr format:(NSString*)format timeZone:(NSTimeZone*)zone locale:(NSLocale *)locale;

+ (NSDate*)defaultDueDateForUserRoleState:(BBUserRoleState)userRoleState;
@end
