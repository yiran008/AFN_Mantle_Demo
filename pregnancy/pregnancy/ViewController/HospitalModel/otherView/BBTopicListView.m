//
//  BBTopicListView.m
//  pregnancy
//
//  Created by babytree babytree on 12-4-1.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBTopicListView.h"
#import "BBDiscuzRequest.h"
#import "SBJson.h"
#import "AlertUtil.h"
#import "BBTopicDB.h"
#import "BBTopicDB.h"
#import "BBUser.h"
#import "BBAppDelegate.h"
#import "MobClick.h"
#import "BBStatisticsUtil.h"
#import "HMShowPage.h"

#import "HMTopicClass.h"
#import "HMTopicListCell.h"
#import "HMCircleTopicHeaderView.h"

@implementation BBTopicListView

@synthesize tableView;
@synthesize groupData;
@synthesize loadedTotalCount;
@synthesize listTotalCount;
@synthesize hud;
@synthesize requests;
@synthesize groupId;
@synthesize page;
@synthesize listType;
@synthesize listSort;
@synthesize area;
@synthesize refreshTopicCallBackHandler;
@synthesize tagContent;
@synthesize userEncodeId;
@synthesize pergMonth;
@synthesize headViewTitle;
@synthesize isElite;
@synthesize refreshSetImageBg;
@synthesize viewCtrl;

-(void)dealloc
{
    [tableView release];
    [groupData release];
    [hud release];
    [requests clearDelegatesAndCancel];
    [requests release];
    [groupId release];
    [area release];
    [tagContent release];
    [userEncodeId release];
    [headViewTitle release];
    [_pregnancyYearAndMoth release];
    [_retryButton release];
    [_m_HeaderView release];
    [_dingTopicArray release];
    
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dingTopicArray = [NSMutableArray arrayWithCapacity:0];
        self.groupData = [NSMutableArray arrayWithCapacity:0];
        
        self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,  self.frame.size.height) style:UITableViewStylePlain] autorelease];
        self.tableView.backgroundView.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
        [self addSubview:tableView];
        
        if (_refresh_header_view == nil) { 
            EGORefreshTableHeaderView *pullDownView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0-self.frame.size.height, self.frame.size.width, self.frame.size.height)];
            pullDownView.delegate = self; 
            [tableView addSubview:pullDownView]; 
            _refresh_header_view = pullDownView;
            [pullDownView release]; 
        } 
        [_refresh_header_view refreshLastUpdatedDate]; 
        //初始化下拉视图
        if (_refresh_pull_up_header_view == nil) {
            EGORefreshPullUpTableHeaderView *pullUpView = [[EGORefreshPullUpTableHeaderView alloc] initWithFrame: CGRectMake(0.0, self.frame.size.height+2000, self.frame.size.width, self.frame.size.height)];
            pullUpView.delegate = self;
            [tableView addSubview:pullUpView];
            pullUpView.backgroundColor = [UIColor clearColor];
            _refresh_pull_up_header_view = pullUpView;
            [pullUpView release];
        }
        [_refresh_pull_up_header_view refreshPullUpLastUpdatedDate];
        
        //MBProgressHUD显示等待框
        self.hud = [[[MBProgressHUD alloc] initWithView:self] autorelease];
        [self addSubview:hud];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_line"]]];
         [self.tableView setBackgroundColor:[UIColor colorWithRed:244./255. green:244./255. blue:244./255. alpha:1]];
    }
    return self;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (groupData ==nil) {
        return 0;
    }
    return [groupData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMTopicClass *class = [self.groupData objectAtIndex:indexPath.row];
    return class.m_CellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMTopicClass *class = [self.groupData objectAtIndex:indexPath.row];
    // 置顶帖
    static NSString *cellName = @"HMTopicListCell";
    HMTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HMTopicListCell" owner:self options:nil] lastObject];
        [cell makeCellStyle];
    }
    
    [cell setTopicCellData:class topicType:0];
    return cell;
}

#pragma mark - network error alert

-(void)showErrorHudWithAlertMessage:(NSString *)message
{
    MBProgressHUD * progressBar = [[[MBProgressHUD alloc]initWithView:self]autorelease];
    [self addSubview:progressBar];
    progressBar.animationType = MBProgressHUDAnimationFade;
    progressBar.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xxx.png"] ]autorelease];
    progressBar.mode = MBProgressHUDModeCustomView;
    progressBar.labelText = message;
    progressBar.userInteractionEnabled = NO;
    [progressBar show:YES];
    [progressBar hide:YES afterDelay:2.0];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableDictionary *group = [self.groupData objectAtIndex:indexPath.row];
//    
//    NSString *pvCount = [group stringForKey:@"pv_count"];
//    if (pvCount!=nil && ![pvCount isEqual:[NSNull null]]) {
//        NSInteger count= [pvCount intValue]+1;
//        [group setObject:[NSString stringWithFormat:@"%d",count] forKey:@"pv_count"];
//        [tableViews reloadData];
//    }
    
//    BBNewTopicDetail *topicDetail = [[[BBNewTopicDetail alloc]initWithNibName:@"BBNewTopicDetail" bundle:nil withTopicData:group] autorelease];
//    topicDetail.delegate = self;
//    topicDetail.dataIndex = indexPath.row;
//    [self.viewCtrl.navigationController pushViewController:topicDetail animated:YES];
//    [tableViews deselectRowAtIndexPath:[tableViews indexPathForSelectedRow] animated:YES];
//    [BBCountUserEvevt custemUserCountEvent:@"communicate" withLabel:@"BBCommunicate"];
    [tableViews deselectRowAtIndexPath:indexPath animated:NO];
    HMTopicClass *class = [self.groupData objectAtIndex:indexPath.row];
    [HMShowPage showTopicDetail:self.viewController topicId:class.m_TopicId topicTitle:class.m_Title];
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
//http request

- (void)reloadData
{
    if (requests!=nil) {
        if(_pull_up_reloading==YES){
            [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
        [requests clearDelegatesAndCancel];
    }
    if(listType == GroupList){
        self.page = 1;
        self.requests = [BBDiscuzRequest discuzListByListSort:listSort withGroupId:self.groupId withPage:[NSString stringWithFormat:@"%d",self.page] withArea:area];
        [requests setDelegate:self];
        [requests setDidFinishSelector:@selector(reloadDataFinished:)];
        [requests setDidFailSelector:@selector(reloadDataFail:)];
        [requests startAsynchronous];
    }
}
- (void)reloadDataFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *discuzList = [parser objectWithString:responseString error:&error];
    NSString *status = [discuzList stringForKey:@"status"];
    if(error == nil){
        if ([status isEqualToString:@"0"]||[status isEqualToString:@"success"]) {
            if (self.retryButton) {
                self.retryButton.hidden = YES;
            }
            self.listTotalCount = [[[discuzList dictionaryForKey:@"data"] stringForKey:@"total"] integerValue];
            [self.dingTopicArray removeAllObjects];
            [self.groupData removeAllObjects];

            NSArray *topicList = [[discuzList dictionaryForKey:@"data"] arrayForKey:@"list"];
            for (NSDictionary *clumn in topicList)
            {
                if (![clumn isDictionaryAndNotEmpty])
                {
                    continue;
                }
                if ([clumn boolForKey:@"is_top"])
                {
                    [self.dingTopicArray addObject:clumn];
                }
                else
                {
                    HMTopicClass *item = [[[HMTopicClass alloc] init] autorelease];
                    
                    item.m_TopicId = [clumn stringForKey:@"id"];
                    
                    // 去重操作
                    BOOL isExisted = NO;
                    NSArray *array = [self.groupData lastArrayWithCount:DUPLICATE_COMPARECOUNT];
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
                    
                    if ([clumn boolForKey:@"is_new"])
                    {
                        item.m_Mark = TopicMark_New;
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
                        NSMutableArray *picArr = [NSMutableArray arrayWithCapacity:0];
                        NSInteger i = 0;
                        for (NSDictionary *dict in photoArr)
                        {
                            if (i > 2)
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
                            
                            [picArr addObject:photoStr];
                            i++;
                        }
                        item.m_PicArray = picArr;
                    }
                    
                    [item calcHeight];
                    [self.groupData addObject:item];
                }
            }
            
            if ([self.dingTopicArray isNotEmpty])
            {
                NSDictionary *groupInfo = [[discuzList dictionaryForKey:@"data" ] dictionaryForKey:@"group_info"];
                
                if (!self.m_HeaderView)
                {
                    self.m_HeaderView = [[[HMCircleTopicHeaderView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0)]autorelease];
                    self.m_HeaderView.delegate = self;
                }
                
                self.m_HeaderView.m_HeadImgUrl = [groupInfo stringForKey:@"avatar"];
                self.m_HeaderView.m_CircleTitle = [groupInfo stringForKey:@"group_name" defaultString:@""];
                self.m_HeaderView.m_TopicCount = [groupInfo stringForKey:@"topic_count" defaultString:@"0"];
                self.m_HeaderView.m_PeopleCount = [groupInfo stringForKey:@"user_count" defaultString:@"0"];
                self.m_HeaderView.m_IsJoin = [groupInfo boolForKey:@"is_joined"];
                self.m_HeaderView.m_TopicArray = self.dingTopicArray;
                [self.m_HeaderView freshData];
                [self.m_HeaderView hiddeHeadView];
                
                if (!self.tableView.tableHeaderView)
                {
                    self.tableView.tableHeaderView = self.m_HeaderView;
                }
            }
            
//            self.groupData = [BBTopicListView filterRepeatObjectByAddAraay:[NSMutableArray arrayWithArray:[discuzList arrayForKey:@"list"]] withOriginArray:nil];
            self.loadedTotalCount = [self.groupData count];
//            [self refreshHeadViewTitle];
            self.page = 1;
            if([self.groupData count]>0){
                [self.tableView reloadData];
                
                CGRect tableRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[groupData count]-1 inSection:0]];
                CGFloat celly = MAX(self.frame.size.height, tableRect.origin.y + tableRect.size.height);
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.frame.size.width, self.frame.size.height)];
                
                [self.tableView setContentOffset:CGPointMake(0,0)];
            }else{
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
                [self.tableView reloadData];
            }
            if(!hud.isHidden){
                hud.labelText = @"加载完成";
                [hud hide:YES afterDelay:0.2];
            }
            
        }else{
            if(!hud.isHidden){
                [hud hide:YES];
            }
            [AlertUtil showApiAlert:@"提示！" withJsonObject:discuzList];
        }
        [refreshSetImageBg refreshSetImageBg:self];
    }else{
        if(!hud.isHidden){
            [hud hide:YES];
        }
        [self addRetryButtonIfNeededWithType:retryBtonTypeError];
    }
    //加载完成去掉加载框
    if(_reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    //id列表，通知vc更改可能的segment栏
    if (refreshTopicCallBackHandler && [refreshTopicCallBackHandler respondsToSelector:@selector(refreshCallBackWithTitle:GroupID:isJoined:)])
    {
        NSDictionary * dic = [[discuzList dictionaryForKey:@"data"] dictionaryForKey:@"group_info"];
        [refreshTopicCallBackHandler refreshCallBackWithTitle:[dic stringForKey:@"group_name"] GroupID:[dic stringForKey:@"group_id"] isJoined:[[dic stringForKey:@"is_joined"]isEqualToString:@"1"]];
    }
}
- (void)reloadDataFail:(ASIHTTPRequest *)request
{
    //修复统计页码
    self.page = self.page - 1;
    if(!hud.isHidden){
        [hud hide:YES];
    }
    //加载完成去掉加载框
    if(_pull_up_reloading==YES){
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    //加载完成去掉加载框
    if(_reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    [self addRetryButtonIfNeededWithType:retryBtonTypeNetworkFailed];
    if (self.groupData && self.groupData.count)
    {
        [self showErrorHudWithAlertMessage:@"网络不给力"];
    }
}

- (void)loadNextPageData
{
    if (requests!=nil) {
        [requests clearDelegatesAndCancel];
    }
    if(loadedTotalCount<listTotalCount||loadedTotalCount==0){
        if(listType == GroupList){
            self.page = self.page + 1;
            self.requests = [BBDiscuzRequest discuzListByListSort:listSort withGroupId:self.groupId withPage:[NSString stringWithFormat:@"%d",self.page] withArea:area];
            [requests setDelegate:self];
            [requests setDidFinishSelector:@selector(nextLoadDataFinished:)];
            [requests setDidFailSelector:@selector(nextLoadDataFail:)];
            [requests startAsynchronous];
        }
    }else{
        //加载完成去掉加载框
        if(_pull_up_reloading==YES){
            [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }
}

//新版接口，只是返回成功标识变化，0-》success
- (void)reloadPostDataFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *discuzList = [parser objectWithString:responseString error:&error];
    NSString *status = [discuzList stringForKey:@"status"];
    if(error == nil){
        if ([status isEqualToString:@"success"])
        {
            if (self.retryButton) {
                self.retryButton.hidden = YES;
            }
            discuzList = [discuzList dictionaryForKey:@"data"];
            self.listTotalCount = [[discuzList stringForKey:@"total"] integerValue];
            if(self.listTotalCount == 0)
            {
 
            }
            
            [refreshTopicCallBackHandler refreshCallBack:[discuzList stringForKey:@"total"]];

            NSArray *topicList = [discuzList arrayForKey:@"list"];
            for (NSDictionary *clumn in topicList)
            {
                if (![clumn isDictionaryAndNotEmpty])
                {
                    continue;
                }
                if ([clumn boolForKey:@"is_top"])
                {
                    [self.dingTopicArray addObject:clumn];
                }
                else
                {
                    HMTopicClass *item = [[[HMTopicClass alloc] init] autorelease];
                    
                    item.m_TopicId = [clumn stringForKey:@"id"];
                    // 去重操作
                    BOOL isExisted = NO;
                    NSArray *array = [self.groupData lastArrayWithCount:DUPLICATE_COMPARECOUNT];
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

                    
                    if ([clumn boolForKey:@"is_new"])
                    {
                        item.m_Mark = TopicMark_New;
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
                        NSMutableArray *picArr = [NSMutableArray arrayWithCapacity:0];
                        NSInteger i = 0;
                        for (NSDictionary *dict in photoArr)
                        {
                            if (i > 2)
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
                            
                            [picArr addObject:photoStr];
                            i++;
                        }
                        item.m_PicArray = picArr;
                    }
                    
                    [item calcHeight];
                    [self.groupData addObject:item];
                }
            }
            self.loadedTotalCount = [self.groupData count];
            [self refreshHeadViewTitle];
            self.page = 1;
            if([self.groupData count]>0){
                [self.tableView reloadData];
                CGRect tableRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[groupData count]-1 inSection:0]];
                CGFloat celly = MAX(self.frame.size.height, tableRect.origin.y + tableRect.size.height);
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.frame.size.width, self.frame.size.height)];
                
                [self.tableView setContentOffset:CGPointMake(0,0)];
            }else{
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
                [self.tableView reloadData];
            }
            if(!hud.isHidden){
                hud.labelText = @"加载完成";
                [hud hide:YES afterDelay:0.2];
            }
            
        }else{
            if(!hud.isHidden){
                [hud hide:YES];
            }
            [self showErrorHudWithAlertMessage:@"出错了"];
        }
        [refreshSetImageBg refreshSetImageBg:self];
    }else{
        if(!hud.isHidden){
            [hud hide:YES];
        }
        [self showErrorHudWithAlertMessage:@"出错了"];
    }
    //加载完成去掉加载框
    if(_reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    //默认列表，通知vc默认列表的groupID和title
    if (refreshTopicCallBackHandler && [refreshTopicCallBackHandler respondsToSelector:@selector(refreshCallBackWithTitle:GroupID:isJoined:)])
    {
        NSDictionary * dic = [discuzList dictionaryForKey:@"group_info"];
        [refreshTopicCallBackHandler refreshCallBackWithTitle:[dic stringForKey:@"group_name"] GroupID:[dic stringForKey:@"group_id"]isJoined:[[dic stringForKey:@"is_joined"]isEqualToString:@"1"]];
    }
}

//新版接口，只是返回成功标识变化，0-》success，还有增加通知groupID和title
- (void)nextPostLoadDataFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *discuzList = [parser objectWithString:responseString error:&error];
    NSString *status = [discuzList stringForKey:@"status"];
    if(error == nil){
        if ([status isEqualToString:@"success"])
        {
            discuzList = [discuzList dictionaryForKey:@"data"];
            if(loadedTotalCount==0){
                self.listTotalCount = [[discuzList stringForKey:@"total"] integerValue];
//                self.groupData = [[[NSMutableArray alloc] init] autorelease];
                [self.dingTopicArray removeAllObjects];
                [self.groupData removeAllObjects];
            }
            NSMutableArray *list = [NSMutableArray arrayWithArray:[discuzList arrayForKey:@"list"]];
            loadedTotalCount+=[list count];
            if([list count]>0){
                
//                self.groupData = [BBTopicListView filterRepeatObjectByAddAraay:list withOriginArray:groupData];

                NSArray *topicList = [discuzList arrayForKey:@"list"];
                for (NSDictionary *clumn in topicList)
                {
                    if (![clumn isDictionaryAndNotEmpty])
                    {
                        continue;
                    }
                    if (![clumn boolForKey:@"is_top"])
                    {
                        HMTopicClass *item = [[[HMTopicClass alloc] init] autorelease];
                        
                        item.m_TopicId = [clumn stringForKey:@"id"];
                        // 去重操作
                        BOOL isExisted = NO;
                        NSArray *array = [self.groupData lastArrayWithCount:DUPLICATE_COMPARECOUNT];
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

                        
                        if ([clumn boolForKey:@"is_new"])
                        {
                            item.m_Mark = TopicMark_New;
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
                            NSMutableArray *picArr = [NSMutableArray arrayWithCapacity:0];
                            NSInteger i = 0;
                            for (NSDictionary *dict in photoArr)
                            {
                                if (i > 2)
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
                                
                                [picArr addObject:photoStr];
                                i++;
                            }
                            item.m_PicArray = picArr;
                        }
                        
                        [item calcHeight];
                        [self.groupData addObject:item];
                    }
                }
                
                [self.tableView reloadData];
                CGRect tableRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[groupData count]-1 inSection:0]];
                CGFloat celly = MAX(self.frame.size.height, tableRect.origin.y + tableRect.size.height);
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.frame.size.width, self.frame.size.height)];
                
            }else if([groupData count]==0){
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
            }
        }else{
            [self showErrorHudWithAlertMessage:@"出错了"];
        }
    }else{
        [self showErrorHudWithAlertMessage:@"出错了"];
    }
    //加载完成去掉加载框
    if(_pull_up_reloading==YES){
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    
}
//老接口
- (void)nextLoadDataFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *discuzList = [parser objectWithString:responseString error:&error];
    NSString *status = [discuzList stringForKey:@"status"];
    if(error == nil){
        if ([status isEqualToString:@"0"] ||[status isEqualToString:@"success"])
        {
            if(loadedTotalCount==0){
                self.listTotalCount = [[[discuzList dictionaryForKey:@"data"] stringForKey:@"total"] integerValue];
//                self.groupData = [[[NSMutableArray alloc] init] autorelease];
                [self.dingTopicArray removeAllObjects];
                [self.groupData removeAllObjects];
            }
            NSMutableArray *list = [NSMutableArray arrayWithArray:[[discuzList dictionaryForKey:@"data"] arrayForKey:@"list"]];
            loadedTotalCount+=[list count];
            if([list count]>0){
//                self.groupData = [BBTopicListView filterRepeatObjectByAddAraay:list withOriginArray:groupData];
                NSArray *topicList = [[discuzList dictionaryForKey:@"data"] arrayForKey:@"list"];
                for (NSDictionary *clumn in topicList)
                {
                    if (![clumn isDictionaryAndNotEmpty])
                    {
                        continue;
                    }
                    if (![clumn boolForKey:@"is_top"])
                    {
                        HMTopicClass *item = [[[HMTopicClass alloc] init] autorelease];
                        
                        item.m_TopicId = [clumn stringForKey:@"id"];
                        // 去重操作
                        BOOL isExisted = NO;
                        NSArray *array = [self.groupData lastArrayWithCount:DUPLICATE_COMPARECOUNT];
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

                        
                        if ([clumn boolForKey:@"is_new"])
                        {
                            item.m_Mark = TopicMark_New;
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
                            NSMutableArray *picArr = [NSMutableArray arrayWithCapacity:0];
                            NSInteger i = 0;
                            for (NSDictionary *dict in photoArr)
                            {
                                if (i > 2)
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
                                
                                [picArr addObject:photoStr];
                                i++;
                            }
                            item.m_PicArray = picArr;
                        }
                        
                        [item calcHeight];
                        [self.groupData addObject:item];
                    }
                }
                
                [self.tableView reloadData];
                CGRect tableRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[groupData count]-1 inSection:0]];
                CGFloat celly = MAX(self.frame.size.height, tableRect.origin.y + tableRect.size.height);
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.frame.size.width, self.frame.size.height)];
                
            }else if([groupData count]==0){
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
            }
        }else{
            [AlertUtil showApiAlert:@"提示！" withJsonObject:discuzList];
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
    [self showErrorHudWithAlertMessage:@"网络不给力"];
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
//UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self.viewCtrl.navigationController popViewControllerAnimated:YES];
    }else{
    
    }
}
- (void)setSectionTitleIsShow:(BOOL)isShow withSectionTitle:(NSString *)sectionTitle{
    if (isShow==YES) {
        self.headViewTitle = sectionTitle;
        UIImageView *sectionView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 27)] autorelease];
        [sectionView setImage:[UIImage imageNamed:@"groupTitleBg"]];
        [sectionView setBackgroundColor:[UIColor clearColor]];
        UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 3, 280, 19)] autorelease];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor colorWithRed:100.0/255 green:100.0/255 blue:100.0/255 alpha:1.0]];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [sectionView addSubview:titleLabel];
        titleLabel.text = [NSString stringWithFormat:@"%@(%d帖)",sectionTitle,listTotalCount];
        [self.tableView setTableHeaderView:sectionView];
    }else {
        [self.tableView setTableHeaderView:nil];
    }
}
- (void)refreshHeadViewTitle{
    if (self.tableView.tableHeaderView!=nil) {
        UIImageView *sectionView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 27)] autorelease];
        [sectionView setImage:[UIImage imageNamed:@"groupTitleBg"]];
        [sectionView setBackgroundColor:[UIColor clearColor]];
        UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 3, 280, 19)] autorelease];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor colorWithRed:100.0/255 green:100.0/255 blue:100.0/255 alpha:1.0]];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [sectionView addSubview:titleLabel];
        titleLabel.text = [NSString stringWithFormat:@"%@(%d帖)",headViewTitle,listTotalCount];
        [self.tableView setTableHeaderView:sectionView];
    }
}

- (void)addRetryButtonIfNeededWithType:(retryBtonType)type;
{
    if (self.groupData && self.groupData.count)
    {
        return;
    }
    
    if (!self.retryButton)
    {
        self.retryButton= [UIButton buttonWithType:UIButtonTypeCustom];
        self.retryButton.exclusiveTouch = YES;
        self.retryButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        UIImageView * imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.retryButton addSubview:imgv];
        imgv.tag = 288;
        [imgv release];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        label.center = CGPointMake(self.frame.size.width/2, 244 - 10);
        label.font = [UIFont systemFontOfSize:14.f];
        [label setTextColor:[UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1.0f]];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.tag = 289;
        [self.retryButton addSubview:label];
        [label release];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        label.center = CGPointMake(self.frame.size.width/2, 244 + 10);
        label.font = [UIFont systemFontOfSize:13.f];
        [label setTextColor:[UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1.0f]];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"点击屏幕，重新加载";
        label.backgroundColor = [UIColor clearColor];
        [self.retryButton addSubview:label];
        [label release];
        
        [self.retryButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.retryButton];
        [self bringSubviewToFront:self.hud];
    }
    
    if (type == retryBtonTypeError)
    {
        UILabel * label = (UILabel *)[self.retryButton viewWithTag:289];
        label.text = @"呃，出错啦！";
        UIImageView * imgv = (UIImageView *)[self.retryButton viewWithTag:288];
        imgv.frame = CGRectMake((320 - 74)/2, 136, 74, 74);
        [imgv setImage:[UIImage imageNamed:@"retrybutton_wrong"]];
    }
    else if (type == retryBtonTypeNetworkFailed)
    {
        UILabel * label = (UILabel *)[self.retryButton viewWithTag:289];
        label.text = @"木有网络";
        UIImageView * imgv = (UIImageView *)[self.retryButton viewWithTag:288];
        imgv.frame = CGRectMake((320 - 128)/2, 0, 128, 230);
        [imgv setImage:[UIImage imageNamed:@"retrybutton_spider"]];
    }
    
    self.retryButton.hidden = NO;
}

#pragma mark topicDelegate methods
//回复了帖子
- (void)replyTopicFinish:(NSInteger)dataIndex
{
    NSMutableDictionary * group=[groupData objectAtIndex:dataIndex];
    NSString *responseCount = [group stringForKey:@"response_count"];
    if (responseCount!=nil && ![responseCount isEqual:[NSNull null]]) {
        NSInteger count= [responseCount intValue]+1;
        [group setObject:[NSString stringWithFormat:@"%d",count] forKey:@"response_count"];
        [tableView reloadData];
    }
}

//对帖子进行了收藏操作
- (void)collectTopicAction:(NSInteger)dataIndex withTopicID:(NSString *)topicID withCollectState:(BOOL)theBool
{
    NSMutableDictionary * group=[groupData objectAtIndex:dataIndex];
    if (theBool) {
        [group setObject:@"1" forKey:@"is_fav"];
    }else {
        [group setObject:@"0" forKey:@"is_fav"];
    }
    
}
//对帖子进行删除
- (void)deleteTopicFinish:(NSInteger)dataIndex{
    [self.groupData removeObjectAtIndex:dataIndex];
    [self.tableView reloadData];
}

+(NSMutableArray *)filterRepeatObjectByAddAraay:(NSArray *) addArray withOriginArray:(NSMutableArray *)originArray
{
    NSMutableArray *mutableArray;
    if (originArray==nil) {
        mutableArray = [[[NSMutableArray alloc]init]autorelease];
    }else{
        mutableArray = [[[NSMutableArray alloc]initWithArray:originArray]autorelease];
    }
    if(addArray==nil || [addArray count]==0){
        return mutableArray;
    }
    NSInteger count = [addArray count];
    NSString *addIdString;
    NSString *originIdString;
    BOOL isExsit = NO;
    for (int i=0; i< count; i++) {
        isExsit = NO;
        NSInteger originCount = [mutableArray count];
        addIdString = [[addArray objectAtIndex:i]stringForKey:@"id"];
        for (int j=0; j<originCount; j++) {
            originIdString = [[mutableArray objectAtIndex:j]stringForKey:@"id"];
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

#pragma mark - HMCircleTopicHeaderViewDelegate

- (void)HMCircleTopicHeaderView:(HMCircleTopicHeaderView *)headerView clickJoinBtnWithisJoin:(BOOL)isJoin
{
    
}
- (void)clickCircleTopicView:(HMCircleTopicView *)topicView
{
    [HMShowPage showTopicDetail:self.viewController topicId:topicView.m_TopicId topicTitle:topicView.m_TopicId];
}

@end
