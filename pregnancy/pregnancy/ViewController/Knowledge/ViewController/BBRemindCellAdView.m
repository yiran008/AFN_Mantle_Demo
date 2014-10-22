//
//  BBRemindCellAdView.m
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-15.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBRemindCellAdView.h"

@interface BBRemindCellAdView ()
@property UILabel *adContext;
@property UIView *adBottom;
@property NSString *url;
@end

@implementation BBRemindCellAdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.adContext = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.adContext.font = [UIFont systemFontOfSize:14.f];
        self.adContext.textColor = [UIColor grayColor];
        self.adContext.backgroundColor = [UIColor clearColor];
        self.adContext.numberOfLines = 0;
        [self addSubview:self.adContext];
        
        self.adBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:self.adBottom];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 60, 17)];
        label1.backgroundColor = RGBColor(208, 208, 208, 1);
        label1.textColor = [UIColor whiteColor];
        label1.text = @"查看详情>";
        label1.font = [UIFont systemFontOfSize:11.f];
        [self.adBottom addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(DEVICE_WIDTH - 32, 3, 32, 17)];
        label2.backgroundColor = RGBColor(249, 179, 111, 1);
        label2.textColor = [UIColor whiteColor];
        label2.text = @"推广";
        label2.font = [UIFont systemFontOfSize:11.f];
        [self.adBottom addSubview:label2];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 320, 0.5)];
        line.backgroundColor = RGBColor(208, 208, 208, 1);
        [self addSubview:line];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *adTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adTapped:)];
        [self addGestureRecognizer:adTap];
        self.exclusiveTouch = YES;

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setData:(BBAdModel *)data
{
    if (data.adContextHeight)
    {
        self.adContext.frame = CGRectMake(13, 0, DEVICE_WIDTH - 13*2, data.adContextHeight );
        self.adContext.text = data.adContent;
        self.url = data.adUrl;
        self.adBottom.frame = CGRectMake(0, data.adContextHeight , DEVICE_WIDTH, 20);
    }
}
- (void)adTapped:(UIGestureRecognizer *)recognizer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:REMIND_AD_TAP object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.url,@"ad_url", nil]];

}
@end
