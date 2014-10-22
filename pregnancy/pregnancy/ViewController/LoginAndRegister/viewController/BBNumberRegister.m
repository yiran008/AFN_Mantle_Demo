//
//  BBNumberRegister.m
//  pregnancy
//
//  Created by whl on 13-10-23.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBNumberRegister.h"
#import "BBApp.h"
#import "BBNavigationLabel.h"
#import "BBUserRequest.h"
#import "MobClick.h"
#import "BBUser.h"
#import "BBCookie.h"
#import "BBRemotePushInfo.h"
#import "BBAppDelegate.h"
#import "BBRegisterPush.h"
#import "BBAppConfig.h"
#import "UMSocial.h"
#import "NoticeUtil.h"
#import "BBPasteboardTool.h"
#import "BBCookie.h"
#import "BBTermsOfUse.h"
#import "BBValidateUtility.h"
#import "MobClick.h"
#import "GTMBase64.h"
#import "BBSupportTopicDetail.h"

@interface BBNumberRegister ()
{
    CGPoint gesturePoint;
    NSInteger paramTimer;
}
@property (nonatomic,strong) NSTimer *timer;
@property (assign) BOOL isApply;
@property (nonatomic, strong) NSString *userPhoneNumber;
@property (nonatomic, strong) NSString *s_UserName;

@end

@implementation BBNumberRegister

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         paramTimer = 60;
        self.isApply = YES;
    }
    return self;
}

- (void)dealloc
{
    [_registerRequest clearDelegatesAndCancel];
    [_checkNumberRequests clearDelegatesAndCancel];
    [_validateRequest clearDelegatesAndCancel];
    [_registerRequest clearDelegatesAndCancel];
    [_SMSRequest clearDelegatesAndCancel];
    [_babyboxRequest clearDelegatesAndCancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"手机号注册";

    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    self.loadProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.loadProgress];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [panRecognizer setDelegate:self];
    [self.registerView addGestureRecognizer:panRecognizer];
    self.registerView.exclusiveTouch = YES;
    //iphone5适配
    IPHONE5_ADAPTATION
    [self.againButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.againButton setEnabled:YES];
    [self.registerButton setEnabled:YES];
    
    self.againButton.exclusiveTouch = YES;
    self.registerButton.exclusiveTouch = YES;
    self.validateButton.exclusiveTouch = YES;
    self.finishButton.exclusiveTouch = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender
{
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)againRegisterRequest{
    [self.againButton setEnabled:NO];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(modifyText) userInfo:nil repeats:YES];
    [self.timer fire];
}

-(void)modifyText{
    if (paramTimer==0) {
        [self.againButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        paramTimer = 60;
        [self.againButton setEnabled:YES];
        [self.timer invalidate];
    }else{
        paramTimer--;
        NSString *str = [NSString stringWithFormat:@"重新获取验证码(%d)",paramTimer];
        [self.againButton setTitle:str forState:UIControlStateDisabled];
    }
}
- (IBAction)privacyAction:(id)sender {
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.isShowCloseButton = NO;
    exteriorURL.title = @"隐私政策";
    [exteriorURL setLoadURL:@"http://www.babytree.com/app/privacy.html"];
    [self.navigationController pushViewController:exteriorURL animated:NO];
}


- (IBAction)registerAction:(id)sender
{
    [self closeKeyboardAction:nil];
    
    [self.numberText resignFirstResponder];
    [self.validateText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    
    if ([self.numberText.text length] == 0 || [self.validateText.text length] == 0 || [self.passwordText.text length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息不完整" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if([self.passwordText.text length] < 6){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码不能少于6位" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else if([self.passwordText.text length] > 24){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码不能多于24位" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
        NSCharacterSet *nameCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
        NSRange userNameRange = [self.passwordText.text rangeOfCharacterFromSet:nameCharacters];
        if (userNameRange.location != NSNotFound) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码不能有特殊字符" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }else{
            self.userPhoneNumber = self.numberText.text;
            [self.loadProgress setLabelText:@"努力加载中"];
            [self.loadProgress show:YES];
            [self.registerRequest clearDelegatesAndCancel];
            self.registerRequest = [BBUserRequest registerWithNumber:self.numberText.text withPassword:self.passwordText.text withRegiterCode:self.validateText.text];
            [self.registerRequest setDidFinishSelector:@selector(phoneNumberRegisterFinish:)];
            [self.registerRequest setDidFailSelector:@selector(phoneNumberRegisterFail:)];
            [self.registerRequest setDelegate:self];
            [self.registerRequest startAsynchronous];
        }
    }
}

-(IBAction)clickedValidateCode:(id)sender
{
    [self getValidateCode];
}

-(IBAction)SMSValidateClicked:(id)sender
{
    [self.codeText resignFirstResponder];
    if ([self.codeText.text length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入校验码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [self getSMSCode];
    [self.finishButton setEnabled:NO];
}

-(IBAction)cancelValidateViewClicked:(id)sender
{    
    [self.codeText resignFirstResponder];
    [self dismissModalView];
}

-(IBAction)validateClicked:(id)sender
{
    [self closeKeyboardAction:nil];
    
    [self.numberText resignFirstResponder];
    [self.validateText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    if (![BBValidateUtility checkPhoneNumInput:self.numberText.text]) {
        self.numberLabel.text = @"请输入正确的手机号";
        return;
    }
    self.codeText.text = nil;
    [self getValidateCode];
    [self showViladate];
    
}

-(void)getValidateCode
{
    [self.validateRequest clearDelegatesAndCancel];
    self.validateRequest = [BBUserRequest getPhoneRegisterCode:self.numberText.text];
    [self.validateRequest setDidFinishSelector:@selector(getRegisterCodeFinish:)];
    [self.validateRequest setDidFailSelector:@selector(getRegisterCodeFail:)];
    [self.validateRequest setDelegate:self];
    [self.validateRequest startAsynchronous];
}

-(void)getSMSCode
{
    [self.SMSRequest clearDelegatesAndCancel];
    self.SMSRequest = [BBUserRequest getPhoneRegisterSMSCode:self.numberText.text withValidate:self.codeText.text];
    [self.SMSRequest setDidFinishSelector:@selector(getRegisterSMSCodeFinish:)];
    [self.SMSRequest setDidFailSelector:@selector(getRegisterSMSCodeFail:)];
    [self.SMSRequest setDelegate:self];
    [self.SMSRequest startAsynchronous];

}

- (IBAction)closeKeyboardAction:(id)sender
{
    [self.view endEditing:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [self.registerView setFrame:CGRectMake(0, 0, 320, 416)];
    [UIView commitAnimations];
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
            [self.registerView setFrame:CGRectMake(0, 0, 320, 416)];
            [UIView commitAnimations];
        }
    }
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
    if (textField == self.numberText) {
        [self.registerView setFrame:CGRectMake(0, 0, 320, 416)];
        self.numberLabel.text = @"";
    }
    else if (textField == self.passwordText)
    {
        self.passwordLabel.text = @"";
        [self.registerView setFrame:CGRectMake(0, -textField.frame.origin.y+61, 320, 416)];
    }
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.numberText) {
        [self.numberText resignFirstResponder];
        [self.passwordText becomeFirstResponder];
        return NO;
    }
    else if (textField == self.passwordText)
    {
        [self.passwordText resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==101 && [self.numberText.text length]>0) {
        if (![BBValidateUtility checkPhoneNumInput:self.numberText.text]) {
            self.numberLabel.text = @"请输入正确的手机号";
            return;
        }
        [self.checkNumberRequests clearDelegatesAndCancel];
        self.checkNumberRequests = [BBUserRequest registerNumberCheck:self.numberText.text];
        [self.checkNumberRequests setDelegate:self];
        [self.checkNumberRequests setDidFinishSelector:@selector(checkNumberInfomationFinish:)];
        [self.checkNumberRequests setDidFailSelector:@selector(checkNumberInfomationFail:)];
        [self.checkNumberRequests startAsynchronous];
        return;
    }
    
    
    if (textField.tag == 112)
    {
        if (self.passwordText.text.length == 0)
        {
            self.passwordLabel.text = @"";
            return;
        }

        if(self.passwordText.text.length < 6 || self.passwordText.text.length > 24)
        {
            self.passwordLabel.text = @"密码格式有误，请输入6-24位英文字母或数字";
        }
        else
        {
            self.passwordLabel.text = @"";
        }
    }

    
}

-(NSData*)getImageData:(NSString*)baseString
{
    NSData *theData = [GTMBase64 decodeString:baseString];
    return theData;
}


#pragma mark - ASIHttpRequest Delegate

- (void)getRegisterCodeFinish:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *registerData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSDictionary *resultData = [registerData dictionaryForKey:@"data"];
    NSString *imageData = [resultData stringForKey:@"auth_code"];

    UIImage *codeImage = [UIImage imageWithData:[self getImageData:imageData]];
    if (codeImage) {
        [self.validateButton setImage:codeImage forState:UIControlStateNormal];
    }else{
    }
}

- (void)getRegisterCodeFail:(ASIHTTPRequest *)request
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}


- (void)getRegisterSMSCodeFinish:(ASIHTTPRequest *)request
{
    [self.finishButton setEnabled:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *registerData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([[registerData stringForKey:@"status"] isEqualToString:@"success"]) {
        [self againRegisterRequest];
        [self dismissModalView];
    } else if ([[registerData stringForKey:@"status"] isEqualToString:@"phone_number_error"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手机号错误" message:@"手机号错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if ([[registerData stringForKey:@"status"] isEqualToString:@"rate_over_limit"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"该号码当天获取验证码已超过10条" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if ([[registerData stringForKey:@"status"] isEqualToString:@"ip_over_limit"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"该IP当天获取验证码已超过30条" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if ([[registerData stringForKey:@"status"] isEqualToString:@"resend_code_already_send"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"两次获取不能少于60秒" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if ([[registerData stringForKey:@"status"] isEqualToString:@"phone_register_already"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手机号已被注册" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if ([[registerData stringForKey:@"status"] isEqualToString:@"auth_code_error"]){
        NSDictionary *resultData = [registerData dictionaryForKey:@"data"];
        NSString *imageData = [resultData stringForKey:@"auth_code"];
        UIImage *codeImage = [UIImage imageWithData:[self getImageData:imageData]];
        if (codeImage) {
            [self.validateButton setImage:codeImage forState:UIControlStateNormal];
        }else{
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"图片验证码错误，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)getRegisterSMSCodeFail:(ASIHTTPRequest *)request
{
    [self.finishButton setEnabled:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}


#pragma mark - check request

- (void)checkNumberInfomationFinish:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *loginData = [parser objectWithString:responseString error:&error];
    if (error == nil) {
        if ([[loginData stringForKey:@"status"] isEqualToString:@"success"]) {
            self.numberLabel.text = @"恭喜！手机号未被注册";
        }else{
            self.numberLabel.text = [loginData stringForKey:@"message"];
        }
    }
}

- (void)checkNumberInfomationFail:(ASIHTTPRequest *)request
{
    
}


- (void)phoneNumberRegisterFinish:(ASIHTTPRequest *)request
{
    [self.loadProgress hide:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *registerData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([[registerData stringForKey:@"status"] isEqualToString:@"success"]) {
        NSDictionary *userInfoDic = [registerData dictionaryForKey:@"data"];
        [BBUser setLoginString:[userInfoDic stringForKey:@"login_string"]];
        [BBUser setNickname:[[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"nickname"]];
        self.s_UserName = [[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"nickname"];
        [BBUser setEncodeID:[[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"enc_user_id"]];
        [BBUser setAvatarUrl:[[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"avatar_url"]];
        [BBUser setEmailAccount:[[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"email"]];
        [BBUser setLocation:[[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"location"]];
        [BBUser setUserOnlyCity:[[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"location"]];
        [BBUser setGender:[[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"gender"]];
        [BBUser setRegisterTime:[[userInfoDic dictionaryForKey:@"user_info"] stringForKey:@"reg_ts"]];
        
        [BBCookie pregnancyCookie:[userInfoDic  stringForKey:@"cookie"]];
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
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];
        //[BBUser setCheckDueDateStatus:YES];
        [BBUser setNeedSynchronizeDueDate:NO];
        [BBUser setNeedSynchronizeStatisticsDueDate:YES];
        BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate pregnancyCookieInfo];
        [MobClick event:@"sign_in_up_v2" label:@"手机成功注册数量"];
        [MobClick event:@"sign_in_up_v2" label:@"成功注册总次数"];
        if (![BBUser isBandFatherStatus])
        {
            NSDate *date = [NSDate dateWithDaysFromNow:3];
            NSDate *notidate = [[date dateAtStartOfDay]dateByAddingHours:20];
            [NoticeUtil registerCustomLocationNoti:@"谁说怀孕生娃只是女人的事情，快来请你的另一半来一起享受孕育的快乐吧!" withNotiInfoName:@"BBMotherBindingNoti" withNotiDate:notidate];
        }

        //重新为该设备推送绑定用户LoginString
        if ([BBRemotePushInfo isRegisterPushToApple]) {
            [self.registerPushRequest  clearDelegatesAndCancel];
            self.registerPushRequest  = [BBRegisterPush registerPushNofitycation:[BBRemotePushInfo getUserDeviceToken]];
            [self.registerPushRequest  setDidFinishSelector:@selector(registerPushFinish:)];
            [self.registerPushRequest  setDidFailSelector:@selector(registerPushFail:)];
            [self.registerPushRequest  setDelegate:self];
            [self.registerPushRequest  startAsynchronous];
        }else{
            BBModifyUserName *modifyView = [[BBModifyUserName alloc] initWithNibName:@"BBModifyUserName" bundle:nil];
            modifyView.m_Delegate = self;
            modifyView.m_UserName = self.s_UserName;
            [self.navigationController pushViewController:modifyView animated:YES];
        }
        //将用户登录信息存入粘贴板
        [BBPasteboardTool setLoginDesToPasteboardWith:registerData];
        
        if(self.isApply)
        {
            [self applyBabyboxRequest];
        }
        

    } else if ([[registerData stringForKey:@"status"] isEqualToString:@"phone_number_error"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手机号错误" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if ([[registerData stringForKey:@"status"] isEqualToString:@"phone_register_already"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手机号已被注册" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if ([[registerData stringForKey:@"status"] isEqualToString:@"register_code_error"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"短信验证码错误" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)phoneNumberRegisterFail:(ASIHTTPRequest *)request
{
    [self.loadProgress hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}



- (void)registerPushFinish:(ASIHTTPRequest *)request
{
    [self.loadProgress hide:YES];
    
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *loginData = [parser objectWithString:responseString error:&error];
    if (error == nil) {
        if ([[loginData stringForKey:@"status"] isEqualToString:@"success"]) {
            [BBRemotePushInfo setIsRegisterPushToBabytree:NO];
            BBModifyUserName *modifyView = [[BBModifyUserName alloc] initWithNibName:@"BBModifyUserName" bundle:nil];
            modifyView.m_Delegate = self;
            modifyView.m_UserName = self.s_UserName;
            [self.navigationController pushViewController:modifyView animated:YES];
            return;
        }else{
            [BBRemotePushInfo setIsRegisterPushToBabytree:YES];
            BBModifyUserName *modifyView = [[BBModifyUserName alloc] initWithNibName:@"BBModifyUserName" bundle:nil];
            modifyView.m_Delegate = self;
            modifyView.m_UserName = self.s_UserName;
            [self.navigationController pushViewController:modifyView animated:YES];
        }
    }
}

- (void)registerPushFail:(ASIHTTPRequest *)request
{
    [self.loadProgress hide:YES];    
    [BBRemotePushInfo setIsRegisterPushToBabytree:YES];
    BBModifyUserName *modifyView = [[BBModifyUserName alloc] initWithNibName:@"BBModifyUserName" bundle:nil];
    modifyView.m_Delegate = self;
    modifyView.m_UserName = self.s_UserName;
    [self.navigationController pushViewController:modifyView animated:YES];
}

#pragma mark - BBPerfectInformation Delegate

- (void)modifyUserNameCall
{
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate numberRegisterFinish];
}


- (void)showViladate {
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if (![keywindow.subviews containsObject:self]) {
        CGRect sf = self.validateView.frame;
        CGRect vf = keywindow.frame;
        CGRect of = CGRectMake(0, 0, vf.size.width, vf.size.height-sf.size.height);
        UIView * overlay = [[UIView alloc] initWithFrame:keywindow.bounds];
        overlay.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
        overlay.tag = 20000;
        
        [keywindow addSubview:overlay];
        
        UIControl * dismissButton = [[UIControl alloc] initWithFrame:CGRectZero];
        [dismissButton addTarget:self action:@selector(dismissKeyborad) forControlEvents:UIControlEventTouchUpInside];
        dismissButton.backgroundColor = [UIColor clearColor];
        dismissButton.frame = of;
        [overlay addSubview:dismissButton];
        
        // Present view animated
        self.validateView.frame = CGRectMake((vf.size.width-sf.size.width)/2.0,(vf.size.height-sf.size.height)/2.0-80, sf.size.width, sf.size.height);
        [keywindow addSubview:self.validateView];
        self.validateView.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.validateView.layer.shadowOffset = CGSizeMake(0, -2);
        self.validateView.layer.shadowRadius = 5.0;
        self.validateView.layer.shadowOpacity = 0.8;
        self.validateView.tag = 30000;
    }
}

- (void)dismissModalView
{
    UIWindow * keywindow = [[UIApplication sharedApplication] keyWindow];
    UIView *overlay = [keywindow viewWithTag:20000];
    UIView *_self = [keywindow viewWithTag:30000];
    [UIView animateWithDuration:0.3f animations:^{
    } completion:^(BOOL finished) {
        [overlay removeFromSuperview];
        [_self removeFromSuperview];
    }];
    
    [self.finishButton setEnabled:YES];
}

- (void)dismissKeyborad
{
    [self.codeText resignFirstResponder];
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

- (IBAction)isBabyboxAction:(UIButton *)sender
{
    if (self.isApply) {
        [sender setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        self.isApply = NO;
    } else {
        [sender setImage:[UIImage imageNamed:@"checkbox-selected"] forState:UIControlStateNormal];
        self.isApply = YES;
    }
}

-(void)applyBabyboxRequest{
    [self.babyboxRequest clearDelegatesAndCancel];
    self.babyboxRequest = [BBUserRequest babyboxUserID:[BBUser getLoginString] withPhoneNumber:self.userPhoneNumber];
    [self.babyboxRequest startAsynchronous];
}

@end
