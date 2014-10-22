//
//  BBTaxiOrdersDetail.h
//  pregnancy
//
//  Created by whl on 13-12-10.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBTaxiOrdersDetail : BaseViewController

@property(nonatomic,strong) IBOutlet UIView *firstView;
@property(nonatomic,strong) IBOutlet UILabel *orderStatusLabel;
@property(nonatomic,strong) IBOutlet UILabel *orderTimerLabel;
@property(nonatomic,strong) IBOutlet UILabel *orderNumberLabel;
@property(nonatomic,strong) IBOutlet UILabel *severNameLabel;
@property(nonatomic,strong) IBOutlet UILabel *driverNameLabel;
@property(nonatomic,strong) IBOutlet UILabel *taxiNumberLabel;
@property(nonatomic,strong) IBOutlet UILabel *driverPhoneLabel;

@property(nonatomic,strong) IBOutlet UIView *secondView;
@property(nonatomic,strong) IBOutlet UILabel *formAddressLabel;
@property(nonatomic,strong) IBOutlet UILabel *startTimerLabel;
@property(nonatomic,strong) IBOutlet UILabel *toAddressLabel;

@property(nonatomic,strong) IBOutlet UIView *thirdView;
@property(nonatomic,strong) IBOutlet UILabel *userPhoneLabel;

@property(nonatomic,strong) IBOutlet UIImageView *taxiImage;

@property(nonatomic,strong) NSString *orderNumber;


@property (nonatomic, strong) ASIFormDataRequest *orderDetailRequest;
@property (nonatomic, strong) MBProgressHUD *loadProgress;

@end
