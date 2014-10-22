//
//  CommonErrorCode.m
//  lama
//
//  Created by mac on 13-6-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "CommonErrorCode.h"

@implementation CommonErrorCode

+ (NSString *) errorWithErrorCode:(BBCommonErrorCode)errorCode
{
    if (errorCode == ErrorCode_NoError)
    {
        return nil;
    }
    
    NSDictionary *errorCodeDic = nil;
    
    NSString *plistpath = [NSBundle pathForResource:@"CommonErrorCode"
                                             ofType:@"plist" inDirectory:[[NSBundle mainBundle] bundlePath]];
    errorCodeDic = [NSMutableDictionary dictionaryWithContentsOfFile:plistpath];
    
    NSString *error = [errorCodeDic stringForKey:[NSString stringWithFormat:@"%d", errorCode]];
    
    return error;
}

+ (NSString *) netErrorWithErrorCode:(NSString *)errorKey
{
    if (![errorKey isNotEmpty] || [errorKey isEqualToString:@"success"] || [errorKey isEqualToString:@"0"])
    {
        return nil;
    }
    
    NSDictionary *errorCodeDic = nil;
    
    NSString *plistpath = [NSBundle pathForResource:@"NetCommonErrorCode"
                                             ofType:@"plist" inDirectory:[[NSBundle mainBundle] bundlePath]];
    errorCodeDic = [NSMutableDictionary dictionaryWithContentsOfFile:plistpath];
    
    NSString *error = [errorCodeDic stringForKey:errorKey];
    
    return error;
}

@end
