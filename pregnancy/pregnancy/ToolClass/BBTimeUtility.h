//
//  BBTimeUtility
//
//  Created by ilike1980 on 11-11-2.
//  Last Updated by Wang Jun on 12-10-23.
//  Copyright 2011-2012 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BBTimeUtility : NSObject 

//返回距离日期格式的字符串，用指定的秒数。
+ (NSString *)stringDateWithPastTimestamp:(NSTimeInterval)timestamp;

//返回格式YY-MM-DD hh:mm:ss
+ (NSString *)stringDateWithPastTimestampDetail:(NSTimeInterval)timestamp;

//返回距离详细日期格式的字符串，用指定的秒数。
+ (NSString *)stringAccuracyDateWithPastTimestamp:(NSTimeInterval)timestamp;
//返回指定日期格式的字符串，用当前日期。
+ (NSString *)stringDateWithFormat:(NSString *)format;
//返回指定日期格式的字符串，用指定的日期。
+ (NSString *)stringDateWithFormat:(NSString *)format withDate:(NSDate *)date;

+ (NSString *)stringDateWithFormat:(NSString *)format withTimestamp:(NSTimeInterval)timestamp;

+(NSDate*)getBeforeMonthDate:(NSDate*)curDate;

+(NSDate*)getLastMonthDate:(NSDate*)curDate;

+(NSDate*)getBeforeWeekDate:(NSDate*)curDate;

+(NSDate*)getLastWeekDate:(NSDate*)curDate;

+(NSString*)getWeekDateString:(NSDate*)curDate;

+ (NSString *)stringAccuracyDateWithPastTimes:(NSTimeInterval)times;
+ (NSString *)babyAgeWithDueDate:(NSString *)dueDateStr;

//判断两个日期是否是同一天
+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

@end
