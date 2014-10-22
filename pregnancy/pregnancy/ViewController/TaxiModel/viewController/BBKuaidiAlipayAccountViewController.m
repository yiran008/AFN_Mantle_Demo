//
//  BBKuaidiAlipayAccountViewController.m
//  pregnancy
//
//  Created by ZHENGLEI on 13-12-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBKuaidiAlipayAccountViewController.h"
#import "BBCallTaxiRequest.h"

@interface BBKuaidiAlipayAccountViewController ()
{
    
}

@property(nonatomic,retain)UIButton * rightItemButton;
@property(nonatomic,retain)IBOutlet UITextField * alipayField;
@property(nonatomic,retain)ASIFormDataRequest * alipayRequest;
@property(nonatomic,retain)MBProgressHUD * progressBar;
@end

@implementation BBKuaidiAlipayAccountViewController

- (void)dealloc
{
    [_rightItemButton release];
    [_alipayField release];
    [_alipayRequest clearDelegatesAndCancel];
    [_alipayRequest release];
    [_alipayAccount release];
    [_progressBar release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setTitle:@"支付宝帐号"];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    if (self.alipayAccount) {
        self.alipayField.text = self.alipayAccount;
    }
    
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
    [self.rightItemButton setFrame:CGRectMake(0, 0, 40, 30)];
    [self.rightItemButton setImage:[UIImage imageNamed:@"commitBarButton"] forState:UIControlStateNormal];
    [self.rightItemButton setImage:[UIImage imageNamed:@"commitPressed"] forState:UIControlStateHighlighted];

    [self.rightItemButton addTarget:self action:@selector(submitAlipayAccount) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.rightItemButton];
    [self.navigationItem setRightBarButtonItem:commitBarButton];
    [commitBarButton release];
        
    UITapGestureRecognizer *tapGr = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)]autorelease];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    self.progressBar = [[[MBProgressHUD alloc]initWithView:self.view]autorelease];
    [self.view addSubview:self.progressBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- classMethod
- (void)submitAlipayAccount
{
    if([BBValidateUtility checkPhoneNumInput:self.alipayField.text]||[BBValidateUtility isValidateEmail:self.alipayField.text])
    {
        [self.alipayRequest clearDelegatesAndCancel];
        self.alipayRequest = [BBCallTaxiRequest modifyAlipayAccount:self.alipayField.text];
        [self.alipayRequest setDidFinishSelector:@selector(alipyFinished:)];
        [self.alipayRequest setDidFailSelector:@selector(alipyFailed:)];
        [self.alipayRequest setDelegate:self];
        [self.alipayRequest startAsynchronous];
        [self.progressBar show:YES];
    }
    else
    {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"支付宝账号必须是手机号码或邮箱" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }

}

- (void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.alipayField resignFirstResponder];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- httpDelegate
- (void)alipyFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser * parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[jsonDictionary stringForKey:@"status"] isEqualToString:@"success"])
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(alipayAccountModifySuccessed:)])
        {
            [self.delegate alipayAccountModifySuccessed:self.alipayField.text];
        }
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"帐号修改成功!" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if([[jsonDictionary stringForKey:@"status"] isEqualToString:@"failed"])
    {
        NSMutableDictionary * data = (NSMutableDictionary *)[jsonDictionary dictionaryForKey:@"data"];
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[data stringForKey:@"message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }

    [self.progressBar hide:YES];
}

- (void)alipyFailed:(ASIFormDataRequest *)request
{
    [self.progressBar hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

#pragma mark- textFieldDelegate
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.alipayField resignFirstResponder];
    return YES;
}

@end
