//
//  UINavigationController+BackgroundColor.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-12-31.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "UINavigationController+BackgroundColor.h"
#import "BBApp.h"

@implementation UINavigationController (BackgroundColor)
- (void)setColorWithImageName:(NSString *)imageName
{
    if ([imageName isEqualToString:@"y_navigationBg"]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0

            self.navigationBar.barTintColor = ParentingColor;
            self.navigationBar.translucent = NO;
#endif
        }else {
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:imageName] forBarMetrics:UIBarMetricsDefault];
        }
    }else if ([imageName isEqualToString:@"navigationBg"]){
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0

            self.navigationBar.barTintColor = PregnancyColor;
            self.navigationBar.translucent = NO;
#endif
        }else {
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:imageName] forBarMetrics:UIBarMetricsDefault];
        }
    }else if ([imageName isEqualToString:@"father_main_nav_bg"]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0

            self.navigationBar.barTintColor = PregnancyBabaColor;
            self.navigationBar.translucent = NO;
#endif
        }else {
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:imageName] forBarMetrics:UIBarMetricsDefault];
        }
    }
}

- (void)setPregnancyColor
{

    [self setColorWithImageName:@"navigationBg"];
}
@end
