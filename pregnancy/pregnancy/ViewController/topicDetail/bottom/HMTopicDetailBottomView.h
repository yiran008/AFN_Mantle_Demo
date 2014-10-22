//
//  HMTopicDetailBottomView.h
//  lama
//
//  Created by songxf on 13-7-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTopicDetailSliderView.h"

#define BOTTOM_VIEW_HEGHT 49


@protocol HMTDBottomViewDelegate <NSObject>

@optional

- (void)openReplyMaster;
- (void)loadPrePage;
- (void)loadNextPage;
- (void)loadPageOfNumber:(NSInteger)page;

@end

@interface HMTopicDetailBottomView : UIView
<HMTDSliderViewDelegate>
{
    CGFloat m_top;
    
    NSInteger tempPage;
}

@property (nonatomic, assign) NSInteger m_maxPageNumber;
@property (nonatomic, assign) NSInteger m_currentPage;
@property (nonatomic, assign) id<HMTDBottomViewDelegate> delegate;

- (id)initWithTop:(CGFloat)top;

@end
