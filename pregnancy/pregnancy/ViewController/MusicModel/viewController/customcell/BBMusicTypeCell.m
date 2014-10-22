//
//  BBMusicTypeCell.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-23.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBMusicTypeCell.h"
@interface BBMusicTypeCell ()
@property (nonatomic, retain) UIImageView   *musicTypeImageview;
@property (nonatomic, retain) UILabel   *titleLabel;
@property (nonatomic, retain) UILabel       *descriptionLabel;
@end

@implementation BBMusicTypeCell

- (void)dealloc {
    [_musicTypeInfo release];
    [_musicTypeImageview release];
    [_titleLabel release];
    [_descriptionLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView setBackgroundColor:RGBColor(239, 239, 244, 1)];
        [self addBg];
        [self addMusicTypeImageView];
        [self addTitleLabel];
        [self addDescriptionLabel];
        [self addAcessory];
    }
    return self;
}

- (void)addMusicTypeImageView {
    self.musicTypeImageview = [[[UIImageView alloc] initWithFrame:CGRectMake(20, 25, 40, 40)] autorelease];
    [self addSubview:self.musicTypeImageview];
}

- (void)addBg {
    UIView *bg = [[[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 70)] autorelease];
    bg.backgroundColor = [UIColor whiteColor];
    [self addSubview:bg];
}

- (void)addAcessory
{
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(290, 36, 12, 18)] autorelease];
    imageView.image = [UIImage imageNamed:@"accessoryArrow"];
    [self addSubview:imageView];
}

- (void)addTitleLabel {
    self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(65, 20, 230, 30)] autorelease];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor colorWithRed:102/255. green:102/255. blue:102/255. alpha:1];
    [self addSubview:self.titleLabel];
}

- (void)addDescriptionLabel {
    self.descriptionLabel = [[[UILabel alloc ] initWithFrame:CGRectMake(65, 50, 230, 20)] autorelease];
    self.descriptionLabel.backgroundColor = [UIColor clearColor];
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionLabel.font = [UIFont systemFontOfSize:12];
    self.descriptionLabel.textColor = [UIColor colorWithRed:102/255. green:102/255. blue:102/255. alpha:1];
    [self addSubview:self.descriptionLabel];
}

- (void)resetCell
{
    self.titleLabel.text = [self.musicTypeInfo stringForKey:@"title"];
    self.descriptionLabel.text = [self.musicTypeInfo stringForKey:@"describe"];
    [self.musicTypeImageview setImageWithURL:[NSURL URLWithString:[self.musicTypeInfo stringForKey:@"icon_url"]]];
    if ([[self.musicTypeInfo stringForKey:@"valid"] intValue] == 1) {
        self.descriptionLabel.textColor = [UIColor colorWithRed:255/255. green:94/255. blue:122/255. alpha:1];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([[defaults objectForKey:[[self.musicTypeInfo stringForKey:@"url"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] isEqualToString:@"YES"]) {
            self.descriptionLabel.text = @"已激活";
        }else {
            self.descriptionLabel.text = [self.musicTypeInfo stringForKey:@"describe"];
        }
    }else {
        self.descriptionLabel.textColor = [UIColor colorWithRed:102/255. green:102/255. blue:102/255. alpha:1];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
