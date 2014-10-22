//
//  BBSelectRegisterController.m
//  pregnancy
//
//  Created by whl on 13-10-23.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBSelectRegisterController.h"
#import "BBApp.h"
#import "BBNavigationLabel.h"
#import "MobClick.h"


@interface BBSelectRegisterController ()

@end

@implementation BBSelectRegisterController

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
    self.navigationItem.title = @"注册";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    ((UIButton*)[self.view viewWithTag:110]).exclusiveTouch = YES;
    ((UIButton*)[self.view viewWithTag:111]).exclusiveTouch = YES;
    ((UIButton*)[self.view viewWithTag:112]).exclusiveTouch = YES;
    ((UIButton*)[self.view viewWithTag:113]).exclusiveTouch = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)selectNumberRegister:(id)sender
{
    BBNumberRegister *numberRegister = [[BBNumberRegister alloc] initWithNibName:@"BBNumberRegister" bundle:nil];
    numberRegister.delegate = self;
    [self.navigationController pushViewController:numberRegister animated:YES];
}

-(IBAction)selectEmailRegister:(id)sender
{
    BBRegister *registerController = [[BBRegister alloc] initWithNibName:@"BBRegister" bundle:nil];
    [registerController setDelegate:self];
    [self.navigationController pushViewController:registerController animated:YES];
}

- (void)registerFinish
{
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate selectRegisterFinish];
}

- (void)numberRegisterFinish
{
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate selectRegisterFinish];
}

@end
