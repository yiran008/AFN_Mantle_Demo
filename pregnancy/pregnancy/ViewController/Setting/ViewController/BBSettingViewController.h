//
//  BBSettingViewController.h
//  pregnancy
//
//  Created by yxy on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBShareMenu.h"
#import "BBLogin.h"
#import "UMSocialControllerService.h"
#import <CoreLocation/CoreLocation.h>
#import "BBBandInfomation.h"

@protocol BBSettingViewDelegate  <NSObject>

-(void)modifyPresonalCenter;

@end

@interface BBSettingViewController : BaseViewController
<
    UITableViewDataSource,
    UITableViewDelegate,
    UIActionSheetDelegate,
    UMSocialUIDelegate,
    ShareMenuDelegate,
    BBLoginDelegate,
    BBBandInfomationDelegate
>
@property(nonatomic, strong) ASIHTTPRequest *m_FatherUnbandRequest;
@property(assign) id<BBSettingViewDelegate> m_delegate;

@end
