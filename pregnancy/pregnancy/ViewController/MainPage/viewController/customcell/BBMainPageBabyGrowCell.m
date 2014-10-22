//
//  BBMainPageBabyGrowCell.m
//  pregnancy
//
//  Created by liumiao on 4/9/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBMainPageBabyGrowCell.h"
#import "BBKonwlegdeModel.h"

// 宝宝发育图片边长
#define GROW_IMAGE_LENGTH 90

// 文字最大行数
#define TEXT_MAX_LINE 4

// cell内各元素之间间隔
#define SIDE_GAP 12

@implementation BBMainPageBabyGrowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.m_BgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 80)];
        [self.m_BgView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.m_BgView];
        
        self.m_BabyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, GROW_IMAGE_LENGTH, GROW_IMAGE_LENGTH)];
        [self.contentView addSubview:self.m_BabyImageView];
        
        self.m_ContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 7, 196, 66)];
        self.m_ContentLabel.numberOfLines = TEXT_MAX_LINE;
        [self.m_ContentLabel setBackgroundColor:[UIColor clearColor]];
        [self.m_ContentLabel setTextColor:[UIColor colorWithHex:0x5a5a5a]];
        [self.m_ContentLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.m_ContentLabel];
        
        self.m_SeplineView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 80, 300, 1)];
        [self.m_SeplineView setImage:[UIImage imageNamed:@"mainPageSepLine"]];
        [self.contentView addSubview:self.m_SeplineView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

+ (CGFloat)CalculateCellHeightUseData:(id)data
{
    BBKonwlegdeModel *growModel = (BBKonwlegdeModel*)data;
    if (!data)
    {
        return 0;
    }
    NSString *imagesStr = growModel.imgArrStr;
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
    if(url)
    {
        return GROW_IMAGE_LENGTH+SIDE_GAP*2+1;
    }
    else
    {
        NSString *content = growModel.title;
        CGSize contentSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(320-SIDE_GAP*2, GROW_IMAGE_LENGTH) withFont:[UIFont systemFontOfSize:14] withString:content maxLine:TEXT_MAX_LINE];
        return (int)(contentSize.height+1)+(SIDE_GAP*2+1);
    }

}

- (void)setData:(id)data cellHeight:(CGFloat)cellHeight
{
    BBKonwlegdeModel *growModel = (BBKonwlegdeModel*)data;
    if (!data)
    {
        return;
    }
    NSString *imagesStr = growModel.imgArrStr;
    [self.m_BgView setFrame:CGRectMake(0, 0, 320, cellHeight-1)];
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
    if(url)
    {
        self.m_BabyImageView.hidden = NO;
        [self.m_BabyImageView setFrame:CGRectMake(320-SIDE_GAP*2-GROW_IMAGE_LENGTH, SIDE_GAP, GROW_IMAGE_LENGTH, GROW_IMAGE_LENGTH)];
        [self.m_BabyImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"mainPageGrowHolder"]];
        [self.m_ContentLabel setFrame:CGRectMake(SIDE_GAP, SIDE_GAP, 320-SIDE_GAP*3-GROW_IMAGE_LENGTH, GROW_IMAGE_LENGTH)];
        
    }
    else
    {
        [self.m_BabyImageView setImage:nil];
        self.m_BabyImageView.hidden = YES;
        [self.m_ContentLabel setFrame:CGRectMake(SIDE_GAP, SIDE_GAP, 320-SIDE_GAP*2, cellHeight-(SIDE_GAP*2+1))];
    }
    [self.m_SeplineView setFrame:CGRectMake(0, cellHeight-1, 320, 1)];
    self.m_ContentLabel.text = growModel.title;

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
