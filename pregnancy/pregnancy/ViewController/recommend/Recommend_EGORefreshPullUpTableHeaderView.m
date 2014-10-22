
//2013-06-29 宋欣芳修改


#define  RefreshViewHight 65.0f

#import "Recommend_EGORefreshPullUpTableHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface Recommend_EGORefreshPullUpTableHeaderView (Private)
- (void)setState:(EGOPullUpRefreshState)aState;
@end

@implementation Recommend_EGORefreshPullUpTableHeaderView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
		
		[self setState:EGOOPullUpRefreshNormal];
    }
	
    return self;
	
}

#pragma mark -
#pragma mark Setters

- (void)refreshPullUpLastUpdatedDate
{
}

- (void)setState:(EGOPullUpRefreshState)aState{
	
	switch (aState) {
		case EGOOPullUpRefreshPulling:
			
			break;
		case EGOOPullUpRefreshNormal:
			
			[_activityView stopAnimating];
			
			[self refreshPullUpLastUpdatedDate];
			
			break;
		case EGOOPullUpRefreshLoading:

			[_activityView startAnimating];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

//手指屏幕上不断拖动调用此方法
- (void)egoRefreshPullUpScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullUpRefreshLoading) {
         scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, RefreshViewHight, 0.0f);
		
	} else if (scrollView.isDragging)
    {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(r_egoRefreshPullUpTableHeaderDataSourceIsLoading:)])
        {
			_loading = [_delegate r_egoRefreshPullUpTableHeaderDataSourceIsLoading:self];
		}
        if(scrollView.contentSize.height>=scrollView.frame.size.height)
        {
            if (_state == EGOOPullUpRefreshPulling && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + RefreshViewHight && scrollView.contentOffset.y > 0.0f && !_loading)
            {
                [self setState:EGOOPullUpRefreshNormal];
            } else if (_state == EGOOPullUpRefreshNormal && scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight  && !_loading)
            {
                [self setState:EGOOPullUpRefreshPulling];
            }
		}else
        {
            // 实现内容不足一屏幕得操作lijie
            if (_state == EGOOPullUpRefreshPulling && scrollView.contentOffset.y < RefreshViewHight&& scrollView.contentOffset.y > 0.0f && !_loading) {
                [self setState:EGOOPullUpRefreshNormal];
            } else if (_state == EGOOPullUpRefreshNormal && scrollView.contentOffset.y >= RefreshViewHight&& !_loading) {
                [self setState:EGOOPullUpRefreshPulling];
            }
        }
		if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	} else {
		if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
    }
	
}

//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
- (void)egoRefreshPullUpScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(r_egoRefreshPullUpTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate r_egoRefreshPullUpTableHeaderDataSourceIsLoading:self];
	}
    if(scrollView.contentSize.height>=scrollView.frame.size.height)
    {
        if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight && !_loading)
        {
            if ([_delegate respondsToSelector:@selector(r_egoRefreshPullUpTableHeaderDidTriggerRefresh:)]) {
                [_delegate r_egoRefreshPullUpTableHeaderDidTriggerRefresh:self];
            }
            [self setState:EGOOPullUpRefreshLoading];
        }
    }else{
    // 实现内容不足一屏幕得操作lijie
        if ( scrollView.contentOffset.y >= RefreshViewHight && !_loading) {
            //修改内容区域高度
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height)];
            if ([_delegate respondsToSelector:@selector(r_egoRefreshPullUpTableHeaderDidTriggerRefresh:)]) {
                [_delegate r_egoRefreshPullUpTableHeaderDidTriggerRefresh:self];
            }
            [self setState:EGOOPullUpRefreshLoading];
        }
    }
	
}

//当开发者页面页面刷新完毕调用此方法，[delegate egoRefreshScrollViewDataSourceDidFinishedLoading: scrollView];
- (void)egoRefreshPullUpScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
        [self setState:EGOOPullUpRefreshNormal];
}

- (void)refreshPullUpLastUpdatedLabel:(BOOL)isTopicDetailType{
    [self setState:EGOOPullUpRefreshNormal];
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
    [super dealloc];
}


@end
