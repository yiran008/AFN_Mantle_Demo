//
//  BBRegister.m
//  pregnancy
//
//  Created by Jun Wang on 12-3-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBRegister.h"
#import "BBNavigationLabel.h"
#import "BBRegisterPush.h"
#import "BBThirdUserRequest.h"
#import "BBAppDelegate.h"
#import "BBRemotePushInfo.h"
#import "BBApp.h"
#import "BBAppConfig.h"
#import "UMSocial.h"
#import "NoticeUtil.h"
#import "BBPasteboardTool.h"
#import "BBCookie.h"
#import "BBTermsOfUse.h"
#import "BBSupportTopicDetail.h"

@implementation BBRegister

@synthesize nicknameTextField;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize registerProgress;
@synthesize registerRequest;
@synthesize requests;
@synthesize checkRequests;
@synthesize checkEmailRequests;
@synthesize delegate;
@synthesize movableView;
@synthesize descLabelOne;
@synthesize descLabelTwo;
@synthesize isShowDesc;

#pragma mark - Memory Management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc 
{
    [registerRequest clearDelegatesAndCancel];
    [requests clearDelegatesAndCancel];
    [checkRequests clearDelegatesAndCancel];
    [checkEmailRequests clearDelegatesAndCancel];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"邮箱注册";

    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    if (isShowDesc) {
        [descLabelOne setHidden:NO];
        [descLabelTwo setHidden:NO];
    }
    
    self.registerProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:registerProgress];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [panRecognizer setDelegate:self];
    [self.view addGestureRecognizer:panRecognizer];
    self.view.exclusiveTouch = YES;
    [self.registerButton setEnabled:YES];
    self.registerButton.exclusiveTouch = YES;
    IPHONE5_ADAPTATION
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
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


#pragma mark - IBAction Event

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeKeyboardAction:(id)sender
{
    [self.view endEditing:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [movableView setFrame:CGRectMake(0, 0, 320, 416)];
    [UIView commitAnimations];
}
- (IBAction)pirvacyAction:(id)sender {
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.isShowCloseButton = NO;
    exteriorURL.title = @"隐私政策";
    [exteriorURL setLoadURL:@"http://www.babytree.com/app/privacy.html"];
    [self.navigationController pushViewController:exteriorURL animated:NO];
}

- (IBAction)registerAction:(id)sender
{
    [self closeKeyboardAction:nil];
    
    loginStyleCode=0;
    [nicknameTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    if ([nicknameTextField.text length] == 0 || [emailTextField.text length] == 0 || [passwordTextField.text length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息不完整" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if([passwordTextField.text length] < 6){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码不能少于6位" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else if([passwordTextField.text length] > 24){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码不能多于24位" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
        [registerProgress setLabelText:@"正在注册"];
        [registerProgress show:YES];
        
        self.registerRequest = [BBUserRequest registerWithEmail:emailTextField.text withPassword:passwordTextField.text withNickname:nicknameTextField.text];
        [registerRequest setDidFinishSelector:@selector(registerAndLoginFinish:)];
        [registerRequest setDidFailSelector:@selector(registerAndLoginFail:)];
        [registerRequest setDelegate:self];
        [registerRequest startAsynchronous];
    }
}

#pragma mark - ASIHttpRequest Delegate

- (void)registerAndLoginFinish:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *registerData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        [registerProgress hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起，注册失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([[registerData stringForKey:@"status"] isEqualToString:@"success"]) {
        NSDictionary *userInfoDic = [registerData dictionaryForKey:@"data"];
        [BBUser setLoginString:[userInfoDic stringForKey:@"login_string"]];
        [BBUser setNickname:[[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"nickname"]];
        [BBUser setEncodeID:[[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"enc_user_id"]];
        [BBUser setAvatarUrl:[[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"avatar_url"]];
        [BBUser setEmailAccount:emailTextField.text];
        [BBUser setLocation:[[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"location"]];
        [BBUser setUserOnlyCity:[[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"location"]];
        [BBUser setGender:[[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"gender"]];
        [BBUser setRegisterTime:[[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"reg_ts"]];
        
        [BBCookie pregnancyCookie:[userInfoDic stringForKey:@"cookie"]];
        [BBUser localCookie:[userInfoDic stringForKey:@"cookie"]];
        
        NSDictionary *bandInfo = [userInfoDic dictionaryForKey:@"mom_father_relation"];
        if ([[bandInfo stringForKey:@"gender"] isEqualToString:@"1"])
        {
            [BBUser setCurrentUserBabyFather:YES];
        }
        else
        {
            [BBUser setCurrentUserBabyFather:NO];
        }
        if ([[bandInfo stringForKey:@"bind_status"] isEqualToString:@"1"])
        {
            [BBUser setBandFatherStatus:YES];
        }
        else
        {
            [BBUser setBandFatherStatus:NO];
        }
        
        //[BBUser setCheckDueDateStatus:YES];
        [BBUser setNeedSynchronizeDueDate:NO];
        [BBUser setNeedSynchronizeStatisticsDueDate:YES];
        BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate pregnancyCookieInfo];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];
        [MobClick event:@"sign_in_up_v2" label:@"成功注册总次数"];

        if (![BBUser isBandFatherStatus])
        {
            NSDate *date = [NSDate dateWithDaysFromNow:3];
            NSDate *notidate = [[date dateAtStartOfDay]dateByAddingHours:20];
            [NoticeUtil registerCustomLocationNoti:@"谁说怀孕生娃只是女人的事情，快来请你的另一半来一起享受孕育的快乐吧!" withNotiInfoName:@"BBMotherBindingNoti" withNotiDate:notidate];
        }
        
        //重新为该设备推送绑定用户LoginString
        if ([BBRemotePushInfo isRegisterPushToApple]) {
            [self.registerRequest  clearDelegatesAndCancel];
            self.registerRequest = [BBRegisterPush registerPushNofitycation:[BBRemotePushInfo getUserDeviceToken]];
            [registerRequest setDidFinishSelector:@selector(registerPushFinish:)];
            [registerRequest setDidFailSelector:@selector(registerPushFail:)];
            [registerRequest setDelegate:self];
            [registerRequest startAsynchronous];
        } else {
            [registerProgress hide:YES];
            if (loginStyleCode == 0) {
                [MobClick event:@"sign_in_up_v2" label:@"邮箱成功注册数量"];
                [self.navigationController popViewControllerAnimated:NO];
                [delegate registerFinish];
            } else {
                if (loginStyleCode == 1)
                {
                    [MobClick event:@"sign_in_up_v2" label:@"新浪微博成功注册数量（不计为当天登录）"];
                }
                else
                {
                    [MobClick event:@"sign_in_up_v2" label:@"QQ成功注册数量（不计为当天登录）"];
                }
                [self thirdPartLoginFinish];
            }
        }
        //将用户登录信息存入粘贴板
        [BBPasteboardTool setLoginDesToPasteboardWith:registerData];
    } else {
        [registerProgress hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起，注册失败" message:[registerData stringForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)registerAndLoginFail:(ASIHTTPRequest *)request
{
    [registerProgress hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)registerPushFinish:(ASIHTTPRequest *)request
{
    [registerProgress hide:YES];
    
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *loginData = [parser objectWithString:responseString error:&error];
    if (error == nil) {
        if ([[loginData stringForKey:@"status"] isEqualToString:@"success"]) {
            [BBRemotePushInfo setIsRegisterPushToBabytree:NO];
            if (loginStyleCode == 0) {
                [self.navigationController popViewControllerAnimated:NO];
                [MobClick event:@"sign_in_up_v2" label:@"邮箱成功注册数量"];
                [delegate registerFinish];
            }else {
                if (loginStyleCode == 1)
                {
                    [MobClick event:@"sign_in_up_v2" label:@"新浪微博成功注册数量（不计为当天登录）"];
                }
                else
                {
                    [MobClick event:@"sign_in_up_v2" label:@"QQ成功注册数量（不计为当天登录）"];
                }
                [self thirdPartLoginFinish];
            }
            return;
        }else{
            [BBRemotePushInfo setIsRegisterPushToBabytree:YES];
            if (loginStyleCode == 0) {
                [self.navigationController popViewControllerAnimated:NO];
                [MobClick event:@"sign_in_up_v2" label:@"邮箱成功注册数量"];
                [delegate registerFinish];
            }else {
                if (loginStyleCode == 1)
                {
                    [MobClick event:@"sign_in_up_v2" label:@"新浪微博成功注册数量（不计为当天登录）"];
                }
                else
                {
                    [MobClick event:@"sign_in_up_v2" label:@"QQ成功注册数量（不计为当天登录）"];
                }
                [self thirdPartLoginFinish];
            }
        }
    }
}

- (void)registerPushFail:(ASIHTTPRequest *)request
{
    [registerProgress hide:YES];    
    [BBRemotePushInfo setIsRegisterPushToBabytree:YES];
    if (loginStyleCode == 0) {
        [self.navigationController popViewControllerAnimated:NO];
        [delegate registerFinish];
    }else {
        [self thirdPartLoginFinish];
    }
}

- (void)thirdPartLoginFinish
{
    if(loginStyleCode == 1)
    {
        BBWeiLoginShare *weiLoginShare = [[BBWeiLoginShare alloc]initWithNibName:@"BBWeiLoginShare" bundle:nil];
        weiLoginShare.delegate = self;
        weiLoginShare.weiboState = loginStyleCode;
        [self.navigationController pushViewController:weiLoginShare animated:NO];
    }
    else
    {
        [self weiLoginShareFinish];
    }
}

#pragma mark - BBWeiLoginShare Delegate

- (void)weiLoginShareFinish
{
    [self.navigationController popViewControllerAnimated:NO];
    [delegate registerFinish];
}

#pragma mark - TextField Delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!textField.window.isKeyWindow)
    {
        [textField.window makeKeyAndVisible];
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    if (textField == nicknameTextField) {
        [movableView setFrame:CGRectMake(0, 0, 320, 416)];
        self.checkNickName.text = @"";
    } else if (textField == emailTextField) {
        [movableView setFrame:CGRectMake(0, -textField.frame.origin.y+61, 320, 416)];
        self.checkEmail.text = @"";
    }
    else if (textField == passwordTextField)
    {
        self.checkPassword.text = @"";
        [movableView setFrame:CGRectMake(0, -textField.frame.origin.y+61, 320, 416)];
    }
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == emailTextField) {
        [emailTextField resignFirstResponder];
        [passwordTextField becomeFirstResponder];
        return NO;
    } else if (textField == nicknameTextField) {
        [nicknameTextField resignFirstResponder];
        [emailTextField becomeFirstResponder];
        return NO;
    } else if (textField == passwordTextField) {
        [passwordTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 100 && [self.nicknameTextField.text length]>0)
    {
        if ([self.nicknameTextField.text length] < 4 || [self.nicknameTextField.text length] > 12)
        {
            self.checkNickName.text = @"昵称，4-12个汉字、英文字母或数字";
            return;
        }
        
        [checkRequests clearDelegatesAndCancel];
        self.checkRequests = [BBUserRequest registerNicknameCheck:self.nicknameTextField.text];
        [checkRequests setDelegate:self];
        [checkRequests setDidFinishSelector:@selector(checkNameInfomationFinish:)];
        [checkRequests setDidFailSelector:@selector(checkInfomationFail:)];
        [checkRequests startAsynchronous];
        return;
    }
    
    if (textField.tag==101 && [self.emailTextField.text length]>0) {
        [checkEmailRequests clearDelegatesAndCancel];
        self.checkEmailRequests = [BBUserRequest registerEmailCheck:self.emailTextField.text];
        [checkEmailRequests setDelegate:self];
        [checkEmailRequests setDidFinishSelector:@selector(checkEmailInfomationFinish:)];
        [checkEmailRequests setDidFailSelector:@selector(checkEmailInfomationFail:)];
        [checkEmailRequests startAsynchronous];
        return;
    }
    
    if (self.passwordTextField.text.length == 0)
    {
        self.checkPassword.text = @"";
        return;
    }

    if(self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 24)
    {
        self.checkPassword.text = @"密码格式有误，请输入6-24位英文字母或数字";
    }
    else
    {
        self.checkPassword.text = @"";
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
            [self.view endEditing:YES];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            [movableView setFrame:CGRectMake(0, 0, 320, 416)];
            [UIView commitAnimations];
        }
    }
}

#pragma mark - check request
- (void)checkNameInfomationFinish:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *loginData = [parser objectWithString:responseString error:&error];
    if (error == nil) {
        if ([[loginData stringForKey:@"status"] isEqualToString:@"success"]) {
            self.checkNickName.text = @"恭喜！昵称可以使用";
        }else{
            self.checkNickName.text = [loginData stringForKey:@"message"];
        }
    }
}

- (void)checkInfomationFail:(ASIHTTPRequest *)request
{

}


- (void)checkEmailInfomationFinish:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *loginData = [parser objectWithString:responseString error:&error];
    if (error == nil) {
        if ([[loginData stringForKey:@"status"] isEqualToString:@"success"]) {
            self.checkEmail.text = @"恭喜！邮箱未被注册";
        }else{
            self.checkEmail.text = [loginData stringForKey:@"message"];
        }
    }
}



- (void)checkEmailInfomationFail:(ASIHTTPRequest *)request
{
    
}
- (IBAction)isCompleteAction:(UIButton *)sender
{
    if ([self.registerButton isEnabled]) {
        [sender setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [self.registerButton setBackgroundColor:[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0]];
        [self.registerButton setEnabled:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"checkbox-selected"] forState:UIControlStateNormal];
        [self.registerButton setBackgroundColor:[UIColor colorWithRed:93/255.0 green:200/255.0 blue:98/255.0 alpha:1.0]];
        [self.registerButton setEnabled:YES];
    }
}

- (IBAction)clauseAction:(UIButton *)sender
{
    BBTermsOfUse *termsOfUseCtrl = [[BBTermsOfUse alloc] initWithNibName:@"BBTermsOfUse" bundle:nil];
    [self.navigationController pushViewController:termsOfUseCtrl animated:YES];
}

@end
