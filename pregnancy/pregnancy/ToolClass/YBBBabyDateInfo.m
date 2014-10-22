//
//  BBBabyDateInfo.m
//  parenting
//
//  Created by Wang Jun on 12-9-19.
//  Copyright (c) 2012年 Babytree. All rights reserved.
//

#import "YBBBabyDateInfo.h"

#define BABY_BORN_DATE_KEY              @"y_babyBornDateKey"

@implementation YBBBabyDateInfo

+ (NSDate *)currentDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDateComponents *dateCom = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:[NSDate date]];
    [dateCom setHour:0];
    [dateCom setMinute:0];
    [dateCom setSecond:0];
    return [calendar dateFromComponents:dateCom];
}

+ (void)setBabyBornDate:(NSDate *)bornDate
{
    if (!([bornDate isKindOfClass:[NSDate class]]||bornDate==nil)) {
        return;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDateComponents *dateCom = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:bornDate];
    NSTimeInterval timeInterval = dateCom.hour*3600+dateCom.minute*60+dateCom.second;
    NSDate *theBornDate = [NSDate dateWithTimeInterval:-timeInterval sinceDate:bornDate];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:theBornDate forKey:BABY_BORN_DATE_KEY];
    [userDefault synchronize];
}

+ (NSDate *)babyBornDate
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:BABY_BORN_DATE_KEY];
}

+ (NSInteger)babyBornDays
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDate *bornDate = [userDefault objectForKey:BABY_BORN_DATE_KEY];
    NSInteger bornDays = [[self currentDate] timeIntervalSinceDate:bornDate]/3600/24 + 1;
    if (bornDays < 1) {
        return 1;
    } else if (bornDays > 364) {
        return 364;
    } else {
        return bornDays;
    }
}

+ (NSString *)stringOfBabyBornDateBySpecifiedFormat:(NSString *)specifiedFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:specifiedFormat];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDate *bornDate = [userDefault objectForKey:BABY_BORN_DATE_KEY];
    return [dateFormatter stringFromDate:bornDate];
}

+ (NSString *)stringOfDateBySpecifiedFormat:(NSString *)specifiedFormat bySourceDate:(NSDate *)sourceDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:specifiedFormat];
    return [dateFormatter stringFromDate:sourceDate];
}

@end
