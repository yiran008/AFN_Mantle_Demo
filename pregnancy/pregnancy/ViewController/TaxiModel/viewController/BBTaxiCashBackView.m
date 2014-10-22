//
//  BBTaxiCashBackView.m
//  pregnancy
//
//  Created by whl on 13-12-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBTaxiCashBackView.h"

@interface BBTaxiCashBackView ()

@end

@implementation BBTaxiCashBackView
- (void)dealloc
{
    [_cashBackLable release];
    [_cashBackString release];
    [_cashBackView release];
    [super dealloc];
}

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
    [self.navigationItem setTitle:@"返现成功"];
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
    
    self.cashBackLable.text = [NSString stringWithFormat:@"真棒～你刚刚获赠打车返现%@元!",self.cashBackString];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)share:(id)sender
{
    BBShareMenu *menu = [[[BBShareMenu alloc] initWithType:0 title:@"分享"] autorelease];
    menu.delegate = self;
    [menu show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark ShareMenuDelegate
- (void)shareMenu:(BBShareMenu *)shareMenu clickItem:(BBShareMenuItem *)item {
    NSString *shareText = @"";
    UIImage *image = [self getShareImage];
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
    if (item.indexAtMenu == 0) {
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:smallImage];
        
        WXImageObject *imageObject = [WXImageObject object];
        imageObject.imageData = UIImageJPEGRepresentation(image,0.8);
        message.mediaObject = imageObject;
        message.title = @"";
        message.description  = shareText;
        
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        [WXApi sendReq:req];
        return;
        
    }else if(item.indexAtMenu == 1) {
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:smallImage];
        
        WXImageObject *imageObject = [WXImageObject object];
        imageObject.imageData = UIImageJPEGRepresentation(image,0.8);
        message.mediaObject = imageObject;
        message.title = shareText;
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
        [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"%@ （分享自@宝宝树孕育）",shareText];
    }else if(item.indexAtMenu == 3) {
        [MobClick event:@"share_v2" label:@"QQ空间图标点击"];
        snsType = UMShareToQzone;
        [UMSocialData defaultData].extConfig.qzoneData.title = @"贴心打车服务，准妈妈们出行零烦忧";
        [UMSocialData defaultData].extConfig.qzoneData.url = [NSString stringWithFormat:@"http://m.babytree.com/"];
        [UMSocialData defaultData].shareImage = [BBImageScale imageScalingToSmallSize:image];
    }else if(item.indexAtMenu == 4) {
        [MobClick event:@"share_v2" label:@"腾讯微博图标点击"];
        snsType = UMShareToTencent;
        [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"%@ （分享自@宝宝树孕育）",shareText];
    }
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsType];
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
}


- (UIImage *)getShareImage
{
    CGFloat originViewheight = self.cashBackView.frame.size.height;
    
    UIImageView *imageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"taxicashbackhare"]]autorelease];
    [imageView setFrame:CGRectMake(1, originViewheight, 290, 44)];
    
    [self.cashBackView setFrame:CGRectMake(self.cashBackView.frame.origin.x, self.cashBackView.frame.origin.y, self.cashBackView.frame.size.width, self.cashBackView.frame.size.height+imageView.frame.size.height)];
    [self.cashBackView addSubview:imageView];
    
    CGFloat height = self.cashBackView.frame.size.height;
    //支持retina高分的关键
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.cashBackView.bounds.size.width, height), NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(CGSizeMake(self.cashBackView.bounds.size.width, height));
    }
    //获取图像
    [self.cashBackView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.cashBackView setFrame:CGRectMake(self.cashBackView.frame.origin.x, self.cashBackView.frame.origin.y, self.cashBackView.frame.size.width,originViewheight)];
    [imageView setImage:nil];
    return image;
}

@end
