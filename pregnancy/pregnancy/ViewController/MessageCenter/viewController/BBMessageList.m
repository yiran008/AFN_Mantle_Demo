//
//  BBMessageList.m
//  pregnancy
//
//  Created by Wang Jun on 12-11-19.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBMessageList.h"
#import "MobClick.h"
#import "BBNavigationLabel.h"
#import "HMShowPage.h"
#import "BBMessageListUserListCell.h"
#import "BBMessageRequest.h"
#import "AlertUtil.h"
#import "BBMessageChat.h"
#import "BBAppConfig.h"
#import "BBFatherInfo.h"
#import "BBNotificationCell.h"
#import "BBCustemSegment.h"
#import "ASIFormDataRequest.h"
#import "HMNoDataView.h"
#import "BBFeedCell.h"
#import "BBFeedClass.h"
#import "BBPersonalViewController.h"

@interface BBMessageList ()
<
    HMNoDataViewDelegate
>

@property (nonatomic, strong) ASIFormDataRequest *s_LoadDataRequest;

@property (nonatomic, strong) ASIFormDataRequest *s_DeleteMessageRequest;

@property (strong, nonatomic) IBOutlet UIImageView *s_TopBgView;

@property (nonatomic,strong) NSMutableArray *s_MessageArray;

@property (nonatomic,strong) NSMutableArray *s_NoticeArray;

@property (nonatomic,strong) NSMutableArray *s_FeedArray;

//segment上小红点
@property (nonatomic,strong) UIImageView *s_MessagePointImageView;

@property (nonatomic,strong) UIImageView *s_NoticePointImageView;

//记录私信列表上次的滑动位置
@property (nonatomic,assign) CGPoint s_LastMessageOffSet;

//记录通知列表上次的滑动位置
@property (nonatomic,assign) CGPoint s_LastNoticeOffSet;

@property (nonatomic,assign) CGPoint s_LastFeedOffSet;

@property (nonatomic,assign) NSInteger s_FeedStartPg;

@property (nonatomic,strong) NSString *s_FeedEndTs;

@property (nonatomic, strong) BBCustemSegment *segmented;

@property (assign)BOOL s_RefreshFeedList;

@property (assign)BOOL s_RefreshNoticeList;

@property (assign)BOOL s_FeedListBottomFreshStatus;

@property (assign)BOOL s_NoticeListBottomFreshStatus;

@end

@implementation BBMessageList


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _m_CurrentMessageListType = BBMessageListTypeFeed;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息中心";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    self.view.backgroundColor = RGBColor(239, 239, 244, 1);
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    self.s_MessageArray = [[NSMutableArray alloc]init];
    self.s_NoticeArray = [[NSMutableArray alloc]init];
    self.s_FeedArray = [[NSMutableArray alloc]init];
    
    self.s_LastMessageOffSet = CGPointMake(0, 0);
    self.s_LastNoticeOffSet = CGPointMake(0, 0);
    self.s_LastFeedOffSet = CGPointMake(0, 0);
    
    self.s_FeedStartPg = 0;
    self.s_FeedEndTs = @"0";
    
    self.m_Table.height = DEVICE_HEIGHT - UI_NAVIGATION_BAR_HEIGHT*2 - UI_STATUS_BAR_HEIGHT;
    self.m_Table.top = UI_NAVIGATION_BAR_HEIGHT;
    
    __weak __typeof (self) weakself = self;
    _segmented=[[BBCustemSegment alloc] initWithFrame:CGRectMake(12, 9, 296, 26) items:@[@{@"text":@"动态",},@{@"text":@"私信",},@{@"text":@"通知"}]
        andSelectionBlock:^(NSUInteger segmentIndex) {
        __strong __typeof (weakself) strongself = weakself;
        if (strongself)
        {
            if (strongself.m_CurrentMessageListType == segmentIndex)
            {
                return;
            }
            
            [strongself.segmented setNoDataViewStatusInfoWithArrayIndex:strongself.m_CurrentMessageListType withNoDataType:strongself.m_NoDataView.m_Type withHidden:strongself.m_NoDataView.hidden];
            
            [strongself saveCurrentTableViewOffset];
            
            BOOL needRefresh = NO;
            
            if (segmentIndex == BBMessageListTypeFeed)
            {
                [MobClick event:@"message_v2" label:@"动态列表页pv"];
                strongself.m_CurrentMessageListType = BBMessageListTypeFeed;
                strongself->_refresh_bottom_view.hidden = NO;
                strongself->_refresh_bottom_view.refreshStatus = strongself.s_FeedListBottomFreshStatus;
                [strongself.m_Table reloadData];
                [strongself.m_Table setContentOffset:self.s_LastFeedOffSet animated:NO];
                if ([strongself.s_FeedArray count] == 0)
                {
                    needRefresh = YES;
                }
            }
            else if (segmentIndex == BBMessageListTypeMessage)
            {
                [MobClick event:@"message_v2" label:@"私信列表页pv"];
                strongself.m_CurrentMessageListType = BBMessageListTypeMessage;
                strongself->_refresh_bottom_view.hidden = YES;
                [strongself.m_Table reloadData];
                [strongself.m_Table setContentOffset:self.s_LastMessageOffSet animated:NO];
                if ([strongself.s_MessageArray count] == 0)
                {
                    needRefresh = YES;
                }
            }
            else
            {
                [MobClick event:@"message_v2" label:@"通知列表页"];
                strongself.m_CurrentMessageListType = BBMessageListTypeNotice;
                strongself->_refresh_bottom_view.hidden = NO;
                strongself->_refresh_bottom_view.refreshStatus = strongself.s_NoticeListBottomFreshStatus;
                [strongself.m_Table reloadData];
                [strongself.m_Table setContentOffset:self.s_LastNoticeOffSet animated:NO];
                if ([strongself.s_NoticeArray count] == 0)
                {
                    needRefresh = YES;
                }
            }
            
            NSDictionary *noDataStatusDic = [strongself.segmented getNoDataStatusWithIndex:segmentIndex];
            strongself.m_NoDataView.m_Type = (HMNODATAVIEW_TYPE)noDataStatusDic[@"noDataViewType"];
            strongself.m_NoDataView.hidden = [noDataStatusDic[@"noDataViewHidden"] boolValue];
            if (needRefresh)
            {
                [strongself freshData];
            }
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
    
    UIImage *tempImage=  [UIImage imageNamed:@"head_tab_bg"];
    self.s_TopBgView.image = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 3, 3)];
    
    self.s_MessagePointImageView = [[UIImageView alloc]initWithFrame:CGRectMake(161, 2, 8, 8)];
    [self.s_MessagePointImageView setImage:[UIImage imageNamed:@"new_point"]];
    [_segmented addSubview:self.s_MessagePointImageView];
    self.s_MessagePointImageView.hidden = YES;
    
    self.s_NoticePointImageView =[[UIImageView alloc]initWithFrame:CGRectMake(260, 2, 8, 8)];
    [self.s_NoticePointImageView setImage:[UIImage imageNamed:@"new_point"]];
    [_segmented addSubview:self.s_NoticePointImageView];
    self.s_NoticePointImageView.hidden = YES;
    
    [_segmented setEnabled:YES forSegmentAtIndex:self.m_CurrentMessageListType];
    [self.view addSubview:_segmented];
    
    //iphone5适配
    IPHONE5_ADAPTATION
    [self bringSomeViewToFront];
    [self freshData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUnreadNoticePointStatus];
    [self updateUnreadMessagePointStatus];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //防止处于编辑模式，离开页面导致crash
    self.m_Table.editing = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [_s_LoadDataRequest clearDelegatesAndCancel];
    [_s_DeleteMessageRequest clearDelegatesAndCancel];
}


#pragma mark- 切换页面

- (void)saveCurrentTableViewOffset
{
    if (self.m_CurrentMessageListType == BBMessageListTypeFeed)
    {
        self.s_LastFeedOffSet = self.m_Table.contentOffset;
    }
    else if (self.m_CurrentMessageListType == BBMessageListTypeMessage)
    {
        self.s_LastMessageOffSet = self.m_Table.contentOffset;
    }
    else
    {
        self.s_LastNoticeOffSet = self.m_Table.contentOffset;
    }
}


#pragma mark- UI

-(void)updateUnreadMessagePointStatus
{
    BOOL hasUnread = NO;
    if ([self.s_MessageArray count]>0)
    {
        
        for (NSDictionary *sixinItem in self.s_MessageArray)
        {
            if([sixinItem stringForKey:@"unread_count"]!=nil)
            {
                if ([[sixinItem stringForKey:@"unread_count"] integerValue]>0)
                {
                    hasUnread = YES;
                    break;
                }
            }
        }
        
    }
    else
    {
        if ([BBUser getUserUnreadSiXinCount] > 0)
        {
            hasUnread = YES;
        }
    }
    
    if (hasUnread)
    {
        self.m_MessageRedPointStatus |= BBMessageRedPointStatusMessage;
    }
    else
    {
        self.m_MessageRedPointStatus &= (~BBMessageRedPointStatusMessage);
    }
    
    if(self.m_MessageRedPointStatus & BBMessageRedPointStatusMessage)
    {
        self.s_MessagePointImageView.hidden = NO;
    }
    else
    {
        self.s_MessagePointImageView.hidden = YES;
    }
}

-(void)updateUnreadNoticePointStatus
{
    if (self.m_MessageRedPointStatus & BBMessageRedPointStatusNotification)
    {
        self.s_NoticePointImageView.hidden = NO;
    }
    else
    {
        self.s_NoticePointImageView.hidden = YES;
    }
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 请求数据

-(void)freshData
{
    if (self.m_CurrentMessageListType == BBMessageListTypeFeed)
    {
        self.s_FeedStartPg = 0;
        self.s_FeedEndTs = @"0";
        self.s_RefreshFeedList = YES;
        _refresh_bottom_view.refreshStatus = NO;
        self.s_FeedListBottomFreshStatus = NO;
    }
    else if (self.m_CurrentMessageListType == BBMessageListTypeMessage)
    {
    }
    else
    {
        self.s_RefreshNoticeList = YES;
        _refresh_bottom_view.refreshStatus = NO;
        self.s_NoticeListBottomFreshStatus = NO;
    }
    [self loadData];
}

-(void)loadNextData
{
    if (self.m_CurrentMessageListType == BBMessageListTypeFeed)
    {
        self.s_RefreshFeedList = NO;
        if (self.s_FeedListBottomFreshStatus)
        {
            [self hideEGORefreshView];
            return;
        }
    }
    else if (self.m_CurrentMessageListType == BBMessageListTypeMessage)
    {
        [self hideEGORefreshView];
        return;
    }
    else
    {
        self.s_RefreshNoticeList = NO;
        if (self.s_NoticeListBottomFreshStatus)
        {
            [self hideEGORefreshView];
            return;
        }
    }
    [self loadData];
}

- (void)loadData
{
    self.m_ProgressHUD.labelText = @"加载中...";
    [self.m_ProgressHUD show:YES];
    [self.s_LoadDataRequest clearDelegatesAndCancel];
    if (self.m_CurrentMessageListType == BBMessageListTypeFeed)
    {
        self.s_LoadDataRequest = [BBMessageRequest feedListwithStart:self.s_FeedStartPg withEndTime:self.s_FeedEndTs];
        [self.s_LoadDataRequest setDidFinishSelector:@selector(feedListRequestFinished:)];
        [self.s_LoadDataRequest setDidFailSelector:@selector(feedListRequestFailed:)];
    }
    else if (self.m_CurrentMessageListType == BBMessageListTypeMessage)
    {
        self.s_LoadDataRequest  = [BBMessageRequest userChatUserList];
        [self.s_LoadDataRequest setDidFinishSelector:@selector(messageListRequestFinished:)];
        [self.s_LoadDataRequest setDidFailSelector:@selector(messageListRequestFailed:)];
    }
    else
    {
        NSInteger startIndex = [self.s_NoticeArray count];
        if (self.s_RefreshNoticeList)
        {
            startIndex = 0;
        }
        self.s_LoadDataRequest = [BBMessageRequest topicMsgListWithStart:startIndex withLimit:20];
        [self.s_LoadDataRequest setDidFinishSelector:@selector(noticeListRequestFinished:)];
        [self.s_LoadDataRequest setDidFailSelector:@selector(noticeListRequestFailed:)];
    }
    
    [self.s_LoadDataRequest setDelegate:self];
    [self.s_LoadDataRequest startAsynchronous];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.m_CurrentMessageListType == BBMessageListTypeFeed)
    {
        return [self.s_FeedArray count];
    }
    else if(self.m_CurrentMessageListType == BBMessageListTypeMessage)
    {
        return [self.s_MessageArray count];
    }
    else
    {
        return [self.s_NoticeArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.m_CurrentMessageListType == BBMessageListTypeFeed)
    {
        static NSString *inviteTableViewCell = @"BBFeedCell";
        BBFeedCell *cell = (BBFeedCell*)[tableView dequeueReusableCellWithIdentifier:inviteTableViewCell];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BBFeedCell" owner:self options:nil] lastObject];
        }
        [cell setCellWithData:(BBFeedClass*)[self.s_FeedArray objectAtIndex:indexPath.row]];
        [cell.userAvatarButton addTarget:self action:@selector(avatarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.userAvatarButton.tag = 100+indexPath.row;
        return cell;
    }
    else if(self.m_CurrentMessageListType == BBMessageListTypeMessage)
    {
        static NSString *inviteTableViewCell = @"BBMessageListUserListCell";
        BBMessageListUserListCell *cell = (BBMessageListUserListCell*)[tableView dequeueReusableCellWithIdentifier:inviteTableViewCell];
        if (cell == nil)
        {
            cell = [[BBMessageListUserListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inviteTableViewCell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
             cell.backgroundColor = [UIColor clearColor];
        }
        
        [cell setCellWithData:[self.s_MessageArray objectAtIndex:indexPath.row]];
        return cell;
    }
    else
    {
        static NSString *notificationCell = @"BBNotificationCell";
        BBNotificationCell *cell = (BBNotificationCell*)[tableView dequeueReusableCellWithIdentifier:notificationCell];
        if (cell == nil)
        {
            cell = [[BBNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:notificationCell];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        [cell setCellWithData:[self.s_NoticeArray objectAtIndex:indexPath.row]];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.m_CurrentMessageListType == BBMessageListTypeMessage)
    {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.m_ProgressHUD.labelText = @"正在删除...";
    [self.m_ProgressHUD show:YES];
    [self.s_DeleteMessageRequest clearDelegatesAndCancel];
    self.s_DeleteMessageRequest  = [BBMessageRequest deleteUserChatUserList:[[self.s_MessageArray objectAtIndex:indexPath.row]stringForKey:@"user_encode_id"]];
    [self.s_DeleteMessageRequest setDelegate:self];
    [self.s_DeleteMessageRequest setDidFinishSelector:@selector(deleteMessageFinished:)];
    [self.s_DeleteMessageRequest setDidFailSelector:@selector(deleteMessageFailed:)];
    [self.s_DeleteMessageRequest startAsynchronous];
}


#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.m_CurrentMessageListType == BBMessageListTypeFeed)
    {
        BBFeedClass *feedClass = (BBFeedClass*)[self.s_FeedArray objectAtIndex:indexPath.row];
        return feedClass.m_CellHeight;
    }
    else if(self.m_CurrentMessageListType == BBMessageListTypeMessage)
    {
        return 67;
    }
    else
    {
        return [BBNotificationCell heightForCellWithData:[self.s_NoticeArray objectAtIndex:indexPath.row]];
    }
}


- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.m_CurrentMessageListType == BBMessageListTypeFeed)
    {
        BBFeedClass *feedClass = (BBFeedClass*)[self.s_FeedArray objectAtIndex:indexPath.row];
        if ([feedClass.m_TopicId isNotEmpty])
        {
            [BBStatistic visitType:BABYTREE_TYPE_TOPIC_USER_EVENT contentId:feedClass.m_TopicId];
            [HMShowPage showTopicDetail:self topicId:feedClass.m_TopicId topicTitle:feedClass.m_Title];
        }
    }
    else if (self.m_CurrentMessageListType == BBMessageListTypeMessage)
    {
        NSDictionary *messageDict = [self.s_MessageArray objectAtIndex:indexPath.row];
        NSString *userEncodeId = [messageDict stringForKey:@"user_encode_id"];
        if (![userEncodeId isNotEmpty])
        {
            return;
        }
        NSString *nickname = [messageDict stringForKey:@"nickname" defaultString:@""];
        NSString *unreadCount = [messageDict stringForKey:@"unread_count" defaultString:@"0"];
        if ([unreadCount integerValue]>0)
        {
            NSMutableDictionary *replaceDict = [[NSMutableDictionary alloc]initWithDictionary:messageDict];
            [replaceDict setString:@"0" forKey:@"unread_count"];
            [self.s_MessageArray replaceObjectAtIndex:indexPath.row withObject:replaceDict];
            [self updateUnreadMessagePointStatus];
            BBMessageListUserListCell *cell = (BBMessageListUserListCell*)[self.m_Table cellForRowAtIndexPath:indexPath];
            cell.unreadMessageCount.hidden = YES;
        }
        BBMessageChat *messageChat = [[BBMessageChat alloc]initWithNibName:@"BBMessageChat" bundle:nil];
        messageChat.title= nickname;
        messageChat.userEncodeId = userEncodeId;
        [self.navigationController pushViewController:messageChat animated:YES];
    }
    else
    {
        NSDictionary *msgData = [self.s_NoticeArray objectAtIndex:indexPath.row];
        if ([[msgData stringForKey:@"type"] isEqualToString:@"1"])
        {
            NSDictionary *topicData = [NSDictionary dictionaryWithObjectsAndKeys:[msgData stringForKey:@"is_fav"], @"is_fav", [msgData stringForKey:@"response_count"], @"response_count", [msgData stringForKey:@"author_response_count"], @"author_response_count", [msgData stringForKey:@"topic_id"], @"id", nil];
            [BBStatistic visitType:BABYTREE_TYPE_TOPIC_MESSAGE contentId:[topicData stringForKey:@"id"]];
            [HMShowPage showTopicDetail:self topicId:[topicData stringForKey:@"id"] topicTitle:[topicData stringForKey:@"title"]];
        }
        else if ([[msgData stringForKey:@"type"] isEqualToString:@"2"])
        {
            
            NSInteger response_count = [msgData intForKey:@"response_floor"];
            NSString *reply_id = [msgData stringForKey:@"reply_id"];
            [BBStatistic visitType:BABYTREE_TYPE_TOPIC_MESSAGE contentId:[msgData stringForKey:@"topic_id"]];
            if ([reply_id isNotEmpty])
            {
                [HMShowPage showTopicDetail:self topicId:[msgData stringForKey:@"topic_id"] topicTitle:nil replyID:reply_id showError:YES];
            }
            else
            {
                [HMShowPage showTopicDetail:self topicId:[msgData stringForKey:@"topic_id"] topicTitle:nil positionFloor:response_count];
            }
        }
    }
    [table deselectRowAtIndexPath:[table indexPathForSelectedRow] animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)avatarButtonClicked:(id)sender
{
    UIButton *avatarButton = (UIButton*)sender;
    int index = avatarButton.tag - 100;
    if (index>=0 && index< [self.s_FeedArray count])
    {
        BBFeedClass *feedClass = (BBFeedClass*)[self.s_FeedArray objectAtIndex:index];
        if([feedClass.m_PosterId isNotEmpty])
        {
            BBPersonalViewController *userInformation = [[BBPersonalViewController alloc]initWithNibName:@"BBPersonalViewController" bundle:nil];
            userInformation.userEncodeId = feedClass.m_PosterId;
            userInformation.userName = feedClass.m_PosterName;
            [self.navigationController pushViewController:userInformation animated:YES];
        }
    }
}
#pragma mark- Feed Request Delegate

- (void)feedListRequestFinished:(ASIFormDataRequest *)request
{
    if (!self.m_ProgressHUD.isHidden)
    {
        [self.m_ProgressHUD hide:YES];
    }
    [self hideEGORefreshView];
    [self changeNoDataViewWithHiddenStatus:YES];
    NSString *responseString = [request responseString];
    //过滤换行符，换行符会导致无法正确计算字符串高度。
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *dictData = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        if (self.s_NoticeArray.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
        }
        else if ([self isVisible])
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }
        return;
    }
    if ([[dictData stringForKey:@"status"] isEqualToString:@"success"])
    {
        NSArray *feedList = [[dictData dictionaryForKey:@"data"]arrayForKey:@"list"];
        if ([feedList count] == 0)
        {
            _refresh_bottom_view.refreshStatus = YES;
            self.s_FeedListBottomFreshStatus = YES;
        }
        if (self.s_RefreshFeedList)
        {
            [self.s_FeedArray removeAllObjects];
            self.s_RefreshFeedList = NO;
        }
        self.s_FeedStartPg = [[dictData dictionaryForKey:@"data"] intForKey:@"pg"];
        self.s_FeedEndTs = [[dictData dictionaryForKey:@"data"] stringForKey:@"end_ts"];
        for (NSDictionary *dict in feedList)
        {
            BBFeedClass *feedClass = [[BBFeedClass alloc]init];
            feedClass.m_PosterImage = [dict stringForKey:@"thumb"];
            feedClass.m_PosterId = [dict stringForKey:@"user_id"];
            feedClass.m_PosterName = [dict stringForKey:@"send_nickname"];
            feedClass.m_PosterLevel = [dict intForKey:@"level_num"];
            feedClass.m_PraiseCount = [dict intForKey:@"praise_count"];
            feedClass.m_Title = [dict stringForKey:@"title"];
            feedClass.m_CircleName = [dict stringForKey:@"group_name" defaultString:@""];
            feedClass.m_CreateTime = [dict intForKey:@"create_ts"];
            feedClass.m_BabyAge = [dict stringForKey:@"baby_age"];
            feedClass.m_Summary = [dict stringForKey:@"content"];
            feedClass.m_TopicId = [dict stringForKey:@"discussion_id"];
            NSDictionary *pics = [dict dictionaryForKey:@"pics"];
            if (pics)
            {
                feedClass.m_HasPic = YES;
            }
            feedClass.m_ResponseTime = [dict intForKey:@"response_id"];
            feedClass.m_ResponseCount = [dict intForKey:@"response_count"];
            feedClass.m_IsElite = [dict boolForKey:@"is_elite"];
            feedClass.m_IsHelp = [dict boolForKey:@"is_question"];
            feedClass.m_CellHeight = [feedClass cellHeight];
            
            [self.s_FeedArray addObject:feedClass];
        }
        [self.m_Table reloadData];
    }
    
    if (self.s_FeedArray.count == 0)
    {
        [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_PROMPT];
    }
    
}

- (void)feedListRequestFailed:(ASIFormDataRequest *)request
{
    if (!self.m_ProgressHUD.isHidden) {
        [self.m_ProgressHUD hide:YES];
    }
    [self hideEGORefreshView];
    if (self.s_FeedArray.count > 0)
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
}

#pragma mark- Notice Request Delegate

- (void)noticeListRequestFinished:(ASIFormDataRequest *)request
{
    if (!self.m_ProgressHUD.isHidden)
    {
        [self.m_ProgressHUD hide:YES];
    }
    [self hideEGORefreshView];
    [self changeNoDataViewWithHiddenStatus:YES];
    NSString *responseString = [request responseString];
    //过滤换行符，换行符会导致无法正确计算字符串高度。
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@" "];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *submitReplyData = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        if (self.s_NoticeArray.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
        }
        else if ([self isVisible])
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }
        return;
    }
    if ([[submitReplyData stringForKey:@"status"] isEqualToString:@"success"])
    {
        [BBUser setUserUnreadTongZhiCount:0];
        NSArray *noticeList = [[submitReplyData dictionaryForKey:@"data"]arrayForKey:@"notice_list"];
        if ([noticeList count] == 0)
        {
            _refresh_bottom_view.refreshStatus = YES;
            self.s_NoticeListBottomFreshStatus = YES;
        }
        if (self.s_RefreshNoticeList)
        {
            [self.s_NoticeArray removeAllObjects];
            self.s_RefreshNoticeList = NO;
        }
        [self.s_NoticeArray addObjectsFromArray:noticeList];
        [self.m_Table reloadData];
    }

    if (self.s_NoticeArray.count == 0)
    {
        [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_PROMPT];
    }
    self.m_MessageRedPointStatus &= (~BBMessageRedPointStatusNotification);
    [self updateUnreadNoticePointStatus];
}

- (void)noticeListRequestFailed:(ASIFormDataRequest *)request
{
    if (!self.m_ProgressHUD.isHidden) {
        [self.m_ProgressHUD hide:YES];
    }
    [self hideEGORefreshView];
    if (self.s_NoticeArray.count > 0)
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
}

#pragma mark- Message Request Delegate

- (void)messageListRequestFinished:(ASIFormDataRequest *)request
{
    if (!self.m_ProgressHUD.isHidden)
    {
        [self.m_ProgressHUD hide:YES];
    }
    [self hideEGORefreshView];
    [self changeNoDataViewWithHiddenStatus:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *responseData = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    NSString *status =[responseData stringForKey:@"status"] ;
    if ([status isEqualToString:@"success"])
    {
        [BBUser setUserUnreadSiXinCount:0];
        self.s_MessageArray =[NSMutableArray arrayWithArray:[[responseData dictionaryForKey:@"data"]arrayForKey:@"list"]];
        [self.m_Table reloadData];
    }
    else
    {
        if (self.s_MessageArray.count > 0)
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
    }
    
    if (self.s_MessageArray.count == 0)
    {
        [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_PROMPT];
    }

    [self updateUnreadMessagePointStatus];
}

- (void)messageListRequestFailed:(ASIFormDataRequest *)request
{
    if (!self.m_ProgressHUD.isHidden)
    {
        [self.m_ProgressHUD hide:YES];
    }
    [self hideEGORefreshView];
    if (self.s_MessageArray.count > 0)
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
}


#pragma mark- Delete Message Request Delegate

- (void)deleteMessageFinished:(ASIHTTPRequest *)request
{
    if (!self.m_ProgressHUD.isHidden)
    {
        [self.m_ProgressHUD hide:YES];
    }
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *deleteUserData = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([[deleteUserData stringForKey:@"status"] isEqualToString:@"success"])
    {
        [self freshData];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)deleteMessageFailed:(ASIFormDataRequest *)request
{
    if (!self.m_ProgressHUD.isHidden) {
        [self.m_ProgressHUD hide:YES];
    }
    [AlertUtil showAlert:@"提示！" withMessage:@"亲，您的网络不给力！"];
}

#pragma mark - HMNoDataViewDelegate andOtherFunction

-(void)freshFromNoDataView
{
    [self freshData];
}

-(void)changeNoDataViewWithHiddenStatus:(BOOL)theHiddenStatus
{
    [self changeNoDataViewWithHiddenStatus:theHiddenStatus withType:HMNODATAVIEW_CUSTOM];
}

-(void)changeNoDataViewWithHiddenStatus:(BOOL)theHiddenStatus withType:(HMNODATAVIEW_TYPE)theType
{
    self.m_NoDataView.m_Type = theType;
    self.m_NoDataView.hidden = theHiddenStatus;
    [self.segmented setNoDataViewStatusInfoWithArrayIndex:self.m_CurrentMessageListType withNoDataType:theType withHidden:theHiddenStatus];
}

@end
