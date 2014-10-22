//
// AFAppDotNetAPIClient.h
//  pregnancy
//
//  Created by heyanyang on 2014年9月28日 星期日.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"

static NSString * const AFAppDotNetAPIBaseURLString = @"https://www.babytree.com";

@implementation AFAppDotNetAPIClient

+ (instancetype)sharedClient
{
    return [self sharedClientWithUrl:nil];
}


+ (instancetype)sharedClientWithUrl:(NSString *)theUrl
{
    if (![theUrl isNotEmpty])
    {
        theUrl = AFAppDotNetAPIBaseURLString;
    }
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:theUrl]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

@end
