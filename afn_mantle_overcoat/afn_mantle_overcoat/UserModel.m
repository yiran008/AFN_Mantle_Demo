//
//  MessageModel.m
//  afn_mantle_overcoat
//
//  Created by liumiao on 10/22/14.
//  Copyright (c) 2014 liumiao. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId" : @"enc_user_id",
             @"userName" : @"nickname"
             };
}

@end
