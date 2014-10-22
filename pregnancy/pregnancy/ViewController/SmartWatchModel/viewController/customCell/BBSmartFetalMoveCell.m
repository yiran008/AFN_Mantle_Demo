//
//  BBSmartFetalMoveCell.m
//  pregnancy
//
//  Created by whl on 13-11-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBSmartFetalMoveCell.h"

@implementation BBSmartFetalMoveCell

- (void)dealloc
{
    [_dateLabel release];
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
    self.dateLabel.text = [dicData stringForKey:@"date"];
    self.numberLabel.text = [dicData stringForKey:@"valid_count"];
}
@end
