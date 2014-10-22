//
//  BBAdPVManager.h
//  pregnancy
//
//  Created by liumiao on 5/5/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//
#import "BBAdModel.h"

@interface BBAdPVManager : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (BBAdPVManager*)sharedInstance;

/**
 *  增加本地广告PV统计，如果有测试链接，发送测试链接
 *
 *  @param data 广告相关数据
 */
- (void)addLocalPVForAd:(NSDictionary*)data;
- (void)addLocalPVForAdModel:(BBAdModel*)data;

/**
 *  发送本地广告PV统计，如果为0不发送,发送成功清空本地统计
 */
- (void)sendLocalAdPV;

@end
