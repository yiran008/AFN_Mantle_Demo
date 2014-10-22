//
//  HMRecommendData.h
//  lama
//
//  Created by songxf on 13-6-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMDayRecommendModel.h"
#import "BBConfigureAPI.h"
#import "ASIFormDataRequest+BBDebug.h"

@interface HMRecommendData : NSObject

// 初始化（拷贝）数据库
+ (void)initRecommendDB;

// 移除缓存
+ (BOOL)removeRecommendDB;

// 获得数据列表
+ (NSArray *)getRecommendDB;

// 插入多条数据
+ (BOOL)insertRecommendList:(NSArray *)dataList;

// 插入一条数据
+ (BOOL)insertRecommendDB:(HMDayRecommendModel *)data;

// 从服务器获取推荐列表
+ (ASIFormDataRequest *)getRecommendDataFromServer:(long long)start;


@end
