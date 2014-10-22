//
//  BBMainPageTimingPrepareCell.m
//  pregnancy
//
//  Created by liumiao on 4/9/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBMainPageTimingPrepareCell.h"

@implementation BBMainPageTimingPrepareCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:bgView];
        self.m_PregnantButton = [[UIButton alloc]initWithFrame:CGRectMake(12, 10, 296, 44)];
        UIImage *bgImage = [UIImage imageWithColor:[UIColor colorWithHex:0xff95a4] size:CGSizeMake(296, 44)];
        [self.m_PregnantButton setBackgroundImage:bgImage forState:UIControlStateNormal];
        [self.m_PregnantButton setTitle:@"我怀孕了" forState:UIControlStateNormal];
        [self.m_PregnantButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self.m_PregnantButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.m_PregnantButton.exclusiveTouch = YES;
        [self.contentView addSubview:self.m_PregnantButton];
        [self.contentView setBackgroundColor:RGBColor(239, 239, 244, 1)];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 1)];
        [line setImage:[UIImage imageNamed:@"mainPageSepLine"]];
        [self.contentView addSubview:line];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
