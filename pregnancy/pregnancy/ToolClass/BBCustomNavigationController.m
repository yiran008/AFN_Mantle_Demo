//
//  CustomNavigationController.m
//  TudouDownloader
//
//  Created by 张 中峰 on 12-12-3.
//  Copyright (c) 2012年 张 中峰. All rights reserved.
//

#import "BBCustomNavigationController.h"

@interface BBCustomNavigationController ()

@end

@implementation BBCustomNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
