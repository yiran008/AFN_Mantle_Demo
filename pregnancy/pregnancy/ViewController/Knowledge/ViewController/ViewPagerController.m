//
//  ViewPagerController.m
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import "ViewPagerController.h"
#import "HorizontalTableView.h"
#import "BBKonwlegdeModel.h"

#define kDefaultTabHeight 44.0 // Default tab height
#define kDefaultTabWidth 53.0
#define kDefaultTabOffset ((UI_SCREEN_WIDTH - kDefaultTabWidth)/2) // Offset of the second and further tabs' from left
//背景图长宽
#define kDefaultTabBackWidth 40.0

#define kDefaultTabLocation 1.0 // 1.0: Top, 0.0: Bottom

#define kDefaultCenterCurrentTab 0.0 // 1.0: YES, 0.0: NO

#define kPageViewTag 34

#define kDefaultIndicatorColor [UIColor colorWithRed:178.0/255.0 green:203.0/255.0 blue:57.0/255.0 alpha:0.75]
#define kDefaultTabsViewBackgroundColor [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:0.75]
#define kDefaultContentViewBackgroundColor [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:0.75]

@interface Label2View : UIView
@property (nonatomic,strong)UILabel * label1;
@property (nonatomic,strong)UILabel * label2;
//非选中时的本色
@property (nonatomic,strong)UIColor * basicColor;
@end

@implementation Label2View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDefaultTabWidth, 27)];
        self.label1.backgroundColor = [UIColor clearColor];
        self.label1.font = [UIFont systemFontOfSize:14.];
        self.label1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label1];
        
        self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, kDefaultTabHeight - 27, kDefaultTabWidth, 27)];
        self.label2.backgroundColor = [UIColor clearColor];
        self.label2.font = [UIFont systemFontOfSize:14.];
        self.label2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label2];
    }
    return self;
}

@end


@interface Label1View : UIView
@property (nonatomic,strong)UILabel * label;
//非选中时的本色
@property (nonatomic,strong)UIColor * basicColor;
@end

@implementation Label1View
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDefaultTabWidth, kDefaultTabHeight)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont systemFontOfSize:14.];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
    }
    return self;
}

- (void)setData:(BBKonwlegdeModel *)data
{
    
}

- (void)setSelected:(BOOL)selected
{
}
@end

// TabView for tabs, that provides un/selected state indicators
@class TabView;

@interface TabView : UIView
@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic) UIColor *indicatorColor;
@property (nonatomic,strong)UIView * backView;
@property (nonatomic,strong)UIView * poit;
@property (nonatomic,strong)Label1View * label1View;
@property (nonatomic,strong)Label2View * label2View;

@end

@implementation TabView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setData:(BBKonwlegdeModel *)data isCurIndex:(BOOL)isCurIndex
{
    if (data.period == knowlegdePeriodPregnancy)
    {
        if (data.days.intValue == 21)
        {
            if (!self.label2View)
            {
                self.label2View = [[Label2View alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                [self addSubview:self.label2View];
            }
            self.label2View.label1.text =@"3周";
            self.label2View.label1.textColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
            self.label2View.label2.text = @"之前";
            self.label2View.label2.textColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
            self.label2View.basicColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
        }else
        {
            int weeks = data.days.intValue / 7;
            int day = data.days.intValue % 7;
            if (day == 0)
            {
                if (!self.label1View) {
                    self.label1View = [[Label1View alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                    [self addSubview:self.label1View];
                }
                self.label1View.label.text = [NSString stringWithFormat:@"%d周",weeks];
                self.label1View.label.textColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
                self.label1View.basicColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
            }
            else
            {
                if (!self.label2View)
                {
                    self.label2View = [[Label2View alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                    [self addSubview:self.label2View];
                }
                self.label2View.label1.text =[NSString stringWithFormat:@"%d周",weeks];
                self.label2View.label1.textColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
                self.label2View.label2.text = [NSString stringWithFormat:@"%d天",day];
                self.label2View.label2.textColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
                self.label2View.basicColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
            }
        }

        
    }
    else if (data.period == knowlegdePeriodParent)
    {
        //出生日
        if (data.days.intValue == 1)
        {
            if (!self.label2View)
            {
                self.label2View = [[Label2View alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                [self addSubview:self.label2View];
            }
            self.label2View.label1.text = @"宝宝";
            self.label2View.label1.textColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(255, 166, 188, 1);
            self.label2View.label2.text = @"出生了";
            self.label2View.label2.textColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(255, 166, 188, 1);
            self.label2View.basicColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(255, 166, 188, 1);
        }
        else if (data.days.intValue > 1)
        {
            NSDate * birthDate = [BBPregnancyInfo dateOfPregnancy];
            NSDate * curDate = [birthDate dateByAddingDays:data.days.intValue-1];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
            NSDateComponents *dateCom = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:birthDate toDate:curDate options:0];
            
            if (dateCom.month == 0)
            {
                if (!self.label1View)
                {
                    self.label1View = [[Label1View alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                    [self addSubview:self.label1View];
                }
                self.label1View.label.text = [NSString stringWithFormat:@"%@天",data.days];
                self.label1View.label.textColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
                self.label1View.basicColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
            }
            else if(dateCom.day == 0)
            {
                if (!self.label2View)
                {
                    self.label2View = [[Label2View alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                    [self addSubview:self.label2View];
                }
                self.label2View.label1.text =[NSString stringWithFormat:@"宝宝"];
                self.label2View.label1.textColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
                self.label2View.label2.text = [NSString stringWithFormat:@"%d月",dateCom.month];
                self.label2View.label2.textColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
                self.label2View.basicColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
                
            }
            else if(dateCom.month >= 0)
            {
                if (!self.label2View)
                {
                    self.label2View = [[Label2View alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                    [self addSubview:self.label2View];
                }
                self.label2View.label1.text =[NSString stringWithFormat:@"%d月",dateCom.month];
                self.label2View.label1.textColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
                self.label2View.label2.text = [NSString stringWithFormat:@"%d天",dateCom.day];
                self.label2View.label2.textColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
                self.label2View.basicColor = isCurIndex ? RGBColor(255, 83, 123, 1) : RGBColor(95, 95, 95, 1);
            }
            
        }
        //TO-DO 大于一个月的情况
    }
    
    if(isCurIndex)
    {
        if (!self.poit)
        {
            self.poit = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 5)];
            self.poit.center = CGPointMake(self.frame.size.width/2, self.frame.size.height -5);
            self.poit.layer.cornerRadius = 2.5;
            [self insertSubview:self.poit atIndex:0];
            self.poit.backgroundColor = RGBColor(255, 83, 123, 1);
        }
        self.poit.hidden = NO;
    }else
    {
        if (self.poit) {
            self.poit.hidden = YES;
        }
    }
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    if (selected)
    {
        if (!self.backView)
        {
            self.backView = [[UIView alloc]initWithFrame:CGRectMake((kDefaultTabWidth - kDefaultTabBackWidth)/2, (kDefaultTabHeight-kDefaultTabBackWidth)/2, kDefaultTabBackWidth, kDefaultTabBackWidth)];
            self.backView.layer.cornerRadius = 2.f;
            if (self.poit)
            {
                [self insertSubview:self.backView aboveSubview:self.poit];
            }else
            {
                [self insertSubview:self.backView atIndex:0];
            }
        }
        self.backView.hidden = NO;
        self.backView.backgroundColor = RGBColor(255,166,188,1);
        self.label1View.label.textColor = [UIColor whiteColor];
        self.label2View.label1.textColor = [UIColor whiteColor];
        self.label2View.label2.textColor = [UIColor whiteColor];
    }else
    {
        if (self.backView)
        {
            self.backView.hidden = YES;
        }
        self.label1View.label.textColor = self.label1View.basicColor;
        self.label2View.label1.textColor = self.label2View.basicColor;
        self.label2View.label2.textColor = self.label2View.basicColor;
    }
}

@end


// ViewPagerController
@interface ViewPagerController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate,HorizontalTableViewDelegate>

@property UIPageViewController *pageViewController;
@property (assign) id<UIScrollViewDelegate> origPageScrollViewDelegate;

@property HorizontalTableView *tabsView;
@property UIView *contentView;

@property NSMutableArray *tabs;
@property NSMutableArray *contents;

@property NSUInteger tabCount;
@property (getter = isAnimatingToTab, assign) BOOL animatingToTab;

@end

@implementation ViewPagerController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultSettings];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self defaultSettings];
    }
    return self;
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
	
    [self reloadData];
}
- (void)viewWillLayoutSubviews {
    
    CGRect frame;
    
    frame = _tabsView.frame;
    frame.origin.x = 0.0;
    frame.origin.y = self.tabLocation ? 0.0 : self.view.frame.size.height - self.tabHeight;
    frame.size.width = self.view.bounds.size.width ;
    frame.size.height = self.tabHeight;
    _tabsView.frame = frame;
    
    frame = _contentView.frame;
    frame.origin.x = 0.0;
    frame.origin.y = self.tabLocation ? self.tabHeight : 0.0;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = self.view.frame.size.height - self.tabHeight;
    _contentView.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)handleTapGesture:(id)sender {
    
    self.animatingToTab = YES;
    
    // Get the desired page's index
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *)sender;
    UIView *tabView = tapGestureRecognizer.view;
    __block NSUInteger index = [self.tabsView.pageViews indexOfObject:tabView];
    
    // Get the desired viewController
    UIViewController *viewController = [self viewControllerAtIndex:index];
    
    // __weak pageViewController to be used in blocks to prevent retaining strong reference to self
    __weak UIPageViewController *weakPageViewController = self.pageViewController;
    __weak ViewPagerController *weakSelf = self;
    viewController.view.tag = index;
    
    NSLog(@"%@",weakPageViewController.view);
    UIViewController * vc = [[UIViewController alloc]init];
    if (index < self.activeTabIndex)
    {
        [self.pageViewController setViewControllers:@[vc]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:YES
                                         completion:^(BOOL completed) {
                                             weakSelf.animatingToTab = NO;
                                             
                                             // Set the current page again to obtain synchronisation between tabs and content
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakPageViewController setViewControllers:@[viewController]
                                                                                  direction:UIPageViewControllerNavigationDirectionReverse
                                                                                   animated:NO
                                                                                 completion:nil];
                                             });
                                         }];
    } else if (index > self.activeTabIndex) {
        
        [self.pageViewController setViewControllers:@[vc]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:^(BOOL completed) {
                                             weakSelf.animatingToTab = NO;
                                             
                                             // Set the current page again to obtain synchronisation between tabs and content
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakPageViewController setViewControllers:@[viewController]
                                                                                  direction:UIPageViewControllerNavigationDirectionForward
                                                                                   animated:NO
                                                                                 completion:nil];
                                             });
                                         }];
    }
    
    // Set activeTabIndex
    self.activeTabIndex = index;
}

#pragma mark - 
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // Re-align tabs if needed
    self.activeTabIndex = self.activeTabIndex;
}

#pragma mark - Setter/Getter
- (void)setActiveTabIndex:(NSUInteger)activeTabIndex
{
    // Bring tab to active position
    // Position the tab in center if centerCurrentTab option provided as YES
    
    CGRect frame = CGRectMake(activeTabIndex * kDefaultTabWidth, 0, kDefaultTabWidth, kDefaultTabHeight);
    
    if (self.centerCurrentTab)
    {
        
        frame.origin.x += (frame.size.width / 2);
        frame.origin.x -= _tabsView.frame.size.width / 2;
        frame.size.width = _tabsView.frame.size.width;
        
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
        }
        
        if ((frame.origin.x + frame.size.width) > _tabsView.scrollView.contentSize.width) {
            frame.origin.x = (_tabsView.scrollView.contentSize.width - _tabsView.frame.size.width);
        }
    } else {
        
        frame.origin.x -= self.tabOffset;
        frame.size.width = self.tabsView.frame.size.width;
    }
    [_tabsView.scrollView scrollRectToVisible:frame animated:YES];
    
    TabView *activeTabView;
    
    // Set to-be-inactive tab unselected
    activeTabView = [self tabViewAtIndex:self.activeTabIndex];
    if ([activeTabView isKindOfClass:[TabView class]])
    {
        activeTabView.selected = NO;
    }
    
    // Set to-be-active tab selected
    activeTabView = [self tabViewAtIndex:activeTabIndex];
    if ([activeTabView isKindOfClass:[TabView class]])
    {
        activeTabView.selected = YES;
    }
    
    // Set current activeTabIndex
    _activeTabIndex = activeTabIndex;
    
    // Inform delegate about the change
    if ([self.delegate respondsToSelector:@selector(viewPager:didChangeTabToIndex:)]) {
        [self.delegate viewPager:self didChangeTabToIndex:self.activeTabIndex];
    }
    
}

#pragma mark -
- (void)defaultSettings {
    
    // Default settings
    _tabHeight = kDefaultTabHeight;
    _tabOffset = kDefaultTabOffset;
    _tabWidth = kDefaultTabWidth;
    
    _tabLocation = kDefaultTabLocation;
    
    _startFromTabIndex = 0;
    
    _centerCurrentTab = kDefaultCenterCurrentTab;
    
    // Default colors
    _indicatorColor = kDefaultIndicatorColor;
    _tabsViewBackgroundColor = kDefaultTabsViewBackgroundColor;
    _contentViewBackgroundColor = kDefaultContentViewBackgroundColor;
    
    // pageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    
    //Setup some forwarding events to hijack the scrollview
    self.origPageScrollViewDelegate = ((UIScrollView*)[_pageViewController.view.subviews objectAtIndex:0]).delegate;
    [((UIScrollView*)[_pageViewController.view.subviews objectAtIndex:0]) setDelegate:self];
    
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    self.animatingToTab = NO;
}
- (void)reloadData {
    
    // Get settings if provided
    if ([self.delegate respondsToSelector:@selector(viewPager:valueForOption:withDefault:)]) {
        _tabHeight = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabHeight withDefault:kDefaultTabHeight];
        _tabOffset = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabOffset withDefault:kDefaultTabOffset];
        _tabWidth = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabWidth withDefault:kDefaultTabWidth];
        
        _tabLocation = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabLocation withDefault:kDefaultTabLocation];
        
        _centerCurrentTab = [self.delegate viewPager:self valueForOption:ViewPagerOptionCenterCurrentTab withDefault:kDefaultCenterCurrentTab];
    }
    
    if ([self.delegate respondsToSelector:@selector(indexForTabWithViewPager:)])
    {
        _startFromTabIndex = [self.delegate indexForTabWithViewPager:self];
    }
    
    // Get colors if provided
    if ([self.delegate respondsToSelector:@selector(viewPager:colorForComponent:withDefault:)]) {
        _indicatorColor = [self.delegate viewPager:self colorForComponent:ViewPagerIndicator withDefault:kDefaultIndicatorColor];
        _tabsViewBackgroundColor = [self.delegate viewPager:self colorForComponent:ViewPagerTabsView withDefault:kDefaultTabsViewBackgroundColor];
        _contentViewBackgroundColor = [self.delegate viewPager:self colorForComponent:ViewPagerContent withDefault:kDefaultContentViewBackgroundColor];
    }
    
    // Empty tabs and contents
    [_contents removeAllObjects];
    
    _tabCount = [self.dataSource numberOfTabsForViewPager:self];
    
    _contents = [NSMutableArray arrayWithCapacity:_tabCount];
    for (int i = 0; i < _tabCount; i++) {
        [_contents addObject:[NSNull null]];
    }
    
//    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24., kDefaultTabHeight)];
//    leftView.image = [UIImage imageNamed:@"knowledge_points"];
//    leftView.contentMode = UIViewContentModeScaleAspectFit;
//    leftView.backgroundColor = self.tabsViewBackgroundColor;
//    [self.view insertSubview:leftView atIndex:0];
//    
//    UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width -24., 0, 24., kDefaultTabHeight)];
//    rightView.image = [UIImage imageNamed:@"knowledge_points"];
//    rightView.contentMode = UIViewContentModeScaleAspectFit;
//    rightView.backgroundColor = self.tabsViewBackgroundColor;
//    [self.view insertSubview:rightView atIndex:0];

    // Add tabsView
    _tabsView = [[HorizontalTableView alloc] initWithFrame:CGRectMake(24.0, 0.0, self.view.frame.size.width -48, self.tabHeight)];
    _tabsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tabsView.backgroundColor = self.tabsViewBackgroundColor;
    _tabsView.delegate = self;
    
    [self.view insertSubview:_tabsView atIndex:0];
    
    // Add contentView
    _contentView = [self.view viewWithTag:kPageViewTag];
    
    if (!_contentView) {
        
        _contentView = _pageViewController.view;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _contentView.backgroundColor = self.contentViewBackgroundColor;
        _contentView.bounds = self.view.bounds;
        _contentView.tag = kPageViewTag;
        
        [self.view insertSubview:_contentView atIndex:0];
    }
    
    // Set first viewController
    UIViewController *viewController;
    
    viewController = [self viewControllerAtIndex:_startFromTabIndex];
    
    if (viewController == nil) {
        viewController = [[UIViewController alloc] init];
        viewController.view = [[UIView alloc] init];
    }
    
    [_pageViewController setViewControllers:@[viewController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    [self.tabsView refreshData];    
    // Set activeTabIndex
    self.activeTabIndex = _startFromTabIndex;//self.startFromSecondTab;
}

- (TabView *)tabViewAtIndex:(NSUInteger)index {
    if (index < self.tabsView.pageViews.count) {
        return [self.tabsView.pageViews objectAtIndex:index];
    }
    return nil;
}
- (NSUInteger)indexForTabView:(UIView *)tabView {
    
    return [self.tabsView.pageViews indexOfObject:tabView];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (index >= _tabCount) {
        return nil;
    }
    
    UIViewController *viewController;
    
    if ([self.dataSource respondsToSelector:@selector(viewPager:contentViewControllerForTabAtIndex:)])
    {
        viewController = [self.dataSource viewPager:self contentViewControllerForTabAtIndex:index];
    }
    else if ([self.dataSource respondsToSelector:@selector(viewPager:contentViewForTabAtIndex:)])
    {
        UIView *view = [self.dataSource viewPager:self contentViewForTabAtIndex:index];
        // Adjust view's bounds to match the pageView's bounds
        UIView *pageView = [self.view viewWithTag:kPageViewTag];
        view.frame = pageView.bounds;
        
        viewController = [UIViewController new];
        viewController.view = view;
    } else
    {
        viewController = [[UIViewController alloc] init];
        viewController.view = [[UIView alloc] init];
    }
    viewController.view.tag = index;
    
    return viewController;
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = viewController.view.tag;
    index++;
    return [self viewControllerAtIndex:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = viewController.view.tag;
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
//    NSLog(@"willTransitionToViewController: %i", [self indexForViewController:[pendingViewControllers objectAtIndex:0]]);
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    UIViewController *viewController = self.pageViewController.viewControllers[0];
    self.activeTabIndex = viewController.view.tag;
}

#pragma mark - UIScrollViewDelegate, Responding to Scrolling and Dragging
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.origPageScrollViewDelegate scrollViewDidScroll:scrollView];
    }
    
    if (![self isAnimatingToTab])
    {
        CGRect frame = CGRectMake(self.activeTabIndex * kDefaultTabWidth, 0, kDefaultTabWidth, kDefaultTabHeight);
        // Get the related tab view position
        CGFloat movedRatio = (scrollView.contentOffset.x / scrollView.frame.size.width) - 1;
        frame.origin.x += movedRatio * frame.size.width;
        
        if (self.centerCurrentTab)
        {
            
            frame.origin.x += (frame.size.width / 2);
            frame.origin.x -= _tabsView.frame.size.width / 2;
            frame.size.width = _tabsView.frame.size.width;
            
            if (frame.origin.x < 0)
            {
                frame.origin.x = 0;
            }
            
            if ((frame.origin.x + frame.size.width) > _tabsView.scrollView.contentSize.width)
            {
                frame.origin.x = (_tabsView.scrollView.contentSize.width - _tabsView.frame.size.width);
            }
        } else
        {
            
            frame.origin.x -= self.tabOffset;
            frame.size.width = self.tabsView.frame.size.width;
        }
        
        [_tabsView.scrollView scrollRectToVisible:frame animated:NO];
 
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.origPageScrollViewDelegate scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.origPageScrollViewDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.origPageScrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.origPageScrollViewDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return NO;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.origPageScrollViewDelegate scrollViewDidScrollToTop:scrollView];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.origPageScrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.origPageScrollViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark - UIScrollViewDelegate, Managing Zooming
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.origPageScrollViewDelegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.origPageScrollViewDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.origPageScrollViewDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.origPageScrollViewDelegate scrollViewDidZoom:scrollView];
    }
}

#pragma mark - UIScrollViewDelegate, Responding to Scrolling Animations
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.origPageScrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}


- (NSInteger)numberOfColumnsForTableView:(HorizontalTableView *)tableView
{
    return self.tabCount;
}
- (UIView *)tableView:(HorizontalTableView *)tableView viewForIndex:(NSInteger)index
{
    if (index >= _tabCount) {
        return nil;
    }
    
    // Get view from dataSource
    BBKonwlegdeModel *data = [self.dataSource viewPager:self dataForTabAtIndex:index];
    
    // Create TabView and subview the content
    TabView *tabView = [[TabView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tabWidth, self.tabHeight)];
    [tabView setClipsToBounds:YES];
    [tabView setData:data isCurIndex:index == _startFromTabIndex];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    for (UIGestureRecognizer * gestrue in tabView.gestureRecognizers)
    {
        [tabView removeGestureRecognizer:gestrue];
    }
    [tabView addGestureRecognizer:tapGestureRecognizer];
    tabView.exclusiveTouch = YES;
    
    if (index == _activeTabIndex && !tabView.isSelected) {
        tabView.selected = YES;
    }

    return tabView;
}
- (CGFloat)columnWidthForTableView:(HorizontalTableView *)tableView
{
    return kDefaultTabWidth;
}

@end
