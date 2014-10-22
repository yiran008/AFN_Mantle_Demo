//
//  BBKnowledgeRequest.h
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBKnowledgeRequest : NSObject
+ (ASIFormDataRequest *)collectKnowledgeWithID:(NSString *)ID isDelete:(BOOL)isDelete;
+ (ASIFormDataRequest *)getCollectedWithID:(NSString *)ID;
@end
