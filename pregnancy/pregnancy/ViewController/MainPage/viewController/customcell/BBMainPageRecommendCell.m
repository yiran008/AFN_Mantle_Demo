//
//  BBMainPageRecommendCell.m
//  pregnancy
//
//  Created by liumiao on 4/9/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBMainPageRecommendCell.h"

@implementation BBMainPageRecommendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView setBackgroundColor:RGBColor(239, 239, 244, 1)];
//        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 7, 320, 1)];
//        [line1 setBackgroundColor:[UIColor colorWithHex:0xdddddd]];
//        [self.contentView addSubview:line1];
        UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 11, 320, 1)];
        [line1 setImage:[UIImage imageNamed:@"mainPageSepLine"]];
        [self.contentView addSubview:line1];
        UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 366, 320, 1)];
        [line2 setImage:[UIImage imageNamed:@"mainPageSepLine"]];
        [self.contentView addSubview:line2];

        self.m_BgView = [[UIView alloc]initWithFrame:CGRectMake(0, 12, 320, 354)];
        [self.m_BgView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.m_BgView];
        
        self.m_CellHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 8, 120, 20)];
        [self.m_CellHeaderLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self.m_CellHeaderLabel setTextColor:[UIColor colorWithHex:0xff537b]];
        [self.m_CellHeaderLabel setBackgroundColor:[UIColor clearColor]];
        self.m_CellHeaderLabel.text = @"宝宝树推荐";
        [self.m_BgView addSubview:self.m_CellHeaderLabel];
        
        self.m_MoreButton = [[UIButton alloc]initWithFrame:CGRectMake(268, 2, 40, 28)];
        [self.m_MoreButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.m_MoreButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.m_MoreButton setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
        self.m_MoreButton.exclusiveTouch = YES;
        [self.m_MoreButton setTitle:@"更多" forState:UIControlStateNormal];
        [self.m_BgView addSubview:self.m_MoreButton];
        
        for (int i=0; i<=3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.exclusiveTouch = YES;
            button.tag = i+10;
            [button setFrame:CGRectMake(0, 81*i+27+i*1, 320, 81)];
            [button setBackgroundImage:[UIImage imageNamed:@"mainPageRecommendTopicCellBg"]  forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(recommendTopicAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            UIImageView *avtarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 8, 90, 65)];
            avtarImageView.tag = i+30;
            [avtarImageView setContentMode:UIViewContentModeScaleAspectFill];
            avtarImageView.clipsToBounds = YES;
            [button addSubview:avtarImageView];
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(108, 8, 200, 40)];
            [textLabel setTextAlignment:NSTextAlignmentLeft];
            textLabel.numberOfLines = 2;
            textLabel.tag = i+50;
            [textLabel setTextColor:[UIColor colorWithHex:0x333333]];
            [textLabel setBackgroundColor:[UIColor clearColor]];
            [textLabel setFont:[UIFont systemFontOfSize:14]];
            [button addSubview:textLabel];
            
            // 添加浏览 评论
            UIImageView *scanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(108, 62, 12, 10)];
            scanImageView.image = [UIImage imageNamed:@"mainPageScan"];
            [button addSubview:scanImageView];
            UILabel *scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(124, 62, 70, 10)];
            scanLabel.tag = i + 60;
            scanLabel.font = [UIFont systemFontOfSize:10.0f];;
            scanLabel.textColor = [UIColor colorWithHex:0x999999];
            scanLabel.backgroundColor = [UIColor clearColor];
            [button addSubview:scanLabel];
            
            UIImageView *commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(198, 62, 12, 10)];
            commentImageView.image = [UIImage imageNamed:@"mainPageComment"];
            [button addSubview:commentImageView];
            UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(214, 62, 70, 10)];
            commentLabel.tag = i + 70;
            commentLabel.font = [UIFont systemFontOfSize:10.0f];;
            commentLabel.textColor = [UIColor colorWithHex:0x999999];
            commentLabel.backgroundColor = [UIColor clearColor];
            [button addSubview:commentLabel];
            
            
            if (i!=3)
            {
                UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(12, button.frame.origin.y+81, 296, 1)];
                [line setImage:[UIImage imageNamed:@"mainPageSepLine"]];
                [self.m_BgView addSubview:line];
            }
            [self.m_BgView addSubview:button];
        }
    }
    return self;
}

-(void)setCellUseData:(id)data
{
    NSArray *recommendArray = (NSArray*)data;
    if (recommendArray!=nil && [recommendArray count]>0)
    {
        for (int i=0; i<=3; i++) {
            UIButton *button = (UIButton *)[self.m_BgView viewWithTag:i+10];
            UIImageView *avtarImageView = (UIImageView *)[button viewWithTag:i+30];
            UILabel *textLabel = (UILabel *)[button viewWithTag:i+50];
            UILabel *scanLabel = (UILabel *)[button viewWithTag:i+60];
            UILabel *commentLabel = (UILabel *)[button viewWithTag:i+70];
            if (i<[recommendArray count]) {
                [button setHidden:NO];
                if (i==0) {
                    [avtarImageView setImageWithURL:[NSURL URLWithString:[[recommendArray objectAtIndex:i]stringForKey:@"img_small"]] placeholderImage:[UIImage imageNamed:@"tuijian_bg"]];
                }else{
                    [avtarImageView setImageWithURL:[NSURL URLWithString:[[recommendArray objectAtIndex:i]stringForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"tuijian_bg"]];
                }
                [textLabel setText:[[recommendArray objectAtIndex:i]stringForKey:@"title"]];
                [textLabel alignTop];
                
                [scanLabel setText:[[recommendArray objectAtIndex:i]stringForKey:@"view_count"]];
                [commentLabel setText:[[recommendArray objectAtIndex:i]stringForKey:@"reply_count"]];
            }else{
                [avtarImageView setImage:[UIImage imageNamed:@"tuijian_bg"]];
                [textLabel setText:@""];
                [scanLabel setText:@"0"];
                [commentLabel setText:@"0"];
                [button setHidden:YES];
            }
        }
    }
}
-(void)recommendTopicAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    int index = button.tag-10;
    if (self.m_RecommendBlock)
    {
        self.m_RecommendBlock(index);
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
