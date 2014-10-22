//
//  BBChoseRole.m
//  pregnancy
//
//  Created by babytree on 13-7-25.
//  Copyright (c) 2013年 babytree. All rights reserved.
//
#import "BBChoseRole.h"
#import "BBApp.h"
#import "BBMainPage.h"
#import "BBAppDelegate.h"
#import "MobClick.h"
#import "NoticeUtil.h"
#import "BBDueDateViewController.h"
#import "BBNavigationLabel.h"
#import "YBBDateSelect.h"
#import "BBAppInfo.h"

@interface BBChoseRole ()

@end

@implementation BBChoseRole

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的状态"];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    [self.navigationItem setLeftBarButtonItem:nil];
    [BBAppInfo setEnableShowVersionUpdateGuideImage:YES];
    
    if (IS_IPHONE5) {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 504);
        [self.roleView setTop:self.roleView.frame.origin.y + 26];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}
- (IBAction)choseRole:(id)sender {
    UIButton *btn = (UIButton*)sender;
    NSString *alertContent = @"进入孕期版";
    if (btn.tag==102 || btn.tag == 112) {
        [MobClick event:@"my_status_v2" label:@"我在备孕中"];
        alertContent = @"进入备孕版";
    }else if(btn.tag==103 || btn.tag == 113){
        [MobClick event:@"my_status_v2" label:@"宝宝已出生"];
        alertContent = @"进入育儿版";
    }
    else
    {
        [MobClick event:@"my_status_v2" label:@"我在怀孕中"];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:alertContent delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alertView.tag = btn.tag;
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag==102 || alertView.tag == 112) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            [BBPregnancyInfo setPregnancyTimeWithDueDate:[NSDate dateWithTimeInterval:86400*300 sinceDate:[NSDate date]]];
            //备孕不检查，不同步预产期
            //[BBUser setCheckDueDateStatus:NO];
            [BBUser setNeedSynchronizeDueDate:NO];
            [BBUser setNewUserRoleState:BBUserRoleStatePrepare];
            
            [BBUser setNeedSynchronizePrepareDueDate:YES];
            BBAppDelegate *appDelegate = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate synchronizePrepareDueDate];
            
            if (![BBApp getAppLaunchStatus]) {
                [BBApp setAppLaunchStatus:YES];
                BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate enterMainPage];
            }
            return;
        }
        if (alertView.tag==101 || alertView.tag == 111) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            if ([BBPregnancyInfo dateOfPregnancy] != nil)
            {
                //修改错误预产期
                NSDate *nowDate =[NSDate dateWithTimeInterval:86400*258 sinceDate:[NSDate date]];
                if([[BBPregnancyInfo dateOfPregnancy] compare:nowDate] == NSOrderedDescending)
                {
                    [BBPregnancyInfo setPregnancyTimeWithDueDate:nowDate];
                }
            }
            BBDueDateViewController *dueDateContorller = [[BBDueDateViewController alloc] initWithNibName:@"BBDueDateViewController" bundle:nil];
            dueDateContorller.isInitialDueDate = YES;
            dueDateContorller.isRegisterNotice = NO;
            [self.navigationController pushViewController:dueDateContorller animated:YES];
            return;
        }
        if (alertView.tag==103 || alertView.tag == 113) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            YBBDateSelect *dateSelect = [[YBBDateSelect alloc] initWithNibName:@"YBBDateSelect" bundle:nil];
            dateSelect.m_IsChoseRole = YES;
            [self.navigationController pushViewController:dateSelect animated:YES];
            return;
        }
    }
}

@end