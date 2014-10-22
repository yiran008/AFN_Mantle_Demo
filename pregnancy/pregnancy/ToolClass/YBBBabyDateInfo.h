//
//  BBBabyDateInfo.h
//  parenting
//
//  Created by Wang Jun on 12-9-19.
//  Copyright (c) 2012年 Babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBBBabyDateInfo : NSObject

//返回今天的0点
+ (NSDate *)currentDate;

//宝宝出生日期
+ (void)setBabyBornDate:(NSDate *)bornDate;
+ (NSDate *)babyBornDate;

//宝宝出生天数
+ (NSInteger)babyBornDays;

//根据指定格式输出宝宝出生日期
+ (NSString *)stringOfBabyBornDateBySpecifiedFormat:(NSString *)specifiedFormat;

//根据指定格式输出指定日期
+ (NSString *)stringOfDateBySpecifiedFormat:(NSString *)specifiedFormat bySourceDate:(NSDate *)sourceDate;

@end
