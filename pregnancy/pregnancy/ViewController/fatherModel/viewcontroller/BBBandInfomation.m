//
//  BBBandInfomation.m
//  pregnancy
//
//  Created by whl on 14-4-14.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBBandInfomation.h"
#import "BBInvitePapaViewController.h"

@interface BBBandInfomation ()

@end

@implementation BBBandInfomation

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
    self.title = @"绑定信息";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.title]];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    self.m_FillButton.exclusiveTouch = YES;
    self.m_InviteButton.exclusiveTouch = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clickedInviteFather:(id)sender
{
    [MobClick event:@"invite_husband_v2" label:@"绑定信息-我是准妈妈"];
    BBInvitePapaViewController *inviteView = [[BBInvitePapaViewController alloc] initWithNibName:@"BBInvitePapaViewController" bundle:nil];
    [self.navigationController pushViewController:inviteView animated:YES];
}
-(IBAction)clickedFillCode:(id)sender
{
    [MobClick event:@"invite_husband_v2" label:@"绑定信息-我是准爸爸"];
    BBFillBandCode *fillCode = [[BBFillBandCode alloc] initWithNibName:@"BBFillBandCode" bundle:nil];
    fillCode.delegate = self;
    [self.navigationController pushViewController:fillCode animated:YES];
}

-(void)closeFillBandCodeView
{
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate closeBandInfomationView];
}

@end
