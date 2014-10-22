//
//  BBPerfectInformation.m
//  pregnancy
//
//  Created by whl on 14-4-8.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBPerfectInformation.h"
#import "BBUserRequest.h"
#import "BBThirdUserRequest.h"
#import "BBHospitalRequest.h"
#import "BBPasteboardTool.h"
#import "BBRemotePushInfo.h"
#import "BBRegisterPush.h"

@interface BBPerfectInformation ()

@end

@implementation BBPerfectInformation

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
    [_m_PerfectRequest       clearDelegatesAndCancel];
    [_m_CheckUserNameRequest clearDelegatesAndCancel];
    [_m_CkeckEmailRequest    clearDelegatesAndCancel];
    [_m_BindingUserRequest   clearDelegatesAndCancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"完善资料";
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
    [commitButton setTitle:@"完成" forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [commitButton addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    [self.navigationItem setRightBarButtonItem:commitBarButton];
    
    self.m_LoadProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.m_LoadProgress];
    self.view.exclusiveTouch = YES;

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
    
    if (![[self.m_UserNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
      [self checkUserNameStatus];   
    }
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

-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)commitAction:(id)sender
{
    if ([[self.m_UserNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || self.m_UserNameTextField.text==nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入您的昵称" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else if([[self.m_EmailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || self.m_EmailTextField.text==nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入您的邮箱" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        if ([self.m_LoadProgress isShow])
        {
            return;
        }
        [self sendRequest];
    }
}

-(void)sendRequest
{
    [self.m_PerfectRequest clearDelegatesAndCancel];
    NSString *pregnancyDate = [NSString stringWithFormat:@"%.0f", [[BBPregnancyInfo dateOfPregnancy] timeIntervalSince1970]];
    self.m_PerfectRequest = [BBThirdUserRequest thirdPartBindingNewUser:[self.m_BindingUserData stringForKey:@"token"] withType:[self.m_BindingUserData stringForKey:@"type"] withNickname:self.m_UserNameTextField.text withEmail:self.m_EmailTextField.text withBabyBirthday:pregnancyDate withUID:[self.m_BindingUserData stringForKey:@"open_id"]];
    [self.m_PerfectRequest setDelegate:self];
    [self.m_PerfectRequest setDidFinishSelector:@selector(commitInfomationFinish:)];
    [self.m_PerfectRequest setDidFailSelector:@selector(commitInfomationFail:)];
    [self.m_PerfectRequest startAsynchronous];
   
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
    if (textField == self.m_UserNameTextField) {
        [self.m_UserNameTextField resignFirstResponder];
        [self.m_EmailTextField becomeFirstResponder];
        return NO;
    } else if (textField == self.m_EmailTextField) {
        [self.m_EmailTextField resignFirstResponder];
        [self.m_UserNameTextField becomeFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 100 && [self.m_UserNameTextField.text length]>0)
    {
        if ([self.m_UserNameTextField.text length] < 4 || [self.m_UserNameTextField.text length] > 12)
        {
            self.m_UserNameLabel.text = @"昵称，4-12个汉字、英文字母或数字";
            return;
        }
        [self checkUserNameStatus];
        return;
    }
    
    if (textField.tag==101 && [self.m_EmailTextField.text length]>0) {
        [self.m_CkeckEmailRequest clearDelegatesAndCancel];
        self.m_CkeckEmailRequest = [BBUserRequest registerEmailCheck:self.m_EmailTextField.text];
        [self.m_CkeckEmailRequest setDelegate:self];
        [self.m_CkeckEmailRequest setDidFinishSelector:@selector(checkEmailInfomationFinish:)];
        [self.m_CkeckEmailRequest setDidFailSelector:@selector(checkEmailInfomationFail:)];
        [self.m_CkeckEmailRequest startAsynchronous];
        return;
    }
    
}

-(void)checkUserNameStatus
{
    [self.m_CheckUserNameRequest clearDelegatesAndCancel];
    self.m_CheckUserNameRequest = [BBUserRequest registerNicknameCheck:self.m_UserNameTextField.text];
    [self.m_CheckUserNameRequest setDelegate:self];
    [self.m_CheckUserNameRequest setDidFinishSelector:@selector(checkNameInfomationFinish:)];
    [self.m_CheckUserNameRequest setDidFailSelector:@selector(checkInfomationFail:)];
    [self.m_CheckUserNameRequest startAsynchronous];
}

//只需要点击非文字输入区域就会响应hideKeyBoard

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doneResign:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer: tapGestureRecognizer];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ASIHttpRequest Delegate

- (void)commitInfomationFinish:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *registerData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        [self.m_LoadProgress hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起，注册失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([[registerData stringForKey:@"status"] isEqualToString:@"success"]) {
        
        NSDictionary *userInfoData = [registerData dictionaryForKey:@"user_info"];
        if (userInfoData == nil) {
            registerData = [registerData dictionaryForKey:@"data"];
            userInfoData = [registerData dictionaryForKey:@"user_info"];
        }
        [MobClick event:@"sign_in_up_v2" label:@"成功注册总次数"];
        
        [BBUser setLoginString:[registerData stringForKey:@"login_string"]];
        [BBUser setSmartWatchCode:[userInfoData stringForKey:@"watch_bluetooth_mac"]];
        [BBUser setNickname:[userInfoData stringForKey:@"nickname"]];
        [BBUser setEncodeID:[userInfoData stringForKey:@"enc_user_id"]];
        [BBUser setAvatarUrl:[userInfoData stringForKey:@"avatar_url"]];
        if ([BBUser getAvatarUrl] != nil) {
            [BBUser setLocalAvatar:nil];
        }
        [BBUser setEmailAccount:[userInfoData stringForKey:@"email"]];
        [BBUser setLocation:[userInfoData stringForKey:@"location"]];
        [BBUser setUserOnlyCity:[userInfoData stringForKey:@"location"]];
        [BBUser setGender:[userInfoData stringForKey:@"gender"]];
        [BBUser setRegisterTime:[userInfoData stringForKey:@"reg_ts"]];
        [BBUser setBabyBirthday:[userInfoData stringForKey:@"baby_birthday_ts"]];
        
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
        //[BBUser setCheckDueDateStatus:YES];
        [BBUser setNeedSynchronizeDueDate:NO];
        [BBUser setNeedSynchronizeStatisticsDueDate:YES];
        BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate pregnancyCookieInfo];
        //将用户登录信息存入粘贴板
        [BBPasteboardTool setLoginDesToPasteboardWith:registerData];
        
        if (![BBUser isBandFatherStatus])
        {
            NSDate *date = [NSDate dateWithDaysFromNow:3];
            NSDate *notidate = [[date dateAtStartOfDay]dateByAddingHours:20];
            [NoticeUtil registerCustomLocationNoti:@"谁说怀孕生娃只是女人的事情，快来请你的另一半来一起享受孕育的快乐吧!" withNotiInfoName:@"BBMotherBindingNoti" withNotiDate:notidate];
        }
        
        //重新为该设备推送绑定用户LoginString
        if ([BBRemotePushInfo isRegisterPushToApple]) {
            [self.m_LoadProgress show:YES];
            [BBRemotePushInfo setIsRegisterPushToBabytree:YES];
            
            [self.m_BindingUserRequest clearDelegatesAndCancel];
            self.m_BindingUserRequest = [BBRegisterPush registerPushNofitycation:[BBRemotePushInfo getUserDeviceToken]];
            [self.m_BindingUserRequest setDidFinishSelector:@selector(registerPushFinish:)];
            [self.m_BindingUserRequest setDidFailSelector:@selector(registerPushFail:)];
            [self.m_BindingUserRequest setDelegate:self];
            [self.m_BindingUserRequest startAsynchronous];
        } else {
            if ([[self.m_BindingUserData stringForKey:@"type"] integerValue] == 1)
            {
                [MobClick event:@"sign_in_up_v2" label:@"新浪微博成功注册数量（不计为当天登录）"];
                BBWeiLoginShare *weiLoginShare = [[BBWeiLoginShare alloc]initWithNibName:@"BBWeiLoginShare" bundle:nil];
                [weiLoginShare setDelegate:self];
                [weiLoginShare setWeiboState:[[self.m_BindingUserData stringForKey:@"type"] integerValue]];
                [self.navigationController pushViewController:weiLoginShare animated:YES];
            }
            else
            {
                [MobClick event:@"sign_in_up_v2" label:@"QQ成功注册数量（不计为当天登录）"];
                [self.m_Delagate perfectInformationFinish];
            }
            
        }
    }
    else
    {
        [self.m_LoadProgress hide:YES];
        NSString *message = [registerData stringForKey:@"message"];
        if (![message isNotEmpty])
        {
            message = @"亲！出错了";
        }
        [AlertUtil showAlert:@"提示" withMessage:message];
    }

}



- (void)registerPushFinish:(ASIFormDataRequest *)request
{
    [self.m_LoadProgress hide:YES];
    
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *loginData = [parser objectWithString:responseString error:&error];
    if (error) {
        return;
    }
    if ([[loginData stringForKey:@"status"] isEqualToString:@"success"]) {
        [BBRemotePushInfo setIsRegisterPushToBabytree:NO];
        if ([[self.m_BindingUserData stringForKey:@"type"] integerValue] == 1)
        {
            [MobClick event:@"sign_in_up_v2" label:@"新浪微博成功注册数量（不计为当天登录）"];
            BBWeiLoginShare *weiLoginShare = [[BBWeiLoginShare alloc]initWithNibName:@"BBWeiLoginShare" bundle:nil];
            [weiLoginShare setDelegate:self];
            [weiLoginShare setWeiboState:[[self.m_BindingUserData stringForKey:@"type"] integerValue]];
            [self.navigationController pushViewController:weiLoginShare animated:YES];
        }
        else
        {
            [MobClick event:@"sign_in_up_v2" label:@"QQ成功注册数量（不计为当天登录）"];
            [self.m_Delagate perfectInformationFinish];
        }
    }
}

- (void)registerPushFail:(ASIFormDataRequest *)request
{
    [self.m_LoadProgress hide:YES];
    if ([[self.m_BindingUserData stringForKey:@"type"] integerValue] == 1)
    {
        [MobClick event:@"sign_in_up_v2" label:@"新浪微博成功注册数量（不计为当天登录）"];
        BBWeiLoginShare *weiLoginShare = [[BBWeiLoginShare alloc]initWithNibName:@"BBWeiLoginShare" bundle:nil];
        [weiLoginShare setDelegate:self];
        [weiLoginShare setWeiboState:[[self.m_BindingUserData stringForKey:@"type"] integerValue]];
        [self.navigationController pushViewController:weiLoginShare animated:YES];
    }
    else
    {
        [MobClick event:@"sign_in_up_v2" label:@"QQ成功注册数量（不计为当天登录）"];
        [self.m_Delagate perfectInformationFinish];
    }
}

- (void)commitInfomationFail:(ASIHTTPRequest *)request
{
    [self.m_LoadProgress hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}



- (void)checkNameInfomationFinish:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *loginData = [parser objectWithString:responseString error:&error];
    if (error == nil) {
        if ([[loginData stringForKey:@"status"] isEqualToString:@"success"]) {
            self.m_UserNameLabel.text = @"恭喜！昵称可以使用";
        }else{
            self.m_UserNameLabel.text = [loginData stringForKey:@"message"];
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
            self.m_EmailLabel.text = @"恭喜！邮箱未被注册";
        }else{
            self.m_EmailLabel.text = [loginData stringForKey:@"message"];
        }
    }
}



- (void)checkEmailInfomationFail:(ASIHTTPRequest *)request
{
    
}

#pragma mark - BBWeiLoginShare Delegate

- (void)weiLoginShareFinish
{
    [self.navigationController popViewControllerAnimated:NO];
    [self.m_Delagate perfectInformationFinish];
}

@end
