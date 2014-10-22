//
//  BBTermsOfUse.m
//  pregnancy
//
//  Created by Jun Wang on 12-4-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBTermsOfUse.h"
#import "BBNavigationLabel.h"
#import "BBApp.h"
#import "BBAppConfig.h"
#import "MobClick.h"
#import "BBAppDelegate.h"
#import "BBAppInfo.h"

@implementation BBTermsOfUse

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"使用条款";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]];
    
    UIWebView *termsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, -5, 320, IPHONE5_ADD_HEIGHT(416+5))];
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:sourcePath];
     NSURL *url = nil;
    if (isExist)
    {
        url = [NSURL fileURLWithPath:sourcePath isDirectory:NO];
    }
    if ([url isNotEmpty]) {
        [termsWebView loadRequest:[NSURLRequest requestWithURL:url]];
        [termsWebView setDataDetectorTypes:UIDataDetectorTypeNone];
    }
    [termsWebView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:termsWebView];

    IPHONE5_ADAPTATION
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
//    BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate switchNightModeStatus:[BBAppInfo nightModeStatus]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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


#pragma mark - IBAction Event Handler Mehthod

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
