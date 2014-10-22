//
//  HMRefreshTableHeaderView.m
//  lama
//
//  Created by babytree on 1/10/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "HMRefreshTableHeaderView.h"


#define DRAGE_HEIGHT            65.0f

#define TEXT_COLOR              [UIColor colorWithHex:0x999999]

#define DEFAULT_NORMALTEXT      @"下拉刷新"
#define DEFAULT_WILLLOADTEXT    @"松开刷新"
#define DEFAULT_LOADINGTEXT     @"加载中..."

#define DEFAULT_NORMALIMAGE     [UIImage imageNamed:@"refresh_loding1"]
#define DEFAULT_WILLLOADIMAGE   [UIImage imageNamed:@"refresh_loding2"]
#define DEFAULT_LOADINGIMAGE    [UIImage imageNamed:@"refresh_loding1"]
//#define DEFAULT_NORMALIMAGE     [UIImage imageNamed:@""]
//#define DEFAULT_WILLLOADIMAGE   [UIImage imageNamed:@""]
//#define DEFAULT_LOADINGIMAGE    [UIImage imageNamed:@""]


@implementation HMRefreshTableHeaderView

- (void)dealloc
{
    [_m_NormalImgView release];
    [_m_WillLoadImgView release];
    [_m_LoadingImgView release];
    [_m_StateLabel release];
    
    [_m_lodingImages release];
    [_m_NormalText release];
    [_m_WillLoadText release];
    [_m_LodingText release];

    [super dealloc];
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0, -60, 320, 60)
              normalText:DEFAULT_NORMALTEXT
              normalImage:DEFAULT_NORMALIMAGE
              willLoadText:DEFAULT_WILLLOADTEXT
              willLoadImage:DEFAULT_WILLLOADIMAGE
              lodingText:DEFAULT_LOADINGTEXT
              lodingImage:DEFAULT_LOADINGIMAGE
           ];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame
                    normalText:DEFAULT_NORMALTEXT
                   normalImage:DEFAULT_NORMALIMAGE
                  willLoadText:DEFAULT_WILLLOADTEXT
                 willLoadImage:DEFAULT_WILLLOADIMAGE
                    lodingText:DEFAULT_LOADINGTEXT
                   lodingImage:DEFAULT_LOADINGIMAGE
            ];
}

- (id)initWithFrame:(CGRect)frame normalText:(NSString *)normalText normalImage:(UIImage *)normalImage willLoadText:(NSString *)willLoadText willLoadImage:(UIImage *)willLoadImage lodingText:(NSString *)lodingText lodingImages:(NSArray *)lodingImages
{
    self.m_lodingImages = lodingImages;
    if (self.m_lodingImages.count > 0)
    {
        return [self initWithFrame:frame normalText:normalText normalImage:normalImage willLoadText:willLoadText willLoadImage:willLoadImage lodingText:lodingText lodingImage:lodingImages[0]];
    }
    else
    {
        return [self initWithFrame:frame normalText:normalText normalImage:normalImage willLoadText:willLoadText willLoadImage:willLoadImage lodingText:lodingText lodingImage:[UIImage imageNamed:@"refresh_loding2"]];
    }
}

- (id)initWithFrame:(CGRect)frame normalText:(NSString *)normalText normalImage:(UIImage *)normalImage willLoadText:(NSString *)willLoadText  willLoadImage:(UIImage *)willLoadImage lodingText:(NSString *)lodingText lodingImage:(UIImage *)lodingImage
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        if (!self.m_lodingImages)
        {
            NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
            [images addObject:[UIImage imageNamed:@"refresh_loding1"]];
            [images addObject:[UIImage imageNamed:@"refresh_loding2"]];
//            [images addObject:[UIImage imageNamed:@"refresh_arrow"]];
//            [images addObject:[UIImage imageNamed:@"refresh_arrow"]];
            self.m_lodingImages = images;
        }

        self.m_NormalImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(50, 8, 52, 52)] autorelease];
        self.m_WillLoadImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(50, 8, 52, 52)] autorelease];
        self.m_LoadingImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(50, 8, 52, 52)] autorelease];
        
        self.m_LoadingImgView.animationImages = self.m_lodingImages;
        self.m_LoadingImgView.animationDuration = 0.4;
        
        self.m_NormalImgView.contentMode = UIViewContentModeTop;
        self.m_NormalImgView.clipsToBounds = YES;
        
        self.m_NormalImgView.image = normalImage;
        self.m_WillLoadImgView.image = willLoadImage;
        self.m_LoadingImgView.image = lodingImage;
        
        self.m_NormalText = normalText;
        self.m_WillLoadText = willLoadText;
        self.m_LodingText = lodingText;
        
        self.m_NormalImgView.hidden = NO;
        self.m_WillLoadImgView.hidden = YES;
        self.m_LoadingImgView.hidden = YES;
        
        self.m_StateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(45, 27, 240, 20)] autorelease];
        self.m_StateLabel.backgroundColor = [UIColor clearColor];
        self.m_StateLabel.font = [UIFont boldSystemFontOfSize:12];
        self.m_StateLabel.textAlignment = NSTextAlignmentCenter;
        self.m_StateLabel.textColor = TEXT_COLOR;
        
        [self addSubview:self.m_NormalImgView];
        [self addSubview:self.m_WillLoadImgView];
        [self addSubview:self.m_LoadingImgView];
        [self addSubview:self.m_StateLabel];
        
        [self setState:HMRefreshNormal];
    }

    return self;
}

- (void)setLoadingState
{
    [self setState:HMRefreshLoading];
}

- (void)setNormalState
{
    [self setState:HMRefreshNormal];
}

- (void)setState:(HMPullRefreshState)state
{
	switch (state)
    {
		case HMRefreshNormal:
        {
            [self normalAnimation];
        }
			break;
            
		case HMRefreshWillLoad:
        {
            [self willLoadAnimation];
        }
			break;
            
		case HMRefreshLoading:
        {
            [self LodingAnimation];
        }
			break;
            
		default:
			break;
	}
	_state = state;
}


- (void)normalAnimation
{
    self.m_StateLabel.text = self.m_NormalText;
    
    self.m_NormalImgView.hidden = NO;
    self.m_WillLoadImgView.hidden = YES;
    self.m_LoadingImgView.hidden = YES;
    
    [self.m_LoadingImgView stopAnimating];
}

- (void)willLoadAnimation
{
    self.m_StateLabel.text = self.m_WillLoadText;
    
    self.m_NormalImgView.hidden = YES;
    self.m_WillLoadImgView.hidden = NO;
    self.m_LoadingImgView.hidden = YES;
}

- (void)LodingAnimation
{
    self.m_StateLabel.text = self.m_LodingText;
    
    self.m_NormalImgView.hidden = YES;
    self.m_WillLoadImgView.hidden = YES;
    self.m_LoadingImgView.hidden = NO;
    
    [self.m_LoadingImgView startAnimating];
}


#pragma mark - ScrollView Methods

- (void)hmRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_state == HMRefreshLoading)
    {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
	}
    else if(scrollView.isDragging)
    {
        if (scrollView.contentOffset.y >= -50 && scrollView.contentOffset.y < 0)
        {
            _m_NormalImgView.frame = CGRectMake(40, 60 + scrollView.contentOffset.y , 74, -scrollView.contentOffset.y);
        }

        BOOL isloading = NO;
        if ([(NSObject *)self.delegate respondsToSelector:@selector(hmRefreshTableHeaderDataSourceIsLoading:)])
        {
            isloading = [self.delegate hmRefreshTableHeaderDataSourceIsLoading:self];
        }

        if (_state == HMRefreshWillLoad && scrollView.contentOffset.y < 0.0f && scrollView.contentOffset.y > - DRAGE_HEIGHT && !isloading)
        {
            [self setState:HMRefreshNormal];
        }
        else if (_state == HMRefreshNormal && scrollView.contentOffset.y < - DRAGE_HEIGHT && !isloading)
        {
            [self setState:HMRefreshWillLoad];
        }
        
        if (scrollView.contentInset.bottom != 0)
        {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
    }
}

- (void)hmRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
	BOOL _loading = NO;
	if ([(NSObject *)self.delegate respondsToSelector:@selector(hmRefreshTableHeaderDataSourceIsLoading:)])
    {
		_loading = [self.delegate hmRefreshTableHeaderDataSourceIsLoading:self];
	}
    
    if (!_loading && scrollView.contentOffset.y < - DRAGE_HEIGHT)
    {
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        }];
        [self setState:HMRefreshLoading];
        if ([(NSObject *)self.delegate respondsToSelector:@selector(hmRefreshTableHeaderDidTriggerRefresh:)])
        {
            [self.delegate hmRefreshTableHeaderDidTriggerRefresh:self];
        }
    }
}

- (void)hmRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }];
    [self setState:HMRefreshNormal];
}

@end
