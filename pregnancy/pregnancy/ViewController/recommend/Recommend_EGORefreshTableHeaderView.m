
//2013-06-29 宋欣芳修改

#import "Recommend_EGORefreshTableHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface Recommend_EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation Recommend_EGORefreshTableHeaderView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor
{
    if((self = [super initWithFrame:frame])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
		
//		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//		view.frame = CGRectMake((UI_SCREEN_WIDTH-25)/2, frame.size.height - 38.0f, 20.0f, 20.0f);
//		[self addSubview:view];
//		_activityView = view;
//		[view release];
		
        if (!self.m_lodingImages)
        {
            NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
            [images addObject:[UIImage imageNamed:@"refresh_loding1"]];
            [images addObject:[UIImage imageNamed:@"refresh_loding2"]];
            self.m_lodingImages = images;
        }
        
        self.m_NormalImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(116, frame.size.height - 65.0f, 52, 52)] autorelease];
        self.m_WillLoadImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(116, frame.size.height - 65.0f, 52, 52)] autorelease];
        self.m_LoadingImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(116, frame.size.height - 65.0f, 52, 52)] autorelease];
        
        self.m_LoadingImgView.animationImages = self.m_lodingImages;
        self.m_LoadingImgView.animationDuration = 0.4;
        
        self.m_NormalImgView.contentMode = UIViewContentModeTop;
        self.m_NormalImgView.clipsToBounds = YES;
        
        self.m_NormalImgView.image = [UIImage imageNamed:@"refresh_loding1"];
        self.m_WillLoadImgView.image = [UIImage imageNamed:@"refresh_loding2"];
        self.m_LoadingImgView.image = [UIImage imageNamed:@"refresh_loding1"];
        
        self.m_NormalImgView.hidden = NO;
        self.m_WillLoadImgView.hidden = YES;
        self.m_LoadingImgView.hidden = YES;
        
        
        [self addSubview:self.m_NormalImgView];
        [self addSubview:self.m_WillLoadImgView];
        [self addSubview:self.m_LoadingImgView];

		[self setState:EGOOPullRefreshNormal];
    }
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithFrame:frame arrowImageName:@"HMBlueArrow@2X.png" textColor:TEXT_COLOR];
}

- (void)setOnlySctivityView
{
    for (UIView *view in self.subviews)
    {
        if (![view isKindOfClass:[UIActivityIndicatorView class]])
        {
            [view removeFromSuperview];
        }
    }
//    _activityView.frame = CGRectMake((UI_SCREEN_WIDTH-25)/2, self.frame.size.height - 38.0f, 20.0f, 20.0f);
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullUpRefreshPulling:
            [self willLoadAnimation];
			break;
		case EGOOPullUpRefreshNormal:
            [self normalAnimation];
			break;
		case EGOOPullUpRefreshLoading:
            [self LodingAnimation];
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(r_egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate r_egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(r_egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate r_egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(r_egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate r_egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];

}
- (void)refreshLastUpdatedLabel:(BOOL)isTopicDetailType{
    [self setState:EGOOPullRefreshNormal];
}

- (void)normalAnimation
{
    self.m_NormalImgView.hidden = NO;
    self.m_WillLoadImgView.hidden = YES;
    self.m_LoadingImgView.hidden = YES;
    
    [self.m_LoadingImgView stopAnimating];
}

- (void)willLoadAnimation
{
    self.m_NormalImgView.hidden = YES;
    self.m_WillLoadImgView.hidden = NO;
    self.m_LoadingImgView.hidden = YES;
}

- (void)LodingAnimation
{
    
    self.m_NormalImgView.hidden = YES;
    self.m_WillLoadImgView.hidden = YES;
    self.m_LoadingImgView.hidden = NO;
    
    [self.m_LoadingImgView startAnimating];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
//	_activityView = nil;
    [super dealloc];
}


@end
