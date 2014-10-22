//
//  BBAttentionRequest.h
//  pregnancy
//
//  Created by MacBook on 14-9-1.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface BBAttentionRequest : NSObject

// 添加关注
+ (ASIFormDataRequest *)addFollow:(NSString *)u_id;

// 取消关注
+ (ASIFormDataRequest *)cancelFollow:(NSString *)u_id;

// 关注列表
+ (ASIFormDataRequest *)getFollowingList:(NSString *)u_id page:(NSInteger)pg limit:(NSInteger)limit;

// 粉丝列表
+ (ASIFormDataRequest *)getFollowedList:(NSString *)u_id page:(NSInteger)pg limit:(NSInteger)limit;

@end
