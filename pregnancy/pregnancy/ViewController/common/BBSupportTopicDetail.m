//
//  BBTopicDetail.m
//  pregnancy
//
//  Created by Jun Wang on 12-4-5.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBSupportTopicDetail.h"
#import "BBDueDateViewController.h"
#import "HMShowPage.h"
#import "BBShareContent.h"
#import "HMCreateTopicViewController.h"
#import "HMTopicDetailVC.h"
//#define MOVEDPAGEURL @"http://172.16.103.87/testWebJs.html"


@interface BBSupportTopicDetail()
@property (nonatomic, strong) NSString *action;
@property (nonatomic, assign) BOOL      shouldPushScan;
@end
@implementation BBSupportTopicDetail

@synthesize topicDetailWebView;
@synthesize javascriptBridge;
@synthesize loadProgress;
@synthesize photos;
@synthesize isFirstLoading;
@synthesize loadURL;
@synthesize topicInfo;

@synthesize checkAppStore;
@synthesize isShowCloseButton;
@synthesize isReloadWebview;

#pragma mark - memory management

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [javascriptBridge release];
    [topicDetailWebView setDelegate:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [topicDetailWebView release];
    [loadProgress release];
    [photos release];
    [loadURL release];
    [topicInfo release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self.navigationItem setTitle:@"精彩活动"];
        self.topicInfo = [[[NSMutableArray alloc]init]autorelease];
        isFirstLoading = YES;
        isShowCloseButton = YES;
        isReloadWebview = NO;
        
    }
    return self;
}

-(void)appBecomeActive:(NSNotification *)notification
{
    //针对闪购的下面出现白条状况2-从后台返回前台，self.view.frame被设置回去进行的处理，由于这个时候不会调用didappear,所以重设一次
//    double delayInSeconds = 1;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self resetViewFrameForShoppingView];
//    });
     [self performSelector:@selector(resetViewFrameForShoppingView) withObject:nil afterDelay:1.0];
}
 //处理encode和decode细节
- (NSMutableString *)urlHandler:(NSString *)urlString{
    NSMutableString *url;
    if(urlString == nil){
        return [[[NSMutableString alloc]init]autorelease];
    }
    NSString *decodeUrl = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (decodeUrl == nil) {
        NSString *encodeUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (encodeUrlString == nil) {
            url = [[[NSMutableString alloc]initWithString:urlString]autorelease];
        }else{
            url = [[[NSMutableString alloc]initWithString:encodeUrlString]autorelease];
        }
    }else{
        NSString *encodeUrlString = [decodeUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (encodeUrlString == nil) {
            url = [[[NSMutableString alloc]initWithString:urlString]autorelease];
        }else{
            url = [[[NSMutableString alloc]initWithString:encodeUrlString]autorelease];
        }
    }
    return url;
}

- (NSString *)autoModifyUrl:(NSString *)urlString
{
    if (urlString == nil) {
        return nil;
    }
    
    NSMutableString *url = [self urlHandler:urlString];
//    NSMutableString *url = [[[NSMutableString alloc]initWithString:[[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]autorelease];
    if([url rangeOfString:@"%23"].length > 0){
        [url replaceCharactersInRange:[url rangeOfString:@"%23"] withString:@"#"];
    }
    if(!([url rangeOfString:@".babytree"].length > 0 || [url rangeOfString:@".haodou"].length > 0))
    {
        return url;
    }
    //防止重复增加公共字段
    if ([url rangeOfString:@"bpreg_brithday"].length >0 && [url rangeOfString:@"babytree-client-type"].length >0 &&
        [url rangeOfString:@"babytree-app-version"].length >0 && [url rangeOfString:@"babytree-app-id"].length >0) {
        return url;
    }
    NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
    NSURL *checkURL =[NSURL URLWithString:url];
    NSString *handlerUrl = nil;
    if (checkURL.query != nil) {
        NSLog(@"Query: %@", [checkURL query]);
        if ([url rangeOfString:@"#"].length > 0) {
            NSArray *array = [url componentsSeparatedByString:@"#"];
            if ([array count] == 2) {
                if([BBUser getNewUserRoleState] == BBUserRoleStatePrepare){
                    handlerUrl = [NSString stringWithFormat:@"%@&babytree-app-id=pregnancy&babytree-client-type=ios&babytree-app-version=%@&bpreg_brithday=%@&babytree-app-is-prepare=1#%@",
                                  [array objectAtIndex:0],[infoDict stringForKey:@"CFBundleVersion"],[BBPregnancyInfo pregancyDateYMDByStringForAPI],[array objectAtIndex:1]];
                }else{
                    handlerUrl = [NSString stringWithFormat:@"%@&babytree-app-id=pregnancy&babytree-client-type=ios&babytree-app-version=%@&bpreg_brithday=%@#%@",
                                  [array objectAtIndex:0],[infoDict stringForKey:@"CFBundleVersion"],[BBPregnancyInfo pregancyDateYMDByStringForAPI],[array objectAtIndex:1]];
                }
               
            }
        }else{
            if([BBUser getNewUserRoleState] == BBUserRoleStatePrepare){
                handlerUrl = [NSString stringWithFormat:@"%@&babytree-app-id=pregnancy&babytree-client-type=ios&babytree-app-version=%@&bpreg_brithday=%@&babytree-app-is-prepare=1",
                              url,[infoDict stringForKey:@"CFBundleVersion"],[BBPregnancyInfo pregancyDateYMDByStringForAPI]];
            }else{
                handlerUrl = [NSString stringWithFormat:@"%@&babytree-app-id=pregnancy&babytree-client-type=ios&babytree-app-version=%@&bpreg_brithday=%@",
                              url,[infoDict stringForKey:@"CFBundleVersion"],[BBPregnancyInfo pregancyDateYMDByStringForAPI]];
            }
        }
    }else{
        NSLog(@"Query: %@", [checkURL query]);
        if ([url rangeOfString:@"#"].length > 0) {
            NSArray *array = [url componentsSeparatedByString:@"#"];
            if ([array count] == 2) {
                if([BBUser getNewUserRoleState] == BBUserRoleStatePrepare){
                    handlerUrl = [NSString stringWithFormat:@"%@?babytree-app-id=pregnancy&babytree-client-type=ios&babytree-app-version=%@&bpreg_brithday=%@&babytree-app-is-prepare=1#%@",
                                  [array objectAtIndex:0],[infoDict stringForKey:@"CFBundleVersion"],[BBPregnancyInfo pregancyDateYMDByStringForAPI],[array objectAtIndex:1]];
                }else{
                    handlerUrl = [NSString stringWithFormat:@"%@?babytree-app-id=pregnancy&babytree-client-type=ios&babytree-app-version=%@&bpreg_brithday=%@#%@",
                                  [array objectAtIndex:0],[infoDict stringForKey:@"CFBundleVersion"],[BBPregnancyInfo pregancyDateYMDByStringForAPI],[array objectAtIndex:1]];
                }
            }
        }else{
            if([BBUser getNewUserRoleState] == BBUserRoleStatePrepare){
                handlerUrl = [NSString stringWithFormat:@"%@?babytree-app-id=pregnancy&babytree-client-type=ios&babytree-app-version=%@&bpreg_brithday=%@&babytree-app-is-prepare=1",
                              url,[infoDict stringForKey:@"CFBundleVersion"],[BBPregnancyInfo pregancyDateYMDByStringForAPI]];
            }else{
                handlerUrl = [NSString stringWithFormat:@"%@?babytree-app-id=pregnancy&babytree-client-type=ios&babytree-app-version=%@&bpreg_brithday=%@",
                              url,[infoDict stringForKey:@"CFBundleVersion"],[BBPregnancyInfo pregancyDateYMDByStringForAPI]];
            }
            
        }
        
    }
    return handlerUrl;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //重设cookie，防止用户在页面退出账户清楚了cookie
    [BBCookie pregnancyCookie:[BBUser localCookie]];
    
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title withWidth:100]];
 
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // 关闭按钮 需要根据返回状态设置是否显示
    if(self.isShowCloseButton)
    {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [closeButton setFrame:CGRectMake(0, 0, 40, 30)];
        closeButton.exclusiveTouch = YES;
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
//        [closeButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
//        [closeButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
        [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
        self.navigationItem.leftBarButtonItems = @[backBarButton,closeBarButton];
        [closeBarButton release];
        [backBarButton release];
    }else{
        [self.navigationItem setLeftBarButtonItem:backBarButton];
        [backBarButton release];
    }
    
    if([self.navigationController.viewControllers count]==1)
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    UIView *backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, -10, 320, IPHONE5_ADD_HEIGHT(416+10))] autorelease];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0]];
    [self.view addSubview:backgroundView];

    self.javascriptBridge = [WebViewJavascriptBridge javascriptBridgeWithDelegate:self];
    self.topicDetailWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)] autorelease];
    self.topicDetailWebView.scalesPageToFit = YES;
    self.topicDetailWebView.clipsToBounds = YES;

    if([loadURL isNotEmpty]){
        if([loadURL rangeOfString:@"http"].location==0){
//            self.loadURL = @"http://172.16.103.87/demo.html";
            self.loadURL = [self autoModifyUrl:self.loadURL];
            NSURL *requestURL =[NSURL URLWithString:self.loadURL];
            NSMutableURLRequest *loadURLRequest = [BBHTTPHeaderADDInfo addHTTPRequestHeaderInfo:requestURL];
            [topicDetailWebView loadRequest:loadURLRequest];
        }else{
            //加载本地html数据
            NSString *resourcePath = [ [NSBundle mainBundle] resourcePath];
            NSString *filePath = [resourcePath stringByAppendingPathComponent:loadURL];
            NSString *htmlstring=[[[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil]autorelease];
            [topicDetailWebView loadHTMLString:htmlstring  baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        }
    }
    [topicDetailWebView setBackgroundColor:[UIColor clearColor]];
    [topicDetailWebView setDelegate:javascriptBridge];
    
    [topicDetailWebView setDataDetectorTypes:UIDataDetectorTypeNone];
    [self.view addSubview:topicDetailWebView];

    self.loadProgress = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    loadProgress.animationType = MBProgressHUDAnimationFade;
    [self.view addSubview:loadProgress];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWebView:) name:RELOAD_WEBVIEW object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    //iphone5适配
    IPHONE5_ADAPTATION
    if (IS_IPHONE5) {
        [self.topicDetailWebView setFrame:CGRectMake(self.topicDetailWebView.frame.origin.x, self.topicDetailWebView.frame.origin.y, self.topicDetailWebView.frame.size.width, self.topicDetailWebView.frame.size.height + 88)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    IOS6_RELEASE_VIEW
}

- (void)viewDidUnload
{
    [self viewDidUnloadBabytree];

    [super viewDidUnload];
}

- (void)viewDidUnloadBabytree
{
    self.loadProgress = nil;
    self.topicDetailWebView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(isReloadWebview){
        [self.topicDetailWebView reload];
        isReloadWebview = NO;
    }
    if ([self.loadURL hasPrefix:[NSString stringWithFormat:@"%@/app/ask/",BABYTREE_URL_SERVER]] || [self.loadURL rangeOfString:@"/app/yunqi/gandong.php"].length > 0) {
        int addHeight = 0;
        if (IS_IPHONE5) {
            addHeight +=88;
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.topicDetailWebView setFrame:CGRectMake(self.topicDetailWebView.frame.origin.x,
                                                         self.topicDetailWebView.frame.origin.y, self.topicDetailWebView.frame.size.width, 480+addHeight)];
        }else{
            [self.topicDetailWebView setFrame:CGRectMake(self.topicDetailWebView.frame.origin.x,
                                                         self.topicDetailWebView.frame.origin.y, self.topicDetailWebView.frame.size.width, 460+addHeight)];
        }
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.topicDetailWebView.scrollView.bounces = NO;
    }
    //下面的判断是当本页面作为tabbarviewController第一级页面时候做了尺寸调整
    if([self.loadURL rangeOfString:@"/flashsale"].length > 0)
    {
        BBAppDelegate *appDelegate = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.m_mainTabbar.tabBar.hidden) {
            if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0){
                [self.topicDetailWebView setFrame:CGRectMake(self.topicDetailWebView.frame.origin.x,
                                                             self.topicDetailWebView.frame.origin.y, self.topicDetailWebView.frame.size.width, DEVICE_HEIGHT)];
            }else{
                [self.topicDetailWebView setFrame:CGRectMake(self.topicDetailWebView.frame.origin.x,
                                                             self.topicDetailWebView.frame.origin.y, self.topicDetailWebView.frame.size.width, DEVICE_HEIGHT-20)];
            }
        }else{
            if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0){
                [self.topicDetailWebView setFrame:CGRectMake(self.topicDetailWebView.frame.origin.x,
                                                             self.topicDetailWebView.frame.origin.y, self.topicDetailWebView.frame.size.width, DEVICE_HEIGHT-UI_TAB_BAR_HEIGHT)];
            }else{
                [self.topicDetailWebView setFrame:CGRectMake(self.topicDetailWebView.frame.origin.x,
                                                             self.topicDetailWebView.frame.origin.y, self.topicDetailWebView.frame.size.width, DEVICE_HEIGHT-UI_TAB_BAR_HEIGHT - 20)];
            }
        }
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.topicDetailWebView.scrollView.bounces = NO;
        [self.topicDetailWebView stringByEvaluatingJavaScriptFromString:@"activate();"];
    }
    else if(!self.tabBarController.tabBar.hidden && (self.navigationController.viewControllers.count == 1))
    {
        [self.topicDetailWebView setFrame:CGRectMake(self.topicDetailWebView.frame.origin.x,
                                                     self.topicDetailWebView.frame.origin.y, self.topicDetailWebView.frame.size.width, DEVICE_HEIGHT-64-UI_TAB_BAR_HEIGHT)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.shouldPushScan = YES;
    //针对闪购的下面出现白条状况1-压新页面，有返回页面之后，self.view.frame被设置回去进行的处理，在didappear的时候重新设置一次，这个设置在willappear里面试验无效
    [self resetViewFrameForShoppingView];
}

-(void)resetViewFrameForShoppingView
{
    if(self.navigationController.viewControllers.lastObject != self)
        return;
    if([self.loadURL rangeOfString:@"/flashsale"].length > 0)
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        BBAppDelegate *appDelegate = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.m_mainTabbar.tabBar.hidden)
        {
            CGRect frame = self.view.frame;
            frame.size.height = DEVICE_HEIGHT;
            self.view.frame = frame;
        }
        else
        {
            CGRect frame = self.view.frame;
            frame.size.height = UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT;
            self.view.frame = frame;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.loadURL hasPrefix:[NSString stringWithFormat:@"%@/app/ask/",BABYTREE_URL_SERVER]] || [self.loadURL rangeOfString:@"/app/yunqi/gandong.php"].length > 0 || [self.loadURL rangeOfString:@"/flashsale"].length > 0) {
        [self.navigationController setNavigationBarHidden:NO];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//lijie 修改不支持旋转 6.0
- (BOOL)shouldAutorotate
{
    return NO;
}
//lijie 修改不支持旋转 6.0
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)reloadWebView:(NSNotification*)notify {
    isReloadWebview = YES;
}
#pragma mark - WebViewJavascriptBridgeDelegate
-(void)adAction:(NSString *)title withUrl:(NSString *)url{
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    [exteriorURL.navigationItem setTitle:title];
    [exteriorURL setLoadURL:url];
    exteriorURL.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:exteriorURL animated:YES];
    [exteriorURL release];
}

-(void)shareAction
{
    [self shareTopicClicked];
}
-(void)showShareButton:(NSString *)status
{
    if ([status isEqualToString:@"yes"]) {
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.exclusiveTouch = YES;
        [shareButton setFrame:CGRectMake(0, 0, 40, 30)];
        [shareButton setImage:[UIImage imageNamed:@"shareBarButton"] forState:UIControlStateNormal];
        [shareButton setImage:[UIImage imageNamed:@"shareBarButtonPressed"] forState:UIControlStateHighlighted];
        [shareButton addTarget:self action:@selector(shareTopicClicked) forControlEvents:UIControlEventTouchUpInside];
    
        UIBarButtonItem *shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
        self.navigationItem.rightBarButtonItem = shareBarButton;
        [shareBarButton release];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}
-(void)showTabbar:(NSString *)status
{
    if ([status isEqualToString:@"yes"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MAINTABBAR_ISHIDE_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"show", nil]];
        CGRect frame = self.view.frame;
        frame.size.height = UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT;
        self.view.frame = frame;

        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0){
            [self.topicDetailWebView setFrame:CGRectMake(self.topicDetailWebView.frame.origin.x,
                                                         self.topicDetailWebView.frame.origin.y, self.topicDetailWebView.frame.size.width, DEVICE_HEIGHT-UI_TAB_BAR_HEIGHT)];
        }else{
            [self.topicDetailWebView setFrame:CGRectMake(self.topicDetailWebView.frame.origin.x,
                                                         self.topicDetailWebView.frame.origin.y, self.topicDetailWebView.frame.size.width, DEVICE_HEIGHT-UI_TAB_BAR_HEIGHT - 20)];
        }

    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MAINTABBAR_ISHIDE_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"show", nil]];
        CGRect frame = self.view.frame;
        frame.size.height = DEVICE_HEIGHT;
        self.view.frame = frame;
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0){
            [self.topicDetailWebView setFrame:CGRectMake(self.topicDetailWebView.frame.origin.x,
                                                         self.topicDetailWebView.frame.origin.y, self.topicDetailWebView.frame.size.width, DEVICE_HEIGHT)];
        }else{
            [self.topicDetailWebView setFrame:CGRectMake(self.topicDetailWebView.frame.origin.x,
                                                         self.topicDetailWebView.frame.origin.y, self.topicDetailWebView.frame.size.width, DEVICE_HEIGHT-20)];
        }
    }
}
- (void)shareContentText:(NSString *)string
{
    self.title = string;
    self.navigationItem.title = self.title;

    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title withWidth:100]];

}
- (void)discuzPhotoPreview:(NSString *)photoUrl
{

}
-(void)innerJump:(NSString *)url{
    NSURL *requestURL =[NSURL URLWithString:[self autoModifyUrl:url]];
    NSMutableURLRequest *loadURLRequest = [BBHTTPHeaderADDInfo addHTTPRequestHeaderInfo:requestURL];
    [self.topicDetailWebView loadRequest:loadURLRequest];
}
-(void)discuzUserEncodeId:(NSString *)userEncodeId{
    
    BBPersonalViewController *userInformation = [[[BBPersonalViewController alloc]initWithNibName:@"BBPersonalViewController" bundle:nil]autorelease];
    userInformation.userEncodeId = userEncodeId;
    userInformation.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userInformation animated:YES];
}

- (void)discuzAllBirthclubByWeek:(NSString *)week
{
    /* 暂时留着
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(280 - [week integerValue] * 7)*86400];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    [dateFormatter setDateFormat:@"yyyyMM"];
    NSString * yymm = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"yyyy'年'M'月同龄圈'"];
    
    BBPostListPage * listVC = [[[BBPostListPage alloc]init]autorelease];
    listVC.listType = MyAgeGroupList;
    listVC.postType = postPageTypePregnancyMonth;
    listVC.pregnancyYearAndMoth = yymm;
    listVC.ageTitle = [dateFormatter stringFromDate:date];
    listVC.extendPregMonths = [NSString stringWithFormat:@"%d",[BBPregnancyInfo pregnanyMonthsFromWeek:[week intValue]]];
    
    [self.navigationController pushViewController:listVC animated:YES];
     */
}

- (void)discuzNewBirthclubByWeek:(NSString *)week{
    /* 暂时注释
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(280 - [week intValue]*7)*86400];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    [dateFormatter setDateFormat:@"yyyyMM"];
    NSString * yymm = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"yyyy'年'M'月同龄圈'"];
    
    BBPostListPage * listVC = [[[BBPostListPage alloc]init]autorelease];
    listVC.listType = MyAgeGroupList;
    listVC.postType = postPageTypeAge;
    listVC.pregnancyYearAndMoth = yymm;
    listVC.ageTitle = [dateFormatter stringFromDate:date];
    
    [self.navigationController pushViewController:listVC animated:YES];
    */
    
}

- (void)topicInnerUrl:(NSString *)url
{
    if ([url hasPrefix:@"http://www.babytree.com/community/topic_mobile.php"]) {
        BOOL fromExpertOnline = NO;
        if([self.loadURL rangeOfString:@"expert_online.php"].location != NSNotFound)
        {
            //专家在线 看帖子
            fromExpertOnline = YES;
            [MobClick event:@"expert_online_v2" label:@"查看帖子"];
        }
        NSArray *pramsArray = [url componentsSeparatedByString:@"?"];
        NSArray *dataArray = nil;
        NSArray *tempArray = nil;
        if([pramsArray count]>1){
            dataArray= [[pramsArray objectAtIndex:1] componentsSeparatedByString:@"&"];
        }
        NSString *topicID = @"1";
        if([dataArray count]>0){
            tempArray = [[dataArray objectAtIndex:0] componentsSeparatedByString:@"="];
        }
        if([tempArray count]>1){
            topicID  = [tempArray objectAtIndex:1];
        }
        if (![topicID isNotEmpty])
        {
            return;
        }
        HMTopicDetailVC *topicDetail = [[HMTopicDetailVC alloc]initWithNibName:@"HMTopicDetailVC" bundle:nil withTopicID:topicID topicTitle:nil isTop:NO isBest:NO];
        if (fromExpertOnline)
        {
            //从专家在线进入的帖子
            [BBStatistic visitType:BABYTREE_TYPE_TOPIC_EXPERT contentId:topicID];
            topicDetail.m_IsFromExpertOnline = YES;
        }
        topicDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:topicDetail animated:YES];
        [topicDetail release];
    } else {
        BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
        [exteriorURL.navigationItem setTitle:@"详情页"];
        [exteriorURL setLoadURL:url];
        exteriorURL.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:exteriorURL animated:YES];
        [exteriorURL release];
    }
}

-(void)customCreateTopic:(NSString *)navTitle withGroupId:(NSString *)groupId withGroupName:(NSString *)groupName withTopicTitle:(NSString *)topicTitle withTip:(NSString *)tip{
    if([BBUser isLogin]){
        HMCreateTopicViewController *editNewVC = [[[HMCreateTopicViewController alloc]initWithNibName:@"HMCreateTopicViewController" bundle:nil]autorelease];
        HMCircleClass *item = [[[HMCircleClass alloc] init]autorelease];
        item.circleId = groupId;
        item.circleTitle = groupName;
        editNewVC.m_CircleInfo = item;
        editNewVC.title = navTitle;
        editNewVC.tip = tip;
        editNewVC.topicTitle = topicTitle;
        editNewVC.m_IsCustomCreateTopic = YES;
        editNewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editNewVC animated:YES];
    }else{
        [self.topicInfo removeAllObjects];
        [self.topicInfo addObject:navTitle];
        [self.topicInfo addObject:groupId];
        [self.topicInfo addObject:groupName];
        [self.topicInfo addObject:topicTitle];
        [self.topicInfo addObject:tip];
        self.action = nil;
        BBLogin *loginController = [[[BBLogin alloc] initWithNibName:@"BBLogin" bundle:nil] autorelease];
        loginController.delegate = self;
        loginController.m_LoginType = BBPresentLogin;
        BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:loginController];
        [navCtrl setColorWithImageName:@"navigationBg"];
        [self.navigationController presentViewController:navCtrl animated:YES completion:^{}];
        
    }
}

-(void)webviewClose{
    if([self.loadURL rangeOfString:@"/app/yunqi/gandong.php"].length > 0)
    {
        [MobClick event:@"feeling_v2" label:@"返回首页"];
        [BBUser setMovedPagePhotoID:@""];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)refreshCallBack{
    [self.topicDetailWebView reload];
}
- (void)bindWatch{
    [MobClick event:@"watch_v2" label:@"绑定手表"];
    ZXScanWatchQR *scanWatchQR = [[[ZXScanWatchQR alloc] initWithNibName:nil bundle:nil] autorelease];
    scanWatchQR.title = @"扫描二维码绑定账号";
    scanWatchQR.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scanWatchQR animated:YES];

}

- (void)enterGroup:(NSString *)groupId withGroupName:(NSString *)groupName{
    [HMShowPage showCircleTopic:self circleId:groupId];
}

-(void)nativeLogin:(NSString *)action{
    if ([BBUser isLogin]) {
        if ([action isEqualToString:@"ask_reload_webview"]) {
            [self.topicDetailWebView reload];
        }else{
            [BBOpenCtrlViewByString doAction:action withNavCtrl:self.navigationController];
        }
    }else{
        [self.topicInfo removeAllObjects];
        self.action = action;
        
        BBLogin *loginController = [[[BBLogin alloc] initWithNibName:@"BBLogin" bundle:nil] autorelease];
        loginController.delegate = self;
        loginController.m_LoginType = BBPresentLogin;
        BBCustomNavigationController *navCtrl = [[[BBCustomNavigationController alloc]initWithRootViewController:loginController]autorelease];
        [navCtrl setColorWithImageName:@"navigationBg"];
        [self.navigationController presentViewController:navCtrl animated:YES completion:nil];
        
    }
}
- (void)mikaMusic
{
    BBMusicTypeListController *musicList = [[[BBMusicTypeListController alloc] init] autorelease];
    musicList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:musicList animated:YES];
}

-(void)scanQR{
    if (self.shouldPushScan) {//该标记为必变push两次页面
        self.shouldPushScan = NO;
        
        ZXSanQR *scan = [[[ZXSanQR alloc] init] autorelease];
        scan.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scan animated:YES];
    }
}
#pragma mark - BBLogin Delegate
- (void)loginFinish{

    if ([self.topicInfo count]==5) {
        HMCreateTopicViewController *editNewVC = [[[HMCreateTopicViewController alloc]initWithNibName:@"HMCreateTopicViewController" bundle:nil]autorelease];
        HMCircleClass *item = [[[HMCircleClass alloc] init]autorelease];
        item.circleId = [self.topicInfo objectAtIndex:1];
        item.circleTitle = [self.topicInfo objectAtIndex:2];
        editNewVC.m_CircleInfo = item;
        editNewVC.title = [self.topicInfo objectAtIndex:0];
        editNewVC.tip = [self.topicInfo objectAtIndex:4];
        editNewVC.topicTitle = [self.topicInfo objectAtIndex:3];
        editNewVC.m_IsCustomCreateTopic = YES;
        editNewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editNewVC animated:YES];
    }else if(self.action){
        if ([self.action isEqualToString:@"ask_reload_webview"]) {
            //防止多次刷新
            isReloadWebview = NO;
            [self.topicDetailWebView reload];
        }else{
            [BBOpenCtrlViewByString doAction:self.action withNavCtrl:self.navigationController];
        }
        self.action = nil;
    }
}
#pragma mark - IBAction Event

- (void)shareTopicClicked
{
    [MobClick event:@"feeling_v2" label:@"晒一下"];
    BBShareMenu *shareMenu;
    // 分享感动页 添加保存到相册
    if([self.loadURL rangeOfString:@"/app/yunqi/gandong.php"].length > 0)
    {
        shareMenu = [[[BBShareMenu alloc] initWithType:3 title:@"分享"] autorelease];
    }
    else
    {
        shareMenu = [[[BBShareMenu alloc] initWithType:2 title:@"分享"] autorelease];
    }
    shareMenu.delegate = self;
    [shareMenu show];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeAction:(id)sender
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (int index = [viewControllers count]-1; index >= 0; index--) {
        UIViewController *viewCtrl = [viewControllers objectAtIndex:index];
        
        if([viewCtrl isKindOfClass:[BBSupportTopicDetail class]] && index != 0){
            continue;
        }else{
            [self.navigationController popToViewController:viewCtrl animated:YES];
            break;
        }
    }
}


#pragma mark - UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{  
    if (isFirstLoading == YES) {
        loadProgress.hidden = NO;
        [loadProgress setMode:MBProgressHUDModeIndeterminate];
        [loadProgress setLabelText:@"加载中..."];
        [loadProgress show:YES];
        isFirstLoading = NO;
    }
    
    checkAppStore = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (loadProgress.hidden == NO) {
        [loadProgress hide:YES];
    }
    isFirstLoading = YES;
    // 感动页加载完成后，关闭感动页显示
    if([self.loadURL rangeOfString:@"/app/yunqi/gandong.php"].length > 0)
    {
        [BBUser setNeedShowMovedPage:0];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // 感动页加载失败后，关闭感动页显示
    if([self.loadURL rangeOfString:@"/app/yunqi/gandong.php"].length > 0)
    {
        [BBUser setNeedShowMovedPage:0];
    }
    isFirstLoading = YES;
    NSInteger errorCode = error.code;
    
    if(loadProgress.hidden == NO)
    {
        [loadProgress hide:YES];
    }
    
    if (errorCode != NSURLErrorCancelled)
    {
        NSString *urlString = [error.userInfo stringForKey:@"NSErrorFailingURLStringKey"];
        NSURL *url = [NSURL URLWithString:urlString];
        if (checkAppStore)
        {
            
            
            if ([[url scheme] isEqualToString:@"itms-appss"])
            {
                urlString = [urlString stringByReplacingOccurrencesOfString:@"itms-appss://" withString:@"itms-apps://"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }
        }
        if (errorCode != kCFURLErrorServerCertificateUntrusted && errorCode != 101 && errorCode != 102 && [[url absoluteString] rangeOfString:@"/flashsale"].length > 0)
        {
            NSString *content = @"<head><title>网络出错了</title><meta charset='utf-8' /><head><title>网络出错了</title><meta charset='utf-8' />"
            "<style>a,body,h1,nav{margin:0;padding:0;border:0}"
            "html{color:#000;background-color:transparent;height:100%%;_background-image:url(/img/bui/2.0.0/src/reset/css/about:blank);_background-attachment:fixed}"
            "body{background-color:transparent;font:12px/1.5 Arial,Microsoft Yahei,sans-serif;color:#666;-webkit-font-smoothing:antialiased;height:100%%}"
            "a{color:#06C;text-decoration:none}a:hover{text-decoration:underline}"
            "h1{*font-family:Microsoft Yahei}"
            "button,input{font-family:inherit;font-size:inherit;font-weight:inherit;line-height:120%%;vertical-align:middle;*font-size:12px;*font-family:Arial,Microsoft Yahei,sans-serif}button,input[type=button],input[type=reset],input[type=submit]{*overflow:visible;cursor:pointer;padding:0}button::-moz-focus-inner{border:0;padding:0}"
            "body {background-color: #f4f4f4;}"
            ".header {padding: 10px 30px;position: relative;background-color: #ff5379;}"
            ".header.ios7 {padding-top: 30px}"
            ".header h1 {margin: 0;font-size: 20px;text-align: center;color: #fff;}"
            ".header .shop a {display: block;width: 80px;height: 34px;position: absolute;bottom: 10px;left: 10px;color: #fff;text-decoration: none;font-size: 50px;line-height: 25px;}"
            ".container {padding: 100px 0;font-size: 18px;text-align: center;color: #9d9d9d;}"
            ".container button {border: none;background: none;margin-top: 30px;background: #fff;font-size: 14px;padding: 10px 25px;border-radius: 5px;color: #9d9d9d;}"
            "</style>"
            "</head>"
            "<body><header class='header'> <h1>特卖频道</h1><nav class='shop'></nav></header>"
            "<div class='container'><p>网络出错了！</p><button id='btnReload'>再试一次</button></div>"
            "</body>";
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"document.body.innerHTML=\"%@\";"
                                                             "	(function (global) {"
                                                             "		var	btnReload = document.getElementById('btnReload');"
                                                             "      function handleReload(e) {"
                                                             "          var url = 'inner_jump_url&' + \"%@\";"
                                                             "          global.location.href='webviewjavascriptbridge://' + encodeURI(url);"
                                                             "          btnReload.removeEventListener('click', handleReload);"
                                                             "		}"
                                                             "		btnReload.addEventListener('click', handleReload);"
                                                             "      if (/iPhone OS 7/.test(navigator.userAgent)) {"
                                                             "          var header = document.querySelector('.header');"
                                                             "          header.className = header.className + ' ios7';"
                                                             "      }"
                                                             "	}(this));",content,[url absoluteString]]];
        }
        else if (errorCode != kCFURLErrorServerCertificateUntrusted && errorCode != 101 && errorCode != 102 && [[url absoluteString] rangeOfString:@"/app/ask/"].length > 0)
        {
            NSString *content = @"<head><title>网络出错了</title><meta charset='utf-8' /><head><title>网络出错了</title><meta charset='utf-8' />"
            "<style>a,body,h1,nav{margin:0;padding:0;border:0}"
            "html{color:#000;background-color:transparent;height:100%%;_background-image:url(/img/bui/2.0.0/src/reset/css/about:blank);_background-attachment:fixed}"
            "body{background-color:transparent;font:12px/1.5 Arial,Microsoft Yahei,sans-serif;color:#666;-webkit-font-smoothing:antialiased;height:100%%}"
            "a{color:#06C;text-decoration:none}a:hover{text-decoration:underline}"
            "h1{*font-family:Microsoft Yahei}"
            "button,input{font-family:inherit;font-size:inherit;font-weight:inherit;line-height:120%%;vertical-align:middle;*font-size:12px;*font-family:Arial,Microsoft Yahei,sans-serif}button,input[type=button],input[type=reset],input[type=submit]{*overflow:visible;cursor:pointer;padding:0}button::-moz-focus-inner{border:0;padding:0}"
            "body {background-color: #f4f4f4;}"
            ".header {padding: 10px 30px;position: relative;background-color: #ff5379;}"
            ".header.ios7 {padding-top: 30px}"
            ".header h1 {margin: 0;font-size: 20px;text-align: center;color: #fff;}"
            ".header .shop a {display: block;width: 80px;height: 34px;position: absolute;bottom: 10px;left: 10px;color: #fff;text-decoration: none;font-size: 50px;line-height: 25px;}"
            ".container {padding: 100px 0;font-size: 18px;text-align: center;color: #9d9d9d;}"
            ".container button {border: none;background: none;margin-top: 30px;background: #fff;font-size: 14px;padding: 10px 25px;border-radius: 5px;color: #9d9d9d;}"
            "</style>"
            "</head>"
            "<body><header class='header'> <h1>育儿问答</h1><nav class='shop'><a href='#'  id='btnReturn'>&#139;</a></nav></header>"
            "<div class='container'><p>网络出错了！</p><button id='btnReload'>再试一次</button></div>"
            "</body>";
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"document.body.innerHTML=\"%@\";"
                                                             "	(function (global) {"
                                                             "		var btnReturn = document.getElementById('btnReturn'),"
                                                             "			btnReload = document.getElementById('btnReload');"
                                                             "      function handleReturn(e) {"
                                                             "          var url = 'webview_close&';"
                                                             "          global.location.href = 'webviewjavascriptbridge://' + encodeURI(url);"
                                                             "          btnReturn.removeEventListener('click', handleReturn);"
                                                             "		}"
                                                             "		btnReturn.addEventListener('click', handleReturn);"
                                                             "      function handleReload(e) {"
                                                             "          var url = 'inner_jump_url&' + \"%@\";"
                                                             "          global.location.href='webviewjavascriptbridge://' + encodeURI(url);"
                                                             "          btnReload.removeEventListener('click', handleReload);"
                                                             "		}"
                                                             "		btnReload.addEventListener('click', handleReload);"
                                                             "      if (/iPhone OS 7/.test(navigator.userAgent)) {"
                                                             "          var header = document.querySelector('.header');"
                                                             "          header.className = header.className + ' ios7';"
                                                             "      }"
                                                             "	}(this));",content,[url absoluteString]]];
        }
        else if (errorCode != kCFURLErrorServerCertificateUntrusted && errorCode != 101 && errorCode != 102)
        {
            //            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[error.userInfo stringForKey:@"NSLocalizedDescription"]  message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            //            [alertView show];
            NSString *content = @"<head><title>网络出错了</title><meta charset='utf-8' /><head><title>网络出错了</title><meta charset='utf-8' />"
            "<style>a,body,h1,nav{margin:0;padding:0;border:0}"
            "html{color:#000;background-color:transparent;height:100%%;_background-image:url(/img/bui/2.0.0/src/reset/css/about:blank);_background-attachment:fixed}"
            "body{background-color:transparent;font:12px/1.5 Arial,Microsoft Yahei,sans-serif;color:#666;-webkit-font-smoothing:antialiased;height:100%%}"
            "a{color:#06C;text-decoration:none}a:hover{text-decoration:underline}"
            "h1{*font-family:Microsoft Yahei}"
            "button,input{font-family:inherit;font-size:inherit;font-weight:inherit;line-height:120%%;vertical-align:middle;*font-size:12px;*font-family:Arial,Microsoft Yahei,sans-serif}button,input[type=button],input[type=reset],input[type=submit]{*overflow:visible;cursor:pointer;padding:0}button::-moz-focus-inner{border:0;padding:0}"
            "body {background-color: #f4f4f4;}"
            ".container {padding: 100px 0;font-size: 18px;text-align: center;color: #9d9d9d;}"
            ".container button {border: none;background: none;margin-top: 30px;background: #fff;font-size: 14px;padding: 10px 25px;border-radius: 5px;color: #9d9d9d;}"
            "</style>"
            "</head>"
            "<body>"
            "<div class='container'><p>网络出错了！</p><button id='btnReload'>再试一次</button></div>"
            "</body>";
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"document.body.innerHTML=\"%@\";"
                                                             "	(function (global) {"
                                                             "			btnReload = document.getElementById('btnReload');"
                                                             "      function handleReload(e) {"
                                                             "          var url = 'inner_jump_url&' + \"%@\";"
                                                             "          global.location.href='webviewjavascriptbridge://' + encodeURI(url);"
                                                             "          btnReload.removeEventListener('click', handleReload);"
                                                             "		}"
                                                             "		btnReload.addEventListener('click', handleReload);"
                                                             "      if (/iPhone OS 7/.test(navigator.userAgent)) {"
                                                             "          var header = document.querySelector('.header');"
                                                             "          header.className = header.className + ' ios7';"
                                                             "      }"
                                                             "	}(this));",content,[url absoluteString]]];
        }
    }
    
    checkAppStore = NO;

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [[request URL]absoluteString];
    if ([url hasPrefix:@"http://www.babytree.com/community/topic_mobile.php"]) {
        [self performSelector:@selector(pushTopicDetail:) withObject:url afterDelay:0.4];
        return NO;
    }
    return YES;
}

-(void)pushTopicDetail:(NSString *)url{
    //webview 跳帖子
    NSArray *pramsArray = [url componentsSeparatedByString:@"?"];
    NSArray *dataArray = nil;
    NSArray *tempArray = nil;
    if([pramsArray count]>1){
        dataArray= [[pramsArray objectAtIndex:1] componentsSeparatedByString:@"&"];
    }
    NSString *topicID = @"1";
    if([dataArray count]>0){
        tempArray = [[dataArray objectAtIndex:0] componentsSeparatedByString:@"="];
    }
    if([tempArray count]>1){
        topicID  = [tempArray objectAtIndex:1];
    }
    [HMShowPage showTopicDetail:self topicId:topicID topicTitle:nil];
}

#pragma mark - Refresh Call Back Delegate

- (IBAction)changeProgressText:(id)sender
{
    [loadProgress setMode:MBProgressHUDModeIndeterminate];
    [loadProgress setLabelText:@"正在刷新"];
}

- (void)closeLoadProgress
{
    if (loadProgress != nil) {
        if (loadProgress.hidden == NO) {
            loadProgress.hidden = YES;
        }
    }
}


- (void)modifyDuedate{
    BBDueDateViewController *dueDate = [[[BBDueDateViewController alloc] initWithNibName:@"BBDueDateViewController" bundle:nil] autorelease];
    dueDate.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dueDate animated:YES];
    
}

#pragma mark - share Delegate

- (void)shareMenu:(BBShareMenu *)shareMenu clickItem:(BBShareMenuItem *)item
{
    NSString* title = [self.topicDetailWebView stringByEvaluatingJavaScriptFromString:@"share.share_title"];
    NSString* content = [self.topicDetailWebView stringByEvaluatingJavaScriptFromString:@"share.share_content"];
    NSString* imageBase64 =[self.topicDetailWebView stringByEvaluatingJavaScriptFromString:@"share.image_base64"];
    NSData *imageData = [GTMBase64 decodeString:imageBase64];
    UIImage *image = [UIImage imageWithData:imageData];
    NSString* url = [self.topicDetailWebView stringByEvaluatingJavaScriptFromString:@"share.share_url"];
    
    if([self.loadURL rangeOfString:@"/app/yunqi/gandong.php"].length > 0)
    {
        if(item.indexAtMenu <=5)
        {
             NSString *shareUrl = [NSString stringWithFormat:@"%@/app/yunqi/gandong.php?share=1&enc_user_id=%@&photo_id=%@",BABYTREE_URL_SERVER,[BBUser getEncId],[BBUser getMovedPagePhotoID]];
            // 已确认分享文案
            [BBShareContent shareContent:item withViewController:self withShareText:@"报喜啦！我家的小宝贝降生了，快来撒花祝福~么么哒~~" withShareOriginImage:[self getShareImage] withShareWXTimelineTitle:@"报喜啦！我家的小宝贝降生了，快来撒花祝福~么么哒~~" withShareWXTimelineDescription:@"" withShareWXSessionTitle:@"宝宝树孕育" withShareWXSessionDescription:@"报喜啦！我家的小宝贝降生了，快来撒花祝福~么么哒~~" withShareWebPageUrl:shareUrl];
        }
        else if(item.indexAtMenu == 6)
        {
            [MobClick event:@"feeling_v2" label:@"保存到相册"];
            //保存进相册
            UIImageWriteToSavedPhotosAlbum([self getShareImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    else
    {
        [BBShareContent shareContent:item withViewController:self withShareText:[NSString stringWithFormat:@"%@ %@",title,content] withShareOriginImage:image withShareWXTimelineTitle:title withShareWXTimelineDescription:@"" withShareWXSessionTitle:title withShareWXSessionDescription:content withShareWebPageUrl:url];
    }
}

- (UIImage *)getShareImage
{
    CGFloat originViewheight = self.topicDetailWebView.frame.size.height;
    
    // 获取webview的原始高度
    UIScrollView *scrollView = (UIScrollView *)[[self.topicDetailWebView subviews] objectAtIndex:0];
    CGFloat webViewHeight = [scrollView contentSize].height;
    [self.topicDetailWebView setFrame:CGRectMake(self.topicDetailWebView.frame.origin.x, self.topicDetailWebView.frame.origin.y, self.topicDetailWebView.frame.size.width, webViewHeight)];
    
    CGFloat height = self.topicDetailWebView.frame.size.height;
    
    //支持retina高分的关键,在这需要减掉两个button的高度
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        NSInteger buttonHeight = 200;
        if(DEVICE_HEIGHT == 480)
        {
            buttonHeight = 160;
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.topicDetailWebView.bounds.size.width, height - buttonHeight), NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(CGSizeMake(self.topicDetailWebView.bounds.size.width, height));
    }
    //获取图像
    [self.topicDetailWebView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.topicDetailWebView setFrame:CGRectMake(self.topicDetailWebView.frame.origin.x, self.topicDetailWebView.frame.origin.y, self.topicDetailWebView.frame.size.width,originViewheight)];
    return image;
}


-(void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    MBProgressHUD *progressHud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:progressHud];
    [progressHud show:YES];
    
    if (error != NULL)
    {
        [progressHud show:NO withText:@"保存失败" delay:1.0];
    }
    else
    {
        [progressHud show:NO withText:@"保存成功" delay:1.0];
    }
}


@end