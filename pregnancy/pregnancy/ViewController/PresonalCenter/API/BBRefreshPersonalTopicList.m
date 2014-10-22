//
//  BBRefreshPersonalTopicList.m
//  pregnancy
//
//  Created by 王春月 on 12-8-13.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBRefreshPersonalTopicList.h"

@implementation BBRefreshPersonalTopicList
+ (void)setNeedRefreshPublishedTopicList:(BOOL)isNeed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (isNeed) {
        [defaults setObject:@"YES" forKey:@"RefreshPublishedTopicList"]; 
    }else {
        [defaults setObject:@"NO" forKey:@"RefreshPublishedTopicList"];
    }
    
}
+ (BOOL)NeedRefreshPublishedTopicList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *needStr = [defaults objectForKey:@"RefreshPublishedTopicList"];
    if (needStr==nil || [needStr isEqualToString:@"NO"]) {
        return NO;
    }
    return YES;
}


+ (void)setNeedRefreshReplyTopicList:(BOOL)isNeed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (isNeed) {
        [defaults setObject:@"YES" forKey:@"RefreshReplyTopicList"]; 
    }else {
        [defaults setObject:@"NO" forKey:@"RefreshReplyTopicList"];
    }
    
}
+ (BOOL)NeedRefreshReplyTopicList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *needStr = [defaults objectForKey:@"RefreshReplyTopicList"];
    if (needStr==nil || [needStr isEqualToString:@"NO"]) {
        return NO;
    }
    return YES;
}


+ (void)setNeedRefreshCollectionTopicList:(BOOL)isNeed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (isNeed) {
        [defaults setObject:@"YES" forKey:@"RefreshCollectionTopicList"]; 
    }else {
        [defaults setObject:@"NO" forKey:@"RefreshCollectionTopicList"];
    }
    
}
+ (BOOL)NeedRefreshCollectionTopicList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *needStr = [defaults objectForKey:@"RefreshCollectionTopicList"];
    if (needStr==nil || [needStr isEqualToString:@"NO"]) {
        return NO;
    }
    return YES;
}


+ (void)setNeedRefreshInboxTopicList:(BOOL)isNeed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (isNeed) {
        [defaults setObject:@"YES" forKey:@"RefreshInboxTopicList"]; 
    }else {
        [defaults setObject:@"NO" forKey:@"RefreshInboxTopicList"];
    }
}
+ (BOOL)NeedRefreshInboxTopicList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *needStr = [defaults objectForKey:@"RefreshInboxTopicList"];
    if (needStr==nil || [needStr isEqualToString:@"NO"]) {
        return NO;
    }
    return YES;
}


+ (void)setNeedRefreshOutboxTopicList:(BOOL)isNeed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (isNeed) {
        [defaults setObject:@"YES" forKey:@"RefreshOutboxTopicList"]; 
    }else {
        [defaults setObject:@"NO" forKey:@"RefreshOutboxTopicList"];
    }
    
}
+ (BOOL)NeedRefreshOutboxTopicList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *needStr = [defaults objectForKey:@"RefreshOutboxTopicList"];
    if (needStr==nil || [needStr isEqualToString:@"NO"]) {
        return NO;
    }
    return YES;
}

+ (void)setNeedRefreshPersonalCenter:(BOOL)isNeed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:isNeed] forKey:@"RefreshPersonalCenter"];
}
+ (BOOL)NeedRefreshPersonalCenter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rs = [defaults objectForKey:@"RefreshPersonalCenter"];
    return [rs boolValue];
}

@end
