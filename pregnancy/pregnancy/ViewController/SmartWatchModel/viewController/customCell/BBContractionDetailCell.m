//
//  BBContractionDetailCell.m
//  pregnancy
//
//  Created by whl on 13-11-14.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBContractionDetailCell.h"


@implementation BBContractionDetailCell

- (void)dealloc
{
    [_startLabel release];
    [_endLabel release];
    [_durationLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
-(void)setupCell:(NSDictionary*)dicData
{
    self.startLabel.text = [BBTimeUtility stringAccuracyDateWithPastTimes:[[dicData stringForKey:@"begin_ts"]doubleValue]];
    self.endLabel.text = [BBTimeUtility stringAccuracyDateWithPastTimes:[[dicData stringForKey:@"end_ts"]doubleValue]];
    self.durationLabel.text =  [dicData stringForKey:@"duration_ts"];
}

@end
