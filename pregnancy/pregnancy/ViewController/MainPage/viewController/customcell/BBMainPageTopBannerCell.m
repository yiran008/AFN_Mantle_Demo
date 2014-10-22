//
//  BBMainPageTopBannerCell.m
//  pregnancy
//
//  Created by liumiao on 4/9/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBMainPageTopBannerCell.h"

@implementation BBMainPageTopBannerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.m_BannerEmptyView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 134)];
        [self.contentView addSubview:self.m_BannerEmptyView];
        
        self.m_BannerView = [[BBBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 134) scrollDirection:ScrollDirectionLandscape images:nil];
        [self.m_BannerView setSquare:YES];
        [self.m_BannerView setPageControlStyle:PageStyle_Right];
        [self.m_BannerView setRollingDelayTime:3.0];
        self.m_BannerView.hidden = YES;
        
        [self.contentView addSubview:self.m_BannerView];
        [self.contentView bringSubviewToFront:self.m_BannerView];
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
        if (!self.m_BannerView.hidden)
        {
            self.m_BannerEmptyView.hidden = YES;
        }
    }
    else
    {
        self.m_BannerEmptyView.hidden = NO;
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
