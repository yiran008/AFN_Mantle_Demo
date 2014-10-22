//
//  HMTableViewController.m
//  lama
//
//  Created by songxf on 13-12-20.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMTableViewController.h"

@interface HMTableViewController ()

@end

@implementation HMTableViewController
@synthesize m_RefreshType;
@synthesize m_DataRequest, m_Data, m_Table;
@synthesize m_ProgressHUD;
@synthesize m_NoDataView;

-(void)dealloc
{
    [m_Table removeObserver:self forKeyPath:@"contentSize" context:nil];

    [m_DataRequest clearDelegatesAndCancel];
}

#pragma mark - didReceiveMemoryWarning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_RefreshType = EGORefreshType_Head | EGORefreshType_Bottom;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    _isRollTopicData = NO;

    s_EachLoadCount = TABLE_EACH_LOAD_COUNT;
    
    self.m_Table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
    
    m_Table.backgroundColor = [UIColor clearColor];
    m_Table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置点击信号栏  table滚动到顶部
//    m_Table.scrollsToTop = NO;
    
    m_Table.dataSource = self;
    m_Table.delegate = self;
    m_Table.top = 0;
    [self.view addSubview:m_Table];
    m_Table.bounces = YES;

    [m_Table addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

    self.m_Data = [[NSMutableArray alloc] initWithCapacity:0];

    //初始化下拉视图
    if ((m_RefreshType & EGORefreshType_Head) && _refresh_header_view == nil) {
        HMRefreshTableHeaderView *refreshHeaderView = [[HMRefreshTableHeaderView alloc] init];
        refreshHeaderView.delegate = self;
        [m_Table addSubview:refreshHeaderView];
        _refresh_header_view = refreshHeaderView;
        _refresh_header_view.backgroundColor = [UIColor clearColor];
    }
    
    if ((m_RefreshType & EGORefreshType_Bottom) && _refresh_bottom_view == nil)
    {
        _refresh_bottom_view = [[EGORefreshPullUpTableHeaderView alloc] initWithFrame: CGRectMake(0.0, self.m_Table.height, self.m_Table.width, self.m_Table.height)];
        _refresh_bottom_view.delegate = self;
// !!!: refresh
//        _refresh_bottom_view.isNotShowDate = YES;
//        _refresh_bottom_view.numberOfLoading = TABLE_EACH_LOAD_COUNT;
        _refresh_bottom_view.backgroundColor = [UIColor clearColor];
        [m_Table addSubview:_refresh_bottom_view];
    }
    [_refresh_bottom_view refreshPullUpLastUpdatedDate];
    
    self.m_NoDataView = [[HMNoDataView alloc] initWithType:HMNODATAVIEW_CUSTOM];
    [self.m_Table addSubview:self.m_NoDataView];
    self.m_NoDataView.m_ShowBtn = NO;
    self.m_NoDataView.delegate = self;
    self.m_NoDataView.hidden = YES;
    
    //MBProgressHUD显示等待框
    self.m_ProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    m_ProgressHUD.animationType = MBProgressHUDAnimationFade;
    [self.view addSubview:m_ProgressHUD];
}

- (void)bringSomeViewToFront
{
    [self.m_NoDataView bringToFront];
    [self.m_ProgressHUD bringToFront];
}

- (void)rollFreshData
{
    if (!(m_RefreshType & EGORefreshType_Head) || _header_reloading)
    {
        return;
    }

    _isRollTopicData = YES;

    _header_reloading = YES;

    CGPoint point = CGPointZero;
    m_Table.contentOffset = point;

    [UIView beginAnimations:@"reloadData" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.4];

    point = CGPointMake(0, -60);
    m_Table.contentOffset = point;
    if (_refresh_header_view != nil)
    {
        [_refresh_header_view setLoadingState];
    }

    [UIView setAnimationDidStopSelector:@selector(freshData)];
    [UIView commitAnimations];
}


#pragma mark 监听UIScrollView的contentOffset属性
#pragma mark - FreshPullUpHeaderViewFrame

- (void)freshBottomViewFrame
{
    if (m_RefreshType & EGORefreshType_Bottom)
    {
        CGFloat t_bottom = self.m_Table.contentSize.height;
        CGFloat celly = MAX(self.m_Table.height, t_bottom);
        [_refresh_bottom_view setFrame:CGRectMake(0, celly, self.m_Table.width, self.m_Table.height)];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([@"contentSize" isEqualToString:keyPath])
    {
        [self freshBottomViewFrame];
    }
}


#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_Data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *taskCellIdentifier = @"HMCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HMCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -
#pragma mark EGORefresh

- (void)checkIsLastPage
{
//    if (self.m_Data.count >= s_LoadedTotalCount)
//    {
//        _refresh_header_view.haveLoadedAllData = YES;
//    }
//    else
//    {
//        _refresh_header_view.haveLoadedAllData = NO;
//    }
}

- (void)freshData
{
    s_LoadedPage = 0;
}

- (void)loadNextData
{
    self.m_NoDataView.hidden = YES;
    s_CanLoadNextPage = NO;
    _refresh_bottom_view.refreshStatus = YES;

    s_BakLoadedPage = s_LoadedPage + 1;

    if (s_BakLoadedPage == 1)
    {
        s_CanLoadNextPage = YES;
        _refresh_bottom_view.refreshStatus = NO;
        [_refresh_bottom_view setState:EGOOPullUpRefreshNormal];
    }
    else
    {
        if (self.m_Data.count < s_LoadedTotalCount)
        {
            s_CanLoadNextPage = YES;
            _refresh_bottom_view.refreshStatus = NO;
        }
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate

-(void)hmRefreshTableHeaderDidTriggerRefresh:(HMRefreshTableHeaderView *)headerView
{
    [self reloadTableViewDataSource];
}

- (BOOL)hmRefreshTableHeaderDataSourceIsLoading:(HMRefreshTableHeaderView *)headerView
{
    return _header_reloading;
}

// 下拉
- (void)reloadTableViewDataSource
{
    if (_bottom_reloading != YES && _header_reloading != YES )
    {
        _header_reloading = YES;

        [self freshData];
    }
    else
    {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

- (void)doneLoadingTableViewData
{
    _header_reloading = NO;
    [_refresh_header_view hmRefreshScrollViewDataSourceDidFinishedLoading:self.m_Table];
}


#pragma mark -
#pragma mark EGORefreshPullUpTableHeaderDelegate

//上拉
- (void)reloadPullUpTableViewDataSource
{
    if (_bottom_reloading != YES && _header_reloading != YES )
    {
        _bottom_reloading = YES;

        [self loadNextData];
    }
    else
    {
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

- (void)egoRefreshPullUpTableHeaderDidTriggerRefresh:(EGORefreshPullUpTableHeaderView*)view
{
	[self reloadPullUpTableViewDataSource];
}

- (BOOL)egoRefreshPullUpTableHeaderDataSourceIsLoading:(EGORefreshPullUpTableHeaderView*)view
{
	return _bottom_reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshPullUpTableHeaderDataSourceLastUpdated:(EGORefreshPullUpTableHeaderView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

- (void)doneLoadingPullUpTableViewData
{
    _bottom_reloading = NO;
    [_refresh_bottom_view egoRefreshPullUpScrollViewDataSourceDidFinishedLoading:self.m_Table];
}

- (void)hideEGORefreshView
{
    if (_isRollTopicData)
    {
        _isRollTopicData = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.m_Table.contentOffset = CGPointZero;
        [UIView commitAnimations];
    }

    //加载完成去掉加载框
    if(_bottom_reloading)
    {
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }

    if(_header_reloading)
    {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (m_RefreshType & EGORefreshType_Head)
    {
        [_refresh_header_view hmRefreshScrollViewDidScroll:scrollView];
    }
    if (m_RefreshType & EGORefreshType_Bottom)
    {
        [_refresh_bottom_view egoRefreshPullUpScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (m_RefreshType & EGORefreshType_Head)
    {
        [_refresh_header_view hmRefreshScrollViewDidEndDragging:scrollView];
    }
    if (m_RefreshType & EGORefreshType_Bottom)
    {
        [_refresh_bottom_view egoRefreshPullUpScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark - HMNoDataViewDelegate

-(void)freshFromNoDataView
{
    [self freshData];
}

@end
