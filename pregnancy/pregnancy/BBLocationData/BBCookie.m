//
//  BBCookie.m
//  pregnancy
//
//  Created by 王春月 on 12-9-12.
//  Copyright (c) 2012年 Babytree. All rights reserved.
//

#import "BBCookie.h"

@implementation BBCookie

+ (void)pregnancyCookie:(NSString *)theCookie
{
    
    if (![theCookie isKindOfClass:[NSString class]] || theCookie == nil) {
        return;
    }
    NSString *encodeCookie = [theCookie stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //cookie
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"NL" forKey:NSHTTPCookieName];
    [cookieProperties setObject:encodeCookie forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@".babytree.com" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:86400*30] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

+ (void)cleanPregnancyCookie
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray) {
        [cookieJar deleteCookie:obj];
    }
    
}


@end
