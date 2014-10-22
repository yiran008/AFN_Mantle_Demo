//
//  BBUmengRecommendApp.m
//  pregnancy
//
//  Created by babytree babytree on 12-8-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBUmengRecommendApp.h"
#import "BBNavigationLabel.h"
#import "BBApp.h"
#import "BBAppConfig.h"
#import "MobClick.h"

@interface BBUmengRecommendApp ()

@end

@implementation BBUmengRecommendApp

@synthesize umengAdView;

- (void)dealloc
{
    [umengAdView release];
   
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"应用推荐";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"应用推荐"];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    self.umengAdView = [[[BBUmengAdView alloc]initWithFrame:CGRectMake(0, 0, 320, 416) withKeywords:@"babytree" withIsAtuoFill:NO]autorelease];
    [self.view addSubview:umengAdView];
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    //iphone5适配
    IPHONE5_ADAPTATION
    if (IS_IPHONE5) {
        [self.umengAdView setFrame:CGRectMake(self.umengAdView.frame.origin.x, self.umengAdView.frame.origin.y, self.umengAdView.frame.size.width, self.umengAdView.frame.size.height + 88)];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction Event Handler Method

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end