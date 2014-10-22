
//2013-06-29 宋欣芳修改


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EGORefreshPullUpTableHeaderView.h"



@protocol Recommend_EGORefreshPullUpTableHeaderDelegate;

@interface Recommend_EGORefreshPullUpTableHeaderView : UIView {
	
	id _delegate;
	EGOPullUpRefreshState _state;

	UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) id <Recommend_EGORefreshPullUpTableHeaderDelegate> delegate;
- (void)refreshPullUpLastUpdatedDate;
- (void)egoRefreshPullUpScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshPullUpScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshPullUpScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)refreshPullUpLastUpdatedLabel:(BOOL)isTopicDetailType;

@end


@protocol Recommend_EGORefreshPullUpTableHeaderDelegate

- (void)r_egoRefreshPullUpTableHeaderDidTriggerRefresh:(Recommend_EGORefreshPullUpTableHeaderView*)view;
- (BOOL)r_egoRefreshPullUpTableHeaderDataSourceIsLoading:(Recommend_EGORefreshPullUpTableHeaderView*)view;
- (NSDate*)r_egoRefreshPullUpTableHeaderDataSourceLastUpdated:(Recommend_EGORefreshPullUpTableHeaderView*)view;

@end

