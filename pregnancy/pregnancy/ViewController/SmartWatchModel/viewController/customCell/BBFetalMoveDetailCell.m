//
//  BBFetalMoveDetailCell.m
//  pregnancy
//
//  Created by whl on 13-11-14.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBFetalMoveDetailCell.h"

@implementation BBFetalMoveDetailCell

- (void)dealloc
{
    [_stratLabel release];
    [_endLabel release];
    [_numberLabel release];
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
    self.stratLabel.text = [BBTimeUtility stringAccuracyDateWithPastTimes:[[dicData stringForKey:@"begin_ts"]doubleValue]];
    self.endLabel.text = [BBTimeUtility stringAccuracyDateWithPastTimes:[[dicData stringForKey:@"end_ts"]doubleValue]];
    self.numberLabel.text =  [dicData stringForKey:@"valid_count"];
}

@end
