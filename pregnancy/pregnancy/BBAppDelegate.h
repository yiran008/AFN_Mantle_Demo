//
//  BBAppDelegate.h
//  pregnancy
//
//  Created by whl on 14-4-2.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBMainTabbar.h"
#import "HMStartImageViewController.h"
#import "WXApi.h"

#import "HMDraftBoxSend.h"
#import "BBLogin.h"
#import <CoreLocation/CoreLocation.h>

#define Appkey @"4f8e312a52701573c9000041"
#define SinaWeibo_BaobaoshuYunqi @"2694160764"

@interface BBAppDelegate : UIResponder
<
    CLLocationManagerDelegate,
    UIApplicationDelegate,
    UITabBarControllerDelegate,
    SDWebImageManagerDelegate,
    HMDraftBoxSendDelegate,
    WXApiDelegate,
    BBLoginDelegate
>
{
    // 动画View
    UIView *addp_GifView;
    // 动画运行状态
    BOOL isAddp_Gif_Run;
    // 记录添加的孕气，用于激活后显示
    NSInteger addPlus;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) BBMainTabBar *m_mainTabbar;

@property (nonatomic, strong) HMDraftBoxSend *m_DraftBoxSend;
@property (strong, nonatomic) ASIFormDataRequest *adverteLimeiRequest;
@property (strong, nonatomic) ASIFormDataRequest *adverteDomobRequest;
@property (nonatomic, strong) CLLocationManager *userLocation;


// 发送报喜贴成功后返回我的圈子
@property (nonatomic, assign) BOOL m_bobyBornFinish;
// 通知主页显示报喜贴提醒
@property (nonatomic, assign) BOOL m_isBabyBornRemind;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)enterMainPage;
- (void)enterChoseRolePage;

- (void)pregnancyCookieInfo;
-(void)follow;

- (void)updatePushToken;
- (void)synchronizePrepareDueDate;

- (BOOL)saveToDraftBox:(HMDraftBoxData *)draftData modify:(BOOL)isModify;
- (BOOL)saveToDraftBox:(HMDraftBoxData *)draftData modify:(BOOL)isModify forSend:(BOOL)forSend;
- (void)sendWithDraftBox:(HMDraftBoxData *)draftData modify:(BOOL)isModify;

//蒙层展示
- (void)checkDisplayOperateGuide:(NSString*)guideKey;

- (void)clickGuideImageAction;

// 获取地理位置
-(void)getUserLocationInfomation;

@end
