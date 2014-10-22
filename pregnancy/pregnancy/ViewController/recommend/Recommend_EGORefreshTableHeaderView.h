
//2013-06-29 宋欣芳修改


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EGORefreshTableHeaderView.h"


@protocol Recommend_EGORefreshTableHeaderDelegate;

@interface Recommend_EGORefreshTableHeaderView : UIView {
	
	id _delegate;
	EGOPullRefreshState _state;

//	UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) id <Recommend_EGORefreshTableHeaderDelegate> delegate;

@property (nonatomic, strong) UIImageView *m_NormalImgView;
@property (nonatomic, strong) UIImageView *m_WillLoadImgView;
@property (nonatomic, strong) UIImageView *m_LoadingImgView;
@property (nonatomic, strong) NSMutableArray *m_lodingImages;


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)refreshLastUpdatedLabel:(BOOL)isTopicDetailType;

@end

@protocol Recommend_EGORefreshTableHeaderDelegate
- (void)r_egoRefreshTableHeaderDidTriggerRefresh:(Recommend_EGORefreshTableHeaderView*)view;
- (BOOL)r_egoRefreshTableHeaderDataSourceIsLoading:(Recommend_EGORefreshTableHeaderView*)view;
@optional
- (NSDate*)r_egoRefreshTableHeaderDataSourceLastUpdated:(Recommend_EGORefreshTableHeaderView*)view;
@end
