//
//  BBAppConfig.h
//  pregnancy
//
//  Created by zhangling on 13-1-16.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "CommonDef.h"

#ifndef pregnancy_BBAppConfig_h
#define pregnancy_BBAppConfig_h

#define IPHONE5_ADAPTATION  \
if ([[UIScreen mainScreen] bounds].size.height==568) {\
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;\
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 504);\
}

#define DEVICE_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define DEVICE_WIDTH    [UIScreen mainScreen].bounds.size.width

//#define IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height==568)

#define IPHONE5_ADD_HEIGHT(x) (IS_IPHONE5 ? (x) + 88 : (x))

#define IPHONE5_IMAGE_NAME(x) (IS_IPHONE5 ? [NSString stringWithFormat:@"%@_iphone5", (x)] :(x))

#define PREGNANCY_APPSTORE_DOWNLOADAPP_ADDRESS @"http://itunes.apple.com/cn/app/kuai-le-yun-qi-40zhou-quan/id523063187?mt=8"
#define PARENTING_APPSTORE_DOWNLOADAPP_ADDRESS @"http://itunes.apple.com/cn/app/kuai-le-yu-er/id570934785?mt=8"

//此appid为您所申请,请勿随意修改
//this APPID for your application,do not arbitrarily modify
#define XUNFEI_APPID (@"510a0bd9")
#define ENGINE_URL (@"http://dev.voicecloud.cn:1028/index.htm")
#define SHARE_DOWNLOAD_URL (@"http://m.babytree.com/app/pregnancy/wap.php")
#define H_CONTROL_ORIGIN (CGPointMake(20, 70))

#define IOS6_RELEASE_VIEW \
if ([self isViewLoaded]) {\
}

#define HAS_EVALUATE (NO)
#endif