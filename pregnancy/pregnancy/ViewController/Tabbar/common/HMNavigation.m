//
//  wiNavigationBarView.m
//  wiIos
//
//  Created by Dengjiang on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "HMNavigation.h"
#import "FXLabel.h"
#import "JSBadgeView.h"
#import <objc/runtime.h>

#define TITLE_WIDTH1                180
#define TITLE_WIDTH2                150
#define TITLE_TAG                   100
#define NAV_BG_TAG                  101
#define NAV_LEFTBTN_TAG             102
//#define NAV_RIGHTBTN_TAG            103
#define NAV_MESSAGETIPS_LABEL_TAG   104
#define NAV_JSBADGEVIEW_TAGADD      10
#ifndef IOS_VERSION
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

/*
#if (__IPHONE_7_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0)
static char TAG_BACKGROUNDVIEW_INDICATOR;

@interface UINavigationController (Private)

- (void)createBackGroundViewWithColor:(UIColor *)color;
- (void)removeBackGroundView;

@end

@implementation UINavigationController (StatusBarBackGround)
@dynamic backGroundView;

- (UIView *)backGroundView
{
    return (UIView *)objc_getAssociatedObject(self, &TAG_BACKGROUNDVIEW_INDICATOR);
}

- (void)setBackGroundView:(UIView *)backView
{
    objc_setAssociatedObject(self, &TAG_BACKGROUNDVIEW_INDICATOR, backView, OBJC_ASSOCIATION_RETAIN);
}

- (void)createBackGroundViewWithColor:(UIColor *)color
{
    if (self.backGroundView == nil)
    {
        self.backGroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 20)] autorelease];
        self.backGroundView.backgroundColor = color;
        [self.view addSubview:self.backGroundView];
    }
}

- (void)removeBackGroundView
{
    if (self.backGroundView && self.backGroundView.superview)
    {
        [self.backGroundView removeFromSuperview];
    }
}

@end

#endif
*/

@implementation UIViewController (HMNavigationBarView)

- (void)setNavigationContainerViewTop:(CGFloat)top
{
    UIView * containerView = [[self.navigationController.view subviews] objectAtIndex:0];
    containerView.top = top;
}

- (void)clearNavBar
{
    for (int i = TITLE_TAG; i <= NAV_MESSAGETIPS_LABEL_TAG; i++)
    {
        UIView *view = [self.navigationController.navigationBar viewWithTag:i];
        
        if (view && view.superview)
        {
            [view removeFromSuperview];
        }
    }
}

- (void)setNavBar:(NSString *)title bgColor:(UIColor *)bgColor leftTitle:(NSString *)ltitle leftBtnImage:(NSString *)lBImage leftToucheEvent:(SEL)aLSelector rightTitle:(NSString *)rtitle rightBtnImage:(NSString *)rBImage rightToucheEvent:(SEL)aRSelector
{
    self.navigationItem.title = title;
    
    FXLabel *titleLabel = nil;
    
    // 设置标题
    if ([title isNotEmpty])
    {
//        titleLabel = [[[FXLabel alloc] initWithFrame:CGRectMake(0, 0, TITLE_WIDTH1, UI_NAVIGATION_BAR_HEIGHT)] autorelease];
//        [titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
//        titleLabel.minimumScaleFactor = 0.7f;
//        titleLabel.adjustsFontSizeToFitWidth = YES;
//        [titleLabel setText:title];
//        [titleLabel setTextAlignment:NSTextAlignmentCenter];
//        [titleLabel setBackgroundColor:[UIColor clearColor]];
//        [titleLabel setTextColor:[UIColor whiteColor]];
//        titleLabel.contentMode = UIViewContentModeTop;
//        titleLabel.textInsets = UIEdgeInsetsMake(10.0f, 0.0f, 0.0f, 0.0f);
//        titleLabel.tag = TITLE_TAG;
        titleLabel = [[FXLabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
        [titleLabel setFont:[UIFont systemFontOfSize:22]];
        [titleLabel setText:title];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setMinimumScaleFactor:14.0/22.0];
        titleLabel.adjustsFontSizeToFitWidth=YES;
        titleLabel.tag = TITLE_TAG;
    }
    
    [self setNavBarTitleView:titleLabel bgColor:bgColor leftTitle:ltitle leftBtnImage:lBImage leftToucheEvent:aLSelector rightTitle:rtitle rightBtnImage:rBImage rightToucheEvent:aRSelector];
}

- (void)setNavBarTitleView:(UIView *)titleView bgColor:(UIColor *)bgColor leftTitle:(NSString *)ltitle leftBtnImage:(NSString *)lBImage leftToucheEvent:(SEL)aLSelector rightTitle:(NSString *)rtitle rightBtnImage:(NSString *)rBImage rightToucheEvent:(SEL)aRSelector
{
    [self.navigationItem setHidesBackButton:YES];
    
    // 背景
    if (bgColor)
    {
#if (__IPHONE_7_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0)
        if (IOS_VERSION >= 7.0)
        {
            self.navigationController.navigationBar.barTintColor = bgColor;
        }
        else
        {
            self.navigationController.navigationBar.tintColor = bgColor;
            UIImage *bgimg = [UIImage imageWithColor:bgColor size:CGSizeMake(1, 44)];
            [self.navigationController.navigationBar setBackgroundImage:bgimg forBarMetrics:UIBarMetricsDefault];
        }
#endif
    }
    else
    {
#if (__IPHONE_7_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0)
        if (IOS_VERSION >= 7.0)
        {
            self.navigationController.navigationBar.barTintColor = UI_NAVIGATION_BGCOLOR;
        }
        else
        {
            self.navigationController.navigationBar.tintColor = UI_NAVIGATION_BGCOLOR;
            UIImage *bgimg = [UIImage imageWithColor:UI_NAVIGATION_BGCOLOR size:CGSizeMake(1, 44)];
            [self.navigationController.navigationBar setBackgroundImage:bgimg forBarMetrics:UIBarMetricsDefault];
        }
#endif
    }

    // 设置标题
    if (titleView)
    {
        [self.navigationItem setTitleView:titleView];
    }
    
    // 设置左按键
    if(aLSelector != nil)
    {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn addTarget:self action:aLSelector forControlEvents:UIControlEventTouchUpInside];
        leftBtn.tag = NAV_LEFTBTN_TAG;

        if (ltitle != nil)
        {
            [leftBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            CGSize size = [ltitle sizeWithFont:leftBtn.titleLabel.font constrainedToSize:CGSizeMake(100, 44) lineBreakMode:leftBtn.titleLabel.lineBreakMode];
            if (size.width<44 && IOS_VERSION < 7.0)
            {
                size.width = 44;
            }
            leftBtn.frame = CGRectMake(0, 0, size.width, size.height);
            [leftBtn setTitle:ltitle forState:UIControlStateNormal];
            [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else if (lBImage)
        {
//            if (IOS_VERSION >= 7.0)
//            {
//                NSString *newLBImage = [lBImage stringByAppendingString:@"_ios7"];
//                if ([[UIImage imageNamed:newLBImage] isNotEmpty])
//                {
//                    lBImage = newLBImage;
//                }
//            }
            UIImage *image = [UIImage imageNamed:lBImage];
            leftBtn.Frame = CGRectMake(0, 0, image.size.width, image.size.height);
            [leftBtn setBackgroundImage:image forState:UIControlStateNormal];
//            NSString *llBimage = [lBImage stringByAppendingString:@"(press)"];
            [leftBtn setBackgroundImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
        }
        
        UIBarButtonItem * lButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = lButtonItem;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }

    // 设置右按键
    if (aRSelector != nil)
    {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [rightBtn addTarget:self action:aRSelector forControlEvents:UIControlEventTouchUpInside];
        
        rightBtn.tag = NAV_RIGHTBTN_TAG;
        
        if (rtitle != nil)
        {
            [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            CGSize size = [rtitle sizeWithFont:rightBtn.titleLabel.font constrainedToSize:CGSizeMake(100, 44) lineBreakMode:rightBtn.titleLabel.lineBreakMode];
            if (size.width<44 && IOS_VERSION < 7.0)
            {
                size.width = 44;
            }
            rightBtn.frame = CGRectMake(0, 0, size.width, size.height);

            [rightBtn setTitle:rtitle forState:UIControlStateNormal];
            [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else if (rBImage)
        {
//            if (IOS_VERSION >= 7.0)
//            {
//                NSString *newRBImage = [rBImage stringByAppendingString:@"_ios7"];
//                if ([[UIImage imageNamed:newRBImage] isNotEmpty])
//                {
//                    rBImage = newRBImage;
//                }
//            }

            UIImage *image = [UIImage imageNamed:rBImage];
            rightBtn.frame = CGRectMake(0, -20, image.size.width, image.size.height);
            [rightBtn setBackgroundImage:image forState:UIControlStateNormal];
//            NSString *rlBimage = [rBImage stringByAppendingString:@"(press)"];
//            [rightBtn setBackgroundImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
        }

        UIBarButtonItem * rButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rButtonItem;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)setNavBar:(NSString *)title bgColor:(UIColor *)bgColor leftTitle:(NSString *)ltitle leftBtnImage:(NSString *)lBImage leftToucheEvent:(SEL)aLSelector rightDicArray:(NSArray *)array
{
    self.navigationItem.title = title;
    
    FXLabel *titleLabel = nil;
    
    // 设置标题
    if ([title isNotEmpty])
    {
//        titleLabel = [[[FXLabel alloc] initWithFrame:CGRectMake(0, 0, TITLE_WIDTH2, UI_NAVIGATION_BAR_HEIGHT)] autorelease];
//        [titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
//        titleLabel.minimumScaleFactor = 0.7f;
//        titleLabel.adjustsFontSizeToFitWidth = YES;
//        [titleLabel setText:title];
//        [titleLabel setTextAlignment:NSTextAlignmentCenter];
//        [titleLabel setBackgroundColor:[UIColor clearColor]];
//        [titleLabel setTextColor:[UIColor whiteColor]];
//        titleLabel.contentMode = UIViewContentModeTop;
//        titleLabel.textInsets = UIEdgeInsetsMake(10.0f, 0.0f, 0.0f, 0.0f);
//        titleLabel.tag = TITLE_TAG;
        titleLabel = [[FXLabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
        [titleLabel setFont:[UIFont systemFontOfSize:22]];
        [titleLabel setText:title];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setMinimumScaleFactor:14.0/22.0];
        titleLabel.adjustsFontSizeToFitWidth=YES;
        titleLabel.tag = TITLE_TAG;
    }
    
    [self setNavBarTitleView:titleLabel bgColor:bgColor leftTitle:ltitle leftBtnImage:lBImage leftToucheEvent:aLSelector rightDicArray:array];
}

- (void)setNavBarTitleView:(UIView *)titleView bgColor:(UIColor *)bgColor leftTitle:(NSString *)ltitle leftBtnImage:(NSString *)lBImage leftToucheEvent:(SEL)aLSelector rightDicArray:(NSArray *)array
{
    [self.navigationItem setHidesBackButton:YES];
    
    // 背景
    if (bgColor)
    {
#if (__IPHONE_7_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0)
        if (IOS_VERSION >= 7.0)
        {
            self.navigationController.navigationBar.barTintColor = bgColor;
        }
        else
        {
            self.navigationController.navigationBar.tintColor = bgColor;
            UIImage *bgimg = [UIImage imageWithColor:bgColor size:CGSizeMake(1, 44)];
            [self.navigationController.navigationBar setBackgroundImage:bgimg forBarMetrics:UIBarMetricsDefault];
        }
#endif
    }
    else
    {
#if (__IPHONE_7_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0)
        if (IOS_VERSION >= 7.0)
        {
            self.navigationController.navigationBar.barTintColor = UI_NAVIGATION_BGCOLOR;
        }
        else
        {
            self.navigationController.navigationBar.tintColor = UI_NAVIGATION_BGCOLOR;
            UIImage *bgimg = [UIImage imageWithColor:UI_NAVIGATION_BGCOLOR size:CGSizeMake(1, 44)];
            [self.navigationController.navigationBar setBackgroundImage:bgimg forBarMetrics:UIBarMetricsDefault];
        }
#endif
    }

    // 设置标题
    if (titleView)
    {
        [self.navigationItem setTitleView:titleView];
    }
        
    // 设置左按键
    if(aLSelector != nil)
    {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        if (IOS_VERSION >= 7.0)
//        {
//            lBImage = [NSString stringWithFormat:@"%@_ios7",lBImage];
//        }

        UIImage *image = [UIImage imageNamed:lBImage];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        leftBtn.Frame = frame;
        [leftBtn setImage:image forState:UIControlStateNormal];
//        NSString *llBimage = [lBImage stringByAppendingString:@"(press)"];
        [leftBtn setImage:[UIImage imageNamed:@"backButtonpress"] forState:UIControlStateHighlighted];
        [leftBtn addTarget:self action:aLSelector forControlEvents:UIControlEventTouchUpInside];
        
        leftBtn.tag = NAV_LEFTBTN_TAG;
        
        if (ltitle != nil)
        {
            [leftBtn setTitle:ltitle forState:UIControlStateNormal];
            [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        }
        
        UIBarButtonItem * lButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = lButtonItem;
    }
    
    // 设置右按键
    if ([array isNotEmpty])
    {
        NSMutableArray *btnArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSInteger index = 0;
        for (NSDictionary *dic in array)
        {
            NSString *rBImage = [dic objectForKey:NAV_RIGHTBTN_IMAGE_KEY];
//            if (IOS_VERSION >= 7.0)
//            {
//                NSString *newRBImage = [rBImage stringByAppendingString:@"_ios7"];
//                if ([[UIImage imageNamed:newRBImage] isNotEmpty])
//                {
//                    rBImage = newRBImage;
//                }
//            }
            NSString *rtitle = [dic objectForKey:NAV_RIGHTBTN_TITLE_KEY];
            SEL aRSelector = NSSelectorFromString([dic objectForKey:NAV_RIGHTBTN_SELECTOR_KEY]);
            
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *image = [UIImage imageNamed:rBImage];
            CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
            rightBtn.Frame = frame;
            [rightBtn setBackgroundImage:image forState: UIControlStateNormal];
//            NSString *rlBimage = [rBImage stringByAppendingString:@"(press)"];
//            [rightBtn setBackgroundImage:[UIImage imageNamed:@"backButtonPress"] forState:UIControlStateHighlighted];
            
            [rightBtn addTarget:self action:aRSelector forControlEvents:UIControlEventTouchUpInside];
            
            NSString *tagStr = [dic objectForKey:NAV_RIGHTBTN_TAG_KEY];
            NSInteger tag = 0;
            
            if ([tagStr isNotEmpty])
            {
                tag = NAV_RIGHTBTN_TAG + [tagStr integerValue];
            }
            
            if (tag)
            {
                rightBtn.tag = tag;
            }
            else
            {
                rightBtn.tag = NAV_RIGHTBTN_TAG+index;
            }
            index++;
            
            if (rtitle != nil)
            {
                [rightBtn setTitle:rtitle forState:UIControlStateNormal];
                [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            }
            UIBarButtonItem * rButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
            [btnArray addObject:rButtonItem];
        }
        
        self.navigationItem.rightBarButtonItems = btnArray;
    }
}

- (void)setNavTitle:(NSString *)title
{
    if ([self.navigationItem.titleView isKindOfClass:[FXLabel class]])
    {
        FXLabel *label = (FXLabel *)self.navigationItem.titleView;
        
        self.navigationItem.title = title;
        label.text = title;
    }
    else if (title)
    {
        FXLabel *titleLabel = [[FXLabel alloc] initWithFrame:CGRectMake(0, 0, TITLE_WIDTH1, UI_NAVIGATION_BAR_HEIGHT)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
        titleLabel.minimumScaleFactor = 0.7f;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [titleLabel setText:title];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        titleLabel.contentMode = UIViewContentModeTop;
        titleLabel.textInsets = UIEdgeInsetsMake(10.0f, 0.0f, 0.0f, 0.0f);
        titleLabel.tag = TITLE_TAG;

        [self.navigationItem setTitleView:titleLabel];
    }
}

- (void)changeTitleNotSetVc:(NSString *)title
{
    if ([self.navigationItem.titleView isKindOfClass:[FXLabel class]])
    {
        FXLabel *label = (FXLabel *)self.navigationItem.titleView;
        
        label.text = title;
    }
    else if (title)
    {
        FXLabel *titleLabel = [[FXLabel alloc] initWithFrame:CGRectMake(0, 0, TITLE_WIDTH1, UI_NAVIGATION_BAR_HEIGHT)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
        titleLabel.minimumScaleFactor = 0.7f;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [titleLabel setText:title];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        titleLabel.contentMode = UIViewContentModeTop;
        titleLabel.textInsets = UIEdgeInsetsMake(10.0f, 0.0f, 0.0f, 0.0f);
        titleLabel.tag = TITLE_TAG;
        
        [self.navigationItem setTitleView:titleLabel];
    }
}

- (UIButton *)getRightBtnAtIndex:(NSInteger)index
{
    if (index < self.navigationItem.rightBarButtonItems.count)
    {
        UIBarButtonItem *buttonItem = [self.navigationItem.rightBarButtonItems objectAtIndex:index];
        return (UIButton *)buttonItem.customView;
    }
    else
    {
        UIBarButtonItem *buttonItem = self.navigationItem.rightBarButtonItem;
        if ( buttonItem != nil)
        {
            return (UIButton *)buttonItem.customView;
        }
        
        return nil;
    }
}

//[self setRightBtnBadge:1 color:nil offset:CGPointMake(0, 12) showText:NO];
// 设置badge
- (void)setRightBtnBadge:(NSInteger)badgeValue
{
    [self setRightBtnBadge:badgeValue color:nil offset:CGPointZero showText:YES];
}

- (void)setRightBtnBadge:(NSInteger)badgeValue color:(UIColor *)badgeColor offset:(CGPoint)offset showText:(BOOL)bShowText
{
    UIButton *btn = [self getRightBtnAtIndex:0];

    UIView* view = [btn viewWithTag:btn.tag+NAV_JSBADGEVIEW_TAGADD];
    if (view != nil && [view isKindOfClass:[JSBadgeView class]])
    {
        if (0 == badgeValue)
        {
            [view removeFromSuperview];
            [btn setNeedsDisplay];
        }
        else
        {
            JSBadgeView *badgeView = (JSBadgeView *)view;
            badgeView.badgeText = [NSString stringWithFormat:@"%d", badgeValue];
            if (badgeColor != nil)
            {
                badgeView.badgeTextColor = badgeColor;
            }
            badgeView.badgePositionAdjustment = offset;
            badgeView.showText = bShowText;
        }
    }
    else
    {
        if (0 == badgeValue)
        {
            return;
        }
        
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:btn alignment:JSBadgeViewAlignmentTopRight];
        badgeView.badgeText = [NSString stringWithFormat:@"%d", badgeValue];
        if (badgeColor != nil)
        {
            badgeView.badgeTextColor = badgeColor;
        }
        badgeView.badgePositionAdjustment = offset;
        badgeView.showText = bShowText;
//        badgeView.badgeBackgroundColor = [UIColor blueColor];
    }
}

// 删除badge
- (void)delRightBtnBadge
{
    UIButton *btn = [self getRightBtnAtIndex:0];
    
    UIView* view = [btn viewWithTag:btn.tag+NAV_JSBADGEVIEW_TAGADD];
    if (view != nil && [view isKindOfClass:[JSBadgeView class]])
    {
        [view removeFromSuperview];
        [btn setNeedsDisplay];
    }
}


@end
