//
//  BBSmartRequest.h
//  pregnancy
//
//  Created by whl on 13-11-14.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BBSmartRequest : NSObject

+ (ASIFormDataRequest *)smartWatchWeight:(NSString *)dateMonth;

+ (ASIFormDataRequest *)smartWatchContraction:(NSString *)pageStr;

+ (ASIFormDataRequest *)smartWatchWalk:(NSString *)dateMonth;

+ (ASIFormDataRequest *)smartWatchFetalMove:(NSString *)dateMonth withValueType:(BOOL)isMonth;

+ (ASIFormDataRequest *)relieveWatchBinding;

+ (ASIFormDataRequest *)bindStatus;

+ (ASIFormDataRequest *)bindWatch:(NSString *)bluetoothMac;

@end
