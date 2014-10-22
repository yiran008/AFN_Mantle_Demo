//
//  CommonErrorCode.h
//  lama
//
//  Created by mac on 13-6-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _BBCommonErrorCode
{
    ErrorCode_NoError = 0,                      // 无错误
    ErrorCode_Unknown = 1,                      // 未知错误
    ErrorCode_NetError,
} BBCommonErrorCode;


@interface CommonErrorCode : NSObject
+ (NSString *) errorWithErrorCode:(BBCommonErrorCode)errorCode;
+ (NSString *) netErrorWithErrorCode:(NSString *)errorKey;

@end
