//
//  HMRefreshTableHeaderView.h
//  lama
//
//  Created by babytree on 1/10/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	HMRefreshNormal = 0,
	HMRefreshWillLoad,
	HMRefreshLoading
} HMPullRefreshState;

@protocol HMRefreshTableHeaderViewDelegate;
@interface HMRefreshTableHeaderView : UIView

@property (nonatomic, assign) HMPullRefreshState state;
@property (nonatomic, assign) id <HMRefreshTableHeaderViewDelegate> delegate;

@property (nonatomic, retain) UIImageView *m_NormalImgView;
@property (nonatomic, retain) UIImageView *m_WillLoadImgView;
@property (nonatomic, retain) UIImageView *m_LoadingImgView;
@property (nonatomic, retain) UILabel *m_StateLabel;

@property (nonatomic, retain) NSArray *m_lodingImages;
@property (nonatomic, retain) NSString *m_NormalText;
@property (nonatomic, retain) NSString *m_WillLoadText;
@property (nonatomic, retain) NSString *m_LodingText;

- (id)initWithFrame:(CGRect)frame normalText:(NSString *)normalText normalImage:(UIImage *)normalImage willLoadText:(NSString *)willLoadText willLoadImage:(UIImage *)willLoadImage lodingText:(NSString *)lodingText lodingImages:(NSArray *)lodingImages;

- (void)hmRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)hmRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)hmRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (void)setLoadingState;
- (void)setNormalState;
- (void)setState:(HMPullRefreshState)state;

@end

@protocol HMRefreshTableHeaderViewDelegate

- (void)hmRefreshTableHeaderDidTriggerRefresh:(HMRefreshTableHeaderView *)headerView;
- (BOOL)hmRefreshTableHeaderDataSourceIsLoading:(HMRefreshTableHeaderView *)headerView;

@end