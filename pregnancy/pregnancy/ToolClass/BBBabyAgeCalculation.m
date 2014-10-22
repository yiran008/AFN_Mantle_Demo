//
//  BBBabyAgeCalculation.m
//  parenting
//
//  Created by 王春月 on 12-9-24.
//  Copyright (c) 2012年 Babytree. All rights reserved.
//

#import "BBBabyAgeCalculation.h"

@implementation BBBabyAgeCalculation

+ (NSString *)babyAgeWithStartDate:(NSDate *)startDate withStopDate:(NSDate *)stopDate
{
    NSString * babyAge = @"";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateCom = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:startDate toDate:stopDate options:0];
    NSInteger years = [dateCom year];
    NSInteger months = [dateCom month]; 
    NSInteger days = [dateCom day];
    
    if (days < 0 || months < 0 || years < 0) {
        babyAge = @"出生";
    } else if (years > 0) {
        if (months > 0) {
            babyAge = [NSString stringWithFormat:@";%d;岁;%d;个月",years,months];
        } else {
            babyAge = [NSString stringWithFormat:@";%d;岁",years];
        }
    } else if (years == 0) {
        if (months > 0) {
            if (days > 0) {
                babyAge = [NSString stringWithFormat:@";%d;个月;%d;天",months,days];
            } else if (days == 0) {
                babyAge = [NSString stringWithFormat:@";%d;个月",months];
            }
        } else if (months == 0) {
            babyAge = [NSString stringWithFormat:@";%d;天",days+1];
        }
    }
    return babyAge;
}

@end
