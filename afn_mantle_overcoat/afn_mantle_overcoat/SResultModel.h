//
//  SResultModel.h
//  afn_mantle_overcoat
//
//  Created by liumiao on 10/23/14.
//  Copyright (c) 2014 liumiao. All rights reserved.
//

#import "UserModel.h"

@interface SResultModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *total;
@property (nonatomic, readonly, copy) NSString *totalpg;
@property (nonatomic, readonly) NSArray *list;
@property (nonatomic, readonly, copy) NSString *status;
@property (nonatomic, readonly, copy) NSString *message;

@end
