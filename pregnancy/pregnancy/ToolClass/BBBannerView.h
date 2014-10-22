//
//  HMBannerView.h
//  HMBannerViewDemo
//
//  Created by Dennis on 13-12-31.
//  Copyright (c) 2013年 Babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

#define BANNER_APEAR_NOTIFICATION @"BANNER_APEAR_NOTIFICATION"

typedef NS_ENUM(NSInteger, BannerViewScrollDirection)
{
    // 水平滚动
    ScrollDirectionLandscape,
    // 垂直滚动
    ScrollDirectionPortait
};

typedef NS_ENUM(NSInteger, BannerViewPageStyle)
{
    PageStyle_None,
    PageStyle_Left,
    PageStyle_Right,
    PageStyle_Middle
};


@protocol BBBannerViewDelegate;

@interface BBBannerView : UIView
<
    UIScrollViewDelegate,
    SDWebImageManagerDelegate
>
{
    UIScrollView *scrollView;
    UIButton *BannerCloseButton;

    NSInteger totalPage;
    NSInteger curPage;
}

@property (nonatomic, assign) id <BBBannerViewDelegate> delegate;

// 存放所有需要滚动的图片URL NSString
@property (nonatomic, retain) NSArray *imagesArray;
// scrollView滚动的方向
@property (nonatomic, assign) BannerViewScrollDirection scrollDirection;

@property (nonatomic, assign) NSTimeInterval rollingDelayTime;

- (id)initWithFrame:(CGRect)frame scrollDirection:(BannerViewScrollDirection)direction images:(NSArray *)images;

- (void)reloadBannerWithData:(NSArray *)images;

- (void)startDownloadImage;
- (void)setSquare:(NSInteger)asquare;
- (void)setPageControlStyle:(BannerViewPageStyle)pageStyle;

- (void)startRolling;
- (void)stopRolling;

- (void)showClose:(BOOL)show;

@end

@protocol BBBannerViewDelegate <NSObject>

- (void)imageCachedDidFinish:(BBBannerView *)bannerView;

@optional
- (void)bannerView:(BBBannerView *)bannerView didSelectImageView:(NSInteger)index withData:(NSDictionary *)bannerData;

- (void)bannerViewdidClosed:(BBBannerView *)bannerView;

- (void)bannerView:(BBBannerView *)bannerView didDisplayPage:(NSInteger)index withData:(NSDictionary *)bannerData;

@end
