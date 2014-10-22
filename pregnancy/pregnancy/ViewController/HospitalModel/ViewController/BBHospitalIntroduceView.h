//
//  BBHospitalIntroduceView.h
//  pregnancy
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBHospitalRequest.h"


@interface BBHospitalIntroduceView : UIScrollView
{
    IBOutlet UIImageView *introBg;
    IBOutlet UIImageView *descriptionBg;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *telLabel;
    IBOutlet UILabel *locationLabel;
    IBOutlet UILabel *longTelLabel;
    IBOutlet UILabel *longLocationLabel;
    IBOutlet UILabel *introductionLabel;
    IBOutlet UITextView *introductionTextView;
    
    ASIFormDataRequest *myRequest;
    NSString *hospitalId;
    MBProgressHUD *hud;
    
    NSString *latitude;
    NSString *longitude;
    UIViewController *viewCtrl;
}

@property (nonatomic, retain) IBOutlet UIImageView *introBg;
@property (nonatomic, retain) IBOutlet UIImageView *descriptionBg;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *telLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UILabel *longTelLabel;
@property (nonatomic, retain) IBOutlet UILabel *longLocationLabel;
@property (nonatomic, retain) IBOutlet UILabel *introductionLabel;
@property (nonatomic, retain) IBOutlet UITextView *introductionTextView;

@property (nonatomic, retain) ASIFormDataRequest *myRequest;
@property (nonatomic, retain) NSString *hospitalId;
@property (nonatomic, retain) MBProgressHUD *hud;

@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (assign) UIViewController *viewCtrl;
- (void)initSubViewsWithHospitalId:(NSString *)hosId;
- (void)refreshData;

- (void)adjustHeightWithData:(NSDictionary *)data;
- (IBAction)locationButtonClicked:(id)sender;

@end
