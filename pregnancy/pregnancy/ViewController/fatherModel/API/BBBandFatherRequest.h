//
//  BBBandFatherRequest.h
//  pregnancy
//
//  Created by mac on 13-5-23.
//  Copyright (c) 2013年 babytree. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BBConfigureAPI.h"
#import "ASIFormDataRequest+BBDebug.h"


@interface BBBandFatherRequest : NSObject

// 绑定状态
+ (ASIFormDataRequest *)bindStatus;
// 取消绑定
+ (ASIFormDataRequest *)unBind;

@end