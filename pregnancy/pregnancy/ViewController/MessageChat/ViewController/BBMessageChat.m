//
//  BBMessageView.m
//  pregnancy
//
//  Created by mac on 12-12-24.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBMessageChat.h"
#import "BBMessageRequest.h"
#import "BBApp.h"
#import "BBNavigationLabel.h"
#import "BBAppConfig.h"
#import "BBAppDelegate.h"
#import "BBPersonalViewController.h"
#import "BBSupportTopicDetail.h"
#import "HMShowPage.h"
#import "BBBabyBornViewController.h"


#define EDIT_BUTTON_TAG         100
#define REFRESH_BUTTON_TAG      200
#define BACK_ALERT_VIEW_TAG     101

@interface BBMessageChat ()
<
    UIAlertViewDelegate
>

@property (nonatomic, retain) UIButton *rightButton;
@property (nonatomic, retain) UIButton *editButton;
@property (nonatomic, retain) UIButton *refreshButton;

@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;
@property (nonatomic, strong) NSMutableString *s_IFlyString;

@end

@implementation BBMessageChat
@synthesize commentRequest,deleteMessageRequest,sendMessageRequest,chatArr,chatTableView,isEdit,userEncodeId,hud,toolbar,deleteBtn,messageTextField,messageIdsList,touchRecognizer,upLoadLogRequest;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [commentRequest clearDelegatesAndCancel];
    [commentRequest release];
    [deleteMessageRequest clearDelegatesAndCancel];
    [deleteMessageRequest release];
    [sendMessageRequest clearDelegatesAndCancel];
    [sendMessageRequest release];
    [upLoadLogRequest clearDelegatesAndCancel];
    [upLoadLogRequest release];
    [chatTableView release];
    [chatArr release];
    [userEncodeId release];
    [hud release];
    [toolbar release];
    [deleteBtn release];
    [messageTextField release];
    [messageIdsList release];
    [touchRecognizer release];
    [_rightButton release];
    [_editButton release];
    [_refreshButton release];
    
    [_iflyRecognizerView cancel];
    [IFlySpeechUtility destroy];
    [_iflyRecognizerView release];

    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.chatArr = [[[NSMutableArray alloc]init]autorelease];
        self.isEdit=NO;
        self.messageIdsList = [[[NSMutableArray alloc]init]autorelease];
        //接收键盘出现通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

     [self.chatTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.title withWidth:100]];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    [self addRightBarButton];
    
    //输入背景框
    UIImageView * tfBack = (UIImageView *)[self.view viewWithTag:997];
    tfBack.image = [[UIImage imageNamed:@"enter_kuang"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];

    [chatTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //初始化下拉视图
    if (_refresh_header_view == nil) {
        EGORefreshTableHeaderView *pullDownView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0-self.chatTableView.frame.size.height, self.chatTableView.frame.size.width, self.chatTableView.frame.size.height)];
        pullDownView.delegate = self;
        pullDownView.isLoadNext = YES;
        [chatTableView addSubview:pullDownView];
        _refresh_header_view = pullDownView;
        [pullDownView release];
    }
    [_refresh_header_view refreshLastUpdatedDate];
    self.hud = [[[MBProgressHUD alloc]initWithView:self.view]autorelease];
    [self.view addSubview:hud];
    [hud setMode:MBProgressHUDModeIndeterminate];
    hud.labelText = @"加载中...";
    [hud show:YES];
    [self reloadData];
    
    //iphone5适配
    IPHONE5_ADAPTATION

    if (IS_IPHONE5) {
        [self.deleteBtn setFrame:CGRectMake(deleteBtn.frame.origin.x, deleteBtn.frame.origin.y + 88, deleteBtn.frame.size.width, deleteBtn.frame.size.height)];
        [self.toolbar setFrame:CGRectMake(self.toolbar.frame.origin.x, self.toolbar.frame.origin.y + 88, self.toolbar.frame.size.width, self.toolbar.frame.size.height)];
    }
    [deleteBtn setBackgroundImage:[[UIImage imageNamed:@"message_button"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[[UIImage imageNamed:@"message_button"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];
    
    [BBIflyMSC firstInit];
    self.iflyRecognizerView = [BBIflyMSC CreateRecognizerView:self];
    self.s_IFlyString  = nil;

    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDismiss:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.chatTableView addGestureRecognizer:recognizer];
    [recognizer release];
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDismiss:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.chatTableView addGestureRecognizer:recognizer];
    [recognizer release];
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDismiss:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.chatTableView addGestureRecognizer:recognizer];
    [recognizer release];
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDismiss:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.chatTableView addGestureRecognizer:recognizer];
    [recognizer release];
    
    self.touchRecognizer = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDismiss:)] autorelease];
    [touchRecognizer setNumberOfTapsRequired:1];
}

- (void)addRightBarButton
{
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.exclusiveTouch = YES;
    [self.editButton setFrame:CGRectMake(0, 0, 40, 30)];
    [self.editButton setImage:[UIImage imageNamed:@"message_bianji"] forState:UIControlStateNormal];
    [self.editButton setImage:[UIImage imageNamed:@"message_bianji_pressed"] forState:UIControlStateHighlighted];
    [self.editButton addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshButton.exclusiveTouch = YES;
    [self.refreshButton setFrame:CGRectMake(0, 0, 40, 30)];
    [self.refreshButton setImage:[UIImage imageNamed:@"message_reload"] forState:UIControlStateNormal];
    [self.refreshButton setImage:[UIImage imageNamed:@"message_reload_pressed"] forState:UIControlStateHighlighted];
    [self.refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *editBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.editButton] autorelease];
    UIBarButtonItem *refreshBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.refreshButton] autorelease];
    self.navigationItem.rightBarButtonItems = @[refreshBarButton,editBarButton];
    
    self.rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.exclusiveTouch = YES;
    [self.rightButton setFrame:CGRectMake(252, 0, 50, 34)];
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton setBackgroundColor:[UIColor clearColor]];
    
    [self.rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [self.rightButton addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self keyboardDismiss:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MobClick event:@"message_v2" label:@"私信详情页"];
}

-(IBAction)toggleEdit:(id)sender {
    if ([hud isShow]) {
        return;
    }

	if (self.isEdit){
		self.isEdit = NO;
        self.navigationItem.rightBarButtonItem = nil;
        
        UIBarButtonItem *editBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.editButton] autorelease];
        UIBarButtonItem *refreshBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.refreshButton] autorelease];
        self.navigationItem.rightBarButtonItems = @[refreshBarButton,editBarButton];
        
        [deleteBtn setHidden:YES];
        [toolbar setHidden:NO];
	}
    else{
		self.isEdit = YES;
        self.navigationItem.rightBarButtonItems = nil;
        UIBarButtonItem *doneBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.rightButton] autorelease];
        self.navigationItem.rightBarButtonItem = doneBarButton;
        
        [toolbar setHidden:YES];
        [deleteBtn setHidden:NO];
        [messageIdsList removeAllObjects];
    }
    [chatTableView reloadData];
    [self keyboardDismiss:nil];
}

- (void)refresh {
    [hud setMode:MBProgressHUDModeIndeterminate];
    hud.labelText = @"刷新中...";
    [hud show:YES];
    [self reloadData];
}

-(IBAction)deleteMessagesAction:(id)sender{
    NSString *messageIds;
    if ([messageIdsList count]==0) {
        [hud setMode:MBProgressHUDModeText];
        hud.labelText = @"您还没有选择要删除的文件...";
        [hud show:YES];
        [self.hud hide:YES afterDelay:2];
        return;
    }
    [hud setMode:MBProgressHUDModeIndeterminate];
    hud.labelText = @"删除文件中...";
    [hud show:YES];
    messageIds = [messageIdsList objectAtIndex:0];
    for (int i=1; i<[messageIdsList count]; i++) {
        messageIds = [NSString stringWithFormat:@"%@,%@",messageIds,[messageIdsList objectAtIndex:i]];
    }
    [deleteMessageRequest clearDelegatesAndCancel];
    self.deleteMessageRequest = [BBMessageRequest deleteChatInfoMessages:messageIds];
    [deleteMessageRequest setDelegate:self];
    [deleteMessageRequest setDidFinishSelector:@selector(deleteMessageFinished:)];
    [deleteMessageRequest setDidFailSelector:@selector(deleteMessageFailed:)];
    [deleteMessageRequest startAsynchronous];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//lijie 修改不支持旋转 6.0
- (BOOL)shouldAutorotate
{
    return NO;
}
//lijie 修改不支持旋转 6.0
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



#pragma mark -
#pragma mark Table View DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chatArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  [BBMessageCell calculateHeightWithContent:[self.chatArr objectAtIndex:[indexPath row]]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"BBMessageCell";
    BBMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[BBMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
    }
    BOOL selectStatus = NO;
    NSDictionary *content = [chatArr objectAtIndex:indexPath.row];
    for (NSString *messageId in messageIdsList) {
        if ([[content stringForKey:@"message_id" ] isEqualToString:messageId]) {
            selectStatus = YES;
        }
    }
    [cell setContent:content withEditStatus:isEdit withSelectStatus:selectStatus withBBMessageChatDelegate:self];
    return cell;
}
-(void)reloadData{
    //调用API请求 开始连接
    [commentRequest clearDelegatesAndCancel];
    self.commentRequest = [BBMessageRequest userChatInfoUserEncodeId:self.userEncodeId withStart:0 withLimit:20];
    [commentRequest setDelegate:self];
    [commentRequest setDidFinishSelector:@selector(reloadMessageFinished:)];
    [commentRequest setDidFailSelector:@selector(reloadMessageFailed:)];
    [commentRequest startAsynchronous];
}

- (void)reloadMessageFinished:(ASIHTTPRequest *)request
{
    if (!hud.isHidden) {
        [hud hide:YES];
    }
    //加载完成去掉加载框
    if(_reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *messageDictionary = [parser objectWithString:responseString error:&error];
    if (error) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"对不起，请求失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    NSString *status = [messageDictionary stringForKey:@"status"];
    if ([status isEqualToString:@"success"]) {
        [chatArr removeAllObjects];
        if ([[[messageDictionary dictionaryForKey:@"data"]arrayForKey:@"list"] count] != 0) {
            [chatArr removeAllObjects];
            NSArray *array = [NSArray arrayWithArray:[[messageDictionary dictionaryForKey:@"data"] arrayForKey:@"list"]];
            NSInteger count = [array count];
            for (int i=count-1; i>=0; i--) {
                [chatArr addObject:[array objectAtIndex:i]];
            }
            [chatTableView reloadData];
            
            if ([chatArr count]>0) {
                [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
        
    }else {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲！你的网络不给力" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)reloadMessageFailed:(ASIHTTPRequest *)request
{
    if (!hud.isHidden) {
        [hud hide:YES];
    }
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲！你的网络不给力" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

-(void)loadNextData{
    //调用API请求 开始连接
    [commentRequest clearDelegatesAndCancel];
    self.commentRequest = [BBMessageRequest userChatInfoUserEncodeId:self.userEncodeId withStart:[chatArr count] withLimit:10];
    [commentRequest setDelegate:self];
    [commentRequest setDidFinishSelector:@selector(loadNextMessageFinished:)];
    [commentRequest setDidFailSelector:@selector(loadNextMessageFailed:)];
    [commentRequest startAsynchronous];
}
- (void)loadNextMessageFinished:(ASIHTTPRequest *)request
{
    if (!hud.isHidden) {
        [hud hide:YES];
    }
    //加载完成去掉加载框
    if(_reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *messageDictionary = [parser objectWithString:responseString error:&error];
    if (error) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"对不起，请求失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    NSString *status = [messageDictionary stringForKey:@"status"];
    if ([status isEqualToString:@"success"]) {
        if ([(NSMutableArray * )[[messageDictionary dictionaryForKey:@"data"]arrayForKey:@"list"] count] != 0) {
            NSArray *array = [NSArray arrayWithArray:[[messageDictionary dictionaryForKey:@"data"] arrayForKey:@"list"]];
//            NSInteger count = [array count];
//            for (int i=count-1; i>=0; i--) {
            self.chatArr = [BBMessageChat filterRepeatObjectByAddAraay:array withOriginArray:self.chatArr];
//            }
            [chatTableView reloadData];
        }
    }else {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲！你的网络不给力" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)loadNextMessageFailed:(ASIHTTPRequest *)request
{
    if (!hud.isHidden) {
        [hud hide:YES];
    }
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲！你的网络不给力" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}
- (void)deleteMessageFinished:(ASIHTTPRequest *)request
{
    if (!hud.isHidden) {
        [hud hide:YES];
    }
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *messageDictionary = [parser objectWithString:responseString error:&error];
    if (error) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"对不起，请求失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    NSString *status = [messageDictionary stringForKey:@"status"];
    if ([status isEqualToString:@"success"]) {
        
        NSInteger count = [messageIdsList count];
        for (int i=0; i<count; i++) {
            NSInteger chatArrCount = [chatArr count];
            for (int j=0; j<chatArrCount;j++) {
                if ([[messageIdsList objectAtIndex:i] isEqualToString:[[chatArr objectAtIndex:j]stringForKey:@"message_id"]]) {
                    [chatArr removeObjectAtIndex:j];
                    break;
                }
            }
        }
        [messageIdsList removeAllObjects];
        [chatTableView reloadData];
    }else {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲！你的网络不给力" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)deleteMessageFailed:(ASIHTTPRequest *)request
{
    if (!hud.isHidden) {
        [hud hide:YES];
    }
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲！你的网络不给力" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

-(IBAction)sendMessageAction:(id)sender{
    if ([[messageTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"请输入发送信息内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alert show];
        return;
    }
    [self keyboardDismiss:nil];
    hud.labelText = @"发送消息中...";
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud show:YES];
    [sendMessageRequest clearDelegatesAndCancel];
    self.sendMessageRequest = [BBMessageRequest sendMessage:self.userEncodeId withMessageContent:messageTextField.text];
    [sendMessageRequest setDelegate:self];
    [sendMessageRequest setDidFinishSelector:@selector(sendMessageFinished:)];
    [sendMessageRequest setDidFailSelector:@selector(sendMessageFail:)];
    [sendMessageRequest startAsynchronous];
}
- (void)sendMessageFinished:(ASIHTTPRequest *)request
{
    //加载完成去掉加载框
    if(_reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *messageDictionary = [parser objectWithString:responseString error:&error];
    if (error) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"对不起，请求失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        if (!hud.isHidden) {
            [hud hide:YES];
        }
        return;
    }
    NSString *status = [messageDictionary stringForKey:@"status"];
    if ([status isEqualToString:@"success"]) {
        [MobClick event:@"message_v2" label:@"消息中心-成功发送私信数量"];
        messageTextField.text = @"";
        [self reloadData];
    }else {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[messageDictionary stringForKey:@"message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        if (!hud.isHidden) {
            [hud hide:YES];
        }
    }
}

- (void)sendMessageFail:(ASIHTTPRequest *)request
{
    if (!hud.isHidden) {
        [hud hide:YES];
    }
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲！你的网络不给力" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark EGORefresh
- (void)reloadTableViewDataSource{
    if(_reloading!=YES){
        _reloading = YES;
        [self loadNextData];
    }
}
- (void)doneLoadingTableViewData{
    _reloading = NO;
    [_refresh_header_view egoRefreshScrollViewDataSourceDidFinishedLoading:self.chatTableView];
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
#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refresh_header_view egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refresh_header_view egoRefreshScrollViewDidEndDragging:scrollView];
}
#pragma mark BBMessageChatDelegate Methods
- (void)addMessageId:(NSString *)messageId
{
    BOOL isHave=NO;
    for (int i=0; i<[messageIdsList count]; i++) {
        if ([[messageIdsList objectAtIndex:i]isEqualToString:messageId]) {
            isHave = YES;
            break;
        }
    }
    if (!isHave) {
        [messageIdsList addObject:messageId];
    }
}
- (void)delMessageId:(NSString *)messageId
{
    for (int i=0; i<[messageIdsList count]; i++) {
        if ([[messageIdsList objectAtIndex:i]isEqualToString:messageId]) {
            [messageIdsList removeObjectAtIndex:i];
            break;
        }
    }
}
- (void)avtarAction:(NSString *)userEncodeId2
{
    BBPersonalViewController *userInformation = [[[BBPersonalViewController alloc]initWithNibName:@"BBPersonalViewController" bundle:nil]autorelease];
    userInformation.userEncodeId = userEncodeId2;
    [self.navigationController pushViewController:userInformation animated:YES];
}

- (void)avtarAction:(NSString *)userEncodeId2 userName:(NSString *)userName
{
    BBPersonalViewController *userInformation = [[[BBPersonalViewController alloc]initWithNibName:@"BBPersonalViewController" bundle:nil]autorelease];
    userInformation.userEncodeId = userEncodeId2;
    userInformation.userName = userName;
    [self.navigationController pushViewController:userInformation animated:YES];
}

-(void)linkAction:(NSDictionary *)data
{
    if ([[data stringForKey:@"type"] isEqualToString:@"1"])
    {
        NSDictionary *topicData = [NSDictionary dictionaryWithObject:[data stringForKey:@"topic_id"] forKey:@"id"] ;
        [BBStatistic visitType:BABYTREE_TYPE_TOPIC_CHAT contentId:[topicData stringForKey:@"id"]];
        [HMShowPage showTopicDetail:self topicId:[topicData stringForKey:@"id"] topicTitle:[topicData stringForKey:@"title"]];
        if([[topicData stringForKey:@"id"] isEqualToString:@"27492066"])
        {
           [MobClick event:@"message_v2" label:@"38周私信提醒-链接点击"];
        }
    }
    else if ([[data stringForKey:@"type"] isEqualToString:@"2"])
    {
        NSString *url = [data stringForKey:@"url"];
        
        if ([url isNotEmpty])
        {
            BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
            exteriorURL.isShowCloseButton = NO;
            [exteriorURL setLoadURL:[data stringForKey:@"url"]];
            [exteriorURL setTitle:[data stringForKey:@"title"]];
            [self.navigationController pushViewController:exteriorURL animated:YES];
            [exteriorURL release];
        }
    }
    else if ([[data stringForKey:@"type"] isEqualToString:@"3"])
    {
        [MobClick event:@"message_v2" label:@"私信提醒报喜-链接点击"];
        BBBabyBornViewController *babyBornViewController = [[BBBabyBornViewController alloc] init];
        babyBornViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:babyBornViewController animated:YES];
        [babyBornViewController release];
    }

    NSString *topic_refcode = [data stringForKey:@"topic_refcode"];
    if (topic_refcode)
    {
        [self.upLoadLogRequest clearDelegatesAndCancel];
        self.upLoadLogRequest = [BBMessageRequest uploadLogToBabytree:topic_refcode];
        [upLoadLogRequest startAsynchronous];
    }
}

#pragma mark - 收起键盘的手势

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!textField.window.isKeyWindow)
    {
        [textField.window makeKeyAndVisible];
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //添加点击手势
    [self.chatTableView addGestureRecognizer:touchRecognizer];
    //关闭tableview的手势，接受自定义手势，收起键盘
    chatTableView.scrollEnabled = NO;

    return YES;
}
#pragma mark - keyboard Dismiss
- (IBAction)keyboardDismiss:(id)sender
{
    //移除点击手势
    [chatTableView removeGestureRecognizer:touchRecognizer];
    //打开tableview的手势，不接受自定义手势
    chatTableView.scrollEnabled = YES;
    
	[messageTextField resignFirstResponder];
    
    __block BBMessageChat *_self = self;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_self.toolbar setFrame:CGRectMake(0, IPHONE5_ADD_HEIGHT(369), 320, 44)];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            [_self.view setFrame:CGRectMake(0, 64, _self.view.frame.size.width, _self.view.frame.size.height)];
        }else{
            [_self.view setFrame:CGRectMake(0, 0, _self.view.frame.size.width, _self.view.frame.size.height)];
        }
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Notification Center Event
- (void)keyboardFrameShow:(NSNotification *)notification
{
    NSValue *value = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    __block BBMessageChat *_self = self;
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        if ([_self.chatArr count]>0) {
            CGRect cellCGRect = [_self.chatTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[_self.chatArr count]-1 inSection:0]];
            CGFloat cellHeight = cellCGRect.origin.y + cellCGRect.size.height;
            if (cellHeight > (IPHONE5_ADD_HEIGHT(369))) {
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
                    [_self.view setFrame:CGRectMake(0, 64-keyboardSize.height, _self.view.frame.size.width, _self.view.frame.size.height)];
                }else{
                     [_self.view setFrame:CGRectMake(0, 0-keyboardSize.height, _self.view.frame.size.width, _self.view.frame.size.height)];
                }
            } else {
                if (IPHONE5_ADD_HEIGHT(369)-cellHeight > keyboardSize.height) {
                    [_self.toolbar setFrame:CGRectMake(0, IPHONE5_ADD_HEIGHT(369)-keyboardSize.height, 320, 44)];
                } else {
                    CGFloat t = (IPHONE5_ADD_HEIGHT(369)-cellHeight);
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
                        [_self.view setFrame:CGRectMake(0, 64-keyboardSize.height+t, _self.view.frame.size.width, _self.view.frame.size.height)];
                    }else{
                        [_self.view setFrame:CGRectMake(0, 0-keyboardSize.height+t, _self.view.frame.size.width, _self.view.frame.size.height)];
                    }
                    [_self.toolbar setFrame:CGRectMake(0, cellHeight, 320, 44)];
                }
            }
        } else {
            [_self.toolbar setFrame:CGRectMake(0, IPHONE5_ADD_HEIGHT(369)-keyboardSize.height, 320, 44)];
        }
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - UIControl Event Handler Method

- (IBAction)backAction:(id)sender
{
    NSString *userInput = [self.messageTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([userInput isNotEmpty])
    {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"您还未发布内容，是否返回" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] autorelease];
        [alertView setTag:BACK_ALERT_VIEW_TAG];
        [alertView show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark- UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == BACK_ALERT_VIEW_TAG)
    {
        if (buttonIndex == 1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - 讯飞输入接口回调
#pragma mark IFlyRecognizerViewDelegate
/** 识别结果回调方法
 @param resultArray 结果列表
 @param isLast YES 表示最后一个，NO表示后面还有结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
    if ([result isNotEmpty])
    {
        if (!self.s_IFlyString)
        {
            self.s_IFlyString = [NSMutableString stringWithCapacity:0];
        }
        
        [self.s_IFlyString appendString:result];
        
    }
    
    if (isLast)
    {
        [self enableButton];
        [self.messageTextField becomeFirstResponder];
        if (self.s_IFlyString)
        {
            [self.messageTextField insertText:self.s_IFlyString];
        }
        self.s_IFlyString =nil;
    }
    
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    NSLog(@"errorCode:%d", [error errorCode]);
    self.s_IFlyString = nil;
    [self enableButton];
}
#pragma mark
#pragma mark 内部调用

// to disableButton,when the recognizer view display,the function will be called
// 当显示语音识别的view时，使其他的按钮不可用
- (void)disableButton
{
	self.messageTextField.enabled = NO;
    
	self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

// to enable button,when you start recognizer,this function will be called
// 当语音识别view消失的时候，使其它按钮可用
- (void)enableButton
{
    self.messageTextField.enabled = YES;
	self.navigationItem.leftBarButtonItem.enabled  = YES;
    self.navigationItem.rightBarButtonItem.enabled  = YES;
}

-(IBAction)xunfeiInput:(id)sender
{
    if ([self.iflyRecognizerView start])
    {
        [self keyboardDismiss:nil];
        [self disableButton];
    }

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
    NSInteger timestamp = INT32_MAX;
    if ([originArray count]>0) {
        timestamp = [[[originArray objectAtIndex:0] stringForKey:@"last_ts"]integerValue];
    }
    BOOL isExsit = NO;
    for (int i = 0; i < count; i++) {
        isExsit = NO;
        NSInteger originCount = [mutableArray count];
        addIdString = [[addArray objectAtIndex:i]stringForKey:@"message_id"];
        for (int j=0; j<originCount; j++) {
            originIdString = [[mutableArray objectAtIndex:j]stringForKey:@"message_id"];
            if ([originIdString isEqualToString:addIdString]) {
                isExsit = YES;
                break;
            }
        }
        NSInteger insertTimestamp = [[[addArray objectAtIndex:i] stringForKey:@"last_ts"]integerValue];
        if (isExsit==NO && timestamp >= insertTimestamp) {
            [mutableArray insertObject:[addArray objectAtIndex:i] atIndex:0];
        }
    }
    return mutableArray;
}


@end