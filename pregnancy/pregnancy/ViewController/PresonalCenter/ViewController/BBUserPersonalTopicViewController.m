//
//  BBUserPersonalTopicViewController.m
//  pregnancy
//
//  Created by zhangzhongfeng on 14-1-8.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBUserPersonalTopicViewController.h"
#import "MBProgressHUD.h"
#import "BBUser.h"
#import "ASIFormDataRequest.h"
#import "BBDiscuzRequest.h"
#import "BBTopicRequest.h"
#import "AlertUtil.h"
#import "BBTopicListView.h"
#import "BBApp.h"
#import "BBNavigationLabel.h"
#import "HMShowPage.h"
#import "HMTopicClass.h"
#import "HMTopicListCell.h"
#import "HMTopicDetailVC.h"
#import "HMNoDataView.h"

@interface BBUserPersonalTopicViewController ()
<
    HMNoDataViewDelegate
>
@property (nonatomic, retain) UITableView       *topicListTable;
@property (nonatomic, retain) NSMutableArray    *topicArray;
@property (nonatomic, retain) MBProgressHUD     *progressHUD;
@property (nonatomic, retain) ASIFormDataRequest *topicRequest;
@property (nonatomic, assign) BOOL              shouldRefresh;
@property (assign) NSInteger pages;
@property (assign) BOOL s_isFirstView;

@property (nonatomic, retain) HMNoDataView *m_NoDataView;
@end

@implementation BBUserPersonalTopicViewController

#pragma mark - UIViewController life cyle

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_topicRequest clearDelegatesAndCancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pages = 1;
        self.s_isFirstView = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.topicArray = [[NSMutableArray alloc] init];
    
    if ([self.userEncodeId isEqualToString:[BBUser getEncId]])
    {
        if (self.topicType == BBTOPIC_TYPE_POST)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTopic) name:DIDCHANGE_PERSON_POST object:nil];
        }
        else if (self.topicType == BBTOPIC_TYPE_REPLAY)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTopic) name:DIDCHANGE_PERSON_REPLY object:nil];
        }
    }

    [self setTitle];
    [self addBackButton];
    [self addListTable];
    [self addRefreshView];
    [self addProgressHUD];
    [self requestTopic];
    
    [self addNoDataView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.shouldRefresh) {
        self.shouldRefresh = NO;
        [self requestTopic];
    }
}

#pragma mark - Create UI

- (void)setTitle
{
    [self.navigationItem setTitle:self.title];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
}

- (void)addBackButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
}

- (void)addListTable
{
    self.topicListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 20 - 44) style:UITableViewStylePlain];
    self.topicListTable.delegate = self;
    self.topicListTable.dataSource = self;
    self.topicListTable.backgroundColor = [UIColor clearColor];
    self.topicListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.topicListTable];
}

- (void)addRefreshView
{
    if (_refresh_header_view == nil) {
        EGORefreshTableHeaderView *pullDownView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0-self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        pullDownView.delegate = self;
        [self.topicListTable addSubview:pullDownView];
        _refresh_header_view = pullDownView;
    }
    [_refresh_header_view refreshLastUpdatedDate];
    //初始化下拉视图
    if (_refresh_pull_up_header_view == nil) {
        EGORefreshPullUpTableHeaderView *pullUpView = [[EGORefreshPullUpTableHeaderView alloc] initWithFrame: CGRectMake(0.0, self.view.frame.size.height+2000, self.view.frame.size.width, self.view.frame.size.height)];
        pullUpView.delegate = self;
        pullUpView.backgroundColor = [UIColor clearColor];
        [self.topicListTable addSubview:pullUpView];
        _refresh_pull_up_header_view = pullUpView;
    }
    [_refresh_pull_up_header_view refreshPullUpLastUpdatedDate];

}

- (void)addProgressHUD
{
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressHUD];
}

#pragma mark - private method

- (void)requestTopic
{
    [self changeNoDataViewWithHiddenStatus:YES];
    self.pages = 1;

    _refresh_pull_up_header_view.refreshStatus = NO;
    [_refresh_pull_up_header_view setState:EGOOPullUpRefreshNormal];
    
    [self.topicRequest clearDelegatesAndCancel];
    [self.progressHUD show:YES];
    if (self.topicType == BBTOPIC_TYPE_POST) {
        self.topicRequest = [BBDiscuzRequest myPostList:self.pages withUserEncodeId:self.userEncodeId];
        [self.topicRequest setDelegate:self];
        [self.topicRequest setDidFinishSelector:@selector(requestTopicFinished:)];
        [self.topicRequest setDidFailSelector:@selector(requestTopicFail:)];
        [self.topicRequest startAsynchronous];
    }else if (self.topicType == BBTOPIC_TYPE_REPLAY) {
        self.topicRequest = [BBDiscuzRequest myReply:self.pages withUserEncodeId:self.userEncodeId];
        [self.topicRequest setDelegate:self];
        [self.topicRequest setDidFinishSelector:@selector(requestTopicFinished:)];
        [self.topicRequest setDidFailSelector:@selector(requestTopicFail:)];
        [self.topicRequest startAsynchronous];
    }else if (self.topicType == BBTOPIC_TYPE_COLLECTION) {
        self.topicRequest = [BBTopicRequest getCollectTopic:@"0"];
        [self.topicRequest setDelegate:self];
        [self.topicRequest setDidFinishSelector:@selector(requestTopicFinished:)];
        [self.topicRequest setDidFailSelector:@selector(requestTopicFail:)];
        [self.topicRequest startAsynchronous];
    }
}

- (void)requestNextTopic
{
    [self changeNoDataViewWithHiddenStatus:YES];
    [self.topicRequest clearDelegatesAndCancel];
    if (self.topicType == BBTOPIC_TYPE_POST) {
        self.topicRequest = [BBDiscuzRequest myPostList:self.pages+1  withUserEncodeId:self.userEncodeId];
        [self.topicRequest setDelegate:self];
        [self.topicRequest setDidFinishSelector:@selector(requestNextTopicFinished:)];
        [self.topicRequest setDidFailSelector:@selector(requestNextTopicFail:)];
        [self.topicRequest startAsynchronous];
    }else if (self.topicType == BBTOPIC_TYPE_REPLAY) {
        self.topicRequest = [BBDiscuzRequest myReply:self.pages+1  withUserEncodeId:self.userEncodeId];
        [self.topicRequest setDelegate:self];
        [self.topicRequest setDidFinishSelector:@selector(requestNextTopicFinished:)];
        [self.topicRequest setDidFailSelector:@selector(nextLoadDataFail:)];
        [self.topicRequest startAsynchronous];
    }else if (self.topicType == BBTOPIC_TYPE_COLLECTION) {
        self.topicRequest = [BBTopicRequest getCollectTopic:[NSString stringWithFormat:@"%d", [self.topicArray count]]];
        [self.topicRequest setDelegate:self];
        [self.topicRequest setDidFinishSelector:@selector(requestNextTopicFinished:)];
        [self.topicRequest setDidFailSelector:@selector(nextLoadDataFail:)];
        [self.topicRequest startAsynchronous];
    }
}


- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableView delegate and dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.topicArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMTopicClass *class = [self.topicArray objectAtIndex:indexPath.row];
    static NSString *cellName = @"HMTopicListCell";
    HMTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HMTopicListCell" owner:self options:nil] lastObject];
        [cell makeCellStyle];
    }
    
    [cell setTopicCellData:class topicType:self.topicType];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.topicArray.count)
    {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    HMTopicClass *topicClass = [self.topicArray objectAtIndex:indexPath.row];
    if (self.topicType  == BBTOPIC_TYPE_REPLAY)
    {
        [BBStatistic visitType:BABYTREE_TYPE_TOPIC_REPLY contentId:topicClass.m_TopicId];
        HMTopicDetailVC *topicDetail = [[HMTopicDetailVC alloc]initWithNibName:@"HMTopicDetailVC" bundle:nil withTopicID:topicClass.m_TopicId topicTitle:topicClass.m_Title isTop:NO isBest:NO];
        topicDetail.m_ReplyID = topicClass.m_ReplyID;
        topicDetail.m_PositionFloor = topicClass.m_Floor;
        topicDetail.m_ShowPositionError = YES;
        [self.navigationController pushViewController:topicDetail animated:YES];
        return;
    }
    
    [BBStatistic visitType:BABYTREE_TYPE_TOPIC_REPLY contentId:topicClass.m_TopicId];
    [HMShowPage showTopicDetail:self topicId:topicClass.m_TopicId topicTitle:topicClass.m_Title positionFloor:topicClass.m_Floor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMTopicClass *class = [self.topicArray objectAtIndex:indexPath.row];
    return class.m_CellHeight;
}

- (void)requestTopicFinished:(ASIHTTPRequest *)request
{
    [self.progressHUD hide:YES];
    [self changeNoDataViewWithHiddenStatus:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *discuzList = [parser objectWithString:responseString error:&error];
    if (error) {
//        NSLog(@"json解析错误");
        if (self.topicArray.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
        }
        else if ([self isVisible])
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }
        return;
    }
    if ([[discuzList stringForKey:@"status"] isEqualToString:@"success"]) {
        
        _refresh_pull_up_header_view.refreshStatus = NO;
        
        [self.topicArray removeAllObjects];
        
        if ([[[discuzList dictionaryForKey:@"data"] arrayForKey:@"list"] count] == 0) {
            [self.topicListTable reloadData];
            if ([self isVisible] && self.s_isFirstView)
            {
//                [AlertUtil showAlert:@"提示" withMessage:@"还没有相关内容"];
                [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_PROMPT];
            }
            self.s_isFirstView = NO;
            if ([self.topicArray count]>0)
            {
                CGRect tableRect = [self.topicListTable rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.topicArray count]-1 inSection:0]];
                CGFloat celly = MAX(self.topicListTable.frame.size.height, tableRect.origin.y + tableRect.size.height);
                //给底部留点空隙，增加10像素。
                celly += 10;
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.topicListTable.frame.size.width, self.topicListTable.frame.size.height)];
            }
            else
            {
                [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_PROMPT];
                [_refresh_pull_up_header_view setFrame:CGRectMake(0, self.topicListTable.frame.size.height, self.topicListTable.frame.size.width, self.topicListTable.frame.size.height)];
            }

        } else {
            
            self.s_isFirstView = NO;
            NSDictionary *data  = [discuzList dictionaryForKey:@"data"];
            NSArray *topicList = [data arrayForKey:@"list"];
            
            for (NSDictionary *clumn in topicList)
            {
                if (![clumn isDictionaryAndNotEmpty])
                {
                    continue;
                }
                HMTopicClass *item = [[HMTopicClass alloc] init];
                
                item.m_TopicId = [clumn stringForKey:@"id"];
                // 去重操作
                BOOL isExisted = NO;
                NSArray *array = [self.topicArray lastArrayWithCount:DUPLICATE_COMPARECOUNT];
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
                if (item.m_ResponseTime == 0)
                {
                    item.m_ResponseTime = item.m_CreateTime;
                }
                item.m_ResponseCount = [clumn intForKey:@"response_count"];
                item.m_Floor = [clumn intForKey:@"floor"];
                item.m_ReplyID = [clumn stringForKey:@"reply_id"];
                
                // 图片数组
                NSArray *photoArr = [clumn arrayForKey:@"photo_list"];
                if ([photoArr count] > 0)
                {
                    BOOL catchRec = NO;
                    NSMutableArray *picArr = [[NSMutableArray alloc] initWithCapacity:0];
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
                        
                        if (!photoArr) {
                            [picArr addObject:photoStr];
                        }
        
                        i++;
                    }
                    item.m_PicArray = picArr;
                }
                
                [item calcHeight];
                [self.topicArray addObject:item];
            }
            
            [self.topicListTable reloadData];
            
            CGRect tableRect = [self.topicListTable rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.topicArray count]-1 inSection:0]];
            CGFloat celly = MAX(self.topicListTable.frame.size.height, tableRect.origin.y + tableRect.size.height);
            //给底部留点空隙，增加10像素。
            celly += 10;
            [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.topicListTable.frame.size.width, self.topicListTable.frame.size.height)];
        }
    }
    
    if (_reloading == YES) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

- (void)requestTopicFail:(ASIHTTPRequest *)request
{
    [self.progressHUD hide:YES];
    [_refresh_pull_up_header_view setFrame:CGRectMake(0, self.topicListTable.frame.size.height, self.topicListTable.frame.size.width, self.topicListTable.frame.size.height)];

    if (self.topicArray.count > 0)
    {
        if ([self isVisible])
        {
            [AlertUtil showAlert:@"提示" withMessage:@"亲，您的网络不给力啊"];
        }
    }
   else
   {
       [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_NETERROR];
   }
    
    if (_reloading == YES) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    
}

//加载更多帖子成功
- (void)requestNextTopicFinished:(ASIHTTPRequest *)request
{
    [self changeNoDataViewWithHiddenStatus:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *discuzList = [parser objectWithString:responseString error:&error];
    if (error) {
//        NSLog(@"json解析错误");
        if (self.topicArray.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
        }
        else if ([self isVisible])
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }
        return;
    }
    if ([[discuzList stringForKey:@"status"] isEqualToString:@"success"]) {
        NSArray *list = [[discuzList dictionaryForKey:@"data"] arrayForKey:@"list"];
        if ([list count] != 0)
        {
            self.pages ++;
            for (NSDictionary *clumn in list)
            {
                if (![clumn isDictionaryAndNotEmpty])
                {
                    continue;
                }
                
                HMTopicClass *item = [[HMTopicClass alloc] init];
                
                item.m_TopicId = [clumn stringForKey:@"id"];
                // 去重操作
                BOOL isExisted = NO;
                NSArray *array = [self.topicArray lastArrayWithCount:DUPLICATE_COMPARECOUNT];
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
                if (item.m_ResponseTime == 0)
                {
                    item.m_ResponseTime = item.m_CreateTime;
                }

                item.m_ResponseCount = [clumn intForKey:@"response_count"];
                item.m_Floor = [clumn intForKey:@"floor"];
                item.m_ReplyID = [clumn stringForKey:@"reply_id"];

                
                // 图片数组
                NSArray *photoArr = [clumn arrayForKey:@"photo_list"];
                if ([photoArr count] > 0)
                {
                    BOOL catchRec = NO;
                    NSMutableArray *picArr = [[NSMutableArray alloc] initWithCapacity:0];
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
                        
                        if (!photoArr) {
                            [picArr addObject:photoStr];
                        }
                        i++;
                    }
                    item.m_PicArray = picArr;
                }
                
                [item calcHeight];
                [self.topicArray addObject:item];
                
            }
            
            [self.topicListTable reloadData];
            
            CGRect tableRect = [self.topicListTable rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.topicArray count]-1 inSection:0]];
            CGFloat celly = MAX(self.topicListTable.frame.size.height, tableRect.origin.y + tableRect.size.height);
            //给底部留点空隙，增加10像素。
            celly += 10;
            [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.topicListTable.frame.size.width, self.topicListTable.frame.size.height)];
            _refresh_pull_up_header_view.refreshStatus = NO;

        }
        else
        {
            _refresh_pull_up_header_view.refreshStatus = YES;
        }
        
    }
    
    if (![self.topicArray isNotEmpty])
    {
        [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_PROMPT];
    }
    
    if (_pull_up_reloading == YES) {
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }

}
//加载更多帖子失败
- (void)requestNextTopicFail:(ASIHTTPRequest *)request
{
    if (self.topicArray.count > 0)
    {
        if ([self isVisible])
        {
            [AlertUtil showAlert:@"提示" withMessage:@"亲，您的网络不给力啊"];
        }
    }
    else
    {
        [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_NETERROR];
    }
    
    if (_pull_up_reloading == YES) {
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

// animate home view to side rect
#pragma mark -
#pragma mark topicDelegate methods
//回复了帖子
- (void)replyTopicFinish:(NSInteger)dataIndex
{
    if (self.topicType == BBTOPIC_TYPE_REPLAY) {
        self.shouldRefresh = YES;
    }
}

//对帖子进行了收藏操作
- (void)collectTopicAction:(NSInteger)dataIndex withTopicID:(NSString *)topicID withCollectState:(BOOL)theBool
{
    if (self.topicType == BBTOPIC_TYPE_COLLECTION) {
        NSMutableDictionary * group=[self.topicArray objectAtIndex:dataIndex];
        if ([topicID isEqualToString:[group stringForKey:@"id"]]) {
            if (theBool) {
                self.shouldRefresh = YES;
            } else {
                [self.topicArray removeObject:group];
                [self.topicListTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:dataIndex inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }

    }
}

#pragma mark -
#pragma mark EGORefresh
- (void)reloadTableViewDataSource{
    if(_pull_up_reloading !=YES && _reloading!=YES)
    {
        _reloading = YES;
        [self requestTopic];

    }else{
        if(_pull_up_reloading==YES){
            [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refresh_header_view egoRefreshScrollViewDataSourceDidFinishedLoading:self.topicListTable];
}

- (void)reloadPullUpTableViewDataSource
{
    if(_reloading!=YES && _pull_up_reloading!=YES){
        _pull_up_reloading = YES;
        [self requestNextTopic];

    }else{
        if(_reloading==YES){
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }
}

- (void)doneLoadingPullUpTableViewData
{
    _pull_up_reloading = NO;
    [_refresh_pull_up_header_view egoRefreshPullUpScrollViewDataSourceDidFinishedLoading:self.topicListTable];
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

#pragma mark - HMNoDataViewDelegate andOtherFunctions

-(void)freshFromNoDataView
{
    [self requestTopic];
}

-(void)addNoDataView
{
    self.m_NoDataView = [[HMNoDataView alloc] initWithType:HMNODATAVIEW_CUSTOM];
    [self.topicListTable addSubview:self.m_NoDataView];
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
