//
//  HMStartImageViewController.m
//  lama
//
//  Created by mac on 13-11-20.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMStartImageViewController.h"
#import "BBAdRequest.h"
#import "BBAdPVManager.h"

#define START_IMAGE_KEY (@"startImageKey")

#define StartImageMaxShowTime 4.0f

@interface HMStartImageViewController ()<SDWebImageManagerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *s_ImageView;
@property (nonatomic, strong) UIControl *s_Control;
@property (nonatomic, strong) ASIFormDataRequest *s_GetStartImageRequest;
@end

@implementation HMStartImageViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [_s_GetStartImageRequest clearDelegatesAndCancel];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
    
    self.s_ImageView.userInteractionEnabled = YES;
    self.s_ImageView.height = UI_SCREEN_HEIGHT;
    
    self.s_Control = [[UIControl alloc] initWithFrame:self.s_ImageView.bounds];
    [self.s_ImageView addSubview:self.s_Control];
    self.s_Control.userInteractionEnabled = YES;
    [self.s_Control addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
    [self showStartImage];
    
    [self getNewStartImageData];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(closeView) withObject:nil afterDelay:StartImageMaxShowTime];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //[[SDWebImageManager sharedManager]cancelForDelegate:self];
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)showStartImage
{
    NSDictionary *adDict = [[NSUserDefaults standardUserDefaults]dictionaryForKey:START_IMAGE_KEY];
    
    NSString *imageUrl = nil;
    if (IS_IPHONE5)
    {
        imageUrl = [adDict stringForKey:AD_DICT_LONG_IMG_KEY];
    }
    else
    {
        imageUrl = [adDict stringForKey:AD_DICT_NORMAL_IMG_KEY];
    }
    
    UIImage *cachedStartImage = [self cachedStartImageOfUrl:imageUrl];
    
    if (cachedStartImage == nil)
    {
        if (IS_IPHONE5)
        {
            self.s_ImageView.image = [UIImage imageNamed:@"Default-568h"];
        }
        else
        {
            self.s_ImageView.image = [UIImage imageNamed:@"Default"];
        }
    }
    else
    {
        [self.s_ImageView setImage:cachedStartImage];
        [[BBAdPVManager sharedInstance]addLocalPVForAd:adDict];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideStatusBar) object:nil];
    [self performSelector:@selector(hideStatusBar) withObject:nil afterDelay:0.5f];
}

- (void)hideStatusBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)closeView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideStatusBar) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(closeView) object:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"statusBarRefresh" object:nil userInfo:nil];
    [self  dismissViewControllerAnimated:NO completion:^{
    }];
}

#pragma mark- 图片相关查询

-(UIImage*)cachedStartImageOfUrl:(NSString*)imageUrl
{
    if (imageUrl == nil)
    {
        return nil;
    }
    
    NSString *imageFilePath = [[SDWebImageManager sharedManager] getCachePathForKey:imageUrl];
    return [UIImage imageWithContentsOfFile:imageFilePath];
}

#pragma mark- 获取开机图url
-(void)getNewStartImageData
{
    [_s_GetStartImageRequest clearDelegatesAndCancel];
    _s_GetStartImageRequest = [BBAdRequest getAdRequestForZoneType:AdZoneTypeStartImage];
    [_s_GetStartImageRequest setDidFinishSelector:@selector(getNewStartImageDataFinished:)];
    [_s_GetStartImageRequest setDidFailSelector:@selector(getNewStartImageDataFailed:)];
    [_s_GetStartImageRequest setDelegate:self];
    [_s_GetStartImageRequest startAsynchronous];
}

- (void)getNewStartImageDataFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *responseDict = [parser objectWithString:responseString];
    
    NSString *status = [responseDict stringForKey:@"status"];
    if ([status isEqualToString:@"success"])
    {
        NSDictionary *dataDict = [responseDict dictionaryForKey:@"data"];
        
        if ([dataDict isDictionaryAndNotEmpty])
        {
            NSDictionary *adDict = [dataDict dictionaryForKey:@"ad"];
            
            if ([adDict isDictionaryAndNotEmpty])
            {
                NSString *imageUrl;
                if (IS_IPHONE5)
                {
                    imageUrl = [adDict stringForKey:AD_DICT_LONG_IMG_KEY];
                }
                else
                {
                    imageUrl = [adDict stringForKey:AD_DICT_NORMAL_IMG_KEY];
                }
                UIImage *cachedStartImage = [self cachedStartImageOfUrl:imageUrl];
                
                if (!cachedStartImage)
                {
                    [self downloadImage:imageUrl];
                }
                
                [[NSUserDefaults standardUserDefaults]safeSetContainer:adDict forKey:START_IMAGE_KEY];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:START_IMAGE_KEY];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }
    }
}

- (void)getNewStartImageDataFailed:(ASIFormDataRequest *)request
{
}


#pragma mark- 下载开机图

-(void)downloadImage:(NSString*)imageUrl
{
    if (imageUrl == nil)
    {
        return;
    }
    
    [[SDWebImageManager sharedManager]downloadWithURL:[NSURL URLWithString:imageUrl] delegate:self options:SDWebImageRetryFailed];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url
{
    
}

@end
