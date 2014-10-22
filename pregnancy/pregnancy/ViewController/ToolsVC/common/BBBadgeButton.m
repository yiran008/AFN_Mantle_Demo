//
//  BBBadgeButton.m
//  pregnancy
//
//  Created by liumiao on 4/21/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBBadgeButton.h"
@interface BBBadgeButton()

@property (nonatomic,strong)UIImageView *s_TipLabel;
@property (nonatomic,strong)UIImageView *s_TipImageView;
@end
@implementation BBBadgeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.s_TipLabel = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-15, -2, 12, 12)];
        self.s_TipLabel.hidden = YES;
        [self addSubview:self.s_TipLabel];
        
        self.s_TipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-17, -2, 26, 14)];
        self.s_TipImageView.hidden = YES;
        [self addSubview:self.s_TipImageView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.s_TipLabel = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-15, -2, 12, 12)];
        self.s_TipLabel.hidden = YES;
        [self addSubview:self.s_TipLabel];
        
        self.s_TipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-16, -4, 24, 16)];
        self.s_TipImageView.hidden = YES;
        [self addSubview:self.s_TipImageView];
    }
    return self;
}

- (void)setTipNumber:(NSString*)badgeCount
{
    if (badgeCount && [badgeCount integerValue] > 0)
    {
        self.s_TipLabel.hidden = NO;
        [self.s_TipLabel setImage:[UIImage imageNamed:@"new_point"]];
    }
    else
    {
        self.s_TipLabel.hidden = YES;
    }
}
- (void)setNewState:(BOOL)isNew
{
    self.s_TipLabel.hidden = YES;
    if (isNew)
    {
        self.s_TipImageView.hidden = NO;
        [self.s_TipImageView setImage:[UIImage imageNamed:@"tool_icon_new"]];
    }
    else
    {
        self.s_TipImageView.hidden = YES;
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
