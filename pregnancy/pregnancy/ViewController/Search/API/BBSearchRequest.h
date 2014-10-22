//
//  BBSearchRequest.h
//  pregnancy
//
//  Created by yinxiaoyan on 14-4-15.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest+BBDebug.h"
#import "BBConfigureAPI.h"

@interface BBSearchRequest : NSObject

// 搜索帖子列表
+ (ASIFormDataRequest *)searchTopicList:(NSString *)key page:(NSInteger)pg;

// 搜索知识列表
+ (ASIFormDataRequest *)searchKnowledgeList:(NSString *)key page:(NSInteger)pg;

// 搜索用户列表
+ (ASIFormDataRequest *)searchUserList:(NSString *)key page:(NSInteger)pg;

@end
