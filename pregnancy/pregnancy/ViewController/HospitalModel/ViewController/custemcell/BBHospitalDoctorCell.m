//
//  BBHospitalDoctorCell.m
//  pregnancy
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBHospitalDoctorCell.h"
#import "BBDoctorPostListView.h"

@implementation BBHospitalDoctorCell

@synthesize doctorName, doctorTitle, topicCount, doctorData, groupId;//, delegate;

- (void)dealloc
{
    [doctorName release];
    [doctorTitle release];
    [topicCount release];
    [doctorData release];
    [groupId release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)setData:(NSDictionary *)data
{
    self.doctorData = data;
    
    self.doctorName.text = [self.doctorData stringForKey:@"name"];
    self.doctorTitle.text = [self.doctorData stringForKey:@"title"];
    self.topicCount.text = [NSString stringWithFormat:@"相关讨论%@个",[self.doctorData stringForKey:@"topic_count"]];
    self.exclusiveTouch = YES;
}


@end

