//
//  BBFillBandCode.m
//  pregnancy
//
//  Created by whl on 14-4-14.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBFillBandCode.h"
#import "BBFatherRequest.h"

@interface BBFillBandCode ()

@end

@implementation BBFillBandCode

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
    [_m_Request clearDelegatesAndCancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我是准爸爸";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.title]];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    self.m_CommitButton.exclusiveTouch = YES;
    self.m_LoadProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.m_LoadProgress];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clickedBandMather:(id)sender
{
    [MobClick event:@"invite_husband_v2" label:@"我是准爸爸-提交"];
    if ([[self.m_CodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || self.m_CodeTextField.text==nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入您的邀请码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        [self.m_LoadProgress show:YES];
        [self.m_Request  clearDelegatesAndCancel];
        self.m_Request = [BBFatherRequest bindUser:self.m_CodeTextField.text];
        [self.m_Request setDidFinishSelector:@selector(bandFinish:)];
        [self.m_Request setDidFailSelector:@selector(bandFail:)];
        [self.m_Request setDelegate:self];
        [self.m_Request startAsynchronous];
    }
}

- (void)bandFinish:(ASIFormDataRequest *)request
{
    [self.m_LoadProgress hide:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *loginData = [parser objectWithString:responseString error:&error];
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"出错了！" message:@"绑定出错，请重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([[loginData stringForKey:@"status"] isEqualToString:@"success"])
    {
        [BBUser setBandFatherStatus:YES];
        [BBUser setCurrentUserBabyFather:YES];
        
        [MobClick event:@"invite_husband_v2" label:@"准爸爸绑定成功数"];

        //刷新本地缓存
        NSDictionary *fatherData = [loginData dictionaryForKey:@"data"];
        if (fatherData)
        {
            if ([fatherData stringForKey:@"mom_user_id"])
            {
                [BBFatherInfo setMotherUID:[fatherData stringForKey:@"mom_user_id"]];
            }
            
            if ([fatherData stringForKey:@"father_user_id"])
            {
                
                NSDictionary *userInfo = [fatherData dictionaryForKey:@"user_info"];
                [BBFatherInfo setFatherUID:[userInfo stringForKey:@"login_string"]];
                [BBFatherInfo setFatherEncodeId:[fatherData stringForKey:@"father_user_id"]];
                [BBFatherInfo setBabyPregnancyTime:[userInfo stringForKey:@"baby_birthday"]];
                
                NSString *newUrl = [fatherData stringForKey:@"image_url"];
                if (![[BBFatherInfo getBackGroundImageURL] isEqualToString:newUrl])
                {
                    [BBFatherInfo setBackGroundImageURL:[fatherData stringForKey:@"image_url"]];
                }
                
                [BBFatherInfo setInviteCode:self.m_CodeTextField.text];
            }
        }
        [self.navigationController popViewControllerAnimated:NO];
        [self.delegate closeFillBandCodeView];
        
    }
    else if ([[loginData stringForKey:@"status"] isEqualToString:@"father_edition_invalid_code"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"绑定失败" message:@"邀请码无效,请向准妈妈索取正确的邀请码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起，绑定失败" message:[loginData stringForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)bandFail:(ASIFormDataRequest *)request
{
    [self.m_LoadProgress hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}


#pragma mark -- textfield delegate
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

@end
