//
//  BBMainPageRequest.h
//  pregnancy
//
//  Created by liumiao on 4/9/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest+BBDebug.h"
#import "BBConfigureAPI.h"
@interface BBMainPageRequest : NSObject

+ (ASIFormDataRequest *)recommendTopic;

+ (ASIFormDataRequest *)topBanner:(NSString *)appTypeId;

+ (ASIFormDataRequest *)getBannerAdvertisement;

+ (ASIFormDataRequest *)getMallHasNewItemStatus:(NSString *)lastTS;

// 下载加孕气请求
+ (ASIFormDataRequest *)addPreValueRequest;

@end
