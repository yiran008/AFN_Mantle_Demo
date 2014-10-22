//
//  BBWeiLoginShare.m
//  pregnancy
//
//  Created by babytree babytree on 12-11-7.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBWeiLoginShare.h"
#import "BBNavigationLabel.h"
#import "BBApp.h"
#import "BBAppConfig.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "BBAppDelegate.h"
@interface BBWeiLoginShare ()

@end

@implementation BBWeiLoginShare
@synthesize selectBtn;
@synthesize delegate;
@synthesize weiboState;
@synthesize bg;
@synthesize shareTitleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        weiboState = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.followWeiBoButton setHidden:YES];
    [self.followWeiboLabel setHidden:YES];
    self.followWeiBoButton.exclusiveTouch = YES;
    self.selectBtn.exclusiveTouch = YES;
    if (weiboState==1){
        self.navigationItem.title = @"分享到新浪微博";
        [self.followWeiBoButton setHidden:NO];
        [self.followWeiboLabel setHidden:NO];
    }else{
        self.navigationItem.title = @"分享到QQ空间";
    }
    [shareTitleLabel setText:self.navigationItem.title];

    NSString *str =  ([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby) ?  @"weibo_yuer" : @"weibo_yunqi";
    [self.bg setImage:[UIImage imageNamed:IPHONE5_IMAGE_NAME(str)]];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager startUpdatingLocation];
    [self.navigationItem setHidesBackButton:YES];

    IPHONE5_ADAPTATION
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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


- (IBAction)startUseAction:(id)sender
{
    NSString *str = @"宝宝树孕育";
    if (weiboState==1) {
        CLLocation *location = _locationManager.location;
        if (self.followWeiBoButton.tag == 2) {
            BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate follow];
        }
        if (selectBtn.tag==2) {
            NSString *shareContent =[NSString stringWithFormat:@"孕期40周全程呵护！我正在使用“宝宝树孕育”免费手机应用，孕期知识、温馨提醒、孕妈交流，还可以跟准爸爸互动，是年轻父母必备神器！下载地址：%@（分享自@%@）",str,SHARE_DOWNLOAD_URL];
            [[UMSocialControllerService defaultControllerService].socialDataService postSNSWithTypes:[NSArray arrayWithObject:UMShareToSina] content:shareContent image:nil location:location urlResource:nil completion:^(UMSocialResponseEntity *response) {
            }];
        }
    }else if(weiboState==2&&selectBtn.tag==2) {
        CLLocation *location = _locationManager.location;
        NSString *shareContent = [NSString stringWithFormat:@"孕期40周全程呵护！我正在使用“宝宝树孕育”免费手机应用，孕期知识、温馨提醒、孕妈交流，还可以跟准爸爸互动，是年轻父母必备神器！下载地址：%@（分享自%@）",str,SHARE_DOWNLOAD_URL];
        [[UMSocialControllerService defaultControllerService].socialDataService postSNSWithTypes:[NSArray arrayWithObject:UMShareToQzone] content:shareContent image:nil location:location urlResource:nil completion:^(UMSocialResponseEntity *response) {
        }];
    }
    

    [self.navigationController popViewControllerAnimated:NO];
    [delegate weiLoginShareFinish];
}
- (IBAction)selectState:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag==1) {
        btn.tag=2;
        [btn setImage:[UIImage imageNamed:@"weibo_select"] forState:UIControlStateNormal];
    }else if(btn.tag==2){
        btn.tag=1;
        [btn setImage:[UIImage imageNamed:@"weibo_no_select"] forState:UIControlStateNormal];
    }
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
    [delegate weiLoginShareFinish];
}
- (IBAction)clickedCancelFollow:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag==1) {
        btn.tag=2;
        [btn setImage:[UIImage imageNamed:@"weibo_select"] forState:UIControlStateNormal];
    }else if(btn.tag==2){
        btn.tag=1;
        [btn setImage:[UIImage imageNamed:@"weibo_no_select"] forState:UIControlStateNormal];
    }
}
@end
