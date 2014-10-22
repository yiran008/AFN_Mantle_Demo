//
//  BBUserStatusViewController.m
//  pregnancy
//
//  Created by yxy on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBUserStatusViewController.h"
#import "BBDueDateViewController.h"
#import "YBBDateSelect.h"
#import "BBSettingViewController.h"
#import "MBProgressHUD.h"

@interface BBUserStatusViewController ()

@property (nonatomic,strong) UITableView *s_statusTableView;
@property (nonatomic,strong) MBProgressHUD *s_changeProgress;

@end

@implementation BBUserStatusViewController

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
    [self addNavigationItem];
    
    self.s_statusTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-44) style:UITableViewStylePlain];
    self.s_statusTableView.dataSource = self;
    self.s_statusTableView.delegate = self;
    self.s_statusTableView.bounces = NO;
    UIView *nilView = [[UIView alloc] init];
    nilView.backgroundColor = [UIColor clearColor];
    [self.s_statusTableView setBackgroundView:nilView];
    [self.view addSubview:self.s_statusTableView];
    
    [self addProgress];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.s_statusTableView reloadData];
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

#pragma mark - create UI
- (void)addNavigationItem {
    [self.navigationItem setTitle:@"我的状态"];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
}

- (void)addProgress {
    self.s_changeProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.s_changeProgress];
    
}

#pragma mark - private method

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modifyUserStatus:(id)sender
{
   
}

// 选中的用户状态显示选中图片
- (void)showCheckedImage:(UITableViewCell *)cell withImageView:(UIImageView *)checkedImageView withIndex:(NSInteger)index
{
    if([BBUser getNewUserRoleState] == BBUserRoleStatePrepare && index == 0)
    {
        [cell.contentView addSubview:checkedImageView];
        cell.textLabel.textColor = [UIColor colorWithHex:0x666666];
    }
    else if([BBUser getNewUserRoleState] == BBUserRoleStatePregnant && index == 1)
    {
        [cell.contentView addSubview:checkedImageView];
        cell.textLabel.textColor = [UIColor colorWithHex:0x666666];
    }
    else if([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby && index == 2)
    {
        [cell.contentView addSubview:checkedImageView];
        cell.textLabel.textColor = [UIColor colorWithHex:0x666666];
    }
    else
    {
        [cell.contentView removeAllSubviews];
        cell.textLabel.textColor = [UIColor colorWithHex:0xaaaaaa];
    }
}



#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [cell.textLabel setTextColor:[UIColor colorWithHex:0xaaaaaa]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setBackgroundColor:[UIColor whiteColor]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *checkedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(84, 14, 16, 16)];
    [cell.contentView addSubview:checkedImageView];
    checkedImageView.image = [UIImage imageNamed:@"setting_hook_icon"];
    

    if(indexPath.row == 0)
    {
        [cell.textLabel setText:@"                          准备怀孕"];
        [cell.detailTextLabel setText:@""];
        [self showCheckedImage:cell withImageView:checkedImageView withIndex:0];
     
    }
    else if(indexPath.row == 1)
    {
        [cell.textLabel setText:@"                            怀孕中"];
        [cell.detailTextLabel setText:@""];
        [self showCheckedImage:cell withImageView:checkedImageView withIndex:1];
    }
    else
    {
        [cell.textLabel setText:@"                         宝宝已出生"];
        [cell.detailTextLabel setText:@""];
        [self showCheckedImage:cell withImageView:checkedImageView withIndex:2];

    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [BBUser setNeedSynchronizePrepareDueDate:NO];
    if(indexPath.row == 0 && [BBUser getNewUserRoleState] != BBUserRoleStatePrepare)
    {
        [MobClick event:@"setting_v2" label:@"状态-准备怀孕"];
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        if([reachability currentReachabilityStatus] == NotReachable)
        {
            [self.s_changeProgress setLabelText:@"网络不给力"];
            self.s_changeProgress.animationType = MBProgressHUDAnimationFade;
            self.s_changeProgress.mode = MBProgressHUDModeCustomView;
            [self.s_changeProgress show:YES];
            [self.s_changeProgress hide:YES afterDelay:1];
        }
        else
        {
            // 保存状态
            [BBUser setNewUserRoleState:BBUserRoleStatePrepare];
            
            [self.s_changeProgress setLabelText:@"修改成功"];
            self.s_changeProgress.animationType = MBProgressHUDAnimationFade;
            self.s_changeProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            self.s_changeProgress.mode = MBProgressHUDModeCustomView;
            [self.s_changeProgress show:YES];
            [self.s_changeProgress hide:YES afterDelay:1];
            
            [self.s_statusTableView reloadData];
            [NoticeUtil cancelCustomLocationNoti:@"BBBabyBornLocationNotice"];
            [NoticeUtil cancelCustomLocationNoti:@"BBCutParentRemindNotice"];
            
            [BBUser setNeedSynchronizePrepareDueDate:YES];
            BBAppDelegate *appDelegate = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate synchronizePrepareDueDate];
            
            // 进入设置首页
            [self performSelector:@selector(backAction:) withObject:nil afterDelay:1];
            [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_PERSONAL_PREPARE object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];
        }
    }
    else if(indexPath.row == 1 && [BBUser getNewUserRoleState] != BBUserRoleStatePregnant)
    {
        // 进入预产期设置页
        [MobClick event:@"setting_v2" label:@"状态-怀孕中"];
        
        if ([BBPregnancyInfo dateOfPregnancy] != nil)
        {
            //修改错误预产期
            NSDate *nowDate =[NSDate dateWithTimeInterval:86400*258 sinceDate:[NSDate date]];
            if([[BBPregnancyInfo dateOfPregnancy] compare:nowDate] == NSOrderedDescending)
            {
                [BBPregnancyInfo setPregnancyTimeWithDueDate:nowDate];
            }
        }
        
        NSDate *defaultDate = [BBPregnancyInfo defaultDueDateForUserRoleState:BBUserRoleStatePregnant];
        BBDueDateViewController *dueDateViewcontroller = [[BBDueDateViewController alloc] initWithNibName:@"BBDueDateViewController" bundle:nil];
        dueDateViewcontroller.isGoBack = YES;
        dueDateViewcontroller.isRegisterNotice = NO;
        dueDateViewcontroller.m_DefaultDateForRoleChange = defaultDate;
        [self.navigationController pushViewController:dueDateViewcontroller animated:YES];
    }
    else if(indexPath.row == 2 && [BBUser getNewUserRoleState] != BBUserRoleStateHasBaby)
    {
        [MobClick event:@"setting_v2" label:@"状态-宝宝已出生"];
        [NoticeUtil cancelCustomLocationNoti:@"BBBabyBornLocationNotice"];
        [NoticeUtil cancelCustomLocationNoti:@"BBCutParentRemindNotice"];
        // 进入宝宝生日设置页
        NSDate *defaultDate = [BBPregnancyInfo defaultDueDateForUserRoleState:BBUserRoleStateHasBaby];
        YBBDateSelect *birthdayViewcontroller = [[YBBDateSelect alloc] initWithNibName:@"YBBDateSelect" bundle:nil];
        birthdayViewcontroller.isGoBack = YES;
        birthdayViewcontroller.m_DefaultDateForRoleChange = defaultDate;
        [self.navigationController pushViewController:birthdayViewcontroller animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return DEVICE_HEIGHT - 44*5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    footView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    footView.layer.borderWidth = 0.25f;
    [footView setBackgroundColor:UI_VIEW_BGCOLOR];
    return footView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, DEVICE_HEIGHT - 44*5)];
    footView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    footView.layer.borderWidth = 0.25f;
    [footView setBackgroundColor:UI_VIEW_BGCOLOR];
    return footView;
}
@end
