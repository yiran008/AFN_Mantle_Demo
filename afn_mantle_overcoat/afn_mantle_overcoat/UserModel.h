//
//  MessageModel.h
//  afn_mantle_overcoat
//
//  Created by liumiao on 10/22/14.
//  Copyright (c) 2014 liumiao. All rights reserved.
//
#import "Mantle.h"

@interface UserModel : MTLModel <MTLJSONSerializing>
@property (copy, nonatomic, readonly) NSString *userId;
@property (copy, nonatomic, readonly) NSString *userName;
@end
