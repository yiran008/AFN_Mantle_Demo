//
//  BBListView.m
//  pregnancy
//
//  Created by babytree babytree on 12-5-9.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBListView.h"
#import "SBJson.h"
#import "AlertUtil.h"
#import "BBTopicDB.h"
#import "BBTopicDB.h"
#import "BBUser.h"
#import "BBAppDelegate.h"
#import "MobClick.h"
#import "BBStatisticsUtil.h"
#import "BBTopicListView.h"


@implementation BBListView

@synthesize bbTableView;
@synthesize requestData;
@synthesize loadedTotalCount;
@synthesize listTotalCount;
@synthesize hud;
@synthesize requests;
@synthesize page;
@synthesize refreshSetImageBg;
@synthesize viewCtrl;

- (void)dealloc
{
    [bbTableView release];
    [requestData release];
    [hud release];
    [requests clearDelegatesAndCancel];
    [requests release];
    [listViewCellDelegate release];
    [listViewInfo release];
    [listViewDataDelegate release];
    
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame withBBListViewCellDelegate:(id<BBListViewCellDelegate>)bBListViewCellDelegate
withBBListViewData:(id)bBListViewData
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        listViewCellDelegate = bBListViewCellDelegate;
        [listViewCellDelegate retain];
        listViewInfo = (BBListViewInfo *)bBListViewData;
        [listViewInfo retain];
        listViewInfo.listViewInfoDelegate = self;
        listViewDataDelegate = (id<BBListViewDataDelegate>)listViewInfo;
        [listViewDataDelegate retain];
        self.bbTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,  self.frame.size.height) style:UITableViewStylePlain] autorelease];
        self.bbTableView.backgroundColor = [UIColor clearColor];
        [self.bbTableView setDelegate:self];
        [self.bbTableView setDataSource:self];
        [self addSubview:bbTableView];
        
        if (_refresh_header_view == nil) { 
            EGORefreshTableHeaderView *pullDownView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0-self.frame.size.height, self.frame.size.width, self.frame.size.height)];
            pullDownView.delegate = self; 
            [bbTableView addSubview:pullDownView]; 
            _refresh_header_view = pullDownView;
            [pullDownView release]; 
        } 
        [_refresh_header_view refreshLastUpdatedDate]; 
        //初始化下拉视图
        if (_refresh_pull_up_header_view == nil) {
            EGORefreshPullUpTableHeaderView *pullUpView = [[EGORefreshPullUpTableHeaderView alloc] initWithFrame: CGRectMake(0.0, self.frame.size.height+2000, self.frame.size.width, self.frame.size.height)];
            pullUpView.delegate = self;
            [bbTableView addSubview:pullUpView];
            _refresh_pull_up_header_view = pullUpView;
            [pullUpView release];
        }
        [_refresh_pull_up_header_view refreshPullUpLastUpdatedDate];
        self.hud = [[[MBProgressHUD alloc] initWithView:self] autorelease];
        [self addSubview:hud];
        [self.bbTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.bbTableView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_line"]]];
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [requestData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [listViewCellDelegate listViewCell:tableView heightForRowAtIndexPath:indexPath withData:[self.requestData objectAtIndex:indexPath.row]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [listViewCellDelegate listViewCell:tableView cellForRowAtIndexPath:indexPath withData:[self.requestData objectAtIndex:indexPath.row]];;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    [listViewCellDelegate listViewCell:tableView didSelectRowAtIndexPath:indexPath withData:[self.requestData objectAtIndex:indexPath.row]];
}

#pragma mark -
#pragma mark EGORefresh
- (void)reloadTableViewDataSource{
    if(_pull_up_reloading !=YES&&_reloading!=YES){
        _reloading = YES;
        [self reloadData];
    }else{
        if(_pull_up_reloading==YES){
            [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }
}

- (void)doneLoadingTableViewData{
    _reloading = NO; 
    [_refresh_header_view egoRefreshScrollViewDataSourceDidFinishedLoading:self.bbTableView];
} 

- (void)reloadPullUpTableViewDataSource
{
    if(_reloading!=YES&&_pull_up_reloading!=YES){
        _pull_up_reloading = YES;
        [self loadNextPageData];
    }else{
        if(_reloading==YES){
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }
}

- (void)doneLoadingPullUpTableViewData
{
    _pull_up_reloading = NO;
    [_refresh_pull_up_header_view egoRefreshPullUpScrollViewDataSourceDidFinishedLoading:self.bbTableView];
}
//下拉
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{ 
    [self reloadTableViewDataSource];  
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{ 
    return _reloading; 
} 

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{ 
    return [NSDate date];     
} 
//上拉
- (void)egoRefreshPullUpTableHeaderDidTriggerRefresh:(EGORefreshPullUpTableHeaderView*)view
{
	[self reloadPullUpTableViewDataSource];
}

- (BOOL)egoRefreshPullUpTableHeaderDataSourceIsLoading:(EGORefreshPullUpTableHeaderView*)view
{
	return _pull_up_reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshPullUpTableHeaderDataSourceLastUpdated:(EGORefreshPullUpTableHeaderView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark – 
#pragma mark UIScrollViewDelegate Methods 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refresh_header_view egoRefreshScrollViewDidScroll:scrollView];
    [_refresh_pull_up_header_view egoRefreshPullUpScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{ 
    [_refresh_header_view egoRefreshScrollViewDidEndDragging:scrollView]; 
    [_refresh_pull_up_header_view egoRefreshPullUpScrollViewDidEndDragging:scrollView];
}
//http request

- (void)reloadData
{
    self.page = 1;
    if (requests!=nil) {
        [requests clearDelegatesAndCancel];
    }
    //变化部分扔出去 
    self.requests = [listViewDataDelegate reload];
    [requests setDelegate:self];
    [requests setDidFinishSelector:@selector(reloadDataFinished:)];
    [requests setDidFailSelector:@selector(reloadDataFail:)];
    [requests startAsynchronous];
}
- (void)reloadDataFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *requestListData = [parser objectWithString:responseString error:&error];
    NSString *status = [requestListData stringForKey:@"status"];
    if(error == nil){
        if ([status isEqualToString:@"0"]||[status isEqualToString:@"success"]) {
            //变化部分扔出去 
            self.listTotalCount = [listViewDataDelegate loadedTotalCount:requestListData];
            self.requestData = [NSMutableArray arrayWithArray:[listViewDataDelegate reloadDataSuccess:requestListData]];
            self.loadedTotalCount = [self.requestData count];
            self.page = 1;
            if([self.requestData count]>0){
                [self.bbTableView reloadData];
                CGRect tableRect = [self.bbTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[requestData count]-1 inSection:0]];
                CGFloat celly = MAX(self.frame.size.height, tableRect.origin.y + tableRect.size.height);
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.frame.size.width, self.frame.size.height)];
                [self.bbTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }else{
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
                [self.bbTableView reloadData];
            }
            if(!hud.isHidden){
                hud.labelText = @"加载完成";
                [hud hide:YES afterDelay:0.2];
            }
            [refreshSetImageBg refreshSetImageBg:self];
        }else{
            if(!hud.isHidden){
                [hud hide:YES];
            }
            NSString *message = [requestListData stringForKey:@"message"];
            if (message==nil) {
                [AlertUtil showAlert:@"提示！" withMessage:status];
            }else {
                 [AlertUtil showAlert:@"提示！" withMessage:message];
            }
            
        }
    }else{
        if(!hud.isHidden){
            [hud hide:YES];
        }
        [AlertUtil showAlert:@"提示！" withMessage:@"加载数据失败"];
    }
    //加载完成去掉加载框
    if(_reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}
- (void)reloadDataFail:(ASIHTTPRequest *)request
{
    //修复统计页码
    self.page = self.page - 1;
    if(!hud.isHidden){
        [hud hide:YES];
    }
    NSError *error = [request error];
    [AlertUtil showErrorAlert:@"亲，您的网络不给力啊" withError:error];
    //加载完成去掉加载框
    if(_pull_up_reloading==YES){
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    //加载完成去掉加载框
    if(_reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

- (void)loadNextPageData
{    
    if(loadedTotalCount<listTotalCount||loadedTotalCount==0){
        self.page = page + 1;
        //变化部分扔出去
        [self.requests clearDelegatesAndCancel];
        self.requests = [listViewDataDelegate loadNext];
        [requests setDelegate:self];
        [requests setDidFinishSelector:@selector(nextLoadDataFinished:)];
        [requests setDidFailSelector:@selector(nextLoadDataFail:)];
        [requests startAsynchronous];
        
    }else{
        //加载完成去掉加载框
        if(_pull_up_reloading==YES){
            [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }
}
- (void)nextLoadDataFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *requestListData = [parser objectWithString:responseString error:&error];
    NSString *status = [requestListData stringForKey:@"status"];
    if(error == nil){    
        if ([status isEqualToString:@"0"]||[status isEqualToString:@"success"]) {
            //变化部分扔出去
            if(loadedTotalCount==0){
                self.listTotalCount = [listViewDataDelegate loadedTotalCount:requestListData];
                self.requestData = [[[NSMutableArray alloc] init] autorelease];
            }
            NSArray *list = [listViewDataDelegate loadNextDataSuccess:requestListData];
            loadedTotalCount+=[list count];
            if([list count]>0){
                self.requestData = [BBTopicListView filterRepeatObjectByAddAraay:list withOriginArray:requestData];
                [self.bbTableView reloadData];
                CGRect tableRect = [self.bbTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[requestData count]-1 inSection:0]];
                CGFloat celly = MAX(self.frame.size.height, tableRect.origin.y + tableRect.size.height);
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.frame.size.width, self.frame.size.height)];
                
            }else if([requestData count]==0){
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
            }
        }else{
            NSString *message = [requestListData stringForKey:@"message"];
            if (message==nil) {
                [AlertUtil showAlert:@"提示！" withMessage:status];
            }else {
                [AlertUtil showAlert:@"提示！" withMessage:message];
            }
        }
    }else{
        [AlertUtil showAlert:@"提示！" withMessage:@"加载数据失败"];
    }
    //加载完成去掉加载框
    if(_pull_up_reloading==YES){
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    
}
- (void)nextLoadDataFail:(ASIHTTPRequest *)request
{
    //修复统计页码
    self.page = self.page - 1;
    if(!hud.isHidden){
        [hud hide:YES];
    }
    NSError *error = [request error];
    [AlertUtil showErrorAlert:@"亲，您的网络不给力啊" withError:error];
    //加载完成去掉加载框
    if(_pull_up_reloading==YES){
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    //加载完成去掉加载框
    if(_reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

- (void)refresh{
    hud.labelText = @"正在加载";
    [hud show:YES];
    [self reloadData];
}

- (void)addTopicRefresh{
    hud.labelText = @"发帖成功";
    [hud show:YES];
    [self performSelector:@selector(colseTopicRefresh) withObject:nil afterDelay:0.3];
    [self reloadData];
}
- (void)colseTopicRefresh{
    if(![hud isHidden]){
        hud.labelText = @"正在刷新";
    }
}
//BBListViewCellDelegate
-(NSInteger)listTotalCountValue{
    return listTotalCount;
}
-(NSInteger)loadedTotalCountValue{
    return loadedTotalCount;
}
-(NSInteger)pageValue{
    return page;
}

@end