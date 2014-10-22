//
//  BBAdminCell.m
//  pregnancy
//
//  Created by whl on 14-8-29.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBAdminCell.h"
#import "UIImageView+WebCache.h"

@implementation BBAdminCell

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


-(void)setCollectionCellData:(BBCircleAdminClass*)adminObj
{
    CGSize size = self.m_AvatarImage.size;
    [self.m_AvatarImage roundCornersTopLeft:size.width/2 topRight:size.width/2 bottomLeft:size.height/2 bottomRight:size.height/2];
    self.m_AdminObj = adminObj;
    self.m_SendMessageButton.exclusiveTouch = YES;

    self.backgroundColor = [UIColor whiteColor];
    [self.m_AvatarImage setImageWithURL:[NSURL URLWithString:adminObj.m_UserAvatar] placeholderImage:[UIImage imageNamed:@"personal_default_avatar"]];
    if([adminObj.m_UserName isNotEmpty])
    {
        CGSize userNameSize = [adminObj.m_UserName sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(MAXFLOAT, 21) lineBreakMode:NSLineBreakByCharWrapping];
        if (userNameSize.width > 120)
        {
            self.m_NameLabel.width = 120;
        }
        else
        {
            self.m_NameLabel.width = userNameSize.width;
        }
        self.m_NameLabel.text = adminObj.m_UserName;
    }
    else
    {
        self.m_NameLabel.text = @"";
    }
    
    if (![adminObj.m_UserRank isNotEmpty])
    {
        adminObj.m_UserRank = @"0";
    }
    self.m_RankLabel.text = [NSString stringWithFormat:@"LV.%@",adminObj.m_UserRank];
    self.m_RankLabel.left = 76 + self.m_NameLabel.width + 10;
    
    if ([adminObj.m_UserPregnancy isNotEmpty])
    {
        self.m_PregnancyLabel.text = adminObj.m_UserPregnancy;
        self.m_AdressLabel.top = 48;
    }
    else
    {
        self.m_PregnancyLabel.text = @"";
        self.m_AdressLabel.top = 30;
    }
    
    self.m_AdressLabel.text = @"";
    
    if ([adminObj.m_UserAdress isNotEmpty])
    {
        self.m_AdressLabel.text = adminObj.m_UserAdress;
    }
}

-(IBAction)clickedSendMesage:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clickedSendMessage:)])
    {
        [self.delegate clickedSendMessage:self.m_AdminObj];
    }
}
@end
