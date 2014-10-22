//
//  HMRefreshTableFooterView.m
//  lama
//
//  Created by babytree on 1/23/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "HMRefreshTableFooterView.h"
#define DRAGE_HEIGHT 65.0f
#define TEXT_COLOR	 [UIColor colorWithHex:0x999999]
#define DEFAULT_NORMALTEXT @"上拉刷新"
#define DEFAULT_WILLLOADTEXT @"松开刷新"
#define DEFAULT_LOADINGTEXT @"加载中..."

@implementation HMRefreshTableFooterView

- (void)dealloc
{
    [_m_ArrowImgView release];
    [_m_IndicatorView release];
    [_m_StateLabel release];
    
    [_m_NormalText release];
    [_m_WillLoadText release];
    [_m_LodingText release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.m_ArrowImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(40, 60, 74, 0)] autorelease];
        self.m_ArrowImgView.image = [UIImage imageNamed:@"refresh_arrow"];
        
        self.m_IndicatorView = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40,27,20,20)] autorelease];
        self.m_IndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.m_IndicatorView.hidden = YES;
        
        self.m_StateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(45, 27, 240, 20)] autorelease];
        self.m_StateLabel.backgroundColor = [UIColor clearColor];
        self.m_StateLabel.font = [UIFont boldSystemFontOfSize:12];
        self.m_StateLabel.textAlignment = NSTextAlignmentCenter;
        
        self.m_NormalText = DEFAULT_NORMALTEXT;
        self.m_WillLoadText = DEFAULT_WILLLOADTEXT;
        self.m_LodingText = DEFAULT_LOADINGTEXT;
        
        [self addSubview:self.m_ArrowImgView];
        [self addSubview:self.m_IndicatorView];
        [self addSubview:self.m_StateLabel];
        
        [self setState:HMRefreshFooterNormal];
    }
    return self;
}

- (void)setState:(HMRefreshFooterState)state
{
    switch (state)
    {
        case HMRefreshFooterNormal:
        {
            self.m_StateLabel.text = self.m_NormalText;
            self.m_IndicatorView.hidden = YES;
            [self.m_IndicatorView stopAnimating];
        }
            break;
        case HMRefreshFooterWillLoad:
        {
            self.m_StateLabel.text = self.m_WillLoadText;
        }
            break;
        case HMRefreshFooterLoading:
        {
            self.m_StateLabel.text = self.m_LodingText;
            self.m_IndicatorView.hidden = NO;
            [self.m_IndicatorView startAnimating];
        }
            break;
        default:
            break;
    }
    _state = state;
}


#pragma mark - ScrollView Methods

- (void)hmRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_state == HMRefreshFooterLoading)
    {
        scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, DRAGE_HEIGHT, 0.0f);
    }
    else if (scrollView.isDragging)
    {
        BOOL _isLoading = NO;
        if ([(NSObject *)self.delegate respondsToSelector:@selector(hmRefreshTableFooterDataSourceIsLoading:)])
        {
            _isLoading = [self.delegate hmRefreshTableFooterDataSourceIsLoading:self];
        }
        
        if(scrollView.contentSize.height >= scrollView.frame.size.height)
        {
            if (_state == HMRefreshFooterWillLoad && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + DRAGE_HEIGHT && scrollView.contentOffset.y > 0.0f && !_isLoading)
            {
                [self setState:HMRefreshFooterNormal];
            }
            else if (_state == HMRefreshFooterNormal && scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + DRAGE_HEIGHT  && !_isLoading)
            {
                [self setState:HMRefreshFooterWillLoad];
            }
		}
        else
        {
            // 实现内容不足一屏幕得操作
            if (_state == HMRefreshFooterWillLoad && scrollView.contentOffset.y < DRAGE_HEIGHT && scrollView.contentOffset.y > 0.0f && !_isLoading)
            {
                [self setState:HMRefreshFooterNormal];
            }
            else if (_state == HMRefreshFooterNormal && scrollView.contentOffset.y >= DRAGE_HEIGHT&& !_isLoading)
            {
                [self setState:HMRefreshFooterWillLoad];
            }
        }
		if (scrollView.contentInset.bottom != 0)
        {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
    }
    else
    {
		if (scrollView.contentInset.bottom != 0)
        {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
    }
}

- (void)hmRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL _isLoading = NO;
	if ([(NSObject *)self.delegate respondsToSelector:@selector(hmRefreshTableFooterDataSourceIsLoading:)])
    {
		_isLoading = [self.delegate hmRefreshTableFooterDataSourceIsLoading:self];
	}
    
    if(scrollView.contentSize.height >= scrollView.frame.size.height)
    {
        if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + DRAGE_HEIGHT && !_isLoading)
        {
            if ([(NSObject *)self.delegate respondsToSelector:@selector(hmRefreshTableFooterDidTriggerRefresh:)])
            {
                [self.delegate hmRefreshTableFooterDidTriggerRefresh:self];
            }
            
            [self setState:HMRefreshFooterLoading];
            
            [UIView animateWithDuration:0.2 animations:^{
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, DRAGE_HEIGHT, 0.0f);
            }];
        }
    }
    else
    {
        // 实现内容不足一屏幕得操作
        if ( scrollView.contentOffset.y >= DRAGE_HEIGHT && !_isLoading)
        {
            //修改内容区域高度
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height)];
            
            if ([(NSObject *)self.delegate respondsToSelector:@selector(hmRefreshTableFooterDidTriggerRefresh:)])
            {
                [self.delegate hmRefreshTableFooterDidTriggerRefresh:self];
            }
            
            [self setState:HMRefreshFooterLoading];
            
            [UIView animateWithDuration:0.2 animations:^{
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, DRAGE_HEIGHT, 0.0f);
            }];
        }
    }
}

- (void)hmRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }];
    [self setState:HMRefreshFooterNormal];
}

@end
