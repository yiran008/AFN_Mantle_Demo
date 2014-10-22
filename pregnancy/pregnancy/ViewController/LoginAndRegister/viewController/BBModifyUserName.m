//
//  BBModifyUserName.m
//  pregnancy
//
//  Created by whl on 14-4-8.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBModifyUserName.h"
#import "BBUserRequest.h"

@interface BBModifyUserName ()

@end

@implementation BBModifyUserName

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [self.m_ModifyRequest clearDelegatesAndCancel];
    [self.m_CheckRequest clearDelegatesAndCancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"填写昵称";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:nil forState:UIControlStateNormal];
    [backButton setImage:nil forState:UIControlStateHighlighted];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.exclusiveTouch = YES;
    [commitButton setFrame:CGRectMake(0, 0, 40, 30)];
    [commitButton setTitle:@"跳过" forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [commitButton addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    [self.navigationItem setRightBarButtonItem:commitBarButton];
    
    self.m_LoadProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.m_LoadProgress];
    
    self.m_commitButton.exclusiveTouch = YES;
    self.view.exclusiveTouch = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.m_UserNameTextField becomeFirstResponder];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.m_UserNameTextField.text = self.m_UserName;
}


-(IBAction)commitAction:(id)sender
{
    [MobClick event:@"sign_in_up_v2" label:@"手机注册填写昵称-跳过"];
    if (self.m_Delegate && [self.m_Delegate respondsToSelector:@selector(modifyUserNameCall)])
    {
        [self.m_Delegate modifyUserNameCall];
    }
}

-(IBAction)clickedModifyUserName:(id)sender
{
//    if ([self.m_UserName isEqualToString:self.m_UserNameTextField.text])
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请修改您的昵称" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//    }
//    else
//    {
        if ([[self.m_UserNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || self.m_UserNameTextField.text==nil)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入您的昵称" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            [self modifyUserName];
        }
//    }
}

#pragma mark - TextField Delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!textField.window.isKeyWindow)
    {
        [textField.window makeKeyAndVisible];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 100 && [self.m_UserNameTextField.text length]>0)
    {
        if ([self.m_UserNameTextField.text length] < 4 || [self.m_UserNameTextField.text length] > 12)
        {
            self.m_MessageLabel.text = @"昵称，4-12个汉字、英文字母或数字";
            return;
        }

        [self.m_CheckRequest clearDelegatesAndCancel];
        self.m_CheckRequest = [BBUserRequest registerNicknameCheck:self.m_UserNameTextField.text];
        [self.m_CheckRequest setDelegate:self];
        [self.m_CheckRequest setDidFinishSelector:@selector(checkNameInfomationFinish:)];
        [self.m_CheckRequest setDidFailSelector:@selector(checkInfomationFail:)];
        [self.m_CheckRequest startAsynchronous];
        return;
    }
}

//只需要点击非文字输入区域就会响应hideKeyBoard

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doneResign:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer: tapGestureRecognizer];
    self.view.exclusiveTouch = YES;
    return YES;
}

-(void)doneResign:(id)sender
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
}


-(void)modifyUserName
{
    [self.m_ModifyRequest clearDelegatesAndCancel];
    self.m_ModifyRequest = [BBUserRequest modifyUserInfoNickName:self.m_UserNameTextField.text];
    [self.m_ModifyRequest setDidFinishSelector:@selector(modifyUserNameFinish:)];
    [self.m_ModifyRequest setDidFailSelector:@selector(modifyUserNameFail:)];
    [self.m_ModifyRequest setDelegate:self];
    [self.m_ModifyRequest startAsynchronous];

}

#pragma mark - ASIHttp Request Delegate



- (void)checkNameInfomationFinish:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *loginData = [parser objectWithString:responseString error:&error];
    if (error == nil) {
        if ([[loginData stringForKey:@"status"] isEqualToString:@"success"]) {
            self.m_MessageLabel.text = @"恭喜！昵称可以使用";
        }else{
            self.m_MessageLabel.text = [loginData stringForKey:@"message"];
        }
    }
}

- (void)checkInfomationFail:(ASIHTTPRequest *)request
{
    
}

- (void)modifyUserNameFinish:(ASIHTTPRequest *)request
{
    [self.m_LoadProgress hide:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *submitTopicData = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发送主题失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([[submitTopicData stringForKey:@"status"] isEqualToString:@"success"])
    {
        [BBUser setNickname:self.m_UserNameTextField.text];
        if (self.m_Delegate && [self.m_Delegate respondsToSelector:@selector(modifyUserNameCall)])
        {
            [self.m_Delegate modifyUserNameCall];
        }
    }
    else
    {
        if (self.m_Delegate && [self.m_Delegate respondsToSelector:@selector(modifyUserNameCall)])
        {
            [self.m_Delegate modifyUserNameCall];
        }
    }
}

- (void)modifyUserNameFail:(ASIHTTPRequest *)request
{
    [self.m_LoadProgress hide:YES];
    if (self.m_Delegate && [self.m_Delegate respondsToSelector:@selector(modifyUserNameCall)])
    {
        [self.m_Delegate modifyUserNameCall];
    }
}

@end
