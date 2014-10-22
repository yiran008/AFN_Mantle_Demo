//
//  BBKuaidiVerificationViewController.h
//  pregnancy
//
//  Created by MAYmac on 13-12-11.
//  Copyright (c) 2013年 babytree. All rights reserved.
//
//免单审核页面类
#import <UIKit/UIKit.h>

//通知打车记录等页面isapply状态发生了变化
@protocol BBKuaidiVerificationDelegate <NSObject>
@optional
- (void)verificationIsApply:(BOOL)isApply;
@end

@interface BBKuaidiVerificationViewController : BaseViewController
//必填,是否申请过
@property(nonatomic,assign)BOOL isApplied;
//必填,通知消息
@property(nonatomic,retain) NSString * infoStr;
@property(nonatomic,assign) id <BBKuaidiVerificationDelegate> delegate;
@end
