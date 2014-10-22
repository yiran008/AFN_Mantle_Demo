//
//  BBDateSelect.m
//  pregnancy
//
//  Created by Jun Wang on 12-4-12.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "YBBDateSelect.h"
#import "MobClick.h"
#import "BBStatisticsUtil.h"
#import "BBPregnancyInfo.h"
#import "BBApp.h"
#import "BBAppConfig.h"
#import "BBAppDelegate.h"
#import "BBSettingViewController.h"

@implementation YBBDateSelect


@synthesize dueDatePicker,datePickerButton,datePickerView;

#pragma mark - memory management


- (void)dealloc
{
    [self.dueDateRequest clearDelegatesAndCancel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"输入宝宝出生日期";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    [self.navigationItem setHidesBackButton:YES];
    
//    if (self.m_IsChoseRole) {
//        [self.navigationItem setLeftBarButtonItem:nil];
//    }else{
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.tag = 100;
        backButton.exclusiveTouch = YES;
        [backButton setFrame:CGRectMake(0, 0, 40, 30)];
        [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backBarButton];
//    }
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.exclusiveTouch = YES;
    [rightButton setFrame:CGRectMake(252, 0, 40, 30)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [rightButton addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    self.saveDueProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.saveDueProgress];
    
    if(self.m_DefaultDateForRoleChange)
    {
        [dueDatePicker setDate:self.m_DefaultDateForRoleChange];
    }
    else
    {
        if ([BBPregnancyInfo dateOfPregnancy]==nil)
        {
            [dueDatePicker setDate:[BBPregnancyInfo currentDate]];
        }
        else
        {
            [dueDatePicker setDate:[BBPregnancyInfo dateOfPregnancy]];
        }
    }
    // 设置日期可选范围
    [dueDatePicker setMinimumDate:[NSDate dateWithTimeIntervalSince1970:0]];
    [dueDatePicker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy'年'MM'月'dd'日"];
    [datePickerButton setTitle:[dateFormatter stringFromDate:dueDatePicker.date] forState:UIControlStateNormal];
    IPHONE5_ADAPTATION
    if (IS_IPHONE5) {
        [datePickerView setFrame:CGRectMake(datePickerView.frame.origin.x, datePickerView.frame.origin.y + 88, datePickerView.frame.size.width, datePickerView.frame.size.height)];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

#pragma mark - IBAction Event

- (IBAction)backAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if(button.tag == 100)
    {
        if(self.presentingViewController)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        if(self.isGoBack)
        {
//            if ([BBUser isLogin])
//            {
                [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_PERSONAL_PREGNANCY object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];

//            }
            for (UIViewController *viewCtrl in [self.navigationController viewControllers])
            {
                if ([viewCtrl isKindOfClass:[BBSettingViewController class]]) {
                    [self.navigationController popToViewController:viewCtrl animated:YES];
                    break;
                }
            }
            
        }
        else
        {
            if(self.presentingViewController)
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (IBAction)datePickerAction:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy'年'MM'月'dd'日"];
    NSString *tmp = [dateFormatter stringFromDate:dueDatePicker.date];
    [datePickerButton setTitle:tmp forState:UIControlStateNormal];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [datePickerView setFrame:CGRectMake(0, IPHONE5_ADD_HEIGHT(200), 320, 260)];
    [UIView commitAnimations];
}

- (IBAction)pickerValueChangeAction:(UIDatePicker *)sender
{   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy'年'MM'月'dd'日"];
    [datePickerButton setTitle:[dateFormatter stringFromDate:dueDatePicker.date] forState:UIControlStateNormal];
}

- (IBAction)doneAction:(UIButton *)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [datePickerView setFrame:CGRectMake(0, IPHONE5_ADD_HEIGHT(460), 320, 260)];
    [UIView commitAnimations];
}

- (IBAction)closeAllPickerView:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [datePickerView setFrame:CGRectMake(0, IPHONE5_ADD_HEIGHT(460), 320, 260)];
    [UIView commitAnimations];
}

- (IBAction)commitAction:(UIButton *)sender
{    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [datePickerView setFrame:CGRectMake(0, IPHONE5_ADD_HEIGHT(460), 320, 260)];
    [UIView commitAnimations];

    if (self.m_IsChoseRole) {
        [BBUser setNeedSynchronizeDueDate:NO];
        [BBUser setNeedSynchronizeStatisticsDueDate:YES];
        [BBPregnancyInfo setPregnancyTimeWithDueDate:dueDatePicker.date];
        [BBUser setNewUserRoleState:BBUserRoleStateHasBaby];
        if (![BBApp getAppLaunchStatus]) {
            [BBApp setAppLaunchStatus:YES];
            BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate enterMainPage];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        [MobClick event:@"edit_v2" label:@"成功保存宝宝生日"];
    }else {
        [self checkSynchronizeDueDate];
    }

}

- (void)checkSynchronizeDueDate
{
    if (![BBUser isLogin]) {
        //判断这个是因为避免修改预产期后回到首页提示预产期已修改...
        [BBPregnancyInfo setPregnancyTimeWithDueDate:dueDatePicker.date];
        
        
        [self.saveDueProgress setLabelText:@"保存成功"];
        self.saveDueProgress.animationType = MBProgressHUDAnimationFade;
        self.saveDueProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        self.saveDueProgress.mode = MBProgressHUDModeCustomView;
        [self.saveDueProgress show:YES];
        [self.saveDueProgress hide:YES afterDelay:1];
        
        //[BBUser setCheckDueDateStatus:YES];
        [BBUser setNeedSynchronizeDueDate:NO];
        [BBUser setNeedSynchronizeStatisticsDueDate:YES];
        // 修改用户状态
        [BBUser setNewUserRoleState:BBUserRoleStateHasBaby];
        [MobClick event:@"edit_v2" label:@"成功保存宝宝生日"];
        [self performSelector:@selector(backAction:) withObject:nil afterDelay:1];
    }else {
        [self setPregnancyDueDate];
    }
}

- (void)setPregnancyDueDate
{
    [self showProgressWithTitle:@"保存中..."];
    NSDate *newDate = dueDatePicker.date;
    [self.dueDateRequest clearDelegatesAndCancel];
    self.dueDateRequest = [BBUserRequest modifyUserDueDate:newDate];
    [self.dueDateRequest setDidFinishSelector:@selector(synchronizeDueDateFinish:)];
    [self.dueDateRequest setDidFailSelector:@selector(synchronizeDueDateFail:)];
    [self.dueDateRequest setDelegate:self];
    [self.dueDateRequest startAsynchronous];
}

#pragma mark - ASIHttpRequest delegate
- (void)synchronizeDueDateFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        [self hideProgerssWithTile:@"保存失败" delay:1.5 customImageName:@"xxx"];
        return;
    }
    if ([[jsonDictionary stringForKey:@"status"] isEqualToString:@"success"]) {
        
        [BBPregnancyInfo setPregnancyTimeWithDueDate:dueDatePicker.date];

        [MobClick event:@"edit_v2" label:@"成功保存宝宝生日"];
        //[BBUser setCheckDueDateStatus:YES];
        [BBUser setNeedSynchronizeDueDate:NO];
        [BBUser setNeedSynchronizeStatisticsDueDate:YES];
        // 修改用户状态
        [BBUser setNewUserRoleState:BBUserRoleStateHasBaby];
        
        [self hideProgerssWithTile:@"保存成功" delay:1.5 customImageName:@"37x-Checkmark.png"];
        [self performSelector:@selector(backAction:) withObject:nil afterDelay:1.5];
        
    }else {
        [self hideProgerssWithTile:@"保存失败" delay:1.5 customImageName:@"xxx"];
    }
}

- (void)synchronizeDueDateFail:(ASIFormDataRequest *)request
{
    [self hideProgerssWithTile:@"保存失败" delay:1.5 customImageName:@"xxx"];
}

- (void)hideProgerssWithTile:(NSString *)title delay:(float)delay customImageName:(NSString *)iamgeName {
    self.saveDueProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iamgeName]];
    self.saveDueProgress.mode = MBProgressHUDModeCustomView;
    self.saveDueProgress.labelText = title;
    [self.saveDueProgress hide:YES afterDelay:delay];
}

- (void)showProgressWithTitle:(NSString *)title
{
    self.saveDueProgress.mode = MBProgressHUDModeIndeterminate;
    self.saveDueProgress.labelText = title;
    [self.saveDueProgress show:YES];
}

@end
