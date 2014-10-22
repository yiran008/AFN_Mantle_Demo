//
//  BBPersonalListCell.m
//  pregnancy
//
//  Created by zhangzhongfeng on 14-1-7.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBPersonalListCell.h"

@implementation BBPersonalListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addIconImageView];
        [self addTitleLabel];
        [self addCountLabel];
        [self addArrowView];
        [self addSeparatorLine];
    }
    return self;
}

- (void)addSeparatorLine
{
    self.separatorLine = [[UIView alloc]initWithFrame:CGRectMake(17, 53, 303, 1)];
    [self.separatorLine setBackgroundColor:[UIColor colorWithHex:0xcccccc]];
    [self.separatorLine setSize:CGSizeMake(303, 0.5)];
    [self addSubview:self.separatorLine];
}

- (void)addIconImageView
{
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 16, 22, 22)];
    [self addSubview:self.iconImageView];
}

- (void)addTitleLabel
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 17, 160, 20)];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = RGBColor(142, 142, 142, 1);
    [self addSubview:self.titleLabel];
}

- (void)addCountLabel
{
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 17, 80, 20)];
    self.countLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.countLabel setTextAlignment:NSTextAlignmentRight];
    self.countLabel.textColor = RGBColor(255, 83, 123, 1);
    [self addSubview:self.countLabel];
}

- (void)addArrowView
{
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, 20, 9, 14)];
    arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
    [self addSubview:arrowImageView];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
