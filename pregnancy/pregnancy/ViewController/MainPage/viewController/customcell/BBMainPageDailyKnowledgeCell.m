//
//  BBMainPageDailyKnowledgeCell.m
//  pregnancy
//
//  Created by liumiao on 4/9/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBMainPageDailyKnowledgeCell.h"
#import "BBKonwlegdeModel.h"
@implementation BBMainPageDailyKnowledgeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 11, 320, 1)];
        [line1 setImage:[UIImage imageNamed:@"mainPageSepLine"]];
        [self.contentView addSubview:line1];
        UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 228, 320, 1)];
        [line2 setImage:[UIImage imageNamed:@"mainPageSepLine"]];
        [self.contentView addSubview:line2];
        self.m_BgView = [[UIView alloc]initWithFrame:CGRectMake(0, 12, 320, 216)];
        [self.m_BgView setBackgroundColor:[UIColor whiteColor]];
        
        self.m_CellHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 120, 20)];
        [self.m_CellHeaderLabel setFont:[UIFont systemFontOfSize:16]];
        [self.m_CellHeaderLabel setTextColor:[UIColor colorWithHex:0xff537b]];
        self.m_CellHeaderLabel.text = @"每日知识";
        [self.m_BgView addSubview:self.m_CellHeaderLabel];
        
        self.m_KnowledgeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 36, 296, 124)];
        [self.m_KnowledgeImageView setContentMode:UIViewContentModeScaleAspectFill];
        self.m_KnowledgeImageView.clipsToBounds = YES;
        [self.m_BgView addSubview:self.m_KnowledgeImageView];
        [self.m_KnowledgeImageView setBackgroundColor:[UIColor redColor]];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(12, 132, 296, 28)];
        [backView setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.3]];
        [self.m_BgView addSubview:backView];
        
        self.m_KnowledgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 132, 280, 28)];
        [self.m_KnowledgeLabel setBackgroundColor:[UIColor clearColor]];
        self.m_KnowledgeLabel.numberOfLines = 1;
        [self.m_KnowledgeLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
        [self.m_KnowledgeLabel setShadowOffset:CGSizeMake(0, 1)];
        [self.m_KnowledgeLabel setShadowColor:[UIColor colorWithHex:0x000000]];
        [self.m_KnowledgeLabel setTextColor:[UIColor colorWithHex:0xffffff]];
        [self.m_BgView addSubview:self.m_KnowledgeLabel];
        
        self.m_KnowledgeSummaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 170, 296, 36)];
        [self.m_KnowledgeSummaryLabel setBackgroundColor:[UIColor clearColor]];
        self.m_KnowledgeSummaryLabel.numberOfLines = 2;
        [self.m_KnowledgeSummaryLabel setFont:[UIFont systemFontOfSize:14.f]];
        [self.m_KnowledgeSummaryLabel setTextColor:[UIColor colorWithHex:0x5a5a5a]];
        [self.m_BgView addSubview:self.m_KnowledgeSummaryLabel];
        
        [self.contentView addSubview:self.m_BgView];

        [self.contentView setBackgroundColor:RGBColor(239, 239, 244, 1)];
    }
    return self;
}

-(void)setCellUseData:(id)data
{
    BBKonwlegdeModel *knowledgeModel = (BBKonwlegdeModel*)data;
    self.m_KnowledgeLabel.text = knowledgeModel.title;
    self.m_KnowledgeSummaryLabel.text = knowledgeModel.description;
    NSString *imagesStr = knowledgeModel.imgArrStr;
    NSString *url;
    if([imagesStr isNotEmpty])
    {
        NSArray *imageArray = [NSJSONSerialization JSONObjectWithData:[imagesStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        if([imageArray isNotEmpty])
        {
            NSDictionary *imageDict = [imageArray firstObject];
            url =[imageDict stringForKey:@"big_src"];
        }
    }
    if (url)
    {
        [self.m_KnowledgeImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"mainPageKnowHolder"]];
    }
    else
    {
        [self.m_KnowledgeImageView setImage:[UIImage imageNamed:@"mainPageKnowHolder"]];
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
