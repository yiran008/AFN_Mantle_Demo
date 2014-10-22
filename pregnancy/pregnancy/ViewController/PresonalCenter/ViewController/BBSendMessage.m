//
//  BBSendMessage.m
//  pregnancy
//
//  Created by Jun Wang on 12-4-24.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBSendMessage.h"
#import "MobClick.h"
#import "BBNavigationLabel.h"
#import "BBRefreshPersonalTopicList.h"
#import "BBStatisticsUtil.h"
#import "BBApp.h"
#import "BBAppConfig.h"
#import "BBAppDelegate.h"

#define BACK_ALERT_VIEW_TAG 3

@implementation BBSendMessage

@synthesize replyTextView;
@synthesize bogusTextField;
@synthesize replyUID;
@synthesize replyProgress;
@synthesize messageRequest;
@synthesize inputView;

#pragma mark - Memory Management


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUID:(NSString *)theUID
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.replyUID = theUID;
        isRequestShow = YES;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [messageRequest clearDelegatesAndCancel];
    [_iflyRecognizerView cancel];
    [IFlySpeechUtility destroy];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"发送消息";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.exclusiveTouch = YES;
    [commitButton setFrame:CGRectMake(0, 0, 40, 30)];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [commitButton setTitle:@"发送" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(replyTopicButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    [self.navigationItem setRightBarButtonItem:commitBarButton];

    self.replyProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:replyProgress];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [panRecognizer setDelegate:self];
    [self.view addGestureRecognizer:panRecognizer];
    self.view.exclusiveTouch = YES;
    
    //iphone5适配
    IPHONE5_ADAPTATION
    
    self.view.backgroundColor = RGBColor(239, 239, 244, 1);

    //给键盘加上语音输入的图标
    [self.replyTextView setInputAccessoryView:self.inputView];
    
    // 语音
    [BBIflyMSC firstInit];
    self.iflyRecognizerView = [BBIflyMSC CreateRecognizerView:self];
    self.s_IFlyString  = nil;

    
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
}

- (void)viewDidUnloadBabytree
{
    self.replyTextView = nil;
    self.replyProgress = nil;
    [self.messageRequest clearDelegatesAndCancel];
    self.messageRequest = nil;
    self.inputView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [replyTextView becomeFirstResponder];
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


#pragma mark - IBAction Event Handler Mehthod

- (IBAction)backAction:(id)sender
{
    if ([self.replyProgress isShow] && isRequestShow) {
        isRequestShow = NO;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    else
    {
        NSString *userInput = [self.replyTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([userInput isNotEmpty])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还未发布内容，是否返回" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView setTag:BACK_ALERT_VIEW_TAG];
            [alertView show];
        }
        else
        {
           [self.navigationController popViewControllerAnimated:YES]; 
        }
    }
    
}

- (IBAction)closeKeyboardAction:(id)sender
{
    [replyTextView resignFirstResponder];
}

- (IBAction)replyTopicButton:(id)sender
{
    [replyTextView resignFirstResponder];
    if ([replyTextView.text length] == 0  || ([[self.replyTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || self.replyTextView.text==nil)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"内容为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [replyProgress setLabelText:@"正在发送消息"];
    [replyProgress show:YES];
    [self.messageRequest clearDelegatesAndCancel];
    self.messageRequest = [BBMessageRequest sendMessage:replyUID withMessageContent:replyTextView.text];
    [messageRequest setDidFinishSelector:@selector(submitReplyFinish:)];
    [messageRequest setDidFailSelector:@selector(submitReplyFail:)];
    [messageRequest setDelegate:self];
    [messageRequest startAsynchronous];
}

- (void)submitReplyFinish:(ASIHTTPRequest *)request
{
//    [BBCountUserEvevt custemUserCountEvent:@"personal" withLabel:@"BBPersonalView"];
    
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *submitReplyData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        [replyProgress hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发送回复失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([[submitReplyData stringForKey:@"status"] isEqualToString:@"success"]) {
        [MobClick event:@"other_center_v2" label:@"实际发消息数量"];
        if (self.isHospitalMessage)
        {
            [MobClick event:@"discuz_v2" label:@"医院圈-发私信成功数量"];
        }
        [replyProgress hide:YES];
        [BBRefreshPersonalTopicList setNeedRefreshOutboxTopicList:YES];
        if (isRequestShow) {
            isRequestShow = NO;
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } else {
        [replyProgress hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发送回复失败" message:[submitReplyData stringForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)submitReplyFail:(ASIHTTPRequest *)request
{
    [replyProgress hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲！你的网络不给力" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - TextView Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""] || [textView.text isEqual:nil]) {
        [bogusTextField setPlaceholder:@"请输入回复内容"];
    } else {
        [bogusTextField setPlaceholder:nil];
    }
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == BACK_ALERT_VIEW_TAG) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - UIGestureRecognizer Delegate

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:[self view]];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        gesturePoint = location;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (location.y - gesturePoint.y >= 30) {
            [replyTextView resignFirstResponder];
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
    NSMutableString *result = [[NSMutableString alloc] init];
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
        [self.replyTextView becomeFirstResponder];
        if (self.s_IFlyString)
        {
            [self.replyTextView insertText:self.s_IFlyString];
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
    self.s_IFlyString = nil;
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
	self.replyTextView.editable = NO;
    
	self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

// to enable button,when you start recognizer,this function will be called
// 当语音识别view消失的时候，使其它按钮可用
- (void)enableButton
{
    self.replyTextView.editable = YES;
	self.navigationItem.leftBarButtonItem.enabled  = YES;
    self.navigationItem.rightBarButtonItem.enabled  = YES;
}
-(IBAction)xunfeiInput:(id)sender
{
    if ([self.iflyRecognizerView start])
    {
        [self disableButton];
    }
}

@end
