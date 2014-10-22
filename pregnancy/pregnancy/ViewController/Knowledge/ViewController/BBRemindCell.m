//
//  BBRemindCellTableViewCell.m
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBRemindCell.h"

@interface BBRemindCell ()
@property(nonatomic,strong)BBRemindCellAdView *remindAd;
@property(nonatomic,strong)BBRemindCellImageView *remindImage;
@property(nonatomic,strong)BBRemindCellContentView *remindContent;

@end

@implementation BBRemindCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(BBKonwlegdeModel *)data AdData:(BBAdModel *)adData
{
    BOOL isHasImage = data.image && data.image.length > 1;
    if (isHasImage)
    {
        if (!self.remindImage)
        {
            self.remindImage = [[BBRemindCellImageView alloc]initWithFrame:CGRectZero];
            [self addSubview:self.remindImage];
        }
        self.remindImage.frame = CGRectMake(0, 0, self.contentView.frame.size.width, REMIND_IMGEVIEW_MINHEIGHT);
        self.remindImage.data = data;

        UITapGestureRecognizer *adTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adTapped:)];
        [self.remindImage addGestureRecognizer:adTap];
    }
    self.remindImage.hidden = isHasImage?NO:YES;
    
    //必有view
    if (!self.remindContent)
    {
        self.remindContent = [[BBRemindCellContentView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.remindContent];
    }
    if (data.textHight + 20 > REMIND_CONTENTVIEW_MINHEIGHT)
    {
        self.remindContent.frame = CGRectMake(0, isHasImage? REMIND_IMGEVIEW_MINHEIGHT:0, self.contentView.frame.size.width, data.textHight + 20);
    }else
        self.remindContent.frame = CGRectMake(0, isHasImage? REMIND_IMGEVIEW_MINHEIGHT:0, self.contentView.frame.size.width, REMIND_CONTENTVIEW_MINHEIGHT);
    self.remindContent.line.hidden = isHasImage?YES:NO;
    self.remindContent.dateView.hidden = isHasImage?YES:NO;
    self.remindContent.data = data;
    if (adData)
    {
        if (!self.remindAd)
        {
            self.remindAd = [[BBRemindCellAdView alloc]initWithFrame:CGRectZero];
            [self addSubview:self.remindAd];
        }
        self.remindAd.frame = CGRectMake(0, self.remindContent.frame.origin.y + self.remindContent.frame.size.height, self.contentView.frame.size.width, adData.adContextHeight + 20);
        self.remindAd.hidden = NO;
        [self.remindAd setData:adData];
    }else
    {
        self.remindAd.hidden = YES;
    }
}

- (void)adTapped:(UIGestureRecognizer *)recognizer
{
    if (self.remindImage && self.delegate && [self.delegate respondsToSelector:@selector(BBRemindCell:imageClicked:)])
    {
        [self.delegate BBRemindCell:self imageClicked:self.remindImage.imageView];
    }
}

@end
