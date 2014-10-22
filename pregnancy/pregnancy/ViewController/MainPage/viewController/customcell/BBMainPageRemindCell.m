//
//  BBMainPageRemindCell.m
//  pregnancy
//
//  Created by liumiao on 4/9/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBMainPageRemindCell.h"
#import "BBKonwlegdeModel.h"

@implementation BBMainPageRemindCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        self.m_BgView = [[UIView alloc]initWithFrame:CGRectMake(0, 12, 320, 110)];
        [self.m_BgView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.m_BgView];
        
        self.m_HeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 22, 80, 20)];
        self.m_HeaderLabel.text = @"关爱提醒";
        [self.m_HeaderLabel setFont:[UIFont systemFontOfSize:16]];
        [self.m_HeaderLabel setTextColor:[UIColor colorWithHex:0xff537b]];
        [self.contentView addSubview:self.m_HeaderLabel];
        [self.m_HeaderLabel setBackgroundColor:[UIColor clearColor]];
        
        self.m_TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 48, 296, 18)];
        [self.m_TitleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.m_TitleLabel setTextColor:[UIColor colorWithHex:0x5a5a5a]];
        [self.contentView addSubview:self.m_TitleLabel];
        [self.m_TitleLabel setBackgroundColor:[UIColor clearColor]];
        
        self.m_ContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 72, 296, 36)];
        [self.m_ContentLabel setFont:[UIFont systemFontOfSize:14.f]];
        [self.m_ContentLabel setNumberOfLines:2];
        [self.m_ContentLabel setTextColor:[UIColor colorWithHex:0x5a5a5a]];
        [self.m_ContentLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.m_ContentLabel];
        
        UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 11, 320, 1)];
        [line1 setImage:[UIImage imageNamed:@"mainPageSepLine"]];
        [self.contentView addSubview:line1];
        
        UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 122, 320, 1)];
        [line2 setImage:[UIImage imageNamed:@"mainPageSepLine"]];
        [self.contentView addSubview:line2];
        
        [self.contentView setBackgroundColor:RGBColor(239, 239, 244, 1)];
    }
    return self;
}

-(void)setCellUseData:(id)data
{
    BBKonwlegdeModel *remindModel = (BBKonwlegdeModel*)data;
    self.m_ContentLabel.text = remindModel.description;
    self.m_TitleLabel.text = remindModel.title;
    [self.m_ContentLabel alignTop];
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
