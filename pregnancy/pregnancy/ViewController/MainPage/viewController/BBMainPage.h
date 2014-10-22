//
//  BBMainPage.h
//  pregnancy
//
//  Created by whl on 14-4-2.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

//用户在其它页面进行身份切换后，需要发送通知告知主页，主页进行更新
#define USER_ROLE_CHANGED_NOTIFICATION @"USER_ROLE_CHANGED_NOTIFICATION"


@interface BBMainPage :BaseViewController

@end
