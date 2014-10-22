//
//  BaseViewController.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-12-23.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()
@property (nonatomic , assign) BOOL m_visible;

@end

@implementation BaseViewController


- (void)viewDidLoad
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.extendedLayoutIncludesOpaqueBars = NO;
        
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
#endif
//    self.view.backgroundColor = commonBgColor;
    [super viewDidLoad];
    // 隐藏系统的返回按钮
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
  self.view.backgroundColor = UI_VIEW_BGCOLOR;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    _m_visible = YES;
     [self.navigationController setNavigationBarHidden:NO];
#ifdef DEBUG
    NSLog(@"页面 %@",[self class]);
#endif
    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@",[self class]]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    _m_visible = NO;
    [MobClick endLogPageView:[NSString stringWithFormat:@"%@",[self class]]];
}

-(BOOL)isVisible
{
    return _m_visible;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backAction:(id)sender
{
    BBAppDelegate *appDelegate = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
    if(appDelegate.m_bobyBornFinish)
    {
        // 跳转到我的圈
        for (UINavigationController *nav in self.navigationController.viewControllers)
        {
            [nav dismissViewControllerAnimated:NO completion:^{
                
            }];
        }

        if (!appDelegate.m_mainTabbar)
        {
            appDelegate.m_mainTabbar = [[BBMainTabBar alloc]init];
        }
        [appDelegate.m_mainTabbar addViewControllers];
        [appDelegate.m_mainTabbar selectedTabWithIndex:1];
        appDelegate.window.rootViewController = appDelegate.m_mainTabbar;
        appDelegate.m_bobyBornFinish = NO;
    }
    else
    {
       [self.navigationController popViewControllerAnimated:YES];
    }
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

//lijie 修改不支持旋转 6.0
- (BOOL)shouldAutorotate
{
    return NO;
}
//lijie 修改不支持旋转 6.0
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
