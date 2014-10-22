//
//  BBRefreshPersonalTopicList.h
//  pregnancy
//
//  Created by 王春月 on 12-8-13.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBRefreshPersonalTopicList : NSObject
+ (void)setNeedRefreshPublishedTopicList:(BOOL)isNeed;
+ (BOOL)NeedRefreshPublishedTopicList;

+ (void)setNeedRefreshReplyTopicList:(BOOL)isNeed;
+ (BOOL)NeedRefreshReplyTopicList;

+ (void)setNeedRefreshCollectionTopicList:(BOOL)isNeed;
+ (BOOL)NeedRefreshCollectionTopicList;

+ (void)setNeedRefreshInboxTopicList:(BOOL)isNeed;
+ (BOOL)NeedRefreshInboxTopicList;

+ (void)setNeedRefreshOutboxTopicList:(BOOL)isNeed;
+ (BOOL)NeedRefreshOutboxTopicList;

+ (void)setNeedRefreshPersonalCenter:(BOOL)isNeed;
+ (BOOL)NeedRefreshPersonalCenter;

@end
