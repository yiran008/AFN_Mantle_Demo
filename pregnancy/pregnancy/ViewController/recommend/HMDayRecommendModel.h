//
//  HMDayRecommendModel.h
//  lama
//
//  Created by songxf on 13-6-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMRecommendModel.h"

@interface HMDayRecommendModel : NSObject

// 推荐id
@property (nonatomic, retain) NSString *recommendId;

// 推荐日期
@property (nonatomic, retain) NSString *dayTime;

// 推荐内容
@property (nonatomic, retain) NSArray  *dayRecommendList;


// 获取推荐日期
- (NSString *)getDateText;

@end
