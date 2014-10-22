//
//  BBAcceptedTaxiOrders.h
//  pregnancy
//
//  Created by whl on 13-12-10.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBAcceptedTaxiOrders : BaseViewController

@property(nonatomic,strong) IBOutlet UIView *firstView;
@property(nonatomic,strong) IBOutlet UILabel *driverName;
@property(nonatomic,strong) IBOutlet UILabel *carNumber;
@property(nonatomic,strong) IBOutlet UILabel *driverPhone;

@property(nonatomic,strong) IBOutlet UIView *secondView;
@property(nonatomic,strong) NSDictionary *driverInfo;
@property(nonatomic,strong) IBOutlet UIImageView *taxiImage;

@end
