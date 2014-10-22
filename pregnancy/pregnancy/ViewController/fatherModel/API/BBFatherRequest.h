//
//  BBFatherRequest.h
//  pregnancy
//
//  Created by songxf on 13-5-23.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBFatherInfo.h"
#import "BBConfigureAPI.h"
#import "ASIFormDataRequest+BBDebug.h"
#import "BBUser.h"

@interface BBFatherRequest : NSObject

// 获取（根据邀请码跟妈妈绑定的）爸爸账户
+ (ASIFormDataRequest *)bindUser:(NSString *)code;

// 删除爸爸账号的关联关系
+ (ASIFormDataRequest *)unbindUser;

@end