//
//  BBUserRecordMoon.m
//  pregnancy
//
//  Created by zhangzhongfeng on 14-1-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBUserRecordMoon.h"
#import "BBNavigationLabel.h"
#import "BBApp.h"

@interface BBUserRecordMoon ()

@end

@implementation BBUserRecordMoon

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"心情记录";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    self.recordMoonView = [[BBRecordMoonView alloc]initWithFrame:CGRectMake(0, 0, 320, IPHONE5_ADD_HEIGHT(416))];
    self.recordMoonView.tableView.tableHeaderView = nil;
    self.recordMoonView.userEncodeId = self.userEncodeId;
    self.recordMoonView.isUserRecord = YES;
    [self.view addSubview:self.recordMoonView];
    if ([self.recordMoonView.dataArray count]==0) {
        [self.recordMoonView refresh];
    }

}
-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

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
