//
//  wiNavigationBarView.h
//  wiIos
//
//  Created by Dengjiang on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MESSAGETIPSLABEL_DELAYTIME  0.8
#define NAV_RIGHTBTN_TAG            103

#define NAV_RIGHTBTN_IMAGE_KEY      @"image"
#define NAV_RIGHTBTN_TITLE_KEY      @"title"
#define NAV_RIGHTBTN_SELECTOR_KEY   @"selector"
#define NAV_RIGHTBTN_TAG_KEY        @"tag"

/*
#if (__IPHONE_7_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0)
@interface UINavigationController (StatusBarBackGround)

@property (nonatomic, retain) UIView *backGroundView;

@end
#endif
*/

@interface UIViewController (HMNavigationBarView)

- (void)setNavigationContainerViewTop:(CGFloat)top;

- (void)clearNavBar;

- (void)setNavBar:(NSString *)title bgColor:(UIColor *)bgColor leftTitle:(NSString *)ltitle leftBtnImage:(NSString *)lBImage leftToucheEvent:(SEL)aLSelector rightTitle:(NSString *)rtitle rightBtnImage:(NSString *)rBImage rightToucheEvent:(SEL)aRSelector;

- (void)setNavBarTitleView:(UIView *)titleView bgColor:(UIColor *)bgColor leftTitle:(NSString *)ltitle leftBtnImage:(NSString *)lBImage leftToucheEvent:(SEL)aLSelector rightTitle:(NSString *)rtitle rightBtnImage:(NSString *)rBImage rightToucheEvent:(SEL)aRSelector;

- (void)setNavBar:(NSString *)title bgColor:(UIColor *)bgColor leftTitle:(NSString *)ltitle leftBtnImage:(NSString *)lBImage leftToucheEvent:(SEL)aLSelector rightDicArray:(NSArray *)array;

- (void)setNavBarTitleView:(UIView *)titleView bgColor:(UIColor *)bgColor leftTitle:(NSString *)ltitle leftBtnImage:(NSString *)lBImage leftToucheEvent:(SEL)aLSelector rightDicArray:(NSArray *)array;

- (UIButton *)getRightBtnAtIndex:(NSInteger)index;

- (void)setNavTitle:(NSString *)title;
- (void)changeTitleNotSetVc:(NSString *)title;

// 设置badge
- (void)setRightBtnBadge:(NSInteger)badgeValue;
- (void)setRightBtnBadge:(NSInteger)badgeValue color:(UIColor *)badgeColor offset:(CGPoint)offset showText:(BOOL)bShowText;
// 删除badge
- (void)delRightBtnBadge;

@end
