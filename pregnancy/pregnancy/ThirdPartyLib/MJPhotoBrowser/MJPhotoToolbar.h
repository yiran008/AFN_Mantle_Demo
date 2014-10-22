//
//  MJPhotoToolbar.h
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
// add by DJ
#import "BBConfigureAPI.h"
#import <MessageUI/MessageUI.h>

@interface MJPhotoToolbar : UIView
// add by DJ
<
    MFMailComposeViewControllerDelegate,
    UIAlertViewDelegate,
    ShareMenuDelegate
>

// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@property (nonatomic, strong) MBProgressHUD *progressHUD;

// add by DJ
@property (nonatomic, strong) ASIFormDataRequest *deletePhotoRequest;

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex;

@end
