//
//  HMDayRecommendModel.m
//  lama
//
//  Created by songxf on 13-6-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMDayRecommendModel.h"

@implementation HMDayRecommendModel
@synthesize recommendId;
@synthesize dayTime;
@synthesize dayRecommendList;

- (void)dealloc
{
    [dayTime release];
    [recommendId release];
    [dayRecommendList release];

    [super dealloc];
}

- (NSString *)getDateText
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dayTime doubleValue]];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *text = [formatter stringFromDate:date];
    
    return text;
}

@end
