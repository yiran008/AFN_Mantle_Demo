//
//  BBTopicDetail.h
//  pregnancy
//
//  Created by Jun Wang on 12-4-5.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
#import "BBUser.h"
#import "BBTopicDB.h"
#import "CallBack.h"
#import "MBProgressHUD.h"
#import "RefreshCallBack.h"
#import "ASIFormDataRequest.h"
#import "BBAppInfo.h"
#import "BBNavigationLabel.h"
#import "BBApp.h"
#import "BBAppConfig.h"
#import "MobClick.h"
#import "BBAppDelegate.h"
#import "BBCookie.h"
#import "BBHTTPHeaderADDInfo.h"
#import "ZXScanWatchQR.h"
#import "MobClick.h"
#import "BBOpenCtrlViewByString.h"

#import "BBLogin.h"
#import "BBRefreshPersonalTopicList.h"
//#import "BBNewTopicDetail.h"
#import "BBMusicTypeListController.h"
#import "ZXSanQR.h"
#import "BBPersonalViewController.h"
//#import "BBPostListPage.h"
#import "BBShareMenu.h"

#define RELOAD_WEBVIEW (@"reload_webview")

@interface BBSupportTopicDetail : BaseViewController
<
    WebViewJavascriptBridgeDelegate,
    RefreshCallBack,
    BBLoginDelegate,
    ShareMenuDelegate
> {
    UIWebView *topicDetailWebView;
    WebViewJavascriptBridge *javascriptBridge;
    MBProgressHUD *loadProgress;
    NSArray *photos;
    BOOL isFirstLoading;
    NSInteger dataIndex;
    NSString *loadURL;
}

@property (nonatomic, strong) UIWebView *topicDetailWebView;
@property (nonatomic, strong) WebViewJavascriptBridge *javascriptBridge;
@property (nonatomic, strong) NSDictionary *topicData;
@property (nonatomic, strong) MBProgressHUD *loadProgress;
@property (nonatomic, strong) NSArray *photos;
@property (assign) BOOL isFirstLoading;
@property (nonatomic, strong) NSString *loadURL;
@property (nonatomic, strong) NSMutableArray *topicInfo;

@property (nonatomic, assign) BOOL checkAppStore;
@property (nonatomic, assign) BOOL isShowCloseButton;
@property (nonatomic, assign) BOOL isReloadWebview;
@end
