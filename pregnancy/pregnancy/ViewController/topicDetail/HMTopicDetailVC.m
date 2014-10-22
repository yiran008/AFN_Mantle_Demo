//
//  HMTopicDetailVC.m
//  lama
//
//  Created by songxf on 13-12-25.
//  Copyright (c) 2013年 babytree. All rights reserved.
//
//
//  HMNewTopicDetailViewController.m
//  lama
//
//  Created by mac on 13-7-29.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMTopicDetailVC.h"
#import "HMNavigation.h"
#import "BBAppDelegate.h"
//#import "HMHotMomTabBar.h"
#import "HMApiRequest.h"
#import "HMTopicDetailCellClass.h"
#import "HMTopicDetailCell.h"
#import "HMTopicDetailCellReplyView.h"
#import "BBAppInfo.h"
#import "UMSocial.h"
#import "BBImageScale.h"
#import "HMShowPage.h"
#import "UIImageView+WebCache.h"
//#import "HMShadeGuideControl.h"
#import "HMTopicDetailCellImageView.h"
#import "HMReportVC.h"
#import "ARCHelper.h"
#import "BBShareContent.h"
#import "BBAdPVManager.h"
#import "BBSupportTopicDetail.h"

#import "BBTopicDetailLocationDB.h"
#import "BBTopicHistoryDB.h"

#define TOPIC_SHARE_URL_PAGE(id) [NSString stringWithFormat:@"%@/community/topic_mobile.php?id=%@&pg=1", BABYTREE_URL_SERVER, id]

@interface HMTopicDetailVC ()
<
    BBLoginDelegate
>
{
    //BOOL _showbar;
    BOOL _isBarShow;
    CGFloat _lastY;
    
    BBShareMenu *s_ShareMenu;

    UIView *s_StatusBarBakView;
}
@property (nonatomic, retain) NSMutableArray *m_ShareData;
@property (nonatomic, retain) UIImageView *m_ShareImage;
@property (nonatomic, retain) NSString *m_ShareContent;

// 浏览图所在位置
@property (assign, nonatomic) NSInteger m_PicRow;

@property (assign, nonatomic) LoginType s_LoginType;

//标记所选actionSheet项
@property (retain, nonatomic) UIActionSheet *m_actionSheet;
@property (assign, nonatomic) NSInteger m_buttonIndex;

//广告数据
@property (retain, nonatomic) NSDictionary *m_ADData;

@property (nonatomic,strong) NSString *s_UserRank;
@end

@implementation HMTopicDetailVC

@synthesize isPopReply;
@synthesize m_IsLoved;
@synthesize m_TopicTitleView;
@synthesize m_TopicTitleCircleBgView;
@synthesize m_TopicTitleCircleLabel;
@synthesize m_TopicTitleCircleControl;
@synthesize m_TopicTitleStyledLabel;
@synthesize m_TopicTableView;

@synthesize m_ProgressHUD;

@synthesize m_TopicDataRequest;
@synthesize m_DelTopicRequest;
@synthesize m_CollectTopicRequest;

@synthesize m_TopicDataList;

@synthesize m_PicsList;

@synthesize m_IsShowAll;
@synthesize m_IsCollected;
@synthesize m_IsReply;
@synthesize m_ReplyFloor;

@synthesize m_CurrentPage;
@synthesize m_PageCount;

@synthesize m_TopicID;
@synthesize m_TopicTitle;
@synthesize m_CircleID;
@synthesize m_CircleName;
@synthesize m_AddCircleStatus;
@synthesize m_MasterID;
@synthesize m_MasterName;

@synthesize m_IsHelp;
@synthesize m_IsBest;
@synthesize m_WebUrl;
@synthesize m_ShareUrl;

@synthesize m_BottomView;
@synthesize m_ReplyView;

@synthesize m_ShareData;
@synthesize m_ShareImage;
@synthesize m_ShareContent;

@synthesize m_PositionFloor;
@synthesize m_ReplyID;
@synthesize m_ShowPositionError;

@synthesize m_PicRow;

#pragma mark -
#pragma mark view func


- (void)dealloc
{
    // 保存浏览记录
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(freshBottom_refresh) object:nil];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showstoreEvaluateView) object:nil];

    if (s_ShareMenu)
    {
        s_ShareMenu.delegate = nil;
    }

    if (m_ReplyView.superview)
    {
        [m_ReplyView removeFromSuperview];
    }
    
    m_ReplyView.delegate = nil;
    [m_ReplyView ah_release];
    m_BottomView.delegate = nil;
    [m_BottomView ah_release];

    [m_TopicDataRequest clearDelegatesAndCancel];
    [m_TopicDataRequest ah_release];
    [m_DelTopicRequest clearDelegatesAndCancel];
    [m_DelTopicRequest ah_release];
    [m_CollectTopicRequest clearDelegatesAndCancel];
    [m_CollectTopicRequest ah_release];
    
    [m_TopicTitleView ah_release];
    [m_TopicTitleCircleBgView ah_release];
    [m_TopicTitleCircleLabel ah_release];
    [_m_TopicViewCountLabel ah_release];
    [_m_TopicReplyCountLabel ah_release];
    [_m_ViewCount ah_release];
    [_m_ReplyCount ah_release];
    [_m_IsNewImageView ah_release];
    [m_TopicTitleCircleControl ah_release];
    [m_TopicTableView ah_release];
    
    [m_ProgressHUD ah_release];
    
    [m_TopicDataList ah_release];
    
    [m_PicsList ah_release];
    
    [m_TopicID ah_release];
    [m_TopicTitle ah_release];
    [m_CircleID ah_release];
    [m_CircleName ah_release];
    [m_MasterID ah_release];
    [m_MasterName ah_release];
    
    [m_CurrentPage ah_release];
    [m_PageCount ah_release];
    
    [m_WebUrl ah_release];
    [m_ShareUrl ah_release];
    
    [m_TopicTitleStyledLabel ah_release];
    
    [m_ShareData ah_release];
    [m_ShareImage ah_release];
    [m_ShareContent ah_release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DIDCHANGE_PERSON_COLLECT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];
    
    [_m_IsBestImageView ah_release];
    [_m_IsHelpImageView ah_release];

    [_m_IsTopImageView ah_release];
    
    [_m_ADData ah_release];
    
    [super ah_dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTopicID:(NSString *)topicID topicTitle:(NSString *)topicTitle isTop:(BOOL)isTop isBest:(BOOL)isBest
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCollectState:) name:DIDCHANGE_PERSON_COLLECT object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshAllTopicData) name:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];
        
        // Custom initialization
        self.m_IsShowAll = YES;
        self.m_IsCollected = NO;
        self.m_IsReply = NO;
        self.m_ShowPositionError = NO;
        
        self.m_CurrentPage = @"1";
        self.m_PageCount = @"1";
        
        self.m_TopicID = topicID;//@"7785010";
        
        if ([topicTitle isNotEmpty])
        {
            self.m_TopicTitle = topicTitle;
        }
        else
        {
            self.m_TopicTitle = @"";
        }
        
//        self.m_IsTop = isTop;
        self.m_IsBest = isBest;
        
        [self makeShareData];
    }
    
    return self;
}


- (void)viewDidLoad
{
//    self.umeng_VCname = @"帖子详情页面";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:NO];
    _isBarShow = YES;

    self.m_PicRow = -1;
    
//    NSInteger appTimes = 0;//[BBUser getOpenAppTimes];
    
    // 不是倍数时，更新打开次数
//    if ((appTimes % DEFAULT_OPENAPPCHECK) != 0)
//    {
//        BBAppDelegate *appdelegate = (BBAppDelegate*)[[UIApplication sharedApplication] delegate];
//        [appdelegate saveOpenAppTimes];
//    }
    
//    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"topicdetail_navi_menu_icon", NAV_RIGHTBTN_IMAGE_KEY, @"topicMenuClicked:", NAV_RIGHTBTN_SELECTOR_KEY, nil];
//    
//    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"shareBarButton", NAV_RIGHTBTN_IMAGE_KEY, @"topicShareClicked:", NAV_RIGHTBTN_SELECTOR_KEY, nil];
//    
//    NSArray *array = [NSArray arrayWithObjects: dic2, dic3, nil];
//    
//    [self setNavBar:@"帖子详情" bgColor:Nil leftTitle:nil leftBtnImage:@"backButton" leftToucheEvent:@selector(backAction:) rightDicArray:array];
    
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"帖子详情" withWidth:100]];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton ah_release];
    
    if (!self.navigationItem.rightBarButtonItems) {
        [self setNavigationRightButton];
    }
    
    m_TopicTableView.height = UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - BOTTOM_VIEW_HEGHT;

    //初始化下拉视图
    if (s_refresh_header_view == nil)
    {
        EGORefreshTableHeaderView *pullDownView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0, -m_TopicTableView.height, m_TopicTableView.width, m_TopicTableView.height)];
        pullDownView.delegate = self;
        s_refresh_header_view.refreshStatus = YES;
        [pullDownView refreshLastUpdatedLabel:YES];
        [m_TopicTableView addSubview:pullDownView];
        s_refresh_header_view = pullDownView;
        [pullDownView ah_release];
        pullDownView.backgroundColor = [UIColor clearColor];
//        s_refresh_header_view.isNotShowDate = YES;
        s_refresh_header_view.topicDetailPage = @"下拉刷新";
        s_refresh_header_view.topicDetailStatus = @"松手刷新";
        [s_refresh_header_view refreshLastUpdatedLabel:YES];
    }
    //初始化上拉视图
    if (s_refresh_bottom_view == nil)
    {
        EGORefreshPullUpTableHeaderView *pullUpView = [[EGORefreshPullUpTableHeaderView alloc] initWithFrame: CGRectMake(0.0, m_TopicTableView.height, m_TopicTableView.width, m_TopicTableView.height)];
        pullUpView.delegate = self;
        s_refresh_bottom_view.refreshStatus = YES;
        [pullUpView refreshPullUpLastUpdatedLabel:YES];
        [m_TopicTableView addSubview:pullUpView];
        s_refresh_bottom_view = pullUpView;
//        s_refresh_bottom_view.isNotShowDate = YES;
        [pullUpView ah_release];
        pullUpView.backgroundColor = [UIColor clearColor];
    }
    
    m_TopicTitleStyledLabel.hidden = YES;
    
    m_TopicTableView.dataSource = self;
    m_TopicTableView.delegate = self;
    [m_TopicTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if (!m_TopicDataList)
    {
        self.m_TopicDataList = [[[NSMutableArray alloc] initWithCapacity:0] ah_autorelease];
    }
    
    self.m_BottomView = [[[HMTopicDetailBottomView alloc] initWithTop:UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - BOTTOM_VIEW_HEGHT] ah_autorelease];
    m_BottomView.m_maxPageNumber = 1;
    m_BottomView.delegate = self;
    [self.view addSubview:m_BottomView];
    
    if (!self.m_ReplyView.superview)
    {
        self.m_ReplyView = [[[HMReplyTopicView alloc] init] ah_autorelease];
        [self.navigationController.view addSubview:m_ReplyView];
        m_ReplyView.delegate = self;
        m_ReplyView.topicID = self.m_TopicID;
        [m_ReplyView hide];
    }
    
    if(self.m_IsFromExpertOnline)
    {
        m_ReplyView.m_IsFromExpertOnline = YES;
    }
    
    UISwipeGestureRecognizer *recognizer= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backAction:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.m_TopicTableView addGestureRecognizer:recognizer];
    [recognizer ah_release];
    
    s_NoDataView = [[[HMNoDataView alloc] initWithType:HMNODATAVIEW_NETERROR] ah_autorelease];
    s_NoDataView.delegate = self;
    s_NoDataView.hidden = YES;
    [self.view addSubview:s_NoDataView];

    if (IOS_VERSION >= 7.0)
    {
        s_StatusBarBakView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_STATUS_BAR_HEIGHT)] ah_autorelease];
        s_StatusBarBakView.backgroundColor = UI_NAVIGATION_BGCOLOR;
        s_StatusBarBakView.alpha = 0.0;
        [self.view addSubview:s_StatusBarBakView];
    }
    else
    {
        s_StatusBarBakView = nil;
    }

    self.m_PicsList = [NSMutableArray arrayWithCapacity:0];
    //[self rollTopicData];


    // 读取阅读记录
    if (![self.m_ReplyID isNotEmpty] && m_PositionFloor == 0)
    {
        self.m_ShowPositionError = NO;
        
        BBTopicDetailLocation *tdl = [BBTopicDetailLocationDB getTopicDetailLocationDB:self.m_TopicID];
        if (tdl)
        {
            self.m_PositionFloor = tdl.m_Topic_Floor;
            self.m_ReplyID = tdl.m_Topic_FloorID;
            self.m_IsShowAll = tdl.m_IsShowAll;
        }
    }

    self.m_ProgressHUD = [[[MBProgressHUD alloc] initWithView:self.view] ah_autorelease];
    [self.view addSubview:m_ProgressHUD];
    //    s_isRollTopicData = NO;
    [self freshTopicData:0];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goAdWebPage) name:TOPICDETAIL_AD_TAP object:nil];
}

-(void)setNavigationRightButton
{
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setFrame:CGRectMake(0, 0, 40, 30)];
    [commitButton setImage:[UIImage imageNamed:@"nav_more"] forState:UIControlStateNormal];
    [commitButton setImage:[UIImage imageNamed:@"nav_more_pressed"] forState:UIControlStateHighlighted];
    [commitButton addTarget:self action:@selector(topicMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
    commitButton.exclusiveTouch = YES;
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.exclusiveTouch = YES;
    [shareButton setFrame:CGRectMake(0, 0, 40, 30)];
    [shareButton setImage:[UIImage imageNamed:@"shareBarButton"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"shareBarButtonPressed"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(topicShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    UIBarButtonItem *shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItems = @[commitBarButton,shareBarButton];
}


- (void)changeCollectState:(NSNotification *)notify
{
    NSDictionary *data = notify.object;
    NSString *topicId = [data stringForKey:@"topic_id"];
    if ([self.m_TopicID isEqualToString:topicId])
    {
        BOOL state = [data boolForKey:@"collect_state"];
        m_IsCollected = state;
    }
}

- (void)freshAllTopicData
{
    [self freshTopicData:0];
}

- (void)rollTopicData
{
    s_reloading = YES;
    s_isRollTopicData = YES;
    
    CGPoint point = CGPointMake(0, 0);
    m_TopicTableView.contentOffset = point;
    
    [UIView beginAnimations:@"reloadData" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.4];
    
    point = CGPointMake(0, -60);
    m_TopicTableView.contentOffset = point;
    if (s_refresh_header_view != nil)
    {
//        [s_refresh_header_view setLoadingState];
    }
    
    [UIView setAnimationDidStopSelector:@selector(freshAllTopicData)];
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [MobClick event:@"discuz_v2" label:@"帖子详情页pv"];
    if ([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
    {
        [MobClick event:@"discuz_v2" label:@"帖子详情页pv-育儿"];
    }
    else if([BBUser getNewUserRoleState] == BBUserRoleStatePregnant)
    {
        [MobClick event:@"discuz_v2" label:@"帖子详情页pv-孕期"];
    }
    else
    {
        [MobClick event:@"discuz_v2" label:@"帖子详情页pv-备孕"];
    }
    
    [super viewWillAppear:animated];
    [ApplicationDelegate checkDisplayOperateGuide:ENABLE_SHOW_TOPIC_PAGE];
    if (isPopReply)
    {
        [self openReplyMaster];
        
        isPopReply = NO;
    }
    
//    [HMShadeGuideControl controlWithEyeshield];

    if (self.m_PicRow != -1)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.m_PicRow inSection:0];

        s_PositionToFloor = YES;
        [m_TopicTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

        self.m_PicRow = -1;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [ApplicationDelegate clickGuideImageAction];
    
    // 显示toolBar
    [self showBar:NO];
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showstoreEvaluateView) object:nil];
    
//    [self storeEvaluateViewClose];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)m_PositionFloor
{
    return m_PositionFloor;
}

- (void)setM_PositionFloor:(NSInteger)positionFloor
{
    if (positionFloor == 0)
    {
        return;
    }
    
    s_PositionToFloor = YES;
    
    m_PositionFloor = positionFloor;

    self.m_CurrentPage = [NSString stringWithFormat:@"%ld", (long)(m_PositionFloor+20-1)/20];
}

- (NSString *)m_ReplyID
{
    return m_ReplyID;
}

- (void)setM_ReplyID:(NSString *)replyID
{
    if (![replyID isNotEmpty])
    {
        s_PositionToFloor = NO;
        m_ReplyID = nil;
    }
    else
    {
        if (![m_ReplyID isEqual:replyID])
        {
            s_PositionToFloor = YES;
            m_ReplyID = replyID;
        }
    }

    //self.m_CurrentPage = [NSString stringWithFormat:@"%ld", (long)(m_PositionFloor+20-1)/20];
}

- (void)adClicked:(NSString *)adUrl title:(NSString *)adTitle
{
    if ([adUrl isNotEmpty])
    {
        BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
        [exteriorURL setLoadURL:adUrl];
        [exteriorURL setTitle:adTitle];

        [self.navigationController pushViewController:exteriorURL animated:YES];
    }
}

#pragma mark -
#pragma mark navigation btn actions

// 返回
- (IBAction)backAction:(id)sender
{
    if ([m_ReplyView isAnyReplyCached])
    {
        [PXAlertView showAlertWithTitle:@"您还有未发布的内容，是否返回" message:nil cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex)
         {
             if (!cancelled)
             {
                 [self goBack];
             }
         }];
        
        return;
    }

    if (m_ReplyView)
    {
        [m_ReplyView closeView];
    }
    
    [self goBack];
}

- (void)goBack
{
    BBTopicDetailLocation *tdl = [[BBTopicDetailLocation alloc] init];
    BBTopicHistoryModel *historyModel = [[BBTopicHistoryModel alloc]init];
    
    if (tdl)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time = [date timeIntervalSince1970];
        tdl.m_AddTime = [NSString stringWithFormat:@"%.0f", time];
        tdl.m_Topic_ID = m_TopicID;
        tdl.m_IsShowAll = m_IsShowAll;
        
        historyModel.m_AddTime = tdl.m_AddTime;
        historyModel.m_TopicID = tdl.m_Topic_ID;
        historyModel.m_IsShowAll = tdl.m_IsShowAll;
        
        NSArray *cellArray = m_TopicTableView.visibleCells;
        if ([m_TopicID isNotEmpty] && [cellArray isNotEmpty])
        {
            HMTopicDetailCell *cell = nil;
            
            if (cellArray.count >= 3)
            {
                cell = cellArray[2];
            }
            else
            {
                cell = cellArray[0];
            }
            tdl.m_Topic_Floor = [cell.m_CellView.m_TopicDetail.m_TopicInfor.m_Floor integerValue];
            tdl.m_Topic_FloorID = cell.m_CellView.m_TopicDetail.m_TopicInfor.m_ReplyID;
            
            historyModel.m_TopicFloor = tdl.m_Topic_Floor;
            historyModel.m_TopicFloorID = tdl.m_Topic_FloorID;
            historyModel.m_TopicTitle = self.m_TopicTitle;
            historyModel.m_PosterID = self.m_MasterID;
            historyModel.m_PosterName = self.m_MasterName;
            
            [BBTopicDetailLocationDB insertAndUpdateTopicDetailLacationData:tdl];
            [BBTopicHistoryDB insertTopicHistoryModel:historyModel];
        }
    }

    if (self.presentingViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 点击更多按钮
- (void)topicMenuClicked:(id)sender
{
    NSString *str1 = @"只看楼主";
    if (!m_IsShowAll)
    {
        str1 = @"查看全部";
    }
    NSString *str2 = @"收藏帖子";
    if (m_IsCollected)
    {
        str2 = @"取消收藏";
    }
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: str1, str2, @"举报主帖", @"复制链接", nil] ah_autorelease];
        [actionSheet setTag:12];
    [actionSheet showInView:self.view];
}

// 点击只看楼主或者全部信息
- (void)topicTypeClicked
{
//    if (m_IsShowAll)
//    {
//    }
//    else
//    {
//    }
    
    [self.m_BottomView hideHMTDSliderView];
    
    
    s_ShowTypeSwitch = YES;
    
    [m_TopicDataRequest clearDelegatesAndCancel];
    if (!m_IsShowAll)
    {
        self.m_TopicDataRequest = [HMApiRequest requestNewTopicDetail:m_TopicID  withCurentPage:@"1" orReplyId:nil withIsUserType:@"0"];
    }
    else
    {
        self.m_TopicDataRequest = [HMApiRequest requestNewTopicDetail:m_TopicID  withCurentPage:@"1" orReplyId:nil withIsUserType:@"1"];
    }

    [m_TopicDataRequest setDelegate:self];
    [m_TopicDataRequest setDidFinishSelector:@selector(freshTopicFinished:)];
    [m_TopicDataRequest setDidFailSelector:@selector(freshTopicFailed:)];
    [m_TopicDataRequest startAsynchronous];
    
    [m_ProgressHUD show:NO showBackground:NO useGray:YES];
}

// 收藏
- (void)topicCollectClicked
{
//    if (m_IsCollected)
//    {
//    }
//    else
//    {
//    }
    
    [self.m_BottomView hideHMTDSliderView];
    
    if ([BBUser isLogin])
    {
        [m_CollectTopicRequest clearDelegatesAndCancel];
        self.m_CollectTopicRequest = [HMApiRequest collectTopicAction:!m_IsCollected withTopicID:self.m_TopicID];
        [m_CollectTopicRequest setDidFinishSelector:@selector(collectTopicFinish:)];
        [m_CollectTopicRequest setDidFailSelector:@selector(collectTopicFail:)];
        [m_CollectTopicRequest setDelegate:self];
        [m_CollectTopicRequest startAsynchronous];
    }
}

// 分享
- (void)topicShareClicked:(id)sender
{
    [MobClick event:@"discuz_v2" label:@"分享图标点击"];
    //点击分享帖子
    [self.m_BottomView hideHMTDSliderView];
    
//    s_ShareMenu = [[[BBShareMenu alloc] initWithType:0 dataArray:self.m_ShareData title:@"分享"] ah_autorelease];
    s_ShareMenu = [[BBShareMenu alloc] initWithType:2 title:@"分享"];
    s_ShareMenu.delegate = self;
    [s_ShareMenu show];
}


#pragma mark -
#pragma mark freshTopicTitleView

- (void)freshTopicTitleView
{
    [m_TopicTitleCircleBgView setBackgroundColor:UI_VIEW_BGCOLOR];

    m_TopicTitleCircleLabel.textColor = DETAIL_CIRCLENAME_COLOR;
    self.m_TopicViewCountLabel.textColor = DETAIL_COUNT_COLOR;
    self.m_TopicReplyCountLabel.textColor = DETAIL_COUNT_COLOR;
    m_TopicTitleStyledLabel.textColor = DETAIL_Title_COLOR;
    
    self.m_TopicViewCountLabel.text = self.m_ViewCount;
    self.m_TopicReplyCountLabel.text = self.m_ReplyCount;
    
    m_TopicTitleCircleLabel.text = [NSString stringWithFormat:@"来自: %@", self.m_CircleName];
    if ([m_TopicTitle isNotEmpty])
    {
        m_TopicTitleStyledLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        
        float start = 12;
        self.m_IsTopImageView.left = start;
        self.m_IsNewImageView.left = start;
        self.m_IsBestImageView.left = start;
        self.m_IsHelpImageView.left = start;
        
        self.m_IsTopImageView.image = [UIImage imageNamed:@"topicdetail_cell_top_icon"];
        self.m_IsNewImageView.image = [UIImage imageNamed:@"topicdetail_cell_new_icon"];
        self.m_IsBestImageView.image = [UIImage imageNamed:@"topicdetail_cell_best_icon"];
        self.m_IsHelpImageView.image = [UIImage imageNamed:@"topiccell_mark_help"];
        
        
        if (self.m_IsTop)
        {
            self.m_IsTopImageView.hidden = NO;

            self.m_IsNewImageView.left = self.m_IsTopImageView.right + 4;
            self.m_IsBestImageView.left = self.m_IsTopImageView.right + 4;
            self.m_IsHelpImageView.left = self.m_IsTopImageView.right + 4;
        }

        if (self.m_IsNew)
        {
            self.m_IsNewImageView.hidden = NO;

            self.m_IsBestImageView.left = self.m_IsNewImageView.right + 4;
            self.m_IsHelpImageView.left = self.m_IsNewImageView.right + 4;
        }
        
        if (self.m_IsBest)
        {
            self.m_IsBestImageView.hidden = NO;

            self.m_IsHelpImageView.left = self.m_IsBestImageView.right + 4;
        }
        
        if (self.m_IsHelp)
        {
            self.m_IsHelpImageView.hidden = NO;
        }
        
        
        NSString *title = [NSString spaceWithFont:[UIFont systemFontOfSize:18.0f] top:self.m_IsTop new:_m_IsNew best:m_IsBest help:m_IsHelp pic:NO add:0];
        if (IOS_VERSION < 7.0)
        {
            self.m_IsTopImageView.top = 35;
            self.m_IsNewImageView.top = 35;
            self.m_IsBestImageView.top = 35;
            self.m_IsHelpImageView.top = 35;

            title = [NSString spaceWithFont:[UIFont systemFontOfSize:16.0f] top:self.m_IsTop new:_m_IsNew best:m_IsBest help:m_IsHelp pic:NO add:0];
        }
        title = [NSString stringWithFormat:@"%@%@", title, m_TopicTitle];
        
        m_TopicTitleStyledLabel.text = title;
        m_TopicTitleStyledLabel.hidden = NO;
        
        if ([title isNotEmpty])
        {
            CGSize size = [self sizeOfTitle];
            m_TopicTitleStyledLabel.height = size.height;
        }
        
        m_TopicTitleView.height = m_TopicTitleStyledLabel.bottom + 6;
    }
    else
    {
        m_TopicTitleView.height = m_TopicTitleCircleBgView.height;
    }
    [m_TopicTableView setTableHeaderView:m_TopicTitleView];
}

- (CGSize)sizeOfTitle
{
    CGSize size = CGSizeZero;
    if (IOS_VERSION >= 7.0)
    {
        NSMutableParagraphStyle *paragraphStyle = [[[NSMutableParagraphStyle alloc] init] ah_autorelease];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.hyphenationFactor = 0.0f;
        paragraphStyle.firstLineHeadIndent = 0.0f;
        paragraphStyle.paragraphSpacing = 0.0f;
        paragraphStyle.headIndent = 0.0f;
        paragraphStyle.lineSpacing = 3.0f;
        
        NSDictionary *attributes = @{NSFontAttributeName : m_TopicTitleStyledLabel.font,
                                     NSParagraphStyleAttributeName : paragraphStyle};
        
        size = [m_TopicTitleStyledLabel.text boundingRectWithSize:CGSizeMake(m_TopicTitleStyledLabel.width, 80) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil].size;
    }
    else
    {
        size = [m_TopicTitleStyledLabel.text sizeWithFont:m_TopicTitleStyledLabel.font constrainedToSize:CGSizeMake(m_TopicTitleStyledLabel.width, 80) lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return size;
}

- (IBAction)openCircle:(id)sender
{
    NSString *circleId = self.m_CircleID;
    
    if (circleId == nil)
    {
        return;
    }
    
    [HMShowPage showCircleTopic:self circleId:circleId];
}


#pragma mark -
#pragma mark parserNodeTopicDetailData

// 获取cell显示的字符串
- (NSString *)topicDetailCellString:(NSDictionary *)topicDetailData
{
    NSString *tag = [topicDetailData stringForKey:@"tag"];
    
    if ([tag isEqualToString:@"text"])
    {
        NSString *contentString = [topicDetailData stringForKey:@"text"];
        
        return contentString;
    }
    else if ([tag isEqualToString:@"emoji"])
    {
        NSString *contentString = [topicDetailData stringForKey:@"key"];
        
        return contentString;
    }
    else if ([tag isEqualToString:@"a"])
    {
        NSDictionary *content = [topicDetailData dictionaryForKey:@"content"];
        NSString *contentType = [content stringForKey:@"tag"];
        if ([contentType isEqualToString:@"text"])
        {
            NSString *contentString = [content stringForKey:@"text"];
            
            return contentString;
        }
    }
    
    return nil;
}

- (HMNewTopicInfor *)makeTopicInfor:(NSDictionary *)sourceDic
{
    // 用户信息
    NSDictionary *user_info = [sourceDic dictionaryForKey:@"user_info"];
    
//    NSMutableDictionary *user_info = [NSMutableDictionary dictionaryWithDictionary:[sourceDic dictionaryForKey:@"user_info"]];
//    [user_info setObject:@"1" forKey:@"is_group_admin"];

    HMNewTopicInfor *topicInfor = [[[HMNewTopicInfor alloc] init] ah_autorelease];
    topicInfor.m_UserId = [user_info stringForKey:@"author_enc_user_id"];
    topicInfor.m_UserName = [user_info stringForKey:@"author_name"];
    topicInfor.m_UserIcon = [user_info stringForKey:@"author_avatar"];
    topicInfor.m_BabyAge = [user_info stringForKey:@"babyage"];
    topicInfor.m_UserSign = [user_info stringForKey:@"active_user_avater"];
    if ([[user_info stringForKey:@"is_group_admin"] isEqualToString:@"1"])
    {
        topicInfor.m_IsAdmin = YES;
    }
    else
    {
        topicInfor.m_IsAdmin = NO;
    }

    // 统计NULL的用户
//    if (topicInfor.m_UserId && ![[user_info objectForKey:@"author_name"] isValided])
//    {
//        NSString *str = [NSString stringWithFormat:@"NULL nickname: %@", topicInfor.m_UserId];
//    }
    
    // 楼层
    NSString *floor = [sourceDic stringForKey:@"floor"];
    if (!floor)
    {
        floor = @"0";
    }
    topicInfor.m_Floor = floor;
    
    // 某楼内容
    NSMutableString *contentString = [[NSMutableString alloc] init];
    NSArray *contentArray = [sourceDic arrayForKey:@"discussion_content"];
    if ([contentArray isNotEmpty])
    {
        for (NSDictionary *dic in contentArray)
        {
            NSString *str = [self topicDetailCellString:dic];
            if (str)
            {
                [contentString appendString:str];
            }
        }
    }
    else
    {
        contentArray = [sourceDic arrayForKey:@"reply_content"];
        for (NSDictionary *dic in contentArray)
        {
            NSString *str = [self topicDetailCellString:dic];
            if (str)
            {
                [contentString appendString:str];
            }
        }
    }
    
    // 1层楼文本
    topicInfor.m_ContentText = contentString;
    [contentString ah_release];
    
    // 回复ID
    NSString *reply_id = [sourceDic stringForKey:@"reply_id"];
    topicInfor.m_ReplyID = reply_id;
    
    return topicInfor;
}

- (HMNewReplyInfor *)makeReplyInfor:(NSDictionary *)sourceDic replyDic:(NSDictionary *)replyDic
{
    HMNewReplyInfor *replyInfor = [[[HMNewReplyInfor alloc] init] ah_autorelease];
    
    // 原帖楼层
    NSString *position = [sourceDic stringForKey:@"position"];
    if (!position || [position isEqualToString:@"0"] || [position isEqualToString:@"-1"])
    {
        return nil;
    }
    replyInfor.m_Position = position;
    
    // 原帖回复人ID
    NSString *userId = [replyDic stringForKey:@"enc_user_id"];
    replyInfor.m_UserId = userId;
    
    // 原帖回复人昵称
    NSString *userName = [replyDic stringForKey:@"nickname"];
    replyInfor.m_UserName = userName;
    
    // 原帖回复人头像
    NSString *userIcon = [replyDic stringForKey:@"avatar"];
    replyInfor.m_UserIcon = userIcon;
    
    // 原帖回复文本内容
    NSString *contentText = [replyDic stringForKey:@"content"];
    if (contentText)
    {
        contentText = [contentText trim];
        replyInfor.m_ContentText = contentText;
    }
    else
    {
        replyInfor.m_ContentText = @"";
    }
    
    //replyInfor.m_ContentText = nil;
    /*
     取消回复内容
     */
    
    // 是否有图
    NSString *pic = [replyDic stringForKey:@"withimg"];
    if ([pic isEqualToString:@"1"])
    {
        replyInfor.m_HavePic = YES;
    }
    else
    {
        replyInfor.m_HavePic = NO;
    }
    
    replyInfor.m_ShowAll = NO;
    
    //    HMTopicDetailCellClass *cellClass = [[[HMTopicDetailCellClass alloc] initWithData:sourceDic topicInfor:topicInfor masterID:self.m_MasterID replyInfor:replyInfor] ah_autorelease];
    
    return replyInfor;
}

- (NSMutableArray *)parserNodeTopicDetailData:(NSDictionary *)sourceDic
{
    NSMutableArray *arrayData = [[[NSMutableArray alloc] init] ah_autorelease];
    
    // 广告数据
    self.m_ADData = [sourceDic dictionaryForKey:@"ad"];
    
    
    NSDictionary *discussionData = [sourceDic dictionaryForKey:@"discussion"];
    HMNewTopicInfor *topicInfor = nil;

    if (![self.m_MasterID isNotEmpty])
    {
        // 帖子楼信息
        HMNewTopicInfor *topicInfor = [self makeTopicInfor:discussionData];
        self.m_MasterID = topicInfor.m_UserId;
        self.m_MasterName = topicInfor.m_UserName;
    }

    if ([self.m_CurrentPage isEqualToString:@"1"])
    {
        if (!topicInfor)
        {
            topicInfor = [self makeTopicInfor:discussionData];
            self.m_MasterID = topicInfor.m_UserId;
            self.m_MasterName = topicInfor.m_UserName;
        }
        
        topicInfor.m_IsLoved = self.m_IsLoved;
        topicInfor.totalLoveTime = [discussionData intForKey:@"praise_count"];

        [arrayData addObjectsFromArray:[self parserNodeData:discussionData withTopicInfor:topicInfor withReplyInfor:nil]];
    }
    
    NSArray *relpyList = [sourceDic arrayForKey:@"reply_list"];
    if ([relpyList isNotEmpty])
    {
        for (NSDictionary *dic in relpyList)
        {
            // 帖子楼信息
            HMNewTopicInfor *topicInfor = [self makeTopicInfor:dic];
            
            NSDictionary *position_user = [dic dictionaryForKey:@"position_user"];
            HMNewReplyInfor *replyInfor = nil;
            
            if ([position_user isNotEmpty])
            {
                replyInfor = [self makeReplyInfor:dic replyDic:position_user];
            }
            
            [arrayData addObjectsFromArray:[self parserNodeData:dic withTopicInfor:topicInfor withReplyInfor:replyInfor]];
        }
    }
    
    return arrayData;
}

- (NSMutableArray *)parserNodeData:(NSDictionary *)sourceDic withTopicInfor:(HMNewTopicInfor *)topicInfor withReplyInfor:(HMNewReplyInfor *)replyInfor
{
    NSMutableArray *arrayData = [[[NSMutableArray alloc] init] ah_autorelease];
    NSMutableDictionary *header = [[[NSMutableDictionary alloc] init] ah_autorelease];
    
    
    __block BOOL isLandlord = YES;
    
    [sourceDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if ([key isEqualToString:@"discussion_content"])
        {
            NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] ah_autorelease];
            
            for (NSDictionary *dic in (NSArray *)obj)
            {
                BOOL addArray = YES;
                NSString *tag = [dic stringForKey:@"tag"];
                if ([tag isEqualToString:@"emoji"] || [tag isEqualToString:@"face"] || [tag isEqualToString:@"text"])
                {
                    if (array.count)
                    {
                        addArray = NO;
                        
                        HMTopicDetailCellClass *cellClass = [[[HMTopicDetailCellClass alloc] initWithData:dic topicInfor:topicInfor masterID:self.m_MasterID] ah_autorelease];
                        HMTopicDetailCellClass *lastCellClass = [array lastObject];
                        if (lastCellClass.m_Type == TOPICDETAILCELL_TEXTCONTENT_TYPE)
                        {
                            NSString *text = [NSString stringWithFormat:@"%@%@", lastCellClass.m_Text, cellClass.m_Text];
                            
                            lastCellClass.m_Text = text;
                        }
                        else
                        {
                            [array addObject:cellClass];
                        }
                    }
                }
                
                if (addArray)
                {
                    HMTopicDetailCellClass *cellClass = [[[HMTopicDetailCellClass alloc] initWithData:dic topicInfor:topicInfor masterID:self.m_MasterID] ah_autorelease];
                    
                    if (cellClass.m_Type != TOPICDETAILCELL_NONE_TYPE)
                    {
                        if (cellClass.m_Type == TOPICDETAILCELL_IMAGECONTENT_TYPE || cellClass.m_Type == TOPICDETAILCELL_IMAGELINK_TYPE)
                        {
                            if (!self.m_ShareImage)
                            {
                                // 分享图片
                                self.m_ShareImage = [[[UIImageView alloc] init] ah_autorelease];
                                [self.m_ShareImage setImageWithURL:[NSURL URLWithString:cellClass.m_PreImageUrl] placeholderImage:[UIImage imageNamed:@"lama_icon_sina"]];
                            }
                            
                            // 组织图片列表
                            cellClass.m_ImageIndex = self.m_PicsList.count;
                            [self.m_PicsList addObject:cellClass.m_ImageUrl];
                        }
                        
                        [array addObject:cellClass];
                    }
                }
            }
            
            [arrayData addObjectsFromArray:array];
        }
        else if([key isEqualToString:@"reply_content"])
        {
            NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] ah_autorelease];
            
            for (NSDictionary *dic in (NSArray *)obj)
            {
                BOOL addArray = YES;
                NSString *tag = [dic stringForKey:@"tag"];
                if ([tag isEqualToString:@"emoji"] || [tag isEqualToString:@"face"] || [tag isEqualToString:@"text"])
                {
                    if (array.count)
                    {
                        addArray = NO;
                        
                        HMTopicDetailCellClass *cellClass = [[[HMTopicDetailCellClass alloc] initWithData:dic topicInfor:topicInfor masterID:self.m_MasterID] ah_autorelease];
                        
                        HMTopicDetailCellClass *lastCellClass = [array lastObject];
                        
                        if (lastCellClass.m_Type == TOPICDETAILCELL_TEXTCONTENT_TYPE)
                        {
                            NSString *text = [NSString stringWithFormat:@"%@%@", lastCellClass.m_Text, cellClass.m_Text];
                            
                            //NSLog(@"%@", text);
                            lastCellClass.m_Text = text;
                            //[lastCellClass calcTextHeight];
                        }
                        else
                        {
                            [array addObject:cellClass];
                        }
                    }
                }
                
                if (addArray)
                {
                    HMTopicDetailCellClass *cellClass = [[[HMTopicDetailCellClass alloc] initWithData:dic topicInfor:topicInfor masterID:self.m_MasterID] ah_autorelease];
                    
                    if (cellClass.m_Type != TOPICDETAILCELL_NONE_TYPE)
                    {
                        // 组织图片列表
                        if (cellClass.m_Type == TOPICDETAILCELL_IMAGECONTENT_TYPE || cellClass.m_Type == TOPICDETAILCELL_IMAGELINK_TYPE)
                        {
                            cellClass.m_ImageIndex = self.m_PicsList.count;
                            [self.m_PicsList addObject:cellClass.m_ImageUrl];
                        }
                        
                        [array addObject:cellClass];
                    }
                }
            }
            
            [arrayData addObjectsFromArray:array];
            
            isLandlord = NO;
        }
        else
        {
            [header setObject:obj forKey:key];
        }
        
    }];
    
    HMTopicDetailCellClass *replyCellClass = nil;
	NSMutableDictionary *footer = [[[NSMutableDictionary alloc]initWithDictionary:header] ah_autorelease];
    if (isLandlord)
    {
        [header setObject:@"discussion_header" forKey:@"tag"];
        [footer setObject:@"discussion_footer" forKey:@"tag"];
        if ([self.m_ADData isDictionaryAndNotEmpty])
        {
            [footer setObject:self.m_ADData forKey:@"ad"];
        }
    }
    else
    {
        [header setObject:@"reply_header" forKey:@"tag"];
        [footer setObject:@"reply_footer" forKey:@"tag"];
        
        if ([replyInfor isNotEmpty])
        {
            replyCellClass = [[[HMTopicDetailCellClass alloc] initWithData:header topicInfor:topicInfor masterID:self.m_MasterID replyInfor:replyInfor] ah_autorelease];
        }
    }
    
    HMTopicDetailCellClass *headerCellClass = [[[HMTopicDetailCellClass alloc] initWithData:header topicInfor:topicInfor masterID:self.m_MasterID] ah_autorelease];
    HMTopicDetailCellClass *footerCellClass = [[[HMTopicDetailCellClass alloc] initWithData:footer topicInfor:topicInfor masterID:self.m_MasterID] ah_autorelease];
    
    if (headerCellClass.m_Type == TOPICDETAILCELL_MASTERHEADER_TYPE)
    {
        // 分享内容
        self.m_ShareContent = headerCellClass.m_TopicInfor.m_ContentText;
    }
    
    if (replyCellClass)
    {
//        [arrayData insertObject:replyCellClass atIndex:0];
        [arrayData addObject:replyCellClass];
    }
    [arrayData insertObject:headerCellClass atIndex:0];
    [arrayData addObject:footerCellClass];
    
    
    for (HMTopicDetailCellClass *cellClass in arrayData)
    {
        if (cellClass.m_Type == TOPICDETAILCELL_TEXTCONTENT_TYPE || cellClass.m_Type == TOPICDETAILCELL_TEXTLINK_TYPE)
        {
            [cellClass calcTextHeight];
        }
    }
    
    return arrayData;
}


#pragma mark -
#pragma mark freshTopicDataRequest

- (void)enableNavFunc:(BOOL)enable
{
    for (UIBarButtonItem *buttonItem in self.navigationItem.rightBarButtonItems)
    {
        UIButton *btn = (UIButton *)buttonItem.customView;
        btn.enabled = enable;
    }
}

- (void)freshTopicData:(NSInteger)addPage
{
    [self enableNavFunc:YES];
    
    [m_TopicDataRequest clearDelegatesAndCancel];
    self.m_TopicDataRequest = nil;
    
    NSInteger page = [self.m_CurrentPage intValue] + addPage;
    
    if (page < 1)
    {
        page = 1;
    }
    
    if (m_TopicDataList.count == 0 && !s_PositionToFloor)
    {
        page = 1;
    }
    
    NSString *pagestr = [NSString stringWithFormat:@"%ld", (long)page];
    
    if (!s_PositionToFloor)
    {
        self.m_ReplyID = nil;
    }
    
    if (self.m_IsShowAll)
    {
        self.m_TopicDataRequest = [HMApiRequest requestNewTopicDetail:self.m_TopicID withCurentPage:pagestr orReplyId:self.m_ReplyID withIsUserType:@"0"];
    }
    else
    {
        self.m_TopicDataRequest = [HMApiRequest requestNewTopicDetail:self.m_TopicID withCurentPage:pagestr orReplyId:self.m_ReplyID withIsUserType:@"1"];
    }
    
    [m_TopicDataRequest setDelegate:self];
    [m_TopicDataRequest setDidFinishSelector:@selector(freshTopicFinished:)];
    [m_TopicDataRequest setDidFailSelector:@selector(freshTopicFailed:)];
    [m_TopicDataRequest startAsynchronous];
    
//    if (m_TopicDataList.count == 0)
    {
        [m_ProgressHUD show:NO showBackground:NO useGray:YES];
    }
}

- (void)freshTopicFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *parserDic = [responseString objectFromJSONString];
    if (![parserDic isDictionaryAndNotEmpty])
    {
        [m_ProgressHUD show:YES withText:@"获取数据失败"];
        [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        m_BottomView.m_currentPage = [m_CurrentPage integerValue];
        self.m_IsReply = NO;
        s_ShowTypeSwitch = NO;
        
        [self hideEGORefreshView];
        if (s_isRollTopicData)
        {
            s_isRollTopicData = NO;
            m_TopicTableView.contentOffset = CGPointZero;
            _lastY = 0;
        }
        
        if (self.m_TopicDataList.count == 0)
        {
            s_NoDataView.m_Type = HMNODATAVIEW_PROMPT;
            s_NoDataView.m_PromptText = @"这里还什么都木有…";
            s_NoDataView.m_ShowBtn = YES;
            s_NoDataView.hidden = NO;
            [self enableNavFunc:NO];
        }
        
        return;
    }

    BOOL is_reply_exist = NO;
    NSString *roll_reply_id = nil;

    //返回数据成功
    NSString *status = [parserDic stringForKey:@"status"];
    if ([status isEqualToString:@"success"] || [status isEqualToString:@"0"])
    {
        NSDictionary *list = [parserDic dictionaryForKey:@"data"];
        
        if (![list isNotEmpty])
        {
            [m_ProgressHUD show:YES withText:@"获取数据失败"];
            [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            
            m_BottomView.m_currentPage = [m_CurrentPage integerValue];
            self.m_IsReply = NO;
            s_ShowTypeSwitch = NO;
            
            [self hideEGORefreshView];
            if (s_isRollTopicData)
            {
                s_isRollTopicData = NO;
                m_TopicTableView.contentOffset = CGPointZero;
                _lastY = 0;
            }
            
            if (self.m_TopicDataList.count == 0)
            {
                s_NoDataView.m_Type = HMNODATAVIEW_PROMPT;
                s_NoDataView.m_PromptText = @"数据错误, \n请稍后再试(>_<!)";
                s_NoDataView.m_ShowBtn = YES;
                s_NoDataView.hidden = NO;
                [self enableNavFunc:NO];
            }
            
            return;
        }
        
        s_isRollTopicData = NO;

        if (s_PositionToFloor)
        {
            is_reply_exist = [list stringForKey:@"is_reply_exist"] == nil ? YES : [list boolForKey:@"is_reply_exist"];
            roll_reply_id = [list stringForKey:@"roll_reply_id"];
        }
        
        NSDictionary *headUserInfomationDic  = [list dictionaryForKey:@"discussion"];
        
        if([[BBUser getEncId] isEqualToString:[[headUserInfomationDic dictionaryForKey:@"user_info"] stringForKey:@"author_enc_user_id"]])
        {
            self.s_UserRank = [[headUserInfomationDic dictionaryForKey:@"user_info"] stringForKey:@"level_num"];
            if ([self.s_UserRank isNotEmpty])
            {
                [BBUser setUserLevel:self.s_UserRank];
            }
        }
        
        self.m_IsLoved = [headUserInfomationDic boolForKey:@"had_praised"];
        
        self.m_CurrentPage = [headUserInfomationDic stringForKey:@"current_page"];
        self.m_PageCount = [headUserInfomationDic stringForKey:@"page_count"];
        m_BottomView.m_maxPageNumber = [m_PageCount integerValue];
        m_BottomView.m_currentPage = [m_CurrentPage integerValue];
        
        NSInteger currentPage = [m_CurrentPage integerValue];
        if (currentPage <= 0 || currentPage > [m_PageCount integerValue])
        {
            self.m_CurrentPage = @"1";
            self.m_PageCount = @"1";
            m_BottomView.m_maxPageNumber = [m_PageCount integerValue];
            m_BottomView.m_currentPage = [m_CurrentPage integerValue];
            
            [m_ProgressHUD show:YES withText:@"获取数据失败"];
            [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            
            self.m_IsReply = NO;
            s_ShowTypeSwitch = NO;
            
            [self hideEGORefreshView];
            if (s_isRollTopicData)
            {
                s_isRollTopicData = NO;
                m_TopicTableView.contentOffset = CGPointZero;
                _lastY = 0;
            }
            
            if (self.m_TopicDataList.count == 0)
            {
                s_NoDataView.m_Type = HMNODATAVIEW_PROMPT;
                s_NoDataView.m_PromptText = @"数据错误, \n请稍后再试(>_<!)";
                s_NoDataView.m_ShowBtn = YES;
                s_NoDataView.hidden = NO;
                [self enableNavFunc:NO];
            }
            
            return;
        }
        
        s_NoDataView.hidden = YES;
        
        [m_TopicDataList removeAllObjects];
        // 清空图片列表
        [self.m_PicsList removeAllObjects];
        
        //获取帖子的信息，标题，是否收藏，当前页码和总页码
        self.m_TopicTitle = [headUserInfomationDic stringForKey:@"discussion_title"];
        // 帖子摘要
        self.m_summary = [headUserInfomationDic stringForKey:@"summary"];
        
        //调用解析器，重新封装数据
        NSArray *parselist = [self parserNodeTopicDetailData:list];
        
        NSDictionary *groupData = [headUserInfomationDic dictionaryForKey:@"group_data"];
        if (groupData)
        {
            self.m_AddCircleStatus = [[groupData stringForKey:@"is_joined"] isEqualToString:@"1"];
            self.m_CircleID = [groupData stringForKey:@"id"];
            self.m_CircleName = [groupData stringForKey:@"title"];
        }
        else
        {
            self.m_AddCircleStatus = NO;
            self.m_CircleID = nil;
            self.m_CircleName = nil;
        }
        
        if (![m_CircleName isNotEmpty])
        {
            self.m_CircleName = @"未知圈子";
        }
        
        self.m_ViewCount = [headUserInfomationDic stringForKey:@"view_count" defaultString:@"0"];
        if ([self.m_ViewCount integerValue]>=100000)
        {
            self.m_ViewCount = @"10万+";
        }
        self.m_ReplyCount = [headUserInfomationDic stringForKey:@"reply_count" defaultString:@"0"];
        if ([self.m_ReplyCount integerValue]>=100000)
        {
            self.m_ReplyCount = @"10万+";
        }
        self.m_WebUrl = [headUserInfomationDic stringForKey:@"weburl" defaultString:@""];
        self.m_ShareUrl =  [headUserInfomationDic stringForKey:@"share_url" defaultString:@""];
        
        NSString *isTop = [headUserInfomationDic stringForKey:@"is_top"];
        self.m_IsTop = [isTop isEqualToString:@"1"];

        NSString *isNew = [headUserInfomationDic stringForKey:@"is_new"];
        self.m_IsNew = [isNew isEqualToString:@"1"];

        NSString *isBest = [headUserInfomationDic stringForKey:@"is_elite"];
        self.m_IsBest = [isBest isEqualToString:@"1"];
        
        NSString *isHelp= [headUserInfomationDic stringForKey:@"is_question"];
        self.m_IsHelp = [isHelp isEqualToString:@"1"];
        
//        NSDictionary *userinfo = [headUserInfomationDic dictionaryForKey:@"user_info"];
        //获取楼主得ID 判断是否是楼主回复
//        HMAppDelegate *appdelegate = (HMAppDelegate*)[[UIApplication sharedApplication] delegate];
//        appdelegate.topicFloorMainUserID = [userinfo stringForKey:@"author_enc_user_id"];
        
        [self freshTopicTitleView];
        
        if ([BBUser isLogin])
        {
            if ([[headUserInfomationDic stringForKey:@"is_fav"] isEqualToString:@"1"])
            {
                self.m_IsCollected = YES;
            }
            else
            {
                self.m_IsCollected = NO;
            }
        }
        
        if ([parselist count] == 0)
        {
            [self.m_TopicTableView reloadData];
        }
        else
        {
            [self.m_TopicDataList addObjectsFromArray:parselist];
            [self.m_TopicTableView reloadData];
        }
        
        m_TopicTableView.contentOffset = CGPointZero;;
        _lastY = 0;
    }
    else if ([[parserDic stringForKey:@"status"] isEqualToString:@"failed"])
    {
        [m_ProgressHUD hide:YES];
        
        m_BottomView.m_currentPage = [m_CurrentPage integerValue];
        self.m_IsReply = NO;
        s_ShowTypeSwitch = NO;
        
        [self hideEGORefreshView];
        
        if (s_isRollTopicData)
        {
            s_isRollTopicData = NO;
            m_TopicTableView.contentOffset = CGPointZero;
            _lastY = 0;
        }
        
        if (self.m_TopicDataList.count == 0)
        {
            s_NoDataView.m_Type = HMNODATAVIEW_PROMPT;
            s_NoDataView.m_PromptText = @"您访问的帖子不存在";
            s_NoDataView.m_ShowBtn = NO;
            s_NoDataView.hidden = NO;
//            [self enableNavFunc:NO];
            if ([self.navigationItem.rightBarButtonItems count]>1)
            {
                UIBarButtonItem *buttonItem = self.navigationItem.rightBarButtonItems[0];
                UIButton *btn = (UIButton *)buttonItem.customView;
                btn.enabled = NO;
            }
        }
        
        return;
    }
    else
    {
        [m_ProgressHUD show:YES withText:@"获取数据失败"];
        [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        m_BottomView.m_currentPage = [m_CurrentPage integerValue];
        self.m_IsReply = NO;
        s_ShowTypeSwitch = NO;
        
        [self hideEGORefreshView];
        if (s_isRollTopicData)
        {
            s_isRollTopicData = NO;
            m_TopicTableView.contentOffset = CGPointZero;
            _lastY = 0;
        }
        
        if (self.m_TopicDataList.count == 0)
        {
            s_NoDataView.m_Type = HMNODATAVIEW_PROMPT;
            s_NoDataView.m_PromptText = @"这里还什么都木有…";
            s_NoDataView.m_ShowBtn = YES;
            s_NoDataView.hidden = NO;
            [self enableNavFunc:NO];
        }
        
        return;
    }
    
    [self freshBottom_refresh];
    
    //设置上拉下拉刷新事 显示要加载得页码和总页数
    if ([m_CurrentPage isEqualToString:m_PageCount])
    {
        s_refresh_bottom_view.refreshStatus = YES;
    }
    else
    {
        s_refresh_bottom_view.topicDetailPage = [NSString stringWithFormat:@"上拉加载第%d页 共%@页", [m_CurrentPage integerValue] + 1, m_PageCount];
        s_refresh_bottom_view.topicDetailStatus = [NSString stringWithFormat:@"松手加载第%d页 共%@页", [m_CurrentPage integerValue] + 1, m_PageCount];
        s_refresh_bottom_view.refreshStatus = NO;
    }
    
    if ([m_CurrentPage integerValue] == 1)
    {
        s_refresh_header_view.refreshStatus = YES;
    }
    else
    {
        s_refresh_header_view.topicDetailPage = [NSString stringWithFormat:@"下拉加载第%d页 共%@页", [m_CurrentPage integerValue] - 1, m_PageCount];
        s_refresh_header_view.topicDetailStatus = [NSString stringWithFormat:@"松手加载第%d页 共%@页", [m_CurrentPage integerValue] - 1, m_PageCount];
        s_refresh_header_view.refreshStatus = NO;
    }
    
    //加载完成去掉加载框  拖动的动画效果
    if(s_bottom_reloading)
    {
        /*
         NSInteger rows = [m_TopicTableView numberOfRowsInSection:0];
         if(rows > 0)
         {
         [m_TopicTableView setContentOffset:CGPointMake(0, -m_TopicTableView.height)];
         [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
         [m_TopicTableView setContentOffset:CGPointMake(0, 2)];
         } completion:^(BOOL finished) {
         
         }];
         }
         */
        
        NSInteger rows = [m_TopicTableView numberOfRowsInSection:0];
        if(rows > 0)
        {
            m_TopicTableView.alpha = 0.5f;
            [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
                m_TopicTableView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                
            }];
        }
        
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    //加载完成去掉加载框 拖动的动画效果
    else if(s_reloading)
    {
        /*
         NSInteger rows = [m_TopicTableView numberOfRowsInSection:0];
         [m_TopicTableView setContentSize:CGSizeMake(0, m_TopicTableView.contentSize.height + m_TopicTableView.height)];
         [m_TopicTableView setContentOffset:CGPointMake(0, m_TopicTableView.height)];
         
         if(rows > 0)
         {
         [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionTransitionCurlDown animations:^{
         [m_TopicTableView setContentOffset:CGPointMake(0, 2)];
         } completion:^(BOOL finished) {
         [m_TopicTableView setContentSize:CGSizeMake(0, m_TopicTableView.contentSize.height-m_TopicTableView.height)];
         }];
         }
         */
        
        NSInteger rows = [m_TopicTableView numberOfRowsInSection:0];
        
        if(rows > 0)
        {
            m_TopicTableView.alpha = 0.5f;
            [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionTransitionCurlDown animations:^{
                m_TopicTableView.alpha = 1.0f;
            } completion:^(BOOL finished) {
            }];
        }
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    else
    {
        self.m_BottomView.userInteractionEnabled = YES;
    }
    
    //重新设置刷新得文案
    [s_refresh_header_view refreshLastUpdatedLabel:YES];
    [s_refresh_bottom_view refreshPullUpLastUpdatedLabel:YES];
    
    if (m_ProgressHUD.isShow)
    {
        [m_ProgressHUD hide:NO];
        
        m_ProgressHUD.mode = MBProgressHUDModeText;
        m_ProgressHUD.color = nil;
    }
    
    if (s_ShowTypeSwitch)
    {
        if (m_IsShowAll)
        {
            [m_ProgressHUD show:YES withText:@"只看楼主"];
        }
        else
        {
            [m_ProgressHUD show:YES withText:@"查看全部"];
        }
        [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        m_IsShowAll = !m_IsShowAll;
        NSInteger rows = [m_TopicTableView numberOfRowsInSection:0];
        
        if(rows > 0)
        {
            m_TopicTableView.alpha = 0.5f;
            [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionTransitionCurlDown animations:^{
                m_TopicTableView.alpha = 1.0f;
            } completion:^(BOOL finished) {
            }];
        }
    }
    
    s_ShowTypeSwitch = NO;
    
    // 跳楼层
    if (s_PositionToFloor)
    {
        if ([self.m_ReplyID isNotEmpty])
        {
            NSString *replyID = self.m_ReplyID;

            if (!is_reply_exist && [roll_reply_id isNotEmpty])
            {
                replyID = roll_reply_id;

                if (m_ShowPositionError)
                {
                    [PXAlertView showAlertWithTitle:@"抱歉哦，该回复已被删除"];
                }
            }
            
            s_PositionToFloor = NO;

            if ([replyID isNotEmpty])
            {
                [self scrollToFloorID:replyID toLastRow:NO];
            }

            self.m_ReplyID = nil;
        }
        else
        {
            s_PositionToFloor = NO;
            
            [self scrollToFloor:m_PositionFloor toLastRow:NO];
        }
    }
    
//    NSInteger appTimes = 0;//[BBUser getOpenAppTimes];
    
//    if ((appTimes % DEFAULT_OPENAPPCHECK) == 0)
//    {
//        HMUserInfor *userInfor = [HMUser UserInfor];
//        
//        if (!userInfor.m_IsShowedStoreEvaluate)
//        {
//            if (!s_StoreEvaluateView)
//            {
//                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showstoreEvaluateView) object:nil];
//                [self performSelector:@selector(showstoreEvaluateView) withObject:nil afterDelay:STOREEVALUATEVIEW_DELAYTIME];
//            }
//        }
//    }
}

- (void)freshTopicFailed:(ASIHTTPRequest *)request
{
    self.m_IsReply = NO;
    s_ShowTypeSwitch = NO;
    
    m_BottomView.m_currentPage = [m_CurrentPage integerValue];
    
    [m_ProgressHUD setLabelText:[CommonErrorCode errorWithErrorCode:ErrorCode_NetError]];
    m_ProgressHUD.mode = MBProgressHUDModeText;
    m_ProgressHUD.color = nil;
    [m_ProgressHUD show:YES];
    [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    
    [self hideEGORefreshView];
    if (s_isRollTopicData)
    {
        s_isRollTopicData = NO;
        m_TopicTableView.contentOffset = CGPointZero;
        _lastY = 0;
    }
    
    if (self.m_TopicDataList.count == 0)
    {
        s_NoDataView.m_Type = HMNODATAVIEW_NETERROR;
        s_NoDataView.hidden = NO;
        [self enableNavFunc:NO];
    }
}


- (void)showstoreEvaluateView
{
    // 成功打开更新次数
//    BBAppDelegate *appdelegate = (BBAppDelegate*)[[UIApplication sharedApplication] delegate];
//    [appdelegate saveOpenAppTimes];
    
//    [m_ReplyView closeView];
    
//    s_StoreEvaluateView = [[HMStoreEvaluateView alloc] initView];
//    s_StoreEvaluateView.delegate = self;
//    [self.navigationController.view addSubview:s_StoreEvaluateView];
//    [s_StoreEvaluateView show];
//    [s_StoreEvaluateView ah_release];
}


#pragma mark -
#pragma mark HMStoreEvaluateViewDelegate

- (void)storeEvaluateViewClose
{
//    if (s_StoreEvaluateView)
//    {
//        if (s_StoreEvaluateView.superview)
//        {
//            [s_StoreEvaluateView removeFromSuperview];
//        }
//    }
//    
//    s_StoreEvaluateView = nil;
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.m_TopicDataList count];
}

//按照索引设置当前的cell属性和值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMTopicDetailCellClass *cellClass = [self.m_TopicDataList objectAtIndex:indexPath.row];
    
    NSString *commentCellIdentifier = [NSString stringWithFormat:@"%d", cellClass.m_Type];
    
    //获取自定义cell类型
    HMTopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[HMTopicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellIdentifier withtype:cellClass.m_Type] ah_autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.m_PopViewController = self.navigationController;
    [cell drawTopicDetailCell:cellClass withTopicDelegate:self];
    if ([cellClass.m_adImg isNotEmpty] && [self.m_ADData isDictionaryAndNotEmpty])
    {
        NSString *adStatus = [self.m_ADData stringForKey:AD_DICT_STATUS_KEY];
        if ([adStatus isNotEmpty] && [adStatus isEqualToString:@"babytree"])
        {
            //只有展示babytree的广告时才记录pv，第三方平台的不统计
            [[BBAdPVManager sharedInstance] addLocalPVForAd:self.m_ADData];
        }
    }
    
    // 设置图片列表
    if ([cell.m_CellView isKindOfClass:[HMTopicDetailCellImageView class]])
    {
        HMTopicDetailCellImageView *cellImageView = (HMTopicDetailCellImageView *)cell.m_CellView;
        cellImageView.m_BigImageUrlArray = self.m_PicsList;
    }
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMTopicDetailCellClass *cellClass = [self.m_TopicDataList objectAtIndex:indexPath.row];
    
    return cellClass.m_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    HMTopicDetailCellClass *cellClass = [self.m_TopicDataList objectAtIndex:indexPath.row];
    
//    BOOL couldReply = _isBarShow;
//    
//    _lastY = tableView.contentOffset.y;
//    [self showType:YES];

//    if (![cellClass.m_TopicInfor.m_Floor isEqualToString:@"0"])
//    {
//        if (cellClass.m_TopicInfor.m_IsMaster)
//        {
//            [self openReplyMaster];
//        }
//        else
//        {
//            [self.m_ReplyView showWithFloor:cellClass.m_TopicInfor.m_Floor referID:cellClass.m_TopicInfor.m_ReplyID isJoin:m_AddCircleStatus groupId:self.m_CircleID floorName:cellClass.m_TopicInfor.m_UserName];
//        }
//    }
}

- (void)freshBottom_refresh
{
    CGSize tableContentSize = m_TopicTableView.contentSize;
    CGFloat refresh_bottom_y = MAX(m_TopicTableView.height, tableContentSize.height);

    s_refresh_bottom_view.top = refresh_bottom_y;
}

- (void)scrollToFloor:(NSInteger)floor toLastRow:(BOOL)last
{
    NSInteger pageNum = [m_CurrentPage integerValue] - 1;
    if (pageNum<0)
    {
        pageNum = 0;
    }
    
    if (!(floor > pageNum*20 && floor <= (pageNum+1)*20))
    {
        return;
    }

    //s_PositionToFloor = YES;

    NSInteger row = m_TopicDataList.count-1;
    NSInteger lastrow = 0;
    
    for (NSInteger i = m_TopicDataList.count-1; i >= 0; i--)
    {
        row = i;
        HMTopicDetailCellClass *cellClass = [m_TopicDataList objectAtIndex:i];
        
        if (cellClass.m_Type == TOPICDETAILCELL_MASTERHEADER_TYPE || cellClass.m_Type == TOPICDETAILCELL_REPLYHEADER_TYPE)
        {
            NSInteger cfloor = [cellClass.m_TopicInfor.m_Floor integerValue];
            
            if (lastrow == 0)
            {
                lastrow = row;
            }
            if (cfloor == floor)
            {
                break;
            }
        }
    }
    
    if (row > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        
        [m_TopicTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        return;
    }
    else
    {
        if (last)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastrow inSection:0];
            
            [m_TopicTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

- (void)scrollToFloorID:(NSString *)floorID toLastRow:(BOOL)last
{
    if (![floorID isNotEmpty])
    {
        return;
    }

    NSInteger row = m_TopicDataList.count-1;
    NSInteger lastrow = 0;

    for (NSInteger i = m_TopicDataList.count-1; i >= 0; i--)
    {
        row = i;
        HMTopicDetailCellClass *cellClass = [m_TopicDataList objectAtIndex:i];

        if (cellClass.m_Type == TOPICDETAILCELL_MASTERHEADER_TYPE || cellClass.m_Type == TOPICDETAILCELL_REPLYHEADER_TYPE)
        {
            if (lastrow == 0)
            {
                lastrow = row;
            }
            if ([floorID isEqual:cellClass.m_TopicInfor.m_ReplyID])
            {
                break;
            }
        }
    }

    if (row > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];

        [m_TopicTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

        return;
    }
    else
    {
        if (last)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastrow inSection:0];

            [m_TopicTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
    //    if ([[scrollView class] isSubclassOfClass:[self.inputView.textView class]])
    //    {
    //        return;
    //    }

//    if(!s_bottom_reloading && !s_reloading)
//    {
//        CGFloat refresh_bottom_y = MAX(scrollView.height, scrollView.contentSize.height);
//        
//        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= refresh_bottom_y-scrollView.height)
//        {
//            //NSLog(@"_lastY = %f, %f, %f", _lastY, scrollView.contentOffset.y, scrollView.contentSize.height);
//
//            if (!s_PositionToFloor)
//            {
//                if (scrollView.contentOffset.y - _lastY < 0)
//                {
//                    //if (scrollView.contentOffset.y-height > 0 && scrollView.contentOffset.y+scrollView.height+height < refresh_bottom_y)
//                    {
//                        [self showType:YES];
//                    }
//                }
//                else if (scrollView.contentOffset.y - _lastY > 0)
//                {
//                    //if (scrollView.contentOffset.y-height > 0 && scrollView.contentOffset.y+scrollView.height+height < refresh_bottom_y)
//                    {
//                        [self showType:NO];
//                    }
//                }
//            }
//            else
//            {
//                s_PositionToFloor = NO;
//            }
//
//            _lastY = scrollView.contentOffset.y;
//        }
//    }

    [s_refresh_header_view egoRefreshScrollViewDidScroll:scrollView];
    [s_refresh_bottom_view egoRefreshPullUpScrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDragging");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDecelerating");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging, %d", decelerate);
    //    if ([[scrollView class] isSubclassOfClass: [self.inputView.textView class]])
    //    {
    //        return;
    //    }

    [s_refresh_header_view egoRefreshScrollViewDidEndDragging:scrollView];
    [s_refresh_bottom_view egoRefreshPullUpScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
}

- (void)showBar:(BOOL)animated
{
    if (_isBarShow == YES)
    {
        return;
    }
    
    _isBarShow = YES;
    
    if (animated)
    {
        [UIView animateWithDuration:0.25f animations:^{
            m_TopicTableView.height = UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - BOTTOM_VIEW_HEGHT;
            m_BottomView.top = UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - BOTTOM_VIEW_HEGHT;
            
            [self freshBottom_refresh];
            
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            if (IOS_VERSION >= 7.0)
            {
                s_StatusBarBakView.alpha = 0.0;
            }
        } completion:^(BOOL finished) {
            if (!self.m_ReplyView.superview)
            {
                [self.navigationController.view addSubview:m_ReplyView];
            }
        }];
    }
    else
    {
        m_TopicTableView.height = UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - BOTTOM_VIEW_HEGHT;
        m_BottomView.top = UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - BOTTOM_VIEW_HEGHT;

        [self freshBottom_refresh];
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        if (!self.m_ReplyView.superview)
        {
            [self.navigationController.view addSubview:m_ReplyView];
        }
        if (IOS_VERSION >= 7.0)
        {
            s_StatusBarBakView.alpha = 0.0;
        }
    }
}

- (void)hideBar:(BOOL)animated
{
    if (_isBarShow == NO)
    {
        return;
    }
    
    _isBarShow = NO;
    
    if (self.m_ReplyView.superview)
    {
        [m_ReplyView removeFromSuperview];
    }
    
    float statusBarHeight = UI_STATUS_BAR_HEIGHT;
    if (IOS_VERSION >= 7.0)
    {
        statusBarHeight = 0;
    }

    if (animated)
    {
        [UIView animateWithDuration:0.25f animations:^{
            m_TopicTableView.height = UI_SCREEN_HEIGHT - statusBarHeight;
            m_BottomView.top = UI_SCREEN_HEIGHT - statusBarHeight;

            [self freshBottom_refresh];
            
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            if (IOS_VERSION >= 7.0)
            {
                s_StatusBarBakView.alpha = 0.7;
            }
        }];
    }
    else
    {
        m_TopicTableView.height = UI_SCREEN_HEIGHT - statusBarHeight;
        m_BottomView.top = UI_SCREEN_HEIGHT - statusBarHeight;

        [self freshBottom_refresh];
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        if (IOS_VERSION >= 7.0)
        {
            s_StatusBarBakView.alpha = 0.7;
        }
    }
}

- (void)showType:(BOOL)show
{
//    if (show)
//    {
//        [self showBar:YES];
//    }
//    else
//    {
//        [self hideBar:YES];
//    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate
// 下拉
- (void)doneLoadingTableViewData
{
    self.m_BottomView.userInteractionEnabled = YES;
    
    self.m_IsReply = NO;
    s_reloading = NO;
    [s_refresh_header_view egoRefreshScrollViewDataSourceDidFinishedLoading:m_TopicTableView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self egoReloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return s_reloading;
}

- (void)egoReloadTableViewDataSource
{
    if(!s_bottom_reloading && !s_reloading)
    {
        s_reloading = YES;
        
        if ([m_CurrentPage integerValue] == 1)
        {
            s_refresh_header_view.refreshStatus = YES;
            [self freshTopicData:0];
            return;
        }
        if ([m_CurrentPage integerValue] > 1)
        {
            s_refresh_header_view.refreshStatus = NO;
        }
        
        [self freshTopicData:-1];
    }
    else
    {
        if (s_bottom_reloading)
        {
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }
}


#pragma mark -
#pragma mark EGORefreshPullUpTableHeaderDelegate

//上拉
- (void)doneLoadingPullUpTableViewData
{
    s_bottom_reloading = NO;
    
    self.m_BottomView.userInteractionEnabled = YES;
    
    [s_refresh_bottom_view egoRefreshPullUpScrollViewDataSourceDidFinishedLoading:m_TopicTableView];
    
    if (m_IsReply)
    {
        self.m_IsReply = NO;
        
        if (!m_IsShowAll)
        {
            [m_ProgressHUD show:YES withText:@"回复成功"];
            [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            
            return;
        }
        
        NSInteger row = m_TopicDataList.count-1;
        NSInteger lastrow = 0;
        
        for (NSInteger i = m_TopicDataList.count-1; i >= 0; i--)
        {
            row = i;
            HMTopicDetailCellClass *cellClass = [m_TopicDataList objectAtIndex:i];
            
            if (cellClass.m_Type == TOPICDETAILCELL_MASTERHEADER_TYPE || cellClass.m_Type == TOPICDETAILCELL_REPLYHEADER_TYPE)
            {
                NSInteger floor = [cellClass.m_TopicInfor.m_Floor integerValue];
                
                if (lastrow == 0)
                {
                    lastrow = row;
                }
                if (self.m_ReplyFloor == floor)
                {
                    break;
                }
            }
        }
        
        if (self.m_ReplyFloor > 0)
        {
            if (row > 0)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                
                [m_TopicTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                
                return;
            }
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastrow inSection:0];
        
        [m_TopicTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

- (void)egoRefreshPullUpTableHeaderDidTriggerRefresh:(EGORefreshPullUpTableHeaderView*)view
{
	[self egoLoadNextTableViewDataSource];
}

- (BOOL)egoRefreshPullUpTableHeaderDataSourceIsLoading:(EGORefreshPullUpTableHeaderView*)view
{
	return s_bottom_reloading; // should return if data source model is reloading
}

- (void)egoLoadNextTableViewDataSource
{
    if(!s_reloading && !s_bottom_reloading)
    {
        s_bottom_reloading = YES;
        
        if ([m_CurrentPage isEqualToString:m_PageCount])
        {
            s_refresh_bottom_view.refreshStatus = YES;
            // 最后一页时不刷新数据
            [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.2 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            return;
        }
        if ([m_CurrentPage integerValue] < [m_PageCount integerValue])
        {
            s_refresh_bottom_view.refreshStatus = NO;
            //            self.m_CurrentPage = [NSString stringWithFormat:@"%d", [m_CurrentPage intValue]+1];
            //
            //            m_BottomView.m_currentPage = [m_CurrentPage intValue];
        }
        
        [self freshTopicData:1];
    }
    else
    {
        if(s_reloading)
        {
            [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }
}


- (void)hideEGORefreshView
{
    //设置上拉下拉刷新事 显示要加载得页码和总页数
    if ([m_CurrentPage isEqualToString:m_PageCount])
    {
        s_refresh_bottom_view.refreshStatus = YES;
    }
    else
    {
        s_refresh_bottom_view.topicDetailPage = [NSString stringWithFormat:@"上拉加载第%d页 共%@页", [m_CurrentPage integerValue] + 1, m_PageCount];
        s_refresh_bottom_view.topicDetailStatus = [NSString stringWithFormat:@"松手加载第%d页 共%@页", [m_CurrentPage integerValue] + 1, m_PageCount];
        s_refresh_bottom_view.refreshStatus = NO;
    }
    
    if ([m_CurrentPage integerValue] == 1)
    {
        s_refresh_header_view.refreshStatus = YES;
    }
    else
    {
        s_refresh_header_view.topicDetailPage = [NSString stringWithFormat:@"下拉加载第%d页 共%@页", [m_CurrentPage integerValue] - 1, m_PageCount];
        s_refresh_header_view.topicDetailStatus = [NSString stringWithFormat:@"松手加载第%d页 共%@页", [m_CurrentPage integerValue] - 1, m_PageCount];
        s_refresh_header_view.refreshStatus = NO;
    }
    
    //加载完成去掉加载框
    if(s_bottom_reloading)
    {
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    else if(s_reloading)
    {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    else
    {
        self.m_BottomView.userInteractionEnabled = YES;
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 20){
        if (buttonIndex == 1) {
            BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
            exteriorURL.title = @"等级和水果介绍";
            exteriorURL.isShowCloseButton = NO;
            [exteriorURL setLoadURL:@"http://m.babytree.com/rule/level.php"];
            [self.navigationController pushViewController:exteriorURL animated:YES];
        }
        
    }
}

//#pragma mark - UIAlertView Delegate
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 退出
    if (alertView.tag == 10)
    {
        if (buttonIndex == 1)
        {
            if (self.presentingViewController)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    // 删除帖子
    else if (alertView.tag == 11)
    {
        if (buttonIndex==1)
        {
 
            m_ProgressHUD.mode = MBProgressHUDModeIndeterminate;
            [m_ProgressHUD setLabelText:@"删除中..."];
            [m_ProgressHUD show:YES];
            
            [m_DelTopicRequest clearDelegatesAndCancel];
            
            self.m_DelTopicRequest = [HMTopicDetailRequest delTopicAction:self.m_TopicID];
            [m_DelTopicRequest setDidFinishSelector:@selector(delTopicFinish:)];
            [m_DelTopicRequest setDidFailSelector:@selector(delTopicFail:)];
            [m_DelTopicRequest setDelegate:self];
            [m_DelTopicRequest startAsynchronous];
        }
    }
    // 举报帖子
    else if (alertView.tag == 12 && buttonIndex == 1)
    {
        NSString *floor = s_DetailData.m_TopicInfor.m_Floor;
        
        if (floor)
        {
 
            [m_ProgressHUD setLabelText:@"举报中..."];
            [m_ProgressHUD show:YES];
            
            if ([floor isEqualToString:@"0"])
            {
                [m_DelTopicRequest clearDelegatesAndCancel];
                
                self.m_DelTopicRequest = [HMTopicDetailRequest reportTopicAction:self.m_TopicID replyId:nil];
                [m_DelTopicRequest setDidFinishSelector:@selector(reportTopicFinish:)];
                [m_DelTopicRequest setDidFailSelector:@selector(reportTopicFail:)];
                [m_DelTopicRequest setDelegate:self];
                [m_DelTopicRequest startAsynchronous];
            }
            else
            {
                NSString *reply_id = s_DetailData.m_TopicInfor.m_ReplyID;
                
                [m_DelTopicRequest clearDelegatesAndCancel];
                
                self.m_DelTopicRequest = [HMTopicDetailRequest reportTopicAction:nil replyId:reply_id];
                [m_DelTopicRequest setDidFinishSelector:@selector(reportTopicFinish:)];
                [m_DelTopicRequest setDidFailSelector:@selector(reportTopicFail:)];
                [m_DelTopicRequest setDelegate:self];
                [m_DelTopicRequest startAsynchronous];
            }
        }
    }
}
*/

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.m_actionSheet = actionSheet;
    self.m_buttonIndex = buttonIndex;
    
    if (actionSheet.tag == 10 || actionSheet.tag == 11 || actionSheet.tag == 20 || actionSheet.tag == 21)
    {
        if ((actionSheet.tag == 20 || actionSheet.tag == 21) && buttonIndex == 0)
        {
            [MobClick event:@"discuz_v2" label:@"删除回帖"];
            NSInteger rank = 0;
            if ([BBUser getUserLevel])
            {
                rank = [[BBUser getUserLevel]integerValue];
            }

            if (rank<3)
            {
                [PXAlertView showAlertWithTitle:@"提示" message:@"您需要达到3级才可以删除自己回复的帖子" cancelTitle:@"取消" otherTitle:@"如何到达3级" completion:^(BOOL cancelled, NSInteger buttonIndex)
                 {
                     if (!cancelled)
                     {
                         BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
                         exteriorURL.title = @"等级和水果介绍";
                         [exteriorURL setLoadURL:@"http://m.babytree.com/rule/level.php"];
                         [self.navigationController pushViewController:exteriorURL animated:YES];
                     }
                 }];
            }
            else
            {
                [PXAlertView showAlertWithTitle:@"确认删除" message:@"您是否要删除您的回复？" cancelTitle:@"取消" otherTitle:@"删除" completion:^(BOOL cancelled, NSInteger buttonIndex)
                 {
                     if (!cancelled)
                     {
                         [self deleteMyReplyAction:s_DetailData.m_TopicInfor.m_ReplyID];
                     }
                 }];
            }
        }
        else if (((actionSheet.tag == 10 || actionSheet.tag == 11) && buttonIndex == 0) || ((actionSheet.tag == 20 || actionSheet.tag == 21) && buttonIndex == 1))
        {
            NSString *url = self.m_ShareUrl;
            if (![url isNotEmpty])
            {
                url = self.m_WebUrl;
            }
            if (![url isNotEmpty])
            {
                url = TOPIC_SHARE_URL_PAGE(self.m_TopicID);
            }
            
            if ([url isNotEmpty])
            {
                if (!m_ProgressHUD.isShow)
                {
                    [m_ProgressHUD show:YES withText:@"复制链接成功"];
                    [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                }
                [[UIPasteboard generalPasteboard] setString:url];
            }
            else
            {
                if (!m_ProgressHUD.isShow)
                {
                    [m_ProgressHUD show:YES withText:@"复制链接失败"];
                    [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                }
            }
        }
        else if ((buttonIndex == 1 && actionSheet.tag == 10) || (buttonIndex == 2 && actionSheet.tag == 20))
        {
            NSString *text = s_DetailData.m_TopicInfor.m_ContentText;
            
            if ([text isNotEmpty])
            {
                if (!m_ProgressHUD.isShow)
                {
                    [m_ProgressHUD show:YES withText:@"复制成功"];
                    [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                }
                [[UIPasteboard generalPasteboard] setString:text];
            }
            else
            {
                if (!m_ProgressHUD.isShow)
                {
                    [m_ProgressHUD show:YES withText:@"复制失败"];
                    [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                }
            }
        }
        else if ((actionSheet.tag == 10 && buttonIndex == 2 ) || (actionSheet.tag == 11 && buttonIndex == 1) || (actionSheet.tag == 20 && buttonIndex == 3 ) || (actionSheet.tag == 21 && buttonIndex == 2))
        {
            if(![BBUser isLogin])
            {
                [self goToLoginWithLoginType:LoginReportTopic];
                return;
            }

            NSString *floor = s_DetailData.m_TopicInfor.m_Floor;
            if (floor)
            {
                NSString *userName = s_DetailData.m_TopicInfor.m_UserName;

                if ([floor isEqualToString:@"0"] && [self.m_TopicID isNotEmpty])
                {
                    [MobClick event:@"discuz_v2" label:@"举报主帖"];
                    HMReportVC *vc = [[[HMReportVC alloc] initWithNibName:@"HMReportVC" bundle:nil withReportedName:userName topicID:self.m_TopicID replyID:nil floor:nil] ah_autorelease];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else if ([s_DetailData.m_TopicInfor.m_ReplyID isNotEmpty])
                {
                    [MobClick event:@"discuz_v2" label:@"举报回帖"];
                    NSString *reply_id = s_DetailData.m_TopicInfor.m_ReplyID;

                    HMReportVC *vc = [[[HMReportVC alloc] initWithNibName:@"HMReportVC" bundle:nil withReportedName:userName topicID:nil replyID:reply_id floor:floor] ah_autorelease];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }

        }
    }
    else  if (actionSheet.tag == 12)
    {
        if (buttonIndex == 0)
        {
            [MobClick event:@"discuz_v2" label:@"只看楼主"];
            // 只看楼主
            [self topicTypeClicked];
        }
        else if (buttonIndex == 1)
        {
            [MobClick event:@"discuz_v2" label:@"收藏帖子"];
            if(![BBUser isLogin])
            {
                [self goToLoginWithLoginType:LoginCollectTopic];
                return;
            }
            // 收藏
            [self topicCollectClicked];
        }
        else if (buttonIndex == 2)
        {
            if(![BBUser isLogin])
            {
                [self goToLoginWithLoginType:LoginReportTopic];
                return;
            }
            [MobClick event:@"discuz_v2" label:@"举报主帖"];
            // 举报楼主页面
            if ([self.m_TopicID isNotEmpty])
            {
                if (!s_DetailData)
                {
                    if (self.m_TopicDataList.count > 0)
                    {
                        s_DetailData = self.m_TopicDataList[0];
                    }
                }

                NSString *userName = s_DetailData.m_TopicInfor.m_UserName;

                HMReportVC *vc = [[[HMReportVC alloc] initWithNibName:@"HMReportVC" bundle:nil withReportedName:userName topicID:self.m_TopicID replyID:nil floor:nil] ah_autorelease];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if (buttonIndex == 3)
        {
            // 复制链接
            NSString *url = self.m_ShareUrl;
            if (![url isNotEmpty])
            {
                url = self.m_WebUrl;
            }
            if (![url isNotEmpty])
            {
                url = TOPIC_SHARE_URL_PAGE(self.m_TopicID);
            }
            
            if ([url isNotEmpty])
            {
                if (!m_ProgressHUD.isShow)
                {
                    [m_ProgressHUD show:YES withText:@"复制链接成功"];
                    [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                }
                [[UIPasteboard generalPasteboard] setString:url];
            }
            else
            {
                if (!m_ProgressHUD.isShow)
                {
                    [m_ProgressHUD show:YES withText:@"复制链接失败"];
                    [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                }
            }
        }
    }
}

#pragma mark -
#pragma mark DeleteMyReply

- (void)deleteMyReplyAction:(NSString *)replyID
{
    if (replyID)
    {
        [m_ProgressHUD show:YES withText:@"删除中..."];

        [m_DelTopicRequest clearDelegatesAndCancel];

        self.m_DelTopicRequest = [HMApiRequest delMyReply:replyID];
        [self.m_DelTopicRequest setDidFinishSelector:@selector(deleteReplyFinish:)];
        [self.m_DelTopicRequest setDidFailSelector:@selector(delTopicFail:)];
        [self.m_DelTopicRequest setDelegate:self];
        [self.m_DelTopicRequest startAsynchronous];
    }
}


#pragma mark -
#pragma mark DelTopicRequest

//删除帖子请求
- (void)delTopicFinish:(ASIFormDataRequest *)request
{
    //[m_ProgressHUD hide:YES];
    //确认删除帖子？删除后不能恢复。
    NSString *responseString = [request responseString];
    NSDictionary *jsonData = [responseString objectFromJSONString];
    if (![jsonData isDictionaryAndNotEmpty])
    {
        [m_ProgressHUD show:YES withText:@"删除失败"];
        [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        return;
    }
    
    if ([[jsonData stringForKey:@"status"] isEqualToString:@"success"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_PERSON_POST object:nil];
        
        [self goBack];
        
        return;
    }
    else if([[jsonData stringForKey:@"status"] isEqualToString:@"nonLogin"])
    {
        [m_ProgressHUD show:YES withText:@"您未登陆"];
        [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        return;
    }
    else if([[jsonData stringForKey:@"status"] isEqualToString:@"invalidParams"])
    {
        [m_ProgressHUD show:YES withText:@"删除失败"];
        [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        return;
    }
    else
    {
        [m_ProgressHUD show:YES withText:@"积分不足删除失败"];
        [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        return;
    }
}

- (void)delTopicFail:(ASIFormDataRequest *)request
{
    [m_ProgressHUD show:YES withText:@"删除失败"];
    [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}

//删除帖子请求
- (void)deleteReplyFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *jsonData = [responseString objectFromJSONString];
    if (![jsonData isDictionaryAndNotEmpty])
    {
        [m_ProgressHUD show:YES withText:@"删除失败"];
        [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];

        return;
    }

    if ([[jsonData stringForKey:@"status"] isEqualToString:@"success"])
    {
        NSDictionary *dic = [request getPostValueFromKey:@"reply_id"];
        NSString *replyID = [dic stringForKey:@"value"];

        if ([replyID isNotEmpty])
        {
            [self deleteReplyWithReplyID:replyID];
        }

        [m_ProgressHUD hide:YES];

        return;
    }
    else
    {
        [m_ProgressHUD show:YES withText:[[jsonData dictionaryForKey:@"data"]stringForKey:@"message"]];
        [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
}

- (void)deleteReplyWithReplyID:(NSString *)replyID
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    BOOL addFirst = NO;
    NSInteger row = -1, index = 0;

    for (HMTopicDetailCellClass *topicDetailCellClass in self.m_TopicDataList)
    {
        if ([topicDetailCellClass.m_TopicInfor.m_ReplyID isEqual:replyID])
        {
            if (topicDetailCellClass.m_Type == TOPICDETAILCELL_REPLYHEADER_TYPE)
            {
                row = index;
                addFirst = YES;
                [array addObject:topicDetailCellClass];
            }
            else if (topicDetailCellClass.m_Type == TOPICDETAILCELL_REPLYFLOOR_TYPE)
            {
                addFirst = NO;
                [array addObject:topicDetailCellClass];
            }
            else if (addFirst)
            {
                addFirst = NO;
                topicDetailCellClass.m_Type = TOPICDETAILCELL_TEXTCONTENT_TYPE;
                topicDetailCellClass.m_LinkType = HMTopicDetailCellView_LinkType_None;
                topicDetailCellClass.m_ReplyInfor = nil;

                topicDetailCellClass.m_Text = @"该内容已被回帖用户删除";
                [topicDetailCellClass calcTextHeight];
                
                [array addObject:topicDetailCellClass];
            }
        }
        else
        {
            [array addObject:topicDetailCellClass];
        }

        index++;
    }

    self.m_TopicDataList = array;

    [self.m_TopicTableView reloadData];

    [self freshBottom_refresh];

    if (row != -1)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [m_TopicTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark - HMTDBottomViewDelegate

- (void)openReplyMaster
{
    [self.m_ReplyView showWithFloor:@"" referID:nil isJoin:m_AddCircleStatus groupId:self.m_CircleID floorName:self.m_MasterName];
}

- (void)loadPrePage
{
    if(!s_reloading && !s_bottom_reloading)
    {
        s_reloading = YES;
        self.m_BottomView.userInteractionEnabled = NO;
        
        [self freshTopicData:-1];
    }
}

-(void)loadNextPage
{
    if(!s_reloading && !s_bottom_reloading)
    {
        s_bottom_reloading = YES;
        self.m_BottomView.userInteractionEnabled = NO;
        [self freshTopicData:1];
    }
}

-(void)loadPageOfNumber:(NSInteger)page
{
    NSInteger pageNum = [m_CurrentPage intValue];
    
    if (pageNum != page)
    {
        pageNum = page - pageNum;
        
        if(!s_reloading && !s_bottom_reloading && pageNum != 0)
        {
            if (pageNum > 0)
            {
                s_bottom_reloading = YES;
            }
            else
            {
                s_reloading = YES;
            }
            self.m_BottomView.userInteractionEnabled = NO;
            [self freshTopicData:pageNum];
        }
    }
}


#pragma mark - HMReplyTopicDelegate
// 发送回复成功，跳到最后一楼
-(void)didReplySuccess:(NSDictionary *)data
{
    // 在最后一页回复时刷新，其他页不刷
    if (![m_CurrentPage isEqualToString:m_PageCount])
    {
        return;
    }
    
    NSString *pageCount = [data stringForKey:@"pg"];
    NSString *position = [data stringForKey:@"position"];
    
    self.m_ReplyFloor = 0;
    
    if ([pageCount isNotEmpty])
    {
        self.m_PageCount = pageCount;
        
        if ([position isNotEmpty])
        {
            NSInteger floor = [position integerValue];
            NSInteger page = [pageCount integerValue];
            
            if (floor > page*20 && floor <= (page+1)*20)
            {
                self.m_ReplyFloor = floor;
            }
        }
    }
    
    NSInteger count = [m_PageCount integerValue];
    NSInteger pageNum = [m_CurrentPage integerValue];
    
    self.m_IsReply = YES;
    s_bottom_reloading = YES;
    
    [self freshTopicData:count-pageNum];
}

// 键入圈子成功，刷新一下状态吧
-(void)refreshAboutAddCircleStatus
{
    self.m_AddCircleStatus = YES;
}

// 获取帖子来自圈子的ID
-(NSString *)topicFromGroupId
{
    return self.m_CircleID;
}

#pragma mark -
#pragma mark HMTopicDetailCellDelegate
#pragma mark reply floor and delete topic delegate

-(void)replyFloorDelegate:(NSString*)replyFloor withReplyID:(NSString *)replyFloorID
{
    [self showBar:NO];
    
    [self.m_ReplyView showWithFloor:replyFloor referID:replyFloorID isJoin:m_AddCircleStatus groupId:self.m_CircleID];
}

-(void)deleteTopicClicked
{
    //    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除帖子？删除后不能恢复。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil] ah_autorelease];
    //    alertView.tag = 11;
    //    [alertView show];
    
    if ([self.s_UserRank integerValue] < 3)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认信息" message:@"您需要达到3级才可以删除自己发布的帖子" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"如何到达3级",nil];
        alertView.tag=20;
        [alertView show];
        
    }
    else
    {
        [PXAlertView showAlertWithTitle:@"提示" message:@"确认删除帖子？删除后不能恢复。" cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex)
         {
             if (!cancelled)
             {
                 [m_ProgressHUD show:YES withText:@"删除中..."];

                 [m_DelTopicRequest clearDelegatesAndCancel];
                 
                 self.m_DelTopicRequest = [HMApiRequest delTopicAction:self.m_TopicID];
                 [m_DelTopicRequest setDidFinishSelector:@selector(delTopicFinish:)];
                 [m_DelTopicRequest setDidFailSelector:@selector(delTopicFail:)];
                 [m_DelTopicRequest setDelegate:self];
                 [m_DelTopicRequest startAsynchronous];
             }
         }];
    }
    
}

- (void)hideBackButtom
{
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem ah_release];
}

- (void)topicClicked:(HMTopicDetailCellClass *)detailData isLong:(BOOL)isLong
{
//    if (!isLong)
//    {
//        return;
//    }

    s_DetailData = detailData;
    
    NSString *message1 = @"复制链接";
    NSString *message2 = nil;
    NSString *message3 = nil;
    NSString *message4 = nil;

    NSString *floor = s_DetailData.m_TopicInfor.m_Floor;
    NSString *copytext = s_DetailData.m_TopicInfor.m_ContentText;
    
    if (floor)
    {
        if ([floor isEqualToString:@"0"])
        {
            message2 = @"复制楼主内容";
            message3 = @"举报楼主内容";
        }
        else
        {
            message2 = @"复制回复内容";
            message3 = @"举报回复内容";

            NSString *userId = s_DetailData.m_TopicInfor.m_UserId;

            if ([[BBUser getEncId] isEqual:userId])
            {
                message4 = @"删除回复内容";
            }
        }
        
        UIActionSheet *actionSheet;

        if ([message4 isNotEmpty])
        {
            if ([copytext isNotEmpty])
            {
                actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:message4, message1, message2, message3, nil] ah_autorelease];
                [actionSheet setTag:20];
            }
            else
            {
                actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:message4, message1, message3, nil] ah_autorelease];
                [actionSheet setTag:21];
            }
        }
        else
        {
            if ([copytext isNotEmpty])
            {
                actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:message1, message2, message3, nil] ah_autorelease];
                [actionSheet setTag:10];
            }
            else
            {
                actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:message1, message3, nil] ah_autorelease];
                [actionSheet setTag:11];
            }
        }
        
        [actionSheet showInView:self.view];
    }
}

- (NSString *)theTopicIdAboutDetail
{
    return self.m_TopicID;
}

-(void)pressLoveButton
{
    //    if (loveRequest!=nil)
    //    {
    //        [loveRequest clearDelegatesAndCancel];
    //    }
    //
    //    self.loveRequest = [HMTopicRequest lovetTopicWithID:self.m_TopicID];
    //    [loveRequest setDelegate:self];
    //    [loveRequest setDidFinishSelector:@selector(loveTopicFinished:)];
    //    [loveRequest setDidFailSelector:@selector(loveTopicFail:)];
    //    [loveRequest startAsynchronous];
}

- (void)closeMJPhotoShow
{
    if (self.m_PicRow != -1)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.m_PicRow inSection:0];
        
        s_PositionToFloor = YES;
        [m_TopicTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        self.m_PicRow = -1;
    }
}

- (void)setFloorWithPicIndex:(NSInteger)index
{
    self.m_PicRow = -1;

    NSInteger row;
    BOOL bFound = NO;

    if (index >= 0 && index < self.m_PicsList.count)
    {
        NSString *imageUrl = self.m_PicsList[index];

        for (row=0; row<m_TopicDataList.count; row++)
        {
            HMTopicDetailCellClass *topicDetailCellClass = m_TopicDataList[row];

            if (topicDetailCellClass.m_Type != TOPICDETAILCELL_IMAGECONTENT_TYPE && topicDetailCellClass.m_Type != TOPICDETAILCELL_IMAGELINK_TYPE)
            {
                continue;
            }

            if ([topicDetailCellClass.m_ImageUrl isEqual:imageUrl])
            {
                bFound = YES;
                break;
            }
        }

        if (bFound)
        {
            self.m_PicRow = row;
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//
//            [m_TopicTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
}

- (void)setFloorWithTopicId:(NSString *)topicId floor:(NSInteger)floor
{
    if ([topicId isEqualToString:m_TopicID])
    {
        self.m_PositionFloor = floor;

        [self freshTopicData:0];
    }
    else
    {
        [BBStatistic visitType:BABYTREE_TYPE_TOPIC_IN_TOPIC contentId:topicId];
        [HMShowPage showTopicDetail:self topicId:topicId topicTitle:nil positionFloor:floor];
    }
}

#pragma mark -
#pragma mark CollectTopicRequest

- (void)collectTopicFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *jsonData = [responseString objectFromJSONString];
    if (![jsonData isDictionaryAndNotEmpty])
    {
        if (m_IsCollected)
        {
            [m_ProgressHUD show:YES withText:@"取消收藏失败"];
        }
        else
        {
            [m_ProgressHUD show:YES withText:@"收藏失败"];
        }

        [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        return;
    }

    NSString *status = [jsonData stringForKey:@"status"];
    if ([status isEqualToString:@"success"] || [status isEqualToString:@"0"])
    {
        
        m_IsCollected = !m_IsCollected;
        
        m_ProgressHUD.mode = MBProgressHUDModeText;
        if (m_IsCollected)
        {
            [m_ProgressHUD setLabelText:@"收藏成功"];
        }
        else
        {
            [m_ProgressHUD setLabelText:@"取消收藏成功"];
        }
        
        NSArray *values = [NSArray arrayWithObjects:self.m_TopicID, [NSString stringWithFormat:@"%d",m_IsCollected], nil];
        NSArray *keys = [NSArray arrayWithObjects:@"topic_id", @"collect_state",nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_PERSON_COLLECT object:dic];
        
        m_ProgressHUD.color = nil;
        [m_ProgressHUD show:YES];
        [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
    else
    {
        if (m_IsCollected)
        {
            [m_ProgressHUD show:YES withText:[jsonData stringForKey:@"message" defaultString:@"取消收藏失败"]];
        }
        else
        {
            [m_ProgressHUD show:YES withText:[jsonData stringForKey:@"message" defaultString:@"收藏失败"]];
        }
        

        [m_ProgressHUD show:YES withText:[jsonData stringForKey:@"message" defaultString:@"操作失败"]];
        [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
}

- (void)collectTopicFail:(ASIFormDataRequest *)request
{
    if (m_IsCollected)
    {
        [m_ProgressHUD show:YES withText:@"取消收藏失败"];
    }
    else
    {
        [m_ProgressHUD show:YES withText:@"收藏失败"];
    }
    [m_ProgressHUD hide:YES afterDelay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}

#pragma mark -
#pragma mark UMShare Methods

- (void)makeShareData
{
    self.m_ShareData = [[[NSMutableArray alloc] init] ah_autorelease];
    
    NSDictionary *shareToFriendCircle = [NSDictionary dictionaryWithObjectsAndKeys:@"朋友圈", @"title", @"share_pengyouquan", @"imageName", UMShareToWechatTimeline, @"shareTo", nil];
    NSDictionary *shareToWeixin = [NSDictionary dictionaryWithObjectsAndKeys:@"微信", @"title", @"share_weixin", @"imageName", UMShareToWechatSession, @"shareTo", nil];
    NSDictionary *shareToSina = [NSDictionary dictionaryWithObjectsAndKeys:@"新浪微博", @"title", @"share_sina", @"imageName", UMShareToSina, @"shareTo", nil];
    NSDictionary *shareToQQ = [NSDictionary dictionaryWithObjectsAndKeys:@"QQ空间", @"title", @"share_qqzone", @"imageName", UMShareToQzone, @"shareTo", nil];
    NSDictionary *shareToTencent = [NSDictionary dictionaryWithObjectsAndKeys:@"腾讯微博", @"title", @"share_tencent_weibo", @"imageName", UMShareToTencent,@"shareTo", nil];
    NSDictionary *shareToSms = [NSDictionary dictionaryWithObjectsAndKeys:@"短信", @"title", @"share_sms", @"imageName", UMShareToSms, @"shareTo", nil];
    //    NSDictionary *shareToEmail =  [NSDictionary dictionaryWithObjectsAndKeys:@"邮件", @"title", @"share_renren0", @"imageName", UMShareToEmail, @"shareTo", nil];
    //    NSDictionary *shareToRenren =  [NSDictionary dictionaryWithObjectsAndKeys:@"人人", @"title", @"share_renren", @"imageName", UMShareToRenren, @"shareTo", nil];
    [self.m_ShareData addObject:shareToFriendCircle];
    [self.m_ShareData addObject:shareToWeixin];
    [self.m_ShareData addObject:shareToSina];
    [self.m_ShareData addObject:shareToQQ];
    [self.m_ShareData addObject:shareToTencent];
    [self.m_ShareData addObject:shareToSms];
    //    [self.shareData addObject:shareToEmail];
    //    [self.m_ShareData addObject:shareToRenren];
}


#pragma mark -
#pragma mark ShareMenuDelegate

- (void)shareMenu:(BBShareMenu *)shareMenu clickItem:(BBShareMenuItem *)item
{
    NSString *loadURL = self.m_ShareUrl;
    if (![loadURL isNotEmpty])
    {
        loadURL = self.m_WebUrl;
    }
    if (![loadURL isNotEmpty])
    {
        loadURL = TOPIC_SHARE_URL_PAGE(self.m_TopicID);
    }
    
    if(![self.m_summary isNotEmpty])
    {
        self.m_summary = @"";
    }

    NSString *shareText = [NSString stringWithFormat:@"【%@】%@", self.m_TopicTitle,self.m_summary];
    
    // 没有标题没有正文  是分享图片
    if (![self.m_summary isNotEmpty] && self.m_TopicTitle.length ==0)
    {
        shareText = [NSString stringWithFormat:@"【分享图片】...  "];
    }
    else if (self.m_TopicTitle.length == 0)
    {
        shareText = [NSString stringWithFormat:@"%@...  ",self.m_summary];
    }
    
    NSString *shareText1 = self.m_summary;
    if (self.m_TopicTitle.length ==0 && self.m_summary.length == 0)
    {
        shareText1 = @"分享图片";
    }
    
    UIImage *shareImage = [UIImage imageNamed:@"topic_share_icon"];
    if (self.m_ShareImage && self.m_ShareImage.image)
    {
        shareImage = self.m_ShareImage.image;
    }
    
    NSString *shareWXTimelineTitle;
    if (self.m_TopicTitle.length == 0)
    {
        shareWXTimelineTitle = shareText1;
    }
    else
    {
        shareWXTimelineTitle = self.m_TopicTitle;
    }
    
    NSString *shareWXSessionTitle;
    if (self.m_TopicTitle.length == 0)
    {
       shareWXSessionTitle = @"《宝宝树孕育》";
    }
    else
    {
        shareWXSessionTitle = self.m_TopicTitle;
    }
    
    NSLog(@"title %@",shareText);
    [BBShareContent shareContent:item withViewController:self withShareText:shareText withShareOriginImage:shareImage withShareWXTimelineTitle:shareWXTimelineTitle withShareWXTimelineDescription:@"" withShareWXSessionTitle:shareWXSessionTitle withShareWXSessionDescription:shareText1 withShareWebPageUrl:loadURL];
}

- (void)shareMenuClose:(BBShareMenu *)shareMenu
{
    s_ShareMenu = nil;
}

#pragma mark -
#pragma mark HMNoDataViewDelegate

- (void)freshFromNoDataView
{
    [self freshTopicData:0];
}

#pragma mark -
#pragma mark loginDelegate  and method

- (void)goToLoginWithLoginType:(LoginType)theLoginType
{
    BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
    login.m_LoginType = BBPresentLogin;
    BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
    [navCtrl setColorWithImageName:@"navigationBg"];
    self.s_LoginType = theLoginType;
    login.delegate = self;
    [self  presentViewController:navCtrl animated:YES completion:^{
        
    }];
    return ;
}


-(void)loginFinish
{
    if (self.s_LoginType == LoginReportTopic)
    {
        if ((self.m_actionSheet.tag == 10 && self.m_buttonIndex == 2 ) || (self.m_actionSheet.tag == 11 && self.m_buttonIndex == 1))
        {
            NSString *floor = s_DetailData.m_TopicInfor.m_Floor;
            if (floor)
            {
                NSString *userName = s_DetailData.m_TopicInfor.m_UserName;

                if ([floor isEqualToString:@"0"] && [self.m_TopicID isNotEmpty])
                {
                    [MobClick event:@"discuz_v2" label:@"举报主帖"];
                    HMReportVC *vc = [[[HMReportVC alloc] initWithNibName:@"HMReportVC" bundle:nil withReportedName:userName topicID:self.m_TopicID replyID:nil floor:nil] ah_autorelease];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else if ([s_DetailData.m_TopicInfor.m_ReplyID isNotEmpty])
                {
                    [MobClick event:@"discuz_v2" label:@"举报回帖"];
                    NSString *reply_id = s_DetailData.m_TopicInfor.m_ReplyID;

                    HMReportVC *vc = [[[HMReportVC alloc] initWithNibName:@"HMReportVC" bundle:nil withReportedName:userName topicID:nil replyID:reply_id floor:floor] ah_autorelease];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
        else  if (self.m_actionSheet.tag == 12 && self.m_buttonIndex == 2)
        {
            [MobClick event:@"discuz_v2" label:@"举报主帖"];
            // 举报楼主页面
            if ([self.m_TopicID isNotEmpty])
            {
                if (!s_DetailData)
                {
                    if (self.m_TopicDataList.count > 0)
                    {
                        s_DetailData = self.m_TopicDataList[0];
                    }
                }

                NSString *userName = s_DetailData.m_TopicInfor.m_UserName;

                HMReportVC *vc = [[[HMReportVC alloc] initWithNibName:@"HMReportVC" bundle:nil withReportedName:userName topicID:self.m_TopicID replyID:nil floor:nil] ah_autorelease];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    else if (self.s_LoginType == LoginCollectTopic)
    {
         [self topicCollectClicked];
    }
}

@end

