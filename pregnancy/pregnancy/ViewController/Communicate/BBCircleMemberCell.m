//
//  BBCircleMemberCell.m
//  pregnancy
//
//  Created by whl on 14-9-2.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBCircleMemberCell.h"

@implementation BBCircleMemberCell

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
    if (self) {
        
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
        [self setCellViewFrame:self.m_NameLabel withLabelText:memberObj.m_UserName withMAXWidth:200 withFont:[UIFont systemFontOfSize:14.0]];
        self.m_NameLabel.text = memberObj.m_UserName;
    }
    else
    {
        self.m_NameLabel.text = @"";
    }
    
    if ([memberObj.m_UserRank isNotEmpty])
    {
        self.m_RankLabel.text = [NSString stringWithFormat:@"LV.%@",memberObj.m_UserRank];
    }
    else
    {
        self.m_RankLabel.text = @"";
    }
    self.m_RankLabel.left = 76 + self.m_NameLabel.width + 10;
    
    
    self.m_Dislabel.hidden = YES;
    if (memberObj.m_MemberType == BBDistancemember)
    {
        self.m_Dislabel.hidden = NO;
    }
    
    if ([memberObj.m_Distance isNotEmpty])
    {
        self.m_Dislabel.text = memberObj.m_Distance;
    }
    else
    {
        self.m_Dislabel.text = @"";
    }
    
    if ([memberObj.m_UserAdress isNotEmpty])
    {
        
        [self setCellViewFrame:self.m_AdressLabel withLabelText:memberObj.m_UserAdress withMAXWidth:200 withFont:[UIFont systemFontOfSize:12.0]];
        self.m_AdressLabel.text = memberObj.m_UserAdress;
        self.m_PregnancyLabel.left = 76 + self.m_AdressLabel.width +12;
    }
    else
    {
        self.m_AdressLabel.text = @"";
        self.m_PregnancyLabel.left = 76;
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
    
    if (![memberObj.m_UserAdress isNotEmpty] && ![memberObj.m_UserPregnancy isNotEmpty])
    {
        self.m_HospitalLabel.top = 30;
    }
    else
    {
        self.m_HospitalLabel.top = 50;
    }
    
    if ([memberObj.m_UserHospital isNotEmpty])
    {
        [self setCellViewFrame:self.m_HospitalLabel withLabelText:memberObj.m_UserHospital withMAXWidth:240 withFont:[UIFont systemFontOfSize:12.0]];
        self.m_HospitalLabel.text = memberObj.m_UserHospital;
    }
    else
    {
        self.m_HospitalLabel.text = @"";
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
