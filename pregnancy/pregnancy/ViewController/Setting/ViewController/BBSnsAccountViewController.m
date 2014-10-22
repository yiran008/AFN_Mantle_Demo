//
//  BBSnsAccountViewController.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-12-25.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBSnsAccountViewController.h"
#import "BBApp.h"
#import "BBNavigationLabel.h"
@interface BBSnsAccountViewController ()

@property (nonatomic, retain) UITableView           *snsTableView;
@property (nonatomic, retain) UISwitch              *changeSwitcher;
@end

@implementation BBSnsAccountViewController

- (void)dealloc
{
    [_snsTableView release];
    [_changeSwitcher release];
    [UMSocialControllerService defaultControllerService].socialUIDelegate = nil;

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    IOS6_RELEASE_VIEW;
}

- (void)viewDidUnloadBabytree
{
    self.snsTableView = nil;
    self.changeSwitcher = nil;
}

- (void)viewDidUnload
{
    [self viewDidUnloadBabytree];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBColor(239, 239, 244, 1);
    [self setNavBar];
    [self addSnsTableView];
}

- (void)setNavBar
{
    self.navigationItem.title = @"账号管理";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    [self addBackButton];
}

- (void)addBackButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];


}

- (void)addSnsTableView
{
    self.snsTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 20 - 44) style:UITableViewStylePlain] autorelease];
    self.snsTableView.delegate = self;
    self.snsTableView.dataSource = self;
    self.snsTableView.backgroundColor = [UIColor clearColor];
    self.snsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.snsTableView.separatorColor = RGBColor(209, 209, 209, 1);
    [self setExtraCellLineHidden:self.snsTableView];
    [self.view addSubview:self.snsTableView];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}

#pragma mark - UITableViewDataSource
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
    static NSString *UMSnsAccountCellIdentifier = @"UMSnsAccountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UMSnsAccountCellIdentifier];
    
    NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:[UMSocialSnsPlatformManager getSnsPlatformStringFromIndex:indexPath.row]];
    
    UMSocialAccountEntity *accountEnitity = [snsAccountDic valueForKey:snsPlatform.platformName];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:UMSnsAccountCellIdentifier] autorelease];
    }
    
    UISwitch *oauthSwitch = nil;
    if ([cell viewWithTag:snsPlatform.shareToType]) {
        oauthSwitch = (UISwitch *)[cell viewWithTag:snsPlatform.shareToType];
    }
    else{
        oauthSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 10, 40, 20)];
        
        oauthSwitch.tag = snsPlatform.shareToType;
        [cell addSubview:oauthSwitch];
    }
    oauthSwitch.center = CGPointMake(_snsTableView.bounds.size.width - 40, oauthSwitch.center.y);
    
    [oauthSwitch addTarget:self action:@selector(onSwitchOauth:) forControlEvents:UIControlEventValueChanged];
    
    NSString *showUserName = nil;
    
    //这里判断是否授权
    if ([UMSocialAccountManager isOauthWithPlatform:snsPlatform.platformName]) {
        [oauthSwitch setOn:YES];
        //这里获取到每个授权账户的昵称
        showUserName = accountEnitity.userName;
    }
    else {
        [oauthSwitch setOn:NO];
        showUserName = [NSString stringWithFormat:@"尚未授权"];
    }
    
    if ([showUserName isEqualToString:@""]) {
        cell.textLabel.text = @"已授权";
    }
    else{
        cell.textLabel.text = showUserName;
    }
    
    cell.imageView.image = [UIImage imageNamed:snsPlatform.smallImageName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)onSwitchOauth:(UISwitch *)switcher
{
    self.changeSwitcher = switcher;
    
    if (switcher.isOn == YES) {
        [switcher setOn:NO];
        
        //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
        NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:switcher.tag];
        
        
        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            NSLog(@"login response is %@",response);
            //          获取微博用户名、uid、token等
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
                NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
            }
            //这里可以获取到腾讯微博openid,Qzone的token等
            /*
             if ([platformName isEqualToString:UMShareToTencent]) {
             [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToTencent completion:^(UMSocialResponseEntity *respose){
             NSLog(@"get openid  response is %@",respose);
             }];
             }
             */
            
            [_snsTableView reloadData];
        });
        
    }
    else {
        UIActionSheet *unOauthActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"解除授权", nil];
        unOauthActionSheet.destructiveButtonIndex = 0;
        unOauthActionSheet.tag = switcher.tag;
        [unOauthActionSheet showInView:self.view];
    }
}

#pragma UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *platformType = [UMSocialSnsPlatformManager getSnsPlatformString:actionSheet.tag];
        
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:platformType completion:^(UMSocialResponseEntity *response) {
            NSLog(@"unOauth response is %@",response);
            [_snsTableView reloadData];
        }];
    }
    else {//按取消
        [self.changeSwitcher setOn:YES animated:YES];
    }
}

- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
