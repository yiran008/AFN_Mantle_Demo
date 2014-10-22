//
//  BBTopListMemberCell.m
//  pregnancy
//
//  Created by whl on 14-9-3.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBTopListMemberCell.h"

@implementation BBTopListMemberCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

-(void)setMemberCellData:(BBMemberClass*)memberObj
{
    CGSize size = self.m_AvtarImage.size;
    [self.m_AvtarImage roundCornersTopLeft:size.width/2 topRight:size.width/2 bottomLeft:size.height/2 bottomRight:size.height/2];

    [self.m_AvtarImage setImageWithURL:[NSURL URLWithString:memberObj.m_UserAvatar] placeholderImage:[UIImage imageNamed:@"personal_default_avatar"]];
    if([memberObj.m_UserName isNotEmpty])
    {
        [self setCellViewFrame:self.m_NameLabel withLabelText:memberObj.m_UserName withMAXWidth:160 withFont:[UIFont systemFontOfSize:14.0]];
        self.m_NameLabel.text = memberObj.m_UserName;
    }
    else
    {
        self.m_NameLabel.text = @"";
    }
    
    if (![memberObj.m_UserRank isNotEmpty])
    {
        memberObj.m_UserRank = @"0";
    }
    self.m_SignLabel.text = memberObj.m_SignName;
    self.m_TopLabel.text = memberObj.m_UserTop;
    [self.m_SignImage setImageWithURL:[NSURL URLWithString:memberObj.m_SignImage] placeholderImage:nil];
    if ([memberObj.m_UserRank isNotEmpty])
    {
        self.m_RankLabel.text = [NSString stringWithFormat:@"LV.%@",memberObj.m_UserRank];
    }
    else
    {
        self.m_RankLabel.text = @"";
    }
    self.m_RankLabel.left = 76 + self.m_NameLabel.width;
    
    if ([memberObj.m_Contribution isNotEmpty])
    {
        NSString *str = [NSString stringWithFormat:@"周贡献: %@",memberObj.m_Contribution];
        [self setCellViewFrame:self.m_ContributionLabel withLabelText:str withMAXWidth:160 withFont:[UIFont systemFontOfSize:12.0]];
        self.m_ContributionLabel.text = str;
        self.m_AdressLabel.top = 50;
        self.m_PregnancyLabel.top = 50;
    }
    else
    {
        self.m_ContributionLabel.text = @"";
        self.m_AdressLabel.top = 30;
        self.m_PregnancyLabel.top = 30;
    }
    
    if ([memberObj.m_UserAdress isNotEmpty])
    {
        
        [self setCellViewFrame:self.m_AdressLabel withLabelText:memberObj.m_UserAdress withMAXWidth:100 withFont:[UIFont systemFontOfSize:12.0]];
        self.m_AdressLabel.text = memberObj.m_UserAdress;
        self.m_PregnancyLabel.left = 76 + self.m_AdressLabel.width;
    }
    else
    {
        self.m_AdressLabel.text = @"";
        self.m_PregnancyLabel.left = 66;
    }
    
    
    if ([memberObj.m_UserPregnancy isNotEmpty])
    {
        [self setCellViewFrame:self.m_PregnancyLabel withLabelText:memberObj.m_UserPregnancy withMAXWidth:100 withFont:[UIFont systemFontOfSize:12.0]];
        self.m_PregnancyLabel.text = memberObj.m_UserPregnancy;
    }
    else
    {
        self.m_PregnancyLabel.text = @"";
    }
}

-(void)setCellViewFrame:(UILabel*)CurrentLabel withLabelText:(NSString*)str withMAXWidth:(CGFloat)maxWith withFont:(UIFont*)font
{
    CGSize sizeRect = [str sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 21) lineBreakMode:NSLineBreakByCharWrapping];
    if (sizeRect.width > maxWith)
    {
        CurrentLabel.width = maxWith;
    }
    else
    {
        CurrentLabel.width = sizeRect.width;
    }
}

@end
