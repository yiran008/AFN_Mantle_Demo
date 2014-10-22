//
//  BBDeviceInfo.m
//  parenting
//
//  Created by Wang Jun on 12-9-19.
//  Copyright (c) 2012年 Babytree. All rights reserved.
//

#import "BBRemotePushInfo.h"

#define USER_DEVICE_MAC_ADDRESS (@"deviceMacAddress")
#define USER_DEVICE_TOKEN (@"deviceApplePushToken")

#define USER_IS_REGISTER_PUSH_TO_APPLE (@"isRegisterPushToApple")
#define USER_IS_REGISTER_PUSH_TO_BABYTREE (@"isRegisterPushToBabytree")

@implementation BBRemotePushInfo

+ (NSString *)getUserDeviceToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_DEVICE_TOKEN];
}

+ (void)setUserDeviceToken:(NSString *)theToken
{
    if (!([theToken isKindOfClass:[NSString class]]||theToken==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:theToken forKey:USER_DEVICE_TOKEN];
}

+ (BOOL)isRegisterPushToApple
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:USER_IS_REGISTER_PUSH_TO_APPLE] isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
}

+ (void)setIsRegisterPushToApple:(BOOL)theBOOL
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (theBOOL == YES) {
        [defaults setObject:@"YES" forKey:USER_IS_REGISTER_PUSH_TO_APPLE];
    } else {
        [defaults setObject:@"NO" forKey:USER_IS_REGISTER_PUSH_TO_APPLE];
    }
}

+ (BOOL)isRegisterPushToBabytree
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:USER_IS_REGISTER_PUSH_TO_BABYTREE] isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
}

+ (void)setIsRegisterPushToBabytree:(BOOL)theBOOL
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (theBOOL == YES) {
        [defaults setObject:@"YES" forKey:USER_IS_REGISTER_PUSH_TO_BABYTREE];
    } else {
        [defaults setObject:@"NO" forKey:USER_IS_REGISTER_PUSH_TO_BABYTREE];
    }
}

@end
