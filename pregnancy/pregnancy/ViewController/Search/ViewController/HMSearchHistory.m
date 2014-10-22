//
//  HMSearchHistory.m
//  lama
//
//  Created by songxf on 13-12-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMSearchHistory.h"

#define SEARCH_HISTORY_KEY @"SearchFunctionHistoryKey"

@implementation HMSearchHistory
// 查询功能的历史记录方法
+ (NSArray *)getSearchHistory
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault arrayForKey:SEARCH_HISTORY_KEY];
}

+ (void)setSearchHistory:(NSArray *)data
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault safeSetContainer:data forKey:SEARCH_HISTORY_KEY];
    [userDefault synchronize];
}

+ (void)clearSearchHistory
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:nil forKey:SEARCH_HISTORY_KEY];
    [userDefault synchronize];
}


@end
