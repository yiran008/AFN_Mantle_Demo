//
//  BBThirdUserRequest.h
//  pregnancy
//
//  Created by 柏旭 肖 on 12-7-5.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest+BBDebug.h"
#import "BBConfigureAPI.h"

#define UUID_KEY            @"uuid"
#define THIRD_SOURCE_KEY    @"source"
#define THIRD_SOURCE_SINA   @"sina"
#define THIRD_SOURCE_TX     @"tx"

#define THIRD_PART_LOGIN_SINA @"1"
#define THIRD_PART_LOGIN_TENCENT @"2"

@interface BBThirdUserRequest : NSObject

+ (ASIFormDataRequest *)thirdPartLogin:(NSString *)authToken withType:(NSString *)authType withUID:(NSString *)uid;

+ (ASIFormDataRequest *)thirdPartBindingNewUser:(NSString *)authToken withType:(NSString *)authType withNickname:(NSString *)name withEmail:(NSString *)email withBabyBirthday:(NSString *)babyBirthday withUID:(NSString *)uid;

@end
