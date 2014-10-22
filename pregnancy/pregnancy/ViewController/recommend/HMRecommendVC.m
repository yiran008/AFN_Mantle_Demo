//
//  HMRecommendVC.m
//  lama
//
//  Created by songxf on 13-6-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMRecommendVC.h"
#import "HMRecommendData.h"
#import "HMRecommendDayCell.h"
#import "SBJson.h"
#import "BBAppDelegate.h"
#import "BBNavigationLabel.h"
#import "BBApp.h"
#import "HMNoDataView.h"

@interface HMRecommendVC ()
<
    HMNoDataViewDelegate
>
@property (nonatomic, retain) HMNoDataView *m_NoDataView;
@end

@implementation HMRecommendVC

@synthesize r_data;
@synthesize r_table;
@synthesize dataRequest;
@synthesize hud;
@synthesize dataArrToAdd;


#pragma mark memory manage

-(void)dealloc
{
    [_refresh_pull_up_header_view setDelegate:nil];
    [_refresh_header_view setDelegate:nil];
    [dataRequest clearDelegatesAndCancel];
    _refresh_pull_up_header_view = nil;
    _refresh_header_view = nil;
    [dataArrToAdd release];
    [dataRequest release];
    [r_table release];
    [r_data release];
    [hud release];
    
    [super dealloc];
}

- (void)viewDidUnloadBabytree
{
    [_refresh_pull_up_header_view setDelegate:nil];
    [_refresh_header_view setDelegate:nil];
    [dataRequest clearDelegatesAndCancel];
    _refresh_pull_up_header_view = nil;
    _refresh_header_view = nil;
    self.dataRequest = nil;
    self.hud = nil;
    
    //    [super viewDidUnloadBabytree];
}


#pragma mark -load data & view

- (void)initData
{
    if (!r_data)
    {
        self.r_data = [[[NSMutableArray alloc] init] autorelease];
    }
    
}



// 请求到数据后的 table刷新处理
- (void)updateTableViewWithNewData
{
    if(_reloading==YES)
    {
        [self doneLoadingTableViewData];
    }
    
    if (!dataArrToAdd)
    {
        return;
    }
    
    if (!r_data)
    {
        self.r_data = [[[NSMutableArray alloc] init] autorelease];
    }
    
    int last = [r_data count];
    
    NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<[dataArrToAdd count]; i++)
    {
        [r_data insertObject:[dataArrToAdd objectAtIndex:i] atIndex:0];
        [arr addObject:[NSIndexPath indexPathForRow:[dataArrToAdd count]-1-i inSection:0]];
    }
    
    if (last>0 && [dataArrToAdd count])
    {
        [r_table insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
        [r_table setContentOffset:CGPointMake(0, dayRowHeight*[dataArrToAdd count]-60)];
        
        if([self.r_data count]>0)
        {
            CGFloat t_bottom = r_table.contentSize.height + dayRowHeight*[dataArrToAdd count];
            CGFloat celly = MAX(self.view.height, t_bottom);
            [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.view.width, self.view.height)];
        }else
        {
            [_refresh_pull_up_header_view setFrame:CGRectMake(0, self.view.height, self.view.width, self.view.height)];
        }
    }
    else if(last == 0 && [r_data count])
    {
        [r_table reloadData];
        
        [self.r_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[r_data count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
        CGFloat t_bottom = r_table.contentSize.height;
        CGFloat celly = MAX(self.view.height, t_bottom);
        [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.view.width, self.view.height)];
    }
    
    self.dataArrToAdd = nil;
}

// 上拉 接着加载数据的请求
- (void)loadDataByLastts
{
    isUpLoad = NO;
    
    if ([r_data count] == 0)
    {
        hud.labelText = @"正在加载";
        [hud show:YES];
    }
    
    long long last_ts = 0;
    
    if ([r_data count])
    {
        last_ts = [[[r_data objectAtIndex:0] dayTime] intValue];
    }
    
    [dataRequest clearDelegatesAndCancel];
    self.dataRequest = [HMRecommendData getRecommendDataFromServer:last_ts];
    [dataRequest setDidFinishSelector:@selector(loadDataFinished:)];
    [dataRequest setDidFailSelector:@selector(loadDataFailed:)];
    [dataRequest setDelegate:self];
    [dataRequest startAsynchronous];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"宝树推荐";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    backButton.exclusiveTouch = YES;
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    
    // 加载数据
//    [self initData];
    
    if (r_table == nil)
    {
        // 初始化
        self.r_table = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)] autorelease];
        r_table.dataSource = self;
        r_table.delegate = self;
        r_table.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
        r_table.separatorStyle = UITableViewCellSeparatorStyleNone;
        r_table.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT - UI_TAB_BAR_HEIGHT);
        r_table.showsVerticalScrollIndicator = NO;
    }
    
    [self.view addSubview:r_table];
    
    //初始化下拉视图
    if (_refresh_header_view == nil)
    {
        Recommend_EGORefreshTableHeaderView *pullDownView = [[Recommend_EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0-self.r_table.height, self.r_table.width, self.r_table.height)];
        pullDownView.delegate = self;
        pullDownView.backgroundColor = r_table.backgroundColor;
        [r_table addSubview:pullDownView];
        _refresh_header_view = pullDownView;
        [pullDownView release];
    }
    [_refresh_header_view refreshLastUpdatedDate];
    
    //初始化上拉视图
    if (_refresh_pull_up_header_view == nil)
    {
        Recommend_EGORefreshPullUpTableHeaderView *pullUpView = [[Recommend_EGORefreshPullUpTableHeaderView alloc] initWithFrame: CGRectMake(0.0, UI_SCREEN_HEIGHT-UI_TAB_BAR_HEIGHT, self.r_table.width, UI_SCREEN_HEIGHT)];
        pullUpView.delegate = self;
        [r_table addSubview:pullUpView];
        _refresh_pull_up_header_view = pullUpView;
        [pullUpView release];
    }
    
    [_refresh_pull_up_header_view refreshPullUpLastUpdatedDate];
    
    dayRowHeight = 415;
    //  下面这段代码本来是想适配iphone4的时候 缩小高度
    if (!IS_IPHONE5)
    {
        dayRowHeight -= DIFHEIGHT_IPHONE5_IPHONE4*4;
    }
    [r_table setRowHeight:dayRowHeight];
    
    self.hud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:hud];
    // Do any additional setup after loading the view from its nib.
    [self addNoDataView];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGFloat t_bottom = r_table.contentSize.height + dayRowHeight*[dataArrToAdd count];
    CGFloat celly = MAX(self.view.height, t_bottom);
    [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.view.width, self.view.height)];
    
    if ([r_data count] == 0)
    {
        // 如果网络好 获取最新
        [self loadDataByLastts];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark UITableView DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [r_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *taskCellIdentifier = @"dayCellIdentifier";
    HMRecommendDayCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[HMRecommendDayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    [cell setNewData:[r_data objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark EGORefresh

- (void)reloadTableViewDataSource
{
    if (_pull_up_reloading != YES && _reloading != YES){
        _reloading = YES;
        [self loadDataByLastts];
    } else {
        if(_pull_up_reloading == YES) {
            [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1];
        }
    }
    if(_reloading!=YES)
    {
        _reloading = YES;
        [self loadDataByLastts];
    }
}

// 加载今天的最新的数据
- (void)loadTodayData
{
    isUpLoad = YES;
    
    [dataRequest clearDelegatesAndCancel];
    self.dataRequest = [HMRecommendData getRecommendDataFromServer:0];
    [dataRequest setDidFinishSelector:@selector(loadDataFinished:)];
    [dataRequest setDidFailSelector:@selector(loadDataFailed:)];
    [dataRequest setDelegate:self];
    [dataRequest startAsynchronous];
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refresh_header_view egoRefreshScrollViewDataSourceDidFinishedLoading:self.r_table];
}

//下拉
- (void)r_egoRefreshTableHeaderDidTriggerRefresh:(Recommend_EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
}

- (BOOL)r_egoRefreshTableHeaderDataSourceIsLoading:(Recommend_EGORefreshTableHeaderView*)view
{
    return _reloading;
}

- (NSDate*)r_egoRefreshTableHeaderDataSourceLastUpdated:(Recommend_EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}


- (void)reloadPullUpTableViewDataSource
{
    if (_reloading!=YES&&_pull_up_reloading!=YES)
    {
        _pull_up_reloading = YES;
        [self loadTodayData];
    }
    else
    {
        if (_reloading==YES)
        {
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY];
        }
    }
}

- (void)doneLoadingPullUpTableViewData
{
    _pull_up_reloading = NO;
    [_refresh_pull_up_header_view egoRefreshPullUpScrollViewDataSourceDidFinishedLoading:self.r_table];
}

//上拉
- (void)r_egoRefreshPullUpTableHeaderDidTriggerRefresh:(Recommend_EGORefreshPullUpTableHeaderView*)view
{
	[self reloadPullUpTableViewDataSource];
}

- (BOOL)r_egoRefreshPullUpTableHeaderDataSourceIsLoading:(Recommend_EGORefreshPullUpTableHeaderView*)view
{
	return _reloading;
}

- (NSDate*)r_egoRefreshPullUpTableHeaderDataSourceLastUpdated:(Recommend_EGORefreshPullUpTableHeaderView*)view
{
    return [NSDate date];
}


#pragma mark UIScrollViewDelegate Methods

// 因为效果跟别的上拉下拉不同，此处没有停顿，处理比较特殊
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refresh_header_view egoRefreshScrollViewDidEndDragging:scrollView];
    [_refresh_pull_up_header_view egoRefreshPullUpScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

#pragma mark UIScrollViewDelegate Methods

- (void)loadDataFinished:(ASIFormDataRequest *)request
{
    if (!hud.hidden)
    {
        [hud hide:YES];
    }
    [self changeNoDataViewWithHiddenStatus:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSDictionary *requestResult = [parser objectWithString:responseString];
    if (parser.error || ![requestResult isNotEmpty])
    {
        if (self.r_data.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
        }
        else
        {
            [AlertUtil showApiAlert:@"提示！" withJsonObject:[requestResult dictionaryForKey:@"data"]];
        }
        return;
    }
    if ([[requestResult stringForKey:@"status"] isEqualToString:@"success"] )
    {
        self.dataArrToAdd = [[[NSMutableArray alloc] init] autorelease];
        
        NSDictionary *allDaysDic = [requestResult dictionaryForKey:@"data"];
        
        if ([allDaysDic isNotEmpty])
        {
            NSArray *allDaysArr = (NSMutableArray*)[allDaysDic arrayForKey:@"recommend_list"];
            for (int i=0; i<[allDaysArr count]; i++)
            {
                // 逐条解析数据
                NSDictionary *day = [allDaysArr objectAtIndex:i];
                HMDayRecommendModel *model = [[[HMDayRecommendModel alloc] init] autorelease];
                
                if (model != nil)
                {
                    model.dayTime = [day stringForKey:@"date"];
                    model.recommendId = [day stringForKey:@"id"];
                    
                    NSMutableArray *List = [[[NSMutableArray alloc] init] autorelease];
                    NSArray *items = [day arrayForKey:@"list"];
                    for (int j=0; j<[items count]; j++)
                    {
                        NSDictionary *item = [items objectAtIndex:j];
                        HMRecommendModel *data = [[[HMRecommendModel alloc] init] autorelease];
                        data.title = [item stringForKey:@"title"];
                        data.picUrl = [item stringForKey:@"img"];
                        data.topicId = [item stringForKey:@"id"];
                        [List addObject:data];
                    }
                    
                    model.dayRecommendList = List;
                    
                }
                
                [dataArrToAdd addObject:model];
            }
        }
        
        if (isUpLoad)
        {
            // 刷新数据
            if ([dataArrToAdd count]>0)
            {
                HMDayRecommendModel *last = [r_data lastObject];
                HMDayRecommendModel *new  = [dataArrToAdd objectAtIndex:0];
                if ([new.dayTime integerValue]>[last.dayTime integerValue])
                {
                    // 删除所有
                    self.r_data = [[[NSMutableArray alloc] init] autorelease];
                    
                    NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
                    for (int i=0; i<[dataArrToAdd count]; i++)
                    {
                        [r_data insertObject:[dataArrToAdd objectAtIndex:i] atIndex:0];
                        [arr addObject:[NSIndexPath indexPathForRow:[dataArrToAdd count]-1-i inSection:0]];
                    }
                    
                    {
                        [r_table reloadData];
                        [r_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    }
                    
                    self.dataArrToAdd = nil;
                    
                }
            }
            
            [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.3];
        }
        else
        {
            NSTimeInterval time = [r_data count] == 0? 0.0:0.3;
            // 更新到页面
            [self performSelector:@selector(updateTableViewWithNewData) withObject:nil afterDelay:time];
        }
    }
    else
    {
//        [self loadLocalData];
        if (self.r_data.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
        }
        else
        {
            [AlertUtil showApiAlert:@"提示！" withJsonObject:[requestResult dictionaryForKey:@"data"]];
        }
    }
    
}

- (void)loadDataFailed:(ASIFormDataRequest *)request
{
    if (!hud.isHidden)
    {
        [hud hide:YES];
    }
    if (self.r_data.count > 0)
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"亲！您的网络不给力"
                                                       message:nil
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else
    {
        [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_NETERROR];
    }
    [self updateTableViewWithNewData];
}

#pragma mark - HMNoDataViewDelegate andOtherFunctions

-(void)freshFromNoDataView
{
    [self loadTodayData];
}

-(void)addNoDataView
{
    self.m_NoDataView = [[[HMNoDataView alloc] initWithType:HMNODATAVIEW_CUSTOM] autorelease];
    [self.r_table addSubview:self.m_NoDataView];
    self.m_NoDataView.m_ShowBtn = NO;
    self.m_NoDataView.delegate = self;
    self.m_NoDataView.hidden = YES;
}

-(void)changeNoDataViewWithHiddenStatus:(BOOL)theHiddenStatus
{
    [self changeNoDataViewWithHiddenStatus:theHiddenStatus withType:HMNODATAVIEW_CUSTOM];
}

-(void)changeNoDataViewWithHiddenStatus:(BOOL)theHiddenStatus withType:(HMNODATAVIEW_TYPE)theType
{
    self.m_NoDataView.m_Type = theType;
    self.m_NoDataView.hidden = theHiddenStatus;
}

@end
