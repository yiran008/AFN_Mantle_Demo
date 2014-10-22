//
//  BBTaxiMainPage.h
//  pregnancy
//
//  Created by whl on 13-12-10.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBRollCycleView.h"
#import "BBTaxiPartnerView.h"
#import "BBCreateTaxiOrderView.h"
#import "BBKuaidiPlaceSelectorViewController.h"

@interface BBTaxiMainPage : BaseViewController<CLLocationManagerDelegate,UITextFieldDelegate,BBCreateTaxiorderDelegate,BBKuaidiPlaceSelectorDelegate>


@property(nonatomic, strong) CLLocationManager *map;
@property(nonatomic, strong) IBOutlet UIView *disclaimerView;
@property(nonatomic, strong) IBOutlet UIWebView *disclaimerWebView;

@property(nonatomic, strong) IBOutlet UIButton *agreeButton;


@property(nonatomic, strong) IBOutlet UIButton *fromAddressButton;
@property(nonatomic, strong) IBOutlet UIButton *toAddressButton;
@property(nonatomic, strong) IBOutlet UILabel *fromAddressLabel;
@property(nonatomic, strong) IBOutlet UILabel *toAddressLabel;
@property(nonatomic, strong) BBRollCycleView *rollView;
@property(nonatomic, strong) IBOutlet UITextField *phoneNumber;

@property (nonatomic, strong) ASIFormDataRequest *partnerRequest;
@property (nonatomic, strong) ASIFormDataRequest *createTaxiRequest;
@property (nonatomic, strong) ASIFormDataRequest *noticeRequest;
@property (nonatomic, strong) ASIFormDataRequest *cashBackRequest;
@property (nonatomic, strong) ASIFormDataRequest *baiduMapRequest;
@property (nonatomic, strong) ASIFormDataRequest *disclaimerRequest;
@property (nonatomic, strong) MBProgressHUD *loadProgress;

@property (nonatomic, strong) IBOutlet UIView *firstView;

@property (nonatomic, strong) BBCreateTaxiOrderView *createTaxiOrder;
@end
