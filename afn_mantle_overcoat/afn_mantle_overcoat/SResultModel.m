//
//  SResultModel.m
//  afn_mantle_overcoat
//
//  Created by liumiao on 10/23/14.
//  Copyright (c) 2014 liumiao. All rights reserved.
//

#import "SResultModel.h"

@implementation SResultModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"total" : @"data.total",
             @"totalpg" : @"data.total_page",
             @"list" : @"data.user_list",
             @"status" : @"status",
             @"message" : @"message"
             };
}

// 针对list array里面包含其他model的情况
+ (NSValueTransformer *)listJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:UserModel.class];
}
@end
