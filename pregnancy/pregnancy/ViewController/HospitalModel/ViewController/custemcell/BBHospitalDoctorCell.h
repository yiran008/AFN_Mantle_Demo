//
//  BBHospitalDoctorCell.h
//  pregnancy
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBHospitalDoctorCell : UITableViewCell
{
    IBOutlet UILabel *doctorName;
    IBOutlet UILabel *doctorTitle;
    IBOutlet UILabel *topicCount;
    
    NSDictionary *doctorData;
    NSString *groupId;
}

@property (nonatomic, retain) IBOutlet UILabel *doctorName;
@property (nonatomic, retain) IBOutlet UILabel *doctorTitle;
@property (nonatomic, retain) IBOutlet UILabel *topicCount;
@property (nonatomic, retain) NSDictionary *doctorData;
@property (nonatomic, retain) NSString *groupId;

- (void)setData:(NSDictionary *)data;

@end




