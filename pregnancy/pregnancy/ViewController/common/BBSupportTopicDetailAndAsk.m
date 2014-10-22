//
//  BBTopicDetail.m
//  pregnancy
//
//  Created by Jun Wang on 12-4-5.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBSupportTopicDetailAndAsk.h"
#import "BBDueDateViewController.h"
#import "HMShowPage.h"
#import "BBShareContent.h"
#import "BBSupportTopicDetail.h"

@interface BBSupportTopicDetailAndAsk()
@property (nonatomic, strong) NSString *action;
@property (nonatomic, assign) BOOL      shouldPushScan;
@end
@implementation BBSupportTopicDetailAndAsk

@synthesize topicDetailWebView;
@synthesize javascriptBridge;
@synthesize loadProgress;
@synthesize photos;
@synthesize isFirstLoading;
@synthesize loadURL;
@synthesize topicInfo;

@synthesize checkAppStore;

#pragma mark - memory management

- (void)dealloc
{
    [topicDetailWebView release];
    [javascriptBridge release];
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
    }
    return self;
}
- (NSString *)autoModifyUrl:(NSString *)urlString
{
    NSMutableString *url = [[[NSMutableString alloc]initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]autorelease];
    if([url rangeOfString:@"%23"].length > 0){
        [url replaceCharactersInRange:[url rangeOfString:@"%23"] withString:@"#"];
    }
    NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
    NSURL *checkURL =[NSURL URLWithString:url];
    NSString *handlerUrl = nil;
    if (checkURL.query != nil) {
        NSLog(@"Query: %@", [checkURL query]);
        if ([url rangeOfString:@"#"].length > 0) {
            NSArray *array = [url componentsSeparatedByString:@"#"];
            if ([array count] == 2) {
                handlerUrl = [NSString stringWithFormat:@"%@&babytree-app-id=pregnancy&babytree-client-type=ios&babytree-app-version=%@&bpreg_brithday=%@#%@",
                              [array objectAtIndex:0],[infoDict stringForKey:@"CFBundleVersion"],[BBPregnancyInfo pregancyDateYMDByString],[array objectAtIndex:1]];
            }
        }else{
            handlerUrl = [NSString stringWithFormat:@"%@&babytree-app-id=pregnancy&babytree-client-type=ios&babytree-app-version=%@&bpreg_brithday=%@",
                          url,[infoDict stringForKey:@"CFBundleVersion"],[BBPregnancyInfo pregancyDateYMDByString]];
            
        }
    }else{
        NSLog(@"Query: %@", [checkURL query]);
        if ([url rangeOfString:@"#"].length > 0) {
            NSArray *array = [url componentsSeparatedByString:@"#"];
            if ([array count] == 2) {
                handlerUrl = [NSString stringWithFormat:@"%@?babytree-app-id=pregnancy&babytree-client-type=ios&babytree-app-version=%@&bpreg_brithday=%@#%@",
                              [array objectAtIndex:0],[infoDict stringForKey:@"CFBundleVersion"],[BBPregnancyInfo pregancyDateYMDByString],[array objectAtIndex:1]];
            }
        }else{
            handlerUrl = [NSString stringWithFormat:@"%@?babytree-app-id=pregnancy&babytree-client-type=ios&babytree-app-version=%@&bpreg_brithday=%@",
                          url,[infoDict stringForKey:@"CFBundleVersion"],[BBPregnancyInfo pregancyDateYMDByString]];
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
    
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
 
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    UIView *backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, -10, 320, IPHONE5_ADD_HEIGHT(416+10))] autorelease];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0]];
    [self.view addSubview:backgroundView];

    self.javascriptBridge = [WebViewJavascriptBridge javascriptBridgeWithDelegate:self];
    self.topicDetailWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)] autorelease];
    self.topicDetailWebView.scalesPageToFit = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.topicDetailWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    }else{
        self.topicDetailWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)] autorelease];
    }
    
    if(loadURL !=nil){
        if([loadURL rangeOfString:@"http"].location==0){
//            self.loadURL = @"http://172.16.103.87/testWebJs.html";
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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"精彩活动"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.shouldPushScan = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"精彩活动"];
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

#pragma mark - WebViewJavascriptBridgeDelegate

-(void)shareAction
{
    [self shareTopicClicked];
}

- (void)shareContentText:(NSString *)string
{
    self.title = string;
    self.navigationItem.title = self.title;

    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];

}
- (void)discuzPhotoPreview:(NSString *)photoUrl
{

}
-(void)innerJump:(NSString *)url{

    NSURL *requestURL =[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *loadURLRequest = [BBHTTPHeaderADDInfo addHTTPRequestHeaderInfo:requestURL];
    [self.topicDetailWebView loadRequest:loadURLRequest];
}
-(void)discuzUserEncodeId:(NSString *)userEncodeId{
    
    BBPersonalViewController *userInformation = [[[BBPersonalViewController alloc]initWithNibName:@"BBPersonalViewController" bundle:nil]autorelease];
    userInformation.userEncodeId = userEncodeId;
    [self.navigationController pushViewController:userInformation animated:YES];
}

- (void)discuzAllBirthclubByWeek:(NSString *)week
{
    /* 暂时注释
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
//        tempArray = nil;
//        NSString *respondCount = @"0";
//        if([dataArray count]>1){
//            tempArray = [[dataArray objectAtIndex:1] componentsSeparatedByString:@"="];
//        }
//        if([tempArray count]>1){
//            respondCount  = [tempArray objectAtIndex:1];
//        }
//        tempArray = nil;
//        NSString *isFav = @"0";
//        if([dataArray count]>2){
//            tempArray = [[dataArray objectAtIndex:2] componentsSeparatedByString:@"="];
//        }
//        if([tempArray count]>1){
//            isFav  = [tempArray objectAtIndex:1];
//        }
//        tempArray = nil;
//        NSString *authorResponseCount = @"0";
//        if([dataArray count]>3){
//            tempArray = [[dataArray objectAtIndex:3] componentsSeparatedByString:@"="];
//        }
//        if([tempArray count]>1){
//            authorResponseCount  = [tempArray objectAtIndex:1];
//        }
//        tempArray = nil;
        /* 暂时注释
        NSDictionary *dataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:topicID, @"id", respondCount, @"response_count", isFav, @"is_fav", authorResponseCount, @"author_response_count", nil];
        BBNewTopicDetail *topicDetail = [[BBNewTopicDetail alloc] initWithNibName:@"BBNewTopicDetail" bundle:nil withTopicData:dataDictionary];
        [self.navigationController pushViewController:topicDetail animated:YES];
        [topicDetail release];
         */
        [HMShowPage showTopicDetail:self topicId:topicID topicTitle:nil];
    } else {
        BBSupportTopicDetailAndAsk *exteriorURL = [[BBSupportTopicDetailAndAsk alloc] initWithNibName:@"BBSupportTopicDetailAndAsk" bundle:nil];
        [exteriorURL.navigationItem setTitle:@"详情页"];
        [exteriorURL setLoadURL:url];
        [self.navigationController pushViewController:exteriorURL animated:YES];
        [exteriorURL release];
    }
}

-(void)customCreateTopic:(NSString *)navTitle withGroupId:(NSString *)groupId withGroupName:(NSString *)groupName withTopicTitle:(NSString *)topicTitle withTip:(NSString *)tip{
    if([BBUser isLogin]){
        /* 暂时注释
        BBCustomCreateTopic *customCreateTopic = [[[BBCustomCreateTopic alloc]initWithNibName:@"BBCustomCreateTopic" bundle:nil]autorelease];
        customCreateTopic.title = navTitle;
        customCreateTopic.topicTitle = topicTitle;
        customCreateTopic.selectedGroupString = groupName;
        customCreateTopic.tip = tip;
        [customCreateTopic setGroupID:groupId];
        customCreateTopic.refreshCallBackHandler = self;
        [self.navigationController pushViewController:customCreateTopic animated:YES];
         */
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
        loginController.m_LoginType = BBPushLogin;
        [self.navigationController pushViewController:loginController animated:YES];
        
    }
}

-(void)webviewClose{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)refreshCallBack{
    [self.topicDetailWebView reload];
}
- (void)bindWatch{
    [MobClick event:@"swatch" label:@"绑定手表"];
    ZXScanWatchQR *scanWatchQR = [[[ZXScanWatchQR alloc] initWithNibName:nil bundle:nil] autorelease];
    scanWatchQR.title = @"扫描二维码绑定账号";
    [self.navigationController pushViewController:scanWatchQR animated:YES];

}

- (void)enterGroup:(NSString *)groupId withGroupName:(NSString *)groupName{
    /* 暂时注释
    [MobClick event:@"box" label:@"孕期盒子讨论圈"];
    BBPostListPage * listVC = [[[BBPostListPage alloc]init]autorelease];
    listVC.listType = GroupList;
    listVC.postType = postPageTypeBox;
    listVC.groupId = groupId;
    listVC.ageTitle = @"孕期盒子讨论圈";
    [self.navigationController pushViewController:listVC animated:YES];
     */
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
        [self.navigationController presentViewController:loginController animated:YES completion:nil];
        
    }
}

- (void)mikaMusic{
    [MobClick event:@"box" label:@"孕期胎教音乐"];
    
    BBMusicTypeListController *musicList = [[[BBMusicTypeListController alloc] init] autorelease];
    [self.navigationController pushViewController:musicList animated:YES];
}

-(void)scanQR{
    if (self.shouldPushScan) {//该标记为必变push两次页面
        self.shouldPushScan = NO;
        
        ZXSanQR *scan = [[[ZXSanQR alloc] init] autorelease];
        [self.navigationController pushViewController:scan animated:YES];
    }
}
#pragma mark - BBLogin Delegate
- (void)loginFinish{

    if ([self.topicInfo count]==5) {
        /* 暂时注释
        BBCustomCreateTopic *customCreateTopic = [[[BBCustomCreateTopic alloc]initWithNibName:@"BBCustomCreateTopic" bundle:nil]autorelease];
        customCreateTopic.title = [self.topicInfo objectAtIndex:0];
        [customCreateTopic setGroupID:[self.topicInfo objectAtIndex:1]];
        customCreateTopic.selectedGroupString = [self.topicInfo objectAtIndex:2];
        customCreateTopic.topicTitle = [self.topicInfo objectAtIndex:3];
        customCreateTopic.tip = [self.topicInfo objectAtIndex:4];
        customCreateTopic.refreshCallBackHandler = self;
        [self.navigationController pushViewController:customCreateTopic animated:YES];
        [self.topicInfo removeAllObjects];
         */
    }else if(self.action){
        if ([self.action isEqualToString:@"ask_reload_webview"]) {
            [self.topicDetailWebView reload];
        }else{
            [BBOpenCtrlViewByString doAction:self.action withNavCtrl:self.navigationController];
        }
        self.action = nil;
    }
}
#pragma mark - IBAction Event

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
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
        
        if (errorCode != kCFURLErrorServerCertificateUntrusted && errorCode != 101 && errorCode != 102 && [[url absoluteString] rangeOfString:@"/app/ask/"].length > 0)
        {
            NSString *content = @"<head><title>网络出错了</title><meta charset='utf-8' /><head><title>网络出错了</title><meta charset='utf-8' />"
            "<style>a,body,h1,nav{margin:0;padding:0;border:0}"
            "html{color:#000;background-color:transparent;height:100%%;_background-image:url(/img/bui/2.0.0/src/reset/css/about:blank);_background-attachment:fixed}"
            "body{background-color:transparent;font:12px/1.5 Arial,Microsoft Yahei,sans-serif;color:#666;-webkit-font-smoothing:antialiased;height:100%%}"
            "a{color:#06C;text-decoration:none}a:hover{text-decoration:underline}"
            "h1{*font-family:Microsoft Yahei}"
            "button,input{font-family:inherit;font-size:inherit;font-weight:inherit;line-height:120%%;vertical-align:middle;*font-size:12px;*font-family:Arial,Microsoft Yahei,sans-serif}button,input[type=button],input[type=reset],input[type=submit]{*overflow:visible;cursor:pointer;padding:0}button::-moz-focus-inner{border:0;padding:0}"
            "body {background-color: #f4f4f4;}"
            ".header {padding: 10px 30px;position: relative;background-color: #4cd964;}"
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
            NSLog(@"%@",[url absoluteString]);
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
                                                             "          global.location.href=\"%@\";"
                                                             "          btnReload.removeEventListener('click', handleReload);"
                                                             "		}"
                                                             "		btnReload.addEventListener('click', handleReload);"
                                                             "      if (/iPhone OS 7/.test(navigator.userAgent)) {"
                                                             "          var header = document.querySelector('.header');"
                                                             "          header.className = header.className + ' ios7';"
                                                             "      }"
                                                             "	}(this));",content,[url absoluteString]]];
        }else if (errorCode != kCFURLErrorServerCertificateUntrusted && errorCode != 101 && errorCode != 102)
        {
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[error.userInfo stringForKey:@"NSLocalizedDescription"]  message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alertView show];
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
//    tempArray = nil;
//    NSString *respondCount = @"0";
//    if([dataArray count]>1){
//        tempArray = [[dataArray objectAtIndex:1] componentsSeparatedByString:@"="];
//    }
//    if([tempArray count]>1){
//        respondCount  = [tempArray objectAtIndex:1];
//    }
//    tempArray = nil;
//    NSString *isFav = @"0";
//    if([dataArray count]>2){
//        tempArray = [[dataArray objectAtIndex:2] componentsSeparatedByString:@"="];
//    }
//    if([tempArray count]>1){
//        isFav  = [tempArray objectAtIndex:1];
//    }
//    tempArray = nil;
//    NSString *authorResponseCount = @"0";
//    if([dataArray count]>3){
//        tempArray = [[dataArray objectAtIndex:3] componentsSeparatedByString:@"="];
//    }
//    if([tempArray count]>1){
//        authorResponseCount  = [tempArray objectAtIndex:1];
//    }
//    tempArray = nil;
    /* 暂时注释
    NSDictionary *dataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:topicID, @"id", respondCount, @"response_count", isFav, @"is_fav", authorResponseCount, @"author_response_count", nil];
    BBAppDelegate *appdelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];

    BBNewTopicDetail *topicDetail = [[[BBNewTopicDetail alloc] initWithNibName:@"BBNewTopicDetail" bundle:nil withTopicData:dataDictionary]autorelease];
    [appdelegate.navigationCtrl pushViewController:topicDetail animated:NO];
    NSMutableArray *list = [NSMutableArray arrayWithArray:appdelegate.navigationCtrl.viewControllers];
    if ([list count]>2) {
        [list removeObjectAtIndex:[list count]-2];
        [appdelegate.navigationCtrl setViewControllers:list];
    }
     */
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
    [MobClick event:@"setup" label:@"设置预产期修改"];
    BBDueDateViewController *dueDate = [[[BBDueDateViewController alloc] initWithNibName:@"BBDueDateViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:dueDate animated:YES];
    
}



- (void)shareTopicClicked
{
    BBShareMenu *menu = [[[BBShareMenu alloc] initWithType:2 title:@"分享"] autorelease];
    menu.delegate = self;
    [menu show];
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
    
    [BBShareContent shareContent:item withViewController:self withShareText:[NSString stringWithFormat:@"%@ %@",title,content] withShareOriginImage:image withShareWXTimelineTitle:title withShareWXTimelineDescription:@"" withShareWXSessionTitle:title withShareWXSessionDescription:content withShareWebPageUrl:url];
}
@end