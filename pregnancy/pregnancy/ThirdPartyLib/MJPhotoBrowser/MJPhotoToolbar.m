//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
#import "MBProgressHUD+Add.h"

@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
// add by DJ
    UIButton *_deletePhotoBtn;
    
    // add by sxf
    UIActionSheet *_actionsSheet;
    
    
}

@property (nonatomic, strong) UIActivityViewController *activityViewController;
@property (assign) BOOL isDeletePhoto;

@end

@implementation MJPhotoToolbar
@synthesize progressHUD;

// add by DJ
- (void)dealloc
{
    [_deletePhotoRequest clearDelegatesAndCancel];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.6];
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
        if (!_indexLabel) {
            _indexLabel = [[UILabel alloc] init];
            _indexLabel.font = [UIFont boldSystemFontOfSize:20];
            _indexLabel.frame = CGRectMake(50, 0, self.width-100, self.height);
            _indexLabel.backgroundColor = [UIColor clearColor];
            _indexLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
            _indexLabel.textAlignment = NSTextAlignmentCenter;
            _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [self addSubview:_indexLabel];
        }
    }
    
    
    // add by sxf
    MJPhoto *photo = _photos[_currentPhotoIndex];
    CGFloat btnWidth = self.bounds.size.height;
    
    if (photo.shareEnable)
    {
        _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveImageBtn.exclusiveTouch = YES;
        _saveImageBtn.frame = CGRectMake(self.bounds.size.width - btnWidth - 10, 5, 40, 30);
        _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_saveImageBtn setBackgroundImage:[UIImage imageNamed:@"download_icon"] forState:UIControlStateNormal];
        [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveImageBtn];
        UIButton *s_ShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        s_ShareBtn.exclusiveTouch = YES;
        [s_ShareBtn setBackgroundImage:[UIImage imageNamed:@"shareBarButton"] forState:UIControlStateNormal];
        [s_ShareBtn setBackgroundImage:[UIImage imageNamed:@"shareBarButtonPressed"] forState:UIControlStateHighlighted];
        s_ShareBtn.frame = CGRectMake(self.bounds.size.width - btnWidth - 60, 5, 40, 30);
        [s_ShareBtn addTarget:self action:@selector(sharePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:s_ShareBtn];
    }
    else
    {
//        // 保存图片按钮
//        _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _saveImageBtn.exclusiveTouch = YES;
//        //    _saveImageBtn.frame = CGRectMake(20, 0, btnWidth, btnWidth);
//        
//        _saveImageBtn.frame = CGRectMake(self.bounds.size.width - btnWidth - 10, 0, btnWidth, btnWidth);
//        
//        _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        [_saveImageBtn setImage:[UIImage imageNamed:@"download_icon"] forState:UIControlStateNormal];
//        
//        //    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
//        
//        [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_saveImageBtn];
        _deletePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deletePhotoBtn.exclusiveTouch = YES;
        [_deletePhotoBtn setBackgroundImage:[UIImage imageNamed:@"imageshow_delete_btn"] forState:UIControlStateNormal];
        _deletePhotoBtn.frame = CGRectMake(self.bounds.size.width - btnWidth - 10, 5, 60, 30);
        [_deletePhotoBtn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deletePhotoBtn];
    }


    // add by DJ

//    if (photo.photoItem)
//    {
//        _deletePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _deletePhotoBtn.exclusiveTouch = YES;
//        _deletePhotoBtn.frame = CGRectMake(self.bounds.size.width - btnWidth*2 - 15, 0, btnWidth, btnWidth);
//        _deletePhotoBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        [_deletePhotoBtn setImage:[UIImage imageNamed:@"toolbar_delete_icon"] forState:UIControlStateNormal];
//        [_deletePhotoBtn addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_deletePhotoBtn];
//    }
}

#pragma mark - savePhoto

- (void)saveImage
{
    MJPhoto *photo = _photos[_currentPhotoIndex];

    if (photo.image)
    {
        _saveImageBtn.enabled = NO;
        // add by DJ
        _deletePhotoBtn.enabled = NO;
        self.superview.userInteractionEnabled = NO;
        
        [self showProgressHUDWithMessage:[NSString stringWithFormat:@"%@\u2026" , NSLocalizedString(@"保存中", @"Displayed with ellipsis as 'Saving...' when an item is in the process of being saved")]];
        [self performSelector:@selector(actuallySavePhoto:) withObject:photo.image afterDelay:0];
    }
}

- (void)actuallySavePhoto:(UIImage *)photo
{
    if (photo)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    }
    else
    {
        _saveImageBtn.enabled = YES;

        // add by DJ
        MJPhoto *thephoto = _photos[_currentPhotoIndex];
        if (_deletePhotoBtn)
        {
            _deletePhotoBtn.enabled = !thephoto.photoItem.m_isDeleted;
        }

        self.superview.userInteractionEnabled = YES;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self showProgressHUDCompleteMessage: error ? NSLocalizedString(@"保存失败", @"Informing the user a process has failed") : NSLocalizedString(@"保存成功", @"Informing the user an item has been saved")];
    
    _saveImageBtn.enabled = YES;

    // add by DJ
    MJPhoto *thephoto = _photos[_currentPhotoIndex];
    if (_deletePhotoBtn)
    {
        _deletePhotoBtn.enabled = !thephoto.photoItem.m_isDeleted;
    }

    if (!error)
    {
        thephoto.save = YES;
        _saveImageBtn.enabled = NO;
    }

    self.superview.userInteractionEnabled = YES;
}

//- (void)saveImage
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        MJPhoto *photo = _photos[_currentPhotoIndex];
//        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    });
//}
//
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
//{
//    if (error) {
//        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
//    } else {
//        MJPhoto *photo = _photos[_currentPhotoIndex];
//        photo.save = YES;
//        _saveImageBtn.enabled = NO;
//        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
//    }
//}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    if (self.isDeletePhoto) {
        self.progressHUD.labelText = @"删除成功";
        self.progressHUD.mode = MBProgressHUDModeCustomView;
        [self.progressHUD hide:YES afterDelay:1];
        self.isDeletePhoto = NO;
    }
    
    // 更新页码
    if ([_photos count] == 1)
    {
        _indexLabel.text = @"";

    }
    else
    {
        _indexLabel.text = [NSString stringWithFormat:@"%lu / %ld", (unsigned long)_currentPhotoIndex + 1, (long)_photos.count];

    }
    if (_currentPhotoIndex < [_photos count])
    {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        // 按钮
        _saveImageBtn.enabled = photo.image != nil && !photo.save;
        // add by DJ
        if (_deletePhotoBtn)
        {
            _deletePhotoBtn.enabled = photo.image != nil;
        }
    }

    self.superview.userInteractionEnabled = YES;
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self ActDeletePhoto];
    }
}


#pragma mark -
#pragma mark deleteImage

- (void)deletePhoto
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认删除此照片?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alertView show];

//    [PXAlertView showAlertWithTitle:@"确认删除此照片?" message:nil cancelTitle:@"取消" otherTitle:@"删除" completion:^(BOOL cancelled, NSInteger buttonIndex)
//     {
//         if (!cancelled)
//         {
//             //[self ActDeletePhoto];
//         }
//     }];
}

- (void)ActDeletePhoto
{
    MJPhoto *thephoto = _photos[_currentPhotoIndex];

    if (![thephoto.photoItem isNotEmpty])
    {
        return;
    }

    [MobClick event:@"click_events" label:@"删除相册照片"];

    [self showProgressHUDWithMessage:[NSString stringWithFormat:@"%@\u2026", @"删除中"]];

    [self.deletePhotoRequest clearDelegatesAndCancel];
//    self.deletePhotoRequest = [HMApiRequest getDeletePicRequest:[HMUser getLoginString] photoId:thephoto.photoItem.m_PhotoId];
    [self.deletePhotoRequest setDidFinishSelector:@selector(deletePhotoRequestFinish:)];
    [self.deletePhotoRequest setDidFailSelector:@selector(deletePhotoRequestFail:)];
    [self.deletePhotoRequest setDelegate:self];
    [self.deletePhotoRequest startAsynchronous];
}


#pragma mark -
#pragma mark deletePhotoRequest

- (void)deletePhotoRequestFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *responseData = [responseString objectFromJSONString];

    if (![responseData isDictionaryAndNotEmpty])
    {
        //[PXAlertView showAlertWithTitle:@"提示" message:@"删除照片失败"];
        [self showProgressHUDCompleteMessage:@"删除照片失败" error:YES];

        return;
    }

    NSString *status = [responseData stringForKey:@"status"];
    // 保存个人资料成功
    if ([status isEqualToString:@"success"] || [status isEqualToString:@"0"])
    {
        [self showProgressHUDCompleteMessage:@"删除成功"];

        MJPhoto *thephoto = _photos[_currentPhotoIndex];
        
        thephoto.photoItem.m_isDeleted = YES;
        if (_deletePhotoBtn)
        {
            _deletePhotoBtn.enabled = !thephoto.photoItem.m_isDeleted;
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_DELETEPHOTO object:nil];

        return;
    }
    else if ([status isEqualToString:@"noLogin"])
    {
        //[PXAlertView showAlertWithTitle:@"提示" message:@"您还未登陆"];
        [self showProgressHUDCompleteMessage:@"您还未登陆" error:YES];
    }
    else if ([status isEqualToString:@"invoidParam"] || [status isEqualToString:@"noPermission"])
    {
        //[PXAlertView showAlertWithTitle:@"提示" message:@"删除照片失败"];
        [self showProgressHUDCompleteMessage:@"删除照片失败" error:YES];
    }
    else
    {
        //[PXAlertView showAlertWithTitle:@"提示" message:@"删除照片失败"];
        [self showProgressHUDCompleteMessage:@"删除照片失败" error:YES];
    }
}

- (void)deletePhotoRequestFail:(ASIFormDataRequest *)request
{
    //[PXAlertView showAlertWithTitle:@"提示" message:[CommonErrorCode errorWithErrorCode:ErrorCode_NetError]];

    [self showProgressHUDCompleteMessage:[CommonErrorCode errorWithErrorCode:ErrorCode_NetError] error:YES];
}


#pragma mark - MBProgressHUD

- (MBProgressHUD *)progressHUD
{
    if (!progressHUD)
    {
        self.progressHUD = [[MBProgressHUD alloc] initWithView:self];
        progressHUD.minSize = CGSizeMake(120, 120);
        progressHUD.minShowTime = 1;

        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window) {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        [window addSubview:progressHUD];
    }
    
    return progressHUD;
}

- (void)showProgressHUDWithMessage:(NSString *)message
{
    self.progressHUD.labelText = message;
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
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
    [self showProgressHUDCompleteMessage:message error:NO];
}

- (void)showProgressHUDCompleteMessage:(NSString *)message error:(BOOL)isError
{
    if (message)
    {
        if (self.progressHUD.isHidden) [self.progressHUD show:YES];
        self.progressHUD.labelText = message;
        if (isError)
        {
            self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xxx"]];
        }
        else
        {
            self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        }
        self.progressHUD.mode = MBProgressHUDModeCustomView;
        [self.progressHUD hide:YES afterDelay:1.5];
    }
    else
    {
        [self.progressHUD hide:YES];
        [progressHUD removeFromSuperview];
        self.progressHUD = nil;
    }
    self.userInteractionEnabled = YES;
}


- (void)actionButtonPressed
{
    MJPhoto *photo = _photos[_currentPhotoIndex];
    if ([photo.image isNotEmpty])
    {
        if (_actionsSheet)
        {
            // Dismiss
            [_actionsSheet dismissWithClickedButtonIndex:_actionsSheet.cancelButtonIndex animated:YES];
        }
        else
        {
            // Show activity view controller
            NSMutableArray *items = [NSMutableArray arrayWithObjects:[photo image],[photo url],nil];
            
            self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];

            __block UIActivityViewController *weakActiveVC = self.activityViewController;
            
            UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed)
            {
                    NSLog(@"%@", activityType);
                    if(completed)
                    {
                        NSLog(@"completed\\");
                    }
                    else
                    {
                        NSLog(@"cancled\\");
                    }
                
                if ([activityType isEqualToString:@"com.apple.UIKit.activity.AssignToContact"])
                {
                    [[UIApplication sharedApplication] setStatusBarHidden:NO];
                }
                [weakActiveVC dismissViewControllerAnimated:YES completion:Nil];
            };
            
            // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
            self.activityViewController.completionHandler = myBlock;
            [self.viewController presentViewController:self.activityViewController animated:YES completion:nil];
        }
    }
}


- (void)sharePhoto {
//    isCanCloseSelf = NO;
    BBShareMenu *menu = [[BBShareMenu alloc] initWithType:0 title:@"分享"];
    menu.delegate = self;
    [menu show];
}

#pragma mark -
#pragma mark ShareMenuDelegate
- (void)shareMenu:(BBShareMenu *)shareMenu clickItem:(BBShareMenuItem *)item {
//    isCanCloseSelf = YES;
    NSString *shareText = [BBCacheData getCurrentTitle];
    NSString *str = @"宝宝树孕育";
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    UIImage *image = photo.image;
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
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
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
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
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
        [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"（分享自@%@）",str];
    }else if(item.indexAtMenu == 3) {
        [MobClick event:@"share_v2" label:@"QQ空间图标点击"];
        snsType = UMShareToQzone;
        [UMSocialData defaultData].extConfig.qzoneData.url = [NSString stringWithFormat:@"http://m.babytree.com/"];
        [UMSocialData defaultData].extConfig.qzoneData.title = @"分享自@宝宝树孕育";
        [UMSocialData defaultData].shareImage = smallImage;
    }else if(item.indexAtMenu == 4) {
        [MobClick event:@"share_v2" label:@"腾讯微博图标点击"];
        snsType = UMShareToTencent;
        [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"（分享自@%@）",str];
    }
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsType];
    snsPlatform.snsClickHandler(self.viewController,[UMSocialControllerService defaultControllerService],YES);
}
- (void)closeMenu:(BBShareMenu *)shareMenu
{
//    [self.superview setHidden:NO];
//    isCanCloseSelf = YES;
}

-(IBAction)deletePhoto:(id)sender
{
    [self.progressHUD show:YES];
    self.isDeletePhoto = YES;
    _deletePhotoBtn.enabled = NO;
    self.superview.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:DELETE_PHOTO_NOTIFICATION object:nil];
}


@end
