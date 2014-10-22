//
//  HMCircleTopicVC.m
//  lama
//
//  Created by jiangzhichao on 14-4-17.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMCircleTopicVC.h"
#import "HMCircleTopicHeaderView.h"
#import "HMTopicClass.h"
#import "HMTopicListCell.h"
#import "HMShowPage.h"
#import "BBConfigureAPI.h"
#import "HMNavigation.h"
#import "HMCreateTopicViewController.h"
#import "BBAppInfo.h"
#import "BBCustemSegment.h"
#import "BBCircleAdminList.h"
#import "BBCircleMember.h"
#import "BBHospitalIntroduce.h"
#import "BBEditPersonalViewController.h"
#import "HMMoreCircleVC.h"
#import "BBMessageChat.h"

#define TOP_BTN_START_TAG 100

@interface HMCircleTopicVC ()
<
    HMCircleTopicHeaderViewDelegate,
    BBLoginDelegate
>

@property (nonatomic, strong) UIButton *s_TitleTriAngelBtn;
@property (nonatomic, strong) HMCircleTopicHeaderView *s_HeaderView;

@property (nonatomic, strong) UIImageView *s_TopBgImgView;
@property (nonatomic, strong) UIImageView *s_TopBtnBgImgView;
@property (nonatomic, strong) NSMutableArray *s_TopBtnArray;

@property (assign, nonatomic) LoginType s_LoginType;

@property (nonatomic, strong) MBProgressHUD *s_AddCircleHUD;

@property (assign) NSInteger s_Mark;
@property (nonatomic, strong) BBCustemSegment *s_Segmented;
@end

@implementation HMCircleTopicVC
{
    BOOL isShowTopBtn;
    //判断是否是发新帖要求加入圈子
    BOOL isAddFromAlertView;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DIDCHANGE_CIRCLE_JOIN_STATE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.s_Mark = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCircleJoinState:) name:DIDCHANGE_CIRCLE_JOIN_STATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshData) name:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];
//    self.umeng_VCname = @"圈子话题";
    [self setNavBar:@"帖子列表" bgColor:nil leftTitle:nil leftBtnImage:@"backButton" leftToucheEvent:@selector(backAction:) rightTitle:nil rightBtnImage:@"thecircletopic_writenewtopic_nav" rightToucheEvent:@selector(writeNewTopicClicked:)];
    
    self.s_AddCircleHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.s_AddCircleHUD];
    
    // titleView
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(135, 14, 1, 16)];
    lineImgView.image = [UIImage imageNamed:@"listmenu_line"];
    [self.navigationItem.titleView addSubview:lineImgView];
    
    self.s_TitleTriAngelBtn = [[UIButton alloc] initWithFrame:CGRectMake(135, 0, 24, 44)];
    self.s_TitleTriAngelBtn.exclusiveTouch = YES;
    [self.s_TitleTriAngelBtn setImage:[UIImage imageNamed:@"listmenu_down_btn1"] forState:UIControlStateNormal];
    [self.s_TitleTriAngelBtn addTarget:self action:@selector(clickTitleView) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:self.s_TitleTriAngelBtn];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTitleView)];
    tapRecognizer.cancelsTouchesInView = YES;
    [self.navigationItem.titleView addGestureRecognizer:tapRecognizer];
    self.navigationItem.titleView.userInteractionEnabled = YES;
    self.navigationItem.titleView.exclusiveTouch = YES;

    // topicStyle
    self.s_TopBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -44, UI_SCREEN_WIDTH, 44)];
    self.s_TopBgImgView.userInteractionEnabled = YES;
    self.s_TopBgImgView.image = [[UIImage imageNamed:@"head_tab_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 3, 3)];
    [self.view addSubview:self.s_TopBgImgView];
    
    self.s_TopBtnBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 320, 26)];
    self.s_TopBtnBgImgView.userInteractionEnabled = YES;
    [self.s_TopBgImgView addSubview:self.s_TopBtnBgImgView];
    //列表右滑返回
    UISwipeGestureRecognizer *recognizer= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backAction:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.m_Table addGestureRecognizer:recognizer];
    self.m_Table.exclusiveTouch = YES;
    [self freshData];
}


-(void)addTopicListHeadSegment
{
    if (self.s_Segmented)
    {
        return;
    }
    __weak __typeof (self) weakself = self;
    
    NSArray *items = @[@{@"text":@"最后回复"},
                       @{@"text":@"最新帖子"},
                       @{@"text":@"只看精华"},
                       @{@"text":@"只看同城"}];
    if (self.s_HeaderView.m_IsHospital)
    {
        items = @[@{@"text":@"最后回复"},
                  @{@"text":@"最新帖子"},
                  @{@"text":@"只看精华"}];
    }

    self.s_Segmented = [[BBCustemSegment alloc] initWithFrame:CGRectMake(10, 0, 300, 26)
                                                                items:items
                                                    andSelectionBlock:^(NSUInteger segmentIndex) {
                                                        __strong __typeof (weakself) strongself = weakself;
                                                        if (strongself) {
                                                            
                                                            
                                                            if (strongself.s_Mark == segmentIndex) {
                                                                return;
                                                            }
                                                            if (segmentIndex == 0)
                                                            {
                                                                strongself.m_TopicStyle = POPLIST_LASTREPLY;
                                                                [MobClick event:@"discuz_v2" label:@"最后回复点击"];
                                                                
                                                            }
                                                            else if (segmentIndex == 1)
                                                            {
                                                                strongself.m_TopicStyle = POPLIST_NEWEST;
                                                                [MobClick event:@"discuz_v2" label:@"最新发布点击"];
                                                                
                                                            }
                                                            else if (segmentIndex == 2)
                                                            {
                                                                strongself.m_TopicStyle = POPLIST_ONLYGOOD;
                                                                [MobClick event:@"discuz_v2" label:@"只看精华点击"];
                                                            }
                                                            else if (segmentIndex == 3)
                                                            {
                                                                [MobClick event:@"discuz_v2" label:@"只看同城点击"];
                                                                if (![[BBUser getUserOnlyCity] isNotEmpty])
                                                                {
                                                                    BBSelectMoreArea *selectMoreArea = [[BBSelectMoreArea alloc]initWithNibName:@"BBSelectMoreArea" bundle:nil];
                                                                    selectMoreArea.selectAreaCallBackHander = strongself;
                                                                    [strongself.navigationController pushViewController:selectMoreArea animated:YES];
                                                                    return;
                                                                }
                                                                strongself.m_TopicStyle = POPLIST_ONLYCITY;
                                                            }
                                                            strongself.s_Mark = segmentIndex;
                                                            
                                                            [strongself.m_Table setContentOffset:CGPointMake(0, 0)];
                                                            
                                                            [strongself freshData];
                                                        }
                                                    }];
    self.s_Segmented.color = [UIColor whiteColor];
    self.s_Segmented.borderWidth = 1.f;
    self.s_Segmented.borderColor = [UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1];
    self.s_Segmented.selectedColor = [UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1];
    self.s_Segmented.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1]};
    self.s_Segmented.selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                         NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.s_TopBtnBgImgView addSubview:self.s_Segmented];
}



- (IBAction)backAction:(id)sender
{
    if (self.isSetHospitial)
    {
        //isSetHospitial=YES 表示从设置为我的医院途径进来的,目前有编辑页面和我的圈两个途径进入，所以这个时候返回编辑资料页或我的圈列表
        BOOL isPopToSpecificVC = NO;
        for (UIViewController *viewCtrl in [self.navigationController viewControllers])
        {
            if ([viewCtrl isKindOfClass:[BBEditPersonalViewController class]] || [viewCtrl isKindOfClass:[HMMoreCircleVC class]])
            {
                isPopToSpecificVC = YES;
                [self.navigationController popToViewController:viewCtrl animated:YES];
                break;
            }
        }
        if (!isPopToSpecificVC)
        {
            //容错处理，找不到特定返回页面，返回上一级页面
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        BBAppDelegate *appDelegate = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
        if(appDelegate.m_bobyBornFinish)
        {
            // 跳转到我的圈
            for (UINavigationController *nav in self.navigationController.viewControllers)
            {
                [nav dismissViewControllerAnimated:NO completion:^{
                    
                }];
            }
            
            if (!appDelegate.m_mainTabbar)
            {
                appDelegate.m_mainTabbar = [[BBMainTabBar alloc]init];
            }
            [appDelegate.m_mainTabbar addViewControllers];
            [appDelegate.m_mainTabbar selectedTabWithIndex:1];
            appDelegate.window.rootViewController = appDelegate.m_mainTabbar;
            appDelegate.m_bobyBornFinish = NO;
        }
        else
        {
            //其它情况返回上一级页面
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"discuz_v2" label:@"帖子列表页pv"];
    [ApplicationDelegate checkDisplayOperateGuide:GUIDE_SHOW_TOPIC_PAGE];
    [self.navigationController setNavigationBarHidden:NO];
    if (![[BBUser getUserOnlyCity] isNotEmpty] && self.s_Segmented)
    {
        [self.s_Segmented setEnabled:YES forSegmentAtIndex:self.s_Mark];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [ApplicationDelegate clickGuideImageAction];
    [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMTopicClass *class = [self.m_Data objectAtIndex:indexPath.row];
    return class.m_CellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMTopicClass *class = [self.m_Data objectAtIndex:indexPath.row];
    // 置顶帖
    static NSString *cellName = @"HMTopicListCell";
    HMTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HMTopicListCell" owner:self options:nil] lastObject];
        [cell makeCellStyle];
    }
    
    [cell setTopicCellData:class topicType:self.m_TopicStyle];

    return cell;
}

- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableViews deselectRowAtIndexPath:indexPath animated:NO];
    
    HMTopicClass *topicClass = [self.m_Data objectAtIndex:indexPath.row];
    
    NSString *tid = topicClass.m_TopicId;
    
    NSString *title = topicClass.m_Title;
    [BBStatistic visitType:BABYTREE_TYPE_TOPIC_GROUP contentId:tid];
    [HMShowPage showTopicDetail:self topicId:tid topicTitle:title];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    if (isShowTopBtn)
    {
        [self hideOrShowTopBtn];
        //isShowTopBtn = !isShowTopBtn;
    }
}


#pragma mark - freshData Request

- (void)freshData
{
    [super freshData];
    
    [self loadNextData];
}

- (void)loadNextData
{
    [super loadNextData];
    
    if (s_CanLoadNextPage)
    {
        [self.m_DataRequest clearDelegatesAndCancel];
        self.m_DataRequest = [HMApiRequest theCircleTopicListwithStart:s_BakLoadedPage withGroupID:self.m_CircleClass.circleId listType:self.m_TopicStyle defaultType:1];
        [self.m_DataRequest setDelegate:self];
        [self.m_DataRequest setDidFinishSelector:@selector(loadDataFinished:)];
        [self.m_DataRequest setDidFailSelector:@selector(loadDataFail:)];
        [self.m_DataRequest startAsynchronous];
        
        [self.m_ProgressHUD show:YES showBackground:NO];
    }
    else
    {
        [self hideEGORefreshView];
    }
}

- (void)loadDataFinished:(ASIHTTPRequest *)request
{
    [self.m_ProgressHUD hide:YES];
    [self hideEGORefreshView];
    
    NSString *responseString = [request responseString];
    NSDictionary *allData = [responseString objectFromJSONString];
    if (![allData isDictionaryAndNotEmpty])
    {
        if (self.m_Data.count == 0)
        {
            self.m_NoDataView.m_Type = HMNODATAVIEW_DATAERROR;
            self.m_NoDataView.hidden = NO;
        }
        else if ([self isVisible])
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }
        return ;
    }
    
    NSString *status = [allData stringForKey:@"status"];
    if ([status isEqualToString:@"success"])
    {
        NSDictionary *data  = [allData dictionaryForKey:@"data"];
        
        NSDictionary *groupInfo = [data dictionaryForKey:@"group_info"];

        NSMutableArray *dingTopicArray = [[NSMutableArray alloc] init];
        NSArray *topicList = [data arrayForKey:@"list"];
        
        if (s_LoadedPage == 0)
        {
            self.m_Table.tableHeaderView = nil;
            
            [self.m_Data removeAllObjects];
            [dingTopicArray removeAllObjects];
        }
        
        for (NSDictionary *clumn in topicList)
        {
            if (![clumn isDictionaryAndNotEmpty])
            {
                continue;
            }
            if ([clumn boolForKey:@"is_top"])
            {
                [dingTopicArray addObject:clumn];
            }
            else
            {
                HMTopicClass *item = [[HMTopicClass alloc] init];
                
                item.m_TopicId = [clumn stringForKey:@"id"];
                
                // 去重操作
                BOOL isExisted = NO;
                NSArray *array = [self.m_Data lastArrayWithCount:DUPLICATE_COMPARECOUNT];
                for (HMTopicClass *item1 in array)
                {
                    if ([item.m_TopicId isEqualToString:item1.m_TopicId])
                    {
                        isExisted = YES;
                        break;
                    }
                }
                if (isExisted)
                {
                    continue;
                }
                
                if ([clumn boolForKey:@"is_top"])
                {
                    item.m_Mark = TopicMark_Top;
                }
                if ([clumn boolForKey:@"is_new"])
                {
                    item.m_Mark |= TopicMark_New;
                }
                if ([clumn boolForKey:@"is_elite"])
                {
                    item.m_Mark |= TopicMark_Extractive;
                }
                if ([clumn boolForKey:@"is_question"])
                {
                    item.m_Mark |= TopicMark_Help;
                }
                if ([clumn boolForKey:@"has_pic"])
                {
                    item.m_Mark |= TopicMark_HasPic;
                }

                item.m_Title = [clumn stringForKey:@"title"];
                item.m_MasterName = [clumn stringForKey:@"author_name"];
                item.m_CreateTime = [clumn intForKey:@"create_ts"];
                item.m_ResponseTime = [clumn intForKey:@"last_response_ts"];
                item.m_UserSign = [clumn stringForKey:@"active_user_avater"];
                if (item.m_ResponseTime == 0)
                {
                    item.m_ResponseTime = item.m_CreateTime;
                }
                item.m_ResponseCount = [clumn intForKey:@"response_count"];
                
                // 图片数组
                NSArray *photoArr = [clumn arrayForKey:@"photo_list"];
                if ([photoArr count] > 0)
                {
                    BOOL catchRec = NO;
                    NSMutableArray *picArr = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *dict in photoArr)
                    {
                        if (picArr.count > 2)
                        {
                            break;
                        }
                        NSDictionary *innerDict = [dict dictionaryForKey:@"middle"];
                        NSString *photoStr = [innerDict stringForKey:@"url"];
                        if (!catchRec)
                        {
                            item.m_PicHeight = [innerDict floatForKey:@"height"];
                            item.m_PicWidth = [innerDict floatForKey:@"width"];
                        }
                        catchRec = YES;
                        
                        if (photoStr)
                        {
                            [picArr addObject:photoStr];
                        }
                    }
                    item.m_PicArray = picArr;
                }
                
                [item calcHeight];
                [self.m_Data addObject:item];
            }
        }
        s_LoadedTotalCount = [data intForKey:@"total"];
        s_EachLoadCount = [data intForKey:@"limit"];
        s_LoadedPage++;
        
        // 如果没有Header
        if (!self.m_Table.tableHeaderView)
        {
            if ([groupInfo isNotEmpty])
            {
                if (!self.s_HeaderView)
                {
                    self.s_HeaderView = [[HMCircleTopicHeaderView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0)];
                    self.s_HeaderView.delegate = self;
                }
                self.s_HeaderView.m_HeadImgUrl = [groupInfo stringForKey:@"avatar"];
                self.s_HeaderView.m_CircleTitle = [groupInfo stringForKey:@"group_name" defaultString:@""];
                self.s_HeaderView.m_TopicCount = [groupInfo stringForKey:@"topic_count" defaultString:@"0"];
                self.s_HeaderView.m_PeopleCount = [groupInfo stringForKey:@"user_count" defaultString:@"0"];
                self.s_HeaderView.m_IsJoin = [groupInfo boolForKey:@"is_joined"];
                self.s_HeaderView.isBirthdayClub = [[groupInfo stringForKey:@"is_birthclub"] isEqualToString:@"1"];
                self.s_HeaderView.m_TopicArray = dingTopicArray;
                self.s_HeaderView.m_IsDefaultJoined = self.m_CircleClass.isDefaultJoined ||[[groupInfo stringForKey:@"is_default_joined"] isEqualToString:@"1"];
                self.s_HeaderView.m_IsHospital = [[groupInfo stringForKey:@"is_hospital"] isEqualToString:@"1"];
                self.s_HeaderView.m_CircleId = [groupInfo stringForKey:@"group_id"];
                if (self.s_HeaderView.m_IsHospital)
                {
                    self.s_HeaderView.m_HospitalId = [groupInfo stringForKey:@"hospital_id"];
                }
                [self.s_HeaderView freshData];
                self.m_Table.tableHeaderView = self.s_HeaderView;
                [self addTopicListHeadSegment];
            }
        }
        
        [self.m_Table reloadData];
        
        if (![self.m_Data isNotEmpty])
        {
            if (!self.m_Table.tableHeaderView)
            {
                self.m_NoDataView.m_MessageType = HMNODATAMESSAGE_PUBLISHTOPIC;
                self.m_NoDataView.m_Type = HMNODATAVIEW_TOPIC;
                self.m_NoDataView.hidden = NO;
            }
        }
    }
    else
    {
        if (self.m_Data.count == 0)
        {
            self.m_NoDataView.m_Type = HMNODATAVIEW_DATAERROR;
            self.m_NoDataView.hidden = NO;
        }
        else if ([self isVisible])
        {
            [PXAlertView showAlertWithTitle:@"数据下载错误, 请稍后再试！"];
        }
    }
}

- (void)loadDataFail:(ASIHTTPRequest *)request
{
    [self.m_ProgressHUD hide:YES];
    [self hideEGORefreshView];
    
    if (self.m_Data.count == 0)
    {
        self.m_NoDataView.m_Type = HMNODATAVIEW_NETERROR;
        self.m_NoDataView.hidden = NO;
    }
    else if ([self isVisible])
    {
        [PXAlertView showAlertWithTitle:@"没有网络连接哦"];
    }
}


#pragma mark - topBtn相关方法

- (void)clickTitleView
{
    [MobClick event:@"discuz_v2" label:@"圈子顶部三角"];
    [self hideOrShowTopBtn];
}

- (void)hideOrShowTopBtn
{
    if (isShowTopBtn)
    {
        [self.s_TitleTriAngelBtn setImage:[UIImage imageNamed:@"listmenu_down_btn1"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25 animations:^{
            self.s_TopBgImgView.top = - 44;
            self.s_TopBgImgView.alpha = 0;
        }];
    }
    else
    {
        [self.s_TitleTriAngelBtn setImage:[UIImage imageNamed:@"listmenu_up_btn1"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25 animations:^{
            self.s_TopBgImgView.top = 0;
            self.s_TopBgImgView.alpha = 1;
        }];
    }
    isShowTopBtn = !isShowTopBtn;
}


#pragma mark - 发表新帖

- (void)writeNewTopicClicked:(id)sender
{
    if(![BBUser isLogin])
    {
        [self goToLoginWithLoginType:LoginDefault];
        return;
    }
    
//    if (!self.m_CircleClass.addStatus)
//    {
//        [PXAlertView showAlertWithTitle:@"加入这个圈子再发帖吧！" message:nil cancelTitle:@"取消" otherTitle:@"加入" completion:^(BOOL cancelled, NSInteger buttonIndex) {
//            if (!cancelled)
//            {
//                [self addCircleReloadData];
//                isAddFromAlertView = YES;
//            }
//        }];
//        
//        return;
//    }
    [MobClick event:@"discuz_v2" label:@"发帖点击"];
    [HMShowPage showCreateTopic:self circleId:self.m_CircleClass.circleId circleName:self.s_HeaderView.m_CircleTitle];
}


#pragma mark - AddCircle request

- (void)addCircleReloadData
{
    if (self.m_DataRequest != nil)
    {
        [self.m_DataRequest clearDelegatesAndCancel];
    }
    
    self.m_DataRequest = [HMApiRequest addTheCircleWithGroupID:self.m_CircleClass.circleId];
    [self.m_DataRequest setDelegate:self];
    [self.m_DataRequest setDidFinishSelector:@selector(addCircleReloadDataFinished:)];
    [self.m_DataRequest setDidFailSelector:@selector(addCircleReloadDataFail:)];
    [self.m_DataRequest startAsynchronous];
    
    [self.s_AddCircleHUD show:YES showBackground:NO];
}

- (void)addCircleReloadDataFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *dictData = [responseString objectFromJSONString];
    
    if (![dictData isDictionaryAndNotEmpty])
    {
        [self.s_AddCircleHUD show:YES withText:@"加入失败, 请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        return;
    }
    
    NSString *status = [dictData stringForKey:@"status"];
    if ([status isEqualToString:@"success"] || [status isEqualToString:@"0"])
    {
        [self.s_AddCircleHUD show:YES withText:@"加入成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        NSDictionary * dictList = [dictData dictionaryForKey:@"data"];
        if ([dictList isNotEmpty])
        {
            if ([[dictList stringForKey:@"group_id"] isEqualToString:self.m_CircleClass.circleId])
            {
                NSArray *values = [NSArray arrayWithObjects:[dictList stringForKey:@"group_id"], @"1", nil];
                NSArray *keys = [NSArray arrayWithObjects:@"group_id", @"join_state", nil];
                NSDictionary *dic = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_CIRCLE_JOIN_STATE object:dic];
                self.s_HeaderView.m_IsJoin = YES;
                self.m_CircleClass.addStatus = YES;
                [self.s_HeaderView changeJoinBtnStyle:YES];

                //发新帖时
                if (isAddFromAlertView)
                {
                    [HMShowPage showCreateTopic:self circleId:self.m_CircleClass.circleId];
                }
            }
        }
    }
    else
    {
        [self.s_AddCircleHUD show:YES withText:@"加入失败, 请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
    
    isAddFromAlertView = NO;
    
    return;
}

- (void)addCircleReloadDataFail:(ASIHTTPRequest *)request
{
    isAddFromAlertView = NO;
    
    [self.s_AddCircleHUD show:YES withText:@"加入失败, 请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}

#pragma mark - QuitCircle request

- (void)quitCircleReloadData
{
    if (self.m_DataRequest != nil)
    {
        [self.m_DataRequest clearDelegatesAndCancel];
    }

    self.m_DataRequest = [HMApiRequest quitTheCircleWithGroupID:self.m_CircleClass.circleId];
    [self.m_DataRequest setDelegate:self];
    [self.m_DataRequest setDidFinishSelector:@selector(quitCircleReloadDataFinished:)];
    [self.m_DataRequest setDidFailSelector:@selector(quitCircleReloadDataFail:)];
    [self.m_DataRequest startAsynchronous];
    
    [self.s_AddCircleHUD show:YES showBackground:NO];
}

- (void)quitCircleReloadDataFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *dictData = [responseString objectFromJSONString];
    
    if (![dictData isDictionaryAndNotEmpty])
    {
        [self.s_AddCircleHUD show:YES withText:@"退出失败, 请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        return;
    }
    
    NSString *status = [dictData stringForKey:@"status"];
    if ([status isEqualToString:@"success"] || [status isEqualToString:@"0"])
    {
        [self.s_AddCircleHUD show:YES withText:@"退出成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        NSDictionary * dictList = [dictData dictionaryForKey:@"data"];
        if ([dictList isNotEmpty])
        {
            if ([[dictList stringForKey:@"group_id"] isEqualToString:self.m_CircleClass.circleId])
            {
                NSArray *values = [NSArray arrayWithObjects:[dictList stringForKey:@"group_id"], @"0", nil];
                NSArray *keys = [NSArray arrayWithObjects:@"group_id", @"join_state",nil];
                NSDictionary *dic = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_CIRCLE_JOIN_STATE object:dic];
                
                self.s_HeaderView.m_IsJoin = NO;
                self.m_CircleClass.addStatus = NO;
                [self.s_HeaderView changeJoinBtnStyle:NO];
            }
        }
    }
    else if ([status isEqualToString:@"owner_cannot_quit"])
    {
        [self.s_AddCircleHUD show:YES withText:@"您不能退出自己管理的圈子哦" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
    else
    {
        [self.s_AddCircleHUD show:YES withText:@"退出失败, 请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
    
    return;
}

- (void)quitCircleReloadDataFail:(ASIHTTPRequest *)request
{
    [self.s_AddCircleHUD show:YES withText:@"退出失败, 请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}


#pragma mark - HMCircleTopicHeaderViewDelegate

- (void)HMCircleTopicHeaderView:(HMCircleTopicHeaderView *)headerView clickJoinBtnWithisJoin:(BOOL)isJoin
{
    if (isJoin)
    {
        [self quitCircleReloadData];
    }
    else
    {
        [self addCircleReloadData];
    }
}

- (void)clickCircleTopicView:(HMCircleTopicView *)topicView
{
    NSString *tid = topicView.m_TopicId;
    
    NSString *title = topicView.m_TopicTitle;
    [BBStatistic visitType:BABYTREE_TYPE_TOPIC_GROUP contentId:tid];
    [HMShowPage showTopicDetail:self topicId:tid topicTitle:title];
}

-(void)clickedCircleUserList
{
    [MobClick event:@"discuz_v2" label:@"圈成员"];
    BBCircleMember *memberVC = [[BBCircleMember alloc]initWithNibName:@"BBCircleMember" bundle:nil];
    memberVC.m_CircleID = self.m_CircleClass.circleId;
    memberVC.m_IsBirthdayClub = self.s_HeaderView.isBirthdayClub;
    [self.navigationController pushViewController:memberVC animated:YES];
}

-(void)clickedAdminList
{
    [MobClick event:@"discuz_v2" label:@"管理员"];
    BBCircleAdminList *adminVC = [[BBCircleAdminList alloc]initWithNibName:@"BBCircleAdminList" bundle:nil];
    adminVC.m_CircleID = self.m_CircleClass.circleId;
    [self.navigationController pushViewController:adminVC animated:YES];
}


-(void)clickedHospitalIntroduction
{
    [MobClick event:@"discuz_v2" label:@"关于医院"];
    
    if (self.s_HeaderView.m_IsHospital)
    {
        BBHospitalIntroduce *introduceVC = [[BBHospitalIntroduce alloc]initWithNibName:@"BBHospitalIntroduce" bundle:nil];
        introduceVC.m_HospitalID = self.s_HeaderView.m_HospitalId;
        introduceVC.m_CircleID = self.s_HeaderView.m_CircleId;
        introduceVC.m_RefreshType = EGORefreshType_NONE;
        [self.navigationController pushViewController:introduceVC animated:YES];
    }
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
    [self presentViewController:navCtrl animated:YES completion:^{
        
    }];
    return ;
}

-(void)loginFinish
{
    [self writeNewTopicClicked:nil];
}

#pragma mark -
#pragma mark NSNotificationCenter - DIDCHANGE_CIRCLE_JOIN_STATE
- (void)changeCircleJoinState:(NSNotification *)notify
{
    NSDictionary *data = notify.object;
    NSString *groupId = [data stringForKey:@"group_id"];
    
    if ([self.m_CircleClass.circleId isEqualToString:groupId])
    {
        [self freshData];
    }
}

#pragma mark-  selectArea Delegate

- (void)selectAreaCallBack:(id)object
{
    NSDictionary *objectDict = (NSDictionary*)object;
    NSString *cityId = [objectDict stringForKey:@"id"];
    if (cityId != nil && ![cityId isEqual:[NSNull null]])
    {
        self.s_Mark = 3;
        self.m_TopicStyle = POPLIST_ONLYCITY;
        [BBUser setUserOnlyCity:cityId];
        [self.m_Table setContentOffset:CGPointMake(0, 0)];
        [self freshData];
    }
    [self.navigationController popToViewController:self animated:YES];
}

@end
