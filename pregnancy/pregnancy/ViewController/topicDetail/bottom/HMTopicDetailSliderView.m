//
//  HMTopicDetailSliderView.m
//  lama
//
//  Created by songxf on 13-7-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMTopicDetailSliderView.h"
#import "ARCHelper.h"

@interface HMTopicDetailSliderView ()
@property (nonatomic, retain) UISlider *slider;

@end

@implementation HMTopicDetailSliderView
@synthesize delegate;
@synthesize slider;
@synthesize m_maxNumber;
@synthesize m_number;

-(void)dealloc
{
    delegate = nil;
    [slider ah_release];
    
    [super ah_dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadViews];
    }
    return self;
}

- (void)loadViews
{
    // 添加滚动条
    self.slider = [[[UISlider alloc] initWithFrame:CGRectMake(10, 5 , UI_SCREEN_WIDTH-20, SLIDER_VIEW_HEIGHT)] ah_autorelease];
    [self addSubview:slider];

    UIImage *leftTrackImage  = [UIImage imageWithColor:UI_NAVIGATION_BGCOLOR size:CGSizeMake(UI_SCREEN_WIDTH-20, 4)];
    UIImage *rightTrackImage = [UIImage imageWithColor:DETAIL_PAGE_SLIDER_COLOR2 size:CGSizeMake(UI_SCREEN_WIDTH-20, 4)];
    UIImage *thumbImage = [UIImage imageNamed:@"topicdetail_slider_btn"];
    [slider setThumbImage:thumbImage forState:UIControlStateNormal];
    [slider setMinimumTrackImage:leftTrackImage forState:UIControlStateNormal];
    [slider setMaximumTrackImage:rightTrackImage forState:UIControlStateNormal];
    [slider setMinimumValue:1.0];
    //滑动拖动后的事件
    [slider addTarget:self action:@selector(sliderDragUp) forControlEvents:UIControlEventTouchUpInside];
    
    [slider addTarget:self action:@selector(sliderDragInside) forControlEvents:UIControlEventTouchDragInside];

    [slider addTarget:self action:@selector(sliderTouchDown) forControlEvents:UIControlEventTouchDown];
    
    [slider addTarget:self action:@selector(sliderTouchUp) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchCancel];
}

-(void)setM_maxNumber:(NSInteger)maxNumber
{
    m_maxNumber = maxNumber;
    [slider setMaximumValue:m_maxNumber];
}

- (void)setM_number:(NSInteger)number
{
    m_number = number;
    [slider setValue:number];
}

- (void)sliderDragUp
{
    NSInteger number = slider.value;

    if (slider.value-number>0.5)
    {
        number += 1;
    }
    NSLog(@"aaaaa sliderDragUp");
    [slider setValue:number animated:YES];

    if (delegate && [delegate respondsToSelector:@selector(didSliderValueChanged:)])
    {
        [delegate didSliderValueChanged:number];
    }
    if (delegate && [delegate respondsToSelector:@selector(sliderDidTouchUp)])
    {
        [delegate sliderDidTouchUp];
    }
}

- (void)sliderDragInside
{
    NSInteger number = slider.value;
    
    if (slider.value-number>0.5)
    {
        number += 1;
    }
    
    if (delegate && [delegate respondsToSelector:@selector(tempSliderValueChanged:)])
    {
        [delegate tempSliderValueChanged:number];
    }
}

- (void)sliderTouchDown
{
    if (delegate && [delegate respondsToSelector:@selector(sliderDidTouchDown)])
    {
        [delegate sliderDidTouchDown];
    }
}
- (void)sliderTouchUp
{
    if (delegate && [delegate respondsToSelector:@selector(sliderDidTouchUp)])
    {
        [delegate sliderDidTouchUp];
    }
}
@end
