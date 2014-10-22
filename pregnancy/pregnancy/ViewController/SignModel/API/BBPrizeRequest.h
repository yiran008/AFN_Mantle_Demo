//
//  BBPrizeRequest.h
//  pregnancy
//
//  Created by babytree on 12-12-3.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest+BBDebug.h"
#import "BBConfigureAPI.h"

@interface BBPrizeRequest : NSObject
+ (ASIFormDataRequest *)prizeUserInfo;
+ (ASIFormDataRequest *)prizeSign;
+ (ASIFormDataRequest *)popLayerRequest;
@end
