//
//  BBTaxiMainPage.m
//  pregnancy
//
//  Created by whl on 13-12-10.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBTaxiMainPage.h"
#import "BBTaxiLocationData.h"
#import "BBCallTaxiRequest.h"
#import "BBTaxiActivityRule.h"
#import "BBTaxiCashBackView.h"
#import "BBKuaidiPersonalViewController.h"
#import "BBGuideDB.h"

@interface BBTaxiMainPage ()

@property (nonatomic,strong) UIButton *rightItemButton;
@property (nonatomic,strong) NSString *locationLongitude;
@property (nonatomic,strong) NSString *locationlatitude;
@property (nonatomic,strong) NSString *activityContent;
@property (nonatomic,strong) NSString *acticityStatus;
@property (nonatomic,strong) NSDictionary *mapAddressDic;
@property (assign) BOOL isSelectAddress;
@property (assign) BOOL isSendRequest;
@end

@implementation BBTaxiMainPage
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_mapAddressDic release];
    [_rightItemButton release];
    [_locationlatitude release];
    [_locationLongitude release];
    [_acticityStatus release];
    [_activityContent release];
    [_disclaimerView release];
    [_disclaimerWebView release];
    [_agreeButton release];
    [_fromAddressButton release];
    [_toAddressButton release];
    [_fromAddressLabel release];
    [_toAddressLabel release];
    [_phoneNumber release];
    [_partnerRequest clearDelegatesAndCancel];
    [_partnerRequest release];
    [_createTaxiRequest clearDelegatesAndCancel];
    [_createTaxiRequest release];
    [_noticeRequest clearDelegatesAndCancel];
    [_noticeRequest release];
    [_cashBackRequest clearDelegatesAndCancel];
    [_cashBackRequest release];
    [_baiduMapRequest clearDelegatesAndCancel];
    [_baiduMapRequest release];
    [_disclaimerRequest clearDelegatesAndCancel];
    [_disclaimerRequest release];
    [_loadProgress release];
    [_firstView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.rollView = [[[BBRollCycleView alloc]initWithFrame:CGRectMake(12, 24, 240, 20)]autorelease];
        self.isSelectAddress = NO;
        self.isSendRequest = YES;
        self.map = [[[CLLocationManager alloc]init]autorelease];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activityStatusRefresh) name:@"activityStatusRefresh" object:nil];
    }
    return self;
}
- (void)activityStatusRefresh
{
    self.acticityStatus =  @"0";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"快乐打车"];
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
    [self.rightItemButton setFrame:CGRectMake(0, 0, 40, 30)];
    [self.rightItemButton setImage:[UIImage imageNamed:@"nav_more"] forState:UIControlStateNormal];
    [self.rightItemButton setImage:[UIImage imageNamed:@"nav_more_pressed"] forState:UIControlStateHighlighted];
    [self.rightItemButton addTarget:self action:@selector(taxiUserInformation:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.rightItemButton];
    [self.navigationItem setRightBarButtonItem:commitBarButton];
    [commitBarButton release];
    
    self.loadProgress = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:self.loadProgress];
    
    UITapGestureRecognizer *tapGr = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)]autorelease];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    self.view.exclusiveTouch = YES;
    [self.firstView addSubview:self.rollView];
    [self.firstView setHidden:YES];
    
    if ([BBTaxiLocationData getUserTaxiPhoneNumber] != nil) {
        self.phoneNumber.text = [BBTaxiLocationData getUserTaxiPhoneNumber];
    }
    
    [self.agreeButton setEnabled:NO];
    [self.disclaimerWebView setBackgroundColor:[UIColor clearColor]];
    [self.disclaimerView setHidden:YES];
    
    if (IS_IPHONE5)
    {
        [self.agreeButton setTop:self.agreeButton.top+88];
        [self.disclaimerWebView setHeight:self.disclaimerWebView.frame.size.height + 88];
        [self.disclaimerView setHeight:self.disclaimerView.frame.size.height + 88];
    }
    
    self.agreeButton.exclusiveTouch = YES;
    self.fromAddressButton.exclusiveTouch = YES;
    self.toAddressButton.exclusiveTouch = YES;
    
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.phoneNumber resignFirstResponder];
}

-(void)obtainLocationInformation
{
        if (![CLLocationManager locationServicesEnabled]) {
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"打开“定位服务”来允许“宝宝树孕育”确定你的位置" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] autorelease];
            [alertView show];
            
        }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"打开“定位服务”来允许“宝宝树孕育”确定你的位置" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alertView show];
        }else {
            if ([BBTaxiLocationData getDisclaimerStatus])
            {
                [self.loadProgress setLabelText:@"获取当前位置信息......"];
                [self.loadProgress show:YES];
            }
             [self.map stopUpdatingLocation];
            self.map.delegate = self;
            //选择定位的方式为最优的状态，他又四种方式在文档中能查到
            self.map.desiredAccuracy=kCLLocationAccuracyBest;
            //发生事件的最小距离间隔
            self.map.distanceFilter = 50.0f;
            [self.map startUpdatingLocation];
        }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.rollView  startTimer];
    if (!self.isSelectAddress) {
       [self needDisclaimerPage]; 
    }else{
        self.isSelectAddress = NO;
    }
    if (self.fromAddressButton.titleLabel.text==nil||[self.fromAddressButton.titleLabel.text isEqualToString:@""]) {
        self.fromAddressLabel.text = @"请输入出发地";
    }else{
        self.fromAddressLabel.text = @"";
    }
    
    if (self.toAddressButton.titleLabel.text==nil||[self.toAddressButton.titleLabel.text isEqualToString:@""]) {
        self.toAddressLabel.text = @"请输入目的地";
    }else{
        self.toAddressLabel.text = @"";
    }
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
     if ([BBTaxiLocationData getDisclaimerStatus]) {
         [self taxiCashBackRequest];
     }
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.rollView stopTimer];
    [self.map stopUpdatingLocation];
    [self.phoneNumber resignFirstResponder];
    [super viewWillDisappear:animated];
    [ApplicationDelegate clickGuideImageAction];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(IBAction)clickedTaxiActivityRule:(id)sender
{
    BBTaxiActivityRule *activityRule = [[[BBTaxiActivityRule alloc]initWithNibName:@"BBTaxiActivityRule" bundle:nil]autorelease];
    activityRule.contentHtml = self.activityContent;
    activityRule.rightStatus = self.acticityStatus;
    [self.navigationController pushViewController:activityRule animated:YES];
}


- (IBAction)backAction:(id)sender
{
    [self dismissModalView];
     self.map.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)taxiUserInformation:(id)sender
{
    BBKuaidiPersonalViewController *kuaidiPersonalView = [[[BBKuaidiPersonalViewController alloc]initWithNibName:@"BBKuaidiPersonalViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:kuaidiPersonalView animated:YES];
    [MobClick event:@"taxi_v2" label:@"打车首页更多点击"];
}


- (IBAction)selectStartAddress:(id)sender
{
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"打开“定位服务”来允许“宝宝树孕育”确定你的位置" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
        
    }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"打开“定位服务”来允许“宝宝树孕育”确定你的位置" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    self.isSelectAddress = YES;
    BBKuaidiPlaceSelectorViewController *kuaidiPlaceSelectorView = [[[BBKuaidiPlaceSelectorViewController alloc]initWithNibName:@"BBKuaidiPlaceSelectorViewController" bundle:nil]autorelease];
    kuaidiPlaceSelectorView.placeSelectorType = BBKuaidiPlaceSelectorTypeStart;
    kuaidiPlaceSelectorView.delegate = self;
    kuaidiPlaceSelectorView.geocoderPalcesDic = [NSMutableDictionary dictionaryWithDictionary:self.mapAddressDic];
    [self.navigationController pushViewController:kuaidiPlaceSelectorView animated:YES];
}

- (IBAction)selectDestinationAddress:(id)sender
{
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"打开“定位服务”来允许“宝宝树孕育”确定你的位置" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
        
    }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"打开“定位服务”来允许“宝宝树孕育”确定你的位置" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    self.isSelectAddress = YES;
    BBKuaidiPlaceSelectorViewController *kuaidiPlaceSelectorView = [[[BBKuaidiPlaceSelectorViewController alloc]initWithNibName:@"BBKuaidiPlaceSelectorViewController" bundle:nil]autorelease];
    kuaidiPlaceSelectorView.placeSelectorType = BBKuaidiPlaceSelectorTypeEnd;
    kuaidiPlaceSelectorView.delegate = self;
    kuaidiPlaceSelectorView.geocoderPalcesDic = [NSMutableDictionary dictionaryWithDictionary:self.mapAddressDic];
    [self.navigationController pushViewController:kuaidiPlaceSelectorView animated:YES];
}

- (void)placeSelectedWithPlace:(NSString *)place type:(BBKuaidiPlaceSelectorType)type
{
    if (type == BBKuaidiPlaceSelectorTypeStart) {
        if (place==nil||[place isEqualToString:@""]) {
            self.fromAddressLabel.text = @"请输入出发地";
        }else{
            self.fromAddressLabel.text = @"";
            [self.fromAddressButton setTitle:place forState:UIControlStateNormal];
        }
    }else if(type == BBKuaidiPlaceSelectorTypeEnd){
        if (place==nil||[place isEqualToString:@""]) {
            self.toAddressLabel.text = @"请输入目的地";
        }else{
            self.toAddressLabel.text = @"";
            [self.toAddressButton setTitle:place forState:UIControlStateNormal];
        }
    }

}


-(IBAction)createTaxiOrder:(id)sender
{
    [MobClick event:@"taxi_v2" label:@"打车首页-马上打车点击"];
    if (self.fromAddressButton.titleLabel.text==nil||[self.fromAddressButton.titleLabel.text isEqualToString:@""]) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"请选择正确的出发地址" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    if (self.toAddressButton.titleLabel.text==nil||[self.toAddressButton.titleLabel.text isEqualToString:@""]) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"请选择目的地址" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    if (![BBValidateUtility checkPhoneNumInput:self.phoneNumber.text]) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"请输入正确的电话号码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    
    if (self.locationlatitude == nil || self.locationLongitude == nil) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"没有获取正确的位置" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        [self obtainLocationInformation];
        return;
    }
    
    [BBTaxiLocationData setUserTaxiPhoneNumber:self.phoneNumber.text];
    [self createOrderRequest];
}


-(void)needDisclaimerPage
{
    if (![BBTaxiLocationData getDisclaimerStatus]) {
        [self.disclaimerView setHidden:NO];
        [self.rightItemButton setHidden:YES];
        [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"软件许可及服务协议"]];
        [self taxiDisclaimerRequest];
    }else{
        [self.disclaimerView setHidden:YES];
        [self.rightItemButton setHidden:NO];
        [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"快乐打车"]];
        [MobClick event:@"taxi_v2" label:@"打车首页显示次数"];
    }
     [self obtainLocationInformation];

}

-(IBAction)clickedAgreeDisclaimer:(id)sender
{
    [MobClick event:@"taxi_v2" label:@"免责声明-我同意点击"];
    [BBTaxiLocationData setDisclaimerStatus:YES];
    [self.disclaimerView setHidden:YES];
    [self.rightItemButton setHidden:NO];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"快乐打车"]];
    [self obtainLocationInformation];
}


#pragma locationManager delegate 

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    self.locationLongitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    self.locationlatitude  = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    [BBTaxiLocationData setCurrentLongitudeString:self.locationLongitude];
    [BBTaxiLocationData setCurrentLatitudeString:self.locationlatitude];
    [self.map stopUpdatingLocation];
    NSString *locationStr = [NSString stringWithFormat:@"%@,%@",self.locationlatitude,self.locationLongitude];
    [self.baiduMapRequest clearDelegatesAndCancel];
    self.baiduMapRequest = [BBCallTaxiRequest baiduMapResolve:locationStr];
    [self.baiduMapRequest setDidFinishSelector:@selector(baiduMapFinish:)];
    [self.baiduMapRequest setDidFailSelector:@selector(baiduMapFail:)];
    [self.baiduMapRequest setDelegate:self];
    [self.baiduMapRequest startAsynchronous];
    if (self.isSendRequest) {
        if ([BBTaxiLocationData getDisclaimerStatus]) {
            [self taxiNoticeRequest];
        }
        [self taxiPartnerRequest];
    }
//     [self taxiNoticeRequest];
}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    
}
#pragma  baidu map request

- (void)baiduMapFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *jsonData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[jsonData stringForKey:@"status"] isEqualToString:@"0"]) {
        //返回数据成功
        self.fromAddressLabel.text = @"";
        NSDictionary *listDic = [jsonData dictionaryForKey:@"result"];
        
        self.locationLongitude = [NSString stringWithFormat:@"%@",[[listDic dictionaryForKey:@"location"] stringForKey:@"lng"]];
        self.locationlatitude  = [NSString stringWithFormat:@"%@",[[listDic dictionaryForKey:@"location"] stringForKey:@"lat"]];
        [BBTaxiLocationData setCurrentLongitudeString:self.locationLongitude];
        [BBTaxiLocationData setCurrentLatitudeString:self.locationlatitude];
        NSString *str =[NSString stringWithFormat:@"%@%@",[[listDic dictionaryForKey:@"addressComponent"] stringForKey:@"city"],[[listDic dictionaryForKey:@"addressComponent"] stringForKey:@"street"]];
        [self.fromAddressButton setTitle:str forState:UIControlStateNormal];
        self.mapAddressDic = listDic;
        [self.loadProgress hide:YES];
    }
}

- (void)baiduMapFail:(ASIFormDataRequest *)request
{
    [self.loadProgress hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}


#pragma request mothed

-(void)taxiDisclaimerRequest
{
    [self.loadProgress setLabelText:@"加载中..."];
    [self.loadProgress show:YES];
    [self.disclaimerRequest clearDelegatesAndCancel];
    self.disclaimerRequest = [BBCallTaxiRequest taxiCallRule];
    [self.disclaimerRequest setDidFinishSelector:@selector(taxiDisclaimerFinish:)];
    [self.disclaimerRequest setDidFailSelector:@selector(taxiDisclaimerFail:)];
    [self.disclaimerRequest setDelegate:self];
    [self.disclaimerRequest startAsynchronous];
    
}


- (void)taxiDisclaimerFinish:(ASIFormDataRequest *)request
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
        [self.agreeButton setEnabled:YES];
        [self.disclaimerWebView loadHTMLString:[listDic stringForKey:@"agreement"] baseURL:nil];
        
    }
}

- (void)taxiDisclaimerFail:(ASIFormDataRequest *)request
{
    [self.loadProgress hide:YES];
}


-(void)createOrderRequest
{
    [self.loadProgress setLabelText:@"加载中..."];
    [self.loadProgress show:YES];
    [self.createTaxiRequest clearDelegatesAndCancel];
    self.createTaxiRequest = [BBCallTaxiRequest taxiCreateOrders:self.phoneNumber.text withFromAddress:self.fromAddressButton.titleLabel.text withToAddress:self.toAddressButton.titleLabel.text withFromLongitude:self.locationLongitude withFromLatitude:self.locationlatitude];
    [self.createTaxiRequest setDidFinishSelector:@selector(createOrderFinish:)];
    [self.createTaxiRequest setDidFailSelector:@selector(createOrderFail:)];
    [self.createTaxiRequest setDelegate:self];
    [self.createTaxiRequest startAsynchronous];
    
}


- (void)createOrderFinish:(ASIFormDataRequest *)request
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
        self.createTaxiOrder = [[[BBCreateTaxiOrderView alloc]initWithFrame:CGRectMake(0, 0, 256,150)]autorelease];
        self.createTaxiOrder.delegate =self;
        self.createTaxiOrder.popViewController =self.navigationController;
        self.createTaxiOrder.orderID = [listDic stringForKey:@"order_id"];
        self.createTaxiOrder.userPhone = self.phoneNumber.text;
        self.createTaxiOrder.fromAddress = self.fromAddressButton.titleLabel.text;
        self.createTaxiOrder.toAddress = self.toAddressButton.titleLabel.text;
        self.createTaxiOrder.currentLongitude = self.locationLongitude;
        self.createTaxiOrder.currentlatitude = self.locationlatitude;
        [self.createTaxiOrder startTimer];
        [self.createTaxiOrder startTimerChangeLabel];
        [self showViladate];
    }else{
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[[jsonData dictionaryForKey:@"data"] stringForKey:@"message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)createOrderFail:(ASIFormDataRequest *)request
{
    [self.loadProgress hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

-(void)taxiPartnerRequest
{
    [self.partnerRequest clearDelegatesAndCancel];
    self.partnerRequest = [BBCallTaxiRequest taxiPartner:self.locationLongitude withLatitude:self.locationlatitude];
    [self.partnerRequest setDidFinishSelector:@selector(taxiPartnerFinish:)];
    [self.partnerRequest setDidFailSelector:@selector(taxiPartnerFail:)];
    [self.partnerRequest setDelegate:self];
    [self.partnerRequest startAsynchronous];
    
}


- (void)taxiPartnerFinish:(ASIFormDataRequest *)request
{
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
        [BBTaxiLocationData setTaxiPartnerData:[listDic arrayForKey:@"data"]];
        [BBTaxiLocationData setTaxiPartnerTitle:[listDic stringForKey:@"partner_title"]];
        BBTaxiPartnerView *taxiPartnerView =[[[BBTaxiPartnerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-60, 320, 40) withDiction:[listDic arrayForKey:@"data"] withPartnerTitle:[listDic stringForKey:@"partner_title"]]autorelease];
        [self.view addSubview:taxiPartnerView];
        
    }
}

- (void)taxiPartnerFail:(ASIFormDataRequest *)request
{
}

-(void)taxiNoticeRequest
{
    [self.noticeRequest clearDelegatesAndCancel];
    self.noticeRequest = [BBCallTaxiRequest taxiNotice:self.locationLongitude withLatitude:self.locationlatitude];
    
//    NSArray *apis = [[[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"mobile_taxi/notice",@"action",[BBUser getLoginString],LOGIN_STRING_KEY,self.locationLongitude,@"lng",self.locationlatitude,@"lat", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"mobile_taxi/partner",@"action",[BBUser getLoginString],LOGIN_STRING_KEY,self.locationLongitude,@"lng",self.locationlatitude,@"lat", nil],nil]autorelease];
//    self.noticeRequest = [BBCallTaxiRequest packageAPI:apis];
    [self.noticeRequest setDidFinishSelector:@selector(taxiNoticeFinish:)];
    [self.noticeRequest setDidFailSelector:@selector(taxiNoticeFail:)];
    [self.noticeRequest setDelegate:self];
    [self.noticeRequest startAsynchronous];
    
}


- (void)taxiNoticeFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *jsonData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
//    if ([[jsonData stringForKey:@"status"] isEqualToString:@"success"]) {
//        if (![jsonData isNotEmpty])
//        {
//            return;
//        }
//        NSArray *arr =[jsonData arrayForKey:@"data"];
//        if ([[[arr objectAtIndex:0] stringForKey:@"status"] isEqualToString:@"success"]) {
//            //返回数据成功
//            NSDictionary *listDic = [[arr objectAtIndex:0] dictionaryForKey:@"data"];
//            self.rollView.contentArray = [listDic arrayForKey:@"user_list"];
//            [self.rollView resetTimer];
//            self.activityContent = [listDic stringForKey:@"html"];
//            [BBTaxiLocationData setAppleWordString:[listDic stringForKey:@"apply_word"]];
//            if ([[listDic stringForKey:@"is_apply"] isEqualToString:@"false"]) {
//                self.acticityStatus = [listDic stringForKey:@"is_apply"];
//            }else{
//                self.acticityStatus = [[listDic dictionaryForKey:@"apply"] stringForKey:@"status"];
//            }
//            [self.firstView setHidden:NO];
//            [self checkDisplayOperateGuide];
//            self.isSendRequest = NO;
//        }else{
//            [BBTaxiLocationData setAppleWordString:@""];
//        }
//        
//        if ([[[arr objectAtIndex:1] stringForKey:@"status"] isEqualToString:@"success"]) {
//            //返回数据成功
//        NSDictionary *listDic = [[arr objectAtIndex:1] dictionaryForKey:@"data"];
//        [BBTaxiLocationData setTaxiPartnerData:[listDic arrayForKey:@"data"]];
//        [BBTaxiLocationData setTaxiPartnerTitle:[listDic stringForKey:@"partner_title"]];
//        BBTaxiPartnerView *taxiPartnerView =[[[BBTaxiPartnerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-60, 320, 40) withDiction:[listDic arrayForKey:@"data"] withPartnerTitle:[listDic stringForKey:@"partner_title"]]autorelease];
//            [self.view addSubview:taxiPartnerView];
//        }
//    }
    if ([[jsonData stringForKey:@"status"] isEqualToString:@"success"]) {
        if (![jsonData isNotEmpty])
        {
            return;
        }
        //返回数据成功
        NSDictionary *listDic = [jsonData dictionaryForKey:@"data"];
        self.rollView.contentArray = [listDic arrayForKey:@"user_list"];
        [self.rollView resetTimer];
        self.activityContent = [listDic stringForKey:@"html"];
        [BBTaxiLocationData setAppleWordString:[listDic stringForKey:@"apply_word"]];
        if ([[listDic stringForKey:@"is_apply"] isEqualToString:@"false"]) {
            self.acticityStatus = [listDic stringForKey:@"is_apply"];
        }else{
            self.acticityStatus = [[listDic dictionaryForKey:@"apply"] stringForKey:@"status"];
        }
        [self.firstView setHidden:NO];
        [ApplicationDelegate checkDisplayOperateGuide:ENABLE_SHOW_TAXI_MAINHOME_PAGE];
        self.isSendRequest = NO;
    }else{
        [BBTaxiLocationData setAppleWordString:@""];
    }
}

- (void)taxiNoticeFail:(ASIFormDataRequest *)request
{
    
}


-(void)taxiCashBackRequest
{
    [self.cashBackRequest clearDelegatesAndCancel];
    self.cashBackRequest = [BBCallTaxiRequest taxiCallbackStatus];
    [self.cashBackRequest setDidFinishSelector:@selector(taxiCashBackFinish:)];
    [self.cashBackRequest setDidFailSelector:@selector(taxiCashBackFail:)];
    [self.cashBackRequest setDelegate:self];
    [self.cashBackRequest startAsynchronous];
    
}


- (void)taxiCashBackFinish:(ASIFormDataRequest *)request
{
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
        long long  new_ts = [[listDic stringForKey:@"back_ts"] longLongValue];
        if ([BBTaxiLocationData getCallBackTimerString] == nil) {
            [BBTaxiLocationData setCallBackTimerString:[listDic stringForKey:@"back_ts"]];
            BBTaxiCashBackView *cashBackView = [[[BBTaxiCashBackView alloc]initWithNibName:@"BBTaxiCashBackView" bundle:nil]autorelease];
            cashBackView.cashBackString = [listDic stringForKey:@"money"];
            [self.navigationController pushViewController:cashBackView animated:YES];
        }else{
          long long  old_ts = [[BBTaxiLocationData getCallBackTimerString] longLongValue];
            if (new_ts > old_ts) {
                [BBTaxiLocationData setCallBackTimerString:[listDic stringForKey:@"back_ts"]];
                BBTaxiCashBackView *cashBackView = [[[BBTaxiCashBackView alloc]initWithNibName:@"BBTaxiCashBackView" bundle:nil]autorelease];
                cashBackView.cashBackString = [listDic stringForKey:@"money"];
                [self.navigationController pushViewController:cashBackView animated:YES];
            }
        }
    }
}

- (void)taxiCashBackFail:(ASIFormDataRequest *)request
{
    
}

#pragma textfield delegate

//开始编辑输入框的时候，软键盘出现，执行此事件
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0){
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            self.view.frame = CGRectMake(0.0f, 64-offset, self.view.frame.size.width, self.view.frame.size.height);
        }else{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
    
    [UIView commitAnimations];
}


//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }else{
        self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}


- (void)showViladate {
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if (![keywindow.subviews containsObject:self]) {
        // Calulate all frames
        CGRect sf = self.createTaxiOrder.frame;
        CGRect vf = keywindow.frame;
        // Add semi overlay
        UIView * overlay = [[[UIView alloc] initWithFrame:keywindow.bounds] autorelease];
        overlay.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
        overlay.tag = 20000;
        
        [keywindow addSubview:overlay];
        
        // Present view animated
        self.createTaxiOrder.frame = CGRectMake((vf.size.width-sf.size.width)/2.0,(vf.size.height-sf.size.height)/2.0, sf.size.width, sf.size.height);
        [keywindow addSubview:self.createTaxiOrder];
        self.createTaxiOrder.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.createTaxiOrder.layer.shadowOffset = CGSizeMake(0, -2);
        self.createTaxiOrder.layer.shadowRadius = 5.0;
        self.createTaxiOrder.layer.shadowOpacity = 0.8;
        self.createTaxiOrder.tag = 30000;
    }
}

- (void)dismissModalView
{
    UIWindow * keywindow = [[UIApplication sharedApplication] keyWindow];
    UIView *overlay = [keywindow viewWithTag:20000];
    UIView *_self = [keywindow viewWithTag:30000];
    [UIView animateWithDuration:0.1f animations:^{
    } completion:^(BOOL finished) {
        [overlay removeFromSuperview];
        [_self removeFromSuperview];
    }];
    
}

-(void)cancelCreateTaxiOrderView
{
    [self.createTaxiOrder stopTimer];
    [self.createTaxiOrder stopChangeLabelTimer];
    [self dismissModalView];
}

@end
