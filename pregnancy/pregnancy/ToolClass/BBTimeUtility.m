//
//  BBTimeUtility
//
//  Created by ilike1980 on 11-11-2.
//  Last Updated by Wang Jun on 12-10-23.
//  Copyright 2011-2012 babytree. All rights reserved.
//

#import "BBTimeUtility.h"

@implementation BBTimeUtility

+ (NSString *)stringDateWithPastTimestamp:(NSTimeInterval)timestamp
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSInteger past = now - timestamp;
    if (past < 10 ) {
        return @"10秒以前";
    }
    if (past <60) {
        return [NSString stringWithFormat:@"%d秒以前",past]; 
    }
    if(past <3600){
        NSInteger min = past/60;
        return [NSString stringWithFormat:@"%d分钟以前",min]; 
    }
    if (past < 86400) {
        NSInteger hour = past/3600;
        return [NSString stringWithFormat:@"%d小时以前",hour];
    }
    if (past < 86400*2 ){
        NSInteger day = past/86400;
        return [NSString stringWithFormat:@"%d天以前",day];
    }
//    if (past < 86400*5 ){
//        NSInteger day = past/86400;
//        return [NSString stringWithFormat:@"%d天以前",day];
//    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return [dateFormat stringFromDate:date];
}

+ (NSString *)stringDateWithPastTimestampDetail:(NSTimeInterval)timestamp
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSInteger past = now - timestamp;
    if (past < 10 ) {
        return @"10秒以前";
    }
    if (past <60) {
        return [NSString stringWithFormat:@"%d秒以前",past];
    }
    if(past <3600){
        NSInteger min = past/60;
        return [NSString stringWithFormat:@"%d分钟以前",min];
    }
    if (past < 86400) {
        NSInteger hour = past/3600;
        return [NSString stringWithFormat:@"%d小时以前",hour];
    }
    if (past < 86400*2 ){
        NSInteger day = past/86400;
        return [NSString stringWithFormat:@"%d天以前",day];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormat stringFromDate:date];
}



+ (NSString *)stringAccuracyDateWithPastTimestamp:(NSTimeInterval)timestamp
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSInteger past = now - timestamp;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    
    if (past < 86400) {
        [dateFormat setDateFormat:@"今天 HH:mm"];
        return [dateFormat stringFromDate:date];
    } else if (past < 86400*2) {
        [dateFormat setDateFormat:@"昨天 HH:mm"];
        return [dateFormat stringFromDate:date];
    } else {
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateFormat stringFromDate:date];
    }
}

+ (NSString *)stringDateWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)stringDateWithFormat:(NSString *)format withDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringDateWithFormat:(NSString *)format withTimestamp:(NSTimeInterval)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}


+(NSDate*)getBeforeMonthDate:(NSDate*)curDate
{
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    NSDateComponents *comps = comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:curDate];
    [comps setYear:[comps year]];
    [comps setMonth:[comps month]-1];
    [comps setDay:1];
    NSDate *beforeDate = [calendar dateFromComponents:comps];
    return beforeDate;
}
+(NSDate*)getLastMonthDate:(NSDate*)curDate
{
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:curDate];
    [comps setYear:[comps year]];
    [comps setMonth:[comps month]+1];
    [comps setDay:1];
    NSDate *LastDate = [calendar dateFromComponents:comps];
    return LastDate;
}


+(NSDate*)getBeforeWeekDate:(NSDate*)curDate
{
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    NSDateComponents *comps= [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:curDate];
    [comps setWeek:[comps week]-1];
    NSDate *beforeDate = [calendar dateFromComponents:comps];
    return beforeDate;
}
+(NSDate*)getLastWeekDate:(NSDate*)curDate
{
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:curDate];
    [comps setWeek:[comps week]+1];
    NSDate *LastDate = [calendar dateFromComponents:comps];
    return LastDate;
}

+(NSString*)getWeekDateString:(NSDate*)curDate
{
    NSCalendar *greCalendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:curDate];
    NSInteger currentWeekDay = dateComponents.weekday;
    NSString *weekStr = nil;
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MM-dd"];
    if (currentWeekDay == 1) {
        weekStr = [formatter stringFromDate:curDate];
        [dateComponents setDay:[dateComponents day]-6];
        NSDate *beforeDate = [greCalendar dateFromComponents:dateComponents];
        weekStr =[NSString stringWithFormat:@"%@ 至 %@",[formatter stringFromDate:beforeDate],weekStr];
        
    }else if (currentWeekDay == 2){
        weekStr = [formatter stringFromDate:curDate];
        [dateComponents setDay:[dateComponents day]+6];
        NSDate *lateDate = [greCalendar dateFromComponents:dateComponents];
        weekStr =[NSString stringWithFormat:@"%@ 至 %@",weekStr,[formatter stringFromDate:lateDate]];
        
    }else if (currentWeekDay == 3){
        [dateComponents setDay:[dateComponents day]-1];
        NSDate *beforeDate = [greCalendar dateFromComponents:dateComponents];
        [dateComponents setDay:[dateComponents day]+6];
        NSDate *lateDate = [greCalendar dateFromComponents:dateComponents];
        weekStr =[NSString stringWithFormat:@"%@ 至 %@",[formatter stringFromDate:beforeDate],[formatter stringFromDate:lateDate]];
        
    }else if (currentWeekDay == 4){
        [dateComponents setDay:[dateComponents day]-2];
        NSDate *beforeDate = [greCalendar dateFromComponents:dateComponents];
        [dateComponents setDay:[dateComponents day]+6];
        NSDate *lateDate = [greCalendar dateFromComponents:dateComponents];
        weekStr =[NSString stringWithFormat:@"%@ 至 %@",[formatter stringFromDate:beforeDate],[formatter stringFromDate:lateDate]];
        
    }else if (currentWeekDay == 5){
        [dateComponents setDay:[dateComponents day]-3];
        NSDate *beforeDate = [greCalendar dateFromComponents:dateComponents];
        [dateComponents setDay:[dateComponents day]+6];
        NSDate *lateDate = [greCalendar dateFromComponents:dateComponents];
        weekStr =[NSString stringWithFormat:@"%@ 至 %@",[formatter stringFromDate:beforeDate],[formatter stringFromDate:lateDate]];
        
    }else if (currentWeekDay == 6){
        [dateComponents setDay:[dateComponents day]-4];
        NSDate *beforeDate = [greCalendar dateFromComponents:dateComponents];
        [dateComponents setDay:[dateComponents day]+6];
        NSDate *lateDate = [greCalendar dateFromComponents:dateComponents];
        weekStr =[NSString stringWithFormat:@"%@ 至 %@",[formatter stringFromDate:beforeDate],[formatter stringFromDate:lateDate]];
        
    }else if (currentWeekDay == 7){
        [dateComponents setDay:[dateComponents day]-5];
        NSDate *beforeDate = [greCalendar dateFromComponents:dateComponents];
        [dateComponents setDay:[dateComponents day]+6];
        NSDate *lateDate = [greCalendar dateFromComponents:dateComponents];
        weekStr =[NSString stringWithFormat:@"%@ 至 %@",[formatter stringFromDate:beforeDate],[formatter stringFromDate:lateDate]];
    }
    
    return weekStr;
}

+ (NSString *)stringAccuracyDateWithPastTimes:(NSTimeInterval)times
{   
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:times];
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    return [dateFormat stringFromDate:date];
}

+ (NSString *)babyAgeWithDueDate:(NSString *)dueDateStr
{
    if (dueDateStr == nil || [dueDateStr isEqualToString:@"false"] || [dueDateStr isEqualToString:@""] || [dueDateStr isEqualToString:@"0"]|| [dueDateStr isEqualToString:@"1970-01-01"])
    {
        return @"";
    }
    
    if ([dueDateStr isEqualToString:@"prepare"])
    {
        return @"备孕中";
    }
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dueDate = [dateFormatter dateFromString:dueDateStr];
    
    if (dueDate == nil)
    {
        return nil;
    }
    
    NSString * babyAge=@"";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateCom = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:dueDate toDate:[NSDate date] options:0];
    
    NSInteger years = [dateCom year];
    NSInteger months = [dateCom month];
    NSInteger days = [dateCom day];
    
    if (days < 0 || months < 0 || years < 0)
    {
        NSTimeZone* localzone = [NSTimeZone localTimeZone];
        NSTimeZone* beijingzone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        NSDate *now= [NSDate date];
        NSDate *day = [NSDate dateWithTimeInterval:([beijingzone secondsFromGMT] - [localzone secondsFromGMT]) sinceDate:now];
        NSDate *today = [day dateAtStartOfDay];
        
        
        NSInteger pregancyDays = 281 - [dueDate timeIntervalSinceDate:today]/3600/24;
        
        NSMutableString *pregnancyText = [[[NSMutableString alloc] init] autorelease];
        if (pregancyDays >= 280)
        {
            [pregnancyText appendString:@"恭喜您已经和宝宝见面"];
        }
        else
        {
            [pregnancyText appendString:@"孕"];
            
            int weekNum = (pregancyDays-1)/7;
            int dayNum = (pregancyDays-1)%7;
            if (weekNum>0)
            {
                [pregnancyText appendFormat:@"%d周",weekNum];
                if (dayNum>0)
                {
                    [pregnancyText appendFormat:@"零%d天",dayNum];
                }
            }
            else
            {
                if (dayNum>0)
                {
                    [pregnancyText appendFormat:@"%d天",dayNum];
                }
                else
                {
                    [pregnancyText appendFormat:@"0周0天"];
                }
            }
            babyAge = pregnancyText;
        }
    }
    else if (years > 0)
    {
        if (months > 0)
        {
            babyAge = [NSString stringWithFormat:@"宝宝%d岁%d个月",years,months];
        }
        else
        {
            babyAge = [NSString stringWithFormat:@"宝宝%d岁",years];
        }
    }
    else if (years == 0)
    {
        if (months > 0)
        {
            if (days > 0)
            {
                babyAge = [NSString stringWithFormat:@"宝宝%d个月%d天",months,days];
            }
            else if (days == 0)
            {
                babyAge = [NSString stringWithFormat:@"宝宝%d个月",months];
            }
        }
        else if (months == 0)
        {
            if (days == 0)
            {
                babyAge = @"宝宝出生";
            }
            else
            {
                babyAge = [NSString stringWithFormat:@"宝宝出生%d天",days+1];
            }
        }
    }
    
    return babyAge;
}

+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    
    
    return [comp1 day]   == [comp2 day] &&
    
    [comp1 month] == [comp2 month] &&
    
    [comp1 year]  == [comp2 year];
    
}

@end
