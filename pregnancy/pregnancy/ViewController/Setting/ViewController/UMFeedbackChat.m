//
//  BBMessageView.m
//  pregnancy
//
//  Created by mac on 12-12-24.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "UMFeedbackChat.h"
#import "BBMessageRequest.h"
#import "BBApp.h"
#import "BBNavigationLabel.h"
#import "BBAppConfig.h"
#import "BBAppDelegate.h"
#define BACK_ALERT_VIEW_TAG     101

@interface UMFeedbackChat ()
<
    UIAlertViewDelegate
>

@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;
@property (nonatomic, strong) NSMutableString *s_IFlyString;

@end

@implementation UMFeedbackChat

@synthesize chatArr,chatTableView,hud,toolbar,messageTextField,touchRecognizer;

- (void)dealloc
{
    UMFeedback *umFeedback = [UMFeedback sharedInstance];
    umFeedback.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [chatTableView release];
    [chatArr release];
    [hud release];
    [toolbar release];
    [messageTextField release];
    [_iflyRecognizerView cancel];
    [IFlySpeechUtility destroy];
    [_iflyRecognizerView release];
    [touchRecognizer release];

    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"意见反馈";
        self.chatArr = [[[NSMutableArray alloc]init]autorelease];
        //接收键盘出现通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

     [self.chatTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.title]];
    
    //输入背景框
    UIImageView * tfBack = (UIImageView *)[self.view viewWithTag:997];
    tfBack.image = [[UIImage imageNamed:@"enter_kuang"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
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
        [self.toolbar setFrame:CGRectMake(self.toolbar.frame.origin.x, self.toolbar.frame.origin.y + 88, self.toolbar.frame.size.width, self.toolbar.frame.size.height)];
    }
    
    // 语音
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
    
    
    UMFeedback *umFeedback = [UMFeedback sharedInstance];
    [umFeedback setAppkey:Appkey delegate:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self keyboardDismiss:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self keyboardDismiss:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    IOS6_RELEASE_VIEW
}

- (void)viewDidUnload
{
    [self viewDidUnloadBabytree];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidUnloadBabytree
{
    UMFeedback *umFeedback = [UMFeedback sharedInstance];
    umFeedback.delegate = nil;
    _refresh_header_view = nil;
    self.chatTableView = nil;
    self.toolbar = nil;
    self.messageTextField = nil;
    self.touchRecognizer = nil;
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
    }
    NSDictionary *content = [chatArr objectAtIndex:indexPath.row];
    [cell setContent:content withEditStatus:NO withSelectStatus:NO withBBMessageChatDelegate:nil];
    return cell;
}

#pragma mark - 从网络加载数据
-(void)reloadData{
    UMFeedback *umFeedback = [UMFeedback sharedInstance];
    [umFeedback get];
}

- (void)getFinishedWithError: (NSError *)error
{
    if (!hud.isHidden) {
        [hud hide:YES];
    }
    if (error!=nil) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲！你的网络不给力" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    
    //加载完成去掉加载框
    if(_reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    UMFeedback *umFeedback = [UMFeedback sharedInstance];
    NSArray *umDataArray = umFeedback.topicAndReplies;
    [self.chatArr removeAllObjects];
    //format UMData
    for (int i=0; i<umDataArray.count; i++) {
        NSDictionary *umData = [umDataArray objectAtIndex:i];
        if (![self isDataValid:umData])
        {
            continue;
        }
        NSMutableDictionary *data = [[[NSMutableDictionary alloc]init]autorelease];
        [data setObject:@"1" forKey:@"message_id"];
        
        NSString *type = [umData stringForKey:@"type"];
        if ([type isEqualToString:@"dev_reply"]) {
            [data setObject:@"花猫园丁" forKey:@"nickname"];
            [data setObject:@"u29659238810" forKey:@"user_encode_id"];
            [data setObject:@"http://pic01.babytreeimg.com/foto3/thumbs/2011/0922/85/1/6e7d4119a3a4bf9a7e83a0f_ss.jpg" forKey:@"user_avatar"];
        } else {
            [data setObject:[BBUser getNickname]==nil ? @"zljsrc" : [BBUser getNickname] forKey:@"nickname"];
            [data setObject:[BBUser getEncId]==nil ? @"uzljsrc" : [BBUser getEncId] forKey:@"user_encode_id"];
            if ([BBUser isLogin] && [BBUser getAvatarUrl]) {
                [data setObject:[BBUser getAvatarUrl] forKey:@"user_avatar"];
            } else {
                [data setObject:@"" forKey:@"user_avatar"];
            }
        }
        
        NSString *dateString = [umData stringForKey:@"datetime"];
        NSDateFormatter *dateFormater = [[[NSDateFormatter alloc]init]autorelease];
        [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *createDate = [dateFormater dateFromString:dateString];
        [data setObject:[NSString stringWithFormat:@"%d", (int)[createDate timeIntervalSince1970]] forKey:@"last_ts"];
        
        [data setObject:([umData stringForKey:@"content"]==nil ? @"" : [umData stringForKey:@"content"]) forKey:@"content"];
        [self.chatArr addObject:data];
    }
    [chatTableView reloadData];
    
    if ([chatArr count]>0) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

-(BOOL)isDataValid:(NSDictionary*)data
{
    if ([self.title isEqualToString:@"账户被禁用反馈"])
    {
        NSDictionary *remark = [data dictionaryForKey:@"remark"];
        if (remark && [remark stringForKey:@"disableAccount"] && [[remark stringForKey:@"disableAccount"]isEqualToString:@"禁用"])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if ([self.title isEqualToString:@"建议反馈"])
    {
        NSDictionary *remark = [data dictionaryForKey:@"remark"];
        if (remark && [remark stringForKey:@"disableAccount"] && [[remark stringForKey:@"disableAccount"]isEqualToString:@"禁用"])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}
- (IBAction)sendMessageAction:(id)sender
{
    NSString *content = messageTextField.text;
    
    if ([[messageTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || content == nil || [content isEqualToString:@""]) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"请输入发送信息内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alert show];
        return;
    }
    [self keyboardDismiss:nil];
    hud.labelText = @"发送消息中...";
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud show:YES];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObject:content forKey:@"content"];
    if ([BBUser isLogin]) {
        NSMutableDictionary *contact = [[[NSMutableDictionary alloc]init]autorelease];
        if ([BBUser getNickname]!=nil) {
            [contact setObject:[BBUser getNickname] forKey:@"nickname"];
        }
        if ([BBUser getEncId]!=nil) {
            [contact setObject:[BBUser getEncId] forKey:@"userId"];
        }
        [data setObject:contact forKey:@"contact"];
    }
    if ([self.title isEqualToString:@"账户被禁用反馈"]) {
        NSMutableDictionary *remark = [[[NSMutableDictionary alloc]init]autorelease];
        [remark setObject:@"禁用" forKey:@"disableAccount"];
        [data setObject:remark forKey:@"remark"];
    }
    UMFeedback *umFeedback = [UMFeedback sharedInstance];
    [umFeedback post:data];
}
- (void)postFinishedWithError:(NSError *)error
{
    if (!hud.isHidden) {
        [hud hide:YES];
    }
    messageTextField.text = nil;
    if (error==nil) {
        [self reloadData];
    }
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - EGORefresh
- (void)reloadTableViewDataSource{
    if(_reloading!=YES){
        _reloading = YES;
        [self reloadData];
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

#pragma mark - 收起键盘的手势
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //添加点击手势
    [self.chatTableView addGestureRecognizer:touchRecognizer];
    //关闭tableview的手势，接受自定义手势，收起键盘
    chatTableView.scrollEnabled = NO;

    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!textField.window.isKeyWindow)
    {
        [textField.window makeKeyAndVisible];
    }
}


#pragma mark - keyboard Dismiss
- (IBAction)keyboardDismiss:(id)sender
{
    //移除点击手势
    [chatTableView removeGestureRecognizer:touchRecognizer];
    //打开tableview的手势，不接受自定义手势
    chatTableView.scrollEnabled = YES;
    
	[messageTextField resignFirstResponder];
    
    __block UMFeedbackChat *_self = self;
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
    
    __block UMFeedbackChat *_self = self;
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
        self.s_IFlyString = nil;
    }
    
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    NSLog(@"errorCode:%d", [error errorCode]);
    
    [self enableButton];
}
#pragma mark
#pragma mark 内部调用

// to disableButton,when the recognizer view display,the function will be called
// 当显示语音识别的view时，使其他的按钮不可用
- (void)disableButton
{
    //	recognizeButton.enabled = NO;
    //	_setupButton.enabled = NO;
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

@end