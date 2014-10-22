//
//  BBRecordDetail.m
//  pregnancy
//
//  Created by whl on 13-9-22.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBRecordDetail.h"
#import "BBRecordRequest.h"
#import "BBRecordMainPage.h"


@interface BBRecordDetail ()
@end

@implementation BBRecordDetail

- (void)dealloc
{
    [_privateButton release];
    [_dateLabel release];
    [_deleteButton release];
    [_optionView release];
    [_recordDetailClass release];
    [_deleteRequest clearDelegatesAndCancel];
    [_deleteRequest release];
    [_loadProgress release];
    [_privateRequest clearDelegatesAndCancel];
    [_privateRequest release];
    [_contentLabel release];
    [_recordImage release];
    [_pictureView release];
    [_recordScrollView release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isPrivate = YES;
        self.isSquare = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [MobClick event:@"mood_v2" label:@"心情详情页"];
    [super viewDidLoad];
    self.navigationItem.title = @"记录详情";
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
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.exclusiveTouch = YES;
    [commitButton setFrame:CGRectMake(0, 0, 40, 30)];
    [commitButton setImage:[UIImage imageNamed:@"shareBarButton"] forState:UIControlStateNormal];
    [commitButton setImage:[UIImage imageNamed:@"shareBarButtonPressed"] forState:UIControlStateHighlighted];
    [commitButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    [self.navigationItem setRightBarButtonItem:commitBarButton];
    [commitBarButton release];
    
//    NSString *dateTS = [self.recordDetailDic stringForKey:@"publish_ts"];
    NSString *dateTS = self.recordDetailClass.publish_ts;
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:[dateTS doubleValue]];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:publishDate];
    self.dateLabel.text = destDateString;
    
    if (IS_IPHONE5) {
        [self.view setFrame:CGRectMake(0, self.view.frame.origin.y, 320, self.view.frame.size.height+88)];
        
    }
    
    [self.optionView setHidden:NO];
    [self.pictureView setHidden:YES];
    [self.contentLabel setHidden:YES];
    
//    if([[self.recordDetailDic stringForKey:@"text"] isNotEmpty])
    if([self.recordDetailClass.text isNotEmpty])
    {
        [self.contentLabel setHidden:NO];
//        NSString *contentString = [self.recordDetailDic stringForKey:@"text"];
        NSString *contentString = self.recordDetailClass.text;
        CGSize size = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(296.0, MAXFLOAT) withFont:[UIFont systemFontOfSize:16.0f] withString:contentString];
        self.contentLabel.text = contentString;
        [self.contentLabel setFrame:CGRectMake(13.0, 48.0, 296.0, size.height)];
    }else{
        [self.contentLabel setFrame:CGRectMake(13.0, 0, 0, 0)];
    }

//    if([[self.recordDetailDic stringForKey:@"img_middle"] isNotEmpty])
    if([self.recordDetailClass.img_middle isNotEmpty])
    {
        [self.pictureView setHidden:NO];
        NSURL *url = [NSURL URLWithString:self.recordDetailClass.img_middle];
        [self.recordImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"topicPictureDefault"] options:0];
        if(self.contentLabel.hidden)
        {
            [self.pictureView setFrame:CGRectMake(0, 48.0, 320, 188)];
        }else{
            [self.pictureView setFrame:CGRectMake(0, 48.0+self.contentLabel.frame.size.height, 320, 188)];
        }
    }else{
        [self.pictureView setFrame:CGRectMake(0, 0, 0, 0)];
    }

    
    if (self.isSquare) {
        if (![self.recordDetailClass.enc_user_id isEqualToString:[BBUser getEncId]]) {
            [self.optionView setHidden:YES];
        }else{
            self.isPrivate = NO;
            [self.privateButton setImage:[UIImage imageNamed:@"recordprivate"] forState:UIControlStateNormal];
        }
    }else{
        if ([self.recordDetailClass.is_private isEqualToString:@"yes"]) {
            self.isPrivate = YES;
        }else{
            self.isPrivate = NO;
        }
    }
    CGFloat height = 58.0+self.contentLabel.frame.size.height+self.pictureView.frame.size.height;
    if (IS_IPHONE5) {
        if (height > 470) {
            [self.recordScrollView setFrame:CGRectMake(0, 0, 320, 470)];
            [self.recordScrollView setContentSize:CGSizeMake(320, height)];
            [self.optionView setFrame:CGRectMake(0, 472, 320, self.optionView.frame.size.height)];
        }else{
            [self.optionView setFrame:CGRectMake(0, height, 320, self.optionView.frame.size.height)];
            [self.recordScrollView setFrame:CGRectMake(0, 0, 320, height)];
            [self.recordScrollView setContentSize:CGSizeMake(320, height)];
        }
    }else{
        if (height > 380) {
            [self.recordScrollView setFrame:CGRectMake(0, 0, 320, 380)];
            [self.recordScrollView setContentSize:CGSizeMake(320, height)];
            [self.optionView setFrame:CGRectMake(0, 380, 320, self.optionView.frame.size.height)];
        }else{
            [self.optionView setFrame:CGRectMake(0, height, 320, self.optionView.frame.size.height)];
            [self.recordScrollView setFrame:CGRectMake(0, 0, 320, height)];
            [self.recordScrollView setContentSize:CGSizeMake(320, height)];
        }
    
    }

    if (self.isPrivate) {
        [self.privateButton setImage:[UIImage imageNamed:@"recordprivate"] forState:UIControlStateNormal];
    }else{
        [self.privateButton setImage:[UIImage imageNamed:@"recordpublic"] forState:UIControlStateNormal];
    }
    self.loadProgress = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:self.loadProgress];
}

-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)shareAction:(id)sender
{
    //获取分享所需要的图片
    BBShareMenu *menu = [[[BBShareMenu alloc] initWithType:0 title:@"分享"] autorelease];
    menu.delegate = self;
    [menu show];
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
        [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"%@（分享自@宝宝树孕育）",shareText];
    }else if(item.indexAtMenu == 3) {
        [MobClick event:@"share_v2" label:@"QQ空间图标点击"];
        snsType = UMShareToQzone;
        [UMSocialData defaultData].extConfig.qzoneData.title = @"分享自@宝宝树孕育 心情记录";
        [UMSocialData defaultData].extConfig.qzoneData.url = [NSString stringWithFormat:@"http://m.babytree.com/"];
        [UMSocialData defaultData].shareImage = smallImage;
    }else if(item.indexAtMenu == 4) {
        [MobClick event:@"share_v2" label:@"腾讯微博图标点击"];
        snsType = UMShareToTencent;
        [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"%@（分享自@宝宝树孕育）",shareText];
    }
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsType];
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
}

-(IBAction)deleteRecord:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定删除吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setTag:DELETE_ALERT_VIEW_TAG];
    [alertView show];
    [alertView release];
}


#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == DELETE_ALERT_VIEW_TAG) {
        if (buttonIndex == 1) {
            [self.loadProgress setLabelText:@"正在删除..."];
            [self.loadProgress show:YES];
            [self.deleteRequest clearDelegatesAndCancel];
            self.deleteRequest = [BBRecordRequest deleteRecord:self.recordDetailClass.mood_id];
            [self.deleteRequest setDidFinishSelector:@selector(deleteRecordFinish:)];
            [self.deleteRequest setDidFailSelector:@selector(deleteRecordFail:)];
            [self.deleteRequest setDelegate:self];
            [self.deleteRequest startAsynchronous];
        }
    }
}

#pragma mark - ASIHttp Request Delegate

- (void)deleteRecordFinish:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *submitTopicData = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        [self.loadProgress hide:YES];
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"删除失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    if ([[submitTopicData stringForKey:@"status"] isEqualToString:@"success"])
    {
        [self.loadProgress hide:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:UPADATE_RECORD_PARK_VIEW object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.recordDetailClass.mood_id,@"mood_id", nil]];
        [[NSNotificationCenter defaultCenter] postNotificationName:UPADATE_RECORD_MOON_VIEW object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.recordDetailClass.mood_id,@"mood_id", nil]];
        [self.navigationController popViewControllerAnimated:YES];

    }
    else
    {
        [self.loadProgress hide:YES];
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"删除失败" message:[[submitTopicData dictionaryForKey:@"data"] stringForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)deleteRecordFail:(ASIHTTPRequest *)request
{
    [self.loadProgress hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}


-(IBAction)setRecordPrivate:(id)sender
{
    [self.loadProgress setLabelText:@"同步设置..."];
    [self.loadProgress show:YES];

    NSString *strPrivate = @"yes";
    if (self.isPrivate) {
        strPrivate = @"no";
    }else{
        strPrivate = @"yes";
    }
    
    [self.privateRequest clearDelegatesAndCancel];
    self.privateRequest = [BBRecordRequest setRecordPrivate:strPrivate withRecodID:self.recordDetailClass.mood_id];
    [self.privateRequest setDidFinishSelector:@selector(privateRecordFinish:)];
    [self.privateRequest setDidFailSelector:@selector(privateRecordFail:)];
    [self.privateRequest setDelegate:self];
    [self.privateRequest startAsynchronous];
}

#pragma mark - ASIHttp Request Delegate

- (void)privateRecordFinish:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *submitTopicData = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        [self.loadProgress hide:YES];
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"设置失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    if ([[submitTopicData stringForKey:@"status"] isEqualToString:@"success"])
    {
        [self.loadProgress setLabelText:@"设置成功"];
        [self.loadProgress hide:YES afterDelay:2];
        NSString *priStr = nil;
        if (self.isPrivate) {
            self.isPrivate = NO;
            [self.privateButton setImage:[UIImage imageNamed:@"recordpublic"] forState:UIControlStateNormal];
            priStr = @"no";
        }else{
            self.isPrivate = YES;
            [self.privateButton setImage:[UIImage imageNamed:@"recordprivate"] forState:UIControlStateNormal];
            priStr = @"yes";
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:UPADATE_RECORD_PARK_VIEW object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.recordDetailClass.mood_id,@"mood_id", priStr, @"is_private", nil]];
        [[NSNotificationCenter defaultCenter] postNotificationName:UPADATE_RECORD_MOON_VIEW object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.recordDetailClass.mood_id,@"mood_id", priStr, @"is_private", nil]];
    }
    else
    {
        [self.loadProgress hide:YES];
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"设置失败" message:[[submitTopicData dictionaryForKey:@"data"] stringForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)privateRecordFail:(ASIHTTPRequest *)request
{
    [self.loadProgress hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

-(IBAction)clickedImage:(id)sender
{
    if (self.recordImage.image != nil) {
        [BBCacheData setCurrentTitle:@" "];
        NSString *photoUrl=self.recordDetailClass.img_big;
        CGRect rect = [self.pictureView  convertRect:self.pictureView.bounds toView:self.view];
        PicReviewView *pView = [[[PicReviewView alloc] initWithRect:rect placeholderImage:self.recordImage.image] autorelease];
        pView.shareTypeMark = BBShareTypeRecord;
        [pView loadUrl:[NSURL URLWithString:photoUrl]];
        [MobClick event:@"mood_v2" label:@"点击查看大图"];
        [self.view addSubview:pView];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    IOS6_RELEASE_VIEW
}

- (void)viewDidUnload
{
    [self viewDidUnloadBabytree];
    
    [super viewDidUnload];
}

- (void)viewDidUnloadBabytree
{
    self.privateButton = nil;
    self.deleteButton = nil;
    self.dateLabel = nil;
    [self.privateRequest clearDelegatesAndCancel];
    self.privateRequest = nil;
    self.optionView = nil;
    self.loadProgress = nil;
    self.contentLabel = nil;
    self.recordImage = nil;
    self.pictureView = nil;
    [self.deleteRequest clearDelegatesAndCancel];
    self.deleteRequest = nil;
    self.recordScrollView = nil;
}

- (UIImage *)getShareImage
{
    CGFloat scollViewheight = self.recordScrollView.contentSize.height;
    CGFloat height =  self.recordScrollView.frame.size.height;
    //为了拿到webview全部高度，需要重设高度位真正的高度
    [self.recordScrollView setFrame:CGRectMake(self.recordScrollView.frame.origin.x, self.recordScrollView.frame.origin.y, self.recordScrollView.frame.size.width,scollViewheight)];
    //支持retina高分的关键
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.recordScrollView.bounds.size.width, scollViewheight), NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(CGSizeMake(self.recordScrollView.bounds.size.width, scollViewheight));
    }
    //获取图像
    [self.recordScrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.recordScrollView setFrame:CGRectMake(self.recordScrollView.frame.origin.x, self.recordScrollView.frame.origin.y, self.recordScrollView.frame.size.width,height)];
    return image;
}


@end
