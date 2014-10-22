//
//  HMTopicDetailSliderView.h
//  lama
//
//  Created by songxf on 13-7-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SLIDER_VIEW_HEIGHT 26

@protocol HMTDSliderViewDelegate <NSObject>

- (void)hideHMTDSliderView;

- (void)didSliderValueChanged:(NSInteger)number;

- (void)tempSliderValueChanged:(NSInteger)number;

@optional
- (void)sliderDidTouchDown;

- (void)sliderDidTouchUp;

@end

@interface HMTopicDetailSliderView : UIView

@property (nonatomic, assign) id<HMTDSliderViewDelegate> delegate;
@property (nonatomic, assign) NSInteger m_maxNumber;
@property (nonatomic, assign) NSInteger m_number;

@end
