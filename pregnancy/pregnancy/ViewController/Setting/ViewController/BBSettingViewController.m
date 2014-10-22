//
//  BBSettingViewController.m
//  pregnancy
//
//  Created by yxy on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBSettingViewController.h"
#import "BBAppInfo.h"
#import "BBSupportTopicDetail.h"
#import "SDImageCache.h"
#import "BBActivityRule.h"
#import "BBAbout.h"
#import "UMFeedbackChat.h"
#import "BBDueDateViewController.h"
#import "BBUserStatusViewController.h"
#import "BBNoticeSettingViewController.h"
#import "BBSnsAccountViewController.h"
#import "BBCustomNavigationController.h"
#import "BBRemotePushInfo.h"
#import "YBBDateSelect.h"
#import "BBInvitePapaViewController.h"
#import "BBFatherRequest.h"
#import "HMShowPage.h"
#import "BBShareContent.h"
#import "BBUmengRecommendApp.h"

#define kSettingLogoutAccountTag 1
#define kCheckUpdateTag 4
#define UNBAND_Tag  122


@interface BBSettingViewController ()

@property (nonatomic, strong) UITableView *settingTableView;
@property (nonatomic, assign) float imageCacheSize;
@property (nonatomic, retain) MBProgressHUD *m_DiskProgress;
@property (nonatomic, strong) MBProgressHUD *settingProgress;

@property (assign, nonatomic) LoginType s_LoginType;
@property (nonatomic, strong) NSString * s_dataSizeStr;

@end

@implementation BBSettingViewController

- (void)dealloc
{
    [_m_FatherUnbandRequest clearDelegatesAndCancel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.s_dataSizeStr = @"计算中...";
    
    [self addNavigationItem];
    [self createSettingTableView];
    
    self.settingProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.settingProgress];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        float cacheSize = [self cacheSize];
        self.imageCacheSize = cacheSize;
        self.s_dataSizeStr = [NSString storeString:cacheSize];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.settingTableView reloadData];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 刷新数据
    [self.settingTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - create UI
- (void)addNavigationItem
{
    [self.navigationItem setTitle:@"设置"];
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

- (void)createSettingTableView
{
    self.settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,DEVICE_HEIGHT - 64) style:UITableViewStyleGrouped];
    [self.settingTableView setDelegate:self];
    [self.settingTableView setDataSource:self];
    [self.settingTableView setShowsVerticalScrollIndicator:NO];
    [self.settingTableView setBackgroundColor:[UIColor clearColor]];
    UIView *nilView = [[UIView alloc] init];
    nilView.backgroundColor = [UIColor clearColor];
    [self.settingTableView setBackgroundView:nilView];
    [self.view addSubview:self.settingTableView];
}

#pragma mark - private method

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showReminderWithTitle:(NSString *)string
{
    self.m_DiskProgress = [[MBProgressHUD alloc] init];
    [self.settingTableView addSubview:self.m_DiskProgress];
    self.m_DiskProgress.mode = MBProgressHUDModeText;
    [self.m_DiskProgress show:YES];
    [self.m_DiskProgress setLabelText:string];
    self.m_DiskProgress.color = [UIColor grayColor];
    [self.m_DiskProgress hide:YES afterDelay:1.0f];
}

- (int)cacheSize
{
    int size = [[SDImageCache sharedImageCache] getSize];
    return size;
}

- (void)setCachSize:(id)object
{
    int cacheSize = [object intValue];
    UITableViewCell *cell = [self.settingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell)
    {
        UILabel *lab = (UILabel *)[cell viewWithTag:1010];
        if (lab)
        {
            NSString *str = [NSString storeString:cacheSize];
            lab.text = [NSString stringWithFormat:@" %@",str];
        }
    }
    
    self.imageCacheSize = cacheSize;
}

- (void)clearDisk
{
    [[SDImageCache sharedImageCache] clearDisk:^{
        [self.m_DiskProgress hide:NO];
        float cacheSize = [self cacheSize];
        self.imageCacheSize = cacheSize;
        self.s_dataSizeStr = [NSString storeString:cacheSize];
        [self.settingTableView reloadData];
        self.m_DiskProgress = nil;
    }];
}


-(void)unBandMethed
{
    if ([BBUser isBandFatherStatus])
    {
        if ([BBUser isCurrentUserBabyFather])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"解除绑定后，你不能再给准妈妈加孕气了！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = UNBAND_Tag;
            [alertView show];
        }
        else
        {
            BBInvitePapaViewController *invitePapa = [[BBInvitePapaViewController alloc] initWithNibName:@"BBInvitePapaViewController" bundle:nil];
            invitePapa.m_BindCode = @"00000000";
            invitePapa.m_BindStatus = YES;
            [self.navigationController pushViewController:invitePapa animated:YES];
            
        }
    }
    else
    {
        BBBandInfomation *bandInfo = [[BBBandInfomation alloc] initWithNibName:@"BBBandInfomation" bundle:nil];
        bandInfo.delegate = self;
        [self.navigationController pushViewController:bandInfo animated:YES];
    }
    
}


#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
        {
            return 2;
        }
        else
        {
            return 3;
        }
    }
    else if(section == 1)
    {
        return 2;
    }
    else if (section == 2)
    {
        return 3;
    }
    else if(section == 3)
    {
        return 6;
    }
    else
    {
        return 1;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingCellIdentifier = @"settingCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingCellIdentifier];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        [cell.textLabel setTextColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
//        [cell setBackgroundColor:[UIColor whiteColor]];
        
    }
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        UIView *testView = [[UIView alloc] init];
        testView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = testView;
        
        UILabel *lineLabel = [[UILabel alloc] init];
        UILabel *upLineLabel = [[UILabel alloc] init];
        if(indexPath.row > 0)
        {
            lineLabel.frame = CGRectMake(-10, 0, 320, 43.5);
            upLineLabel.frame = CGRectMake(16, 0.5, 304, 0.5);
        }
        else
        {
            lineLabel.frame = CGRectMake(-10, 0, 320, 44);
            upLineLabel.frame = CGRectMake(0, 0.5, 320, 0.5);
        }
        lineLabel.backgroundColor = [UIColor whiteColor];
        [testView addSubview:lineLabel];
        
        upLineLabel.backgroundColor = [UIColor colorWithHex:0xcccccc];
        [lineLabel addSubview:upLineLabel];
    }
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 100, 42)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentRight;
    lab.font = [UIFont systemFontOfSize:14.0];
    lab.tag = 1010;
    lab.textColor = [UIColor colorWithRed:119/255. green:119/255. blue:119/255. alpha:1];
    [cell.contentView addSubview:lab];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]];
    [cell.detailTextLabel setText:@""];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [cell.textLabel setText:@"我的状态"];
            // 需要根据我的状态显示不同的数据
            if([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
            {
                [cell.detailTextLabel setText:@"准备怀孕"];
            }
            else if([BBUser getNewUserRoleState] == BBUserRoleStatePregnant)
            {
                [cell.detailTextLabel setText:@"怀孕中"];
            }
            else
            {
                [cell.detailTextLabel setText:@"宝宝已出生"];
            }
        }
        else
        {
            if(indexPath.row == 1)
            {
                if([BBUser getNewUserRoleState] == BBUserRoleStatePregnant)
                {
                    [cell.textLabel setText:@"预产期"];
                    [cell.detailTextLabel setText:[BBPregnancyInfo pregancyDateByString]];
                }
                else if([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
                {
                    [cell.textLabel setText:@"宝宝生日"];
                    [cell.detailTextLabel setText:[BBPregnancyInfo pregancyDateByString]];
                }
                else
                {
                    if ([BBUser isBandFatherStatus])
                    {
                        [cell.textLabel setText:@"解除绑定"];
                    }
                    else
                    {
                        [cell.textLabel setText:@"邀请准爸爸"];
                    }
                }
            }
            else
            {
                if ([BBUser isBandFatherStatus])
                {
                    [cell.textLabel setText:@"解除绑定"];
                }
                else
                {
                    [cell.textLabel setText:@"邀请准爸爸"];
                }
            }
        }
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            [cell.textLabel setText:@"清除图片缓存"];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.detailTextLabel setText:self.s_dataSizeStr];
        }
        else
        {
            [cell.textLabel setText:@"新消息通知"];
            if([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone)
            {
                [cell.detailTextLabel setText:@"关闭"];
            }
            else
            {
                [cell.detailTextLabel setText:@"打开"];
            }
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            [cell.textLabel setText:@"访问宝宝树网站"];
            [cell.detailTextLabel setText:@"m.babytree.com"];
        }
        else if(indexPath.row == 1)
        {
            [cell.textLabel setText:@"宝宝树版规"];
        }
        else
        {
            [cell.textLabel setText:@"活动说明"];
        }
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            [cell.textLabel setText:@"分享给好友"];
        }
        else if (indexPath.row == 1)
        {
            [cell.textLabel setText:@"建议反馈"];
        }
        else if (indexPath.row == 2)
        {
            [cell.textLabel setText:@"给我评分"];
        }
        else if (indexPath.row == 3)
        {
            [cell.textLabel setText:@"版本更新"];
            if ([BBAppInfo needUpdateNewVersion])
            {
                [cell.detailTextLabel setText:@"new"];
                cell.detailTextLabel.textColor = [UIColor redColor];
            }
            else
            {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"已是最新版本 %@", [[[NSBundle mainBundle] infoDictionary] stringForKey:@"CFBundleShortVersionString"]]];
            }
        }
        else if(indexPath.row == 4)
        {
            [cell.textLabel setText:@"关于我们"];
        }
        else
        {
            [cell.textLabel setText:@"应用推荐"];
        }
    }
    else if (indexPath.section == 4)
    {
        if (indexPath.row == 0)
        {
            [cell.textLabel setText:@"第三方账号管理"];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4)
    {
        return 74;
    }
    else
    {
       if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
       {
         return 25;
       }
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        UIView *loginBg= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 74)];
        [loginBg setBackgroundColor:[UIColor clearColor]];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
        {
            UILabel *upLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -1, 320, 0.5)];
            upLineLabel.backgroundColor = [UIColor colorWithHex:0xcccccc];
            [loginBg addSubview:upLineLabel];
        }
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.exclusiveTouch = YES;
        [loginButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1.0]];
        [loginButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [loginButton.titleLabel setTextColor:[UIColor whiteColor]];
        [loginButton addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
        [loginButton setFrame:CGRectMake(10, 30, 300, 40)];
        if ([BBUser isLogin]) {
            [loginButton setTitle:@"退出登录" forState:UIControlStateNormal];
        } else {
            [loginButton setTitle:@"注册登录" forState:UIControlStateNormal];
        }
        [loginBg addSubview:loginButton];
        return loginBg;
    }
    else
    {
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
        {
            UIView *footView = [[UIView alloc] init];
            footView.backgroundColor = [UIColor clearColor];
            UILabel *upLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
            upLineLabel.backgroundColor = [UIColor colorWithHex:0xcccccc];
            [footView addSubview:upLineLabel];
            return footView;
        }
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        // 我的状态 怀孕-预产期 宝宝出生-生日
        if(indexPath.row == 0)
        {
            [MobClick event:@"setting_v2" label:@"我的状态"];
            BBUserStatusViewController *userStatusViewController = [[BBUserStatusViewController alloc] initWithNibName:@"BBUserStatusViewController" bundle:nil];
            [self.navigationController pushViewController:userStatusViewController animated:YES];
        }
        else
        {
            if(indexPath.row == 1)
            {
                if([BBUser getNewUserRoleState] == BBUserRoleStatePregnant)
                {
                    [MobClick event:@"setting_v2" label:@"预产期"];
                    BBDueDateViewController *dueDateContorller = [[BBDueDateViewController alloc] initWithNibName:@"BBDueDateViewController" bundle:nil];
                    [self.navigationController pushViewController:dueDateContorller animated:YES];
                }
                else if ([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
                {
                    [MobClick event:@"setting_v2" label:@"宝宝生日"];
                    // 宝宝生日设置页面
                    YBBDateSelect *babyDateViewController = [[YBBDateSelect alloc] init];
                    [self.navigationController pushViewController:babyDateViewController animated:YES];
                }
                else
                {
                    [MobClick event:@"setting_v2" label:@"邀请准爸爸"];
                    if ([BBUser isLogin])
                    {
                        [self unBandMethed];
                    }
                    else
                    {
                        BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
                        login.m_LoginType = BBPresentLogin;
                        login.delegate = self;
                        self.s_LoginType = LoginBandFather;
                        BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
                        [navCtrl setColorWithImageName:@"navigationBg"];
                        [self.navigationController  presentViewController:navCtrl animated:YES completion:^{
                            
                        }];
                        
                    }
                }
            }
            else
            {
                [MobClick event:@"setting_v2" label:@"邀请准爸爸"];
                if ([BBUser isLogin])
                {
                    [self unBandMethed];
                }
                else
                {
                    BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
                    login.m_LoginType = BBPresentLogin;
                    login.delegate = self;
                    self.s_LoginType = LoginBandFather;
                    BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
                    [navCtrl setColorWithImageName:@"navigationBg"];
                    [self.navigationController  presentViewController:navCtrl animated:YES completion:^{
                        
                    }];
                    
                }
            }
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            [MobClick event:@"setting_v2" label:@"清除图片缓存"];
            // 清除图片缓存
            if (self.imageCacheSize > 0)
            {
                [self showReminderWithTitle:@"√ 缓存已清除"];
                [self performSelector:@selector(clearDisk) withObject:nil afterDelay:0.5f];
            }
            else
            {
                [self showReminderWithTitle:@"√ 缓存已清除"];
            }
        }
        else
        {
            [MobClick event:@"setting_v2" label:@"新消息通知"];
            // 新消息通知
            BBNoticeSettingViewController *noticeSetViewController = [[BBNoticeSettingViewController alloc] init];
            [self.navigationController pushViewController:noticeSetViewController animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            [MobClick event:@"setting_v2" label:@"访问宝宝树网站"];
            // 访问宝宝树网站
            NSString *str = BABYTREE_IPHONE_ADDRESS;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
        else if (indexPath.row == 1)
        {
            [MobClick event:@"setting_v2" label:@"宝宝树版规"];
            // 快乐孕期版规  需要判断
            BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
            exteriorURL.isShowCloseButton = NO;
            [exteriorURL setLoadURL:@"http://m.babytree.com/rule/rule.php"];
            [exteriorURL setTitle:@"宝宝树版规"];
            [self.navigationController pushViewController:exteriorURL animated:YES];
        }
        else
        {
            [MobClick event:@"setting_v2" label:@"活动说明"];
            // 活动说明
            BBActivityRule *activityRule = [[BBActivityRule alloc] initWithNibName:@"BBActivityRule" bundle:nil];
            [self.navigationController pushViewController:activityRule animated:YES];
        }
    }
    else if (indexPath.section == 3)
    {
        if(indexPath.row == 0)
        {
            [MobClick event:@"setting_v2" label:@"分享给好友"];
            // 分享给好友
            BBShareMenu *menu = [[BBShareMenu alloc] initWithType:1 title:@"分享"];
            menu.delegate = self;
            if ([BBUser isLogin]) {
                NSString *url = [NSString stringWithFormat:@"http://m.babytree.com/download.php?a=preg&uid=%@",[BBUser getEncId]];
                NSString *encodeUrl = [url URLEncodeComponent];
                menu.qrUrl = [NSString stringWithFormat:@"%@/api/qrcode.php?url=%@&size=3",BABYTREE_URL_SERVER,encodeUrl];
            }
            [menu show];
        }
        else if(indexPath.row == 1)
        {
            [MobClick event:@"setting_v2" label:@"建议反馈"];
            // 建议反馈
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"意见反馈" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"账户被禁用反馈",@"Babybox反馈",@"建议反馈", nil];
            [actionSheet showInView:self.view];
        }
        else if(indexPath.row == 2)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=523063187"]];
        }
        else if(indexPath.row == 3)
        {
            [MobClick event:@"setting_v2" label:@"版本更新"];
            // 版本更新
            if ([BBAppInfo needUpdateNewVersion]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PREGNANCY_APPSTORE_DOWNLOADAPP_ADDRESS]];
            }else {
                [AlertUtil showAlert:nil withMessage:@"应用已经是最新版本"];
            }
        }
        else if(indexPath.row == 4)
        {
            [MobClick event:@"setting_v2" label:@"关于我们"];
            // 关于我们
            [BBStatisticsUtil setEvent:@"setup_about"];
            BBAbout *aboutController = [[BBAbout alloc] initWithNibName:@"BBAbout" bundle:nil];
            [aboutController setNavigationTitle:@"关于我们"];
            [self.navigationController pushViewController:aboutController animated:YES];
        }
        else
        {
            BBUmengRecommendApp *recommendApp = [[BBUmengRecommendApp alloc] initWithNibName:@"BBUmengRecommendApp" bundle:nil];
            [self.navigationController pushViewController:recommendApp animated:YES];
        }
    }
    else
    {
        [MobClick event:@"setting_v2" label:@"第三方账号管理"];
        // 第三方账号管理
        BBSnsAccountViewController *controller = [[BBSnsAccountViewController alloc] init];
        
        BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:controller];
        [navCtrl setColorWithImageName:@"navigationBg"];
        [self presentViewController:navCtrl animated:YES completion:^{

        }];

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - BBLogin Delegate
- (void)loginFinish
{
    if (self.s_LoginType == LoginSetPageCenter)
    {
        [self.settingTableView reloadData];
        if (self.m_delegate && [self.m_delegate respondsToSelector:@selector(modifyPresonalCenter)])
        {
            [self.m_delegate modifyPresonalCenter];
        }
    }
    else if(self.s_LoginType == LoginBandFather)
    {
        if ([BBUser isBandFatherStatus])
        {
            if ([BBUser isCurrentUserBabyFather])
            {
                [self.settingTableView reloadData];
            }
        }else
            [self unBandMethed];
    }
    else
    {
            [HMShowPage showBabyBoxFeedBackTopic:self];
    }
}



-(IBAction)loginClicked:(id)sender{
    
    if ([BBUser isLogin]) {
        [MobClick event:@"setting_v2" label:@"退出登录"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定要注销此用户" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag = kSettingLogoutAccountTag;
        [alert show];
    } else {
        [MobClick event:@"setting_v2" label:@"注册登录"];
        [BBStatisticsUtil setEvent:@"setup_registLogin"];
        BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
        login.m_LoginType = BBPresentLogin;
        login.delegate = self;
        self.s_LoginType = LoginSetPageCenter;
        BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
        [navCtrl setColorWithImageName:@"navigationBg"];
        [self.navigationController  presentViewController:navCtrl animated:YES completion:^{
            
        }];

    }
}


#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            UMFeedbackChat *feedbackCtl = [[UMFeedbackChat alloc]initWithNibName:@"UMFeedbackChat" bundle:nil];
            feedbackCtl.title = @"账户被禁用反馈";
            [self.navigationController pushViewController:feedbackCtl animated:YES];
            
        }
            
            break;
        case 1:
        {
            if([BBUser isLogin])
            {
                [HMShowPage showBabyBoxFeedBackTopic:self];
            }
            else
            {
                BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
                login.m_LoginType = BBPresentLogin;
                self.s_LoginType = LoginSetPage;
                BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
                [navCtrl setColorWithImageName:@"navigationBg"];
                login.delegate = self;
                [self.navigationController  presentViewController:navCtrl animated:YES completion:^{
                    
                }];
            }
        }
            
            break;
        case 2: {
            UMFeedbackChat *feedbackCtl = [[UMFeedbackChat alloc]initWithNibName:@"UMFeedbackChat" bundle:nil];
            feedbackCtl.title = @"建议反馈";
            [self.navigationController pushViewController:feedbackCtl animated:YES];
            
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == UNBAND_Tag)
    {
        if (buttonIndex ==1)
        {
            [self.settingProgress setLabelText:@"正在解绑"];
            [self.settingProgress show:YES];
            
            // 只要发送出去  解除绑定 没有委托处理
            [self.m_FatherUnbandRequest clearDelegatesAndCancel];
            self.m_FatherUnbandRequest = [BBFatherRequest unbindUser];
            [self.m_FatherUnbandRequest setDidFinishSelector:@selector(unbindUserFinished:)];
            [self.m_FatherUnbandRequest setDidFailSelector:@selector(unbindUserFailed:)];
            [self.m_FatherUnbandRequest setDelegate:self];
            [self.m_FatherUnbandRequest startAsynchronous];
        }
    }
    
    if (kSettingLogoutAccountTag == alertView.tag) {
        if (1 == buttonIndex) {
            [BBStatisticsUtil setEvent:@"setup_logout"];
            
            [BBUser logout];
            [self removeFileWithFileName:@"vaccineData.plist"];
            [self.settingTableView reloadData];
            [self modifyFinish:@"退出成功" withImageName:@"37x-Checkmark.png"];
            [BBPregnancyInfo setNotiCount:0];
            
            
            
            //删除第三方登陆的token
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQQ completion:^(UMSocialResponseEntity *response) {
            }];
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToWechatTimeline completion:^(UMSocialResponseEntity *response) {
            }];
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToWechatSession completion:^(UMSocialResponseEntity *response) {
            }];
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina completion:^(UMSocialResponseEntity *response) {
            }];
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToTencent completion:^(UMSocialResponseEntity *response) {
            }];
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQzone completion:^(UMSocialResponseEntity *response) {
            }];
            
            [BBRemotePushInfo setIsRegisterPushToBabytree:YES];
            BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate updatePushToken];
            if (self.m_delegate && [self.m_delegate respondsToSelector:@selector(modifyPresonalCenter)])
            {
                [self.m_delegate modifyPresonalCenter];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];
        }
    } else if (kCheckUpdateTag == alertView.tag) {
        if (1 == buttonIndex) {
            NSString *downString = PREGNANCY_APPSTORE_DOWNLOADAPP_ADDRESS;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downString]];
        }
    }
}

#pragma mark - bindDelegate
- (void)unbindUserFinished:(ASIFormDataRequest *)request
{
    if (self.settingProgress.isShow)
    {
        [self.settingProgress hide:YES];
    }
    
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *unBindData = [parser objectWithString:responseString error:&error];
    
    if (error)
    {
        [self modifyFinish:@"对不起，解绑出错" withImageName:@"xxx"];
        return;
    }
    
    if ([[unBindData stringForKey:@"status"] isEqualToString:@"success"] || [[unBindData stringForKey:@"status"] isEqualToString:@"father_edition_no_bind"])
    {
        [MobClick event:@"invite_husband_v2" label:@"准爸爸成功解除绑定数"];
        [BBUser setBandFatherStatus:NO];
        [BBUser setCurrentUserBabyFather:NO];
        [self modifyFinish:@"解除绑定成功" withImageName:@"37x-Checkmark.png"];
        [self.settingTableView reloadData];
    }
    else
    {
        [self modifyFinish:@"对不起，解绑出错" withImageName:@"xxx"];
    }
}

- (void)unbindUserFailed:(ASIFormDataRequest *)request
{
    if (self.settingProgress.isShow)
    {
        [self.settingProgress hide:YES];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}



- (void)modifyFinish:(NSString *)showContent withImageName:(NSString*)imageName
{
    [self.settingProgress setLabelText:showContent];
    self.settingProgress.animationType = MBProgressHUDAnimationFade;
    self.settingProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    self.settingProgress.mode = MBProgressHUDModeCustomView;
    [self.settingProgress show:YES];
    [self.settingProgress hide:YES afterDelay:1.5];
}

-(void)closeBandInfomationView
{
    [self modifyFinish:@"绑定成功" withImageName:@"37x-Checkmark.png"];
}

-(void)removeFileWithFileName:(NSString *)theFileName
{
    NSString *sandboxFilePath = getDocumentsDirectoryWithFileName(theFileName);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:sandboxFilePath])
    {
        [fileManager removeItemAtPath:sandboxFilePath error:nil];
    }
}

#pragma mark -
#pragma mark ShareMenuDelegate
- (void)shareMenu:(BBShareMenu *)shareMenu clickItem:(BBShareMenuItem *)item
{
    NSString *shareText = [NSString stringWithFormat:@"千万准妈妈每天都会使用的孕期APP。如今，她焕然一新，她变的更美丽更懂你更爱你，轻轻点击下载，孕期280天有她来守护你"];
    UIImage *originImage = [UIImage imageNamed:@"Icon-72@2x.png"];
    [BBShareContent shareContent:item withViewController:self withShareText:shareText withShareOriginImage:originImage withShareWXTimelineTitle:@"生娃养娃，我这段时间就靠她了！" withShareWXTimelineDescription:@"" withShareWXSessionTitle:@"生娃养娃，我这段时间就靠她了！" withShareWXSessionDescription:shareText withShareWebPageUrl:[NSString stringWithFormat:@"%@",SHARE_DOWNLOAD_URL]];
}
@end
