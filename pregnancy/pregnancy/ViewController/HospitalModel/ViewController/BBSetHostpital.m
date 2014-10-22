//
//  BBSetHostpital.m
//  pregnancy
//
//  Created by babytree babytree on 12-10-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBSetHostpital.h"
#import "BBHospitalRequest.h"
#import "BBSelectMoreArea.h"
#import "BBAreaDB.h"

@interface BBSetHostpital ()

@end

@implementation BBSetHostpital
@synthesize textField;
@synthesize hud;
@synthesize setHospitalRequest;
@synthesize areatextField;
@synthesize ciytCode;
- (void)dealloc
{
    [textField release];
    [hud release];
    [setHospitalRequest clearDelegatesAndCancel];
    [setHospitalRequest release];
    [areatextField release];
    [ciytCode release];
    
    [super dealloc];
}
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

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.exclusiveTouch = YES;
    [rightButton setFrame:CGRectMake(252, 0, 50, 34)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [rightButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    [rightBarButton release];
    
    self.title = @"设置您的医院";
    
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"设置您的医院"]];

    //MBProgressHUD显示等待框
    self.hud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:hud];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    IOS6_RELEASE_VIEW
}

- (void)viewDidUnload
{
    [self viewDidUnloadBabytree];
    
    [super viewDidUnload];
}

- (void)viewDidUnloadBabytree
{
    self.textField = nil;
    self.areatextField = nil;
    self.hud = nil;
    [self.setHospitalRequest clearDelegatesAndCancel];
    self.setHospitalRequest = nil;
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


- (IBAction)backAction:(UIBarButtonItem *)sender
{
    [textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveAction:(UIBarButtonItem *)sender
{
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"请输入医院名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alert show];
    }else if ([[areatextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"请选择所在城市" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alert show];
    }
    else {
        [textField resignFirstResponder];
        
        self.hud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
        [self.view addSubview:hud];
        [hud setLabelText:@"加载中..."];
        [hud show:YES];
        
        if (self.setHospitalRequest != nil) {
            [self.setHospitalRequest clearDelegatesAndCancel];
        }
        self.setHospitalRequest = [BBHospitalRequest setHospitalWithName:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] withId:nil withCityCode:self.ciytCode];
        [setHospitalRequest setDelegate:self];
        [setHospitalRequest setDidFinishSelector:@selector(loadDataFinished:)];
        [setHospitalRequest setDidFailSelector:@selector(loadDataFail:)];
        [setHospitalRequest startAsynchronous];
    }
}

- (void)loadDataFinished:(ASIHTTPRequest *)request
{
    [hud hide:YES];
    
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *parserData = [parser objectWithString:responseString error:&error];
    NSLog(@"%@", parserData);
    if (error != nil) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    
    if ([[parserData stringForKey:@"status"] isEqualToString:@"success"])
    {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:@"您的医院暂时还没有圈子，我们会在三个工作日内为您开通此医院圈子" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    } 
    else 
    {
        //测试
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"失败" message:[parserData stringForKey:@"status"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)loadDataFail:(ASIHTTPRequest *)request
{
    [hud hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *name = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [BBHospitalRequest setAddedHospitalName:name];
    [BBHospitalRequest setHospitalCategory:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)areaAction:(id)sender
{
    [textField resignFirstResponder];
	[areatextField resignFirstResponder];
    BBSelectMoreArea *selectArea = [[[BBSelectMoreArea alloc]initWithNibName:@"BBSelectMoreArea" bundle:nil]autorelease];
    selectArea.selectAreaCallBackHander = self;
    [self.navigationController pushViewController:selectArea animated:YES];
}
- (void)selectAreaCallBack:(id)object{
    NSDictionary *objectDict = (NSDictionary*)object;
    self.ciytCode = [objectDict stringForKey:@"id"];
    areatextField.text = [BBAreaDB areaByCiytCode:self.ciytCode];
    [self.navigationController popToViewController:self animated:YES];
}
@end
