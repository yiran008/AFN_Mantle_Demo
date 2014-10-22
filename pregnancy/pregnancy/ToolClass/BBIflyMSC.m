//
//  BBIflyMSC.m
//  pregnancy
//
//  Created by whl on 14-9-2.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBIflyMSC.h"

@implementation BBIflyMSC

+ (void)firstInit
{
    //初始化语音识别控件
    NSString *initString = [NSString stringWithFormat:@"%@=%@", [IFlySpeechConstant APPID], IFLYMSC_APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

+ (IFlyRecognizerView *)CreateRecognizerView:(id<IFlyRecognizerViewDelegate>)delegate
{
    if (!delegate)
    {
        return nil;
    }
    
    UIView *view = nil;
    if ([delegate isKindOfClass:[UIViewController class]])
    {
        view = ((UIViewController *)delegate).view;
    }
    else if ([delegate isKindOfClass:[UIView class]])
    {
        view = (UIView *)delegate;
    }
    else
    {
        return nil;
    }
    
    IFlyRecognizerView *iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:view.center];
    iflyRecognizerView.delegate = delegate;
    
    [iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    [iflyRecognizerView setParameter: @"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    // | result_type   | 返回结果的数据格式，可设置为json，xml，plain，默认为json。
    [iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //    [iflyRecognizerView setParameter:@"asr_audio_path" value:nil];   当你再不需要保存音频时，请在必要的地方加上这行。
    
    return iflyRecognizerView;
}


@end
