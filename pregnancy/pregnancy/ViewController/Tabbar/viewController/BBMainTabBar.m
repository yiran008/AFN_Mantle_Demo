//
//  HMHotMomTabBar.m
//  BBHotMum
//
//  Created by songxf on 13-12-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//


#import "BBMainTabBar.h"
#import "BBMainPage.h"
#import "BBToolsNewVC.h"
#import "BBSupportTopicDetail.h"
#import "BBPersonalViewController.h"
#import "HMMoreCircleVC.h"
#import "BBToolsRequest.h"
#import "BBMainPageRequest.h"
#import "BBToolOpreation.h"

#define TABBAR_MAX_ITEM 5
#define NAVIGATION_TITLE1 @"首页"
#define NAVIGATION_TITLE2 @"圈子"
#define NAVIGATION_TITLE3 @"特卖"
#define NAVIGATION_TITLE4 @"工具"
#define NAVIGATION_TITLE5 @"我"
//#define UI_TAB_BAR_HEIGHT               49


@interface BBMainTabBar ()

//检查工具页是否有更新请求
@property (nonatomic, strong) ASIFormDataRequest *s_GetToolsListRequest;

//检查特卖页点标状态请求
@property (nonatomic, strong) ASIFormDataRequest *s_GetMallStatusRequest;

@property (assign) BOOL s_HasReadFromPlist;
@end

@implementation BBMainTabBar
//@synthesize m_BirthRequests;
@synthesize tab_itemlist;
@synthesize tab_textlist;
@synthesize m_TabBarBgView;
@synthesize btn_bg_imagelist;
@synthesize btn_selectbg_imagelist;
@synthesize btn_highlightbg_imagelist;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_s_GetToolsListRequest clearDelegatesAndCancel];
    [_s_GetMallStatusRequest clearDelegatesAndCancel];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initData];
        [self addViewReplaceTabBar];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabbar:) name:MAINTABBAR_ISHIDE_NOTIFICATION object:nil];
    }
    return self;
}

- (void)initData
{
	self.btn_bg_imagelist =
    [[NSMutableArray alloc] initWithObjects:
      @"home",
      @"comment",
      @"special",
      @"tool",
      @"personal",
      nil
      ];
    
	self.btn_highlightbg_imagelist =
    [[NSMutableArray alloc] initWithObjects:
      @"home_pressed",
      @"comment_pressed",
      @"special_pressed",
      @"tool_pressed",
      @"personal_pressed",
      nil
      ];
    
//    self.btn_selectbg_imagelist =
//                        [[[NSMutableArray alloc] initWithObjects:
//                        @"mtab_btn_selected",
//                        @"mtab_btn_selected",
//                        @"mtab_btn_selected",
//                        @"mtab_btn_selected",
//                        nil
//                        ] autorelease];
    
	self.tab_textlist =
    [[NSMutableArray alloc] initWithObjects:
      NAVIGATION_TITLE1,
      NAVIGATION_TITLE2,
      NAVIGATION_TITLE3,
      NAVIGATION_TITLE4,
      NAVIGATION_TITLE5,
      nil];
}

// 隐藏原来的tabbar
- (void)hideOriginTabBar
{
	for(UIView *t_view in self.tabBar.subviews)
    {
        // 不隐藏自定义的tabbar 其余都匿藏
        if (![t_view isKindOfClass:[UIImageView class]])
        {
            t_view.hidden = YES;
        }
	}
    
    // 设置自定义的高度
    self.tabBar.frame = CGRectMake(0, UI_SCREEN_HEIGHT-UI_TAB_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_TAB_BAR_HEIGHT);
    UIView * transitionView = [[self.view subviews] objectAtIndex:0];
    
    // 设置VC.View高度
    transitionView.frame = CGRectMake(transitionView.frame.origin.x, transitionView.frame.origin.y, transitionView.frame.size.width, UI_SCREEN_HEIGHT-UI_TAB_BAR_HEIGHT);
}

#pragma mark -
#pragma mark addViewControllers

// 一次性添加所有VC
- (void)addViewControllers
{
//    [self showSinaFollowView];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//    
//    if (IOS_VERSION >= 7.0)
//    {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    }

    if (self.viewControllers.count > 0)
    {
        return;
    }
    
    BBMainPage *viewController1 = [[BBMainPage alloc]initWithNibName:@"BBMainPage" bundle:nil];
    [viewController1.navigationController setNavigationBarHidden:NO animated:NO];
    BBCustomNavigationController *navController1 = [[BBCustomNavigationController alloc] initWithRootViewController:viewController1];
    [navController1 setColorWithImageName:@"navigationBg"];
//    navController1.delegate = self;
    viewController1.title = NAVIGATION_TITLE1;
    
    HMMoreCircleVC *viewController2 = [[HMMoreCircleVC alloc] init];
    [viewController2.navigationController setNavigationBarHidden:NO animated:NO];
    BBCustomNavigationController *navController2 = [[BBCustomNavigationController alloc] initWithRootViewController:viewController2];
    [navController2 setColorWithImageName:@"navigationBg"];
    viewController2.title = NAVIGATION_TITLE2;
    
    BBSupportTopicDetail *viewController3 = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
//    [viewController3 setLoadURL:[NSString stringWithFormat:@"%@/app/flashsale/#!/",BABYTREE_URL_SERVER]];
//    [viewController3 setLoadURL:@"http://172.16.102.185/testWebJs.html?a=/app/flashsale/"];
    [viewController3 setLoadURL:BABYTREE_MALL_SERVER];
    viewController3.isShowCloseButton = NO;
    [viewController3.navigationController setNavigationBarHidden:NO animated:NO];
    BBCustomNavigationController *navController3 = [[BBCustomNavigationController alloc] initWithRootViewController:viewController3];
    [navController3 setColorWithImageName:@"navigationBg"];
    viewController3.title = NAVIGATION_TITLE3;
    
    
    BBToolsNewVC *viewController4 = [[BBToolsNewVC alloc] initWithNibName:@"BBToolsNewVC" bundle:nil];
    [viewController4.navigationController setNavigationBarHidden:NO animated:NO];//    viewController4.isSelfCenter = YES;
//    viewController4.title = [HMUser getNickname];
//    viewController4.isTabVC = YES;
    [viewController4.navigationController setNavigationBarHidden:NO animated:NO];
    BBCustomNavigationController *navController4 = [[BBCustomNavigationController alloc] initWithRootViewController:viewController4];
    [navController4 setColorWithImageName:@"navigationBg"];
    viewController4.title = NAVIGATION_TITLE4;
    
    BBPersonalViewController *viewController5 = [[BBPersonalViewController alloc] initWithNibName:@"BBPersonalViewController" bundle:nil];
    viewController5.isToolBar = YES;
    viewController5.hidesBottomBarWhenPushed = NO;
    [viewController5.navigationController setNavigationBarHidden:NO animated:NO];
    BBCustomNavigationController *navController5 = [[BBCustomNavigationController alloc] initWithRootViewController:viewController5];
    [navController5 setColorWithImageName:@"navigationBg"];
    viewController5.title = NAVIGATION_TITLE5;
    
    self.viewControllers = [NSArray arrayWithObjects:navController1, navController2, navController3, navController4,navController5, nil];
    
    numberOfItems = [self.viewControllers count];
    
    for (NSInteger i = 0; i< numberOfItems; i++)
    {
        //初始化每个tab的点标显示状态
        BOOL isShow = [BBUser getTabbarStatusForIndex:i];
        if (isShow)
        {
            [self showTipPointWithIndex:i];
        }
        else
        {
            [self hideTipPointWithIndex:i];
        }
    }
    
    [self hideOriginTabBar];
    [self selectedTabWithIndex:0];
}

// 根据索引找到VC
- (UIViewController *)getViewControllerAtIndex:(NSInteger)index
{
    NSArray *array = [self viewControllers];
    
    UINavigationController *navCtl = (UINavigationController *)[array objectAtIndex:index];
    if (navCtl == nil)
    {
        return nil;
    }
    
    NSArray *carray = navCtl.viewControllers;
    if (carray.count == 0)
    {
        return nil;
    }
    
    UIViewController *vc = [carray objectAtIndex:0];
    return vc;
}

// 设置某个VC隐藏
- (void)setViewControllersHide:(BOOL)hide atIndex:(NSInteger)index
{
    int oldNumber = numberOfItems;
    int newNumber = (hide == YES)? oldNumber-1 : oldNumber+1;
    if (newNumber > TABBAR_MAX_ITEM)
    {
        return;
    }
    
    // 刷新tabbar
    for (int i=0; i<[tab_itemlist count]; i++)
    {
        BBTabBarItemView *item = (BBTabBarItemView *)[tab_itemlist objectAtIndex:i];
        if (i == index)
        {
            item.hidden = hide;
        }
        
        int newLocation = i;
        
        if (i>index && hide)
        {
            newLocation -= 1;
        }
        
        CGRect rect = CGRectMake(320/newNumber * newLocation, 0, 320/newNumber, UI_TAB_BAR_HEIGHT);
        item.frame = rect;
    }
    
    numberOfItems = newNumber;
}

// 添加模拟的TabBar
- (void)addViewReplaceTabBar
{
    // 设置背景图
	self.m_TabBarBgView = [[UIImageView alloc] initWithFrame:self.tabBar.bounds];
    UIImage *originImage = [UIImage imageNamed:@"mtab_bg"];
    m_TabBarBgView.image = [originImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 2, 5, 2)];
    [m_TabBarBgView setUserInteractionEnabled:YES];
    
    // 添加Item
    self.tab_itemlist = [NSMutableArray arrayWithCapacity:0];
	int tab_Count = self.btn_bg_imagelist.count;
	for (int i=0; i<tab_Count; i++)
	{
        CGRect rect = CGRectMake(320/tab_Count * i, 0, 320/tab_Count, UI_TAB_BAR_HEIGHT);
        
        BBTabBarItemView *item = [[BBTabBarItemView alloc] initWithFrame:rect];
        
        item.exclusiveTouch = YES;

        [item addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        
        [item addTarget:self action:@selector(cancleSelectTab:) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchCancel];
        
        [item setNormalImageName:[btn_bg_imagelist          objectAtIndex:i]
              highLightImageName:[btn_highlightbg_imagelist objectAtIndex:i]
               selectedImageName:[btn_selectbg_imagelist    objectAtIndex:i]];
        item.m_titleLable.text = [tab_textlist              objectAtIndex:i] ;
        
        item.tag = ITEM_TAG_START+i;
        [tab_itemlist addObject:item];
        [m_TabBarBgView addSubview:item];
        
        if (i == 0)
        {
            // 默认选中第一个VC
            [item setSelected:YES];
        }
    }
    
    [self.tabBar addSubview:m_TabBarBgView];
    
    self.tabBar.backgroundColor = [UIColor clearColor];
}

// 所有的item恢复为未选中状态
- (void)unselectedTab:(BBTabBarItemView *)view
{
    for (int i = 0; i < tab_itemlist.count; i++)
	{
        [[tab_itemlist objectAtIndex:i] setSelected:NO];
    }
}

- (void)selectedTabWithIndex:(NSInteger)index
{
    BBTabBarItemView *view =[tab_itemlist objectAtIndex:index];
    [self selectedTab:view];
}

// 选中某个item
- (void)selectedTab:(BBTabBarItemView *)view
{
    int newIndex = view.tag-ITEM_TAG_START;
//    if (newIndex == 4) {
//        if (![BBUser isLogin]) {
//            BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
//            login.delegate = self;
//            login.m_LoginType = BBPresentLogin;
//            BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
//            [navCtrl setColorWithImageName:@"navigationBg"];
//            [self  presentViewController:navCtrl animated:YES completion:^{
//                
//            }];
//            return;
//        }
//    }
    
    [self unselectedTab:view];
    [view setSelected:YES];
    
    switch (newIndex) {
        case 0:
            [self mobclickLabel:@"底部tab-首页"];
            break;
        case 1:
            [self mobclickLabel:@"底部tab-圈子"];
            break;
        case 2:
            [self mobclickLabel:@"底部tab-特卖"];
            break;
        case 3:
            [self mobclickLabel:@"底部tab-工具"];
            break;
        case 4:
            [self mobclickLabel:@"底部tab-我"];
            break;
        default:
            break;
    }
    
    if ((view.tag-ITEM_TAG_START == self.selectedIndex) && self.selectedIndex==0 )
    {
        if (!isNotFirst)
        {
            isNotFirst = YES;
        }
        else
        {
            // 第一个tab是可以重新点击代表刷新操作
            if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
            {
                [self.delegate tabBarController:self didSelectViewController:[self.viewControllers objectAtIndex:self.selectedIndex]];
            }
        }
    }
    
    self.selectedIndex = newIndex;
    [self hideTipPointWithIndex:newIndex];
    
    if (newIndex == 0)
    {
        //切到首页，去获取工具页更新消息
        [self checkToolListUpdate];
        //切到首页，去获取特卖点标状态
        [self checkMallStatus];
    }
    else if (newIndex == 3)
    {
        //切到工具页把本次获取的请求cancel掉
        [self.s_GetToolsListRequest clearDelegatesAndCancel];
        
    }
    else if (newIndex == 4)
    {
        //切到特卖页cancel掉请求
        [self.s_GetMallStatusRequest clearDelegatesAndCancel];
    }
    UINavigationController *nav = [self.viewControllers objectAtIndex:newIndex];
    if ([nav.viewControllers count]>1)
    {
        [nav popToRootViewControllerAnimated:NO];
    }

}

-(void)showTabbar:(NSNotification*)notify
{
    NSDictionary *dic = notify.userInfo;
    if([dic isNotEmpty])
    {
        if ([dic boolForKey:@"show"]) {
            self.tabBar.hidden = ![dic boolForKey:@"show"];
            self.tabBar.frame = CGRectMake(0, UI_SCREEN_HEIGHT-UI_TAB_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_TAB_BAR_HEIGHT);
            UIView * transitionView = [[self.view subviews] objectAtIndex:0];
            
            // 设置VC.View高度
            transitionView.frame = CGRectMake(transitionView.frame.origin.x, transitionView.frame.origin.y, transitionView.frame.size.width, UI_SCREEN_HEIGHT-UI_TAB_BAR_HEIGHT);
//            [UIView animateWithDuration:0.5
//                                  delay:0
//                                options:UIViewAnimationOptionCurveEaseOut animations:^(void){
//                                    self.tabBar.alpha = 1.0;
//                                }completion:^(BOOL finished){
//                                    self.tabBar.hidden = ![dic boolForKey:@"show"];
//                                }];
        }else{
            [UIView animateWithDuration:0.4
                                  delay:0
                                options:UIViewAnimationOptionShowHideTransitionViews animations:^(void){
                                    self.tabBar.alpha = 0.0;
                                }completion:^(BOOL finished){
                                    self.tabBar.hidden = ![dic boolForKey:@"show"];
                                    self.tabBar.alpha = 1.0;
                                    self.tabBar.frame = CGRectMake(0, UI_SCREEN_HEIGHT-UI_TAB_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_TAB_BAR_HEIGHT);
                                    UIView * transitionView = [[self.view subviews] objectAtIndex:0];
                                    
                                    // 设置VC.View高度
                                    transitionView.frame = CGRectMake(transitionView.frame.origin.x, transitionView.frame.origin.y, transitionView.frame.size.width, UI_SCREEN_HEIGHT);
                                }];
        
        }
    }
}

-(void)mobclickLabel:(NSString*)label
{
    if ([BBUser getNewUserRoleState]==BBUserRoleStatePrepare)
    {
        [MobClick event:@"home_prepare_v2" label:label];
    }
    else if ([BBUser getNewUserRoleState]==BBUserRoleStatePregnant)
    {
        [MobClick event:@"home_pregnant_v2" label:label];
    }
    else
    {
        [MobClick event:@"home_baby_v2" label:label];
    }
}

- (void)cancleSelectTab:(BBTabBarItemView *)view
{
    if (self.selectedIndex != view.tag-ITEM_TAG_START)
    {
        [view setSelected:NO];
    }
}

- (void)backTopLeverView:(NSInteger)index
{
    NSArray *array = [self viewControllers];
    
    UINavigationController *navCtl = (UINavigationController *)[array objectAtIndex:index];
    if (navCtl == nil)
    {
        return;
    }
    
    [navCtl popToRootViewControllerAnimated:NO];
}

- (void)showTipPointWithIndex:(NSInteger)index
{
    [BBUser setTabbarIndex:index Status:YES];
    BBTabBarItemView *item =[tab_itemlist objectAtIndex:index];
    [item showTipPoint];
}

- (void)hideTipPointWithIndex:(NSInteger)index
{
    [BBUser setTabbarIndex:index Status:NO];
    BBTabBarItemView *item =[tab_itemlist objectAtIndex:index];
    [item hideTipPoint];
}

- (BOOL)getTipPointStateWithIndex:(NSInteger)index
{
    BBTabBarItemView *item =[tab_itemlist objectAtIndex:index];
    return [item isTipShow];
}


#pragma mark- 检查特卖点标状态
/*
 字段 last_ts ："1243124313" 或 “0”
 返回字段 new_ts :"13412431243"  表示服务器当前时间的时间戳
 has_new_item: "1"/"0" 有没有新的商品上架
 1. last_ts 传“0” has_new_item =1
 2.last_ts 传正常值 后台取地区（登录或未登录用户） 取不到地区认为没有 has_new_item=0
 取到地区的话正常判断
 */
-(void)checkMallStatus
{
    //根据last_ts进行查询
    [self.s_GetMallStatusRequest clearDelegatesAndCancel];
    NSString *lastTS = [BBUser getLastQueryMallStatusTS];
    self.s_GetMallStatusRequest  = [BBMainPageRequest getMallHasNewItemStatus:lastTS];
    [self.s_GetMallStatusRequest setDelegate:self];
    [self.s_GetMallStatusRequest setDidFailSelector:@selector(getMallStatusRequestFailed:)];
    [self.s_GetMallStatusRequest setDidFinishSelector:@selector(getMallStatusRequestFinished:)];
    [self.s_GetMallStatusRequest startAsynchronous];
}

- (void)getMallStatusRequestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *responseData = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[responseData stringForKey:@"status"] isEqualToString:@"success"])
    {
        //如果有更新 显示点标
        NSDictionary *data = [responseData dictionaryForKey:@"data"];
        if ([data isDictionaryAndNotEmpty])
        {
            NSString *hasNewItem = [data stringForKey:@"has_new_item"];
            if ([hasNewItem isNotEmpty] && [hasNewItem isEqualToString:@"1"])
            {
                [self showTipPointWithIndex:MAIN_TAB_INDEX_MALL];
            }
            
            NSString *lastTS = [data stringForKey:@"new_ts"];
            
            //同时更新本地ts
            [BBUser setLastQueryMallStatusTS:lastTS];
        }
    }
}

- (void)getMallStatusRequestFailed:(ASIFormDataRequest *)request
{
    //请求失败不改变点标状态
}
#pragma mark- 检查工具页是否更新

-(void)checkToolListUpdate
{
    NSDictionary *localActionDataDict = [BBToolOpreation getToolActionDataOfType:ToolPageTypeTool];
    self.s_HasReadFromPlist = [localActionDataDict boolForKey:@"from_plist"];
    
    [self.s_GetToolsListRequest clearDelegatesAndCancel];
    self.s_GetToolsListRequest  = [BBToolsRequest getToolsListRequest:@"toolpage"];
    [self.s_GetToolsListRequest setDelegate:self];
    [self.s_GetToolsListRequest setDidFailSelector:@selector(getToolsListRequestFailed:)];
    [self.s_GetToolsListRequest setDidFinishSelector:@selector(getToolsListRequestFinished:)];
    [self.s_GetToolsListRequest startAsynchronous];
}

- (void)getToolsListRequestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *responseData = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[responseData stringForKey:@"status"] isEqualToString:@"success"])
    {
        //数据返回
        NSDictionary *nData = [responseData dictionaryForKey:@"data"];
        NSArray *nTempArray = [nData arrayForKey:@"tool_list"];
        if (nTempArray == nil || [nTempArray count] == 0)
        {
            return;
        }
        
        NSDictionary *oldData = [BBToolOpreation getToolActionDataOfType:ToolPageTypeTool];
        NSArray *oldTempArray = [oldData arrayForKey:@"tool_list"];
        NSArray *nArray = [BBToolOpreation getCurrentVersionSupportedToolsArray:nTempArray];
        NSArray *oldArray = [BBToolOpreation getCurrentVersionSupportedToolsArray:oldTempArray];
        if(![nArray isEqualToArray:oldArray])
        {
            if (!self.s_HasReadFromPlist)
            {
                //如果是从默认布局读取的列表，也就是说从没进入过工具页，那么新读取的列表，即便和旧的不一致也不会显示红点
                if([BBToolOpreation compareOldTools:oldArray withNewTools:nArray])
                {
                    [self showTipPointWithIndex:MAIN_TAB_INDEX_TOOLPAGE];
                }
            }
        }
        [BBToolOpreation setToolActionData:nData ofType:ToolPageTypeTool];
    }
    else
    {
        //[AlertUtil showAlert:@"提示！" withMessage:@"亲，您的网络不给力！"];
    }
}

- (void)getToolsListRequestFailed:(ASIFormDataRequest *)request
{
    //[AlertUtil showAlert:@"提示！" withMessage:@"亲，您的网络不给力！"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma login delegate
//
//-(void)loginFinish
//{
//    if (tab_itemlist > 0)
//    {
//        //进入个人中心
//        BBTabBarItemView *item =[tab_itemlist objectAtIndex:[tab_itemlist count]-1];
//        [self selectedTab:item];
//    }
//}

@end
