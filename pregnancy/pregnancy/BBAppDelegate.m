
//
//  BBAppDelegate.m
//  pregnancy
//
//  Created by whl on 14-4-2.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBAppDelegate.h"
#import "BBFatherInfo.h"
#import "BBChoseRole.h"
#import "BBFirstLaunchGuide.h"
#import "BBAppInfo.h"
#import "BBCookie.h"
#import "BBUserRequest.h"
#import "BBUpdataManger.h"
#import "BBRecordMainPage.h"
#import "YBBDateSelect.h"
#import "BBTaxiMainPage.h"
#import "BBMessageList.h"
#import "BBRemotePushInfo.h"
#import "BBRegisterPush.h"
#import "HMDraftBoxViewController.h"
#import "MTStatusBarOverlay.h"
#import "BBAdRequest.h"
#import "HMShowPage.h"
#import "BBAdPVManager.h"
#import "YBBBabyDateInfo.h"
#import "BBKonwlegdeModel.h"
#import "BBKonwlegdeDB.h"
#import "BBBabyBornViewController.h"
#import "UMFeedbackChat.h"
#import "UMSocialQQHandler.h"
#import "BBSupportTopicDetail.h"
#import "BBHospitalRequest.h"
#import "SDImageCache.h"
#import "WSPX.h"
#import "BBTopicDetailLocationDB.h"
#import "UMSocialSinaHandler.h"
#import "BBKnowlegeViewController.h"
#import "BBKnowledgeCreateTool.h"
#import "BBGuideDB.h"
#import "HMDBVersionCheck.h"
#import "BBSelectHospitalArea.h"
#import "BBTopicHistoryDB.h"
#import "HMTopicDetailVC.h"
#import "HMCircleTopicVC.h"

#ifdef DEBUG
#import "TestHelper.h"
#endif

#define StatusBarOverlay_delay  3.0

#define kRemoteNotificationTopicTag 2
#define kRemoteNotificationWebURLTag 3
#define kRemoteNotificationShortMsgTag 4
#define kLocalNotificationCareRemindTag 5
#define kLocalNotificationFortyWeekTag 6
#define kAppEvaluateTag 7
#define UMFeedbackTag 8
#define kLocalNotificationUnbindTag 9
#define kLocalNotificationFatherTaskTag 10
#define kRemoteNotificationKuaiDiTag 11
#define kRemoteNotificationWebURLAskTag 12
#define KBBBaByBornLocationTag 122
#define KBBCutParentLocationTag 123
#define kMaxCacheSize       100
#define kAppUpdateTag               10000




@interface BBAppDelegate ()
{
    UIAlertView *s_PushAlertView;
    UIBackgroundTaskIdentifier bgTask;
}
@property (strong, nonatomic) NSMutableArray *s_PushData;
@property (strong, nonatomic) NSMutableArray *s_LocalPushData;
@property (nonatomic, strong) HMStartImageViewController *s_StartImageViewController;
@property (nonatomic, strong) NSDictionary *s_PushDic;
@property (nonatomic, strong) ASIHTTPRequest *s_PrepareRequest;
@property (nonatomic, strong) BBCoverLayerClass *s_cover;
@end

@implementation BBAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

-(void)dealloc
{
    [self.adverteLimeiRequest clearDelegatesAndCancel];
    [self.adverteDomobRequest clearDelegatesAndCancel];
    [self.s_PrepareRequest clearDelegatesAndCancel];
    self.userLocation.delegate = nil;
}

//Document目录下指定文件删除
-(void)withNameDeleteDataFile:(NSString *)name
{
    NSString *dbPath = getDocumentsDirectoryWithFileName(name);
    if ([NSFileManager exist:dbPath])
    {
        [NSFileManager deleteDocumentPathFile:dbPath];
    }
}

#pragma mark -  判断Document文件下是否存在该文件
-(BOOL)isExistFile:(NSString*)fileName
{
    NSString *path = getDocumentsDirectoryWithFileName(fileName);
    return [NSFileManager exist:path];
}

#pragma mark-  返回NO 表示升级用户  返回YES 表示新安装用户
-(BOOL)checkUserType
{
    if ([self isExistFile:@"pregnancy_calendar.db"] || [self isExistFile:@"pregnancy.db"] || [self isExistFile:@"knowledge.db"])
    {
        return NO;
    }
    return YES;
}


- (void)registerUmeng
{
    NSString *channelId = nil;
    NSString *resourcePath = [ [NSBundle mainBundle] resourcePath];
    NSString *uniquePath = [resourcePath stringByAppendingPathComponent:@"channel.dat"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave)
    {
        NSLog(@"no  have");
    }
    else
    {
        NSData *reader = [NSData dataWithContentsOfFile:uniquePath];
        channelId = [[NSString alloc] initWithData:reader encoding:NSUTF8StringEncoding];
        if ([channelId isEqualToString:@"appstroe"] || [channelId isEqualToString:@""])
        {
            channelId = nil;
        }
    }
    
    [UMSocialData setAppKey:Appkey];
    //友盟
    //reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    [MobClick startWithAppkey:Appkey reportPolicy:BATCH  channelId:channelId];
    [MobClick checkUpdate:@"有新版本" cancelButtonTitle:@"忽略此版本" otherButtonTitles:@"去Store下载"];
    [MobClick updateOnlineConfig];
    
    [WXApi registerApp:@"wxfb15b7e70bb0897f"];
    [UMSocialQQHandler setQQWithAppId:@"100246272" appKey:@"6134f4d4749bbeacad7270fdf52fb740" url:@"http://www.babytree.com/"];
    // 如果用户未安装qq客户端，允许网页授权
    [UMSocialQQHandler setSupportWebView:YES];
    // 打开新浪微博sso登陆，这里设置的url必须和新浪后台配置的回调url相同
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifndef DEBUG
    //debug模式不打开网络加速，方便抓包
    [WSPX start];
#endif
//    BOOL isNewUser;
//    isNewUser = [self checkUserType];
    
    [self updateNewVesion];
    //注册umeng数据
    [self registerUmeng];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self handleUserDefault];
#ifdef DEBUG
    self.window = [[iConsoleWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [TestHelper sharedInstance];
#else
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#endif
    self.window.backgroundColor = [UIColor whiteColor];

    if (![HMDBVersionCheck checkDraftBox_DBVer])
    {
        [HMDraftBoxDB deleteDraftBoxDB];
    }
    [HMDraftBoxDB createDraftBoxDB];
    
    // 创建话题详情浏览记录数据库
    if (![HMDBVersionCheck checkDetailRead_DBVer])
    {
        [BBTopicDetailLocationDB deleteTopicDetalLocationDB];
    }
    [BBTopicDetailLocationDB createTopicDetalLocationDB];
    [BBTopicHistoryDB createDataBase];
    [[BBAdPVManager sharedInstance]sendLocalAdPV];
    [[BBStatistic sharedInstance]sendStatisticData];
    self.s_PushDic = launchOptions;
    
    if (![BBAppInfo enableShowVersionUpdateGuideImage])
    {
        
        BBFirstLaunchGuide *firstLaunchGuide = [[BBFirstLaunchGuide alloc] initWithNibName:@"BBFirstLaunchGuide" bundle:nil];
//        firstLaunchGuide.isNewUser = isNewUser;
        BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc] initWithRootViewController:firstLaunchGuide];
        [navCtrl setColorWithImageName:@"navigationBg"];
        self.window.rootViewController = navCtrl;
        [self.window makeKeyAndVisible];
    }
    else
    {
        if ([BBUser getNewUserRoleState]==BBUserRoleStateNone)
        {
            //用户没有选择身份应该进入身份选择页面
            [self enterChoseRolePage];
        }
        else
        {
            [BBApp setAppLaunchStatus:YES];
            [self enterMainPage];
        }
        [self.window makeKeyAndVisible];
        //开机屏广告
        [self getStartImage];
    }
    

    //注册远程推送通知
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(umCheck:) name:UMFBCheckFinishedNotification object:nil];
    self.s_PushData = [[NSMutableArray alloc] init];
    self.s_LocalPushData = [[NSMutableArray alloc] init];
    
    [self registerNoticeLocationLaunchAPP];

    [self pregnancyScore];
    // 是否在首页显示报喜贴提醒
    if([BBUser getBabyBornReminderNum] >= 0)
    {
        self.m_isBabyBornRemind = YES;
    }
    
    return YES;
}


-(void)registerNoticeLocationLaunchAPP
{
    [NoticeUtil cancelCustomLocationNoti:@"BBPregnancyUserLaunchAPP"];
    NSDate *date = [NSDate dateWithDaysFromNow:7];
    NSDate *notidate = [[date dateAtStartOfDay]dateByAddingHours:9];
    NSInteger days = [BBPregnancyInfo daysOfPregnancy] + 7;
    NSString *appStr = @"你很久没有登录宝宝树孕育啦，宝宝树孕育想你啦！圈子里的姐妹们也想你啦！";
    if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
    {
        appStr = @"圈子里有很多备孕经验贴，快来看看吧！宝宝树孕育祝你备孕成功哦";
    }
    else
    {
        BBKonwlegdeModel *daysKnowledge = [BBKonwlegdeDB babyGrowthRecord:days];
        if ([daysKnowledge.title isNotEmpty])
        {
            appStr = daysKnowledge.title;
        }
    }
    [NoticeUtil registerCustomLocationNoti:appStr withNotiInfoName:@"BBPregnancyUserLaunchAPP" withNotiDate:notidate];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@", deviceToken];
    NSLog(@"deviceToken %@", deviceTokenString);
    [BBRemotePushInfo setUserDeviceToken:deviceTokenString];
    [BBRemotePushInfo setIsRegisterPushToApple:YES];
    
    ASIFormDataRequest *request = [BBRegisterPush registerPushNofitycation:deviceTokenString];
    [request setDidFinishSelector:@selector(registerPushFinished:)];
    [request setDidFailSelector:@selector(registerPushFailed:)];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([self skipToScheme:url.description])
    {
        return YES;
    }
    if([url.description hasPrefix:@"wx"]) {
        return  [WXApi handleOpenURL:url delegate:self];
    }else if([url.description hasPrefix:@"sina"]){
//        return (BOOL)[[UMSocialSnsService sharedInstance] performSelector:@selector(handleSinaSsoOpenURL:) withObject:url];
       return  [UMSocialSnsService handleOpenURL:url];
    }else {
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
        
    }
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    NSDictionary *remindData = notification.userInfo;
    if (application.applicationState == UIApplicationStateActive)
    {
        if ([[remindData stringForKey:@"localPushNotification"] isNotEmpty])
        {
            
            if ([[remindData stringForKey:@"localPushNotification"]isEqualToString:@"BBMotherBindingNoti"])
            {
                [MobClick event:@"push_v2" label:@"打开本地通知"];
                [MobClick event:@"push_v2" label:@"绑定准爸爸"];
                [NoticeUtil cancelCustomLocationNoti:@"BBMotherBindingNoti"];
                NSInteger curentPreCount = [BBPregnancyInfo getNotiCount];
                if (curentPreCount < 1)
                {
                    curentPreCount++;
                    [BBPregnancyInfo setNotiCount:curentPreCount];
                    NSDate *date = [NSDate dateWithDaysFromNow:3];
                    NSDate *notidate = [[date dateAtStartOfDay]dateByAddingHours:20];
                    [NoticeUtil registerCustomLocationNoti:@"谁说怀孕生娃只是女人的事情，快来请你的另一半来一起享受孕育的快乐吧!" withNotiInfoName:@"BBMotherBindingNoti" withNotiDate:notidate];
                }
          
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""   message:@"谁说怀孕生娃只是女人的事情，快来请你的另一半来一起享受孕育的快乐吧!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alertView setTag:kLocalNotificationUnbindTag];
                [alertView show];
            }
            else if([[remindData stringForKey:@"localPushNotification"]isEqualToString:@"BBBabyBornLocationNotice"])
            {
                [NoticeUtil cancelCustomLocationNoti:@"BBBabyBornLocationNotice"];
                [self pushLocationBabyBorn];
            }
            else if ([[remindData stringForKey:@"localPushNotification"]isEqualToString:@"BBNewCareRemindNoti"])
            {
                if ([self.s_LocalPushData count]>0)
                {
                    //为了防止由于多次触发schedule push导致的多次弹框，所以当有一个关爱提醒弹框已经在显示的时候，屏蔽后续的
                    return;
                }
                [self.s_LocalPushData addObject:remindData];
                NSString *remindContent = notification.alertBody;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"宝宝树孕育" message:remindContent delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"查看", nil];
                [alertView setTag:kLocalNotificationCareRemindTag];
                [alertView show];
            }
            else if ([[remindData stringForKey:@"localPushNotification"]isEqualToString:@"BBPregnancyUserLaunchAPP"])
            {
                [MobClick event:@"push_v2" label:@"打开本地通知"];
                [MobClick event:@"push_v2" label:@"7天召回"];
            }
            else if([[remindData stringForKey:@"localPushNotification"] isEqualToString:@"BBCutParentRemindNotice"])
            {
                [NoticeUtil cancelCustomLocationNoti:@"BBCutParentRemindNotice"];
                NSString *preStr = @"恭喜您的宝宝已经足月了，宝宝出生后建议您及时修改宝宝生日，获得更多育儿经验";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:preStr   message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"了解更多", nil];
                [alertView setTag:KBBCutParentLocationTag];
                [alertView show];
            }
        }
    }
    else if (application.applicationState == UIApplicationStateInactive)
    {
        if ([[remindData stringForKey:@"localPushNotification"] isNotEmpty]) {
            if ([[remindData stringForKey:@"localPushNotification"]isEqualToString:@"BBMotherBindingNoti"])
            {
                [MobClick event:@"push_v2" label:@"打开本地通知"];
                [MobClick event:@"push_v2" label:@"绑定准爸爸"];
                [NoticeUtil cancelCustomLocationNoti:@"BBMotherBindingNoti"];
                NSInteger curentPreCount = [BBPregnancyInfo getNotiCount];
                if (curentPreCount < 1)
                {
                    curentPreCount++;
                    [BBPregnancyInfo setNotiCount:curentPreCount];
                    NSDate *date = [NSDate dateWithDaysFromNow:3];
                    NSDate *notidate = [[date dateAtStartOfDay]dateByAddingHours:19];
                    [NoticeUtil registerCustomLocationNoti:@"谁说怀孕生娃只是女人的事情，快来请你的另一半来一起享受孕育的快乐吧!" withNotiInfoName:@"BBMotherBindingNoti" withNotiDate:notidate];
                }
            
            }
            else if([[remindData stringForKey:@"localPushNotification"]isEqualToString:@"BBBabyBornLocationNotice"])
            {
                [NoticeUtil cancelCustomLocationNoti:@"BBBabyBornLocationNotice"];
                [self pushLocationBabyBorn];
            }
            else if ([[remindData stringForKey:@"localPushNotification"]isEqualToString:@"BBNewCareRemindNoti"])
            {
                [self showRemindPage:remindData];
            }
            else if ([[remindData stringForKey:@"localPushNotification"]isEqualToString:@"BBPregnancyUserLaunchAPP"])
            {
                [MobClick event:@"push_v2" label:@"打开本地通知"];
                [MobClick event:@"push_v2" label:@"7天召回"];
            }
            else if([[remindData stringForKey:@"localPushNotification"] isEqualToString:@"BBCutParentRemindNotice"])
            {
                [NoticeUtil cancelCustomLocationNoti:@"BBCutParentRemindNotice"];
                NSString *preStr = @"恭喜您的宝宝已经足月了，宝宝出生后建议您及时修改宝宝生日，获得更多育儿经验";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:preStr   message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"了解更多", nil];
                [alertView setTag:KBBCutParentLocationTag];
                [alertView show];
            }
        }
    }
}


-(void)pushLocationBabyBorn
{
    [MobClick event:@"good_news_v2" label:@"邀请报喜弹层次数"];
    NSString *preStr = @"  亲爱的，宝宝已经出生了吗？快去圈子里报个喜吧，大家都等着你的好消息!";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:preStr   message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"残忍的拒绝",@"切换到快乐育儿",@"去报喜，晒宝宝", nil];
    [alertView setTag:KBBBaByBornLocationTag];
    [alertView show];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *applePushData = [userInfo dictionaryForKey:@"aps"];
    NSString *pushType = [applePushData stringForKey:@"t"];
    
    if (application.applicationState == UIApplicationStateActive) {
        if ([pushType isEqualToString:@"1"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"宝宝树孕育" message:[applePushData stringForKey:@"alert"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        } else if ([pushType isEqualToString:@"2"]) {
            [self.s_PushData addObject:applePushData];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"宝宝树孕育" message:[applePushData stringForKey:@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
            [alertView setTag:kRemoteNotificationTopicTag];
            [alertView show];
        } else if ([pushType isEqualToString:@"3"]) {
            [self.s_PushData addObject:applePushData];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"宝宝树孕育" message:[applePushData stringForKey:@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
            [alertView setTag:kRemoteNotificationWebURLTag];
            [alertView show];
        }else if ([pushType isEqualToString:@"11"]) {
            [self.s_PushData addObject:applePushData];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"宝宝树孕育" message:[applePushData stringForKey:@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
            [alertView setTag:kRemoteNotificationWebURLAskTag];
            [alertView show];
        }
        else if ([pushType isEqualToString:@"4"]) {
            [BBStatisticsUtil setEvent:@"push_type4"];
            
            if (s_PushAlertView == nil)
            {
                s_PushAlertView = [[UIAlertView alloc] initWithTitle:@"宝宝树孕育" message:[applePushData stringForKey:@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
                [s_PushAlertView setTag:kRemoteNotificationShortMsgTag];
                [s_PushAlertView show];
            }
        }
        else if ([pushType isEqualToString:@"8"])
        {
            if ([BBUser isLogin]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"宝宝树孕育" message:[applePushData stringForKey:@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
                [alertView setTag:kRemoteNotificationKuaiDiTag];
                [alertView show];
            }
        }
        else if ([pushType isEqualToString:@"5"])
        {
            NSInteger plus = [applePushData intForKey:@"yunqi"];
            if (plus > 0)
            {
                // 显示孕气动画
                [self showAddPregnancy:plus];
            }
        }
        
    } else if (application.applicationState == UIApplicationStateInactive) {
        if ([pushType isEqualToString:@"2"]) {
            [self showTopicPageWithData:applePushData];
            if ([[applePushData stringForKey:@"y"] isEqualToString:@"1"])
            {
                [MobClick event:@"push_topic_v2" label:[BBStringLengthByCount subStringByCount:[applePushData stringForKey:@"alert"]  withCount:20]];
            }

        }
        else if ([pushType isEqualToString:@"11"]) {
            [self showAskWebViewPageWithUrl:[applePushData stringForKey:@"u"]];
        }
        else if ([pushType isEqualToString:@"3"]) {
            [self showWebViewPageWithUrl:[applePushData stringForKey:@"u"]];
            if ([[applePushData stringForKey:@"y"] isEqualToString:@"1"])
            {
                [MobClick event:@"push_web_v2" label:[BBStringLengthByCount subStringByCount:[applePushData stringForKey:@"alert"]  withCount:20]];
            }
        } else if ([pushType isEqualToString:@"4"]) {
            [self showMessagePage];
        }
        else if ([pushType isEqualToString:@"8"])
        {
            [self showKuaidi];
        }
        else if ([pushType isEqualToString:@"5"])
        {
            addPlus = [applePushData intForKey:@"yunqi"];
        }
    }
}

- (void)launchRemoteNotification:(NSDictionary *)launchOptions
{
    //通过远程推送启动应用的处理
    if ([launchOptions dictionaryForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] != nil) {
        NSDictionary *applePushData = [[launchOptions dictionaryForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] dictionaryForKey:@"aps"];
        NSString *pushType = [applePushData stringForKey:@"t"];
        if ([pushType isEqualToString:@"2"])
        {
            if ([[applePushData stringForKey:@"y"] isEqualToString:@"1"])
            {
                [MobClick event:@"push_topic_v2" label:[BBStringLengthByCount subStringByCount:[applePushData stringForKey:@"alert"]  withCount:20]];
            }
            [self performSelector:@selector(showTopicPageWithData:) withObject:applePushData afterDelay:0.5];
        }
        else if ([pushType isEqualToString:@"11"])
        {
            [self performSelector:@selector(showAskWebViewPageWithUrl:) withObject:[applePushData stringForKey:@"u"] afterDelay:0.5];
        }
        else if ([pushType isEqualToString:@"3"])
        {
            if ([[applePushData stringForKey:@"y"] isEqualToString:@"1"])
            {
                [MobClick event:@"push_web_v2" label:[BBStringLengthByCount subStringByCount:[applePushData stringForKey:@"alert"]  withCount:20]];
            }
            [self performSelector:@selector(showWebViewPageWithUrl:) withObject:[applePushData stringForKey:@"u"] afterDelay:0.5];
        } else if ([pushType isEqualToString:@"4"])
        {
            [self performSelector:@selector(showMessagePage) withObject:nil afterDelay:0.5];
        }
        else if ([pushType isEqualToString:@"5"])
        {
            addPlus = [applePushData intForKey:@"yunqi"];
        }
        else if ([pushType isEqualToString:@"8"])
        {
            [self performSelector:@selector(showKuaidi) withObject:nil afterDelay:0.5];
        }
    }
}


- (void)launchLocalNotification:(NSDictionary *)launchOptions
{
    //通过本地推送启动应用的处理
    UILocalNotification *localPush = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localPush != nil)
    {
        NSDictionary *localPushDictionary = localPush.userInfo;
        if ([[localPushDictionary stringForKey:@"localPushNotification"] isNotEmpty])
        {
            if ([[localPushDictionary stringForKey:@"localPushNotification"]isEqualToString:@"BBMotherBindingNoti"])
            {
                [MobClick event:@"push_v2" label:@"打开本地通知"];
                [MobClick event:@"push_v2" label:@"绑定准爸爸"];
                [NoticeUtil cancelCustomLocationNoti:@"BBMotherBindingNoti"];
                NSInteger curentPreCount = [BBPregnancyInfo getNotiCount];
                if (curentPreCount < 1)
                {
                    curentPreCount++;
                    [BBPregnancyInfo setNotiCount:curentPreCount];
                    NSDate *date = [NSDate dateWithDaysFromNow:3];
                    NSDate *notidate = [[date dateAtStartOfDay]dateByAddingHours:20];
                    [NoticeUtil registerCustomLocationNoti:@"谁说怀孕生娃只是女人的事情，快来请你的另一半来一起享受孕育的快乐吧!" withNotiInfoName:@"BBMotherBindingNoti" withNotiDate:notidate];
                }
            }
            else if([[localPushDictionary stringForKey:@"localPushNotification"]isEqualToString:@"BBBabyBornLocationNotice"])
            {
                [NoticeUtil cancelCustomLocationNoti:@"BBBabyBornLocationNotice"];
                [self pushLocationBabyBorn];
            }
            else if ([[localPushDictionary stringForKey:@"localPushNotification"]isEqualToString:@"BBNewCareRemindNoti"])
            {
                [self showRemindPage:localPushDictionary];
            }
            else if([[localPushDictionary stringForKey:@"localPushNotification"] isEqualToString:@"BBCutParentRemindNotice"])
            {
                [NoticeUtil cancelCustomLocationNoti:@"BBCutParentRemindNotice"];
                NSString *preStr = @"恭喜您的宝宝已经足月了，宝宝出生后建议您及时修改宝宝生日，获得更多育儿经验";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:preStr   message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"了解更多", nil];
                [alertView setTag:KBBCutParentLocationTag];
                [alertView show];
            }
        }
    }
}


#pragma push action

-(void)showRemindPage:(NSDictionary*)localPushDictionary
{
    BBKnowlegeViewController * bkv = [[BBKnowlegeViewController alloc]init];
    NSString *knowledgeID = [localPushDictionary stringForKey:@"remindID"];
    BBKonwlegdeModel *remindModel = [BBKonwlegdeDB knowledgeByID:knowledgeID];
    if (remindModel)
    {
        [MobClick event:@"push_v2" label:@"关爱提醒点击"];
        bkv.startID = knowledgeID;
        bkv.m_CurVCType = KnowlegdeVCRemind;
        [self showPushView:bkv];
    }
}

- (void)showTopicPageWithData:(NSDictionary *)topicData
{
    [MobClick event:@"push_v2" label:@"打开帖子总数"];
    
    NSString *tid = [topicData stringForKey:@"id"];
    
    if (!([topicData isNotEmpty]&&[tid isNotEmpty]))
    {
        return;
    }
    
    UIViewController *vc = [self.m_mainTabbar getViewControllerAtIndex:self.m_mainTabbar.selectedIndex];
    [vc viewWillDisappear:NO];
    [vc.navigationController setNavigationBarHidden:NO];

    NSString *replyId = [topicData stringForKey:@"ri"];
    [BBStatistic visitType:BABYTREE_TYPE_TOPIC_PUSH contentId:tid];
    if ([replyId isNotEmpty])
    {
        [MobClick event:@"push_v2" label:@"推送打开获取个人回帖消息"];
        [HMShowPage showTopicDetail:vc topicId:tid topicTitle:nil replyID:replyId showError:YES];
    }
    else if ([[topicData stringForKey:@"p"] isNotEmpty])
    {
        NSString *pcount = [topicData stringForKey:@"p" defaultString:@"0"];
        if ([pcount intValue] == 0 || [pcount intValue] == 1)
        {
            pcount = [NSString stringWithFormat:@"0"];
        }
        else
        {
            pcount = [NSString stringWithFormat:@"%d",([pcount intValue] - 1) * 20 + 1 ];
        }
        
        [HMShowPage showTopicDetail:vc topicId:tid topicTitle:nil positionFloor:[pcount intValue]];
    }
    else if([[topicData stringForKey:@"tr"] isNotEmpty])
    {
        [MobClick event:@"push_v2" label:@"推送打开获取个人回帖消息"];
        NSString *response_count = [topicData stringForKey:@"tr"];
        [HMShowPage showTopicDetail:vc topicId:tid topicTitle:nil positionFloor:[response_count intValue]];
    }
    else
    {
        [HMShowPage showTopicDetail:vc topicId:tid topicTitle:nil replyID:replyId];
    }
}

- (void)showWebViewPageWithUrl:(NSString *)url
{
    [MobClick event:@"push_v2" label:@"打开一个url页面"];
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.isShowCloseButton = NO;
    exteriorURL.hidesBottomBarWhenPushed = YES;
    [exteriorURL setLoadURL:url];
    [self showPushView:exteriorURL];
}

- (void)showAskWebViewPageWithUrl:(NSString *)url
{
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.isShowCloseButton = NO;
    exteriorURL.hidesBottomBarWhenPushed = YES;
    [exteriorURL setLoadURL:url];
    [self showPushView:exteriorURL];
}

- (void)showMessagePage
{
    [MobClick event:@"push_v2" label:@"推送打开获取个人短消息"];
    BBMessageList *messageList = [[BBMessageList alloc] initWithNibName:@"BBMessageList" bundle:nil];
    messageList.m_CurrentMessageListType = BBMessageListTypeMessage;
     messageList.hidesBottomBarWhenPushed = YES;
    [self showPushView:messageList];
}

- (void)showKuaidi
{
    if ([BBUser isLogin]) {
        BBTaxiMainPage *taxiMainPage = [[BBTaxiMainPage alloc] initWithNibName:@"BBTaxiMainPage" bundle:nil];
        taxiMainPage.hidesBottomBarWhenPushed = YES;
        [self showPushView:taxiMainPage];
    }
}

-(void)showPushView:(UIViewController*)pushvc;
{
    pushvc.hidesBottomBarWhenPushed = YES;
    UIViewController *vc = [self.m_mainTabbar getViewControllerAtIndex:self.m_mainTabbar.selectedIndex];
    [vc viewWillDisappear:NO];
    [vc.navigationController setNavigationBarHidden:NO];
    [vc.navigationController pushViewController:pushvc animated:YES];
}

#pragma update token

- (void)updatePushToken
{
    //注册远程推送通知
    if ([BBRemotePushInfo isRegisterPushToApple] == NO) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
        
    } else if ([BBRemotePushInfo isRegisterPushToBabytree]) {
        ASIFormDataRequest *request = [BBRegisterPush registerPushNofitycation:[BBRemotePushInfo getUserDeviceToken]];
        [request setDidFinishSelector:@selector(registerPushFinished:)];
        [request setDidFailSelector:@selector(registerPushFailed:)];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}

- (void)registerPushFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *registerPushData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[registerPushData stringForKey:@"status"] isEqualToString:@"0"]||[[registerPushData stringForKey:@"status"] isEqualToString:@"success"]) {
        [BBRemotePushInfo setIsRegisterPushToBabytree:NO];
    }
}

- (void)registerPushFailed:(ASIFormDataRequest *)request
{
    
}

- (void)enterChoseRolePage
{
    BBChoseRole *choseRole = [[BBChoseRole alloc]initWithNibName:@"BBChoseRole" bundle:nil];
    BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:choseRole];
    [navCtrl setColorWithImageName:@"navigationBg"];
    self.window.rootViewController = navCtrl;
}

- (void)enterMainPage
{
    [BBAppInfo setEnableShowVersionUpdateGuideImage:YES];
    if (!self.m_mainTabbar)
    {
        self.m_mainTabbar = [[BBMainTabBar alloc]init];
    }
    [self.m_mainTabbar addViewControllers];
    self.window.rootViewController = self.m_mainTabbar;
    
    if ([self.s_PushDic isNotEmpty])
    {
        [self launchLocalNotification:self.s_PushDic];
        [self launchRemoteNotification:self.s_PushDic];
        self.s_PushDic = nil;
    }
}

- (void)getStartImage
{    
    self.s_StartImageViewController = [[HMStartImageViewController alloc] initWithNibName:@"HMStartImageViewController" bundle:nil];
    [self.window.rootViewController presentViewController:self.s_StartImageViewController animated:NO completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    application.applicationIconBadgeNumber = 0;
    [self registerNoticeLocationLaunchAPP];
}

- (void)performBackgroundTask
{
    __block UIBackgroundTaskIdentifier bTask =
    [[UIApplication sharedApplication]
     beginBackgroundTaskWithExpirationHandler:
     ^{
         [[UIApplication sharedApplication]
          endBackgroundTask:bTask];
         
         bTask = UIBackgroundTaskInvalid;
     }];
    
    [[SDImageCache sharedImageCache]cleanDisk];
    
    [[UIApplication sharedApplication] endBackgroundTask:bTask];
    bTask = UIBackgroundTaskInvalid;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[BBAdPVManager sharedInstance]sendLocalAdPV];
    [[BBStatistic sharedInstance]sendStatisticData];
    
    dispatch_queue_t background =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(background, ^{
        [self performBackgroundTask];
    });
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [WSPX activate];
    [MobClick updateOnlineConfig];
    [self updatePushToken];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self checkHasUMFeedBackReply];
    //获取用户地理位置
    [self getUserLocationInfomation];
    [UMSocialSnsService applicationDidBecomeActive];
    if (![BBApp getAdvertisingByLimeiStatus]) {
        [self.adverteLimeiRequest clearDelegatesAndCancel];
        self.adverteLimeiRequest = [BBUserRequest adverteActivateByLimei];
        self.adverteLimeiRequest.delegate = self;
        [self.adverteLimeiRequest setDidFinishSelector:@selector(activateByLimeiFinished:)];
        [self.adverteLimeiRequest setDidFailSelector:@selector(activateByLimeiFailed:)];
        [self.adverteLimeiRequest startAsynchronous];
    }
    if (![BBApp getAdvertisingByDomobStatus]) {
        [self.adverteDomobRequest clearDelegatesAndCancel];
        self.adverteDomobRequest = [BBUserRequest adverteActivateByDomob];
        self.adverteDomobRequest.delegate = self;
        [self.adverteDomobRequest setDidFinishSelector:@selector(activateByDomobFinished:)];
        [self.adverteDomobRequest setDidFailSelector:@selector(activateByDomobFailed:)];
        [self.adverteDomobRequest startAsynchronous];
    }
    [self pregnancyCookieInfo];
    application.applicationIconBadgeNumber = 0;
    //更新知识相关的数据库
    //[BBKnowledgeCreateTool createKnowledgeDB];
    [[BBUpdataManger sharedManager]startUpdate];
    
    if ([BBUser isCurrentUserBabyFather])
    {
        [MobClick event:@"launch_husband_v2" label:@"准爸爸启动次数"];
    }
    if ([BBUser getNewUserRoleState]==BBUserRoleStatePrepare)
    {
        [MobClick event:@"launch_prepare_v2" label:@"备用用户启动次数(妈妈+爸爸)"];
        [self synchronizePrepareDueDate];
    }
    else if ([BBUser getNewUserRoleState]==BBUserRoleStatePregnant)
    {
        [MobClick event:@"launch_pregnant_v2" label:@"孕期用户启动次数(妈妈+爸爸)"];
    }
    else if([BBUser getNewUserRoleState]==BBUserRoleStateHasBaby)
    {
        [MobClick event:@"launch_baby2_v2" label:@"育儿用户启动次数(妈妈+爸爸)"];
    }
    else if([BBUser getNewUserRoleState]==BBUserRoleStateNone)
    {
        [MobClick event:@"launch_other_v2" label:@"未选择状态用户启动次数"];
    }

    [BBTopicDetailLocationDB deleteSpareTopicDetailLacationData];
    [BBTopicHistoryDB deleteSpareTopicHistory];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    [WSPX stop];
}


#pragma mark - 好评
- (void)pregnancyScore
{
    if ([BBAppInfo enableScore]) {
        [self performSelector:@selector(appEvaluation) withObject:nil afterDelay:60];
    }
}
- (void)appEvaluation
{
    NSString *message = [NSString stringWithFormat:@"%@\n%@",@"喜欢我，就给我个好评吧！",@"我会继续努力的！"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"给我们评分" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"残忍的拒绝",@"恩，提个建议先",@"好,马上去好评", nil];
    [alertView setTag:kAppEvaluateTag];
    [alertView show];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kRemoteNotificationTopicTag)
    {
        if (buttonIndex == 1)
        {
            [self showTopicPageWithData:[self.s_PushData lastObject]];
            if ([[[self.s_PushData lastObject] stringForKey:@"y"] isEqualToString:@"1"])
            {
               [MobClick event:@"push_topic_v2" label:[BBStringLengthByCount subStringByCount:[[self.s_PushData lastObject] stringForKey:@"alert"]  withCount:20]];
            }
        }
        [self.s_PushData removeLastObject];
    }
    else if (alertView.tag == kRemoteNotificationWebURLTag)
    {
        if (buttonIndex == 1)
        {
            [self showWebViewPageWithUrl:[[self.s_PushData lastObject] stringForKey:@"u"]];
            if ([[[self.s_PushData lastObject] stringForKey:@"y"] isEqualToString:@"1"])
            {
                [MobClick event:@"push_web_v2" label:[BBStringLengthByCount subStringByCount:[[self.s_PushData lastObject] stringForKey:@"alert"]  withCount:20]];
            }
        }
        [self.s_PushData removeLastObject];
    }
    else if (alertView.tag == kRemoteNotificationWebURLAskTag) {
        if (buttonIndex == 1) {
            [self showAskWebViewPageWithUrl:[[self.s_PushData lastObject] stringForKey:@"u"]];
        }
        [self.s_PushData removeLastObject];
    }
    else if (alertView.tag == kRemoteNotificationShortMsgTag)
    {
        s_PushAlertView = nil;
        if (buttonIndex == 1)
        {
            [self showMessagePage];
        }
    }
    else if (alertView.tag == kRemoteNotificationKuaiDiTag)
    {
        if (buttonIndex == 1)
        {
            [self showKuaidi];
        }
    }
    else if (alertView.tag == kLocalNotificationCareRemindTag)
    {
        if (buttonIndex == 1)
        {
            NSDictionary *localDict = [self.s_LocalPushData lastObject];
            [self showRemindPage:localDict];
        }
        [self.s_LocalPushData removeLastObject];

    }
    else if (alertView.tag == kLocalNotificationFortyWeekTag)
    {
        if (buttonIndex == 1)
        {
            YBBDateSelect *dateSelect = [[YBBDateSelect alloc] initWithNibName:@"YBBDateSelect" bundle:nil];
             dateSelect.hidesBottomBarWhenPushed = YES;
            [self showPushView:dateSelect];
        }
    }
    else if (alertView.tag == UMFeedbackTag)
    {
        UMFeedbackChat *feedbackCtl = [[UMFeedbackChat alloc]initWithNibName:@"UMFeedbackChat" bundle:nil];
        feedbackCtl.title = @"建议反馈";
        [self showPushView:feedbackCtl];
    }
    else if(alertView.tag == kLocalNotificationUnbindTag)
    {
        if (buttonIndex == 1)
        {
            
        }
        
    }
    else if(alertView.tag == kLocalNotificationFatherTaskTag)
    {
        if (buttonIndex == 1)
        {
        }
    }
    else if (alertView.tag == kAppUpdateTag)
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PREGNANCY_APPSTORE_DOWNLOADAPP_ADDRESS]];
        }
    }
    else if(alertView.tag == KBBBaByBornLocationTag)
    {
        if(buttonIndex == 0)
        {
            return;
        }
        else if(buttonIndex == 1) {
            YBBDateSelect *modifyDueDate = [[YBBDateSelect alloc] initWithNibName:@"YBBDateSelect" bundle:nil];
            NSDate *defaultDate = [BBPregnancyInfo defaultDueDateForUserRoleState:BBUserRoleStateHasBaby];
            modifyDueDate.hidesBottomBarWhenPushed = YES;
            modifyDueDate.m_DefaultDateForRoleChange = defaultDate;
            
            BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:modifyDueDate];
            [navCtrl setColorWithImageName:@"navigationBg"];
            UIViewController *vc = [self.m_mainTabbar getViewControllerAtIndex:self.m_mainTabbar.selectedIndex];
            [vc viewWillDisappear:NO];
            [vc.navigationController setNavigationBarHidden:NO];
            [vc.navigationController presentViewController:navCtrl animated:YES completion:^{}];
        }
        else if(buttonIndex == 2)
        {
            [MobClick event:@"good_news_v2" label:@"邀请报喜弹层-去报喜"];
            if(![BBUser isLogin])
            {
                [self presentLoginWithLoginType:LoginBabyBorn];
            }
            else
            {
                [MobClick event:@"push_v2" label:@"打开本地通知"];
                [MobClick event:@"push_v2" label:@"报喜提醒"];
                BBBabyBornViewController *babyBornViewController = [[BBBabyBornViewController alloc] init];
                babyBornViewController.hidesBottomBarWhenPushed = YES;
                
                BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:babyBornViewController];
                [navCtrl setColorWithImageName:@"navigationBg"];
                UIViewController *vc = [self.m_mainTabbar getViewControllerAtIndex:self.m_mainTabbar.selectedIndex];
                [vc viewWillDisappear:NO];
                [vc.navigationController setNavigationBarHidden:NO];
                [vc.navigationController presentViewController:navCtrl animated:YES completion:^{}];
            }
        }
    }
    else if (alertView.tag == kAppEvaluateTag)
    {
        [BBAppInfo setEnableScoreToNO];
        if(buttonIndex == 0)
        {
            return;
        }
        if(buttonIndex == 1)
        {
            UMFeedbackChat *feedbackCtl = [[UMFeedbackChat alloc]initWithNibName:@"UMFeedbackChat" bundle:nil];
            feedbackCtl.hidesBottomBarWhenPushed = YES;
            feedbackCtl.title = @"建议反馈";
            [self showPushView:feedbackCtl];
        }
        else if(buttonIndex == 2)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=523063187"]];
        }
    }
    else if(alertView.tag == KBBCutParentLocationTag)
    {
        if(buttonIndex == 1)
        {
            [MobClick event:@"push_v2" label:@"38周提醒-确定点击"];
            [BBStatistic visitType:BABYTREE_TYPE_TOPIC_PUSH contentId:@"27492066"];
            HMTopicDetailVC *topicDetail = [[HMTopicDetailVC alloc]initWithNibName:@"HMTopicDetailVC" bundle:nil withTopicID:@"27492066" topicTitle:@"" isTop:NO isBest:NO];
            topicDetail.hidesBottomBarWhenPushed = YES;
            BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:topicDetail];
            [navCtrl setColorWithImageName:@"navigationBg"];
            
            UIViewController *vc = [self.m_mainTabbar getViewControllerAtIndex:self.m_mainTabbar.selectedIndex];
            [vc viewWillDisappear:NO];
            [vc.navigationController setNavigationBarHidden:NO];
            [vc.navigationController presentViewController:navCtrl animated:YES completion:^{}];
        }
    }
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark- 友盟反馈处理

-(void)checkHasUMFeedBackReply
{
    double delayInSeconds = 4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),^{
        [UMFeedback checkWithAppkey:Appkey];
        if (addPlus > 0)
        {
            // 显示孕气动画
            [self showAddPregnancy:addPlus];
            addPlus = 0;
        }
    });
    
}
- (void)umCheck:(NSNotification *)notification {
    if (notification.userInfo) {
        NSArray * newReplies = [notification.userInfo arrayForKey:@"newReplies"];
        if (newReplies.count > 0) {
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"您好，你的意见反馈我们的园丁已经回复，请您查看！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertview.tag = UMFeedbackTag;
            [alertview show];
        }
    }
}

#pragma mark- 整理UserDefault

-(void)handleUserDefault
{
    NSString *resetStringKey = [NSString stringWithFormat:@"resetStandardUserDefaultsVersion%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:resetStringKey] != YES)
    {
        [[BBUpdataManger sharedManager]removeKnowledgeDirectory];
        BOOL isNeedChange = YES;
        //5.0后续升级暂不调整
        if (![BBUser isUseNewRoleState])
        {
            isNeedChange = NO;
            //旧版升级5.0
            NSInteger choseRole = [BBFatherInfo getChoseRoleState];
            if (choseRole == 0)
            {
                //旧版没选择,设置新版没选择@"0"
                [BBUser setNewUserRoleState:BBUserRoleStateNone];
            }
            else if(choseRole == 1)
            {
                //旧版准爸爸,设置新版孕期+准爸爸
                if ([[BBFatherInfo getFatherUID] isNotEmpty])
                {
                    [BBUser setCurrentUserBabyFather:YES];

                }
                NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(280 - 22) * 3600 * 24];
                [BBPregnancyInfo setPregnancyTimeWithDueDate:date];
                [BBUser setNewUserRoleState:BBUserRoleStatePregnant];
                
            }
            else if(choseRole == 2)
            {
                //旧版准妈妈
                if ([[BBApp getProjectCategory]isEqualToString:@"0"])
                {
                    //旧版准妈妈孕期，设置新版孕期@"2"
                    [BBUser setNewUserRoleState:BBUserRoleStatePregnant];
                }
                else
                {
                    //旧版准妈妈育儿，设置新版育儿@"3"
                    [BBUser setNewUserRoleState:BBUserRoleStateHasBaby];
                    NSDate *babyBornDate = [YBBBabyDateInfo babyBornDate];
                    //由于旧版是育儿的话，生日是存放到YBBBabyDateInfo，新版都统一放到BBPregnancyInfo，所以要过渡一下
                    if (babyBornDate != nil)
                    {
                        [BBPregnancyInfo setPregnancyTimeWithDueDate:babyBornDate];
                    }
                    else
                    {
                        [BBPregnancyInfo setPregnancyTimeWithDueDate:[BBPregnancyInfo currentDate]];
                    }
                }
            }
            else if(choseRole == 3)
            {
                //旧版备孕，设置新版备孕@"1"
                [BBUser setNewUserRoleState:BBUserRoleStatePrepare];
            }
        }
        
        if (![BBGuideDB isExistCorverLayer])
        {
            [self setCoverLayerStatus:isNeedChange];
        }
        // 蒙层增加新key
        [self setCoverLayerNewStatus];
        
        [NoticeUtil cancelCareRemindLocationNoti];
        //取出一些需要保留的信息
        BBUserRoleState state = [BBUser getNewUserRoleState];
        NSDictionary *category =[BBHospitalRequest getHospitalCategory];
        NSString *name = [BBHospitalRequest getAddedHospitalName];
        NSString *hospitalState = [BBHospitalRequest getPostSetHospital];
        NSString *userLoginString = [BBUser getLoginString];
        NSString *userEmailAccount = [BBUser getEmailAccount];
        NSString *userAvatarUrl = [BBUser getAvatarUrl];
        NSString *userEncodeID = [BBUser getEncId];
        NSString *userGender = [BBUser getGender];
        NSString *userLevel = [BBUser getUserLevel];
        NSString *userNickname = [BBUser getNickname];
        NSString *userPassword = [BBUser getPassword];
        NSString *userRegisterTime = [BBUser getRegisterTime];
        NSString *userOnlyCity = [BBUser getUserOnlyCity];
        NSString *userLocalAvatar = [BBUser getLocalAvatar];
        NSString *userLocation = [BBUser getLocation];
        BOOL userNeedUploadAvatar = [BBUser needUploadAvatar];
        BOOL goScoreStatus = [BBAppInfo goScoreStatus];
        NSString *userBabyDate = [BBUser getBabyBirthday];
        NSDate *pregnancyDate = [BBPregnancyInfo dateOfPregnancy];
        NSInteger noticetime =  [NoticeUtil getNoticeTime];
        BOOL isNoticeOn = [NoticeUtil isNoticeOn];
        BOOL signState = [BBUser todaySignState];
        NSInteger babyBornRemindNum = [BBUser getBabyBornReminderNum];
        NSString *fatherUID = nil;
        NSString *fatherEncodeId = nil;
        NSString *motherUID = nil;
        NSString *inviteCode = nil;
        NSString *papaBindCode = nil;
        NSString *papaYunqi = nil;
        NSDate *papaPregnancy = nil;
        BOOL isCurrentFather = [BBUser isCurrentUserBabyFather];
        
        fatherUID = [BBFatherInfo getFatherUID];
        fatherEncodeId = [BBFatherInfo getFatherEncodeId];
        motherUID = [BBFatherInfo getMotherUID];
        inviteCode = [BBFatherInfo getInviteCode];
        papaPregnancy = [BBFatherInfo dateOfPregnancy];
        papaBindCode = [BBFatherInfo getPapaBindCode];
        papaYunqi = [BBFatherInfo getPapaYunqi];
        
        [self withNameDeleteDataFile:@"browsetopicdetail.db"];
        [self withNameDeleteDataFile:@"pregnancy_calendar.db"];
        [self withNameDeleteDataFile:@"pregnancy.db"];
        [self withNameDeleteDataFile:@"remindRecordNew.db"];
        
        //清理旧的userDefault信息
        NSDictionary *defaultsDictionary = [defaults dictionaryRepresentation];
        for (NSString *key in [defaultsDictionary allKeys])
        {
            const char *keyStr = [key cStringUsingEncoding:NSASCIIStringEncoding];
            char keyFirst = keyStr[0];
            
            if (keyFirst < 'A' || keyFirst > 'Z')
            {
                //NSLog(@"%@", key);
                [defaults removeObjectForKey:key];
            }
        }
        [defaults synchronize];
        
        
        //将取出的信息保存回去
        [BBApp setAppLaunchStatus:NO];
        [BBUser setNeedSynchronizeStatisticsDueDate:YES];
        [BBUser setNeedSynchronizeDueDate:NO];
        if (signState) {
            [BBUser setTodaySignState];
        }
        [NoticeUtil setNoticeTime:noticetime];
        [NoticeUtil setNoticeFlag:isNoticeOn];
        [BBUser setLoginString:userLoginString];
        [BBUser setEmailAccount:userEmailAccount];
        [BBUser setAvatarUrl:userAvatarUrl];
        [BBUser setEncodeID:userEncodeID];
        [BBUser setGender:userGender];
        [BBUser setNewUserRoleState:state];
        UIImage *avatarImage = [[UIImage alloc] initWithContentsOfFile:userLocalAvatar];
        if (avatarImage == nil) {
            [BBUser setLocalAvatar:nil];
        }else{
            [BBUser setLocalAvatar:userLocalAvatar];
        }
        [BBUser setLocation:userLocation];
        [BBUser setUserOnlyCity:userOnlyCity];
        [BBUser setNeedUploadAvatar:userNeedUploadAvatar];
        [BBUser setNickname:userNickname];
        [BBUser setPassword:userPassword];
        [BBUser setUserLevel:userLevel];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy年MM月dd日"];
        NSDate *regiterDate = [dateFormatter dateFromString:userRegisterTime];
        [BBUser setRegisterTime:[NSString stringWithFormat:@"%ld", (long)[regiterDate timeIntervalSince1970]]];
        [BBUser setBabyBirthday:userBabyDate];
        [BBHospitalRequest setHospitalCategory:category];
        [BBHospitalRequest setAddedHospitalName:name];
        [BBHospitalRequest setPostSetHospital:hospitalState];
        [BBAppInfo setGoScoreStatus:goScoreStatus];
        [BBUser setBabyBornReminderNum:babyBornRemindNum];
        [BBPregnancyInfo setPregnancyTimeWithDueDate:pregnancyDate];
        [BBUser setCurrentUserBabyFather:isCurrentFather];
        if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
        {
            [BBUser setNeedSynchronizePrepareDueDate:YES];
        }
        
        if (fatherUID != nil)
        {
            [BBFatherInfo setFatherUID:fatherUID];
        }
        if (fatherEncodeId != nil)
        {
            [BBFatherInfo setFatherEncodeId:fatherEncodeId];
        }
        if (motherUID != nil)
        {
            [BBFatherInfo setMotherUID:motherUID];
        }
        if (inviteCode != nil)
        {
            [BBFatherInfo setInviteCode:inviteCode];
        }
        if (papaBindCode != nil)
        {
            [BBFatherInfo setPapaBindCode:papaBindCode];
        }
        if (papaYunqi != nil)
        {
            [BBFatherInfo setPapaYunqi:papaYunqi];
        }
        if (papaPregnancy != nil)
        {
            [BBFatherInfo setBabyPregnancyTimeWithMenstrualDate:papaPregnancy];
        }
        [defaults setBool:YES forKey:resetStringKey];
        [defaults synchronize];
        [BBAppInfo setAppCurrentVersion];
    }
}
#pragma mark - Custom Method

- (void)updateNewVesion
{
    double delayInSeconds = 4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSString *URL = PARENTING_APPSTROE_CHECK_VERSION_ADDRESS;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:URL]];
        [request setHTTPMethod:@"POST"];
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        
        NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *dic = [parser objectWithString:results];
        
        if (![dic isDictionaryAndNotEmpty] || parser.error)
        {
            return;
        }
        
        NSArray *infoArray = [dic arrayForKey:@"results"];
        if ([infoArray count] > 0)
        {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *appVersion = [releaseInfo stringForKey:@"version"];
            [BBAppInfo setAppStoreVersion:appVersion];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([BBAppInfo needUpdateNewVersion]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"应用有新版本，现在就去更新？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                    alert.tag = kAppUpdateTag;
                    [alert show];
                }
            });
        }
    });
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"pregnancy" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"pregnancy.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// 显示孕气动画
- (void)showAddPregnancy:(NSInteger)plus
{
    // 判断妈妈版本
    
    if (isAddp_Gif_Run || plus <= 0)
    {
        return;
    }
    
    addp_GifView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, getScreenWidth(), getScreenHeight())];
    addp_GifView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, addp_GifView.height, 150, 150)];
    
    NSTimeInterval duration = 0.9f;
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 1; i <= 8; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"mother_addp_gif_%d", i]];
        [images addObject:image];
    }
    
    [imageView setImage:[images objectAtIndex:0]];
    [imageView setAnimationImages:images];
    [imageView setAnimationDuration:duration];
    [imageView setAnimationRepeatCount:0];
    
    [addp_GifView addSubview:imageView];
    [imageView centerHorizontallyInSuperViewWithTop:getScreenHeight()-100];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18.0f];
    label.text = [NSString stringWithFormat:@"老公给你\n+%d孕气", plus];
    label.numberOfLines = 0;
    
    CGSize remindTextSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(150, MAXFLOAT) withFont:label.font withString:label.text];
    label.width = remindTextSize.width;
    label.height = remindTextSize.height;
    
    
    [imageView addSubview:label];
    [label centerInSuperView];
    
    
    UIControl *control = [[UIControl alloc] initWithFrame:addp_GifView.bounds];
    [addp_GifView addSubview:control];
    [control addTarget:self action:@selector(closeAddp_GifView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.window addSubview:addp_GifView];
    
    imageView.alpha = 0.6;
    [imageView startAnimating];
    isAddp_Gif_Run = YES;
    [UIView beginAnimations:@"ShowAddp_GifView" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:2.8];
    
    if (IS_IPHONE5)
    {
        imageView.top = 150+88;
    }
    else
    {
        imageView.top = 150;
    }
    imageView.alpha = 1.0;
    
    [UIView commitAnimations];
}

- (void)closeAddp_GifView
{
    [self animationDidStop:@"ShowAddp_GifView" finished:nil context:nil];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)theContext
{
    if ([animationID isEqualToString:@"ShowAddp_GifView"] && addp_GifView != nil)
    {
        isAddp_Gif_Run = NO;
        [addp_GifView removeFromSuperview];
        addp_GifView = nil;
    }
}

- (void)pregnancyCookieInfo
{
    if ([BBUser localCookie]) {
        [BBCookie pregnancyCookie:[BBUser localCookie]];
    }
    
    if ([BBUser isLogin]) {
        ASIFormDataRequest *request = [BBUserRequest pregnancyCookie];
        [request setDidFinishSelector:@selector(cookieFinished:)];
        [request setDidFailSelector:@selector(cookieFailed:)];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}


- (void)cookieFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *cookieData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[cookieData stringForKey:@"status"] isEqualToString:@"0"] || [[cookieData stringForKey:@"status"] isEqualToString:@"success"]) {
        [BBCookie pregnancyCookie:[[cookieData dictionaryForKey:@"data"] stringForKey:@"cookie"]];
        [BBUser localCookie:[[cookieData dictionaryForKey:@"data"] stringForKey:@"cookie"]];
    }
}

- (void)cookieFailed:(ASIFormDataRequest *)request
{
    
}

- (void)follow
{
    //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeSina];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    
    if ([UMSocialAccountManager isOauthWithPlatform:snsPlatform.platformName])
    {
        [self sinaFollow];
        
        return;
    }
    snsPlatform.loginClickHandler(nil,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess)
        {
            [[UMSocialDataService defaultDataService] requestSnsFriends:platformName completion:^(UMSocialResponseEntity *response) {
                
                if (response.responseCode == UMSResponseCodeSuccess)
                {
                    NSArray *array = [response.data allKeys];
                    
                    for (NSString *key in array)
                    {
                        if ([key isEqualToString:SinaWeibo_BaobaoshuYunqi])
                        {
                            return;
                        }
                    }
                    
                    [self sinaFollow];
                }
            } ];
        }
    });
}


- (void)sinaFollow
{
    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeSina];
    
    NSArray *followArray = @[SinaWeibo_BaobaoshuYunqi];
    [[UMSocialDataService defaultDataService] requestAddFollow:platformName followedUsid:followArray completion:^(UMSocialResponseEntity *response) {
    }];
}

#pragma Mark - Draft box

- (BOOL)saveToDraftBox:(HMDraftBoxData *)draftData modify:(BOOL)isModify
{
    return [self saveToDraftBox:draftData modify:isModify forSend:NO];
}

- (BOOL)saveToDraftBox:(HMDraftBoxData *)draftData modify:(BOOL)isModify forSend:(BOOL)forSend
{
    BOOL result = NO;
    
    if (isModify)
    {
        result = [HMDraftBoxDB modifyDraftBoxDB:draftData];
    }
    else
    {
        result = [HMDraftBoxDB insertDraftBoxDB:draftData];
    }
    
    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
    overlay.animation = MTStatusBarOverlayAnimationFallDown;
    overlay.detailViewMode = MTDetailViewModeDetailText;
    if (result)
    {
        if (!forSend)
        {
            overlay.customBgColor = [UIColor colorWithHex:0x775599];
            [overlay postFinishMessage:@"保存到草稿箱" duration:StatusBarOverlay_delay];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_DRAFTBOX object:nil];
        }
    }
    else
    {
        overlay.customBgColor = [UIColor colorWithHex:0x999999];
        [overlay postErrorMessage:@"保存到草稿箱失败" duration:StatusBarOverlay_delay];
    }
    
    return result;
}

- (void)sendWithDraftBox:(HMDraftBoxData *)draftData modify:(BOOL)isModify
{
    if ([self saveToDraftBox:draftData modify:isModify forSend:YES])
    {
        if (self.m_DraftBoxSend == nil)
        {
            self.m_DraftBoxSend = [[HMDraftBoxSend alloc] init];
            self.m_DraftBoxSend.delegate = self;
        }
        
        MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
        overlay.animation = MTStatusBarOverlayAnimationFallDown;
        overlay.detailViewMode = MTDetailViewModeDetailText;
        overlay.customBgColor = [UIColor colorWithHex:0x999999];
        
        NSString *htext = nil;
        NSString *ctext = nil;
        
        if (draftData.m_IsReply)
        {
            htext = @"回复: ";
        }
        else
        {
            htext = @"发送: ";
        }
        
        if (draftData.m_Title.length <= 10)
        {
            if (![draftData.m_Title isNotEmpty])
            {
                ctext = [NSString stringWithFormat:@"%@...", @"图片"];
            }
            else
            {
                ctext = [NSString stringWithFormat:@"%@...", draftData.m_Title];
            }
        }
        else
        {
            ctext = [NSString stringWithFormat:@"%@...", [draftData.m_Title substringToIndex:8]];
        }
        
        if ([self.m_DraftBoxSend sendWithDraftBoxData:draftData])
        {
            NSString *text = [NSString stringWithFormat:@"%@%@", htext, ctext];
            
            //overlay.customBgColor = [UIColor colorWithHex:0x775599];
            [overlay postMessage:text];
        }
        else
        {
            NSString *text = [NSString stringWithFormat:@"%@%@失败,到草稿箱查看", htext, ctext];
            
            [overlay postErrorMessage:text duration:StatusBarOverlay_delay];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_DRAFTBOX object:nil];
    }
}

#pragma mark -
#pragma mark HMDraftBoxSendDelegate

// 图片上传进度
- (void)draftBoxUploadPicProgress:(HMDraftBoxData *)draftData atIndex:(NSInteger)index progress:(float)progress
{
    
}

// 上传成功
- (void)draftBoxSendSucceed:(HMDraftBoxData *)draftData atIndex:(NSInteger)index
{
    if (index < 0)
    {
        NSString *htext = nil;
        NSString *ctext = nil;
        
        if (draftData.m_IsReply)
        {
            htext = @"回复: ";
        }
        else
        {
            htext = @"发送: ";
        }
        
        if (draftData.m_Title.length <= 10)
        {
            if (![draftData.m_Title isNotEmpty])
            {
                ctext = @"图片";
            }
            else
            {
                ctext = draftData.m_Title;
            }
        }
        else
        {
            ctext = [NSString stringWithFormat:@"%@...", [draftData.m_Title substringToIndex:8]];
        }
        
        NSString *text = [NSString stringWithFormat:@"%@%@完成", htext, ctext];
        
        MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
        overlay.animation = MTStatusBarOverlayAnimationFallDown;
        overlay.detailViewMode = MTDetailViewModeDetailText;
        overlay.customBgColor = [UIColor colorWithHex:0x775599];
        [overlay postFinishMessage:text duration:StatusBarOverlay_delay];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_DRAFTBOX object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_PERSON_POST object:nil];
        
        [MobClick event:@"discuz_v2" label:@"成功发帖数量"];
        if ([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
        {
            [MobClick event:@"discuz_v2" label:@"成功发帖数量-育儿"];
        }
        else if([BBUser getNewUserRoleState] == BBUserRoleStatePregnant)
        {
            [MobClick event:@"discuz_v2" label:@"成功发帖数量-孕期"];
        }
        else
        {
            [MobClick event:@"discuz_v2" label:@"成功发帖数量-备孕"];
        }
        
//        NSMutableArray *shareArray = [NSMutableArray arrayWithCapacity:0];
//        
//        if (draftData.m_ShareType & HMTopicShareSina)
//        {
//            [shareArray addObject:UMShareToSina];
//        }
//        if (draftData.m_ShareType & HMTopicShareTenc)
//        {
//            [shareArray addObject:UMShareToTencent];
//        }
        
        NSString *fromStr = @"（分享自宝宝树孕育）";
        NSString *shareURL = draftData.m_ShareUrl;
        
        NSString *tagStr = @"详情：";
        NSString *str = [NSString stringWithFormat:@"...  %@%@ %@",tagStr, shareURL, fromStr];
        NSString *titleStr = [NSString stringWithFormat:@"#孕期交流#【%@】",draftData.m_Title];
        
        
        NSInteger subConlength = 140 - str.length - titleStr.length;
        
        if (subConlength < 0)
        {
            subConlength = 0;
        }
        
        NSString *content = draftData.m_Content;
        if (![content isNotEmpty])
        {
            content = @"";
        }
        
        NSString *theSubCon = content.length > subConlength ? [content substringToIndex:subConlength] : content;
        
        NSString *shareText = [NSString stringWithFormat:@"%@%@%@", titleStr,theSubCon, str];
        
        UIImage *image = nil;
        if ([draftData.m_PicArray isNotEmpty])
        {
            HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:0];
            image = [UIImage imageWithData:draftBoxPic.m_Photo_data];
        }
        else
        {
            image = [UIImage imageNamed:@"topic_share_icon"];
        }
        [UMSocialData openLog:YES];
        
        /*
         取消该功能：发帖同步到QQ空间
        if (draftData.m_ShareType & HMTopicShareQzone)
        {
            [UMSocialData defaultData].extConfig.qzoneData.url = shareURL;
            [UMSocialData defaultData].extConfig.qzoneData.title = titleStr;
            // QQ空间修改sharetext为分享帖子内容
            NSString *content = draftData.m_Content;
            if (![content isNotEmpty])
            {
                content = @"";
            }
    
            NSString *theSubCon = content.length > 120 ? [content substringToIndex:content.length] : content;
            
            [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"%@%@",theSubCon, fromStr];
            [UMSocialData defaultData].shareImage = image;
            
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone];
            UIViewController *vc = [self.m_mainTabbar getViewControllerAtIndex:self.m_mainTabbar.selectedIndex];
            snsPlatform.snsClickHandler(vc,[UMSocialControllerService defaultControllerService],YES);
        }
        */
        
        if (draftData.m_ShareType & HMTopicShareSina)
        {
            NSMutableArray *shareArray = [NSMutableArray arrayWithObject:UMShareToSina];
            
            [[UMSocialControllerService defaultControllerService].socialDataService postSNSWithTypes:shareArray content:shareText image:image location:nil urlResource:nil completion:^(UMSocialResponseEntity *response)
             {
                 
             }];
            
        }
        
        if (draftData.m_ShareType & HMTopicShareTenc)
        {
            NSMutableArray *shareArray = [NSMutableArray arrayWithObject:UMShareToTencent];
            
            [[UMSocialControllerService defaultControllerService].socialDataService postSNSWithTypes:shareArray content:shareText image:image location:nil urlResource:nil completion:^(UMSocialResponseEntity *response)
             {
                 
             }];
        }

        
//        if ([shareArray isNotEmpty])
//        {
//            [[UMSocialControllerService defaultControllerService].socialDataService postSNSWithTypes:shareArray content:shareText image:image location:nil urlResource:nil completion:^(UMSocialResponseEntity *response)
//             {
//
//             }];
//        }
    }
}

// 上传失败
- (void)draftBoxSendFail:(HMDraftBoxData *)draftData atIndex:(NSInteger)index error:(NSString *)errorText
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_DRAFTBOX object:nil];
    
    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
    overlay.animation = MTStatusBarOverlayAnimationFallDown;
    overlay.detailViewMode = MTDetailViewModeDetailText;
    overlay.customBgColor = [UIColor colorWithHex:0x999999];
    
    if (index < 0)
    {
        NSString *text;
        
        if ([errorText isNotEmpty])
        {
            text = errorText;
        }
        else
        {
            NSString *htext = nil;
            NSString *ctext = nil;
            
            if (draftData.m_IsReply)
            {
                htext = @"回复: ";
            }
            else
            {
                htext = @"发送: ";
            }
            
            if (draftData.m_Title.length <= 10)
            {
                if (![draftData.m_Title isNotEmpty])
                {
                    ctext = @"图片";
                }
                else
                {
                    ctext = draftData.m_Title;
                }
            }
            else
            {
                ctext = [NSString stringWithFormat:@"%@...", [draftData.m_Title substringToIndex:8]];
            }
            
            text = [NSString stringWithFormat:@"%@%@失败,到草稿箱查看", htext, ctext];
        }
        
        [overlay postErrorMessage:text duration:StatusBarOverlay_delay];
    }
    else
    {
        if ([errorText isNotEmpty])
        {
            [overlay postErrorMessage:errorText duration:StatusBarOverlay_delay];
        }
        else
        {
            [overlay postErrorMessage:@"发送图片失败,到草稿箱查看" duration:StatusBarOverlay_delay];
        }
    }
}


-(void)presentLoginWithLoginType:(LoginType)type
{
    BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
    login.m_LoginType = BBPresentLogin;
    BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
    [navCtrl setColorWithImageName:@"navigationBg"];
    login.delegate = self;
    UIViewController *vc = [self.m_mainTabbar getViewControllerAtIndex:self.m_mainTabbar.selectedIndex];
    [vc viewWillDisappear:NO];
    [vc.navigationController setNavigationBarHidden:NO];
    [vc.navigationController presentViewController:navCtrl animated:YES completion:^{}];
}

- (void)loginFinish
{
    [MobClick event:@"push_v2" label:@"打开本地通知"];
    [MobClick event:@"push_v2" label:@"报喜提醒"];
    BBBabyBornViewController *babyBornViewController = [[BBBabyBornViewController alloc] init];
    babyBornViewController.hidesBottomBarWhenPushed = YES;
    [self showPushView:babyBornViewController];
}
- (void)activateByLimeiFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *adverteData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[adverteData stringForKey:@"status"] isEqualToString:@"success"]) {
        [BBApp setAdvertisingByLimeiStatus:YES];
    }
}

- (void)activateByLimeiFailed:(ASIFormDataRequest *)request
{
    
}
- (void)activateByDomobFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *adverteData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[adverteData stringForKey:@"status"] isEqualToString:@"success"]) {
        [BBApp setAdvertisingByDomobStatus:YES];
    }
}

- (void)activateByDomobFailed:(ASIFormDataRequest *)request
{
    
}

//登录用户切换备孕 同步预产期
- (void)synchronizePrepareDueDate
{
    if ([BBUser isLogin] && [BBUser needSynchronizePrepareDueDate] && [BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = @"2100-01-01 00:00:00";
        NSDate *prepareDate = [formatter dateFromString:dateStr];
        [self.s_PrepareRequest clearDelegatesAndCancel];
        NSString *babyStatus = [BBPregnancyInfo clientStatusOfUserRoleState:BBUserRoleStatePrepare];
        self.s_PrepareRequest = [BBUserRequest modifyUserDueDate:prepareDate changeToStatus:babyStatus];
        [self.s_PrepareRequest setDidFinishSelector:@selector(synchronizePrepareDueDateFinish:)];
        [self.s_PrepareRequest setDidFailSelector:@selector(synchronizePrepareDueDateFail:)];
        [self.s_PrepareRequest setDelegate:self];
        [self.s_PrepareRequest startAsynchronous];
    }
}

#pragma mark- 同步预产期请求返回

- (void)synchronizePrepareDueDateFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[jsonDictionary stringForKey:@"status"] isEqualToString:@"success"])
    {
        [BBUser setNeedSynchronizePrepareDueDate:NO];
    }
}

- (void)synchronizePrepareDueDateFail:(ASIFormDataRequest *)request
{
    
}

//蒙层版本过度
-(void)setCoverLayerStatus:(BOOL)isShow
{
    [BBGuideDB createCoverLayerLocationDB];
    NSMutableArray *coverKeys = [NSMutableArray arrayWithObjects:ENABLE_SHOW_HOME_PAGE,ENABLE_SHOW_COMMUNITY_ADD,ENABLE_SHOW_COMMUNITY_MAIN,ENABLE_SHOW_TOPIC_PAGE,ENABLE_SHOW_TAXI_MAINHOME_PAGE,nil];
    if ([BBGuideDB createCoverLayerLocationDB])
    {
        for (NSString *coverLayerKey in coverKeys)
        {
            BBCoverLayerClass *cover = [BBGuideDB getCoverLayerClass:coverLayerKey withIsShow:YES];
            if (isShow)
            {
                if ([coverLayerKey isEqualToString:ENABLE_SHOW_HOME_PAGE])
                {
                    cover.m_IsShow = [BBAppInfo enableShowHomePageGuideImage];
                }
                else if([coverLayerKey isEqualToString:ENABLE_SHOW_COMMUNITY_ADD])
                {
                    cover.m_IsShow = [BBAppInfo enableShowCommunityAddPageGuideImage];
                }
                else if([coverLayerKey isEqualToString:ENABLE_SHOW_TOPIC_PAGE])
                {
                    cover.m_IsShow = [BBAppInfo enableShowTopicPageGuideImage];
                }
                else if([coverLayerKey isEqualToString:ENABLE_SHOW_TAXI_MAINHOME_PAGE])
                {
                    cover.m_IsShow = [BBAppInfo enableShowTaxiMainPageGuideImage];
                }

            }
            [BBGuideDB insertAndUpdateCoverLayerData:cover];
        }
    }
}

-(void)setCoverLayerNewStatus
{
    //增加新Key 时补充
    [BBGuideDB createCoverLayerLocationDB];
    NSMutableArray *coverKeys = [NSMutableArray arrayWithObjects:GUIDE_SHOW_HOME_PAGE,GUIDE_SHOW_TOPIC_PAGE,nil];
    if ([BBGuideDB createCoverLayerLocationDB])
    {
        for (NSString *coverLayerKey in coverKeys)
        {
            BBCoverLayerClass *cover = [BBGuideDB getCoverLayerClass:coverLayerKey withIsShow:YES];
            [BBGuideDB insertAndUpdateCoverLayerData:cover];
        }
    }
}


#pragma mark- 显示蒙层

- (void)checkDisplayOperateGuide:(NSString*)guideKey
{
     self.s_cover = [BBGuideDB getCoverLayerData:guideKey];
    if (self.s_cover && self.s_cover.m_IsShow)
    {
        UIButton *guideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        guideButton.tag = 10011;
        guideButton.exclusiveTouch = YES;
        [guideButton setFrame:CGRectMake(0, 0, 320, (480+88))];
        if([guideKey isEqualToString:GUIDE_SHOW_HOME_PAGE] && DEVICE_HEIGHT < 568)
        {
            [guideButton setFrame:CGRectMake(0, -44, 320, (480+88))];
        }
        [guideButton setImage:[UIImage imageNamed:[BBGuideDB getGuideImageName:guideKey]] forState:UIControlStateNormal];
        [guideButton addTarget:self action:@selector(clickGuideImageAction) forControlEvents:UIControlEventTouchUpInside];
        [[([UIApplication sharedApplication].delegate) window] addSubview:guideButton];
    }
}

- (void)clickGuideImageAction
{
    [BBGuideDB insertAndUpdateCoverLayerData:[BBGuideDB getCoverLayerClass:self.s_cover.m_CoverLayerKey withIsShow:NO]];
    for (UIView *subview in [[([UIApplication sharedApplication].delegate) window] subviews])
    {
        if ([subview isKindOfClass:[UIButton class]] && subview.tag==10011)
        {
            [subview removeFromSuperview];
        }
    }
}


-(void)getUserLocationInfomation
{
    if ([self IsLocationServicesEnabled])
    {
        
        if (!self.userLocation)
        {
            self.userLocation = [[CLLocationManager alloc]init];
        }
        
        self.userLocation.delegate = self;
        //选择定位的方式为最优的状态
        self.userLocation.desiredAccuracy = kCLLocationAccuracyBest;
        //发生事件的最小距离间隔
        self.userLocation.distanceFilter = kCLDistanceFilterNone;
        [self.userLocation startUpdatingLocation];
    }
}

-(BOOL)IsLocationServicesEnabled
{
    /**
     * [CLLocationManager locationServicesEnabled] 系统设置允许定位服务是否开启
     * [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied  APP是否开启定位服务
     */
    return ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied);
}

#pragma locationManager delegate

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 180.0) return;
    // 测试该水平精度是否有效
    if (newLocation.horizontalAccuracy < 0) return;
    [BBLocation setCurrentLocationByGps:newLocation];
    [self.userLocation stopUpdatingLocation];
    self.userLocation.delegate = nil;

}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    
}


#pragma scheme 跳本地页
- (BOOL)skipToScheme:(NSString *)scheme
{
    if ([scheme hasPrefix:@"wxfb15b7e70bb0897f://aid"]) {
        
        if ([[self getStringWithKey:@"aid" fromString:scheme] isEqualToString:@"1"])
        {
            // 之前跳美食厨房 暂处理待定
        }
        else if([[self getStringWithKey:@"aid" fromString:scheme] isEqualToString:@"2"])
        {
            NSDictionary *hospitalData = [BBHospitalRequest getHospitalCategory];
            if (hospitalData != nil)
            {
               HMCircleClass *hospitalObj = [[HMCircleClass alloc]init];
                hospitalObj.m_HospitalID = [hospitalData stringForKey:kHospitalHospitalIdKey];
                hospitalObj.circleId     = [hospitalData stringForKey:kHospitalGroupIdKey];
                hospitalObj.circleTitle  = [hospitalData stringForKey:kHospitalNameKey];
                HMCircleTopicVC *circleVC = [[HMCircleTopicVC alloc] init];
                circleVC.m_CircleClass = hospitalObj;
                
                [self showPushView:circleVC];
                
            }
            else
            {
                BBSelectHospitalArea *selectHospitalArea = [[BBSelectHospitalArea alloc] initWithNibName:@"BBSelectHospitalArea" bundle:nil];
                [self showPushView:selectHospitalArea];
            }
        }
        else if([[self getStringWithKey:@"aid" fromString:scheme] isEqualToString:@"0"])
        {
            NSString *topicID = [self getStringWithKey:@"tid" fromString:scheme];
            if (topicID.isNotEmpty)
            {
                UIViewController *vc = [self.m_mainTabbar getViewControllerAtIndex:self.m_mainTabbar.selectedIndex];
                [vc viewWillDisappear:NO];
                [vc.navigationController setNavigationBarHidden:NO];
                [BBStatistic visitType:BABYTREE_TYPE_TOPIC_SCHEME contentId:topicID];
                [HMShowPage showTopicDetail:vc topicId:topicID topicTitle:@""];
            }
        }
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSString *)getStringWithKey:(NSString *)keyStirng fromString:(NSString *)schemeUrl
{
    NSString *topicStr = nil;
    NSArray *array = [schemeUrl componentsSeparatedByString:@"//"];
    NSString  *containerStr = nil;
    if ([array count] >= 2) {
        containerStr = [array objectAtIndex:1];
    }
    
    NSArray *dicArray = [containerStr componentsSeparatedByString:@"&"];
    for(int i = 0; i < [dicArray count]; i++) {
        NSString *dicstr = [dicArray objectAtIndex:i];
        NSArray *array1 = [dicstr componentsSeparatedByString:@"="];
        if([array1 count] >=2) {
            if([[array1 objectAtIndex:0] isEqualToString:keyStirng]) {
                topicStr = [array1 objectAtIndex:1];
                break;
            }
        }
        
    }
    return topicStr;
}


@end
