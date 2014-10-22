//
//  BBIflyMSC.h
//  pregnancy
//
//  Created by whl on 14-9-2.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
// 带界面的语音识别控件
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"

#define IFLYMSC_APPID_VALUE     @"53e86989"


@interface BBIflyMSC : NSObject

+ (void)firstInit;

+ (IFlyRecognizerView *)CreateRecognizerView:(id<IFlyRecognizerViewDelegate>)delegate;

@end
