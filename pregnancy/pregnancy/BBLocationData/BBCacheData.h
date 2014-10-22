//
//  BBCacheData.h
//  pregnancy
//
//  Created by Wang Jun on 12-8-15.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PUBLISH_TOPIC_CACHE_TITLE @"publishTopicCacheTitle"
#define PUBLISH_TOPIC_CACHE_CONTENT @"publishTopicCacheContent"
#define PUBLISH_TOPIC_CACHE_IMAGE @"publishTopicCacheImage"
#define CURRENT_TOPIC_TITLE @"current_topic_title"

@interface BBCacheData : NSObject


+ (void)setCurrentTitle:(NSString *)title;
+ (NSString *)getCurrentTitle;
@end
