//
//  RecordConfig.h
//  BBTestModel
//
//  Created by whl on 14-3-31.
//  Copyright (c) 2014年 王 鸿禄. All rights reserved.
//

#ifndef BBTestModel_RecordConfig_h
#define BBTestModel_RecordConfig_h

#define USE_RECORD_MODEL 1

/*
   1.抽离UI  VC cell  API 
   2.提取头文件 分类
   3.处理存储及配置
   4.宏控制耦合错误
 */

//公共部分
#import "UIButton+WebCache.h"
#import "MobClick.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshPullUpTableHeaderView.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "UMSocial.h"
#import <MessageUI/MessageUI.h>
#import "ASIFormDataRequest+BBDebug.h"
#import "UIImageView+WebCache.h"

//工具部分
#import "BBNavigationLabel.h"
#import "BBImageScale.h"
#import "NoticeUtil.h"
#import "UICopyLabel.h"
#import "BBTimeUtility.h"
#import "BBCustomNavigationController.h"
#import "BBPlaceholderTextView.h"
#import "BBAutoCalculationSize.h"
//#import "BBPersonalViewController.h"

//
#import "BBConfigureAPI.h"
#import "BBUser.h"
#import "BBCacheData.h"
#import "BBAppDelegate.h"
#import "BBShareMenu.h"
#import "PicReviewView.h"
#import "AlertUtil.h"
#import "BBWaterMarkViewController.h"


#endif
