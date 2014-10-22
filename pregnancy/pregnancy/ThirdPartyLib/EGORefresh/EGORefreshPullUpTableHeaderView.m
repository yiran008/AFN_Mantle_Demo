//
//  EGORefreshTableHeaderView.m
//  Demo
//
//修改人：禚来强 iphone开发qq群：79190809 邮箱：zhuolaiqiang@gmail.com
//修改人：李杰，解决内容区域不够一屏上拉显示不对问题


#define  RefreshViewHight 65.0f

#import "EGORefreshPullUpTableHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshPullUpTableHeaderView (Private)
- (void)setState:(EGOPullUpRefreshState)aState;
@end

@implementation EGORefreshPullUpTableHeaderView

@synthesize delegate=_delegate;
@synthesize isTopicDetail;
@synthesize refreshStatus;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
		
        isTopicDetail = NO;
        refreshStatus = NO;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor whiteColor];

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, RefreshViewHight - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, RefreshViewHight - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, RefreshViewHight - RefreshViewHight, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, RefreshViewHight - 45.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		
		[self setState:EGOOPullUpRefreshNormal];
		
    }
	
    return self;
	
}


#pragma mark -
#pragma mark Setters

- (void)refreshPullUpLastUpdatedDate {
	
//	if ([_delegate respondsToSelector:@selector(egoRefreshPullUpTableHeaderDataSourceLastUpdated:)]) {
//		
//		NSDate *date = [_delegate egoRefreshPullUpTableHeaderDataSourceLastUpdated:self];
//		
//		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//		[formatter setAMSymbol:@"上午"];
//		[formatter setPMSymbol:@"下午"];
//		[formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
//		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [formatter stringFromDate:date]];
//        
//		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//		[formatter release];
//		
//	} else {
//		
//		_lastUpdatedLabel.text = nil;
//		
//	}

}

- (void)setState:(EGOPullUpRefreshState)aState{
	
	switch (aState) {
		case EGOOPullUpRefreshPulling:
			if (isTopicDetail) {
                if (refreshStatus) {
                    _statusLabel.text = NSLocalizedString(@"没有了哦！", @"没有了哦！");
                }else{
                    _statusLabel.text = NSLocalizedString(self.topicDetailStatus, self.topicDetailStatus);
                }
            }else{
                if (refreshStatus)
                {
                    _statusLabel.text = NSLocalizedString(@"已加载全部", @"已加载全部");
                }
                else
                {
                    _statusLabel.text = NSLocalizedString(@"更多", @"更多");
                }
            }
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullUpRefreshNormal:
			
			if (_state == EGOOPullUpRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			if (isTopicDetail) {
                if (refreshStatus) {
                    _statusLabel.text = NSLocalizedString(@"没有了哦！", @"没有了哦！");
                }else{
                    _statusLabel.text = NSLocalizedString(self.topicDetailPage, self.topicDetailPage);
                }
            }else
            {
                if (refreshStatus)
                {
                    _statusLabel.text = NSLocalizedString(@"已加载全部", @"已加载全部");
                }
                else
                {
                    _statusLabel.text = NSLocalizedString(@"更多", @"更多");
                }            }
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshPullUpLastUpdatedDate];
			
			break;
		case EGOOPullUpRefreshLoading:
//            if (refreshStatus) {
//                _statusLabel.text = NSLocalizedString(@"已经是最后一页", @"已经是最后一页");
//            }else{
                _statusLabel.text = NSLocalizedString(@"加载中...", @"加载中...");
//            }
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
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
		/*
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		*/
         scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, RefreshViewHight, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshPullUpTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshPullUpTableHeaderDataSourceIsLoading:self];
		}
        if(scrollView.contentSize.height>=scrollView.frame.size.height){
            if (_state == EGOOPullUpRefreshPulling && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + RefreshViewHight && scrollView.contentOffset.y > 0.0f && !_loading) {
                [self setState:EGOOPullUpRefreshNormal];
            } else if (_state == EGOOPullUpRefreshNormal && scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight  && !_loading) {
                [self setState:EGOOPullUpRefreshPulling];
            }
		}else{
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
	if ([_delegate respondsToSelector:@selector(egoRefreshPullUpTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshPullUpTableHeaderDataSourceIsLoading:self];
	}
    //NSLog(@"scrollView.contentOffset.y%f,scrollView.frame.size.height%f",scrollView.contentOffset.y,scrollView.frame.size.height);
    if(scrollView.contentSize.height>=scrollView.frame.size.height){
        if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight && !_loading) {
            if ([_delegate respondsToSelector:@selector(egoRefreshPullUpTableHeaderDidTriggerRefresh:)]) {
                [_delegate egoRefreshPullUpTableHeaderDidTriggerRefresh:self];
            }
            if (refreshStatus) {
                return;
            }
            [self setState:EGOOPullUpRefreshLoading];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, RefreshViewHight, 0.0f);
            [UIView commitAnimations];
            
        }
    }else{
    // 实现内容不足一屏幕得操作lijie
        if ( scrollView.contentOffset.y >= RefreshViewHight && !_loading) {
            //修改内容区域高度
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height)];
            if ([_delegate respondsToSelector:@selector(egoRefreshPullUpTableHeaderDidTriggerRefresh:)]) {
                [_delegate egoRefreshPullUpTableHeaderDidTriggerRefresh:self];
            }
            if (refreshStatus) {
                return;
            }
            [self setState:EGOOPullUpRefreshLoading];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, RefreshViewHight, 0.0f);
            [UIView commitAnimations];
        }
    }
	
}

//当开发者页面页面刷新完毕调用此方法，[delegate egoRefreshScrollViewDataSourceDidFinishedLoading: scrollView];
- (void)egoRefreshPullUpScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [UIView commitAnimations];
        [self setState:EGOOPullUpRefreshNormal];
}

- (void)refreshPullUpLastUpdatedLabel:(BOOL)isTopicDetailType{
    isTopicDetail = isTopicDetailType;
    [self setState:EGOOPullUpRefreshNormal];
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    _topicDetailPage = nil;
    _topicDetailStatus = nil;
    [super dealloc];
}


@end
