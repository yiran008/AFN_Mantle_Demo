//
//  HMRefreshTableFooterView.h
//  lama
//
//  Created by babytree on 1/23/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	HMRefreshFooterNormal = 0,
	HMRefreshFooterWillLoad,
	HMRefreshFooterLoading
} HMRefreshFooterState;

@protocol HMRefreshTableFooterViewDelegate;
@interface HMRefreshTableFooterView : UIView

@property (nonatomic, assign) HMRefreshFooterState state;
@property (nonatomic, assign) id <HMRefreshTableFooterViewDelegate> delegate;

@property (nonatomic, retain) UIImageView *m_ArrowImgView;
@property (nonatomic, retain) UIActivityIndicatorView *m_IndicatorView;
@property (nonatomic, retain) UILabel *m_StateLabel;

@property (nonatomic, retain) NSString *m_NormalText;
@property (nonatomic, retain) NSString *m_WillLoadText;
@property (nonatomic, retain) NSString *m_LodingText;

- (void)hmRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)hmRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)hmRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (void)setState:(HMRefreshFooterState)state;

@end

@protocol HMRefreshTableFooterViewDelegate

- (void)hmRefreshTableFooterDidTriggerRefresh:(HMRefreshTableFooterView *)footerView;
- (BOOL)hmRefreshTableFooterDataSourceIsLoading:(HMRefreshTableFooterView *)footerView;

@end


