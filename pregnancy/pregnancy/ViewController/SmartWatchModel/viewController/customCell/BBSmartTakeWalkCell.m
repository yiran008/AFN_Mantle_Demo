//
//  BBSmartTakeWalkCell.m
//  pregnancy
//
//  Created by whl on 13-11-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBSmartTakeWalkCell.h"

@implementation BBSmartTakeWalkCell

- (void)dealloc
{
    [_dateLabel release];
    [_targetLabel release];
    [_actualLabel release];
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
    self.targetLabel.text = [dicData stringForKey:@"step_total"];
    self.actualLabel.text = [dicData stringForKey:@"step_actual"];
    NSString *step = [dicData stringForKey:@"step_percent"];
    self.durationLabel.text = [NSString stringWithFormat:@"%d%%",(NSInteger)([step floatValue]*100)];

}

@end
