//
//  BBMainPage.m
//  pregnancy
//
//  Created by whl on 14-4-2.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBMainPage.h"
#import "BBMainPageBabyGrowCell.h"
#import "BBMainPageDailyKnowledgeCell.h"
#import "BBMainPageMidBannerCell.h"
#import "BBMainPageRemindCell.h"
#import "BBMainPageTimingHasBabyCell.h"
#import "BBMainPageTimingPregnantCell.h"
#import "BBMainPageTimingPrepareCell.h"
#import "BBMainPageTopBannerCell.h"
#import "BBMainPageRecommendCell.h"
#import "BBMainPageRequest.h"
#import "UMFeedbackChat.h"
#import "HMSearchVC.h"
#import "BBLogin.h"
#import "BBSign.h"
#import "BBDueDateViewController.h"
#import "HMRecommendVC.h"
#import "BBActivityRule.h"
#import "BBSupportTopicDetail.h"
#import "BBMessageList.h"
#import "BBMessageRequest.h"
#import "BBBabyBornViewController.h"
#import "BBBandFatherRequest.h"
#import "BBKnowlegeViewController.h"
#import "BBKonwlegdeDB.h"
#import "BBKonwlegdeModel.h"
#import "BBRemindViewController.h"
#import "HMShowPage.h"
#import "BBAdRequest.h"
#import "BBAdPVManager.h"
#import "BBMainPagePregnantTimingView.h"
#import "BBToolsRequest.h"
#import "BBMainPageToolsCell.h"
#import "BBShareContent.h"
#import "MBProgressHUD.h"
#import "YBBDateSelect.h"
#import "PXAlertView.h"
#import "BBRemotePushInfo.h"
#import "AHAlertView.h"
#import "BBToolOpreation.h"

#define MAIN_CONTENT_TOP_BANNER_KEY @"section0"
#define MAIN_CONTENT_TIMING_KEY @"section1"
#define MAIN_CONTENT_BABY_GROW_KEY @"section2"
#define MAIN_CONTENT_REMMIND_KEY @"section3"
#define MAIN_CONTENT_DAILY_KNOWLEDGE_KEY @"section4"
#define MAIN_CONTENT_TOOL_KEY @"section5"
#define MAIN_CONTENT_RECOMMEND_KEY @"section6"
#define MAIN_CONTENT_MID_BANNER_KEY @"section7"
#define TOP_BANNER_VIEW_TAG 101
#define MID_BANNER_VIEW_TAG 102
#define PREGNANT_ALERT_VIEW_TAG 201
#define DUEDATE_ALERT_VIEW_TAG 202
#define kBBBabyBornRemiderTag 13

@interface BBMainPage ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    UIActionSheetDelegate,
    UIAlertViewDelegate,
    BBLoginDelegate,
    BBBannerViewDelegate,
    BBToolOpreationDelegate
>


//页面主体tableview
@property (strong, nonatomic) UITableView *s_ListView;

//展示内容的数据源
@property (strong, nonatomic) NSMutableDictionary *s_DataSourceDict;

//配置不同的阶段主页显示内容
@property (strong, nonatomic) NSArray *s_DisplaySettingsArray;

//请求中部广告的request
@property (nonatomic, strong) ASIFormDataRequest *s_MidBannerRequest;

//请求topbanner的request
@property (nonatomic, strong) ASIFormDataRequest *s_TopBannerRequest;

//请求宝宝树推荐的request
@property (nonatomic, strong) ASIFormDataRequest *s_RecommendRequest;

//检查新消息的request
@property (nonatomic, strong) ASIFormDataRequest *s_NewMessageRequest;

//检查是否需要同步预产期请求
@property (nonatomic, strong) ASIFormDataRequest *s_CheckDueDateRequest;

//同步预产期请求
@property (nonatomic, strong) ASIFormDataRequest *s_DueDateRequest;

//统计宝宝生日请求
@property (nonatomic, strong) ASIFormDataRequest *s_StatisticsDueDateRequest;

//获取首页工具列表请求
@property (nonatomic, strong) ASIFormDataRequest *s_GetMainToolsListRequest;

//手表绑定状态请求
@property (nonatomic, strong) ASIFormDataRequest *s_WatchBindStatusRequest;

//更新 下载5.1版加孕气请求
@property (nonatomic, strong) ASIFormDataRequest *s_AddPreValueRequest;

@property (nonatomic,assign)float s_BabyGrowCellHeight;

//@property (nonatomic,assign)NSInteger s_CurrentUsingDay;

//判断各部分是否需要刷新
@property (assign) BOOL s_NeedRefreshTopBanner;

@property (assign) BOOL s_NeedRefreshTools;

@property (assign) BOOL s_NeedRefreshMidBanner;

@property (assign) BOOL s_NeedRefreshRecommend;

@property (assign) BOOL s_NeedRefreshRemind;

@property (assign) BOOL s_NeedRefreshBabyGrow;

@property (assign) BOOL s_NeedRefreshTiming;

@property (assign) BOOL s_NeedRefreshDailyKnowledge;

@property (assign) BOOL s_DisplayingBanner;

//判断用户是否进入过消息中心，用于小红点显示逻辑
@property (nonatomic, assign) BBMessageRedPointStatus s_MessageStatus;

//判断是否第一次进入
@property (assign) BOOL s_IsVCFirstLoad;

//判断页面是否可见，有于广告PV统计
@property (assign) BOOL s_IsViewVisible;

//需要每天刷新一次知识的刷新日期，用于再次刷新进行判断
@property (nonatomic, strong) NSDate *s_LastDailyUpdateDate;

//判断是否可以显示中间广告
@property (assign) BOOL s_CanShowMidBanner;

//触发login时候的操作类型，login后根据操作类型进行下一步动作
@property (assign, nonatomic) LoginType s_LoginType;

//签到按钮
@property (nonatomic,strong)UIButton *s_UserSignButton;

//右上角小红点
@property (nonatomic,strong)UIImageView *s_MessagePointImgView;

@property (nonatomic,strong) NSString *s_OnlineDueDate;

@property (nonatomic,strong) BBMainPagePregnantTimingView *s_PregnantTimingView;

// 感动页webview
@property (nonatomic, strong)BBSupportTopicDetail *movedWebView;

@property (nonatomic, strong) UIButton *s_RightButton;
@end

/**
 *  目前为止，最多7个section，头图banner和顶部banner只set一次，需要更新的时候更新数据源并reloaddata即可
 */
@implementation BBMainPage

@synthesize s_ToolOperation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBColor(239, 239, 244, 1);
    
    self.navigationItem.title = @"宝宝树孕育";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    UIImageView *mainLogo = [[UIImageView alloc]initWithFrame:CGRectMake(140, 70, 40, 40)];
    [mainLogo setImage:[UIImage imageNamed:@"mainPageLogo"]];
    [self.view addSubview:mainLogo];
    
    self.s_ListView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_TAB_BAR_HEIGHT)];
    [self.view addSubview:self.s_ListView];
    [self.s_ListView setBackgroundColor:[UIColor clearColor]];
    [self.s_ListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.s_ListView.dataSource = self;
    self.s_ListView.delegate = self;
    
    self.s_BabyGrowCellHeight  = 83;
    
    //footer 增加建议反馈 活动说明按钮
    UIView *tableFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 36)];
    [tableFooter setBackgroundColor:[UIColor clearColor]];
    UIImageView *feedBackIcon = [[UIImageView alloc]initWithFrame:CGRectMake(12, 11, 14, 14)];
    [feedBackIcon setImage:[UIImage imageNamed:@"community_head_tiezi_icon"]];
    [tableFooter addSubview:feedBackIcon];
    UIButton *feedBackButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 10, 80, 18)];
    [feedBackButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [feedBackButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [feedBackButton setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [feedBackButton setTitle:@"建议反馈" forState:UIControlStateNormal];
    [feedBackButton addTarget:self action:@selector(feedBackClicked) forControlEvents:UIControlEventTouchUpInside];
    feedBackButton.exclusiveTouch = YES;
    [tableFooter addSubview:feedBackButton];
    UIButton *activityButton = [[UIButton alloc]initWithFrame:CGRectMake(228, 10, 80, 18)];
    [activityButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [activityButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [activityButton setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [activityButton setTitle:@"※ 活动说明" forState:UIControlStateNormal];
    [activityButton addTarget:self action:@selector(activityClicked) forControlEvents:UIControlEventTouchUpInside];
    activityButton.exclusiveTouch = YES;
    [tableFooter addSubview:activityButton];
    self.s_ListView.tableFooterView = tableFooter;
    
    self.s_UserSignButton = [[UIButton alloc]initWithFrame:CGRectMake(260, 0, 54, 90)];
    [self.s_UserSignButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [self.s_UserSignButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    self.s_UserSignButton.exclusiveTouch = YES;
    [self.s_ListView addSubview:self.s_UserSignButton];
    [self.s_UserSignButton addTarget:self action:@selector(signButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.s_PregnantTimingView = [[BBMainPagePregnantTimingView alloc]initWithFrame:CGRectMake(0, 134-26, 320, 62)];
    [self.s_ListView addSubview:self.s_PregnantTimingView];
    [self.s_PregnantTimingView addButtonActionWithTarget:self selector:@selector(babyBornBtnClicked)];
    
    //添加搜索和消息按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.exclusiveTouch = YES;
    [leftButton setFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"mainPageSearch"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"mainPageSearchPressed"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    self.s_RightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.s_RightButton.exclusiveTouch = YES;
    [self.s_RightButton setFrame:CGRectMake(0, 0, 40, 30)];
    self.s_MessagePointImgView = [[UIImageView alloc]initWithFrame:CGRectMake(40-12, 0, 12, 12)];
    [self.s_MessagePointImgView setImage:[UIImage imageNamed:@"new_point"]];
    self.s_MessagePointImgView.hidden = YES;
    [self.s_RightButton addSubview:self.s_MessagePointImgView];
    [self.s_RightButton setImage:[UIImage imageNamed:@"mainPageMessage"] forState:UIControlStateNormal];
    [self.s_RightButton setImage:[UIImage imageNamed:@"mainPageMessagePressed"] forState:UIControlStateHighlighted];
    [self.s_RightButton addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.s_RightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    [self.s_RightButton setEnabled:NO];
    
    self.s_DataSourceDict  = [[NSMutableDictionary alloc]init];
    
    //self.s_CurrentUsingDay = 0;

    self.s_IsVCFirstLoad = YES;
    
    self.s_CanShowMidBanner = YES;
    
    self.s_ToolOperation = [[BBToolOpreation alloc]init];
    
    [self.view setUserInteractionEnabled:NO];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userRoleChangedNotification:) name:USER_ROLE_CHANGED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userRoleChangedNotification:) name:USER_PREGNANCY_DATE_CHANGED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateSignButton];
    [self checkNewMessage];
    [self checkSmartWatchBindStatus];
    if(self.s_IsVCFirstLoad)
    {
        //获取数据源并刷新
        self.s_IsVCFirstLoad = NO;
        [self refreshContentAndForceReload:YES];
    }
    else
    {
        //页面内容刷新
        [self refreshContentAndForceReload:NO];
    }
    
    // 显示感动页面
    if([BBUser needShowMovedPage] == 1
       && [BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
    {
        [self showMovedPage];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.s_IsViewVisible = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:BANNER_APEAR_NOTIFICATION object:nil];
    
    // 感动页加载显示时不检查 同步预产期
    if([BBUser needShowMovedPage] == 0 && ![BBUser needAddPreValue])
    {
        [self checkDueDateState];
        [self synchronizeStatisticDueDate];
    }
    [ApplicationDelegate checkDisplayOperateGuide:GUIDE_SHOW_HOME_PAGE];
    [self  synchronizeDueDate];
    
    [self checkAddPreValue];
    
    if (!self.s_PregnantTimingView.m_HasDisplayedProgressAnimation)
    {
        [self.s_PregnantTimingView displayProgressAnimation];
        self.s_PregnantTimingView.m_HasDisplayedProgressAnimation = YES;
    }
//    [self.s_PregnantTimingView reload];
    
    // 育儿报喜提醒
    BBAppDelegate *delegate = (BBAppDelegate*)[[UIApplication sharedApplication]delegate];
    if(delegate.m_isBabyBornRemind)
    {
        [self openBabyBornRemind];
        delegate.m_isBabyBornRemind = NO;
    }
    [self.s_RightButton setEnabled:YES];
    [self.view setUserInteractionEnabled:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ApplicationDelegate clickGuideImageAction];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.s_IsViewVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_s_MidBannerRequest clearDelegatesAndCancel];
    [_s_TopBannerRequest clearDelegatesAndCancel];
    [_s_RecommendRequest clearDelegatesAndCancel];
    [_s_NewMessageRequest clearDelegatesAndCancel];
    [_s_CheckDueDateRequest clearDelegatesAndCancel];
    [_s_DueDateRequest clearDelegatesAndCancel];
    [_s_StatisticsDueDateRequest clearDelegatesAndCancel];
    [_s_GetMainToolsListRequest clearDelegatesAndCancel];
    [_s_WatchBindStatusRequest clearDelegatesAndCancel];
    [_s_AddPreValueRequest clearDelegatesAndCancel];
}

-(void)mobclickLabel:(NSString*)label
{
    if ([BBUser getNewUserRoleState]==BBUserRoleStatePrepare)
    {
        [MobClick event:@"home_prepare_v2" label:label];
    }
    else if ([BBUser getNewUserRoleState]==BBUserRoleStatePregnant)
    {
        [MobClick event:@"home_pregnant_v2" label:label];
    }
    else
    {
        [MobClick event:@"home_baby_v2" label:label];
    }
}


#pragma mark- 通知事件处理

-(void)userRoleChangedNotification:(NSNotification *)notification
{
    self.s_IsVCFirstLoad = YES;
    self.s_PregnantTimingView.m_HasDisplayedProgressAnimation = NO;
}

-(void)appBecomeActive:(NSNotification *)notification
{
    self.s_CanShowMidBanner = YES;
    if (self.s_IsViewVisible)
    {
        //由于app从后台回前台不会调用 apear方法，所以发送通知让banner统计一次数据
        [[NSNotificationCenter defaultCenter]postNotificationName:BANNER_APEAR_NOTIFICATION object:nil];
        [self checkDueDateState];
        [self synchronizeStatisticDueDate];
        [self checkSmartWatchBindStatus];
        [self synchronizeDueDate];
        [self updateSignButton];
        [self checkNewMessage];
        if(self.s_IsVCFirstLoad)
        {
            //获取数据源并刷新
            self.s_IsVCFirstLoad = NO;
            [self refreshContentAndForceReload:YES];
        }
        else
        {
            //页面内容刷新
            [self refreshContentAndForceReload:NO];
        }
    }
}

#pragma mark - BabyBorn Reminder
// 比较两个日期大小
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

- (void)openBabyBornRemind
{
    /*
     报喜贴提醒：
     1.用户所在为孕期版
     2.提醒次数小于3
     3.预产期+14天大于今天日期；
     4.今日没有提醒过
     满足以上三个条件开启打开APP时开启报喜贴提醒;
     */
    
    NSDate *remindDate = [BBUser getBabyBornReminderTime];
    // 比较上次提醒时间和本次进入时间，如果是同一天不提醒
    if(remindDate && [self compareOneDay:remindDate withAnotherDay:[BBPregnancyInfo currentDate]] == -1)
    {
        [BBUser setBabyBornTodayReminderNum:0];
    }
    
    if(([BBUser getNewUserRoleState] == BBUserRoleStatePregnant)
       && ([BBUser getBabyBornReminderNum] >= 0)
       && ([self compareOneDay:[[BBPregnancyInfo dateOfPregnancy] dateByAddingDays:14] withAnotherDay:[BBPregnancyInfo currentDate]] == -1)
       && ([BBUser getBabyBornTodayReminderNum] == 0))
    {
        [self showBabyBornRemind];
        [BBUser setBabyBornReminderNum:[BBUser getBabyBornReminderNum]-1];
        // 今日提醒次数
        [BBUser setBabyBornTodayReminderNum:1];
        // 保存提醒日期
        [BBUser setBabyBornReminderTime:[BBPregnancyInfo currentDate]];
    }
}

- (void)showBabyBornRemind
{
    [MobClick event:@"good_news_v2" label:@"邀请报喜弹层次数"];
    NSString *preStr = @"  亲爱的，宝宝已经出生了吗？快去圈子里报个喜吧，大家都等着你的好消息!";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:preStr   message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"残忍的拒绝",@"切换到快乐育儿",@"去报喜，晒宝宝", nil];
    [alertView setTag:kBBBabyBornRemiderTag];
    [alertView show];
}

#pragma mark- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [self.s_DisplaySettingsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //有数据则返回1，无数据则返回0

    NSString *dataSourceKey = [self.s_DisplaySettingsArray objectAtIndex:section];
    
    if ([dataSourceKey isEqualToString: MAIN_CONTENT_TOP_BANNER_KEY] || [dataSourceKey isEqualToString:MAIN_CONTENT_TIMING_KEY])
    {
        //topbanner和计时部分一直都有
        return 1;
    }
    
    if ([self.s_DataSourceDict objectForKey:dataSourceKey])
    {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dataSourceKey = [self.s_DisplaySettingsArray objectAtIndex:indexPath.section];
    if ([dataSourceKey isEqualToString:MAIN_CONTENT_TOP_BANNER_KEY])
    {
        self.s_DisplayingBanner = YES;
        BBMainPageTopBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBMainPageTopBannerCell"];
        if (cell == nil)
        {
            cell = [[BBMainPageTopBannerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBMainPageTopBannerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.m_BannerView.delegate = self;
            cell.m_BannerView.tag = TOP_BANNER_VIEW_TAG;
            
            [cell.m_BannerEmptyView setImage:[UIImage imageNamed:@"banner_empty"]];
            
        }
        //如果需要更新bool == YES， set新数据，bool = NO
        if (self.s_NeedRefreshTopBanner)
        {
            [cell setCellUseData:[self.s_DataSourceDict objectForKey:MAIN_CONTENT_TOP_BANNER_KEY]];
            self.s_NeedRefreshTopBanner = NO;
        }
        else
        {
            //如果图片没下载成功，重新下载
            if (cell.m_BannerView.hidden)
            {
                [cell setCellUseData:[self.s_DataSourceDict objectForKey:MAIN_CONTENT_TOP_BANNER_KEY]];
            }
        }
        
        return cell;
    }
    else if ([dataSourceKey isEqualToString:MAIN_CONTENT_TIMING_KEY])
    {
        //3个阶段，不同cell，不同逻辑
        if ([BBUser getNewUserRoleState]== BBUserRoleStatePrepare)
        {

            self.s_PregnantTimingView.hidden = YES;
            BBMainPageTimingPrepareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBMainPageTimingPrepareCell"];
            if (cell == nil)
            {
                cell = [[BBMainPageTimingPrepareCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBMainPageTimingPrepareCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.m_PregnantButton addTarget:self action:@selector(pregmentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            }
            return cell;
        }
        else if ([BBUser getNewUserRoleState]== BBUserRoleStatePregnant)
        {
            self.s_PregnantTimingView.hidden = NO;
            BBMainPageTimingPregnantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBMainPageTimingPregnantCell"];
            if (cell == nil)
            {
                cell = [[BBMainPageTimingPregnantCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBMainPageTimingPregnantCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            //如果需要更新bool == YES， set新数据，bool = NO
            if (self.s_NeedRefreshTiming)
            {
                //set数据
                //[cell updateUI];
                [self.s_PregnantTimingView reload];
                self.s_NeedRefreshTiming = NO;
            }
            return cell;
        }
        else
        {
            self.s_PregnantTimingView.hidden = YES;
            BBMainPageTimingHasBabyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBMainPageTimingHasBabyCell"];
            if (cell == nil)
            {
                cell = [[BBMainPageTimingHasBabyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBMainPageTimingHasBabyCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            //如果需要更新bool == YES， set新数据，bool = NO
            if (self.s_NeedRefreshTiming)
            {
                //set数据
                [cell updateUI];
                self.s_NeedRefreshTiming = NO;
            }
            return cell;
        }
    }
    else if ([dataSourceKey isEqualToString:MAIN_CONTENT_BABY_GROW_KEY])
    {
        BBMainPageBabyGrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBMainPageBabyGrowCell"];
        if (cell == nil)
        {
            cell = [[BBMainPageBabyGrowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBMainPageBabyGrowCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //如果需要更新bool == YES， set新数据，bool = NO
        if (self.s_NeedRefreshBabyGrow)
        {
            //set数据
            BBKonwlegdeModel *growModel = (BBKonwlegdeModel*)[self.s_DataSourceDict objectForKey:MAIN_CONTENT_BABY_GROW_KEY];
            [cell setData:growModel cellHeight:self.s_BabyGrowCellHeight];
            //为了防止图片下载失败，目前改为每次都刷，所以注释掉了s_NeedRefreshBabyGrow状态回置
            //self.s_NeedRefreshBabyGrow = NO;
        }
        return cell;
    }
    else if ([dataSourceKey isEqualToString:MAIN_CONTENT_REMMIND_KEY])
    {
        BBMainPageRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBMainPageRemindCell"];
        if (cell == nil)
        {
            cell = [[BBMainPageRemindCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBMainPageRemindCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //如果需要更新bool == YES， set新数据，bool = NO
        if (self.s_NeedRefreshRemind)
        {
            //set数据
            [cell setCellUseData:[self.s_DataSourceDict objectForKey:MAIN_CONTENT_REMMIND_KEY]];
            self.s_NeedRefreshRemind = NO;
        }
        return cell;
    }
    else if ([dataSourceKey isEqualToString:MAIN_CONTENT_DAILY_KNOWLEDGE_KEY])
    {
        BBMainPageDailyKnowledgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBMainPageDailyKnowledgeCell"];
        if (cell == nil)
        {
            cell = [[BBMainPageDailyKnowledgeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBMainPageDailyKnowledgeCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //如果需要更新bool == YES， set新数据，bool = NO
        if (self.s_NeedRefreshDailyKnowledge)
        {
            //set数据
            [cell setCellUseData:[self.s_DataSourceDict objectForKey:MAIN_CONTENT_DAILY_KNOWLEDGE_KEY]];
            //为了防止图片下载失败，目前改为每次都刷，所以注释掉了s_NeedRefreshDailyKnowledge状态回置
            //self.s_NeedRefreshDailyKnowledge = NO;
        }
        return cell;
    }
    else if ([dataSourceKey isEqualToString:MAIN_CONTENT_MID_BANNER_KEY])
    {
        BBMainPageMidBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBMainPageMidBannerCell"];
        if (cell == nil)
        {
            cell = [[BBMainPageMidBannerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBMainPageMidBannerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.m_BannerView.delegate = self;
            cell.m_BannerView.tag = MID_BANNER_VIEW_TAG;
        }
        //如果需要更新bool == YES， set新数据，bool = NO
        if (self.s_NeedRefreshMidBanner)
        {
            [cell setCellUseData:[self.s_DataSourceDict objectForKey:MAIN_CONTENT_MID_BANNER_KEY]];
            self.s_NeedRefreshMidBanner = NO;
        }
        else
        {
            //如果图片没下载成功，重新下载
            if (cell.m_BannerView.hidden)
            {
                [cell setCellUseData:[self.s_DataSourceDict objectForKey:MAIN_CONTENT_MID_BANNER_KEY]];
            }
        }
        return cell;
    }
    else if ([dataSourceKey isEqualToString:MAIN_CONTENT_TOOL_KEY])
    {
        BBMainPageToolsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBMainPageToolsCell"];
        if (cell == nil)
        {
            cell = [[BBMainPageToolsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBMainPageToolsCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak __typeof (self) weakself = self;
            cell.m_ToolBlock = ^(int index)
            {
                __strong __typeof (weakself) strongself = weakself;
                if (strongself)
                {
                    [strongself toolAction:index];
                }
            };
        }
        //如果需要更新bool == YES， set新数据，bool = NO
        if (self.s_NeedRefreshTools)
        {
            [cell setCellUseData:[self.s_DataSourceDict objectForKey:MAIN_CONTENT_TOOL_KEY]];
            self.s_NeedRefreshTools = NO;
        }
        else
        {
            //更新图片
            [cell downloadImageForData:[self.s_DataSourceDict objectForKey:MAIN_CONTENT_TOOL_KEY]];
        }
        return cell;
    }
    else
    {
        BBMainPageRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBMainPageRecommendCell"];
        if (cell == nil)
        {
            cell = [[BBMainPageRecommendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBMainPageRecommendCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.m_MoreButton addTarget:self action:@selector(moreRecommendClicked) forControlEvents:UIControlEventTouchUpInside];
            __weak __typeof (self) weakself = self;
            cell.m_RecommendBlock = ^(int index){
                __strong __typeof (weakself) strongself = weakself;
                if (strongself)
                {
                    NSArray *recommendArray = [strongself.s_DataSourceDict objectForKey:MAIN_CONTENT_RECOMMEND_KEY];
                    if (index >=0 && index < [recommendArray count])
                    {
                        if([[(NSDictionary *)[recommendArray objectAtIndex:index]stringForKey:@"id"] isNotEmpty])
                        {
                            if ([BBUser getNewUserRoleState]==BBUserRoleStatePrepare)
                            {
                                [MobClick event:@"recommend_prepare_v2" label:[NSString stringWithFormat:@"宝宝树推荐-%@",[(NSDictionary *)[recommendArray objectAtIndex:index]stringForKey:@"id"]]];
                            }
                            else if ([BBUser getNewUserRoleState]==BBUserRoleStatePregnant)
                            {
                                [MobClick event:@"recommend_pregnant_v2" label:[NSString stringWithFormat:@"宝宝树推荐-%@",[(NSDictionary *)[recommendArray objectAtIndex:index]stringForKey:@"id"]]];
                            }
                            else
                            {
                                [MobClick event:@"recommend_baby_v2" label:[NSString stringWithFormat:@"宝宝树推荐-%@",[(NSDictionary *)[recommendArray objectAtIndex:index]stringForKey:@"id"]]];
                            }
                            [BBStatistic visitType:BABYTREE_TYPE_TOPIC_HOME_RECOMMEND contentId:[(NSDictionary *)[recommendArray objectAtIndex:index]stringForKey:@"id"]];
                            [HMShowPage showTopicDetail:strongself topicId:[(NSDictionary *)[recommendArray objectAtIndex:index]stringForKey:@"id"] topicTitle:[(NSDictionary *)[recommendArray objectAtIndex:index]stringForKey:@"title"]];
                        }
                    }
                }};
        }
        //如果需要更新bool == YES， set新数据，bool = NO
        if (self.s_NeedRefreshRecommend)
        {
            [cell setCellUseData:[self.s_DataSourceDict objectForKey:MAIN_CONTENT_RECOMMEND_KEY]];
            //为了防止图片下载失败，目前改为每次都刷，所以注释掉了s_NeedRefreshRecommend状态回置
            //self.s_NeedRefreshRecommend = NO;
        }
        return cell;
    }
}


#pragma mark- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dataSourceKey = [self.s_DisplaySettingsArray objectAtIndex:indexPath.section];
    if ([dataSourceKey isEqualToString:MAIN_CONTENT_TOP_BANNER_KEY])
    {
        //固定高度
        return 134;
    }
    else if ([dataSourceKey isEqualToString:MAIN_CONTENT_TIMING_KEY])
    {
        //固定高度
        if ([BBUser getNewUserRoleState]== BBUserRoleStatePrepare)
        {
            return 65;
        }
        else if ([BBUser getNewUserRoleState]== BBUserRoleStatePregnant)
        {
            return 36;
        }
        else
        {
            return 36;
        }
    }
    else if ([dataSourceKey isEqualToString:MAIN_CONTENT_BABY_GROW_KEY])
    {
        //固定高度
        if(self.s_NeedRefreshBabyGrow)
        {
            BBKonwlegdeModel *growModel = (BBKonwlegdeModel*)[self.s_DataSourceDict objectForKey:MAIN_CONTENT_BABY_GROW_KEY];
            self.s_BabyGrowCellHeight = [BBMainPageBabyGrowCell CalculateCellHeightUseData:growModel];
        }
        return self.s_BabyGrowCellHeight;
    }
    else if ([dataSourceKey isEqualToString:MAIN_CONTENT_REMMIND_KEY])
    {
        //固定高度
        return 123;
    }
    else if ([dataSourceKey isEqualToString:MAIN_CONTENT_DAILY_KNOWLEDGE_KEY])
    {
        //固定高度
        return 229;
    }
    else if ([dataSourceKey isEqualToString:MAIN_CONTENT_MID_BANNER_KEY])
    {
        //固定高度
        return 81;
    }
    else if ([dataSourceKey isEqualToString:MAIN_CONTENT_TOOL_KEY])
    {
        //固定高度
        return 110;
    }
    else
    {
        //固定高度
        return 367;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dataSourceKey = [self.s_DisplaySettingsArray objectAtIndex:indexPath.section];
    if ([dataSourceKey isEqualToString:MAIN_CONTENT_BABY_GROW_KEY])
    {
        [self mobclickLabel:@"版块-宝宝发育"];
        //打开宝宝发育页面
        BBRemindViewController * brv = [[BBRemindViewController alloc]initWithType:RemindTypeBabyGrowth];
        BBKonwlegdeModel *obj = [self.s_DataSourceDict objectForKey:MAIN_CONTENT_BABY_GROW_KEY];
        if (obj)
        {
            brv.startID = obj.ID;
        }
        brv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:brv animated:YES];
    }
    else if ([dataSourceKey isEqualToString:MAIN_CONTENT_REMMIND_KEY])
    {
        [self mobclickLabel:@"版块-关爱提醒"];
        //打开关爱提醒
        //BBRemindViewController * brv = [[BBRemindViewController alloc]initWithType:RemindTypeRimind];
        BBKnowlegeViewController * bkv = [[BBKnowlegeViewController alloc]init];
        BBKonwlegdeModel *obj = [self.s_DataSourceDict objectForKey:MAIN_CONTENT_REMMIND_KEY];
        if (obj)
        {
            bkv.startID = obj.ID;
        }
        bkv.m_CurVCType = KnowlegdeVCRemind;
        bkv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bkv animated:YES];
    }
    else if ([dataSourceKey isEqualToString:MAIN_CONTENT_DAILY_KNOWLEDGE_KEY])
    {
        [self mobclickLabel:@"版块-每日知识"];
        //打开每日知识页面
        BBKnowlegeViewController * bkv = [[BBKnowlegeViewController alloc]init];
        BBKonwlegdeModel *obj = [self.s_DataSourceDict objectForKey:MAIN_CONTENT_DAILY_KNOWLEDGE_KEY];
        if (obj)
        {
            bkv.startID = obj.ID;
        }
        bkv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bkv animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.s_ListView.contentOffset.y<134)
    {
        if (!self.s_DisplayingBanner)
        {
            self.s_DisplayingBanner = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:BANNER_APEAR_NOTIFICATION object:nil];
        }
    }
    else
    {
        if (self.s_DisplayingBanner)
        {
            self.s_DisplayingBanner = NO;
        }
    }
}

#pragma mark - Banner代理

- (void)imageCachedDidFinish:(BBBannerView *)bannerView
{
    bannerView.hidden = NO;
    [bannerView startRolling];
}

- (void)bannerView:(BBBannerView *)bannerView didDisplayPage:(NSInteger)index withData:(NSDictionary *)bannerData
{
    if (self.s_IsViewVisible && bannerView.tag == TOP_BANNER_VIEW_TAG && self.s_ListView.contentOffset.y< 134.f && !bannerView.hidden)
    {
        if ([[bannerData stringForKey:@"select_type"] isEqualToString:@"6"])
        {
            NSDictionary *ad = [bannerData dictionaryForKey:@"ad"];
            if ([ad isNotEmpty])
            {
                [[BBAdPVManager sharedInstance]addLocalPVForAd:ad];
            }
        }
    }
}

- (void)bannerView:(BBBannerView *)bannerView didSelectImageView:(NSInteger)index withData:(NSDictionary *)bannerData
{
    if (bannerView.tag == TOP_BANNER_VIEW_TAG || bannerView.tag == MID_BANNER_VIEW_TAG)
    {
        if (bannerView.tag == TOP_BANNER_VIEW_TAG)
        {
            //增加头图banner的点击事件,根据id+title的格式统计,比如"266时间去哪儿了"
            if ([bannerData stringForKey:@"id"] && [bannerData stringForKey:@"title"])
            {
                NSString *eventTopBannerClickId = [NSString stringWithFormat:@"%@%@",[bannerData stringForKey:@"id"],[bannerData stringForKey:@"title"]];
                [MobClick event:@"topBannerClick_V2" label:eventTopBannerClickId];
            }
            
        }
        
        if ([[bannerData stringForKey:@"select_type"] isEqualToString:@"1"])
        {
            [BBStatistic visitType:BABYTREE_TYPE_TOPIC_HOME_AD contentId:[[bannerData dictionaryForKey:@"topic_data"] stringForKey:@"id"]];
            [HMShowPage showTopicDetail:self topicId:[[bannerData dictionaryForKey:@"topic_data"] stringForKey:@"id"] topicTitle:[[bannerData dictionaryForKey:@"topic_data"]stringForKey:@"title"]];
        }
        else if ([[bannerData stringForKey:@"select_type"] isEqualToString:@"2"])
        {
            [self openSupportTopicURL:[bannerData stringForKey:@"url"] title:[bannerData stringForKey:@"title"]];
        }
        else if ([[bannerData stringForKey:@"select_type"] isEqualToString:@"3"])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[bannerData stringForKey:@"download_url"]]];
        }
        else if ([[bannerData stringForKey:@"select_type"] isEqualToString:@"4"])
        {
            [BBOpenCtrlViewByString doAction:[bannerData stringForKey:@"native_page"] withNavCtrl:self.navigationController];
        }
        else if ([[bannerData stringForKey:@"select_type"] isEqualToString:@"6"])
        {
            NSDictionary *ad = [bannerData dictionaryForKey:@"ad"];
            if ([ad isNotEmpty])
            {
                NSString *url = [ad stringForKey:AD_DICT_URL_KEY];
                NSString *title = [ad stringForKey:AD_DICT_TITLE_KEY]?[ad stringForKey:AD_DICT_TITLE_KEY]:@"推广";
                if ([url isNotEmpty])
                {
                    [self openSupportTopicURL:url title:title];
                }
            }
        }
    }
}

- (void)bannerViewdidClosed:(BBBannerView *)bannerView
{
    if(bannerView.tag == MID_BANNER_VIEW_TAG)
    {
        self.s_CanShowMidBanner = NO;
        [self.s_DataSourceDict removeObjectForKey:MAIN_CONTENT_MID_BANNER_KEY];
        [self.s_ListView reloadData];
    }
}


#pragma mark- 页面内点击事件

//左上搜索按钮点击
-(void)leftBarButtonItemClicked
{
    // 搜索View
    [self mobclickLabel:@"首页-搜索"];
    HMSearchVC *searchVC = [[HMSearchVC alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    searchVC.isShowKeyboard = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

//右上消息按钮点击
-(void)rightBarButtonItemClicked
{
    [self mobclickLabel:@"首页-消息中心"];
    if ([BBUser isLogin])
    {
        BBMessageList *messageList = [[BBMessageList alloc] initWithNibName:@"BBMessageList" bundle:nil];
        messageList.m_MessageRedPointStatus = self.s_MessageStatus;
        self.s_MessageStatus = BBMessageRedPointStatusNone;
        [self showNewMessagePoint:self.s_MessageStatus];
        messageList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messageList animated:YES];

    }
    else
    {
        [self presentLoginWithLoginType:LoginMessage];
    }
    
}

//签到按钮点击
-(void)signButtonClicked
{
    [self mobclickLabel:@"首页-签到"];
    if ([BBUser isLogin])
    {
        BBSign *bbSign = [[BBSign alloc]initWithNibName:@"BBSign" bundle:nil];
        bbSign.m_SignType = BBPushSign;
        bbSign.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bbSign animated:YES];
    }
    else
    {
        [self presentLoginWithLoginType:LoginSign];
    }
}

//我怀孕啦按钮点击
-(void)pregmentBtnClicked
{
    [self mobclickLabel:@"我怀孕了"];
    UIAlertView *pregnantAlert = [[UIAlertView alloc]initWithTitle:@"切换到孕期版" message:@"恭喜你成为了准妈妈，接下来我们将陪伴你度过幸福的10个月。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    pregnantAlert.tag = PREGNANT_ALERT_VIEW_TAG;
    [pregnantAlert show];
}

//宝宝出生按钮点击
-(void)babyBornBtnClicked
{
    [self mobclickLabel:@"报喜"];
    [self showBabyBornRemind];
}

//更多推荐按钮点击
-(void)moreRecommendClicked
{
    [self mobclickLabel:@"宝宝树推荐-更多"];
    HMRecommendVC *recommendMore = [[HMRecommendVC alloc]initWithNibName:@"HMRecommendVC" bundle:nil];
    recommendMore.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recommendMore animated:YES];
}

//活动说明
-(void)activityClicked
{
    BBActivityRule *activityRule = [[BBActivityRule alloc] initWithNibName:@"BBActivityRule" bundle:nil];
    activityRule.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityRule animated:YES];
}

//建议反馈按钮点击
-(void)feedBackClicked
{
    [self mobclickLabel:@"建议反馈"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"意见反馈" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"账户被禁用反馈",@"Babybox反馈",@"建议反馈", nil];
    [actionSheet showInView:self.tabBarController.view];
}


#pragma mark- 工具点击事件

-(void)toolAction:(int)index
{
    NSArray *toolArray = [self.s_DataSourceDict objectForKey:MAIN_CONTENT_TOOL_KEY];
    if(index>= 0 && index<[toolArray count])
    {
        BBToolModel *model =[toolArray objectAtIndex:index];
        [self.s_ToolOperation performActionOfTool:model target:self];
    }
}

-(void)openSupportTopicURL:(NSString*)url title:(NSString*)title
{
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.isShowCloseButton = NO;
    [exteriorURL setLoadURL:url];
    [exteriorURL setTitle:title];
    exteriorURL.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:exteriorURL animated:YES];
}


#pragma mark- 整体更新逻辑

-(void)refreshContentAndForceReload:(BOOL)forceReload
{
    if (forceReload)
    {
        if ([BBUser getNewUserRoleState]== BBUserRoleStatePrepare)
        {
//            self.navigationItem.title = @"快乐备孕";
//            [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
            self.s_DisplaySettingsArray = [NSArray arrayWithObjects:MAIN_CONTENT_TOP_BANNER_KEY,MAIN_CONTENT_TIMING_KEY,MAIN_CONTENT_TOOL_KEY,MAIN_CONTENT_RECOMMEND_KEY,MAIN_CONTENT_MID_BANNER_KEY, nil];
            self.s_PregnantTimingView.hidden = YES;
        }
        else if ([BBUser getNewUserRoleState]== BBUserRoleStatePregnant)
        {
//            self.navigationItem.title = @"快乐孕期";
//            [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
            self.s_DisplaySettingsArray = [NSArray arrayWithObjects:MAIN_CONTENT_TOP_BANNER_KEY,MAIN_CONTENT_TIMING_KEY,MAIN_CONTENT_BABY_GROW_KEY,MAIN_CONTENT_REMMIND_KEY,MAIN_CONTENT_DAILY_KNOWLEDGE_KEY,MAIN_CONTENT_TOOL_KEY,MAIN_CONTENT_RECOMMEND_KEY,MAIN_CONTENT_MID_BANNER_KEY, nil];
            self.s_PregnantTimingView.hidden = NO;
        }
        else
        {
//            self.navigationItem.title = @"快乐育儿";
//            [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
            self.s_DisplaySettingsArray = [NSArray arrayWithObjects:MAIN_CONTENT_TOP_BANNER_KEY,MAIN_CONTENT_TIMING_KEY,MAIN_CONTENT_BABY_GROW_KEY,MAIN_CONTENT_REMMIND_KEY,MAIN_CONTENT_DAILY_KNOWLEDGE_KEY,MAIN_CONTENT_TOOL_KEY,MAIN_CONTENT_RECOMMEND_KEY,MAIN_CONTENT_MID_BANNER_KEY, nil];
            self.s_PregnantTimingView.hidden = YES;
        }
        //删除所有数据源并更新整个页面
        [self.s_DataSourceDict removeAllObjects];
    }
    //每次都更新 topbanner midbanner和recommend
    [self updateTopBanner];
    [self updateRecommend];
    [self updateMidBanner];
    [self updateToolList];
    [self updateTimingDays];
    //由于备孕只有3个部分，所以要做更新拦截，防止不必要的更新，甚至出现crash，所以这部分的语句调用顺序要注意
    if ([BBUser getNewUserRoleState]== BBUserRoleStatePregnant || [BBUser getNewUserRoleState]== BBUserRoleStateHasBaby)
    {
//        NSInteger currentDays = [BBPregnancyInfo daysOfPregnancy];
//        //如果不是同一个日期，或者强制刷新（包括身份切换以及预产期修改），都会更新页面
//        if ((self.s_CurrentUsingDay != currentDays) || forceReload)
//        {
        [self updateBabyGrow];
        [self updateRemind];
        [self updateDailyKnowledge];
//            self.s_CurrentUsingDay = currentDays;
//        }
    }
    [self.s_ListView reloadData];
}
#pragma mark- 一些检查请求

//检查手表绑定状态
-(void)checkSmartWatchBindStatus
{
    if ([BBUser isLogin])
    {
        [self.s_WatchBindStatusRequest clearDelegatesAndCancel];
        self.s_WatchBindStatusRequest = [BBSmartRequest bindStatus];
        [self.s_WatchBindStatusRequest setDelegate:self];
        [self.s_WatchBindStatusRequest setDidFinishSelector:@selector(watchBindStatusFinish:)];
        [self.s_WatchBindStatusRequest setDidFailSelector:@selector(watchBindStatusFail:)];
        [self.s_WatchBindStatusRequest startAsynchronous];
    }
}

//检查是否有新消息
- (void)checkNewMessage
{
    if ([BBUser isLogin])
    {
        [self.s_NewMessageRequest clearDelegatesAndCancel];
        self.s_NewMessageRequest = [BBMessageRequest numberOfUnreadMessage];
        [self.s_NewMessageRequest setDelegate:self];
        [self.s_NewMessageRequest setDidFinishSelector:@selector(checkNewMessageFinished:)];
        [self.s_NewMessageRequest setDidFailSelector:@selector(checkNewMessageFail:)];
        [self.s_NewMessageRequest startAsynchronous];
    }
    else
    {
        self.s_MessageStatus = BBMessageRedPointStatusNone;
        [self showNewMessagePoint:self.s_MessageStatus];
    }
}

//检查线上和线下预产期是否一致
- (void)checkDueDateState
{
    if ([BBUser isLogin] && ([BBUser getNewUserRoleState]==BBUserRoleStatePregnant || [BBUser getNewUserRoleState]==BBUserRoleStateHasBaby))
    {
        [self.s_CheckDueDateRequest clearDelegatesAndCancel];
        self.s_CheckDueDateRequest = [BBUserRequest getUserDueDate];
        [self.s_CheckDueDateRequest setDidFinishSelector:@selector(checkDueDateFinish:)];
        [self.s_CheckDueDateRequest setDidFailSelector:@selector(checkDueDateFail:)];
        [self.s_CheckDueDateRequest setDelegate:self];
        [self.s_CheckDueDateRequest startAsynchronous];
    }
}

//同步预产期
- (void)synchronizeDueDate
{
    if ([BBUser isLogin] && [BBUser needSynchronizeDueDate] && ([BBUser getNewUserRoleState]==BBUserRoleStatePregnant || [BBUser getNewUserRoleState]==BBUserRoleStateHasBaby))
    {
        [self.s_DueDateRequest clearDelegatesAndCancel];
        self.s_DueDateRequest = [BBUserRequest modifyUserDueDate:[BBPregnancyInfo dateOfPregnancy]];
        [self.s_DueDateRequest setDidFinishSelector:@selector(synchronizeDueDateFinish:)];
        [self.s_DueDateRequest setDidFailSelector:@selector(synchronizeDueDateFail:)];
        [self.s_DueDateRequest setDelegate:self];
        [self.s_DueDateRequest startAsynchronous];
    }
}

//宝宝生日统计
-(void)synchronizeStatisticDueDate
{
    if ([BBUser needSynchronizeStatisticsDueDate])
    {
        [self.s_StatisticsDueDateRequest clearDelegatesAndCancel];
        self.s_StatisticsDueDateRequest = [BBUserRequest statisticsDueDate:[BBPregnancyInfo dateOfPregnancy]];
        [self.s_StatisticsDueDateRequest setDidFinishSelector:@selector(synchronizeStatisticsDueDateFinish:)];
        [self.s_StatisticsDueDateRequest setDidFailSelector:@selector(synchronizeStatisticsDueDateFail:)];
        [self.s_StatisticsDueDateRequest setDelegate:self];
        [self.s_StatisticsDueDateRequest startAsynchronous];
    }
}

//检测用户是否需要更新、下载新版本，加孕气请求
-(void)checkAddPreValue
{
    if ([BBUser isLogin] && [BBUser needAddPreValue])
    {
        [self.s_AddPreValueRequest clearDelegatesAndCancel];
        self.s_AddPreValueRequest = [BBMainPageRequest addPreValueRequest];
        [self.s_AddPreValueRequest setDidFinishSelector:@selector(addPreValueFinish:)];
        [self.s_AddPreValueRequest setDidFailSelector:@selector(addPreValueFail:)];
        [self.s_AddPreValueRequest setDelegate:self];
        [self.s_AddPreValueRequest startAsynchronous];
    }
}

#pragma mark- 各部分内容刷新

-(void)showNewMessagePoint:(BBMessageRedPointStatus)status
{
    if (status == BBMessageRedPointStatusNone)
    {
        self.s_MessagePointImgView.hidden = YES;
    }
    else
    {
        self.s_MessagePointImgView.hidden = NO;
    }
}
-(void)updateToolList
{
    //发请求。。。
    if (![self.s_DataSourceDict objectForKey:MAIN_CONTENT_TOOL_KEY])
    {
        //工具缓存
        //读取之前存储的布局
        NSDictionary *localActionDataDict = [BBToolOpreation getToolActionDataOfType:ToolPageTypeMain];
        //过滤不支持的type
        NSArray *localActionDataArray = [localActionDataDict arrayForKey:@"tool_list"];
        NSArray *toolsArray = [BBToolOpreation getCurrentVersionSupportedToolsArray:localActionDataArray];
        if ([toolsArray count]>0)
        {
            [self.s_DataSourceDict setObject:toolsArray forKey:MAIN_CONTENT_TOOL_KEY];
        }
        self.s_NeedRefreshTools = YES;
    }
    
    [self.s_GetMainToolsListRequest clearDelegatesAndCancel];
    self.s_GetMainToolsListRequest  = [BBToolsRequest getToolsListRequest:@"mainpage"];
    [self.s_GetMainToolsListRequest setDelegate:self];
    [self.s_GetMainToolsListRequest setDidFailSelector:@selector(getMainToolsListRequestFailed:)];
    [self.s_GetMainToolsListRequest setDidFinishSelector:@selector(getMainToolsListRequestFinished:)];
    [self.s_GetMainToolsListRequest startAsynchronous];
}
-(void)updateSignButton
{
    //增加签到button点击区域，由于需要保证图片正常尺寸显示，所以button不能设置background image,而是设置image
    //原始点击区域为36*74，目前新区域为46*78
    if([BBUser todaySignState]){
        [self.s_UserSignButton setImage:[UIImage imageNamed:@"mainPageSigned"] forState:UIControlStateNormal];
    }else{
        [self.s_UserSignButton setImage:[UIImage imageNamed:@"mainPageSign"] forState:UIControlStateNormal];
    }
}

-(void)updateTopBanner
{
    //头部banner广告数据,先读本地缓存，并发网络请求，请求回数据更新数据源和本地缓存，更新table section0
    if (![self.s_DataSourceDict objectForKey:MAIN_CONTENT_TOP_BANNER_KEY])
    {
        NSArray *topBannerArray = [BBUser bannerArray];
        if (topBannerArray != nil && [topBannerArray count]!= 0)
        {
            [self.s_DataSourceDict setObject:topBannerArray forKey:MAIN_CONTENT_TOP_BANNER_KEY];
        }
        self.s_NeedRefreshTopBanner = YES;
    }
    //发送请求，请求成功返回后 update datasource并reload
    [self.s_TopBannerRequest clearDelegatesAndCancel];
    NSString *queryId = @"1";
    if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
    {
        queryId = @"4";
    }
    else if([BBUser getNewUserRoleState] == BBUserRoleStatePregnant)
    {
        queryId = @"1";
    }
    else
    {
        queryId = @"2";
    }
    self.s_TopBannerRequest = [BBAdRequest getNewBannerAdRequestForTypeId:queryId];
    [self.s_TopBannerRequest setDidFinishSelector:@selector(topBgRequestFinish:)];
    [self.s_TopBannerRequest setDidFailSelector:@selector(topBgRequestFail:)];
    [self.s_TopBannerRequest setDelegate:self];
    [self.s_TopBannerRequest startAsynchronous];
    
}

-(void)updateTimingDays
{
    self.s_NeedRefreshTiming = YES;
    if ([BBUser getNewUserRoleState]== BBUserRoleStatePregnant)
    {
        [self.s_PregnantTimingView reload];
    }
}

-(void)updateBabyGrow
{
    //调用接口获取宝宝发育信息
    self.s_NeedRefreshBabyGrow = YES;
    BBKonwlegdeModel *growModel = [BBKonwlegdeDB babyGrowthRecordOfDay];
    if (growModel != nil)
    {
        [self.s_DataSourceDict setObject:growModel forKey:MAIN_CONTENT_BABY_GROW_KEY];
    }
    else
    {
        [self.s_DataSourceDict removeObjectForKey:MAIN_CONTENT_BABY_GROW_KEY];
    }
    
}

-(void)updateRemind
{
    //调用接口获取关爱提醒
    self.s_NeedRefreshRemind = YES;
    BBKonwlegdeModel *remindModel = [BBKonwlegdeDB remindRecordOfDay];
    if (remindModel != nil)
    {
        [self.s_DataSourceDict setObject:remindModel forKey:MAIN_CONTENT_REMMIND_KEY];
    }
    else
    {
        [self.s_DataSourceDict removeObjectForKey:MAIN_CONTENT_REMMIND_KEY];
    }

}

-(void)updateDailyKnowledge
{
    //调用接口获取每日知识
    self.s_NeedRefreshDailyKnowledge = YES;
    BBKonwlegdeModel *konwlegdeModel = [BBKonwlegdeDB knowledgeInDays];
    if (konwlegdeModel != nil)
    {
        [self.s_DataSourceDict setObject:konwlegdeModel forKey:MAIN_CONTENT_DAILY_KNOWLEDGE_KEY];
    }
    else
    {
        [self.s_DataSourceDict removeObjectForKey:MAIN_CONTENT_DAILY_KNOWLEDGE_KEY];
    }
}

-(void)updateMidBanner
{
    if (self.s_CanShowMidBanner)
    {
        if (![self.s_DataSourceDict objectForKey:MAIN_CONTENT_MID_BANNER_KEY])
        {
            NSArray *midBannerArray = [BBUser midBannerArray];
            if (midBannerArray != nil && [midBannerArray count]!= 0)
            {
                [self.s_DataSourceDict setObject:midBannerArray forKey:MAIN_CONTENT_MID_BANNER_KEY];
            }
            self.s_NeedRefreshMidBanner = YES;
        }
        //发送请求，请求成功返回后 update datasource并reload
        [self.s_MidBannerRequest clearDelegatesAndCancel];
        self.s_MidBannerRequest = [BBMainPageRequest getBannerAdvertisement];
        [self.s_MidBannerRequest setDidFinishSelector:@selector(promoRequestFinish:)];
        [self.s_MidBannerRequest setDidFailSelector:@selector(promoRequestFail:)];
        [self.s_MidBannerRequest setDelegate:self];
        [self.s_MidBannerRequest startAsynchronous];
    }
}

-(void)updateRecommend
{
    if (![self.s_DataSourceDict objectForKey:MAIN_CONTENT_RECOMMEND_KEY])
    {
        NSArray * recommendArray = [BBUser recommendTopicArray];
        if (recommendArray != nil && [recommendArray count]!= 0)
        {
            [self.s_DataSourceDict setObject:recommendArray forKey:MAIN_CONTENT_RECOMMEND_KEY];
        }
        self.s_NeedRefreshRecommend = YES;
    }
    //发送请求，请求成功返回后 update datasource并reload
    [self.s_RecommendRequest clearDelegatesAndCancel];
    self.s_RecommendRequest = [BBMainPageRequest recommendTopic];
    [self.s_RecommendRequest setDidFinishSelector:@selector(recommendTopicRequestFinish:)];
    [self.s_RecommendRequest setDidFailSelector:@selector(recommendTopicRequestFail:)];
    [self.s_RecommendRequest setDelegate:self];
    [self.s_RecommendRequest startAsynchronous];
    
}


#pragma mark- AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == PREGNANT_ALERT_VIEW_TAG)
    {
        //我怀孕啦alert
        if (buttonIndex == 1)
        {
            [self mobclickLabel:@"切换到孕期-确定按钮"];
            //确定，进入预产期设置页面
            
            if ([BBPregnancyInfo dateOfPregnancy] != nil)
            {
                //修改错误预产期
                NSDate *nowDate =[NSDate dateWithTimeInterval:86400*258 sinceDate:[NSDate date]];
                if([[BBPregnancyInfo dateOfPregnancy] compare:nowDate] == NSOrderedDescending)
                {
                    [BBPregnancyInfo setPregnancyTimeWithDueDate:nowDate];
                }
            }
            NSDate *defaultDate = [BBPregnancyInfo defaultDueDateForUserRoleState:BBUserRoleStatePregnant];
            BBDueDateViewController *dueDateViewController =[[BBDueDateViewController alloc]initWithNibName:@"BBDueDateViewController" bundle:nil];
            dueDateViewController.isInitialDueDate = YES;
            dueDateViewController.hidesBottomBarWhenPushed = YES;
            dueDateViewController.m_DefaultDateForRoleChange = defaultDate;
            [self.navigationController pushViewController:dueDateViewController animated:YES];
        }
        else
        {
            [self mobclickLabel:@"切换到孕期-取消按钮"];
        }
    }
    else if (alertView.tag == DUEDATE_ALERT_VIEW_TAG)
    {
        if (buttonIndex == 0)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *dueDate = [dateFormatter dateFromString:self.s_OnlineDueDate];
            //如果设置网络预产期，则把网络预产期立即设为本地预产期，同时设为同步本体预产期状态为YES
            [BBPregnancyInfo setPregnancyTimeWithDueDate:dueDate];
            [BBUser setNeedSynchronizeDueDate:NO];
            //[BBUser setCheckDueDateStatus:NO];
            //刷新首页显示信息
            [self refreshContentAndForceReload:YES];
            
            if ([BBUser getNewUserRoleState] == BBUserRoleStatePregnant) {
                [NoticeUtil registerBBRecallParentLocalNotification];
                [NoticeUtil registerBBCutParentLocalNotification];
            }
        }
        else
        {
            [BBUser setNeedSynchronizeDueDate:YES];
            [self synchronizeDueDate];
        }
    }
    else if (alertView.tag == kBBBabyBornRemiderTag)
    {
        if(buttonIndex == 0)
        {
            return;
        }
        else if(buttonIndex == 1) {
            [MobClick event:@"good_news_v2" label:@"报喜弹层-切换到快乐育儿"];
            NSDate *defaultDate = [BBPregnancyInfo defaultDueDateForUserRoleState:BBUserRoleStateHasBaby];
            YBBDateSelect *modifyDueDate = [[YBBDateSelect alloc] initWithNibName:@"YBBDateSelect" bundle:nil];
            modifyDueDate.m_DefaultDateForRoleChange = defaultDate;
            modifyDueDate.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:modifyDueDate animated:YES];
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
                BBBabyBornViewController *babyBornViewController = [[BBBabyBornViewController alloc] init];
                babyBornViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:babyBornViewController animated:YES];
            }
            
        }
    }

}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSArray *array = alertView.subviews;
    NSLog(@"arrar %@",array);
    return YES;
}

#pragma mark- Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            UMFeedbackChat *feedbackCtl = [[UMFeedbackChat alloc]initWithNibName:@"UMFeedbackChat" bundle:nil];
            feedbackCtl.title = @"账户被禁用反馈";
            feedbackCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feedbackCtl animated:YES];
            
        }
            
            break;
        case 1:
        {
            if([BBUser isLogin])
            {
                [HMShowPage showBabyBoxFeedBackTopic:self];
            }
            else
            {
                [self presentLoginWithLoginType:LoginFeedback];
            }
        }
            
            break;
        case 2: {
            UMFeedbackChat *feedbackCtl = [[UMFeedbackChat alloc]initWithNibName:@"UMFeedbackChat" bundle:nil];
            feedbackCtl.title = @"建议反馈";
            feedbackCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feedbackCtl animated:YES];
            
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark- 手表绑定状态请求返回

- (void)watchBindStatusFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"]) {
        
        NSString *bluetoothMac = [[data dictionaryForKey:@"data"] stringForKey:@"bluetooth_mac"];
        if ([bluetoothMac isEqualToString:@""]) {
            bluetoothMac = nil;
        }
        if ([BBUser smartWatchCode] == nil && bluetoothMac != nil) {
            [BBUser setSmartWatchCode:bluetoothMac];
        }else if([BBUser smartWatchCode] != nil && bluetoothMac == nil){
            [BBUser setSmartWatchCode:nil];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您的账号已经在其他设备上与手表解绑" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)watchBindStatusFail:(ASIFormDataRequest *)request
{
    
}


#pragma mark- 检查预产期请求返回

- (void)checkDueDateFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[jsonDictionary stringForKey:@"status"] isEqualToString:@"success"])
    {
        //[BBUser setBabyBirthday:[NSString stringWithFormat:@"%0.f", [[YBBBabyDateInfo babyBornDate] timeIntervalSince1970]]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *localDueDate = [dateFormatter stringFromDate:[BBPregnancyInfo dateOfPregnancy]];
        NSString *onlineDueDate = [[jsonDictionary dictionaryForKey:@"data"]stringForKey:@"babybirthday"];
        if (![localDueDate isEqualToString:onlineDueDate] )
        {
            //如果网络没有设置预产期，直接以本体为准设置同步本体预产期，同时设为同步本体预产期状态为YES
            if ([onlineDueDate isEqualToString:@""] || onlineDueDate==nil)
            {
                [BBUser setNeedSynchronizeDueDate:YES];
                [self synchronizeDueDate];
            }
            else
            {
                if ([onlineDueDate isEqualToString:@"1970-01-01"] || [onlineDueDate isEqualToString:@"2100-01-01"])
                {
                    [BBUser setNeedSynchronizeDueDate:YES];
                    [self synchronizeDueDate];
                }
                else
                {
                    NSString *message = @"检测到您网络上的预产期和本地的预产期不一致，请您确认";
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:onlineDueDate otherButtonTitles:localDueDate,nil];
                    alertView.tag = DUEDATE_ALERT_VIEW_TAG;
                    self.s_OnlineDueDate = onlineDueDate;
                    [alertView show];
                }
            }
        }
    }
}

- (void)checkDueDateFail:(ASIFormDataRequest *)request
{
    
}


#pragma mark- 同步预产期请求返回

- (void)synchronizeDueDateFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[jsonDictionary stringForKey:@"status"] isEqualToString:@"success"]) {
        [BBUser setNeedSynchronizeDueDate:NO];
//        [BBUser setCheckDueDateStatus:NO];
//        [BBUser setBabyBirthday:[NSString stringWithFormat:@"%0.f", [[BBPregnancyInfo dateOfPregnancy] timeIntervalSince1970]]];
        if ([BBUser getNewUserRoleState] == BBUserRoleStatePregnant) {
            [NoticeUtil registerBBRecallParentLocalNotification];
            [NoticeUtil registerBBCutParentLocalNotification];
        }
    }
}

- (void)synchronizeDueDateFail:(ASIFormDataRequest *)request
{
    
}

#pragma mark- 统计宝宝生日请求返回

- (void)synchronizeStatisticsDueDateFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[jsonDictionary objectForKey:@"status"] isEqualToString:@"success"]) {
        [BBUser setNeedSynchronizeStatisticsDueDate:NO];
    }
}

- (void)synchronizeStatisticsDueDateFail:(ASIFormDataRequest *)request
{
    
}

#pragma mark- 检查新消息请求返回

- (void)checkNewMessageFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    NSString *status = [data stringForKey:@"status"];
    if (error == nil)
    {
        if ([status isEqualToString:@"success"])
        {
            NSDictionary *realData = [data dictionaryForKey:@"data"];
            NSDictionary *unread_message_count = [realData dictionaryForKey:@"unread_message_count"];
            NSInteger unreadSiXinCount = [[realData stringForKey:@"user_unread_count"] integerValue];
            NSInteger unreadTongZhiCount = [[realData stringForKey:@"user_comment_reply_unread_count"] integerValue];
            NSInteger lastUnreadSiXinCount = [BBUser getUserUnreadSiXinCount];
            NSInteger lastUnreadTongZhiCount = [BBUser getUserUnreadTongZhiCount];
            NSInteger newEventCount = [[unread_message_count stringForKey:@"event"]integerValue];
            if (self.s_MessageStatus == BBMessageRedPointStatusNone)
            {
                BBMessageRedPointStatus tmpStatus = BBMessageRedPointStatusNone;
                if (newEventCount >0)
                {
                    tmpStatus |= BBMessageRedPointStatusFeed;
                }
                if (unreadSiXinCount!=lastUnreadSiXinCount && (unreadSiXinCount+unreadTongZhiCount>0))
                {
                    tmpStatus |= BBMessageRedPointStatusMessage;
                }
                if(unreadTongZhiCount!=lastUnreadTongZhiCount && (unreadSiXinCount+unreadTongZhiCount>0))
                {
                    tmpStatus |= BBMessageRedPointStatusNotification;
                }
                self.s_MessageStatus = tmpStatus;
            }
            [self showNewMessagePoint:self.s_MessageStatus];
            [BBUser setUserUnreadSiXinCount:unreadSiXinCount];
            [BBUser setUserUnreadTongZhiCount:lastUnreadTongZhiCount+unreadTongZhiCount];
            
            
            NSInteger followerCount = [[unread_message_count stringForKey:@"follower"] integerValue];
            NSInteger oldFollowerCount = [BBUser getUserNewFansCount];
            if (followerCount > oldFollowerCount)
            {
                [ApplicationDelegate.m_mainTabbar showTipPointWithIndex:MAIN_TAB_INDEX_PERSONCENTER];
            }
            [BBUser setUserNewFansCount:followerCount];
            
        }
        else if([status isEqualToString:@"301"] || [status isEqualToString:@"nonLogin"])
        {
            [BBUser logout];
            [BBPregnancyInfo setNotiCount:0];
            
            //删除第三方登陆的token
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQQ completion:^(UMSocialResponseEntity *response) {
            }];
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToWechatTimeline completion:^(UMSocialResponseEntity *response) {
            }];
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToWechatSession completion:^(UMSocialResponseEntity *response) {
            }];
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina completion:^(UMSocialResponseEntity *response) {
            }];
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToTencent completion:^(UMSocialResponseEntity *response) {
            }];
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQzone completion:^(UMSocialResponseEntity *response) {
            }];
            
            [BBRemotePushInfo setIsRegisterPushToBabytree:YES];
            BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate updatePushToken];
            [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您在网站上修改过密码，请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)checkNewMessageFail:(ASIHTTPRequest *)request
{
    
}


#pragma mark- 获取宝宝树推荐请求返回

- (void)recommendTopicRequestFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"]) {
        NSArray *originList = [[data dictionaryForKey:@"data"]arrayForKey:@"recommend_list"];
        NSArray *list = nil;
        if ([originList isKindOfClass:[NSArray class]] && [originList count]>0)
        {
            list = [[originList objectAtIndex:0]arrayForKey:@"list"];
            if ([list isKindOfClass:[NSArray class]] && [list count]>0) {
                NSArray *originData = [self.s_DataSourceDict objectForKey:MAIN_CONTENT_RECOMMEND_KEY];
                if(originData == nil || ![originData isEqualToArray:list])
                {
                    [self.s_DataSourceDict setObject:list forKey:MAIN_CONTENT_RECOMMEND_KEY];
                    self.s_NeedRefreshRecommend = YES;
                    [self.s_ListView reloadData];

                }
                [BBUser setRecommendTopicArray:list];
            }
        }
    }
}

- (void)recommendTopicRequestFail:(ASIFormDataRequest *)request
{
    
}


#pragma mark- 获取顶部Banner数据请求返回

- (void)topBgRequestFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"])
    {
        if ([[data arrayForKey:@"data"] count] >0)
        {
            NSArray *originData = [self.s_DataSourceDict objectForKey:MAIN_CONTENT_TOP_BANNER_KEY];
            NSArray *list = [data arrayForKey:@"data"];
            if ([list isKindOfClass:[NSArray class]] && [list count]>0)
            {
                if(originData == nil || ![originData isEqualToArray:list])
                {
                    [self.s_DataSourceDict setObject:list forKey:MAIN_CONTENT_TOP_BANNER_KEY];
                    self.s_NeedRefreshTopBanner = YES;
                    [self.s_ListView reloadData];
                }
                [BBUser setBannerArray:list];
            }
        }
    }
}

- (void)topBgRequestFail:(ASIFormDataRequest *)request
{
    
}


#pragma mark- 获取首页工具请求返回

- (void)getMainToolsListRequestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *responseData = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[responseData stringForKey:@"status"] isEqualToString:@"success"])
    {
        //数据返回
        NSDictionary *data = [responseData dictionaryForKey:@"data"];
        NSArray *tempArray = [data arrayForKey:@"tool_list"];
        if (tempArray == nil || [tempArray count] == 0)
        {
            return;
        }
        NSArray *tempTools = [BBToolOpreation getCurrentVersionSupportedToolsArray:tempArray];
        NSArray *originData = [self.s_DataSourceDict objectForKey:MAIN_CONTENT_TOOL_KEY];
        if ([tempTools isKindOfClass:[NSArray class]] && [tempTools count]>0)
        {
            if(originData == nil || ![originData isEqualToArray:tempTools])
            {
                [self.s_DataSourceDict setObject:tempTools forKey:MAIN_CONTENT_TOOL_KEY];
                self.s_NeedRefreshTools = YES;
                [self.s_ListView reloadData];
            }
            [BBToolOpreation setToolActionData:data ofType:ToolPageTypeMain];
        }
    }
    else
    {
        //[AlertUtil showAlert:@"提示！" withMessage:@"亲，您的网络不给力！"];
    }
}

- (void)getMainToolsListRequestFailed:(ASIFormDataRequest *)request
{
    //[AlertUtil showAlert:@"提示！" withMessage:@"亲，您的网络不给力！"];
}


#pragma mark- 中间广告数据请求返回

- (void)promoRequestFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"])
    {
        
        if ([[data arrayForKey:@"data"] count] > 0)
        {
            NSArray *originData = [self.s_DataSourceDict objectForKey:MAIN_CONTENT_TOP_BANNER_KEY];
            if(originData == nil || ![originData isEqualToArray:[data arrayForKey:@"data"]])
            {
                [self.s_DataSourceDict setObject:[data arrayForKey:@"data"] forKey:MAIN_CONTENT_MID_BANNER_KEY];
                self.s_NeedRefreshMidBanner = YES;
                [self.s_ListView reloadData];
            }
            [BBUser setMidBannerArray:[data arrayForKey:@"data"]];
        }
    }
}

- (void)promoRequestFail:(ASIFormDataRequest *)request
{
    
}

#pragma mark- 登录及登录成功返回

-(void)presentLoginWithLoginType:(LoginType)type
{
    BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
    login.m_LoginType = BBPresentLogin;
    BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
    [navCtrl setColorWithImageName:@"navigationBg"];
    self.s_LoginType = type;
    login.delegate = self;
    [self.navigationController  presentViewController:navCtrl animated:YES completion:^{
        
    }];
}

- (void)loginFinish
{
    if (self.s_LoginType==LoginMessage)
    {
        BBMessageList *messageList = [[BBMessageList alloc] initWithNibName:@"BBMessageList" bundle:nil];
        messageList.m_MessageRedPointStatus = self.s_MessageStatus;
        self.s_MessageStatus = BBMessageRedPointStatusNone;
        [self showNewMessagePoint:self.s_MessageStatus];
        messageList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messageList animated:YES];
    }
    else if (self.s_LoginType==LoginSign)
    {
        BBSign *bbSign = [[BBSign alloc]initWithNibName:@"BBSign" bundle:nil];
        bbSign.m_SignType = BBPushSign;
        bbSign.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bbSign animated:YES];
    }
    else if (self.s_LoginType==LoginFeedback)
    {
        [HMShowPage showBabyBoxFeedBackTopic:self];
    }
    else if (self.s_LoginType == LoginBabyBorn)
    {
        BBBabyBornViewController *babyBornViewController = [[BBBabyBornViewController alloc] init];
        babyBornViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:babyBornViewController animated:YES];
    }

}

#pragma mark- 更新 下载新版本加孕气请求返回

- (void)addPreValueFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"])
    {
        [BBUser setNeedAddPreValue:NO];
        [MobClick event:@"preValue_v2" label:@"送孕气弹框次数"];
        NSString *title = @"";
        NSString *message = [NSString stringWithFormat:@"%@\n%@\n%@\n\n%@%@",@"亲爱的，",@"感谢你参与“下载新版本，孕",@"气大放送”活动。",@"99孕气",[data stringForKey:@"message"]];
        AHAlertView *alert = [[AHAlertView alloc] initWithTitle:title message:message];
        
        [alert setBackgroundImage:[UIImage imageNamed:@"mainPagePreValueBg"]];
        [alert setCancelButtonBackgroundImage:[UIImage imageNamed:@"mainPagePreValueCloseNomal"] forState:UIControlStateNormal];
        [alert setCancelButtonBackgroundImage:[UIImage imageNamed:@"mainPagePreValueClosePressed"] forState:UIControlStateHighlighted];
        [alert setButtonBackgroundImage:[UIImage imageNamed:@"mainPagePreValueSignNomal"] forState:UIControlStateNormal];
        [alert setButtonBackgroundImage:[UIImage imageNamed:@"mainPagePreValueSignPressed"] forState:UIControlStateHighlighted];
        
        [alert setCancelButtonTitle:@"关闭" block:^{
            return ;
        }];
        [alert addButtonWithTitle:@"查看孕气值" block:^{
            // 签到页面
            BBSign *bbSign = [[BBSign alloc]initWithNibName:@"BBSign" bundle:nil];
            bbSign.m_SignType = BBPresentSign;
            
            BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:bbSign];
            [navCtrl setColorWithImageName:@"navigationBg"];
            BBAppDelegate *appDelegate = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
            UIViewController *vc = [appDelegate.m_mainTabbar getViewControllerAtIndex:appDelegate.m_mainTabbar.selectedIndex];
            [vc viewWillDisappear:NO];
            [vc.navigationController setNavigationBarHidden:NO];
            [vc.navigationController  presentViewController:navCtrl animated:YES completion:^{
                
            }];
            
        }];
        [alert show];
        
    }
    else if([[data stringForKey:@"status"] isEqualToString:@"already_add"])
    {
        [BBUser setNeedAddPreValue:NO];
        [self checkDueDateState];
    }
    else
    {
        [self checkDueDateState];
    }
}

- (void)addPreValueFail:(ASIFormDataRequest *)request
{
    
}

#pragma mark - 感动页面请求
- (void)showMovedPage
{
    [MobClick event:@"feeling_v2" label:@"感动页pv"];
    self.movedWebView = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    self.movedWebView.isShowCloseButton = NO;
    // 感动页url
    NSString *url = [NSString stringWithFormat:@"%@/app/yunqi/gandong.php?enc_user_id=%@&photo_id=%@",BABYTREE_URL_SERVER,[BBUser getEncId],[BBUser getMovedPagePhotoID]];
    NSLog(@"moved %@",url);
    [self.movedWebView setLoadURL:url];
    self.movedWebView.hidesBottomBarWhenPushed = YES;
    [self presentViewController:self.movedWebView animated:YES completion:^{
        
    }];
}
@end
