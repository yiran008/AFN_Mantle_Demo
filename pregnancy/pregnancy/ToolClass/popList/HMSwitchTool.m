//
//  HMSwitchTool.m
//  lama
//
//  Created by songxf on 13-8-10.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMSwitchTool.h"


@interface HMSwitchTool ()

@end

@implementation HMSwitchTool
@synthesize leftBtn;
@synthesize rightBtn;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame  dataList:(NSArray *)data delegate:(id)delegat;
{
    self = [super initWithFrame:frame];
    if (self)
    {        
        self.leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SWITCH_TOOL_WIDTH/2, SWITCH_TOOL_HEIGHT)];
        [leftBtn setTitle:[data objectAtIndex:0] forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        leftBtn.exclusiveTouch = YES;
        [self addSubview:leftBtn];
        
        self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SWITCH_TOOL_WIDTH/2, 0, SWITCH_TOOL_WIDTH/2, SWITCH_TOOL_HEIGHT)];
        [rightBtn setTitle:[data objectAtIndex:1] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        rightBtn.exclusiveTouch = YES;
        [self addSubview:rightBtn];
        
        [leftBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        self.delegate = delegat;
        [self performSelector:@selector(pressBtn:) withObject:leftBtn];
    }
    
    return self;
}

- (void)pressBtn:(UIButton *)btn
{
    if ([btn isEqual:leftBtn])
    {
        leftBtn.enabled =NO;
        rightBtn.enabled = YES;
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"swith_tool_btn_left_high"] forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"swith_tool_btn_right"] forState:UIControlStateNormal];
        
        if (delegate && [delegate respondsToSelector:@selector(haveSelectedBtnIndex:)])
        {
            [delegate haveSelectedBtnIndex:0];
        }
    }
    else
    {
        leftBtn.enabled =YES;
        rightBtn.enabled = NO;
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"swith_tool_btn_left"] forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"swith_tool_btn_right_high"] forState:UIControlStateNormal];

        if (delegate && [delegate respondsToSelector:@selector(haveSelectedBtnIndex:)])
        {
            [delegate haveSelectedBtnIndex:1];
        }
    }
}

@end
