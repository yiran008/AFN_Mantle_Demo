//
//  BBSmartMainPage.h
//  pregnancy
//
//  Created by whl on 13-11-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BBSmartMainPage : BaseViewController<UIAlertViewDelegate>

@property (nonatomic, strong) ASIFormDataRequest *relieveBindRequest;
@property (nonatomic, strong) MBProgressHUD *loadProgress;

@end
