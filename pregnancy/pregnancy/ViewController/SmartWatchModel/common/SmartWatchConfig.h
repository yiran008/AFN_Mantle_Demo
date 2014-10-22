//
//  SmartWatchConfig.h
//  pregnancy
//
//  Created by liumiao on 4/2/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#ifndef pregnancy_SmartWatchConfig_h
#define pregnancy_SmartWatchConfig_h

#define USE_SMARTWATCH_MODEL 1

#if USE_SMARTWATCH_MODEL
//#import "BBSupportTopicDetail.h"
#import "BBLogin.h"
#endif

//公共部分
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "GTMBase64.h"
#import "MobClick.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "ASIFormDataRequest+BBDebug.h"
#import "MBProgressHUD.h"


//工具部分
#import "BBConfigureAPI.h"
#import "BBUser.h"
#import "BBTimeUtility.h"
#import "BBNavigationLabel.h"
#import "BBSmartRequest.h"


//头文件

#import "BBSmartContractionView.h"
#import "BBSmartFetalmoveView.h"
#import "BBSmartWeighetView.h"
#import "BBSmartTakeWalkView.h"
#import "BBMainPage.h"
#import "BBSmartMainPage.h"
#import "BBSmartTakeWalkCell.h"
#import "BBSmartWeightCell.h"
#import "BBSmartContractionCell.h"
#import "BBContractionDetailCell.h"
#import "BBSmartFetalMoveCell.h"
#import "BBFetalMoveDetailCell.h"

#endif
