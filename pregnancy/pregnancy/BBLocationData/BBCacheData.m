//
//  BBCacheData.m
//  pregnancy
//
//  Created by Wang Jun on 12-8-15.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBCacheData.h"

#define GROUP_CACHE_DATA @"groupCacheData"
#define PUBLISH_TOPIC_CACHE_DATA @"publishTopicCacheData"
#define HOME_PAGE_AD_DATA @"homePageAdData"
#define TOPIC_COLLECT_STATUS_TEMP_DATA @"TopicCollectStatusTempData"

@implementation BBCacheData

+ (void)setCurrentTitle:(NSString *)title {
    if (title && [title isKindOfClass:[NSString class]])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:title forKey:CURRENT_TOPIC_TITLE];
    }
}

+ (NSString *)getCurrentTitle {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:CURRENT_TOPIC_TITLE];
}

@end
