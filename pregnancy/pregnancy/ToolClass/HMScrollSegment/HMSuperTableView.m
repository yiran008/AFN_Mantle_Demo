//
//  HMTableViewController.m
//  lama
//
//  Created by songxf on 13-12-20.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMSuperTableView.h"


@interface HMSuperTableView ()

- (void)doneLoadingPullUpTableViewData;
- (void)doneLoadingTableViewData;
- (void)hideEGORefreshView;

@end


@implementation HMSuperTableView

-(void)dealloc
{
    [_m_Table removeObserver:self forKeyPath:@"contentSize" context:nil];
    [_m_DataRequest clearDelegatesAndCancel];
}

- (id)initWithFrame:(CGRect)frame
{
    _m_RefreshType = HMRefreshType_Head | HMRefreshType_Bottom;

    self = [self initWithFrame:frame refreshType:_m_RefreshType];

    return self;
}

- (id)initWithFrame:(CGRect)frame refreshType:(HMRefreshType)refreshType
{
    self = [super initWithFrame:frame];

    if (self)
    {
        _m_RefreshType = refreshType;

        [self loadView];
    }

    return self;
}

#pragma mark - didReceiveMemoryWarning

- (void)loadView
{
    self.m_Data = [NSMutableArray arrayWithCapacity:0];
    
    _isRollTopicData = NO;
    
    self.m_EachLoadCount = HMTABLEVIEW_EACH_LOAD_COUNT;
    self.m_LoadedTotalCount = HMTABLEVIEW_TOTAL_LOAD_COUNT;
    
    self.m_Table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, self.height)];

    self.m_Table.backgroundColor = [UIColor clearColor];
    self.m_Table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置点击信号栏  table滚动到顶部
    //    m_Table.scrollsToTop = NO;
    
    self.m_Table.top = 0;
    [self addSubview:self.m_Table];
    self.m_Table.bounces = YES;
    
    [self.m_Table addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    //初始化下拉视图
    if ((self.m_RefreshType & HMRefreshType_Head) && _refresh_header_view == nil)
    {
        HMRefreshTableHeaderView *refreshHeaderView = [[HMRefreshTableHeaderView alloc] init];
        refreshHeaderView.delegate = self;
        [self.m_Table addSubview:refreshHeaderView];
        _refresh_header_view = refreshHeaderView;
        _refresh_header_view.backgroundColor = [UIColor clearColor];
    }
    
    if ((self.m_RefreshType & HMRefreshType_Bottom) && _refresh_bottom_view == nil)
    {
        _refresh_bottom_view = [[EGORefreshPullUpTableHeaderView alloc] initWithFrame: CGRectMake(0.0, self.m_Table.height, self.m_Table.width, self.m_Table.height)];
        _refresh_bottom_view.delegate = self;
//        _refresh_bottom_view.isNotShowDate = YES;
//        _refresh_bottom_view.numberOfLoading = HMTABLEVIEW_EACH_LOAD_COUNT;
        _refresh_bottom_view.backgroundColor = [UIColor clearColor];
        [self.m_Table addSubview:_refresh_bottom_view];
    }
    
    [_refresh_bottom_view refreshPullUpLastUpdatedDate];
    
    self.m_NoDataView = [[HMNoDataView alloc] initWithType:HMNODATAVIEW_CUSTOM];
    [self.m_Table addSubview:self.m_NoDataView];
    self.m_NoDataView.m_ShowBtn = NO;
    self.m_NoDataView.delegate = self;
    self.m_NoDataView.hidden = YES;
    
    //MBProgressHUD显示等待框
    self.m_ProgressHUD = [[MBProgressHUD alloc] initWithView:self];
    self.m_ProgressHUD.animationType = MBProgressHUDAnimationFade;
    
    [self addSubview:self.m_ProgressHUD];
}

- (void)bringSomeViewToFront
{
    [self.m_NoDataView bringToFront];
    [self.m_ProgressHUD bringToFront];
}

- (void)rollFreshData
{
    if (!(self.m_RefreshType & HMRefreshType_Head) || _header_reloading)
    {
        return;
    }
    
    _isRollTopicData = YES;
    
    _header_reloading = YES;
    
    CGPoint point = CGPointZero;
    self.m_Table.contentOffset = point;
    
    [UIView beginAnimations:@"reloadData" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.4];
    
    point = CGPointMake(0, -60);
    self.m_Table.contentOffset = point;
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
    if (self.m_RefreshType & HMRefreshType_Bottom)
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


#pragma mark - EGORefresh

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
    self.m_LoadedPage = 0;
}

- (void)loadNextData
{
    [self.m_ProgressHUD show:YES showBackground:NO];
    
    self.m_CanLoadNextPage = NO;
    self.m_BakLoadedPage = self.m_LoadedPage + 1;
    _refresh_bottom_view.refreshStatus = YES;
    
    if (self.m_BakLoadedPage == 1)
    {
        self.m_CanLoadNextPage = YES;
        _refresh_bottom_view.refreshStatus = NO;
    }
    else
    {
        if (self.m_Data.count < self.m_LoadedTotalCount)
        {
            self.m_CanLoadNextPage = YES;
            _refresh_bottom_view.refreshStatus = NO;
        }
    }
}

- (void)reloadTableData
{
    [self.m_Table reloadData];
}

- (void)doneLoadingData
{
    [self.m_ProgressHUD hide:YES];
    self.m_NoDataView.hidden = YES;
    
    [self hideEGORefreshView];
}


#pragma mark - EGORefreshTableHeaderDelegate

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


#pragma mark - EGORefreshPullUpTableHeaderDelegate

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

- (NSDate *)egoRefreshPullUpTableHeaderDataSourceLastUpdated:(EGORefreshPullUpTableHeaderView*)view
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


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.m_RefreshType & HMRefreshType_Head)
    {
        [_refresh_header_view hmRefreshScrollViewDidScroll:scrollView];
    }
    if (self.m_RefreshType & HMRefreshType_Bottom)
    {
        [_refresh_bottom_view egoRefreshPullUpScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.m_RefreshType & HMRefreshType_Head)
    {
        [_refresh_header_view hmRefreshScrollViewDidEndDragging:scrollView];
    }
    if (self.m_RefreshType & HMRefreshType_Bottom)
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
