//
//  BBTopicListView.m
//  pregnancy
//
//  Created by babytree babytree on 12-4-1.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBRecordParkView.h"
#import "BBRecordRequest.h"
#import "BBRecordDetail.h"
#import "BBRecordParkViewCell.h"
#import "HMNoDataView.h"

@interface  BBRecordParkView ()
<
HMNoDataViewDelegate
>
@property (nonatomic, retain) HMNoDataView *m_NoDataView;

@end

@implementation BBRecordParkView

-(void)dealloc
{
    [_tableView release];
    [_dataArray release];
    [_hud release];
    [_requests clearDelegatesAndCancel];
    [_requests release];

    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,  self.frame.size.height) style:UITableViewStylePlain] autorelease];
        self.tableView.backgroundView = [[[UIView alloc]initWithFrame:frame]autorelease];
        self.tableView.backgroundView.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
        [self addSubview:_tableView];

        if (_refresh_header_view == nil) { 
            EGORefreshTableHeaderView *pullDownView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0-self.frame.size.height, self.frame.size.width, self.frame.size.height)];
            pullDownView.delegate = self; 
            [_tableView addSubview:pullDownView]; 
            _refresh_header_view = pullDownView;
            [pullDownView release]; 
        } 
        [_refresh_header_view refreshLastUpdatedDate]; 
        //初始化下拉视图
        if (_refresh_pull_up_header_view == nil) {
            EGORefreshPullUpTableHeaderView *pullUpView = [[EGORefreshPullUpTableHeaderView alloc] initWithFrame: CGRectMake(0.0, self.frame.size.height+2000, self.frame.size.width, self.frame.size.height)];
            pullUpView.delegate = self;
            [_tableView addSubview:pullUpView];
            _refresh_pull_up_header_view = pullUpView;
            [pullUpView release];
        }
        [_refresh_pull_up_header_view refreshPullUpLastUpdatedDate];
        
        //MBProgressHUD显示等待框
        self.hud = [[[MBProgressHUD alloc] initWithView:self] autorelease];
        [self addSubview:self.hud];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [MobClick event:@"mood_v2" label:@"右上角+写心情点击"];
        
        [self addNoDataView];
    }
    return self;
}
#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray ==nil) {
        return 0;
    }
    return [self.dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BBRecordParkViewCell cellHeight:[self.dataArray objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BBRecordParkViewCell";
    
    BBRecordParkViewCell *cell = [tableViews dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BBRecordParkViewCell" owner:self options:nil] objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    [cell setCellWithData:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //暂时屏蔽
//    NSMutableDictionary *data = [self.dataArray objectAtIndex:indexPath.row];
//    BBRecordDetail *recordDetail = [[[BBRecordDetail alloc]initWithNibName:@"BBRecordDetail" bundle:nil]autorelease];
//    recordDetail.recordDetailDic = data;
//    recordDetail.isSquare = YES;
//    [self.viewController.navigationController pushViewController:recordDetail animated:YES];

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
    [_refresh_header_view egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
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
    [_refresh_pull_up_header_view egoRefreshPullUpScrollViewDataSourceDidFinishedLoading:self.tableView];
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

- (void)reloadData
{
    if(_pull_up_reloading==YES){
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    [self.requests clearDelegatesAndCancel];
    self.requests = [BBRecordRequest recordPark:@"0"];
    [_requests setDelegate:self];
    [_requests setDidFinishSelector:@selector(reloadDataFinished:)];
    [_requests setDidFailSelector:@selector(reloadDataFail:)];
    [_requests startAsynchronous];

}
- (void)reloadDataFinished:(ASIHTTPRequest *)request
{
    [self changeNoDataViewWithHiddenStatus:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *responseDic = [parser objectWithString:responseString error:&error];
    NSString *status = [responseDic stringForKey:@"status"];
    if(error == nil){
        if ([status isEqualToString:@"success"]) { 
            self.dataArray = [BBRecordParkView filterObjectByAddAraay:[NSMutableArray arrayWithArray:[[responseDic dictionaryForKey:@"data"]  arrayForKey:@"list"]] withOriginArray:nil];
            if([self.dataArray count]>0){
                [self.tableView reloadData];
                CGRect tableRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count]-1 inSection:0]];
                CGFloat celly = MAX(self.frame.size.height, tableRect.origin.y + tableRect.size.height);
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.frame.size.width, self.frame.size.height)];
                
                [self.tableView setContentOffset:CGPointMake(0,0)];
            }else{
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
                [self.tableView reloadData];
                [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_PROMPT];
            }
            if(!self.hud.isHidden){
                self.hud.labelText = @"加载完成";
                [self.hud hide:YES afterDelay:0.2];
            }
            
        }else{
            if(!self.hud.isHidden){
                [self.hud hide:YES];
            }
            if (self.dataArray.count == 0)
            {
                [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
            }
            else
            {
                [AlertUtil showApiAlert:@"提示！" withJsonObject:[responseDic dictionaryForKey:@"data"]];
            }
           
        }
    }else{
        if(!self.hud.isHidden){
            [self.hud hide:YES];
        }
        if (self.dataArray.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
        }
        else
        {
            [AlertUtil showAlert:@"提示！" withMessage:@"加载数据失败"];
        }
    }
    //加载完成去掉加载框
    if(_reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}
- (void)reloadDataFail:(ASIHTTPRequest *)request
{
    if(!self.hud.isHidden){
        [self.hud hide:YES];
    }
    NSError *error = [request error];
    
    if (self.dataArray.count > 0)
    {
        [AlertUtil showErrorAlert:@"亲，您的网络不给力啊" withError:error];
    }
    else
    {
        [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_NETERROR];
    }
   
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
    if(_reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    [self.requests clearDelegatesAndCancel];
    self.requests = [BBRecordRequest recordPark:[NSString stringWithFormat:@"%d",[self.dataArray count]]];
    [_requests setDelegate:self];
    [_requests setDidFinishSelector:@selector(nextLoadDataFinished:)];
    [_requests setDidFailSelector:@selector(nextLoadDataFail:)];
    [_requests startAsynchronous];
    
}
- (void)nextLoadDataFinished:(ASIHTTPRequest *)request
{
    [self changeNoDataViewWithHiddenStatus:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *responseDic = [parser objectWithString:responseString error:&error];
    NSString *status = [responseDic stringForKey:@"status"];
    if(error == nil){    
        if ([status isEqualToString:@"success"]) {
            if(self.dataArray == nil){
                self.dataArray = [[[NSMutableArray alloc] init] autorelease];
            }
            NSMutableArray *list = [NSMutableArray arrayWithArray:[[responseDic dictionaryForKey:@"data"] arrayForKey:@"list"]];
            if([list count]>0){
                self.dataArray = [BBRecordParkView filterObjectByAddAraay:list withOriginArray:self.dataArray];
                [self.tableView reloadData];
                CGRect tableRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count]-1 inSection:0]];
                CGFloat celly = MAX(self.frame.size.height, tableRect.origin.y + tableRect.size.height);
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.frame.size.width, self.frame.size.height)];
                
            }else if([self.dataArray count]==0){
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
                [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_PROMPT];
            }
        }else{
            if (self.dataArray.count == 0)
            {
                [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
            }
            else
            {
                [AlertUtil showApiAlert:@"提示！" withJsonObject:[responseDic dictionaryForKey:@"data"]];
            }
        }
    }else{
        if (self.dataArray.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
        }
        else
        {
            [AlertUtil showAlert:@"提示！" withMessage:@"加载数据失败"];
        }
    }
    //加载完成去掉加载框
    if(_pull_up_reloading==YES){
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}
- (void)nextLoadDataFail:(ASIHTTPRequest *)request
{
    if(!self.hud.isHidden){
        [self.hud hide:YES];
    }
    NSError *error = [request error];
    if (self.dataArray.count > 0)
    {
        [AlertUtil showErrorAlert:@"亲，您的网络不给力啊" withError:error];
    }
    else
    {
        [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_NETERROR];
    }
    //加载完成去掉加载框
    if(_pull_up_reloading==YES){
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    //加载完成去掉加载框
    if(_reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

+(NSMutableArray *)filterObjectByAddAraay:(NSArray *) addArray withOriginArray:(NSMutableArray *)originArray
{
    NSMutableArray *mutableArray;
    if (originArray==nil) {
        mutableArray = [[[NSMutableArray alloc]init]autorelease];
    }else{
        mutableArray = [[[NSMutableArray alloc]initWithArray:originArray]autorelease];
    }
    if(addArray == nil || [addArray count] == 0){
        return mutableArray;
    }
    NSInteger count = [addArray count];
    NSString *addIdString;
    NSString *originIdString;
    BOOL isExsit = NO;
    for (int i=0; i< count; i++) {
        isExsit = NO;
        NSInteger originCount = [mutableArray count];
        addIdString = [[addArray objectAtIndex:i]stringForKey:@"mood_id"];
        for (int j=0; j<originCount; j++) {
            originIdString = [[mutableArray objectAtIndex:j]stringForKey:@"mood_id"];
            if ([originIdString isEqualToString:addIdString]) {
                isExsit = YES;
                break;
            }
        }
        if (isExsit==NO) {
            [mutableArray addObject:[addArray objectAtIndex:i]];
        }
    }
    return mutableArray;
}

- (void)refresh{
    self.hud.labelText = @"正在加载";
    [self.hud show:YES];
    [self reloadData];
}

#pragma mark - HMNoDataViewDelegate andOtherFunctions

-(void)freshFromNoDataView
{
    [self reloadData];
}

-(void)addNoDataView
{
    self.m_NoDataView = [[[HMNoDataView alloc] initWithType:HMNODATAVIEW_CUSTOM] autorelease];
    [self.tableView addSubview:self.m_NoDataView];
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