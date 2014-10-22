//
//  BBEditPersonalCell.m
//  pregnancy
//
//  Created by zhangzhongfeng on 14-1-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBEditPersonalCell.h"

@implementation BBEditPersonalCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addBg];
        [self addAvatarImageView];
        [self addUserAttributeLable];
        [self addUserValueLabel];
    }
    return self;
}

- (void)addBg
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
}

- (void)addAvatarImageView
{
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 40, 40)];
    [self addSubview:self.avatarImageView];
}

- (void)addUserAttributeLable
{
    self.userValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 10, 175, 30)];
    self.userValueLabel.backgroundColor = [UIColor clearColor];
    [self.userValueLabel setTextAlignment:NSTextAlignmentLeft];
    self.userValueLabel.textColor = RGBColor(85, 85, 85, 1);
    self.userValueLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.userValueLabel];
}

- (void)addUserValueLabel
{
    self.userAttributeLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 30)];
    self.userAttributeLable.backgroundColor = [UIColor clearColor];
    [self.userAttributeLable setTextAlignment:NSTextAlignmentLeft];
    self.userAttributeLable.textColor = RGBColor(85, 85, 85, 1);
    self.userAttributeLable.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.userAttributeLable];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
