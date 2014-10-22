//
//  BBSmartWeightCell.m
//  pregnancy
//
//  Created by whl on 13-11-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBSmartWeightCell.h"

@implementation BBSmartWeightCell

- (void)dealloc
{
    [_dateLabel release];
    [_weekLabel release];
    [_weightLabel release];
    [_changeLabel release];
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
    self.weekLabel.text = [dicData stringForKey:@"week"];
    self.weightLabel.text = [dicData stringForKey:@"curr_weight"];
    self.changeLabel.text = [dicData stringForKey:@"gap_weight"];
    
}
@end
