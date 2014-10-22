//
//  PicReviewView.m
//  pregnancy
//
//  Created by mac on 13-5-15.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "PicReviewView.h"
#import <ImageIO/ImageIO.h>
#import "NSData+GIF.h"

#import "BBCacheData.h"
#import "BBImageScale.h"
#import "MobClick.h"
#import "WXApi.h"
#import "UMSocial.h"
#import "BBAppDelegate.h"

/*
 CGRect rect = [image convertRect:image.bounds toView:appdelegate.window];
 
 PicReviewView *pView = [[[PicReviewView alloc] initWithRect:rect placeholderImage:image.image] autorelease];
 
 [pView loadUrl:[NSURL URLWithString:photoUrl]];
 
 [appdelegate.window addSubview:pView];
 */

@implementation PicReviewView
@synthesize m_OriginalRect;
@synthesize m_Placeholder;
@synthesize m_ImageView;
@synthesize m_ImageURL;
@synthesize progressHUD;
@synthesize m_ScrollView;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideStatusBar) object:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager cancelForDelegate:self];
    
    [m_Placeholder release];
    [m_ImageView release];
    [m_ImageURL release];
    [m_ScrollView release];
    
    if (progressHUD.isShow)
    {
        [progressHUD hide:NO];
    }
    [progressHUD release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.shareTypeMark = BBShareTypeCommunicate; 
        //babyMenu
    }
    return self;
}

- (id)initWithRect:(CGRect)rect placeholderImage:(UIImage *)placeholder
{
    self = [super initWithFrame:UI_WHOLE_SCREEN_FRAME];
    
    if (self) {
        isCanCloseSelf = YES;
        self.frame = UI_WHOLE_SCREEN_FRAME;
        self.backgroundColor = [UIColor blackColor];
        self.shareTypeMark = BBShareTypeCommunicate;
        // Initialization code
        m_OriginalRect = rect;
        self.m_Placeholder = placeholder;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:[UIApplication sharedApplication]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:[UIApplication sharedApplication]];
    }
    
    return self;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //NSLog(@"=======applicationDidEnterBackground========");
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //NSLog(@"=======applicationWillEnterForeground========");
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideStatusBar) object:nil];
    [self performSelector:@selector(hideStatusBar) withObject:nil afterDelay:0.5];
}

- (void)hideStatusBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)loadUrl:(NSURL *)url
{    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.superview.userInteractionEnabled = NO;
    
    self.m_ImageURL = url;
    
    if (m_ImageView == nil)
    {
        self.m_ImageView = [[[UIImageView alloc] init] autorelease];
    }
    m_ImageView.frame = m_OriginalRect;
    m_ImageView.image = m_Placeholder;
    m_ImageView.userInteractionEnabled = YES;
    m_ImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.m_ScrollView = [[[UIScrollView alloc] initWithFrame:self.frame] autorelease];
    [self addSubview:m_ScrollView];
    m_ScrollView.delegate = self;
    m_ScrollView.backgroundColor = [UIColor clearColor];
    
    CGSize maxSize = m_ScrollView.frame.size;
    CGFloat widthRatio = maxSize.width/m_ImageView.image.size.width;
    CGFloat heightRatio = maxSize.height/m_ImageView.image.size.height;
    CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;

    if (initialZoom>1.0)
    {
        initialZoom = 1.0;
    }
    
    [m_ScrollView setMinimumZoomScale:initialZoom];
    [m_ScrollView setMaximumZoomScale:5];
    [m_ScrollView setZoomScale:initialZoom];
    
    [m_ScrollView addSubview:m_ImageView];

    float sourceWidth = [m_Placeholder size].width;
    float sourceHeight = [m_Placeholder size].height;
	float targetWidth = self.width;
	float ratio = targetWidth / sourceWidth;
	float targetHeight = sourceHeight * ratio;
    
    
    if ([m_Placeholder isEqual:[UIImage imageNamed:@"topicPictureDefault"]])
    {
        indicationView = [[[UIActivityIndicatorView alloc]
                           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        [indicationView startAnimating];
        [m_ImageView addSubview:indicationView];
        [indicationView centerInSuperView];
    }
    
    if ([[BBCacheData getCurrentTitle] isNotEmpty]) {
        s_ShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        s_ShareBtn.exclusiveTouch = YES;
        [s_ShareBtn setBackgroundImage:[UIImage imageNamed:@"shareBarButton"] forState:UIControlStateNormal];
        [s_ShareBtn setBackgroundImage:[UIImage imageNamed:@"shareBarButtonPressed"] forState:UIControlStateHighlighted];
        s_ShareBtn.frame = CGRectMake(UI_SCREEN_WIDTH - 50 - 20 - 40, UI_SCREEN_HEIGHT - 50 - 40, 40, 30);
        [s_ShareBtn addTarget:self action:@selector(sharePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:s_ShareBtn];
    }
    
    s_SaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    s_SaveBtn.exclusiveTouch = YES;
    [s_SaveBtn setBackgroundImage:[UIImage imageNamed:@"download_icon"] forState:UIControlStateNormal];
    [s_SaveBtn setBackgroundImage:[UIImage imageNamed:@"download_icon_pressed"] forState:UIControlStateHighlighted];
    s_SaveBtn.frame = CGRectMake(UI_SCREEN_WIDTH - 50 - 10, UI_SCREEN_HEIGHT - 50 - 40, 40, 30);
    [s_SaveBtn addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:s_SaveBtn];
    

    m_ScrollView.userInteractionEnabled = NO;
    [UIView beginAnimations:@"begin" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    firRect = CGRectMake(0, (UI_SCREEN_HEIGHT-targetHeight)/2, targetWidth, targetHeight);
    m_ImageView.frame = firRect;
    [UIView commitAnimations];

}

- (void)loadImage
{
    m_ScrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapGR, *doubleTapGR;
    singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(changeRect:)];
    singleTapGR.delegate = self;
//    singleTapGR.cancelsTouchesInView = NO;
    doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(showOriginalImage:)];
    doubleTapGR.numberOfTapsRequired = 2;
    doubleTapGR.delegate = self;
//    doubleTapGR.cancelsTouchesInView = NO;
    
    //当你需要使用单击时请求双击事件失败.
    [singleTapGR requireGestureRecognizerToFail:doubleTapGR];
    
    [m_ScrollView addGestureRecognizer:singleTapGR];
    [m_ScrollView addGestureRecognizer:doubleTapGR];
    [singleTapGR release];
    [doubleTapGR release];
    
    m_ScrollView.exclusiveTouch = YES;
    
    /*
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 0.5;
    lpress.allowableMovement = 5;
    lpress.delegate = self;
    [m_ScrollView addGestureRecognizer:lpress];
    [lpress release];
     */

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    if (m_ImageURL)
    {
        [manager downloadWithURL:m_ImageURL delegate:self options:0];
    }
}


-(void)changeRect:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [s_SaveBtn setEnabled:NO];
        [s_ShareBtn removeTarget:self action:@selector(sharePhoto) forControlEvents:UIControlEventTouchUpInside];
        m_ScrollView.userInteractionEnabled = NO;
        [UIView beginAnimations:@"close1" context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
        m_ScrollView.contentSize = m_ScrollView.bounds.size;
        m_ScrollView.contentOffset = CGPointZero;
        m_ImageView.frame = m_OriginalRect;
        [UIView commitAnimations];
    }
}

- (void)closeView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideStatusBar) object:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.viewController.navigationController setNavigationBarHidden:NO animated:NO];
    [UIView beginAnimations:@"close2" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.backgroundColor = [UIColor clearColor];
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context
{
    m_ScrollView.userInteractionEnabled = YES;
    if ([animationID isEqualToString:@"begin"])
    {

        animationOver = YES;
        [self loadImage];
    }
    else if ([animationID isEqualToString:@"close2"])
    {
        if (!isCanCloseSelf) {
            return;
        }
        m_ScrollView.userInteractionEnabled = NO;
        [self removeFromSuperview];
        self.superview.userInteractionEnabled = YES;
    }
    else if ([animationID isEqualToString:@"close1"])
    {
        if (!isCanCloseSelf) {
            return;
        }
        m_ScrollView.userInteractionEnabled = NO;
        [self closeView];
    }
}

-(void)showOriginalImage:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView beginAnimations:@"Original" context:NULL];
        [UIView setAnimationDuration:0.3];
        
        if (beScaled)
        {
            beScaled = NO;
        }
        else
        {
            isOriginSize = !isOriginSize;
        }
        
        m_ScrollView.contentSize = m_ScrollView.bounds.size;
        
        CGFloat width = 0.0f;
        CGFloat height = 0.0f;
        CGFloat top = 0.0f;
        CGFloat left = 0.0f;
        
        if (!isOriginSize)
        {
            width = firRect.size.width;
            height = firRect.size.height;
            top = (UI_SCREEN_HEIGHT - height)/2;
            left =  (UI_SCREEN_WIDTH - width)/2;
            m_ImageView.frame = CGRectMake(left, top, width, height);
        }
        else
        {
            width = m_Placeholder.size.width;
            height = m_Placeholder.size.height;
            top = (UI_SCREEN_HEIGHT - height)/2;
            left =  (UI_SCREEN_WIDTH - width)/2;
            m_ImageView.frame = CGRectMake(left, top, width, height);
        }
        
        if (left < 0 || top < 0)
        {
            CGFloat width1 = width > UI_SCREEN_WIDTH ? width : UI_SCREEN_WIDTH;
            CGFloat height1 = height > UI_SCREEN_HEIGHT ? height : UI_SCREEN_HEIGHT;
            m_ScrollView.contentSize = CGSizeMake(width1, height1);
            
            CGFloat top1 = top < 0 ? 0 : top;
            CGFloat left1 = left < 0 ? 0 : left;
            m_ImageView.frame = CGRectMake(left1, top1, width, height);
            
            CGFloat top2 = top < 0 ? -top : 0;
            CGFloat left2 = left < 0 ? -left : 0;
            m_ScrollView.contentOffset = CGPointMake(left2, top2);
        }
        else
        {
            m_ScrollView.contentSize = m_ScrollView.bounds.size;
            m_ScrollView.contentOffset = CGPointZero;
        }
        
        [UIView commitAnimations];
    }
}

/*
-(void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet *photoActionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil] autorelease];
        [photoActionSheet showInView:self];
    }
}

#pragma mark - UIActionSheetDelegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex!=actionSheet.cancelButtonIndex)
    {
        [self savePhoto];
    }
}
 */

#pragma mark - savePhoto

- (void)savePhoto
{
    if (m_ImageView.image)
    {
        //s_SaveBtn.enabled = NO;
        self.superview.userInteractionEnabled = NO;
        
        [self showProgressHUDWithMessage:[NSString stringWithFormat:@"%@\u2026" , NSLocalizedString(@"保存中", @"Displayed with ellipsis as 'Saving...' when an item is in the process of being saved")]];
        [self performSelector:@selector(actuallySavePhoto:) withObject:m_ImageView.image afterDelay:0];
    }
}

- (void)actuallySavePhoto:(UIImage *)photo
{
    if (photo)
    {
        UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    else
    {
        //s_SaveBtn.enabled = YES;
        self.superview.userInteractionEnabled = YES;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self showProgressHUDCompleteMessage: error ? NSLocalizedString(@"保存失败", @"Informing the user a process has failed") : NSLocalizedString(@"保存成功", @"Informing the user an item has been saved")];
    
    //s_SaveBtn.enabled = YES;
    self.superview.userInteractionEnabled = YES;
}

#pragma mark - MBProgressHUD

- (MBProgressHUD *)progressHUD
{
    if (!progressHUD)
    {
        self.progressHUD = [[[MBProgressHUD alloc] initWithView:self] autorelease];
        progressHUD.minSize = CGSizeMake(120, 120);
        progressHUD.minShowTime = 1;
        [self addSubview:progressHUD];
    }
    
    return progressHUD;
}

- (void)showProgressHUDWithMessage:(NSString *)message
{
    self.progressHUD.labelText = message;
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc]
                                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    [indicator startAnimating];
    self.progressHUD.customView = indicator;
    [self.progressHUD show:YES];
    self.userInteractionEnabled = NO;
}

- (void)hideProgressHUD:(BOOL)animated
{
    [self.progressHUD hide:animated];
    self.userInteractionEnabled = YES;
}

- (void)showProgressHUDCompleteMessage:(NSString *)message
{
    if (message)
    {
        if (self.progressHUD.isHidden) [self.progressHUD show:YES];
        self.progressHUD.labelText = message;
        self.progressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
        self.progressHUD.mode = MBProgressHUDModeCustomView;
        [self.progressHUD hide:YES afterDelay:1.5];
    }
    else
    {
        [self.progressHUD hide:YES];
    }
    self.userInteractionEnabled = YES;
}

#pragma mark UIScrollView Delegate

// 设置UIScrollView中要缩放的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.m_ImageView;
    
}

// 让UIImageView在UIScrollView缩放后居中显示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (!animationOver)
    {
        return;
    }

    beScaled = YES;
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    m_ImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                            scrollView.contentSize.height * 0.5 + offsetY);
}

//当滑动结束时
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    //把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
    [scrollView setZoomScale:scale animated:NO];
}


- (BOOL)animatedGIFWithData:(NSData *)data
{
    if (!data)
    {
        return NO;
    }
    
    if (![data sd_isGIF])
    {
        return NO;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData(( CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    NSMutableArray *images = [NSMutableArray array];
    
    NSTimeInterval duration = 0.0f;
    
    for (size_t i = 0; i < count; i++)
    {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        NSDictionary *frameProperties = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source, i, NULL));
        duration += [[[frameProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary] objectForKey:(NSString*)kCGImagePropertyGIFDelayTime] doubleValue];
        
        [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
        if (image != NULL) {
             CGImageRelease(image);
        }
    }
    if (source != NULL) {
            CFRelease(source);
    }
    
    if (!duration)
    {
        duration = (1.0f/10.0f)*count;
    }
    
    if (images.count > 0)
    {
        [m_ImageView setImage:[images objectAtIndex:0]];
        [m_ImageView setAnimationImages:images];
        
        [m_ImageView setAnimationDuration:duration];
        [m_ImageView setAnimationRepeatCount:0];
        [m_ImageView startAnimating];
        
        return YES;
    }
    
    return NO;
}

#pragma mark SDWebImageManagerDelegate

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error forURL:(NSURL *)url userInfo:(NSDictionary *)info;
{
    [indicationView removeFromSuperview];
    indicationView = nil;
}

// SDImageCache中有数据
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info
{
    [indicationView removeFromSuperview];
    indicationView = nil;
    
    NSString *fileName = [imageManager getCachePathForKey:[url absoluteString]];
	NSData* imageData = [NSData dataWithContentsOfFile:fileName];
    
    if (![self animatedGIFWithData:imageData])
    {
        if ([m_ImageView isAnimating])
        {
            [m_ImageView stopAnimating];
        }
        
        m_ImageView.image = image;
    }
    
    float width = m_ImageView.image.size.width;
    float height = m_ImageView.image.size.height;
    
    float divMax = width/UI_SCREEN_WIDTH;
    width = UI_SCREEN_WIDTH;
    height = height/divMax;
    
    m_ScrollView.userInteractionEnabled = NO;
    [UIView beginAnimations:@"showImage" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];

    if (UI_SCREEN_HEIGHT-height < 0)
    {
        m_ScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, height);
        m_ScrollView.contentOffset = CGPointMake(0, (height-UI_SCREEN_HEIGHT)/2);
        m_ImageView.frame = CGRectMake(0, 0, width, height);
    }
    else
    {
        m_ImageView.frame = CGRectMake(0, (UI_SCREEN_HEIGHT-height)/2, width, height);
        m_ScrollView.contentSize = m_ScrollView.bounds.size;
        m_ScrollView.contentOffset = CGPointZero;
    }
    
    [UIView commitAnimations];
}

// SDImageCache中无数据，SDWebImageDownloader下载获得
- (void)webImageManager:(SDWebImageManager *)imageManager ImageData:(NSData *)imageData didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info
{
    [indicationView removeFromSuperview];
    indicationView = nil;

    if (![self animatedGIFWithData:imageData])
    {
        if ([m_ImageView isAnimating])
        {
            [m_ImageView stopAnimating];
        }
        
        m_ImageView.image = image;
    }
    
    float width = m_ImageView.image.size.width;
    float height = m_ImageView.image.size.height;
    
    float divMax = width/UI_SCREEN_WIDTH;
    width = UI_SCREEN_WIDTH;
    height = height/divMax;
    
    m_ScrollView.userInteractionEnabled = NO;
    [UIView beginAnimations:@"showImage" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];

    if (UI_SCREEN_HEIGHT-height < 0)
    {
        m_ScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, height);
        m_ScrollView.contentOffset = CGPointMake(0, (height-UI_SCREEN_HEIGHT)/2);
        m_ImageView.frame = CGRectMake(0, 0, width, height);
    }
    else
    {
        m_ImageView.frame = CGRectMake(0, (UI_SCREEN_HEIGHT-height)/2, width, height);
        m_ScrollView.contentSize = m_ScrollView.bounds.size;
        m_ScrollView.contentOffset = CGPointZero;
    }

    [UIView commitAnimations];
}


- (void)sharePhoto {
    isCanCloseSelf = NO;
    BBShareMenu *menu = [[[BBShareMenu alloc] initWithType:0 title:@"分享"] autorelease];
    menu.delegate = self;
    [menu show];
}

#pragma mark -
#pragma mark ShareMenuDelegate
- (void)shareMenu:(BBShareMenu *)shareMenu clickItem:(BBShareMenuItem *)item {
    isCanCloseSelf = YES;
    NSString *shareText = [BBCacheData getCurrentTitle];
    NSString *str = @"宝宝树孕育";
    
    UIImage *image = m_ImageView.image;
    if (!image) {
        return;
    }
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
        message.title = shareText;
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
        [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"%@（分享自@%@）",shareText,str];
    }else if(item.indexAtMenu == 3) {
        [MobClick event:@"share_v2" label:@"QQ空间图标点击"];
        snsType = UMShareToQzone;
        [UMSocialData defaultData].extConfig.qzoneData.url = [NSString stringWithFormat:@"http://m.babytree.com/"];
        [UMSocialData defaultData].extConfig.qzoneData.title = @"分享自@宝宝树孕育 心情记录";
        [UMSocialData defaultData].shareImage = smallImage;
    }else if(item.indexAtMenu == 4) {
        [MobClick event:@"share_v2" label:@"腾讯微博图标点击"];
        snsType = UMShareToTencent;
        [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"%@（分享自@%@）",shareText,str];
    }
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsType];
    snsPlatform.snsClickHandler(self.viewController,[UMSocialControllerService defaultControllerService],YES);
}
- (void)closeMenu:(BBShareMenu *)shareMenu{
    isCanCloseSelf = YES;
}
@end
