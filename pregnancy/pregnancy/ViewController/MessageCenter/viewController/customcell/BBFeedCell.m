//
//  BBFeedCell.m
//  pregnancy
//
//  Created by liumiao on 9/10/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBFeedCell.h"

@implementation BBFeedCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.userAvatarButton.exclusiveTouch = YES;
    }
    return self;
}
- (void)setCellWithData:(BBFeedClass *)feedClass
{
    self.bgView.layer.borderColor = [[UIColor colorWithHex:0xcccccc] CGColor];
    self.bgView.layer.borderWidth = 0.5f;
    CGFloat cellHeight = 0;
    if (feedClass.m_CellHeight >0)
    {
        cellHeight = feedClass.m_CellHeight;
    }
    else
    {
        cellHeight = [feedClass cellHeight];
    }
    self.bgView.height = cellHeight - 8;
    self.bgView.top = 8;
    
    self.userAvatarButton.layer.masksToBounds = YES;
    self.userAvatarButton.layer.cornerRadius = 20.f;
    self.userAvatarButton.left = 12;
    self.userAvatarButton.top = 8;
    [self.userAvatarButton setImageWithURL:[NSURL URLWithString:feedClass.m_PosterImage] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    self.userNameLabel.left = self.userAvatarButton.right + 12;
    self.userNameLabel.top = 10;
    self.userNameLabel.text = feedClass.m_PosterName;
    
    self.babyAgeLabel.left = self.userNameLabel.left;
    self.babyAgeLabel.top = self.userNameLabel.bottom+2;
    self.babyAgeLabel.text = feedClass.m_BabyAge;
    
    self.createTSLabel.right = 298;
    self.createTSLabel.top = 12;
    self.createTSLabel.text = [NSDate hmStringDateFromTs:feedClass.m_CreateTime];
    
    self.picIcon.left = 12;
    self.eliteIcon.left = 12;
    self.helpIcon.left = 12;
    self.picIcon.hidden = YES;
    self.eliteIcon.hidden = YES;
    self.helpIcon.hidden = YES;
    
    if ([feedClass.m_Title isNotEmpty])
    {
        NSString *title = [feedClass.m_Title copy];
        CGFloat iconLeft = 8;
        if (feedClass.m_HasPic)
        {
            title = [NSString stringWithFormat:@"%@%@",ICON_HOLDER_STRING,title];
            self.picIcon.hidden = NO;
            self.picIcon.left = iconLeft+4;
            iconLeft = self.picIcon.right;
            self.picIcon.top = self.userAvatarButton.bottom + 10;
        }
        
        if (feedClass.m_IsElite)
        {
            title = [NSString stringWithFormat:@"%@%@",ICON_HOLDER_STRING,title];
            self.eliteIcon.hidden = NO;
            self.eliteIcon.left = iconLeft + 4;
            iconLeft = self.eliteIcon.right;
            self.eliteIcon.top = self.userAvatarButton.bottom + 10;
        }

        if (feedClass.m_IsHelp)
        {
            title = [NSString stringWithFormat:@"%@%@",ICON_HOLDER_STRING,title];
            self.helpIcon.hidden = NO;
            self.helpIcon.left = iconLeft + 4;
            iconLeft = self.helpIcon.right;
            self.helpIcon.top = self.userAvatarButton.bottom + 10;
        }

        self.topicTitleLabel.left = 12;
        CGSize onelineSize = [title calcSizeWithFont:[UIFont systemFontOfSize:16]];
        if (onelineSize.width > 296)
        {
            self.topicTitleLabel.height = 40;
            self.topicTitleLabel.top = self.userAvatarButton.bottom + 8;
        }
        else
        {
            self.topicTitleLabel.height = 20;
            self.topicTitleLabel.top = self.userAvatarButton.bottom + 9;
        }
        self.topicTitleLabel.text = title;
        self.topicTitleLabel.hidden = NO;
    }
    else
    {
        self.topicTitleLabel.text = @"";
        self.topicTitleLabel.hidden = YES;
    }

    
    if ([feedClass.m_Summary isNotEmpty])
    {
        self.topicSummuryLabel.hidden = NO;
        self.topicSummuryLabel.text = feedClass.m_Summary;
        self.topicSummuryLabel.top = self.topicTitleLabel.hidden ? (self.userAvatarButton.bottom + 5):(self.topicTitleLabel.bottom +5);
    }
    else
    {
        self.topicSummuryLabel.text = @"";
        self.topicSummuryLabel.hidden = YES;
    }
    
    self.circleLabel.left = 12;
    self.circleLabel.bottom = self.bgView.height-8;
    if ([feedClass.m_CircleName isNotEmpty])
    {
        self.circleLabel.text = [NSString stringWithFormat:@"来自：%@",feedClass.m_CircleName];
        self.circleLabel.hidden = NO;
    }
    else
    {
        self.circleLabel.text = @"";
        self.circleLabel.hidden = YES;
    }
    
    if (feedClass.m_ResponseCount>9999)
    {
        self.responceLabel.text = @"9999+";
    }
    else
    {
        self.responceLabel.text = [NSString stringWithFormat:@"%d",feedClass.m_ResponseCount];
    }
    self.responceLabel.bottom = self.bgView.height-7;
    self.responceIcon.bottom = self.bgView.height-8;
    self.responceLabel.right = 308;
    self.responceIcon.right = self.responceLabel.left-2;
}
@end
