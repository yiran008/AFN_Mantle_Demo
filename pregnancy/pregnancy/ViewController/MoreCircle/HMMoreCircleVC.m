//
//  HMMoreCircleNewVC.m
//  lama
//
//  Created by jiangzhichao on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMMoreCircleVC.h"
#import "BBConfigureAPI.h"
#import "HMCircleClass.h"
#import "HMShowPage.h"
#import "HMMoreCircleTableView.h"
#import "HMScrollSegmentTable.h"
#import "HMMoreCircleCell.h"
#import "HMNoDataView.h"
#import "MBProgressHUD.h"
#import "HMApiRequest.h"
#import "HMMyCircleList.h"
@interface HMMoreCircleVC ()
<
    HMNoDataViewDelegate
>
{
    float statusViewHeight;
}
// SegmentTable
@property (nonatomic, strong) HMScrollSegmentTable *s_ScrollTable;

// Segment Data
@property (nonatomic, strong) NSMutableArray *s_TitleArray;
@property (nonatomic, strong) NSMutableArray *s_IdArray;
// 网络
@property (nonatomic, strong) ASIFormDataRequest *s_DataRequest;
@property (nonatomic, strong) MBProgressHUD *s_ProgressHUD;
@property (nonatomic, strong) HMNoDataView *s_NoDataView;

@end

@implementation HMMoreCircleVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DIDCHANGE_MORECIRCLE_LOGIN_STATE object:nil];
    [_s_DataRequest clearDelegatesAndCancel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (self.s_ScrollTable)
    {
        if ([[self.s_ScrollTable getCurrentTabTitle] isEqualToString:@"我的圈"])
        {
               [MobClick event:@"discuz_v2" label:@"我的圈页pv"];//tag3
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAllData) name:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMoreCirclePage) name:DIDCHANGE_MORECIRCLE_LOGIN_STATE object:nil];
    self.title = @"圈子";
    
//    [self setNavBar:self.title bgColor:nil leftTitle:nil leftBtnImage:@"backButton" leftToucheEvent:@selector(backAction:) rightTitle:nil rightBtnImage:nil rightToucheEvent:nil];
    statusViewHeight = 0.0;
    if (IOS_VERSION >= 7.0)
    {
        UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 20)];
        statusView.backgroundColor = UI_NAVIGATION_BGCOLOR;
        [self.view addSubview:statusView];
        statusViewHeight = 20.0;
    }
    
    self.s_TitleArray = [NSMutableArray arrayWithCapacity:0];
    self.s_IdArray = [NSMutableArray arrayWithCapacity:0];
    
    // MBProgressHUD显示等待框
    self.s_ProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.s_ProgressHUD.animationType = MBProgressHUDAnimationFade;
    [self.view addSubview:self.s_ProgressHUD];
    
    // s_NoDataView
    self.s_NoDataView = [[HMNoDataView alloc] initWithType:HMNODATAVIEW_CUSTOM];
    self.s_NoDataView.m_ShowBtn = NO;
    self.s_NoDataView.delegate = self;
    self.s_NoDataView.hidden = YES;
    [self.view addSubview:self.s_NoDataView];

    [self loadData:self.m_CircleIdFromOutSide];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - freshData Request

- (void)loadData:(NSString *)classId
{
    if (self.s_TitleArray.count == 0)
    {
        [self.s_ProgressHUD show:YES showBackground:NO];
    }

    [self.s_DataRequest clearDelegatesAndCancel];
    self.s_DataRequest = [HMApiRequest circleListwithStart:1 withClassId:classId];
    [self.s_DataRequest setDelegate:self];
    [self.s_DataRequest setDidFinishSelector:@selector(loadDataFinished:)];
    [self.s_DataRequest setDidFailSelector:@selector(loadDataFail:)];
    [self.s_DataRequest startAsynchronous];
}

- (void)loadDataFinished:(ASIHTTPRequest *)request
{
    [self.s_ProgressHUD hide:YES];
    self.s_NoDataView.hidden = YES;
    
    NSString *responseString = [request responseString];
    NSDictionary *dictData = [responseString objectFromJSONString];
    
    if (![dictData isDictionaryAndNotEmpty])
    {       
        if (self.s_TitleArray.count == 0)
        {
            self.s_NoDataView.m_Type = HMNODATAVIEW_DATAERROR;
            self.s_NoDataView.hidden = NO;
        }
        else
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }
        return ;
    }
    
    NSDictionary *dictList = [dictData dictionaryForKey:@"data"];
    
    NSString *status = [dictData stringForKey:@"status"];
    if ([status isEqualToString:@"success"])
    {
        [self.s_TitleArray removeAllObjects];
        [self.s_IdArray removeAllObjects];
        // 设置头部滚动条
        if (![self.s_TitleArray isNotEmpty])
        {
            // 默认选中TableView的位置
            NSUInteger defaultTableIndex = 0;
            
            NSArray *nav = [dictList arrayForKey:@"navigation"];
            for (NSInteger i = 0; i < nav.count; i++)
            {
                NSDictionary * navItem = nav[i];
                NSString *typeName = [navItem stringForKey:@"type_name"];
                NSString *classId = [navItem stringForKey:@"id"];
                
                if ([typeName isNotEmpty] && [classId isNotEmpty])
                {
                    [self.s_TitleArray addObject:typeName];
                    [self.s_IdArray addObject:classId];
                }
                if ([self.m_CircleIdFromOutSide isEqualToString:classId])
                {
                    defaultTableIndex = i;
                }
            }
            
            BOOL isContains = NO;
            if ([self.s_TitleArray isNotEmpty])
            {
                if (!self.s_ScrollTable)
                {                    
                    self.s_ScrollTable = [[HMScrollSegmentTable alloc] initWithFrame:CGRectMake(0, statusViewHeight, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT - UI_TAB_BAR_HEIGHT)];
                }
                HMMyCircleList *circleTable = [[HMMyCircleList alloc] init];
                circleTable.ContainerVC = self;
                NSArray *localListVCArray = [NSArray arrayWithObjects:circleTable, nil];
                [self.s_ScrollTable freshAllTableViewWithTables:localListVCArray tableTitles:@[@"我的圈"] otherTitles:self.s_TitleArray otherIds:self.s_IdArray];
                [self.view addSubview:self.s_ScrollTable];
               
                 if (self.m_CircleIdFromOutSide != nil)
                 {
                     isContains = [self.s_IdArray containsObject:self.m_CircleIdFromOutSide];
                     if (isContains)
                     {
                         defaultTableIndex += localListVCArray.count;
                     }
                 }
            }
            else
            {
                self.s_NoDataView.m_Type = HMNODATAVIEW_DATAERROR;
                self.s_NoDataView.hidden = NO;
                return;
            }
            
            // 设置默认TableView的数据
            NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
            NSArray *group = [dictList arrayForKey:@"group"];
            if ([group isNotEmpty])
            {
                for (NSDictionary *clumn in [dictList arrayForKey:@"group"])
                {
                    if (![clumn isDictionaryAndNotEmpty])
                    {
                        continue;
                    }
                    HMCircleClass *item = [[HMCircleClass alloc] init];
                    item.circleId = [clumn stringForKey:@"id"];
                    
                    // 去重操作
                    BOOL isExisted = NO;
                    for (HMCircleClass *item1 in dataArray)
                    {
                        if ([item.circleId isEqualToString:item1.circleId])
                        {
                            isExisted = YES;
                            break;
                        }
                    }
                    if (isExisted)
                    {
                        continue;
                    }
                    
                    item.circleImageUrl = [clumn stringForKey:@"img_src"];
                    item.circleTitle = [clumn stringForKey:@"title" defaultString:@""];
                    item.topicNum = [clumn stringForKey:@"topic_count" defaultString:@""];
                    item.memberNum = [clumn stringForKey:@"user_count" defaultString:@""];
                    item.circleId = [clumn stringForKey:@"id"];
                    item.addStatus = [clumn boolForKey:@"is_joined"];
                    item.circleIntro = [clumn stringForKey:@"desc" defaultString:@""];
                    item.type = [clumn stringForKey:@"type"];
                    item.isMyCityCircle = [clumn boolForKey:@"is_mycity"];
                    if([item.type isEqualToString:@"1"])
                    {
                        item.m_HospitalID = [clumn stringForKey:@"hospital_id" defaultString:@""];
                    }
                    [dataArray addObject:item];
                }
            }
            
//            NSInteger totalDataCount = 10000;//API暂时没有
//            
//            // 滚动到默认的TableView并设置其数据
//            [self.s_ScrollTable scrollTableViewToIndex:defaultTableIndex dataArray:dataArray totalDataCount:totalDataCount];
            if ([self.m_CircleIdFromOutSide isNotEmpty]  && isContains)
            {
                NSInteger totalDataCount = 10000;//API暂时没有
                
                // 滚动到默认的TableView并设置其数据
                [self.s_ScrollTable scrollTableViewToIndex:defaultTableIndex dataArray:dataArray totalDataCount:totalDataCount];
            }
            else
            {
                [self.s_ScrollTable freshFirshTableView];
            }

        }
    }
    else
    {
        if (self.s_TitleArray.count == 0)
        {
            self.s_NoDataView.m_Type = HMNODATAVIEW_DATAERROR;
            self.s_NoDataView.hidden = NO;
        }
        else
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }
    }
}

- (void)loadDataFail:(ASIHTTPRequest *)request
{
    [self.s_ProgressHUD hide:YES];
    self.s_NoDataView.hidden = YES;
    
    if (self.s_TitleArray.count == 0)
    {
        self.s_NoDataView.m_Type = HMNODATAVIEW_NETERROR;
        self.s_NoDataView.hidden = NO;
    }
    else
    {
        [PXAlertView showAlertWithTitle:@"数据下载错误, 请稍后再试！"];
    }
}


#pragma mark - HMNoDataViewDelegate

-(void)freshFromNoDataView
{
    [self loadData:self.m_CircleIdFromOutSide];
}


#pragma mark - 通知：DIDCHANGE_CIRCLE_LOGIN_STATE 刷新所有的圈子

- (void)reloadAllData
{
    [self.s_ScrollTable freshAllTableData];
}

#pragma mark - 通知：DIDCHANGE_MORECIRCLE_LOGIN_STATE 登录、退出刷新更多圈（含tabs）

- (void)reloadMoreCirclePage
{
    self.m_CircleIdFromOutSide = [self.s_ScrollTable getCurrentTabClassId];

    [self loadData:self.m_CircleIdFromOutSide];
}

@end
