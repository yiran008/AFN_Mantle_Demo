//
//  BBRemindCellImageView.m
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-15.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBRemindCellImageView.h"
#import "UIImageView+WebCache.h"
#import "BBKnowledgeDateLabelView.h"

@interface BBRemindCellImageView()
@property(nonatomic,strong)BBKnowledgeDateLabelView * dateView;
@property UIImageView * line;
@end

@implementation BBRemindCellImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.dateView = [[BBKnowledgeDateLabelView alloc]initWithFrame:CGRectMake(10, 10, 48, 68)];
        [self addSubview:self.dateView];
        
        UIImageView * imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(78, 10, 161, 161)];
        imgBack.image = [[UIImage imageNamed:@"pic_kuang"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.5, 0.5, 160, 160)];
        [imgBack addSubview:self.imageView];
        
        [self addSubview:imgBack];
        
        self.line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
        self.line.backgroundColor = RGBColor(208, 208, 208, 1);
        [self addSubview:self.line];
    }
    return self;
}

- (void)setData:(BBKonwlegdeModel *)data
{
    if (data.image)
    {
        [self.imageView setImageWithURL:[NSURL URLWithString:data.image] placeholderImage:[UIImage imageNamed:@"mainPageGrowHolder"]];
    }
    
    if (data.week)
    {
        [self.dateView setDateData:data];
    }
    
    if (data.period == knowlegdePeriodPregnancy && [data.days intValue]%7 == 0)
    {
        self.line.frame = CGRectMake(0, 0, 320, 0.5);
    }else
        self.line.frame = CGRectMake(10, 0, 320, 0.5);
    self.imageView.userInteractionEnabled = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
