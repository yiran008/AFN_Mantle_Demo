//
//  BBKnowledgeFirstLVCell.m
//  pregnancy
//
//  Created by liumiao on 4/24/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBKnowledgeFirstLevelCell.h"

@implementation BBKnowledgeFirstLevelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.m_BgView = [[UIView alloc]initWithFrame:CGRectMake(0, 8, 320, 49)];
        [self.contentView addSubview:self.m_BgView];
        [self.m_BgView setBackgroundColor:[UIColor whiteColor]];
        
        self.m_KnowledgeSpeciesLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 23, 200, 20)];
        [self.contentView addSubview:self.m_KnowledgeSpeciesLabel];
        [self.m_KnowledgeSpeciesLabel setFont:[UIFont systemFontOfSize:16.f]];
        [self.m_KnowledgeSpeciesLabel setTextColor:[UIColor colorWithRed:68/255.f green:68/255.f blue:68/255.f alpha:1.0f]];
        [self.m_KnowledgeSpeciesLabel setBackgroundColor:[UIColor clearColor]];
        
        self.m_DetailArrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(295, 26, 9, 14)];
        [self.contentView addSubview:self.m_DetailArrowImageView];
        [self.m_DetailArrowImageView setImage:[UIImage imageNamed:@"cell_arrow"]];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 57, 320, 1)];
        [self.contentView addSubview:line];
        [line setImage:[UIImage imageNamed:@"community_grey_line"]];
    }
    return self;
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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted)
    {
        [self.m_BgView setBackgroundColor:[UIColor lightGrayColor]];
    }
    else
    {
        [self.m_BgView setBackgroundColor:[UIColor whiteColor]];
    }
}

@end
