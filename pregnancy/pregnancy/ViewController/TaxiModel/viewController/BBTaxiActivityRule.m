//
//  BBTaxiActivityRule.m
//  pregnancy
//
//  Created by whl on 13-12-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBTaxiActivityRule.h"
#import "BBKuaidiVerificationViewController.h"
#import "BBCallTaxiRequest.h"
#import "BBTaxiLocationData.h"

@interface BBTaxiActivityRule ()
@property (nonatomic, strong) UIButton *rightItemButton;
@end

@implementation BBTaxiActivityRule

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_activityRule release];
    [_contentHtml release];
    [_rightStatus release];
    [_rightItemButton release];
    [_loadProgress release];
    [_competenceRequest clearDelegatesAndCancel];
    [_competenceRequest release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activityStatusRefresh) name:@"activityStatusRefresh" object:nil];
    }
    return self;
}

- (void)activityStatusRefresh
{
    self.rightStatus = @"0";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"打车返现活动说明"];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    
    self.rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightItemButton.exclusiveTouch = YES;
    [self.rightItemButton setFrame:CGRectMake(0, 0, 72, 34)];
    self.rightItemButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.rightItemButton setTitle:@"我要参加" forState:UIControlStateNormal];
    [self.rightItemButton setBackgroundColor:[UIColor clearColor]];
    [self.rightItemButton addTarget:self action:@selector(checkUserStatus:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightItemButton setHidden:YES];
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.rightItemButton];
    [self.navigationItem setRightBarButtonItem:commitBarButton];
    [commitBarButton release];
    [self.activityRule loadHTMLString:self.contentHtml baseURL:nil];
    
    self.loadProgress = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:self.loadProgress];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([self.rightStatus isEqualToString:@"2"])
    {
        [self.rightItemButton setHidden:YES];
    }else{
        [self.rightItemButton setHidden:NO];
    }

    [super viewWillAppear:animated];
}



- (IBAction)checkUserStatus:(id)sender
{
    if ([self.rightStatus isEqualToString:@"false"])
    {
        [self taxiCompetenceRequest];
    }
    else 
    {
        BBKuaidiVerificationViewController *kuaidiVerificationView = [[[BBKuaidiVerificationViewController alloc]initWithNibName:@"BBKuaidiVerificationViewController" bundle:nil]autorelease];
        kuaidiVerificationView.isApplied = YES;
        [self.navigationController pushViewController:kuaidiVerificationView animated:YES];
    }
}


-(void)taxiCompetenceRequest
{
    [self.loadProgress setLabelText:@"加载中..."];
    [self.loadProgress show:YES];
    [self.competenceRequest clearDelegatesAndCancel];
    self.competenceRequest = [BBCallTaxiRequest taxiCompetence:[BBTaxiLocationData getCurrentLongitudeString] withLatitude:[BBTaxiLocationData getCurrentLatitudeString]];
    [self.competenceRequest setDidFinishSelector:@selector(taxiCompetenceFinish:)];
    [self.competenceRequest setDidFailSelector:@selector(taxiCompetenceFail:)];
    [self.competenceRequest setDelegate:self];
    [self.competenceRequest startAsynchronous];
    
}
- (void)taxiCompetenceFinish:(ASIFormDataRequest *)request
{
    [self.loadProgress hide:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *jsonData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[jsonData stringForKey:@"status"] isEqualToString:@"success"]) {
        //返回数据成功
        BBKuaidiVerificationViewController *kuaidiVerificationView = [[[BBKuaidiVerificationViewController alloc]initWithNibName:@"BBKuaidiVerificationViewController" bundle:nil]autorelease];
        kuaidiVerificationView.isApplied = NO;
        [self.navigationController pushViewController:kuaidiVerificationView animated:YES];
        
    }else{
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)taxiCompetenceFail:(ASIFormDataRequest *)request
{
    [self.loadProgress hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}
@end
