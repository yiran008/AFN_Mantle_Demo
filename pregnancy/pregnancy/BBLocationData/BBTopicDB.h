//
//  BBTopicDB.h
//  pregnancy
//
//  Created by babytree babytree on 12-3-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBTopicDB : NSObject

+ (BOOL)insertTopic:(NSDictionary *)topic;

+ (BOOL)delTopicByTopicId:(NSString *)topicId;

+ (BOOL)isExsitByTopicId:(NSString *)topicId;

+ (NSMutableArray *)topicList;

+ (NSInteger)topicListCount;

+ (NSString *)checkNil:(NSString *)str;

+ (NSMutableArray *)topicCollectList;

+ (void)deleteTopicCollectDatabase;

@end
