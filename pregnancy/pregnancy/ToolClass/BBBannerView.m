//
//  HMBannerView.m
//  HMBannerViewDemo
//
//  Created by Dennis on 13-12-31.
//  Copyright (c) 2013年 Babytree. All rights reserved.
//

#import "BBBannerView.h"
#import "BBAdModel.h"

#define Banner_StartTag     1000


@interface BBBannerView ()
{
    // 下载统计
    NSInteger totalCount;
}

@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, assign) BOOL enableRolling;


- (void)refreshScrollView;

- (NSInteger)getPageIndex:(NSInteger)index;
- (NSArray *)getDisplayImagesWithPageIndex:(NSInteger)pageIndex;


@end

@implementation BBBannerView
@synthesize delegate;

@synthesize imagesArray;
@synthesize scrollDirection;

@synthesize pageControl;

- (void)dealloc
{
    delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BANNER_APEAR_NOTIFICATION object:nil];
    [[SDWebImageManager sharedManager] cancelForDelegate:self];

    [imagesArray release];
    [pageControl release];

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame scrollDirection:(BannerViewScrollDirection)direction images:(NSArray *)images
{
    self = [super initWithFrame:frame];

    if(self)
    {
        self.imagesArray = [[[NSArray alloc] initWithArray:images] autorelease];

        self.scrollDirection = direction;

        totalPage = imagesArray.count;
        totalCount = totalPage;
        // 显示的是图片数组里的第一张图片
        // 和数组是+1关系
        curPage = 1;

        scrollView = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        // 在水平方向滚动
        if(scrollDirection == ScrollDirectionLandscape)
        {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3,
                                                scrollView.frame.size.height);
        }
        // 在垂直方向滚动 
        else if(scrollDirection == ScrollDirectionPortait)
        {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                                scrollView.frame.size.height * 3);
        }

        for (NSInteger i = 0; i < 3; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
            imageView.userInteractionEnabled = YES;
            imageView.tag = Banner_StartTag+i;

            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:singleTap];
            imageView.exclusiveTouch = YES;
            [singleTap release];

            // 水平滚动
            if(scrollDirection == ScrollDirectionLandscape)
            {
                imageView.frame = CGRectOffset(imageView.frame, scrollView.frame.size.width * i, 0);
            }
            // 垂直滚动
            else if(scrollDirection == ScrollDirectionPortait)
            {
                imageView.frame = CGRectOffset(imageView.frame, 0, scrollView.frame.size.height * i);
            }
            
            [scrollView addSubview:imageView];
            [imageView release];
        }

        self.pageControl = [[[UIPageControl alloc] initWithFrame:CGRectMake(5, frame.size.height-15, 60, 15)] autorelease];
        self.pageControl.numberOfPages = self.imagesArray.count;
        [self addSubview:self.pageControl];

        self.pageControl.currentPage = 0;
        //[self refreshScrollView];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bannerApear:) name:BANNER_APEAR_NOTIFICATION object:nil];
    }
    
    return self;
}

- (void)reloadBannerWithData:(NSArray *)images
{
    if (self.enableRolling)
    {
        [self stopRolling];
    }
    
    self.imagesArray = [[[NSArray alloc] initWithArray:images] autorelease];

    
    totalPage = imagesArray.count;
    totalCount = totalPage;
    curPage = 1;
    self.pageControl.numberOfPages = totalPage;
    self.pageControl.currentPage = 0;

    [self startDownloadImage];
}

- (void)setSquare:(NSInteger)asquare
{
    if (scrollView)
    {
        scrollView.layer.cornerRadius = asquare;
        if (asquare == 0)
        {
            scrollView.layer.masksToBounds = NO;
        }
        else
        {
            scrollView.layer.masksToBounds = YES;
        }
    }
}

- (void)setPageControlStyle:(BannerViewPageStyle)pageStyle
{
    if (pageStyle == PageStyle_Left)
    {
        [self.pageControl setFrame:CGRectMake(5, self.height-15, 60, 15)];
    }
    else if (pageStyle == PageStyle_Right)
    {
        [self.pageControl setFrame:CGRectMake(self.width-5-60, self.height-15, 60, 15)];
    }
    else if (pageStyle == PageStyle_Middle)
    {
        [self.pageControl setFrame:CGRectMake((self.width-60)/2, self.height-15, 60, 15)];
    }
    else if (pageStyle == PageStyle_None)
    {
        [self.pageControl setHidden:YES];
    }
}

- (void)showClose:(BOOL)show
{
    if (show)
    {
        if (!BannerCloseButton)
        {
            BannerCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            BannerCloseButton.exclusiveTouch = YES;
            [BannerCloseButton setFrame:CGRectMake(self.width-40, 0, 40, 40)];
            [BannerCloseButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
            [BannerCloseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [BannerCloseButton addTarget:self action:@selector(closeBanner) forControlEvents:UIControlEventTouchUpInside];
            [BannerCloseButton setImage:[UIImage imageNamed:@"mainPageCloseAdBanner"] forState:UIControlStateNormal];
            [self addSubview:BannerCloseButton];
        }

        BannerCloseButton.hidden = NO;
    }
    else
    {
        if (BannerCloseButton)
        {
            BannerCloseButton.hidden = YES;
        }
    }
}

- (void)closeBanner
{
    [self stopRolling];

    if ([self.delegate respondsToSelector:@selector(bannerViewdidClosed:)])
    {
        [self.delegate bannerViewdidClosed:self];
    }
}

- (void)bannerApear:(NSNotification*)notification
{
    //补漏banner 第一次展示第一帧不统计的问题，以及banner只有一张的时候，页面切回来不统计的问题
    int index = curPage-1;
    if (index >=0 && index < [self.imagesArray count])
    {
        NSDictionary *dic = [self.imagesArray objectAtIndex:index];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didDisplayPage:withData:)])
        {
            [self.delegate bannerView:self didDisplayPage:index withData:dic];
        }
    }
}
#pragma mark - Custom Method

- (void)startDownloadImage
{
    //取消已加入的延迟线程
    if (self.enableRolling)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
    }

    [[SDWebImageManager sharedManager] cancelForDelegate:self];

    for (NSInteger i=0; i<self.imagesArray.count; ++i)
    {
        NSDictionary *dic = [self.imagesArray objectAtIndex:i];
        NSString *url = nil;
        if ([[dic stringForKey:@"select_type"] isEqualToString:@"6"])
        {
            NSDictionary *ad = [dic dictionaryForKey:@"ad"];
            if ([ad isDictionaryAndNotEmpty])
            {
                url = [ad stringForKey:AD_DICT_NORMAL_IMG_KEY];
            }
        }
        else
        {
            url = [dic stringForKey:@"img_url"];
        }

        if ([url isNotEmpty])
        {
            [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url] delegate:self];
        }
    }
}

- (void)refreshScrollView
{
    NSArray *curimageUrls = [self getDisplayImagesWithPageIndex:curPage];

    for (NSInteger i = 0; i < 3; i++)
    {
        UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:Banner_StartTag+i];
        NSDictionary *dic = [curimageUrls objectAtIndex:i];
        NSString *url = nil;
        if ([[dic stringForKey:@"select_type"] isEqualToString:@"6"])
        {
            NSDictionary *ad = [dic dictionaryForKey:@"ad"];
            if ([ad isNotEmpty])
            {
                url = [ad stringForKey:AD_DICT_NORMAL_IMG_KEY];
            }
        }
        else
        {
            url = [dic stringForKey:@"img_url"];
        }

        if (imageView && [imageView isKindOfClass:[UIImageView class]] && [url isNotEmpty])
        {
            [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        }
    }

    // 水平滚动
    if (scrollDirection == ScrollDirectionLandscape)
    {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }
    // 垂直滚动
    else if (scrollDirection == ScrollDirectionPortait)
    {
        scrollView.contentOffset = CGPointMake(0, scrollView.frame.size.height);
    }

    self.pageControl.currentPage = curPage-1;
    
    NSDictionary *dic = [self.imagesArray objectAtIndex:curPage-1];

    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didDisplayPage:withData:)])
    {
        [self.delegate bannerView:self didDisplayPage:curPage-1 withData:dic];
    }
}

- (NSArray *)getDisplayImagesWithPageIndex:(NSInteger)page
{
    NSInteger pre = [self getPageIndex:curPage-1];
    NSInteger last = [self getPageIndex:curPage+1];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
    
    [images addObject:[imagesArray objectAtIndex:pre-1]];
    [images addObject:[imagesArray objectAtIndex:curPage-1]];
    [images addObject:[imagesArray objectAtIndex:last-1]];
    
    return images;
}

- (NSInteger)getPageIndex:(NSInteger)index
{
    // value＝1为第一张，value = 0为前面一张
    if (index == 0)
    {
        index = totalPage;
    }

    if (index == totalPage + 1)
    {
        index = 1;
    }
    
    return index;
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    NSInteger x = aScrollView.contentOffset.x;
    NSInteger y = aScrollView.contentOffset.y;

    //取消已加入的延迟线程
    if (self.enableRolling)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
    }

    // 水平滚动
    if(scrollDirection == ScrollDirectionLandscape)
    {
        // 往下翻一张
        if (x >= 2 * scrollView.frame.size.width)
        {
            curPage = [self getPageIndex:curPage+1];
            [self refreshScrollView];
        }

        if (x <= 0)
        {
            curPage = [self getPageIndex:curPage-1];
            [self refreshScrollView];
        }
    }
    // 垂直滚动
    else if(scrollDirection == ScrollDirectionPortait)
    {
        // 往下翻一张
        if (y >= 2 * scrollView.frame.size.height)
        {
            curPage = [self getPageIndex:curPage+1];
            [self refreshScrollView];
        }

        if (y <= 0)
        {
            curPage = [self getPageIndex:curPage-1];
            [self refreshScrollView];
        }
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    // 水平滚动
    if (scrollDirection == ScrollDirectionLandscape)
    {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }
    // 垂直滚动
    else if (scrollDirection == ScrollDirectionPortait)
    {
        scrollView.contentOffset = CGPointMake(0, scrollView.frame.size.height);
    }

    if (self.enableRolling)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
        [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}


#pragma mark -
#pragma mark Rolling

- (void)startRolling
{
    if (![self.imagesArray isNotEmpty] || self.imagesArray.count == 1)
    {
        return;
    }

    [self stopRolling];

    self.enableRolling = YES;
    [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime];
}

- (void)stopRolling
{
    self.enableRolling = NO;
    //取消已加入的延迟线程
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
}

- (void)rollingScrollAction
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    [UIView animateWithDuration:0.25 animations:^{
        // 水平滚动
        if(scrollDirection == ScrollDirectionLandscape)
        {
            scrollView.contentOffset = CGPointMake(1.99*scrollView.frame.size.width, 0);
        }
        // 垂直滚动
        else if(scrollDirection == ScrollDirectionPortait)
        {
            scrollView.contentOffset = CGPointMake(0, 1.99*scrollView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        curPage = [self getPageIndex:curPage+1];
        [self refreshScrollView];

        if (self.enableRolling)
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
            [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }];


    [pool drain];
}

#pragma mark - SDWebImageManager Delegate

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    totalCount--;

    if (totalCount == 0)
    {
        curPage = 1;
        [self refreshScrollView];

        if ([self.delegate respondsToSelector:@selector(imageCachedDidFinish:)])
        {
            [self.delegate imageCachedDidFinish:self];
        }
    }
}


#pragma mark -
#pragma mark action

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if ([delegate respondsToSelector:@selector(bannerView:didSelectImageView:withData:)])
    {
        [delegate bannerView:self didSelectImageView:curPage-1 withData:[self.imagesArray objectAtIndex:curPage-1]];
    }
}

@end
