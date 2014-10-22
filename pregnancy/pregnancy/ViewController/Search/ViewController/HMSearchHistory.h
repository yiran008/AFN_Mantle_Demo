//
//  HMSearchHistory.h
//  lama
//
//  Created by songxf on 13-12-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMSearchHistory : NSObject

// 查询功能的历史记录方法
+ (NSArray *)getSearchHistory;
+ (void)setSearchHistory:(NSArray *)data;
+ (void)clearSearchHistory;

@end
