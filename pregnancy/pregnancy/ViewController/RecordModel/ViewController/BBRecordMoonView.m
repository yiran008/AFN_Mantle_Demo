//
//  BBTopicListView.m
//  pregnancy
//
//  Created by babytree babytree on 12-4-1.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBRecordMoonView.h"
#import "BBRecordRequest.h"
#import "BBRecordDetail.h"
#import "BBRecordMoonViewCell.h"
#import "BBPublishRecord.h"

#import "BBRecordClass.h"
#import "BBRecordAFRequest.h"

@interface BBRecordMoonView ()

@property (nonatomic,strong)NSDictionary *jsonData;

@end

@implementation BBRecordMoonView

-(void)dealloc
{
    [_tableView release];
    [_dataArray release];
    [_hud release];
    [_requests clearDelegatesAndCancel];
    [_requests release];
    [_lastTimeTs release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,  self.frame.size.height) style:UITableViewStylePlain] autorelease];
        self.tableView.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"recordMoonCellBg"]] autorelease];
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
        [self addSubview:_tableView];
        self.lastTimeTs =[NSString stringWithFormat:@"%d",(int)[[NSDate date]timeIntervalSince1970]];
        if (_refresh_header_view == nil) { 
            EGORefreshTableHeaderView *pullDownView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0-self.frame.size.height, self.frame.size.width, self.frame.size.height)];
            pullDownView.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
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
        
        UIView *headView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)]autorelease];
        UIImageView *pointImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(25, 28, 16, 16)]autorelease];
        [pointImageView setImage:[UIImage imageNamed:@"recordMoonPoint1"]];
        [headView addSubview:pointImageView];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.exclusiveTouch = YES;
        [button setFrame:CGRectMake(42, 24, 262, 36)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -55, 0, 0)];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setBackgroundImage:[UIImage imageNamed:@"recordMoonContentBg"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0xcc/255.0f green:0xcc/255.0f blue:0xcc/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0xcc/255.0f green:0xcc/255.0f blue:0xcc/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithRed:0xcc/255.0f green:0xcc/255.0f blue:0xcc/255.0f alpha:1.0f] forState:UIControlStateSelected];
        [button setTitle:@"今天，对宝宝说些什么......" forState:UIControlStateNormal];
        [button setTitle:@"今天，对宝宝说些什么......" forState:UIControlStateHighlighted];
        [button setTitle:@"今天，对宝宝说些什么......" forState:UIControlStateSelected];
        [button addTarget:self action:@selector(addRecord) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:button];
        [headView setBackgroundColor:[UIColor clearColor]];
        self.tableView.tableHeaderView = headView;
        
        [self addNoDataView];
    }
    return self;
}



- (void)addRecord{
    BBPublishRecord *publishRecord = [[[BBPublishRecord alloc]initWithNibName:@"BBPublishRecord" bundle:nil]autorelease];
    BBCustomNavigationController *navCtrl = [[[BBCustomNavigationController alloc]initWithRootViewController:publishRecord]autorelease];
    [navCtrl setColorWithImageName:@"navigationBg"];
    [self.viewController.navigationController presentViewController:navCtrl animated:YES completion:^{
        
    }];
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
    if (indexPath.row+1==self.dataArray.count) {
        return [BBRecordMoonViewCell cellHeight:[self.dataArray objectAtIndex:indexPath.row]]+14;
    }
    return [BBRecordMoonViewCell cellHeight:[self.dataArray objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BBRecordMoonViewCell";
    
    BBRecordMoonViewCell *cell = [tableViews dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BBRecordMoonViewCell" owner:self options:nil] objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    if (indexPath.row < self.dataArray.count)
    {
        [cell setCellWithData:[self.dataArray objectAtIndex:indexPath.row]];
    }
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBRecordClass *dataClass = [self.dataArray objectAtIndex:indexPath.row];
    if (self.userEncodeId)
    {
        if (![dataClass.date isNotEmpty]) {
            BBRecordDetail *recordDetail = [[[BBRecordDetail alloc]initWithNibName:@"BBRecordDetail" bundle:nil]autorelease];
            recordDetail.recordDetailClass = dataClass;
            recordDetail.isSquare = YES;
            [self.viewController.navigationController pushViewController:recordDetail animated:YES];
        }
        
    }else{
        if (![dataClass.date isNotEmpty]) {
            BBRecordDetail *recordDetail = [[[BBRecordDetail alloc]initWithNibName:@"BBRecordDetail" bundle:nil]autorelease];
            recordDetail.recordDetailClass = dataClass;
            [self.viewController.navigationController pushViewController:recordDetail animated:YES];
        }
    }
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
    self.lastTimeTs =[NSString stringWithFormat:@"%d",(int)[[NSDate date]timeIntervalSince1970]];
    if (self.userEncodeId)
    {
        [BBRecordAFRequest recordMoonWithTime:self.lastTimeTs withUserEncodeId:self.userEncodeId theBlock:^(id jsonData, NSError *error) {
            if (!error)
            {
                self.jsonData = (NSDictionary *)jsonData;
                [self buildDataArrayWithModelFromObject:jsonData];
                if ([self.dataArray isNotEmpty])
                {
                    [self reloadDataFinished];
                }
            }
            else
            {
                [self reloadDataFail];
            }
        }];
    }
    else
    {
        [BBRecordAFRequest recordMoonWithTime:self.lastTimeTs theBlock:^(id jsonData, NSError *error) {
            if (!error)
            {
                self.jsonData = (NSDictionary *)jsonData;
                [self buildDataArrayWithModelFromObject:jsonData];
                if ([self.dataArray isNotEmpty])
                {
                    [self reloadDataFinished];
                }
            }
            else
            {
                [self reloadDataFail];
            }
        }];
    }
}

- (void)buildDataArrayWithModelFromObject:(id)object
{
    if(self.dataArray == nil)
    {
        self.dataArray = [[[NSMutableArray alloc] init] autorelease];
    }
    
    if(_reloading==YES)
    {
        [self.dataArray removeAllObjects];
    }
    
    NSDictionary *theDic = (NSDictionary *)object;
    NSMutableArray *list = [NSMutableArray arrayWithArray:[[theDic dictionaryForKey:@"data"]  arrayForKey:@"list"]];
    NSMutableArray *tmpArr = [[[NSMutableArray alloc]initWithCapacity:0] autorelease];
    if([list count]>0)
    {
        tmpArr = [BBRecordMoonView filterObjectByAddAraay:list withOriginArray:nil];
    }
    for (NSDictionary *subDic in tmpArr)
    {
        BBRecordClass *theRecordClass = [[[BBRecordClass alloc]initWithJsonData:subDic] autorelease];
        [self.dataArray addObject:theRecordClass];
    }
}

- (void)reloadDataFinished
{
    self.m_NoDataView.hidden = YES;
    
    NSString *status = [self.jsonData stringForKey:@"status"];
  
    if ([status isEqualToString:@"success"]) {
        NSString *time = [[self.jsonData  dictionaryForKey:@"data"]stringForKey:@"last_ts"];
        if (time != nil) {
            self.lastTimeTs = time;
        }

        if([self.dataArray count]>0){
            [self.tableView reloadData];
            CGRect tableRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count]-1 inSection:0]];
            CGFloat celly = MAX(self.frame.size.height, tableRect.origin.y + tableRect.size.height);
            [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.frame.size.width, self.frame.size.height)];
            
            [self.tableView setContentOffset:CGPointMake(0,0)];
        }else{
            [_refresh_pull_up_header_view setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
            [self.tableView reloadData];
            if (![self.userEncodeId isEqual:[BBUser getEncId]])
            {
               // is_publish =1：心情记录隐私   =0：没有心情记录
                NSString *isPublish = [[self.jsonData dictionaryForKey:@"data"] stringForKey:@"is_publish"];
                if([isPublish isEqualToString:@"0"])
                {
                    [self showNoDataNoticeWithType:HMNODATAVIEW_DATAERROR  withTitle:@"这里还什么都没有"];
                }
                else
                {
                    [self showNoDataNoticeWithType:HMNODATAVIEW_DATAERROR  withTitle:@"她的心情记录没有公开哦~"];
                }
            }
        }
        if(!self.hud.isHidden){
            self.hud.labelText = @"加载完成";
            [self.hud hide:YES afterDelay:0.2];
        }
        
    }else{
        if(!self.hud.isHidden){
            [self.hud hide:YES];
        }
        [self showDataErrorWithType:HMNODATAVIEW_DATAERROR withAlertTitle:@"提示！" withAlertMessage:[[self.jsonData dictionaryForKey:@"data"] stringForKey:@"message"]];
    }
   
    //加载完成去掉加载框
    if(_reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}
- (void)reloadDataFail
{
    self.m_NoDataView.hidden = YES;
    if(!self.hud.isHidden){
        [self.hud hide:YES];
    }
    [self showDataErrorWithType:HMNODATAVIEW_NETERROR withAlertTitle:@"亲，您的网络不给力啊" withAlertMessage:[[self.jsonData dictionaryForKey:@"data"] stringForKey:@"message"]];

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
    if (self.userEncodeId)
    {
        [BBRecordAFRequest recordMoonWithTime:self.lastTimeTs withUserEncodeId:self.userEncodeId theBlock:^(id jsonData, NSError *error) {
            if (!error)
            {
                self.jsonData = (NSDictionary *)jsonData;
                [self buildDataArrayWithModelFromObject:jsonData];
                if ([self.dataArray isNotEmpty])
                {
                    [self nextLoadDataFinished];
                }
            }
            else
            {
                [self nextLoadDataFail];
            }
        }];
    }
    else
    {
        [BBRecordAFRequest recordMoonWithTime:self.lastTimeTs theBlock:^(id jsonData, NSError *error) {
            if (!error)
            {
                self.jsonData = (NSDictionary *)jsonData;
                [self buildDataArrayWithModelFromObject:jsonData];
                if ([self.dataArray isNotEmpty])
                {
                    [self nextLoadDataFinished];
                }
            }
            else
            {
                [self nextLoadDataFail];
            }
        }];
    }
}

- (void)nextLoadDataFinished
{
    self.m_NoDataView.hidden = YES;
    
    NSString *status = [self.jsonData stringForKey:@"status"];
    if ([status isEqualToString:@"success"]) {
        NSString *time = [[self.jsonData  dictionaryForKey:@"data"]stringForKey:@"last_ts"];
        if (time != nil) {
            self.lastTimeTs = time;
        }
        if(self.dataArray == nil){
            self.dataArray = [[[NSMutableArray alloc] init] autorelease];
        }
        NSMutableArray *list = [NSMutableArray arrayWithArray:[[self.jsonData dictionaryForKey:@"data"]  arrayForKey:@"list"]];
        if([list count]>0){
            [self.tableView reloadData];
            CGRect tableRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count]-1 inSection:0]];
            CGFloat celly = MAX(self.frame.size.height, tableRect.origin.y + tableRect.size.height);
            [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.frame.size.width, self.frame.size.height)];
            
        }else if([self.dataArray count]==0){
            [_refresh_pull_up_header_view setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
            if (![self.userEncodeId isEqual:[BBUser getEncId]])
            {
                // is_publish =1：心情记录隐私   =0：没有心情记录
                NSString *isPublish = [[self.jsonData dictionaryForKey:@"data"] stringForKey:@"is_publish"];
                if([isPublish isEqualToString:@"0"])
                {
                    [self showNoDataNoticeWithType:HMNODATAVIEW_DATAERROR  withTitle:@"这里还什么都没有"];
                }
                else
                {
                    [self showNoDataNoticeWithType:HMNODATAVIEW_DATAERROR  withTitle:@"她的心情记录没有公开哦~"];
                }
            }
        }
    }else{
        [self showDataErrorWithType:HMNODATAVIEW_DATAERROR withAlertTitle:@"提示！" withAlertMessage:[[self.jsonData dictionaryForKey:@"data"] stringForKey:@"message"]];
    }

    //加载完成去掉加载框
    if(_pull_up_reloading==YES){
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}
- (void)nextLoadDataFail
{
    self.m_NoDataView.hidden = YES;
    
    if(!self.hud.isHidden){
        [self.hud hide:YES];
    }
    [self showDataErrorWithType:HMNODATAVIEW_NETERROR withAlertTitle:@"亲，您的网络不给力啊" withAlertMessage:[[self.jsonData dictionaryForKey:@"data"] stringForKey:@"message"]];
    
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
   
    for (int i = 0; i < [addArray count]; i++) {
        NSDictionary *dic = [addArray objectAtIndex:i];
        NSMutableDictionary *dicData = [[[NSMutableDictionary alloc]init]autorelease];
        if ([dic stringForKey:@"date"] != nil) {
            if(!([originArray count] > 0 && [[dic stringForKey:@"date"] isEqualToString:[[addArray objectAtIndex:0] stringForKey:@"date"]]))
            {
                NSArray *moodList = [dic arrayForKey:@"mood_list"];
                [dicData setObject:[dic stringForKey:@"date"] forKey:@"date"];
                if ([moodList count]>0) {
                    [dicData setObject:[[moodList lastObject] stringForKey:@"that_time_age"] forKey:@"that_time_age"];
                }
                [mutableArray addObject:dicData];
            }
        }
        [mutableArray addObjectsFromArray:[dic arrayForKey:@"mood_list"]];
    }

    return mutableArray;
}

- (void)refresh{
    self.hud.labelText = @"正在加载";
    [self.hud show:YES];
    [self reloadData];
}

#pragma mark - HMNoDataView 

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


- (void)showNoDataNoticeWithType:(HMNODATAVIEW_TYPE)type withTitle:(NSString *)title
{
    self.m_NoDataView.m_Type = type;
    self.m_NoDataView.m_PromptText = title;
    self.m_NoDataView.m_ShowBtn = NO;
    self.m_NoDataView.hidden = NO;
}



- (void)showDataErrorWithType:(HMNODATAVIEW_TYPE)type withAlertTitle:(NSString *)title withAlertMessage:(NSString *)message
{
    if([self.dataArray count] == 0)
    {
        if(type == HMNODATAVIEW_DATAERROR)
        {
            [self showNoDataNoticeWithType:type  withTitle:@"数据错误， \n请稍后再试(>_<!)"];
        }
        else if(type == HMNODATAVIEW_NETERROR)
        {
            self.m_NoDataView.m_Type = type;
            self.m_NoDataView.hidden = NO;
        }
    }
    else
    {
        [AlertUtil showAlert:title withMessage:message];
    }
    
    
    
}

@end