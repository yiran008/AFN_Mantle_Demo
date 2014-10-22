//
//  BBRemindCellContentView.m
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-15.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBRemindCellContentView.h"
#import "OHAttributedLabel.h"
#import "BBAutoCalculationSize.h"
#import "BBPregnancyInfo.h"

@interface BBRemindCellContentView ()

@property(nonatomic,strong)UILabel * contentLabel;
@property(nonatomic,assign)float textHeight;

@end

@implementation BBRemindCellContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.dateView = [[BBKnowledgeDateLabelView alloc]initWithFrame:CGRectMake(10, 10, 48, 68)];
        [self addSubview:self.dateView];
        
        UIImageView * imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(78, 10, 161, 161)];
        imgBack.image = [[UIImage imageNamed:@"pic_kuang"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [self addSubview:imgBack];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.contentLabel.font = [UIFont systemFontOfSize:REMIND_FONT_CONTENT];
        self.contentLabel.textColor = [UIColor grayColor];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.numberOfLines = 0;
        [self addSubview:self.contentLabel];
        
        self.line = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 320, 0.5)];
        self.line.backgroundColor = RGBColor(208, 208, 208, 1);
        [self addSubview:self.line];
    }
    return self;
}

- (void)setData:(BBKonwlegdeModel *)data
{
    if (data.week)
    {
        [self.dateView setDateData:data];
        
        self.contentLabel.text = data.title;
        if (self.contentLabel.text)
        {
            CGSize timeSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(230.0, 1024.0) withFont:self.contentLabel.font withString:self.contentLabel.text];
            [self.contentLabel setFrame:CGRectMake(75, 5, 230.0, timeSize.height + 10)];
            self.textHeight = timeSize.height + 10;
            self.contentLabel.textColor = [UIColor grayColor];
        }
        if (data.period == knowlegdePeriodPregnancy && [data.days intValue]%7 == 0) {
            self.line.frame = CGRectMake(0, 0, 320, 0.5);
        }else
            self.line.frame = CGRectMake(10, 0, 320, 0.5);
    }
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
