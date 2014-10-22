//
//  BBShareMenu.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-7-24.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBShareMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "BBUser.h"
#import "UIImageView+WebCache.h"
#import "BBShareConfig.h"

#define ITEM_WIDTH      60
#define ITEM_HEIGHT     70
#define DEVICE_WIDTH    [UIScreen mainScreen].bounds.size.width
#define kSemiModalAnimationDuration 0.3f
#define MAX_ROW         2
#define ROW_COUNT       4       //每行的按钮个数
#define PAGE_COUNT      (MAX_ROW * ROW_COUNT) //一页的按钮个数

#define ITEM_SEPERATE   (DEVICE_WIDTH - ITEM_WIDTH * ROW_COUNT) /(ROW_COUNT + 1)//每个item之间的横向间隔


@interface BBShareMenu ()
@property (nonatomic, assign) NSInteger     menuType;
@property (nonatomic, retain) NSMutableArray        *menuDatas;
@property (nonatomic, retain) UIScrollView  *shareScrollView;
@property (nonatomic, retain) NSString      *title;

@end

@implementation BBShareMenu

- (void)dealloc {
    [_menuDatas release];
    [_qrUrl release];
    [_shareScrollView release];
    [_title release];
    [_qrImageView release];
    [self.layer removeAllAnimations];
    [super dealloc];
}

/*
 menuType 
       0:原始分享不包含QQ分享 
       1:分享应用有二维码包含手机QQ 
       2:分享无二维码包含手机QQ
       3.分享无二维码含手机QQ 保存到相册
 */

- (id)initWithType:(NSInteger)menuType dataArray:(NSMutableArray *)dataArray title:(NSString *)title;
{
    self = [super init];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:244/255. green:244/255. blue:244/255. alpha:1];
        self.menuType = menuType;
        if (dataArray == nil) {
            if(menuType == 1 || menuType == 2)
            {
                self.menuDatas = [BBShareConfig getShareDataAddQQ];
            }
            else if(menuType == 3)
            {
                self.menuDatas = [BBShareConfig getShareDataAddAlbum];
            }
            else
            {
                self.menuDatas = [BBShareConfig getShareData];
            }
        }else {
            self.menuDatas = dataArray;
        }
        int row = MAX_ROW;//默认有两行，每行四个
        if ([self.menuDatas count] < ROW_COUNT) {
            row = 1;
        }
        
        if (menuType == 0 || menuType == 2 || menuType == 3) {
            CGRect rect = self.frame;
            rect.size.width = DEVICE_WIDTH;
            rect.size.height = 100 + 90 * row;
            self.frame = rect;
        }else {
            CGRect rect = self.frame;
            rect.size.width = DEVICE_WIDTH;
            rect.size.height = 100 + 90 * row + 120;
            self.frame = rect;
        }
        self.title = title;
        [self addSubviews];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title {
   return [self initWithType:0 dataArray:nil title:title];
}

- (id)initWithType:(NSInteger)menuType title:(NSString *)title {
    return [self initWithType:menuType dataArray:nil title:title];
}

- (id)initWithTitle:(NSString *)title dataArray:(NSMutableArray *)dataArray {
    return [self initWithType:0 dataArray:dataArray title:title];

}

- (void)addSubviews{
    [self addTitleLabel];
    [self addShareScrollView];
    [self addItmes];
    if (self.menuType == 1) {
        [self addSeparateLine];
        [self addQRCodeView];
    }
    [self addCancelButton];
}

- (void)addTitleLabel {
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(50, 10, 220, 20)] autorelease];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithRed:34/255. green:34/255. blue:34/255. alpha:1];
    titleLabel.text = self.title;
    [self addSubview:titleLabel];
}

- (void)addShareScrollView {
    self.shareScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 170)] autorelease];
    self.shareScrollView.pagingEnabled = YES;
    int pageCount = [self.menuDatas count] % PAGE_COUNT == 0 ? [self.menuDatas count]/PAGE_COUNT : [self.menuDatas count]/PAGE_COUNT + 1;
    self.shareScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * pageCount, 170);
    self.shareScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.shareScrollView];
}

- (void)addItmes {
    //总共两行
    for (int i = 0; i < [self.menuDatas count]; i++) {
        int pageIndex = (i + 1) % PAGE_COUNT == 0 ? (i + 1)/PAGE_COUNT :(i + 1)/PAGE_COUNT + 1;
        int row = (i % PAGE_COUNT)/ROW_COUNT;
        int cloumn = i % ROW_COUNT;
        
        NSDictionary *dic = [self.menuDatas objectAtIndex:i];
        BBShareMenuItem *item = [[[BBShareMenuItem alloc] initWithTitle:[dic stringForKey:@"title"] image:[dic stringForKey:@"imageName"] shareTo:[dic stringForKey:@"shareTo"]] autorelease];
        item.indexAtMenu = i;
        [item addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        item.frame = CGRectMake((cloumn + 1) * ITEM_SEPERATE + cloumn * ITEM_WIDTH + (pageIndex - 1) * DEVICE_WIDTH,row * 20 + row * ITEM_HEIGHT , ITEM_WIDTH, ITEM_HEIGHT);
        [self.shareScrollView addSubview:item];
    }
}

- (void)addSeparateLine {
    UIImageView *separateLine = [[[UIImageView alloc] initWithFrame:CGRectMake(24, 223, 272, 27)] autorelease];
//  if (APP_ID == 1) {
//        separateLine.image = [UIImage imageNamed:@"y_share_separate_line"];
//    }else{
        separateLine.image = [UIImage imageNamed:@"share_separate_line"];
//    }
    [self addSubview:separateLine];
}

- (void)addQRCodeView {
    self.qrImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(119, 260, 82, 82)] autorelease];
    self.qrImageView.backgroundColor = [UIColor clearColor];
//    if (APP_ID == 1) {
//        self.qrImageView.image = [UIImage imageNamed:@"y_share_qrcode"];
//    }else{
        self.qrImageView.image = [UIImage imageNamed:@"share_qrcode"];
//    }
    [self addSubview:self.qrImageView];
}

- (void)addCancelButton {
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.exclusiveTouch = YES;
    UIImage *image = [UIImage imageNamed:@"greyline_button"];
    [cancelButton setBackgroundImage:[image stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(15, self.frame.size.height - 50, 288, 36);
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:RGBColor(136, 136, 136, 1) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:cancelButton];
    
}

- (void)itemPressed:(id)sender {
    [self dismissModalView];
    BBShareMenuItem *item = (BBShareMenuItem *)sender;
    if (item && self.delegate && [self.delegate respondsToSelector:@selector(shareMenu:clickItem:)]) {
        [self.delegate shareMenu:self clickItem:item];
    }
}

- (void)cancel {
    [self dismissModalView];
}

- (void)show {
//    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
     UIWindow * keywindow = [[[UIApplication sharedApplication] delegate] window];
    if (![keywindow.subviews containsObject:self]) {
        CGRect sf = self.frame;
        CGRect vf = keywindow.frame;
        CGRect f  = CGRectMake(0, vf.size.height-sf.size.height, vf.size.width, sf.size.height);
        CGRect of = CGRectMake(0, 0, vf.size.width, vf.size.height-sf.size.height);
        
        UIView * overlay = [[[UIView alloc] initWithFrame:keywindow.bounds] autorelease];
        overlay.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
        overlay.tag = 20000;

        [keywindow addSubview:overlay];
        
        UIControl * dismissButton = [[[UIControl alloc] initWithFrame:CGRectZero] autorelease];
        [dismissButton addTarget:self action:@selector(dismissModalView) forControlEvents:UIControlEventTouchUpInside];
        dismissButton.backgroundColor = [UIColor clearColor];
        dismissButton.frame = of;
        [overlay addSubview:dismissButton];
        
        self.frame = CGRectMake(0, vf.size.height, vf.size.width, sf.size.height);
        [keywindow addSubview:self];
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0, -2);
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.8;
        self.tag = 30000;
        [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
            self.frame = f;
        }];
        [self performSelector:@selector(changeImage) withObject:nil afterDelay:.4];
    }
}

- (void)changeImage {
    if ([BBUser isLogin]) {
        [self.qrImageView setImageWithURL:[NSURL URLWithString:self.qrUrl] placeholderImage:[UIImage imageNamed:@"share_qrcode"]];
    }
}

- (void)dismissModalView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeMenu:)]) {
        [self.delegate closeMenu:self];
    }
//    UIWindow * keywindow = [[UIApplication sharedApplication] keyWindow];
    UIWindow * keywindow = [[[UIApplication sharedApplication] delegate] window];
    UIView *overlay = [keywindow viewWithTag:20000];
    UIView *_self = [keywindow viewWithTag:30000];
    [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
        _self.frame = CGRectMake(0, keywindow.frame.size.height, _self.frame.size.width, _self.frame.size.height);
    } completion:^(BOOL finished) {
        [overlay removeFromSuperview];
        [_self removeFromSuperview];
    }];
    
}


@end
