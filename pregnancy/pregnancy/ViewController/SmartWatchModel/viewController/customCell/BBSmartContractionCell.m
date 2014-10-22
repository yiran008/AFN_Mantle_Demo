//
//  BBSmartContractionCell.m
//  pregnancy
//
//  Created by whl on 13-11-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBSmartContractionCell.h"

@implementation BBSmartContractionCell

- (void)dealloc
{
    [_dateLabel release];
    [_startLabel release];
    [_endLabel release];
    [_frequencyLabel release];
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
    self.dateLabel.text = [dicData stringForKey:@"date"];
    self.startLabel.text = [BBTimeUtility stringAccuracyDateWithPastTimes:[[dicData stringForKey:@"begin_ts"]doubleValue]];
    self.endLabel.text = [BBTimeUtility stringAccuracyDateWithPastTimes:[[dicData stringForKey:@"end_ts"]doubleValue]];;
    self.frequencyLabel.text = [dicData stringForKey:@"frequency"];
    self.durationLabel.text = [dicData stringForKey:@"average_duration"];
}

@end
