//
//  BBHospitalPregnancyCell.h
//  pregnancy
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBHospitalPregnancyCell : UITableViewCell
<
    CallBack,
    BBLoginDelegate
>
{
    IBOutlet UIButton *headImage;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *dateLabel;
    
    NSDictionary *pregnancyData;
    UIViewController *viewCtrl;
}

@property (nonatomic, retain) IBOutlet UIButton *headImage;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) NSDictionary *pregnancyData;
@property (assign) UIViewController *viewCtrl;
- (void)setData:(NSDictionary *)data;
- (IBAction)sendMessageButtonClicked:(id)sender;

@end

