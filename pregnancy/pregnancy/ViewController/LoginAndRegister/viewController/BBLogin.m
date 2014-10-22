//
//  BBLogin.m
//  pregnancy
//
//  Created by whl on 14-4-8.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBLogin.h"
#import "BBSupportTopicDetail.h"
#import "BBHospitalRequest.h"
#import "BBPasteboardTool.h"
#import "BBRemotePushInfo.h"
#import "BBLoginAndRegisterRequest.h"
#import "BBRegisterPush.h"
#import "BBThirdUserRequest.h"

@interface BBLogin ()
{
    CGPoint s_gesturePoint;
}
@property(nonatomic, strong) NSString *s_DefaultUserName;
@end

@implementation BBLogin

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
    [_m_LoginRequest clearDelegatesAndCancel];
    [_m_Requests clearDelegatesAndCancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.m_ProgressBox = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.m_ProgressBox];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [panRecognizer setDelegate:self];
    [self.view addGestureRecognizer:panRecognizer];
    self.view.exclusiveTouch = YES;
    
    IPHONE5_ADAPTATION
    [self.m_EmailTextField setValue:[UIColor colorWithRed:240/255.0 green:200/255.0 blue:210/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [self.m_PasswordTextField setValue:[UIColor colorWithRed:240/255.0 green:200/255.0 blue:210/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    ((UIButton*)[self.view viewWithTag:1010]).exclusiveTouch = YES;
    ((UIButton*)[self.view viewWithTag:1011]).exclusiveTouch = YES;
    ((UIButton*)[self.view viewWithTag:1012]).exclusiveTouch = YES;
    ((UIButton*)[self.view viewWithTag:1013]).exclusiveTouch = YES;
    ((UIButton*)[self.view viewWithTag:1014]).exclusiveTouch = YES;
    ((UIButton*)[self.view viewWithTag:1015]).exclusiveTouch = YES;
    ((UIButton*)[self.view viewWithTag:1016]).exclusiveTouch = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [[UIApplication sharedApplication].delegate.window setBackgroundColor:[UIColor blackColor]];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)backAction:(id)sender
{
    if (self.m_LoginType == BBPushLogin)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(backActionFromLoginVC)] && sender)
            {
                [self.delegate backActionFromLoginVC];
            }
        }];
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)registerAction:(id)sender
{
//    BBSelectRegisterController *registerController = [[BBSelectRegisterController alloc] initWithNibName:@"BBSelectRegisterController" bundle:nil];
//    [registerController setDelegate:self];
//    [self.navigationController pushViewController:registerController animated:YES];
    
    [MobClick event:@"sign_in_up_v2" label:@"新账号注册点击"];
    BBNumberRegister *numberRegister = [[BBNumberRegister alloc] initWithNibName:@"BBNumberRegister" bundle:nil];
    numberRegister.delegate = self;
    [self.navigationController pushViewController:numberRegister animated:YES];
}


- (IBAction)loginAction:(id)sender
{
    [self.m_EmailTextField resignFirstResponder];
    [self.m_PasswordTextField resignFirstResponder];
    
    if (![BBValidateUtility checkPhoneNumInput:self.m_EmailTextField.text] && ![BBValidateUtility isValidateEmail:self.m_EmailTextField.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机账号或者邮箱账号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [self.m_ProgressBox setLabelText:@"正在登录"];
    [self.m_ProgressBox show:YES];
    
    [self.m_LoginRequest clearDelegatesAndCancel];
    self.m_LoginRequest = [BBLoginAndRegisterRequest loginWithEmail:self.m_EmailTextField.text withPassword:self.m_PasswordTextField.text];
    if ([BBValidateUtility checkPhoneNumInput:self.m_EmailTextField.text]) {
        self.m_LoginRequest.tag = 101;
    }else{
        self.m_LoginRequest.tag = 102;
    }
    [self.m_LoginRequest setDidFinishSelector:@selector(loginFinish:)];
    [self.m_LoginRequest setDidFailSelector:@selector(loginFail:)];
    [self.m_LoginRequest setDelegate:self];
    [self.m_LoginRequest startAsynchronous];
}

#pragma mark - ASIHttpRequest Delegate

- (void)loginFinish:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *loginData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        [self.m_ProgressBox hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起，登录失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([[loginData stringForKey:@"status"] isEqualToString:@"0"] || [[loginData stringForKey:@"status"] isEqualToString:@"success"])
    {
        
        NSDictionary *userInfoData = [loginData dictionaryForKey:@"user_info"];
        if (userInfoData == nil)
        {
            loginData = [loginData dictionaryForKey:@"data"];
            userInfoData = [loginData dictionaryForKey:@"user_info"];
        }
        [BBUser setUserLevel:[loginData stringForKey:@"sum_level"]];
        [BBCookie pregnancyCookie:[loginData stringForKey:@"cookie"]];
        [BBUser localCookie:[loginData stringForKey:@"cookie"]];
        
        [BBUser setLoginString:[loginData stringForKey:@"login_string"]];
        [BBUser setSmartWatchCode:[userInfoData stringForKey:@"watch_bluetooth_mac"]];
        [BBUser setNickname:[userInfoData stringForKey:@"nickname"]];
        [BBUser setEncodeID:[userInfoData stringForKey:@"enc_user_id"]];
        [BBUser setAvatarUrl:[userInfoData stringForKey:@"avatar_url"]];
        if ([BBUser getAvatarUrl] != nil) {
            [BBUser setLocalAvatar:nil];
        }
        [BBUser setEmailAccount:self.m_EmailTextField.text];
        if ([userInfoData stringForKey:@"email"] != nil) {
            [BBUser setEmailAccount:[userInfoData stringForKey:@"email"]];
        }
        [BBUser setPassword:self.m_PasswordTextField.text];
        [BBUser setLocation:[userInfoData stringForKey:@"location"]];
        [BBUser setUserOnlyCity:[userInfoData stringForKey:@"location"]];
        [BBUser setGender:[userInfoData stringForKey:@"gender"]];
        [BBUser setRegisterTime:[userInfoData stringForKey:@"reg_ts"]];
        [BBUser setBabyBirthday:[userInfoData stringForKey:@"baby_birthday_ts"]];
        
        NSDictionary *bandInfo = [loginData dictionaryForKey:@"mom_father_relation"];
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
        
        
        NSString *groupId =[NSString stringWithFormat:@"%@",[userInfoData stringForKey:@"group_id"]];
        if ([groupId isEqualToString:@"0"]) {
            if(![[userInfoData stringForKey:@"hospital_name"] isEqualToString:@""])
            {
                NSString *name = [userInfoData stringForKey:@"hospital_name"];
                [BBHospitalRequest setAddedHospitalName:name];
                [BBHospitalRequest setPostSetHospital:@"0"];
            }
        } else {
            NSString *name = [userInfoData stringForKey:@"hospital_name"];
            NSString *hospitalId =[NSString stringWithFormat:@"%@",[userInfoData stringForKey:@"hospital_id"]];
            NSDictionary *category = [[NSDictionary alloc] initWithObjectsAndKeys:name, kHospitalNameKey, hospitalId, kHospitalHospitalIdKey, groupId, kHospitalGroupIdKey, nil];
            [BBHospitalRequest setHospitalCategory:category];
            [BBHospitalRequest setAddedHospitalName:name];
            [BBHospitalRequest setPostSetHospital:@"1"];
        }
        
        if (![BBUser isBandFatherStatus])
        {
            NSDate *date = [NSDate dateWithDaysFromNow:3];
            NSDate *notidate = [[date dateAtStartOfDay]dateByAddingHours:20];
            [NoticeUtil registerCustomLocationNoti:@"谁说怀孕生娃只是女人的事情，快来请你的另一半来一起享受孕育的快乐吧!" withNotiInfoName:@"BBMotherBindingNoti" withNotiDate:notidate];
        }
        //[BBUser setCheckDueDateStatus:YES];
        [BBUser setNeedSynchronizeDueDate:NO];
        [BBUser setNeedSynchronizeStatisticsDueDate:YES];
        BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate pregnancyCookieInfo];
        
        //将用户登录信息存入粘贴板
        [BBPasteboardTool setLoginDesToPasteboardWith:loginData];
        if (request.tag==101)
        {
            [MobClick event:@"sign_in_up_v2" label:@"手机成功登录数量"];
        }
        else if(request.tag==102)
        {
            [MobClick event:@"sign_in_up_v2" label:@"邮箱成功登录数量"];
        }
        if (self.m_LoginFashion == BBSinaLogin )
        {
            [MobClick event:@"sign_in_up_v2" label:@"新浪微博第三方成功登录数量（不含注册）"];
            
        }
        else if(self.m_LoginFashion == BBQQLogin)
        {
            [MobClick event:@"sign_in_up_v2" label:@"QQ第三方成功登录数量（不含注册）"];
        }
        [MobClick event:@"sign_in_up_v2" label:@"成功登录总次数"];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];

        
        //重新为该设备推送绑定用户LoginString
        if ([BBRemotePushInfo isRegisterPushToApple]) {
            [self.m_LoginRequest clearDelegatesAndCancel];
            self.m_LoginRequest = [BBRegisterPush registerPushNofitycation:[BBRemotePushInfo getUserDeviceToken]];
            [self.m_LoginRequest setDidFinishSelector:@selector(registerPushFinish:)];
            [self.m_LoginRequest setDidFailSelector:@selector(registerPushFail:)];
            [self.m_LoginRequest setDelegate:self];
            [self.m_LoginRequest startAsynchronous];
        } else {
            [self.m_ProgressBox hide:YES];
            if (self.m_LoginFashion == BBDefauleLogin) {
                [self weiLoginShareFinish];
            } else {
                [self thirdPartLoginFinish];
            }
        }
    } else if ([[loginData stringForKey:@"status"] isEqualToString:@"no_bind"]) {
        [self.m_ProgressBox hide:YES];
        BBPerfectInformation *perfectinfo = [[BBPerfectInformation alloc] initWithNibName:@"BBPerfectInformation" bundle:nil];
        perfectinfo.m_Delagate = self;
        perfectinfo.m_BindingUserData = [loginData dictionaryForKey:@"data"];
        perfectinfo.m_UserName = self.s_DefaultUserName;
        [self.navigationController pushViewController:perfectinfo animated:YES];
    } else {
        [self.m_ProgressBox hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起，登录失败" message:[loginData stringForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)loginFail:(ASIHTTPRequest *)request
{
    [self.m_ProgressBox hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)registerPushFinish:(ASIHTTPRequest *)request
{
    [self.m_ProgressBox hide:YES];
    
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *loginData = [parser objectWithString:responseString error:&error];
    if (error == nil) {
        if ([[loginData stringForKey:@"status"] isEqualToString:@"success"]) {
            [BBRemotePushInfo setIsRegisterPushToBabytree:NO];
            //由于自己登陆也用这个方法
            if (self.m_LoginFashion == BBDefauleLogin) {
                [self weiLoginShareFinish];
            } else {
                [self thirdPartLoginFinish];
            }
            return;
        }else{
            [BBRemotePushInfo setIsRegisterPushToBabytree:YES];
            //由于自己登陆也用这个方法
            if (self.m_LoginFashion == BBDefauleLogin) {
                [self weiLoginShareFinish];
            } else {
                [self thirdPartLoginFinish];
            }
        }
    }
}

- (void)registerPushFail:(ASIHTTPRequest *)request
{
    [self.m_ProgressBox hide:YES];
    
    [BBRemotePushInfo setIsRegisterPushToBabytree:YES];
    if (self.m_LoginFashion == BBDefauleLogin) {
        [self weiLoginShareFinish];
    } else {
        [self thirdPartLoginFinish];
    }
}

- (IBAction)weiboLoginAction:(id)sender
{
    [MobClick event:@"sign_in_up_v2" label:@"新浪微博登录点击"];
    
    if ([UMSocialAccountManager isOauthWithPlatform:UMShareToSina])
    {
        self.m_LoginFashion = BBSinaLogin;
        [self bindWeibo];
    } else {
        //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
        {
            self.m_LoginFashion = BBSinaLogin;
            [self bindWeibo];
        });
    }
}

- (IBAction)closeKeyboardAction:(id)sender
{
    [self.m_EmailTextField resignFirstResponder];
    [self.m_PasswordTextField resignFirstResponder];
}


- (IBAction)findPasswordAction:(id)sender
{
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.title = @"找回密码";
    exteriorURL.isShowCloseButton = NO;
    [exteriorURL setLoadURL:@"http://www.babytree.com/reg/forgotpwd.php"];
    [self.navigationController pushViewController:exteriorURL animated:YES];
}

- (IBAction)QQLoginAction:(id)sender
{
    [MobClick event:@"sign_in_up_v2" label:@"QQ登录点击"];
    
    if ([UMSocialAccountManager isOauthWithPlatform:UMShareToQzone])
    {
        self.m_LoginFashion = BBQQLogin;
        [self bindWeibo];
    } else {
        //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
        {
            self.m_LoginFashion = BBQQLogin;
            [self bindWeibo];
            
        });
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.m_EmailTextField) {
        [self.m_EmailTextField resignFirstResponder];
        [self.m_PasswordTextField becomeFirstResponder];
        return NO;
    } else if (textField == self.m_PasswordTextField) {
        [self.m_PasswordTextField resignFirstResponder];
    }
    return NO;
}

#pragma mark - UIGestureRecognizer Delegate

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:[self view]];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        s_gesturePoint = location;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (location.y - s_gesturePoint.y >= 30) {
            [self.m_EmailTextField resignFirstResponder];
            [self.m_PasswordTextField resignFirstResponder];
        }
    }
}


#pragma mark - BBRegister Delegate

//屏蔽邮箱注册
- (void)selectRegisterFinish
{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//    }
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    [self backAction:nil];
//    [self.delegate loginFinish];
}

- (void)numberRegisterFinish
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self backAction:nil];
    [self.delegate loginFinish];
}

- (void)thirdPartLoginFinish
{
    if(self.m_LoginFashion == BBSinaLogin)
    {
        BBWeiLoginShare *weiLoginShare = [[BBWeiLoginShare alloc]initWithNibName:@"BBWeiLoginShare" bundle:nil];
        weiLoginShare.delegate = self;
        weiLoginShare.weiboState = self.m_LoginFashion;
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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self backAction:nil];
    [self.delegate loginFinish];
}

#pragma mark - BBPerfectInformation Delegate

- (void)perfectInformationFinish
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self backAction:nil];
    [self.delegate loginFinish];
}

#pragma mark - The Third Party Login Method

- (void)bindWeibo
{
    NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
    
    if (![snsAccountDic isNotEmpty])
    {
        self.m_LoginFashion = BBDefauleLogin;
        return;
    }
    if (self.m_LoginFashion == BBSinaLogin ) {
        UMSocialAccountEntity *accountEnitity = [snsAccountDic valueForKey:UMShareToSina];
        [self.m_Requests clearDelegatesAndCancel];
        self.s_DefaultUserName = accountEnitity.userName;
        self.m_Requests = [BBThirdUserRequest thirdPartLogin:accountEnitity.accessToken withType:THIRD_PART_LOGIN_SINA withUID:accountEnitity.usid];
        [self.m_Requests setDelegate:self];
        [self.m_Requests setDidFinishSelector:@selector(loginFinish:)];
        [self.m_Requests setDidFailSelector:@selector(loginFail:)];
        [self.m_Requests startAsynchronous];
        [self.m_ProgressBox show:YES];
    }else if(self.m_LoginFashion == BBQQLogin){
        UMSocialAccountEntity *accountEnitity = [snsAccountDic valueForKey:UMShareToQzone];
        [self.m_Requests clearDelegatesAndCancel];
        NSLog(@"uid %@",accountEnitity.usid);
        self.s_DefaultUserName = accountEnitity.userName;
        self.m_Requests = [BBThirdUserRequest thirdPartLogin:accountEnitity.accessToken withType:THIRD_PART_LOGIN_TENCENT withUID:accountEnitity.usid];
        [self.m_Requests setDelegate:self];
        [self.m_Requests setDidFinishSelector:@selector(loginFinish:)];
        [self.m_Requests setDidFailSelector:@selector(loginFail:)];
        [self.m_Requests startAsynchronous];
        [self.m_ProgressBox show:YES];
    }
}

@end
