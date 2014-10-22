//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;
@synthesize isLoadNext;
@synthesize isTopicDetail;
@synthesize refreshStatus;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		isLoadNext = NO;
        isTopicDetail = NO;
        refreshStatus = NO;
        self.m_IsPicture = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor whiteColor];

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 45.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
        _activityView.hidden = YES;
        
        if (!self.m_lodingImages)
        {
            NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
            [images addObject:[UIImage imageNamed:@"refresh_loding1"]];
            [images addObject:[UIImage imageNamed:@"refresh_loding2"]];
            self.m_lodingImages = images;
        }
        
        self.m_NormalImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(50.0f, frame.size.height - 65.0f, 50, 52)] autorelease];
        self.m_WillLoadImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(50.0f, frame.size.height - 65.0f, 52, 52)] autorelease];
        self.m_LoadingImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(50.0f, frame.size.height - 65.0f, 52, 52)] autorelease];
        
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
        self.backgroundColor = [UIColor clearColor];
		
    }
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
//	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
//		
//		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
//		
//		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
//		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//		//[dateFormatter setDateStyle:NSDateFormatterShortStyle];
//		//[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//
//        [dateFormatter setAMSymbol:@"上午"];
//		[dateFormatter setPMSymbol:@"下午"];
//		[dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
//		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [dateFormatter stringFromDate:date]];
//		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//		
//	} else {
//		
//		_lastUpdatedLabel.text = nil;
//		
//	}

}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:

            
            if (isTopicDetail) {
                if (refreshStatus) {
                    _statusLabel.text = NSLocalizedString(@"已经是第一页", @"已经是第一页");
                }else{
                    _statusLabel.text =NSLocalizedString(self.topicDetailStatus, self.topicDetailStatus);
                }
            }else{
                if (!isLoadNext) {
                    _statusLabel.text = NSLocalizedString(@"刷新", @"刷新");
                }else{
                    _statusLabel.text = NSLocalizedString(@"刷新", @"刷新");
                }
            }
            if (self.m_IsPicture)
            {
                [self willLoadAnimation];
            }
            else
            {
                self.m_NormalImgView.hidden = YES;
                _activityView.hidden = NO;
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                [CATransaction commit];
            }
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling && !self.m_IsPicture) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
            if (isTopicDetail) {
                if (refreshStatus) {
                    _statusLabel.text = NSLocalizedString(@"已经是第一页", @"已经是第一页");
                }else{
                    _statusLabel.text =NSLocalizedString(self.topicDetailPage, self.topicDetailPage);
                }
            }else{
                if (!isLoadNext) {
                    _statusLabel.text = NSLocalizedString(@"刷新", @"刷新");
                }else{
                    _statusLabel.text = NSLocalizedString(@"刷新", @"刷新");
                }
            }
            
            if (self.m_IsPicture)
            {
                [self normalAnimation];
            }
            else
            {
                self.m_NormalImgView.hidden = YES;
                _activityView.hidden = NO;
                [_activityView stopAnimating];
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                _arrowImage.hidden = NO;
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:

//			if (refreshStatus) {
//                 _statusLabel.text = NSLocalizedString(@"已经是第一页", @"已经是第一页");
//            }else{
                _statusLabel.text = NSLocalizedString(@"加载中...", @"加载中...");
            
//            }
            
            if (self.m_IsPicture)
            {
                [self LodingAnimation];
            }
            else
            {
                self.m_NormalImgView.hidden = YES;
                _activityView.hidden = NO;
                [_activityView startAnimating];
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                _arrowImage.hidden = YES;
                [CATransaction commit];
            }
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
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
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
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
        if (refreshStatus) {
            return;
        }
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
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
    isTopicDetail = isTopicDetailType;
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
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    _topicDetailPage = nil;
    _topicDetailStatus = nil;
    [_m_NormalImgView release];
    [_m_WillLoadImgView release];
    [_m_LoadingImgView release];
    [_m_lodingImages release];
    [super dealloc];
}


@end
