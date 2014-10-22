//
//  BBAcceptedTaxiOrders.m
//  pregnancy
//
//  Created by whl on 13-12-10.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBAcceptedTaxiOrders.h"
#import "BBTaxiMainPage.h"
#import "BBTaxiOrdersDetail.h"

@interface BBAcceptedTaxiOrders ()

@end

@implementation BBAcceptedTaxiOrders
- (void)dealloc
{
    [_firstView release];
    [_driverName release];
    [_carNumber release];
    [_driverPhone release];
    
    [_secondView release];
    [_driverInfo release];
    [_taxiImage release];
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
    [self.navigationItem setTitle:@"正在派单"];
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
    [super viewDidLoad];
    
    
    NSURL *url = [NSURL URLWithString:[self.driverInfo stringForKey:@"partner_img"]];
    [self.taxiImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"taxi_default"]];
    self.driverName.text = [NSString stringWithFormat:@"司机: %@",[self checkString:[[self.driverInfo dictionaryForKey:@"kuaidi_accept_info"] stringForKey:@"driver_name"]]];
    self.driverPhone.text = [NSString stringWithFormat:@"车号: %@",[self checkString:[[self.driverInfo dictionaryForKey:@"kuaidi_accept_info"] stringForKey:@"driver_phone"]]];
    self.carNumber.text = [NSString stringWithFormat:@"电话: %@", [self checkString:[[self.driverInfo dictionaryForKey:@"kuaidi_accept_info"] stringForKey:@"driver_license"]]];
}

- (IBAction)backAction:(id)sender
{
    for (UIViewController *viewCtrl in [self.navigationController viewControllers])
    {
        if ([viewCtrl isKindOfClass:[BBTaxiMainPage class]]) {
            [self.navigationController popToViewController:viewCtrl animated:YES];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)callPhoneNumber:(id)sender{

    if ([[self.driverInfo dictionaryForKey:@"kuaidi_accept_info"] stringForKey:@"driver_phone"] != nil) {
        NSString *num = [NSString stringWithFormat:@"tel://%@",[[self.driverInfo dictionaryForKey:@"kuaidi_accept_info"] stringForKey:@"driver_phone"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    }
}

-(IBAction)clickedOrderDetail:(id)sender
{
    BBTaxiOrdersDetail *taxiOrdersDetail = [[[BBTaxiOrdersDetail alloc]initWithNibName:@"BBTaxiOrdersDetail" bundle:nil] autorelease];
    taxiOrdersDetail.orderNumber = [self.driverInfo stringForKey:@"enc_order_id"];
    [self.navigationController pushViewController:taxiOrdersDetail animated:YES];
    [MobClick event:@"taxi_v2" label:@"接单页-查看详情点击"];
    [MobClick event:@"taxi_v2" label:@"订单详情页显示次数"];
}

-(NSString*)checkString:(NSString*)str
{
    if (str == nil) {
        return  [NSString stringWithFormat:@""];
    }
    return str;
}

@end
