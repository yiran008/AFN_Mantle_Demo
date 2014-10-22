//
//  BBMainPageMidBannerCell.m
//  pregnancy
//
//  Created by liumiao on 4/9/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBMainPageMidBannerCell.h"

@implementation BBMainPageMidBannerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.m_BannerView = [[BBBannerView alloc] initWithFrame:CGRectMake(0, 11, 320, 70) scrollDirection:ScrollDirectionLandscape images:nil];
        [self.m_BannerView showClose:YES];
        [self.m_BannerView setRollingDelayTime:3.0];
        [self.m_BannerView setSquare:YES];
        self.m_BannerView.hidden = YES;

        [self.contentView addSubview:self.m_BannerView];
        [self.contentView setBackgroundColor:RGBColor(239, 239, 244, 1)];
    }
    return self;
}

-(void)setCellUseData:(id)data
{
    NSArray *bannerArray = (NSArray*)data;
    if (bannerArray !=nil && [bannerArray count] > 0)
    {
        [self.m_BannerView reloadBannerWithData:bannerArray];
    }
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
