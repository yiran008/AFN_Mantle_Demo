//
//  BBNoticeSettingViewController.m
//  pregnancy
//
//  Created by MacBook on 14-4-11.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBNoticeSettingViewController.h"

@interface BBNoticeSettingViewController ()

// 新消息设置
@property (nonatomic, strong) UITableView *s_noticeTableView;

@end

@implementation BBNoticeSettingViewController

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
    
    self.s_noticeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-44) style:UITableViewStylePlain];
    self.s_noticeTableView.dataSource = self;
    self.s_noticeTableView.delegate = self;
    self.s_noticeTableView.bounces = NO;
    [self.s_noticeTableView setBackgroundColor:[UIColor whiteColor]];
    self.s_noticeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UIView *nilView = [[UIView alloc] init];
    [self.s_noticeTableView setBackgroundView:nilView];
    [self.view addSubview:self.s_noticeTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - create UI
- (void)addNavigationItem
{
    [self.navigationItem setTitle:@"新消息通知"];
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

#pragma mark - private method

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)noticeSwitch:(id)sender
{
    UISwitch *notice = (UISwitch*)sender;
    if (notice.isOn) {
        // 请求API设定
        
    }else {
       
    }

}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.detailTextLabel setTextColor:[UIColor colorWithHex:0xaaaaaa]];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [cell.textLabel setTextColor:[UIColor colorWithHex:0x666666]];
        
        UIColor *lightColor = [UIColor colorWithHex:0xcccccc];
        [cell.layer setBorderColor:lightColor.CGColor];
        [cell.layer setBorderWidth:0.5];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.text = @"";

    
    if(indexPath.section == 0)
    {
        [cell.textLabel setText:@"接收新消息通知"];
        NSLog(@"%d",[[UIApplication sharedApplication] enabledRemoteNotificationTypes]);
        if([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone)
        {
            [cell.detailTextLabel setText:@"已关闭"];
        }
        else
        {
            [cell.detailTextLabel setText:@"已开启"];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 30;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        return DEVICE_HEIGHT-24-30-80;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [headView setBackgroundColor:UI_VIEW_BGCOLOR];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    [footView setBackgroundColor:UI_VIEW_BGCOLOR];
    if(section == 0)
    {
        UILabel *useLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
        useLabel.text = @"如果想关闭或开启宝宝树孕育的新消息通知，请在iPhone的“设置”—“通知”功能中，找到应用程序“宝宝树孕育”进行更改";
        [useLabel setBackgroundColor:[UIColor clearColor]];
        [useLabel setFont:[UIFont systemFontOfSize:14]];
        [useLabel setTextColor:[UIColor colorWithHex:0xaaaaaa]];
        useLabel.numberOfLines = 0;
        [useLabel setTextAlignment:NSTextAlignmentLeft];
        [footView addSubview:useLabel];
    }
    return footView;
}



@end
