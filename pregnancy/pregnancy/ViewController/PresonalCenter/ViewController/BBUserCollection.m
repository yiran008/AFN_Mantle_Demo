//
//  BBUserCollection.m
//  pregnancy
//
//  Created by whl on 14-4-11.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBUserCollection.h"
#import "BBCustemSegment.h"
#import "HMTopicListCell.h"
#import "HMTopicClass.h"
#import "HMShowPage.h"
#import "BBTopicRequest.h"
#import "BBKnowledgeSecondLevelCell.h"
#import "BBKonwlegdeModel.h"
#import "BBKnowledgeLibDetailVC.h"
#import "HMApiRequest.h"
#import "BBKnowledgeRequest.h"
#import "HMNoDataView.h"

@interface BBUserCollection ()
<
    HMNoDataViewDelegate
>

@property (assign) NSInteger s_Mark;
@property (nonatomic, strong) NSMutableArray *s_TopicArray;
@property (nonatomic, strong) NSMutableArray *s_KnowledgeArray;
@property (assign) NSInteger s_TopicPage;
@property (strong, nonatomic) IBOutlet UIImageView *s_TopBgView;
@property (assign) NSInteger s_KnowledgePage;
@property (nonatomic, strong) id s_ItemToDelete;

@property (nonatomic, retain) HMNoDataView *m_NoDataView;
@property (nonatomic, strong) BBCustemSegment *segmented;

@end

@implementation BBUserCollection

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.m_CollectRequest clearDelegatesAndCancel];
    [self.m_KnowladgeRequest clearDelegatesAndCancel];
    [self.m_DeleteRequest clearDelegatesAndCancel];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.s_Mark = 0;
        self.s_TopicPage = 1;
        self.s_KnowledgePage = 1;
        self.s_TopicArray = [[NSMutableArray alloc]init];
        self.s_KnowledgeArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLoadData) name:DIDCHANGE_PERSON_COLLECT object:nil];
    
    [super viewDidLoad];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"我的收藏"]];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    backButton.exclusiveTouch = YES;
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [self addSegmentView];
    [self addRefreshView];
    self.m_TopicTable.backgroundColor = RGBColor(239, 239, 244, 1);
    [self.m_TopicTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.view.backgroundColor = RGBColor(239, 239, 244, 1);
    
    self.m_LoadProgress = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.m_LoadProgress];
    [self loadData];
    
    [self addNoDataView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    self.editing = NO;
}

- (void)addRefreshView
{
    if (_refresh_header_view == nil) {
        EGORefreshTableHeaderView *pullDownView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0-self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        pullDownView.delegate = self;
        pullDownView.backgroundColor = [UIColor clearColor];
        [self.m_TopicTable addSubview:pullDownView];
        _refresh_header_view = pullDownView;
    }
    [_refresh_header_view refreshLastUpdatedDate];
    //初始化下拉视图
    if (_refresh_pull_up_header_view == nil) {
        EGORefreshPullUpTableHeaderView *pullUpView = [[EGORefreshPullUpTableHeaderView alloc] initWithFrame: CGRectMake(0.0, self.view.frame.size.height+2000, self.view.frame.size.width, self.view.frame.size.height)];
        pullUpView.delegate = self;
        pullUpView.backgroundColor = [UIColor clearColor];
        [self.m_TopicTable addSubview:pullUpView];
        _refresh_pull_up_header_view = pullUpView;
    }
    [_refresh_pull_up_header_view refreshPullUpLastUpdatedDate];
    
}

-(void)addSegmentView
{
    __weak __typeof (self) weakself = self;
    NSArray * tabItemsArray = [NSArray arrayWithObjects:@{@"text":@"帖子",},@{@"text":@"知识"}, nil];
    self.segmented=[[BBCustemSegment alloc] initWithFrame:CGRectMake(60, 9, 200, 26) items:tabItemsArray
                                                    andSelectionBlock:^(NSUInteger segmentIndex) {
                                                        __strong __typeof (weakself) strongself = weakself;
                                                        if (strongself) {
                                             
                                                            if (strongself.s_Mark == segmentIndex) {
                                                                return;
                                                            }
                                                            
                                                            [strongself.segmented setNoDataViewStatusInfoWithArrayIndex:strongself.s_Mark withNoDataType:strongself.m_NoDataView.m_Type withHidden:strongself.m_NoDataView.hidden];
                                                            
                                                            _refresh_pull_up_header_view.refreshStatus = NO;
                                                            if (segmentIndex == 1) {
                                                                [strongself loadKnowladge];
                                                            }else{
                                                                [strongself loadData];
                                                            }
                                                            strongself.s_Mark = segmentIndex;
                                                            
                                                            NSDictionary *noDataStatusDic = [strongself.segmented getNoDataStatusWithIndex:segmentIndex];
                                                            strongself.m_NoDataView.m_Type = (HMNODATAVIEW_TYPE)noDataStatusDic[@"noDataViewType"];
                                                            strongself.m_NoDataView.hidden = [noDataStatusDic[@"noDataViewHidden"] boolValue];
                                                            
                                                            [strongself.m_TopicTable reloadData];
                                                        }
                                                    }];
    _segmented.color = [UIColor whiteColor];
    _segmented.borderWidth = 1.f;
    _segmented.borderColor = [UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1];
    _segmented.selectedColor = [UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1];
    _segmented.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1]};
    _segmented.selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                         NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.view addSubview:_segmented];
    UIImage *tempImage=  [UIImage imageNamed:@"head_tab_bg"];
    self.s_TopBgView.image = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 3, 3)];
}


-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadKnowladge
{
    [MobClick event:@"favorite_v2" label:@"收藏的知识列表pv"];
    [self.m_LoadProgress show:YES];
    [self.m_KnowladgeRequest clearDelegatesAndCancel];
    self.m_KnowladgeRequest = [BBTopicRequest getCollectKnowledge:[NSString stringWithFormat:@"%d",self.s_KnowledgePage]];
    [self.m_KnowladgeRequest setDelegate:self];
    [self.m_KnowladgeRequest setDidFinishSelector:@selector(loadKnowladgeDataFinished:)];
    [self.m_KnowladgeRequest setDidFailSelector:@selector(loadKnowladgeDataFail:)];
    [self.m_KnowladgeRequest startAsynchronous];
}

- (void)loadKnowladgeDataFinished:(ASIHTTPRequest *)request
{
    [self.m_LoadProgress hide:YES];
    [self changeNoDataViewWithHiddenStatus:YES];
    NSString *responseString = [request responseString];
    NSDictionary *allData = [responseString objectFromJSONString];
    if (![allData isDictionaryAndNotEmpty])
    {
        if (self.s_KnowledgeArray.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
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
        // 刷新的时候清楚所有数据
        if (self.s_KnowledgePage ==  1)
        {
            [self.s_KnowledgeArray removeAllObjects];
            _refresh_pull_up_header_view.refreshStatus = NO;
            [_refresh_pull_up_header_view setState:EGOOPullUpRefreshNormal];
        }
        
        NSArray *knowledgeList = [[allData dictionaryForKey:@"data"] arrayForKey:@"knowledge_list"];
        if ([knowledgeList count] == 0)
        {
            _refresh_pull_up_header_view.refreshStatus = YES;
        }
        for (NSDictionary *clumn in knowledgeList)
        {
            if (![clumn isDictionaryAndNotEmpty])
            {
                continue;
            }
            BBKonwlegdeModel *item = [[BBKonwlegdeModel alloc] init];
            
            item.ID = [clumn stringForKey:@"id"];
            item.knowledgeStatus = [clumn stringForKey:@"status"];
            // 去重操作
            BOOL isExisted = NO;
            NSArray *array = [self.s_KnowledgeArray lastArrayWithCount:DUPLICATE_COMPARECOUNT];
            for (BBKonwlegdeModel *item1 in array)
            {
                if ([item.ID isEqualToString:item1.ID])
                {
                    isExisted = YES;
                    break;
                }
            }
            if (isExisted)
            {
                continue;
            }

            
            item.title = [clumn stringForKey:@"title"];
            NSArray *imageArray = [clumn arrayForKey:@"images"];
            if ([imageArray isNotEmpty] && [imageArray count] > 0) {
                item.image = [[imageArray objectAtIndex:0]stringForKey:@"small_src"] ;
            }
            item.days = [clumn stringForKey:@"day_num"];
            item.category = [clumn stringForKey:@"category_id"];
            [self.s_KnowledgeArray addObject:item];
        }
         //原m_ErrorView
        if (self.s_KnowledgeArray.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_PROMPT];
        }
        
        [self.m_TopicTable reloadData];
        if ([self.s_KnowledgeArray count]>0)
        {
            CGRect tableRect = [self.m_TopicTable rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.s_KnowledgeArray count]-1 inSection:0]];
            CGFloat celly = MAX(self.m_TopicTable.frame.size.height, tableRect.origin.y + tableRect.size.height);
            //给底部留点空隙，增加10像素。
            celly += 10;
            [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.m_TopicTable.frame.size.width, self.m_TopicTable.frame.size.height)];
        }
    }
    else
    {
        if (self.s_KnowledgeArray.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
        }
        else if ([self isVisible])
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }
    }
    
    if (_pull_up_reloading == YES)
    {
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    if (_reloading == YES) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

- (void)loadKnowladgeDataFail:(ASIHTTPRequest *)request
{
    [self.m_LoadProgress hide:YES];

    if (self.s_KnowledgeArray.count > 0)
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
    
    if (_pull_up_reloading == YES)
    {
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    if (_reloading == YES) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}


- (void)loadData
{
    [MobClick event:@"favorite_v2" label:@"收藏的帖子列表pv"];
    [self.m_LoadProgress show:YES];
    [self.m_CollectRequest clearDelegatesAndCancel];
    self.m_CollectRequest = [BBTopicRequest getCollectTopic:[NSString stringWithFormat:@"%d",self.s_TopicPage]];
    [self.m_CollectRequest setDelegate:self];
    [self.m_CollectRequest setDidFinishSelector:@selector(loadDataFinished:)];
    [self.m_CollectRequest setDidFailSelector:@selector(loadDataFail:)];
    [self.m_CollectRequest startAsynchronous];
}
- (void)loadDataFinished:(ASIHTTPRequest *)request
{
    [self.m_LoadProgress hide:YES];
    [self changeNoDataViewWithHiddenStatus:YES];
    NSString *responseString = [request responseString];
    NSDictionary *allData = [responseString objectFromJSONString];
    if (![allData isDictionaryAndNotEmpty])
    {
        if (self.s_TopicArray.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
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
        // 刷新的时候清楚所有数据
        if (self.s_TopicPage ==  1)
        {
            [self.s_TopicArray removeAllObjects];
        }

        NSArray *topicList = [[allData dictionaryForKey:@"data"] arrayForKey:@"list"];
        
        if ([topicList count] == 0)
        {
            _refresh_pull_up_header_view.refreshStatus = YES;
        }
        
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
            NSArray *array = [self.s_TopicArray lastArrayWithCount:DUPLICATE_COMPARECOUNT];
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

            NSString *dateStr = [clumn stringForKey:@"create_ts"];
            NSDate *day = [NSDate dateFromString:dateStr];
            if (day)
            {
                item.m_CreateTime = [day timeIntervalSince1970];
            }
            else
            {
                item.m_CreateTime = 0;
            }
            
            item.m_ResponseCount = [clumn intForKey:@"response_count"];
            
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
                    
                    [picArr addObject:photoStr];
                    i++;
                }
                item.m_PicArray = picArr;
            }
            
            [item calcHeight];
            [self.s_TopicArray addObject:item];
        }
       //原m_ErrorView
        if (self.s_TopicArray.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_PROMPT];
        }
        
        [self.m_TopicTable reloadData];
        
        if ([self.s_TopicArray count]>0) {
            CGRect tableRect = [self.m_TopicTable rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.s_TopicArray count]-1 inSection:0]];
            CGFloat celly = MAX(self.m_TopicTable.frame.size.height, tableRect.origin.y + tableRect.size.height);
            //给底部留点空隙，增加10像素。
            celly += 10;
            [_refresh_pull_up_header_view setFrame:CGRectMake(0, celly, self.m_TopicTable.frame.size.width, self.m_TopicTable.frame.size.height)];
        }
    }
    else
    {
        if (self.s_TopicArray.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
        }
        else if ([self isVisible])
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }
    }
    if (_pull_up_reloading == YES) {
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    if (_reloading == YES) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

- (void)loadDataFail:(ASIHTTPRequest *)request
{
    [self.m_LoadProgress hide:YES];

    if (self.s_TopicArray.count > 0)
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
    
    if (_pull_up_reloading == YES)
    {
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    if (_reloading == YES) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.s_Mark == 0) {
        return [self.s_TopicArray count];
    }
    return [self.s_KnowledgeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.s_Mark == 0)
    {
        HMTopicClass *class = [self.s_TopicArray objectAtIndex:indexPath.row];
        // 置顶帖
        static NSString *cellName = @"HMTopicListCell";
        HMTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HMTopicListCell" owner:self options:nil] lastObject];
            [cell makeCellStyle];
        }
        cell.m_IsForCollection = YES;
        [cell setTopicCellData:class topicType:1];
        return cell;
    }
    else
    {
        BBKnowledgeSecondLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBKnowledgeSecondLevelCell"];
        if (cell == nil)
        {
            cell = [[BBKnowledgeSecondLevelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBKnowledgeSecondLevelCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.m_IsForCollection = YES;
        BBKonwlegdeModel *model = [self.s_KnowledgeArray objectAtIndex:indexPath.row];
        [cell setCellWithData:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.s_Mark == 0)
    {
        HMTopicClass *class = [self.s_TopicArray objectAtIndex:indexPath.row];
        return class.m_CellHeight;
    }
    else
    {
        return 69;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.s_Mark == 0)
    {
        HMTopicClass *topicClass = [self.s_TopicArray objectAtIndex:indexPath.row];
        
        NSString *tid = topicClass.m_TopicId;
        
        NSString *title = topicClass.m_Title;
        [BBStatistic visitType:BABYTREE_TYPE_TOPIC_FAVIRATE contentId:tid];
        [HMShowPage showCollectedTopicDetail:self topicId:tid topicTitle:title];
    }
    else
    {
        BBKonwlegdeModel *model = [self.s_KnowledgeArray objectAtIndex:indexPath.row];
        NSString *knowledgeID = model.ID;
        BBKnowledgeLibDetailVC * kld = [[BBKnowledgeLibDetailVC alloc]initWithID:knowledgeID];
        kld.m_ReadKnowledgeFromWebOnly = YES;
        [self.navigationController pushViewController:kld animated:YES];
        kld.title = model.title;
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
    
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.m_DeleteRequest clearDelegatesAndCancel];
    
    self.s_ItemToDelete = nil;
    
    if (self.s_Mark == 0)
    {
        //取消收藏帖子
        if (indexPath.row>=0 && indexPath.row<[self.s_TopicArray count])
        {
            HMTopicClass *topicClass = [self.s_TopicArray objectAtIndex:indexPath.row];
            self.s_ItemToDelete = topicClass;
            NSString *tid = topicClass.m_TopicId;
            self.m_DeleteRequest = [HMApiRequest collectTopicAction:NO withTopicID:tid];
        }
        else
        {
            return;
        }
    }
    else
    {
        //取消收藏知识
        if (indexPath.row>=0 && indexPath.row<[self.s_KnowledgeArray count])
        {
            BBKonwlegdeModel *model = [self.s_KnowledgeArray objectAtIndex:indexPath.row];
            self.s_ItemToDelete = model;
            //被删除的知识也可以被取消收藏，所以注释掉下面判断
            NSString *knowledgeID = model.ID;
            self.m_DeleteRequest = [BBKnowledgeRequest collectKnowledgeWithID:knowledgeID isDelete:YES];
        }
        else
        {
            return;
        }
    }
    [self.m_LoadProgress show:YES];
    [self.m_DeleteRequest setDelegate:self];
    [self.m_DeleteRequest setDidFailSelector:@selector(deletecontentFail:)];
    [self.m_DeleteRequest setDidFinishSelector:@selector(deletecontentFinish:)];
    [self.m_DeleteRequest startAsynchronous];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - reply topic ASIHttpRequest Delegate
- (void)deletecontentFinish:(ASIHTTPRequest *)request
{
    if (!self.m_LoadProgress.isHidden) {
        [self.m_LoadProgress hide:YES];
    }
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *deleteUserData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        [AlertUtil showAlert:@"提示！" withMessage:@"操作失败！"];
        return;
    }
    if ([[deleteUserData stringForKey:@"status"] isEqualToString:@"success"] || [[deleteUserData stringForKey:@"status"] isEqualToString:@"0"])
    {
        [MobClick event:@"my_center_v2" label:@"取消收藏成功数"];
        if (self.s_ItemToDelete == nil)
        {
            return;
        }
        //删除指定数据
        if (self.s_Mark == 0)
        {
            //取消收藏帖子
            NSUInteger index = [self.s_TopicArray indexOfObject:self.s_ItemToDelete];
            if (index == NSNotFound)
            {
                return;
            }
            else
            {
                [self.s_TopicArray removeObjectAtIndex:index];
                [self.m_TopicTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
        else
        {
            //取消收藏知识
            NSUInteger index = [self.s_KnowledgeArray indexOfObject:self.s_ItemToDelete];
            if (index == NSNotFound)
            {
                return;
            }
            else
            {
                [self.s_KnowledgeArray removeObjectAtIndex:index];
                [self.m_TopicTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
    else
    {
        [AlertUtil showAlert:@"提示！" withMessage:@"亲，您的网络不给力！"];
    }
    
    if (self.s_Mark == 0)
    {
        if (self.s_TopicArray.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_PROMPT];
        }
    }
    else if(self.s_Mark == 1)
    {
        if (self.s_KnowledgeArray.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_PROMPT];
        }
    }
}
- (void)deletecontentFail:(ASIFormDataRequest *)request
{
    if (!self.m_LoadProgress.isHidden) {
        [self.m_LoadProgress hide:YES];
    }
    [AlertUtil showAlert:@"提示！" withMessage:@"亲，您的网络不给力！"];
}

#pragma mark -
#pragma mark EGORefresh
- (void)reloadTableViewDataSource
{
    _refresh_pull_up_header_view.refreshStatus = NO;
    [_refresh_pull_up_header_view setState:EGOOPullUpRefreshNormal];
    
    if(_pull_up_reloading !=YES&&_reloading!=YES){
        _reloading = YES;
        if (self.s_Mark == 0)
        {
            self.s_TopicPage = 1;
           [self loadData];
        }
        else
        {
            self.s_KnowledgePage = 1;
            [self loadKnowladge];
        }
    }else{
        if(_pull_up_reloading==YES){
            [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refresh_header_view egoRefreshScrollViewDataSourceDidFinishedLoading:self.m_TopicTable];
}

- (void)reloadPullUpTableViewDataSource
{
    if(_reloading!=YES&&_pull_up_reloading!=YES){
        _pull_up_reloading = YES;
        if (self.s_Mark == 0)
        {
            if (!_refresh_pull_up_header_view.refreshStatus)
            {
                self.s_TopicPage++;
            }
            [self loadData];
        }
        else
        {
            if (!_refresh_pull_up_header_view.refreshStatus)
            {
                self.s_KnowledgePage++;
            }
            [self loadKnowladge];
        }
    }else{
        if(_reloading==YES){
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }
}

- (void)doneLoadingPullUpTableViewData
{
    _pull_up_reloading = NO;
    [_refresh_pull_up_header_view egoRefreshPullUpScrollViewDataSourceDidFinishedLoading:self.m_TopicTable];
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

-(void)refreshLoadData
{

    if (self.s_Mark == 0)
    {
        self.s_TopicPage = 1;
        [self loadData];
    }
    else
    {
        self.s_KnowledgePage = 1;
        [self loadKnowladge];
    }
}

#pragma mark - HMNoDataViewDelegate andOtherFunction

-(void)freshFromNoDataView
{
    if (self.s_Mark == 0)
    {
        [self loadData];
    }
    else if(self.s_Mark == 1)
    {
        [self loadKnowladge];
    }
}

-(void)addNoDataView
{
    self.m_NoDataView = [[HMNoDataView alloc] initWithType:HMNODATAVIEW_CUSTOM];
    [self.m_TopicTable addSubview:self.m_NoDataView];
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
