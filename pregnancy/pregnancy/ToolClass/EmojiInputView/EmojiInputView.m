//
//  wiEmojiInputView.m
//  wiIos
//
//  Created by qq on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EmojiInputView.h"
#import "ARCHelper.h"

// 人物
#define Emoji_People_key    @"People"
#define Emoji_People5_key   @"People_5"
// 物品
#define Emoji_Objects_key   @"Objects"
// 自然
#define Emoji_Nature_key    @"Nature"
// 地点
#define Emoji_Places_key    @"Places"
// 符号
#define Emoji_Symbols_key   @"Symbols"

#define Emoji_Lame_key      @"lama"


#define Emoji_bg_height     162.0f
#define Emoji_bar_height    45.0f


@interface EmojiInputView ()
- (void)changeEmojiCategory:(UIButton *)btn;
- (void)drawInputView:(EMOJI_TYPE)emojiType;
- (void)loadScrollViewWithPage:(NSInteger)page;

@end


@implementation EmojiInputView
@synthesize delegate;

@synthesize m_EmojiDic;
@synthesize m_EmojiCodeArray;
@synthesize m_EmojiViews;
@synthesize m_BtnArray;

- (void)dealloc
{
    [m_EmojiDic ah_release];
    [m_EmojiViews ah_release];
    [m_EmojiCodeArray ah_release];
    [m_BtnArray ah_release];
    
    [super ah_dealloc];
}

- (NSDictionary *)makeEmojisDic
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmojisList"
                                                          ofType:@"plist"];
    self.m_EmojiDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    return m_EmojiDic;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code
        self.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, Emoji_bg_height+Emoji_bar_height);
        self.BackgroundColor = [UIColor clearColor];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, Emoji_bg_height)];
        bgImageView.image = [UIImage imageNamed:@"emoji_keybord_bg"];
        [self addSubview:bgImageView];
        [bgImageView ah_release];
        
        UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 162, UI_SCREEN_WIDTH, Emoji_bar_height)];
        bottomImageView.image = [UIImage imageNamed:@"emoji_keybord_bottom"];
        bottomImageView.userInteractionEnabled = YES;
        [self addSubview:bottomImageView];
        [bottomImageView ah_release];

/*
        NSArray *imagesForSelect = @[
        [UIImage imageNamed:@"emoji_keybord_face_sicon"],
        [UIImage imageNamed:@"emoji_keybord_bell_sicon"],
        [UIImage imageNamed:@"emoji_keybord_flower_sicon"],
        [UIImage imageNamed:@"emoji_keybord_car_sicon"],
        [UIImage imageNamed:@"emoji_keybord_characters_sicon"],
        [UIImage imageNamed:@"emoji_keybord_characters_sicon"],
        ];
        
        NSArray *imagesForNormal = @[
        [UIImage imageNamed:@"emoji_keybord_face_icon"],
        [UIImage imageNamed:@"emoji_keybord_bell_icon"],
        [UIImage imageNamed:@"emoji_keybord_flower_icon"],
        [UIImage imageNamed:@"emoji_keybord_car_icon"],
        [UIImage imageNamed:@"emoji_keybord_characters_icon"],
        [UIImage imageNamed:@"emoji_keybord_characters_icon"],
        ];
*/ 
        self.m_BtnArray = [NSMutableArray arrayWithCapacity:0];

/*
        CGFloat width = (UI_SCREEN_WIDTH-80)/imagesForNormal.count;
        for (NSInteger i = 0 ; i < imagesForNormal.count; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(40+i*width, 0, width, 54);
            [btn addTarget:self action:@selector(changeEmojiCategory:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [btn setImage:[imagesForNormal objectAtIndex:i] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"emoji_keybord_icon_bg"] forState:UIControlStateNormal];
            [btn setImage:[imagesForSelect objectAtIndex:i] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@"emoji_keybord_icon_sbg"] forState:UIControlStateSelected];
            btn.exclusiveTouch = YES;
            [bottomImageView addSubview:btn];
            
            [m_BtnArray addObject:btn];
        }
*/
        
        UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lbtn.frame = CGRectMake(0, 0, 45, Emoji_bar_height);
        [lbtn addTarget:self action:@selector(switchEmoji:) forControlEvents:UIControlEventTouchUpInside];
        [lbtn setImage:[UIImage imageNamed:@"emoji_keybord_switch_icon"] forState:UIControlStateNormal];
        [lbtn setImage:[UIImage imageNamed:@"emoji_keybord_switch_sicon"] forState:UIControlStateHighlighted];
        lbtn.exclusiveTouch = YES;
        [bottomImageView addSubview:lbtn];

        UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rbtn.frame = CGRectMake(UI_SCREEN_WIDTH-45, 0, 45, Emoji_bar_height);
        [rbtn addTarget:self action:@selector(deleteEmoji:) forControlEvents:UIControlEventTouchUpInside];
        [rbtn setImage:[UIImage imageNamed:@"emoji_keybord_delete_icon"] forState:UIControlStateNormal];
        [rbtn setImage:[UIImage imageNamed:@"emoji_keybord_delete_sicon"] forState:UIControlStateHighlighted];
        rbtn.exclusiveTouch = YES;
        [bottomImageView addSubview:rbtn];
        
        s_ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, EMOJI_VIEW_HEIGHT)];
        s_ScrollView.pagingEnabled = YES;
        s_ScrollView.delegate = self;
        s_ScrollView.showsHorizontalScrollIndicator = NO;
        s_ScrollView.BackgroundColor = [UIColor clearColor];
        [self addSubview:s_ScrollView];
        [s_ScrollView ah_release];
        
        s_PageControl = [[HMPageControl alloc] init];
        
        if (IOS_VERSION >= 6.0)
        {
            s_PageControl.pageIndicatorTintColor = [UIColor colorWithHex:0xDDDDDD];
            s_PageControl.currentPageIndicatorTintColor = [UIColor colorWithHex:0x888888];
        }
        else
        {
            s_PageControl.imagePageStateNormal = [UIImage imageNamed:@"emoji_page_dot"];
            s_PageControl.imagePageStateHighlighted = [UIImage imageNamed:@"emoji_page_dot_active"];
        }

        s_PageControl.frame = CGRectMake(0, EMOJI_VIEW_HEIGHT, UI_SCREEN_WIDTH, 10);
        [s_PageControl addTarget:self action:@selector(clickpagecontrol:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:s_PageControl];
        [s_PageControl ah_release];
        
        s_CurrentCategory = -1;
        
        [self makeEmojisDic];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)deleteEmoji:(UIButton *)btn
{
    [delegate deleteEmoji];
}

- (void)switchEmoji:(UIButton *)btn
{
    [delegate switchEmojiInputView];
}

- (void)changeEmojiCategoryByIndex:(EMOJI_TYPE)emojiType
{
    if ([m_BtnArray isNotEmpty])
    {
        UIButton *sbtn = [m_BtnArray objectAtIndex:emojiType];
    
        [self changeEmojiCategory:sbtn];
    }
    else
    {
        if (s_CurrentCategory == EMOJI_CATEGORY_LAMA)
        {
            return;
        }
        
        [self drawInputView:EMOJI_CATEGORY_LAMA];
    }
}

- (void)changeEmojiCategory:(UIButton *)btn
{
    if (s_CurrentCategory == btn.tag)
    {
        return;
    }
    
    for (NSInteger i = 0; i < m_BtnArray.count; i++)
    {
        UIButton *sbtn = [m_BtnArray objectAtIndex:i];
        sbtn.selected = NO;
    }
    
    btn.selected = YES;
    [self drawInputView:btn.tag];
}
 
- (void)drawInputView:(EMOJI_TYPE)emojiType
{
    NSArray *keyArray;
    
    s_CurrentCategory = emojiType;
    
    if (IOS_VERSION >= 6.0)
    {
        keyArray = @[Emoji_People_key, Emoji_Objects_key, Emoji_Nature_key, Emoji_Places_key, Emoji_Symbols_key, Emoji_Lame_key];
    }
    else
    {
        keyArray = @[Emoji_People5_key, Emoji_Objects_key, Emoji_Nature_key, Emoji_Places_key, Emoji_Symbols_key, Emoji_Lame_key];
    }
    
    self.m_EmojiCodeArray = [NSMutableArray arrayWithArray:[m_EmojiDic arrayForKey:[keyArray objectAtIndex:emojiType]]];
    
    NSInteger pageCount = m_EmojiCodeArray.count / EMOJI_ONEPAGE_COUNT;
    if (m_EmojiCodeArray.count % EMOJI_ONEPAGE_COUNT > 0)
    {
        pageCount++;
    }
    
    [m_EmojiViews removeAllObjects];
    
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < pageCount; i++)
    {
		[views addObject:[NSNull null]];
    }
    self.m_EmojiViews = views;
    [views ah_release];

    // 先初始化PageControl，否则scrollViewDidScroll后m_EmojiViews的index有可能溢出
    NSInteger currentPage = 0;
    s_PageControl.numberOfPages = pageCount;
    s_PageControl.currentPage = currentPage;
    
    if (s_ScrollView != nil)
    {
        [s_ScrollView removeAllSubviews];
    }
    
    s_ScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH * pageCount, EMOJI_VIEW_HEIGHT);

    [self loadScrollViewWithPage:currentPage];
    s_ScrollView.contentOffset = CGPointMake(UI_SCREEN_WIDTH * currentPage, 0);
}


- (void)loadScrollViewWithPage:(NSInteger)page
{
    if (s_PageControl.numberOfPages == 0)
        return;
    
    if (page < 0)
        return;
    
    if (page >= s_PageControl.numberOfPages)
        return;
    
    // replace the placeholder if necessary
    EmojiImagePageView *view = [m_EmojiViews objectAtIndex:page];
    if ((NSNull *)view == [NSNull null])
    {
        view = [[EmojiImagePageView alloc] initWithEmojiArray:m_EmojiCodeArray];
        view.delegate = self;
        [m_EmojiViews replaceObjectAtIndex:page withObject:view];
        [view ah_release];
    }
    
    // add the controller's view to the scroll view
    if (view.superview == nil)
    {
        CGRect frame = s_ScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        view.frame = frame;
        [s_ScrollView addSubview:view];
        [view drawPageAtIndex:page];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (s_PageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = s_ScrollView.frame.size.width;
    NSInteger page = floor((s_ScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    s_PageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    s_PageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    s_PageControlUsed = NO;
}

- (void)clickpagecontrol:(id)sender
{
    NSInteger page = s_PageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = s_ScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [s_ScrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    s_PageControlUsed = YES;
}

- (void)selectedEmojiatIndex:(NSInteger)index
{
    [self.delegate setEmojiFromEmojiInputView:[m_EmojiCodeArray objectAtIndex:index]];
}

@end

/*
// 使用举例
 
    EmojiInputView *emojiInputView = [[[EmojiInputView alloc] init] autorelease];
    [emojiInputView changeEmojiCategoryByIndex:EMOJI_CATEGORY_MOOD];
    emojiInputView.delegate = self;
    m_EmailTextField.inputView = emojiInputView;
 
#pragma mark -
#pragma mark EmojiInputViewDelegate

- (void)switchEmojiInputView
{
    m_EmailTextField.inputView = nil;
    [m_EmailTextField reloadInputViews];
}

- (void)setEmojiFromEmojiInputView:(NSString *)emojiStr
{
    [m_EmailTextField insertText:emojiStr];
}

- (void)deleteEmoji
{
    [m_EmailTextField deleteBackward];
}
*/