//
//  HMTopicDetailBottomView.m
//  lama
//
//  Created by songxf on 13-7-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMTopicDetailBottomView.h"
#import "ARCHelper.h"


#define PAGE_CONTENT_WIDTH 72
@interface HMTopicDetailBottomView ()

// 是否调节页数模式
@property (nonatomic, assign) BOOL m_isPageStyle;
// 回复楼主模式背景图view
@property (nonatomic, retain) UIImageView *bgView;
// 上下页模式背景图view
@property (nonatomic, retain) UIImageView *pageView;
// 手势控制view
@property (nonatomic, retain) UIView *gestureView;
@property (nonatomic, retain) UIButton *replyBtn;
@property (nonatomic, retain) UIButton *upPageBtn;
@property (nonatomic, retain) UIButton *downPageBtn;
@property (nonatomic, retain) UIButton *pageBtn;
@property (nonatomic, retain) UILabel *pageLab;
@property (nonatomic, retain) HMTopicDetailSliderView *sliderView;

@property (nonatomic, retain) UILabel *currentPageLab;

@end

@implementation HMTopicDetailBottomView
@synthesize m_isPageStyle;
@synthesize m_maxPageNumber;
@synthesize m_currentPage;
@synthesize delegate;

@synthesize bgView;
@synthesize pageView;
@synthesize replyBtn;
@synthesize gestureView;
@synthesize upPageBtn;
@synthesize downPageBtn;
@synthesize pageLab;
@synthesize sliderView;
@synthesize pageBtn;
@synthesize currentPageLab;

-(void)dealloc
{
    sliderView.delegate = nil;
    [sliderView ah_release];
    [currentPageLab ah_release];
    [pageLab ah_release];
    [pageBtn ah_release];
    [upPageBtn ah_release];
    [downPageBtn ah_release];
    [pageView ah_release];
    [replyBtn ah_release];
    [bgView ah_release];
    [gestureView ah_release];
    delegate = nil;
    
    [super ah_dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        m_top = frame.origin.y;
        
        [self loadViews];
    }
    
    return self;
}

- (id)initWithTop:(CGFloat)top
{
    CGRect frame = CGRectMake(0, top, UI_SCREEN_WIDTH, BOTTOM_VIEW_HEGHT);
    self = [super initWithFrame:frame];
    
    if (self)
    {
        m_top = top;
        
        m_maxPageNumber = 1;
        m_currentPage = 1;
        
        [self loadViews];
    }
    
    return self;
}


- (void)loadViews
{
    // 添加背景图片
    self.bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topicdetail_bottom_bg"]] ah_autorelease];
    bgView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, BOTTOM_VIEW_HEGHT);
    bgView.backgroundColor = [UIColor clearColor];
    bgView.frame = self.bounds;
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];

    // 添加切换页面按钮
    self.pageBtn = [[[UIButton alloc] initWithFrame:CGRectMake(12, 7, 80, 36)] ah_autorelease];//19 17
    self.pageBtn.exclusiveTouch = YES;
    [pageBtn setImage:[UIImage imageWithColor:UI_NAVIGATION_BGCOLOR size:pageBtn.size] forState:UIControlStateNormal];
    [pageBtn roundedRect:6.0 borderWidth:0.0 borderColor:[UIColor clearColor]];
    [pageBtn addTarget:self action:@selector(didPressPageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:pageBtn];

    UILabel *lab = [[[UILabel alloc] init] ah_autorelease];
    lab.frame = CGRectMake((80-PAGE_CONTENT_WIDTH)/2, 10, PAGE_CONTENT_WIDTH, 16);
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = [UIColor whiteColor];
    lab.backgroundColor = [UIColor clearColor];
    [lab setContentMode:UIViewContentModeTop];
    lab.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = [NSString stringWithFormat:@"%d/%d页",m_currentPage,m_maxPageNumber];
    [pageBtn addSubview:lab];
    self.pageLab = lab;
    [pageLab setMinimumScaleFactor:0.2];
    [pageLab setAdjustsFontSizeToFitWidth:YES];
    

    // 添加回复楼主按钮
    UIImage *imagebg1 = [UIImage imageNamed:@"detail_page_frame1"];
    UIImage *imagebg2 = [imagebg1 resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.replyBtn = [[[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-12-207, 7, 207, 36)] ah_autorelease];
    self.replyBtn.exclusiveTouch = YES;
    [replyBtn setBackgroundImage:imagebg2 forState:
     UIControlStateNormal];
    [replyBtn addTarget:self action:@selector(didPressReplyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:replyBtn];
    
    [replyBtn setTitle:@"回复楼主" forState:UIControlStateNormal];
    [replyBtn setTitleColor:DETAIL_PAGE_INVALID_COLOR forState:UIControlStateNormal];
    [replyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -120, 0, 0)];
    replyBtn.titleLabel.font = [UIFont systemFontOfSize:16];

    
    // 添加上一页下一页按钮
    self.pageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, UI_MAINSCREEN_HEIGHT-BOTTOM_VIEW_HEGHT, UI_SCREEN_WIDTH, 84)] ah_autorelease];
    UIImage *imagebg21 = [UIImage imageNamed:@"detail_page_frame2"];
    UIImage *imagebg22 = [imagebg21 stretchableImageWithLeftCapWidth:24 topCapHeight:12];
    [pageView setImage:imagebg22];
    [self addSubview:pageView];
    pageView.userInteractionEnabled = YES;
    pageView.backgroundColor = [UIColor clearColor];
    
    UIButton *upBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 42, pageView.width/4, 42)] ah_autorelease];
    upBtn.exclusiveTouch = YES;
    [upBtn setBackgroundColor:[UIColor clearColor]];
    [upBtn setTitle:@"上一页" forState:UIControlStateNormal];
    [upBtn setTitleColor:DETAIL_PAGE_INVALID_COLOR forState:UIControlStateNormal];
    upBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    upBtn.enabled = NO;
    [upBtn addTarget:self action:@selector(lastPage:) forControlEvents:UIControlEventTouchUpInside];
    [pageView addSubview:upBtn];
    self.upPageBtn = upBtn;
    
    UIButton *downBtn = [[[UIButton alloc] initWithFrame:CGRectMake(pageView.width/4*3, 42, pageView.width/4, 42)] ah_autorelease];
    downBtn.exclusiveTouch = YES;
    [downBtn setBackgroundColor:[UIColor clearColor]];
    [downBtn setTitle:@"下一页" forState:UIControlStateNormal];
    [downBtn setTitleColor:DETAIL_PAGE_INVALID_COLOR forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    downBtn.enabled = NO;
    downBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [pageView addSubview:downBtn];
    self.downPageBtn = downBtn;
    
    self.currentPageLab= [[[UILabel alloc] init] ah_autorelease];
    currentPageLab.frame = CGRectMake(pageView.width/4 , 42, pageView.width/2 , 42);
    currentPageLab.font = [UIFont systemFontOfSize:17];
    currentPageLab.textColor = DETAIL_PAGE_NORMAL_COLOR;
    currentPageLab.backgroundColor = [UIColor clearColor];
    currentPageLab.textAlignment = NSTextAlignmentCenter;
    [pageView addSubview:currentPageLab];

    CGRect rect = CGRectMake(0, 2, UI_SCREEN_WIDTH, SLIDER_VIEW_HEIGHT);
    self.sliderView = [[[HMTopicDetailSliderView alloc] initWithFrame:rect] ah_autorelease];
    sliderView.backgroundColor = [UIColor clearColor];
    sliderView.delegate = self;
    [pageView addSubview:sliderView];

    self.replyBtn.exclusiveTouch = YES;
    self.upPageBtn.exclusiveTouch = YES;
    self.downPageBtn.exclusiveTouch = YES;
    self.pageBtn.exclusiveTouch = YES;
    
    
    // 添加单击手势
    self.gestureView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH,UI_MAINSCREEN_HEIGHT-BOTTOM_VIEW_HEGHT-84)] ah_autorelease];
    [self addSubview:gestureView];

    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHMTDSliderView)] ah_autorelease];
    [tapGesture setNumberOfTapsRequired:1];
    [gestureView addGestureRecognizer:tapGesture];

    // 添加滑动手势
    UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(hideHMTDSliderView)] ah_autorelease];
    [gestureView addGestureRecognizer:panRecognizer];
    gestureView.exclusiveTouch = YES;
    gestureView.hidden = YES;
}

- (void)didPressPageBtn:(id)sender
{
    [MobClick event:@"discuz_v2" label:@"跳页点击"];
    if (self.m_maxPageNumber>1)
    {
        self.m_isPageStyle = !m_isPageStyle;
    }
}

- (void)didPressReplyBtn:(id)sender
{
    [MobClick event:@"discuz_v2" label:@"底部回复框"];
    if (delegate && [delegate respondsToSelector:@selector(openReplyMaster)])
    {
        [delegate openReplyMaster];
    }
}

- (void)lastPage:(id)sender
{
    self.m_currentPage -= 1;
    
    if (delegate && [delegate respondsToSelector:@selector(loadPrePage)])
    {
        [delegate loadPrePage];
    }
    else if (delegate && [delegate respondsToSelector:@selector(loadPageOfNumber:)])
    {
        [delegate loadPageOfNumber:m_currentPage];
    }
}

- (void)nextPage:(id)sender
{
    self.m_currentPage += 1;
    
    if (delegate && [delegate respondsToSelector:@selector(loadNextPage)])
    {
        [delegate loadNextPage];
    }
    else if (delegate && [delegate respondsToSelector:@selector(loadPageOfNumber:)])
    {
        [delegate loadPageOfNumber:m_currentPage];
    }
}

-(void)setM_maxPageNumber:(NSInteger)maxPageNumber
{
    if (maxPageNumber == m_maxPageNumber)
    {
        [self updatePageBtnAndView];

        return;
    }
    
    if (maxPageNumber<0)
    {
        maxPageNumber = 1;
    }
    
    m_maxPageNumber = maxPageNumber;

    sliderView.m_maxNumber = m_maxPageNumber;
    
    [self updatePageBtnAndView];
}

-(void)setM_currentPage:(NSInteger)currentPage
{
    if (currentPage == m_currentPage)
    {
        return;
    }
    
    if (currentPage<1)
    {
        currentPage = 1;
    }
    
    m_currentPage = currentPage;
    
    [self updateCurrentLab:m_currentPage];

    if (m_currentPage>m_maxPageNumber)
    {
        m_currentPage = m_maxPageNumber;
    }
    
    tempPage = m_currentPage;
    
    sliderView.m_number = m_currentPage;
    sliderView.m_maxNumber = m_maxPageNumber;
    sliderView.m_number = m_currentPage;

    [self updatePageBtnAndView];
}

- (void)updatePageBtnAndView
{
    if (m_currentPage>1)
    {
        self.upPageBtn.enabled = YES;
        [self.upPageBtn setTitleColor:DETAIL_PAGE_NORMAL_COLOR forState:UIControlStateNormal];
    }
    else
    {
        self.upPageBtn.enabled = NO;
        [self.upPageBtn setTitleColor:DETAIL_PAGE_INVALID_COLOR forState:UIControlStateNormal];
    }
    
    if (m_currentPage<m_maxPageNumber)
    {
        self.downPageBtn.enabled = YES;
        [self.downPageBtn setTitleColor:DETAIL_PAGE_NORMAL_COLOR forState:UIControlStateNormal];
    }
    else
    {
        self.downPageBtn.enabled = NO;
        [self.downPageBtn setTitleColor:DETAIL_PAGE_INVALID_COLOR forState:UIControlStateNormal];
    }

    pageLab.text = [NSString stringWithFormat:@"%ld/%ld页",(long)m_currentPage,(long)m_maxPageNumber];
    currentPageLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)m_currentPage,(long)m_maxPageNumber];

    if (m_maxPageNumber < 2)
    {
        pageBtn.enabled = NO;
    }
    else
    {
        pageBtn.enabled = YES;
    }
}

-(void)setM_isPageStyle:(BOOL)isPageStyle
{
    m_isPageStyle = isPageStyle;
    
    if (m_isPageStyle)
    {
        gestureView.hidden = NO;
        self.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT);
        self.bgView.top = UI_MAINSCREEN_HEIGHT-BOTTOM_VIEW_HEGHT-UI_NAVIGATION_BAR_HEIGHT;
    }
    else
    {
        gestureView.hidden = YES;
    }
    __block UIImageView *_view = pageView;
    if (isPageStyle)
    {
        [UIView animateWithDuration:0.25 animations:^{
            _view.top = UI_MAINSCREEN_HEIGHT-BOTTOM_VIEW_HEGHT-84;
        }];
    }
    else
    {
        __block UIView *_self = self;
        __block UIView *_bgView = bgView;
        [UIView animateWithDuration:0.25 animations:^{
            _view.top = UI_MAINSCREEN_HEIGHT-BOTTOM_VIEW_HEGHT;
        } completion:^(BOOL finished) {
            _self.frame = CGRectMake(0, m_top, UI_SCREEN_WIDTH, BOTTOM_VIEW_HEGHT);
            _bgView.top = 0;
        }];
    }
}

- (void)updateCurrentLab:(NSInteger)page
{
    self.currentPageLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)page,(long)m_maxPageNumber];
}

#pragma mark - delegate

- (void)hideHMTDSliderView
{
    self.m_isPageStyle = NO;
}

-(void)didSliderValueChanged:(NSInteger)number
{
    if (m_currentPage!=number)
    {
        self.m_currentPage = number;
        
        if (delegate && [delegate respondsToSelector:@selector(loadPageOfNumber:)])
        {
            [delegate loadPageOfNumber:m_currentPage];
        }
    }
}

-(void)tempSliderValueChanged:(NSInteger)number
{
    if (tempPage!=number)
    {
        if (number<1)
        {
            number = 1;
        }
        
        tempPage = number;
        
        if (tempPage>m_maxPageNumber)
        {
            tempPage = m_maxPageNumber;
        }
        
        [self updatePageBtnAndView];
        [self updateCurrentLab:tempPage];
        
        NSString *str = [NSString stringWithFormat:@"%ld/%ld页",(long)tempPage,(long)m_maxPageNumber];
        pageLab.text = str;
    }
}

@end
