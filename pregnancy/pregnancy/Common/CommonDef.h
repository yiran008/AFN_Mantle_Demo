//
//  wiAppDelegate.h
//  wiIos
//
//  Created by xuanwenchao on 11-12-20.
//  Copyright (c) 2011年 Waptech (Beijing) Information Technologies, Ltd. All rights reserved.
//

#import "CommonMacros.h"

#import "CommonCategories.h"

#import "CommonLog.h"
#import "CommonErrorCode.h"

#import "PXAlertView.h"

#import "BaseViewController.h"
#import "RecordConfig.h"
#import "TaxiConfig.h"
#import "HospitalConfig.h"
#import "SmartWatchConfig.h"
#import "MusicConfig.h"
#import "BBCoverLayer.h"
#import "BBStatistic.h"


void DummyLog(NSString *format, ...);
void SetLogFile(NSString *fileName);
void DeleteLogFile(NSString *fileName);

float getScreenWidth(void);
float getScreenHeight(void);

NSString *getAppStringVersion(void);
NSString *getAppBuildStringVersion(void);
BOOL stringIsEmpty(NSString *str);

NSString *getDocumentsDirectoryWithFileName(NSString *fileName);

// 获取时钟(单位:微秒)
unsigned long long elapsedTimeMillis(void);
CGFloat BNRTimeBlock(void (^block)(void));
