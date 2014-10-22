//
//  BBKuaidiPersonalViewController.m
//  pregnancy
//
//  Created by MAYmac on 13-12-12.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBKuaidiPersonalViewController.h"
#import "BBKuaidiVerificationViewController.h"
#import "BBCallTaxiRequest.h"
#import "BBKuaidiRecordViewController.h"
#import "BBKuaidiVerificationViewController.h"
#import "BBKuaidiAlipayAccountViewController.h"
#import "BBTaxiLocationData.h"
#import "BBTaxiActivityRule.h"
#import "UMSocialQQHandler.h"


@interface BBKuaidiPersonalViewController ()<ShareMenuDelegate,alipayAccountModifySuccessDelegate>
{
    
}
@property(nonatomic,retain)ASIFormDataRequest * personalRequest;
@property(nonatomic,retain)IBOutlet UIView * recordsView;
@property(nonatomic,retain)IBOutlet UIView * shareView;
@property(nonatomic,retain)IBOutlet UIButton * goVerificationButton;
@property(nonatomic,retain)IBOutlet UIView * alipayView;
@property(nonatomic,retain)NSString * alipayStr;
@property(nonatomic,assign)BOOL isApply;
@property(nonatomic,retain)MBProgressHUD * progressBar;
@property(nonatomic,retain)NSString * html;
@property(nonatomic,retain)NSString * status;

@end

@implementation BBKuaidiPersonalViewController

-(void)dealloc
{
    [_personalRequest clearDelegatesAndCancel];
    [_personalRequest release];
    [_html release];
    [_status release];
    [_alipayView release];
    [_recordsView release];
    [_shareView release];
    [_goVerificationButton release];
    [_alipayStr release];
    [_progressBar release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startFetchPersonalRequest];
    
    [self.navigationItem setTitle:@"更多"];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    self.progressBar = [[[MBProgressHUD alloc]initWithView:self.view]autorelease];
    [self.view addSubview:self.progressBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)startFetchPersonalRequest
{
    NSString * lat = [BBTaxiLocationData getCurrentLatitudeString];
    NSString * lng = [BBTaxiLocationData getCurrentLongitudeString];
    if (lat && lng)
    {
        [self.personalRequest clearDelegatesAndCancel];
        self.personalRequest = [BBCallTaxiRequest fetchKuaidiPersonalWithLat:lat lng:lng];
        [self.personalRequest setDidFinishSelector:@selector(requestFinishedWithPersonal:)];
        [self.personalRequest setDidFailSelector:@selector(requestFailedWithPersonal:)];
        [self.personalRequest setDelegate:self];
        [self.personalRequest startAsynchronous];
        
        self.progressBar.labelText = @"正在加载";
        [self.progressBar show:YES];

    }else
    {
        
    }
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goVerification:(id)sender
{
    [MobClick event:@"taxi_v2" label:@"更多-banner点击"];
    if (self.html)
    {
        NSString *st = nil;
        if (!self.isApply)
        {
            st = @"false";
        }else{
            st = self.status;
        }
        
        BBTaxiActivityRule *activityRule = [[[BBTaxiActivityRule alloc]initWithNibName:@"BBTaxiActivityRule" bundle:nil]autorelease];
        activityRule.contentHtml = self.html;
        activityRule.rightStatus = st;
        [self.navigationController pushViewController:activityRule animated:YES];
    }

}

- (IBAction)goAlipayAccount:(id)sender
{
    [MobClick event:@"taxi_v2" label:@"更多-支付宝账号点击"];
    BBKuaidiAlipayAccountViewController * kav = [[BBKuaidiAlipayAccountViewController alloc]init];
    kav.alipayAccount = self.alipayStr;
    kav.delegate = self;
    [self.navigationController pushViewController:kav animated:YES];
    [kav release];
}

- (IBAction)goKuaidiRecords:(id)sender
{
    [MobClick event:@"taxi_v2" label:@"更多-打车记录点击"];
    BBKuaidiRecordViewController * krv = [[BBKuaidiRecordViewController alloc]init];
    [self.navigationController pushViewController:krv animated:YES];
    [krv release];
}

- (IBAction)telFriends:(id)sender
{
    [MobClick event:@"taxi_v2" label:@"更多-告诉朋友点击"];
    BBShareMenu *menu = [[[BBShareMenu alloc] initWithType:0 title:@"分享"] autorelease];
    menu.delegate = self;
    [menu show];
}

#pragma mark- httpMethod
- (void)requestFinishedWithPersonal:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser * parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[jsonDictionary stringForKey:@"status"] isEqualToString:@"success"])
    {
        NSDictionary * data = [jsonDictionary dictionaryForKey:@"data"];
        NSString * url = [data stringForKey:@"banner"];
        
        self.recordsView.center = CGPointMake(self.recordsView.center.x, self.recordsView.center.y + 134);
        self.shareView.center = CGPointMake(self.shareView.center.x, self.shareView.center.y + 134);
        
        if (url)
        {
            [self.goVerificationButton setImageWithURL:[NSURL URLWithString:url]];
            self.goVerificationButton.hidden = NO;
        }else
        {
            self.goVerificationButton.hidden = YES;
            self.alipayView.center = CGPointMake(self.alipayView.center.x, self.alipayView.center.y - 78);
            self.recordsView.center = CGPointMake(self.recordsView.center.x, self.recordsView.center.y - 78);
            self.shareView.center = CGPointMake(self.shareView.center.x, self.shareView.center.y - 78);

        }
        NSString * alipayAccount = [data stringForKey:@"alipay_account"];
        if (!alipayAccount || alipayAccount.length == 0)
        {
            self.recordsView.center = CGPointMake(self.recordsView.center.x, self.recordsView.center.y - 67);
            self.shareView.center = CGPointMake(self.shareView.center.x, self.shareView.center.y - 67);
        }else
        {
            self.alipayView.hidden = NO;
        }
        
        self.alipayStr = [data stringForKey:@"alipay_account"];
        self.isApply = [[data stringForKey:@"is_apply"]isEqualToString:@"true"];
        self.html = [data stringForKey:@"html"];
        self.status = [data stringForKey:@"status"];
    }
    [self.progressBar hide:YES];
}

- (void)requestFailedWithPersonal:(ASIFormDataRequest *)request
{
    [self.progressBar hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

#pragma mark - alipyModified
- (void)alipayAccountModifySuccessed:(NSString *)account
{
    self.alipayStr = account;
}

#pragma mark -
#pragma mark ShareMenuDelegate
- (void)shareMenu:(BBShareMenu *)shareMenu clickItem:(BBShareMenuItem *)item {
    
    NSString *shareText = [NSString stringWithFormat:@"贴心打车服务，准妈妈们出行零烦忧%@",SHARE_DOWNLOAD_URL];
    
    UIImage *image = [UIImage imageNamed:@"Icon-72@2x"];
    UIImage *smallImage = [BBImageScale imageScalingToSmallSize:image];
    
    if(item.indexAtMenu == 0 || item.indexAtMenu == 1)
    {
        if(item.indexAtMenu == 0)
        {
            [MobClick event:@"share_v2" label:@"朋友圈图标点击"];
        }
        else
        {
            [MobClick event:@"share_v2" label:@"微信图标点击"];
        }
        if(![WXApi isWXAppInstalled])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备没有安装微信" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
    }
    
    if (item.indexAtMenu == 0)
    {
        WXWebpageObject *webPage= [[[WXWebpageObject alloc] init] autorelease];
        webPage.webpageUrl = [NSString stringWithFormat:@"%@",@"http://m.babytree.com/app/"];
        
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:smallImage];
        message.mediaObject = webPage;
        
        message.title = @"贴心打车服务，准妈妈们出行零烦忧";
        message.description  = shareText;
        
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        [WXApi sendReq:req];
        return;
        
    }else if(item.indexAtMenu == 1)
    {
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:smallImage];
        
        WXWebpageObject *webPage= [[[WXWebpageObject alloc] init] autorelease];
        webPage.webpageUrl = [NSString stringWithFormat:@"%@",@"http://m.babytree.com/app/"];
        
        message.mediaObject = webPage;
        
        message.title = @"宝宝树孕育";
        message.description  = shareText;
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
        return;
    }
    [UMSocialData defaultData].shareText = shareText;
    [UMSocialData defaultData].shareImage = image;
    
    NSString *snsType = UMShareToSina;
    
    if(item.indexAtMenu == 2) {
        [MobClick event:@"share_v2" label:@"新浪微博图标点击"];
        snsType = UMShareToSina;
        [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"%@（分享自@宝宝树孕育）",shareText];
    }else if(item.indexAtMenu == 3) {
        [MobClick event:@"share_v2" label:@"QQ空间图标点击"];
        snsType = UMShareToQzone;
        [UMSocialData defaultData].extConfig.qzoneData.url = SHARE_DOWNLOAD_URL;
        [UMSocialData defaultData].extConfig.qzoneData.title = shareText;
    }else if(item.indexAtMenu == 4) {
        [MobClick event:@"share_v2" label:@"腾讯微博图标点击"];
        snsType = UMShareToTencent;
        [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"%@（分享自@宝宝树孕育）",shareText];
    }
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsType];
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}

@end
