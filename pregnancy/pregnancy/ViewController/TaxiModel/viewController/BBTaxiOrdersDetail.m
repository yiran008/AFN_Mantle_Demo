//
//  BBTaxiOrdersDetail.m
//  pregnancy
//
//  Created by whl on 13-12-10.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBTaxiOrdersDetail.h"
#import "BBCallTaxiRequest.h"


@interface BBTaxiOrdersDetail ()

@property (nonatomic, strong) NSString *driverPhone;
@property (nonatomic, strong) NSString *severPhone;

@end

@implementation BBTaxiOrdersDetail

- (void)dealloc
{
    [_firstView release];
    [_orderStatusLabel release];
    [_orderTimerLabel release];
    [_orderNumberLabel release];
    [_severNameLabel release];
    [_driverNameLabel release];
    [_taxiNumberLabel release];
    [_driverPhoneLabel release];
    [_secondView release];
    [_formAddressLabel release];
    [_startTimerLabel release];
    [_toAddressLabel release];
    [_thirdView release];
    [_userPhoneLabel release];
    [_orderNumber release];
    [_orderDetailRequest clearDelegatesAndCancel];
    [_orderDetailRequest release];
    [_loadProgress release];
    [_taxiImage release];
    [_driverPhone release];
    [_severPhone release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"订单详情"];
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
    
    self.loadProgress = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:self.loadProgress];
    [self loadDetailDataRequest];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)callDriverPhoneNumber:(id)sender{
    if (self.driverPhone != nil) {
        NSString *num = [NSString stringWithFormat:@"tel://%@",self.driverPhone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    }
    [MobClick event:@"taxi_v2" label:@"订单详情页-拨联系司机点击"];
}
-(IBAction)callServicePhoneNumber:(id)sender{
    if (self.severPhone != nil) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.severPhone]]];
    }
    [MobClick event:@"taxi_v2" label:@"订单详情页-拨客服电话点击"];
}

-(void)loadDetailDataRequest
{
    [self.loadProgress show:YES];
    [self.orderDetailRequest clearDelegatesAndCancel];
    self.orderDetailRequest = [BBCallTaxiRequest taxiOrdersDetail:self.orderNumber];
    [self.orderDetailRequest setDidFinishSelector:@selector(loadDetailDataFinish:)];
    [self.orderDetailRequest setDidFailSelector:@selector(loadDetailDataFail:)];
    [self.orderDetailRequest setDelegate:self];
    [self.orderDetailRequest startAsynchronous];
    
}


- (void)loadDetailDataFinish:(ASIFormDataRequest *)request
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
        if (![jsonData isNotEmpty])
        {
            return;
        }
        //返回数据成功
        NSDictionary *listDic = [jsonData dictionaryForKey:@"data"];
        
        NSDictionary *detailInfo = [listDic dictionaryForKey:@"kuaidi_accept_info"];
        
        NSString *orderStatus ;
        
        
        if ([[listDic stringForKey:@"status"] isEqualToString:@"0"]||[[listDic stringForKey:@"status"] isEqualToString:@"2"]) {
            orderStatus = @"订单审核中";
        }else if([[listDic stringForKey:@"status"] isEqualToString:@"4"]){
            orderStatus = @"订单失败";
        }else if([[listDic stringForKey:@"status"] isEqualToString:@"5"]){
            orderStatus = @"订单完成";
        }else {
            orderStatus = @"订单取消";
        }
        
        self.orderStatusLabel.text = orderStatus;
        self.orderTimerLabel.text = [NSString stringWithFormat:@"下单时间: %@",[self checkString:[listDic stringForKey:@"create_ts"]]] ;
        self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号: %@",[self checkString:[listDic stringForKey:@"enc_order_id"]]];
        self.severNameLabel.text = [NSString stringWithFormat:@"服务商: %@",[self checkString:[listDic stringForKey:@"partner"]]] ;
        self.driverNameLabel.text = [NSString stringWithFormat:@"司机: %@",[self checkString:[detailInfo stringForKey:@"driver_name"]]];
        self.taxiNumberLabel.text = [NSString stringWithFormat:@"车号: %@",[self checkString:[detailInfo stringForKey:@"driver_license"]]];
        self.driverPhoneLabel.text = [NSString stringWithFormat:@"电话: %@",[self checkString:[detailInfo stringForKey:@"driver_phone"]]];
        NSURL *url = [NSURL URLWithString:[listDic stringForKey:@"partner_img"]];
        [self.taxiImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"taxi_default"]];
        self.formAddressLabel.text = [self checkString:[listDic stringForKey:@"from"]];
        self.startTimerLabel.text = [self checkString:[listDic stringForKey:@"accept_ts"]];
        self.toAddressLabel.text = [self checkString:[listDic stringForKey:@"to"]];
        self.userPhoneLabel.text = [NSString stringWithFormat:@"预留电话: %@",[self checkString:[listDic stringForKey:@"telephone"]]];
        self.driverPhone = [detailInfo stringForKey:@"driver_phone"];
        self.severPhone = [listDic stringForKey:@"partner_tel"];
    }
}

- (void)loadDetailDataFail:(ASIFormDataRequest *)request
{
    [self.loadProgress hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

-(NSString*)checkString:(NSString*)str
{
    if (str == nil) {
        return  [NSString stringWithFormat:@""];
    }
    return str;
}

@end
