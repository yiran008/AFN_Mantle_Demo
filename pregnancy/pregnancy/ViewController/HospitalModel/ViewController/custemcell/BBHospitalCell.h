//
//  BBHospitalCell.h
//  pregnancy
//
//  Created by mac on 12-10-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBHospitalRequest.h"


@interface BBHospitalCell : UITableViewCell
<
    CallBack,
    BBLoginDelegate
>
{
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *postNumLabel;
    IBOutlet UILabel *pregnanryNumLabel;
    IBOutlet UIButton *button;
    IBOutlet UIButton *jianDangGongLueBtn;
    NSDictionary *itemData;
    
    ASIFormDataRequest *myRequest;
    MBProgressHUD *hud;
    UIViewController *viewCtrl;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *postNumLabel;
@property (nonatomic, retain) IBOutlet UILabel *pregnanryNumLabel;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UIButton *jianDangGongLueBtn;
@property (nonatomic, retain) NSDictionary *itemData;
@property (nonatomic, retain)ASIFormDataRequest *myRequest;
@property (nonatomic, retain)MBProgressHUD *hud;
@property (assign) UIViewController *viewCtrl;
@property (strong, nonatomic) IBOutlet UIButton *myHospitalButton;

- (IBAction)setMyHospitalAction:(id)sender;
- (IBAction)checkStrategyAction:(id)sender;

- (void)setData:(NSDictionary *)data;
- (void)requestSetMyHopital;

- (IBAction)buttonClicked:(id)sender;

@end
