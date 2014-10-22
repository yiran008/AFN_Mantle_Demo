//
//  BBKuaidiPlaceCell.m
//  pregnancy
//
//  Created by ZHENGLEI on 13-12-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBKuaidiPlaceCell.h"

@implementation BBKuaidiPlaceCell

- (void)dealloc
{
    [_icon release];
    [_mainLabel release];
    [_infoLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSugestData:(NSDictionary *)dic
{
    if ([dic stringForKey:@"name"])
    {
        self.mainLabel.text = [dic stringForKey:@"name"];
    }
    if ([dic stringForKey:@"district"])
    {
        self.infoLabel.text = [dic stringForKey:@"district"];
    }
    self.mainLabel.frame = CGRectMake(18, self.mainLabel.frame.origin.y, self.mainLabel.frame.size.width, self.mainLabel.frame.size.height);
    self.infoLabel.frame = CGRectMake(18, self.infoLabel.frame.origin.y, self.infoLabel.frame.size.width, self.infoLabel.frame.size.height);
    self.icon.hidden = YES;
}

- (void)setGeoArrData:(NSDictionary *)dic
{
    if ([dic stringForKey:@"name"])
    {
        self.mainLabel.text = [dic stringForKey:@"name"];
    }
    if ([dic stringForKey:@"addr"])
    {
        self.infoLabel.text = [dic stringForKey:@"addr"];
    }
    self.mainLabel.frame = CGRectMake(18, self.mainLabel.frame.origin.y, self.mainLabel.frame.size.width, self.mainLabel.frame.size.height);
    self.infoLabel.frame = CGRectMake(18, self.infoLabel.frame.origin.y, self.infoLabel.frame.size.width, self.infoLabel.frame.size.height);
    self.icon.hidden = YES;
}

- (void)setGeoStrData:(NSString *)str
{
    self.mainLabel.text = @"您的位置";
    self.infoLabel.text = str;
    self.mainLabel.frame = CGRectMake(38, self.mainLabel.frame.origin.y, self.mainLabel.frame.size.width, self.mainLabel.frame.size.height);
    self.infoLabel.frame = CGRectMake(38, self.infoLabel.frame.origin.y, self.infoLabel.frame.size.width, self.infoLabel.frame.size.height);
    self.icon.hidden = NO;
}

@end
