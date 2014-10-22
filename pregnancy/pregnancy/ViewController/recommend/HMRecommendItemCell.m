//
//  HMRecommendItemCell.m
//  lama
//
//  Created by songxf on 13-6-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMRecommendItemCell.h"
#import "UIImageView+WebCache.h"

@implementation HMRecommendItemCell
@synthesize titleLab;
@synthesize itemData;
@synthesize picView;
@synthesize bgView;
@synthesize activity;

- (void)dealloc
{
    [activity release];
    [titleLab release];
    [itemData release];
    [picView release];
    [bgView release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // 选中后效果背景
        UIView *bg = [[[UIView alloc] initWithFrame:CGRectMake(3, 3, self.width-6, self.height-6)] autorelease];
        bg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:bg];
        self.bgView = bg;

        // 缩略图
        UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
        self.picView = imageView;
        imageView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
        [self.contentView addSubview:imageView];

        self.activity = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)] autorelease];
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [picView addSubview:activity];
        [activity centerInSuperView];

        UILabel *lab = [[[UILabel alloc] init] autorelease];
        self.titleLab = lab;
        lab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lab];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    bgView.height = self.height - 6;
    bgView.width = self.width - 6;
    
    if (highlighted)
    {
        bgView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
    }
    else
    {
        bgView.backgroundColor = [UIColor clearColor];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (void)setNewData:(HMRecommendModel *)data style:(BOOL)isBig itemHeight:(float)height
{
    self.itemData = data;
    titleLab.text = data.title;
    
    if (isBig)
    {
        // 头条大区域展示 各项设置
        picView.frame = CGRectMake(DISTANCE_ABOUT_TABLELEFT, DISTANCE_ABOUT_TABLELEFT, getScreenWidth()-(DISTANCE_ABOUT_SCREENLEFT+DISTANCE_ABOUT_TABLELEFT)*2, BIG_ITEM_HEIGHT-DISTANCE_ABOUT_TABLELEFT*2);
        
        titleLab.frame = CGRectMake(DISTANCE_ABOUT_TABLELEFT, BIG_ITEM_HEIGHT-DISTANCE_ABOUT_TABLELEFT-29, getScreenWidth()-(DISTANCE_ABOUT_SCREENLEFT+DISTANCE_ABOUT_TABLELEFT)*2, 29);
        titleLab.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.numberOfLines = 1;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:16];
    }
    else
    {
        // 小区域设置
//        picView.frame = CGRectMake(235, (height-SMALL_PIC_HEIGHT)/2, SMALL_PIC_HEIGHT, SMALL_PIC_HEIGHT);
        picView.frame = CGRectMake(225, (height-SMALL_PIC_HEIGHT)/2, SMALL_PIC_WIDTH, SMALL_PIC_HEIGHT);
        [picView setClipsToBounds:YES];
        [picView setContentMode:UIViewContentModeScaleAspectFill];
        
        titleLab.frame = CGRectMake(DISTANCE_ABOUT_TABLELEFT, 0, 210, height);
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.textColor = [UIColor blackColor];
        titleLab.numberOfLines = 0;
        titleLab.font = [UIFont systemFontOfSize:16];
    }
     
    [activity centerInSuperView];
    [activity startAnimating];
    [picView setImageWithURL:[data getPicURL] placeholderImage:nil options:0 success:^(UIImage *image, BOOL cached) {
        [activity stopAnimating];
    } failure:^(NSError *error) {
        [activity stopAnimating];
    }];
}

@end
