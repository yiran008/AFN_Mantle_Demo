//
//  PicReviewView.h
//  pregnancy
//
//  Created by mac on 13-5-15.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "MBProgressHUD.h"
#import "BBShareMenu.h"

typedef enum{
    BBShareTypeCommunicate,//默认
    BBShareTypeRecord
} BBShareType;

@interface PicReviewView : UIView
<
    UIGestureRecognizerDelegate,
    SDWebImageManagerDelegate,
    UIActionSheetDelegate,
    UIScrollViewDelegate,
    ShareMenuDelegate
>
{
    BOOL beScaled;      // 被拉伸过了
    BOOL animationOver;
    BOOL isOriginSize;
    BOOL isCanCloseSelf;
    CGRect firRect;
    UIActivityIndicatorView *indicationView;
    
    UIButton *s_SaveBtn;
    UIButton *s_ShareBtn;
}

@property (nonatomic, assign) CGRect m_OriginalRect;
@property (nonatomic, retain) UIImage *m_Placeholder;
@property (nonatomic, retain) UIScrollView *m_ScrollView;
@property (nonatomic, retain) UIImageView *m_ImageView;
@property (nonatomic, retain) NSURL *m_ImageURL;
@property (nonatomic, retain) MBProgressHUD *progressHUD;
@property (assign)  BBShareType shareTypeMark;

- (void)loadUrl:(NSURL *)url;
- (id)initWithRect:(CGRect)rect placeholderImage:(UIImage *)placeholder;

@end
