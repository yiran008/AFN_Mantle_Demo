//
//  BBKnowlegeViewController.m
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBKnowlegeViewController.h"
#import "BBKonwlegdeDB.h"
#import "BBKownledgeWebView.h"
#import "BBKnowledgeRequest.h"
#import "ASIHTTPRequest.h"
#import "BBWebViewController.h"
#import "BBShareContent.h"
#import "SDImageCache.h"
#import "BBSupportTopicDetail.h"
#import "HMTopicDetailVC.h"
#import "HMShowPage.h"

#define KNOWLEDGE_TAB_HEIGHT 41

@interface BBKnowlegeViewController ()<ViewPagerDataSource,ViewPagerDelegate,ShareMenuDelegate,BBLoginDelegate,BBAdTapDelegate>

@property(nonatomic,strong)NSMutableArray *tabsData;
@property(nonatomic,strong)NSString *curID;
@property(nonatomic,strong)ASIHTTPRequest *collectRequest;
@property(nonatomic,strong)ASIHTTPRequest *fecthCollectRequest;
@property(nonatomic,assign)BOOL isCurCollect;
@property(nonatomic,strong)UIButton *collectButton;
@property(nonatomic,strong)MBProgressHUD *saveDueProgress;

@end

@implementation BBKnowlegeViewController

- (void)dealloc
{
    [_collectRequest clearDelegatesAndCancel];
    [_fecthCollectRequest clearDelegatesAndCancel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.days = [BBPregnancyInfo daysOfPregnancy];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //由于基类初始化的需要，下面初始化数据的地方要写到viewdidload前面
    self.delegate = self;
    self.dataSource = self;
    
    if (self.m_CurVCType == KnowlegdeVCKnowlegde)
    {
        self.tabsData = [BBKonwlegdeDB allKonwledgeTabsData];
    }
    else
    {
        self.tabsData = [BBKonwlegdeDB allReminds];
    }
    
    //基类执行其余数据和ui的操作。
    [super viewDidLoad];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.exclusiveTouch = YES;
    [leftButton setFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectButton setFrame:CGRectMake(0, 0, 40, 30)];
    [self.collectButton setImage:[UIImage imageNamed:self.isCurCollect ?@"collected_icon" : @"collect_icon"] forState:UIControlStateNormal];
    [self.collectButton setImage:[UIImage imageNamed:@"collect_icon_pressed"] forState:UIControlStateHighlighted];
    [self.collectButton addTarget:self action:@selector(doCollect) forControlEvents:UIControlEventTouchUpInside];
    self.collectButton.exclusiveTouch = YES;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.exclusiveTouch = YES;
    [shareButton setFrame:CGRectMake(0, 0, 40, 30)];
    [shareButton setImage:[UIImage imageNamed:@"shareBarButton"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"shareBarButtonPressed"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareTopicClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.collectButton];
    UIBarButtonItem *shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    
    //关爱提醒没有收藏
    if (self.m_CurVCType == KnowlegdeVCKnowlegde)
    {
        [MobClick event:@"knowledge_daily_v2" label:@"知识详情页pv"];
        [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"每日知识" withWidth:(([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?180:150)]];
        self.navigationItem.rightBarButtonItems = @[commitBarButton,shareBarButton];
    }
    else
    {
        [MobClick event:@"knowledge_remind_v2" label:@"访问用户数"];
        [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"关爱提醒" withWidth:(([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?180:150)]];
        self.navigationItem.rightBarButtonItems = @[shareBarButton];
    }
    
    self.saveDueProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.saveDueProgress];
}

- (void)leftButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    return self.tabsData.count;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    UIView * aTab = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, KNOWLEDGE_TAB_HEIGHT)];
    
    return aTab;
}

- (BBKonwlegdeModel *)viewPager:(ViewPagerController *)viewPager dataForTabAtIndex:(NSUInteger)index
{
    return [self.tabsData objectAtIndex:index];
}

//- (UIView *)viewPager:(ViewPagerController *)viewPager contentViewForTabAtIndex:(NSUInteger)index
//{
//    BBKonwlegdeModel * model = [self.tabsData objectAtIndex:index];
//    BBKonwlegdeModel * knowledge = [BBKonwlegdeDB knowledgeByID:model.ID];
//
//    BBKownledgeWebView *web = [[BBKownledgeWebView alloc]initWithFrame:CGRectMake(0, KNOWLEDGE_TAB_HEIGHT,self.view.frame.size.width , self.view.frame.size.height - KNOWLEDGE_TAB_HEIGHT)htmlStr:knowledge.content imagesStr:knowledge.imgArrStr];
//    return web;
//}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    BBWebViewController * vc = [[BBWebViewController alloc]initWithNibName:@"BBWebViewController" bundle:nil];
    BBKonwlegdeModel * model = [self.tabsData objectAtIndex:index];
    BBKonwlegdeModel * knowledge = [BBKonwlegdeDB knowledgeByID:model.ID];
    
    vc.htmlStr = knowledge.content;
    vc.imagesStr = knowledge.imgArrStr;
    vc.ID = knowledge.ID;
    vc.delegate = self;
    return vc;
}

- (int)indexForTabWithViewPager:(ViewPagerController *)viewPager
{
    __block int index = 0;
    
    if (self.startID)
    {
        [self.tabsData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            BBKonwlegdeModel * data = obj;
            if (data.ID && [data.ID isEqualToString:self.startID])
            {
                index = idx;
                *stop = YES;
            }
        }];
    }
    return index;
}

-(void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    if (self.m_CurVCType == KnowlegdeVCKnowlegde)
    {
        [self.collectButton setImage:[UIImage imageNamed:@"collect_icon"] forState:UIControlStateNormal];

        [self fecthCollectStatus];
    }
}

//属性覆盖,获取当前页面的ID
- (NSString *)curID
{
    if (self.tabsData)
    {
        if (self.activeTabIndex < self.tabsData.count)
        {
            BBKonwlegdeModel * model = [self.tabsData objectAtIndex:self.activeTabIndex];
            return model.ID;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark ShareMenuDelegate
-(void)shareTopicClicked
{
    // 分享给好友
    if (self.m_CurVCType == KnowlegdeVCKnowlegde)
    {
        [MobClick event:@"knowledge_daily_v2" label:@"分享"];
    }
    else
    {
        [MobClick event:@"knowledge_remind_v2" label:@"分享点击"];
    }
    BBShareMenu *menu = [[BBShareMenu alloc] initWithType:2 title:@"分享"];
    menu.delegate = self;
    [menu show];
}

//点击分享帖子
- (void)shareMenu:(BBShareMenu *)shareMenu clickItem:(BBShareMenuItem *)item
{
    BBKonwlegdeModel *obj = [BBKonwlegdeDB knowledgeByID:self.curID];
    if (obj)
    {
        UIImage *img = nil;
        if (obj.imgArrStr)
        {
            NSArray *imageArray = [NSJSONSerialization JSONObjectWithData:[obj.imgArrStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if ([imageArray isNotEmpty])
            {
                NSDictionary *imageDict = [imageArray firstObject];
                NSString * url = [imageDict stringForKey:@"big_src"];
                if (url && url.length)
                {
                    img = [[SDImageCache sharedImageCache]imageFromKey:url];
                }
            }
        }
        
        [BBShareContent shareContent:item withViewController:self withShareText:[NSString stringWithFormat:@"【%@】%@",obj.title?obj.title:@"",obj.description?obj.description:@""] withShareOriginImage:img withShareWXTimelineTitle:obj.title withShareWXTimelineDescription:@"" withShareWXSessionTitle:obj.title withShareWXSessionDescription:obj.description withShareWebPageUrl:[NSString stringWithFormat:@"http://m.babytree.com/knowledge/detail.php?kid=%@",obj.ID]];
    }
}

- (void)doCollect
{
    if([BBUser isLogin])
    {
        if (self.curID)
        {
            [MobClick event:@"knowledge_daily_v2" label:self.isCurCollect?@"取消收藏":@"收藏知识"];
            [self.collectRequest clearDelegatesAndCancel];
            self.collectRequest = [BBKnowledgeRequest collectKnowledgeWithID:self.curID isDelete:self.isCurCollect];
            [self.collectRequest setDidFinishSelector:@selector(collectFinished:)];
            [self.collectRequest setDidFailSelector:@selector(collectFailed:)];
            [self.collectRequest setDelegate:self];
            [self.collectRequest startAsynchronous];
            
            self.collectButton.userInteractionEnabled = NO;
        }
    }
    else
    {
        [MobClick event:@"knowledge_daily_v2" label:@"收藏知识"];
        BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
        login.m_LoginType = BBPresentLogin;
        BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
        [navCtrl setColorWithImageName:@"navigationBg"];
        login.delegate = self;
        [self.navigationController  presentViewController:navCtrl animated:YES completion:^{
            
        }];
    }

}

- (void)fecthCollectStatus
{
    if (self.curID)
    {
        [self.fecthCollectRequest clearDelegatesAndCancel];
        self.fecthCollectRequest = [BBKnowledgeRequest getCollectedWithID:self.curID];
        [self.fecthCollectRequest setDidFinishSelector:@selector(fecthCollectFinished:)];
        [self.fecthCollectRequest setDidFailSelector:@selector(fecthCollectFailed:)];
        [self.fecthCollectRequest setDelegate:self];
        [self.fecthCollectRequest startAsynchronous];
    }
}

#pragma mark -
#pragma mark httpDelegate
- (void)collectFinished:(ASIFormDataRequest *)request
{
    self.collectButton.userInteractionEnabled = YES;
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"])
    {
        self.isCurCollect = !self.isCurCollect;
        [self.collectButton setImage:[UIImage imageNamed:self.isCurCollect ?@"collected_icon" : @"collect_icon"] forState:UIControlStateNormal];
        [self.saveDueProgress setLabelText:self.isCurCollect? @"已收藏":@"取消收藏"];
        self.saveDueProgress.animationType = MBProgressHUDAnimationFade;
        self.saveDueProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        self.saveDueProgress.mode = MBProgressHUDModeCustomView;
        [self.saveDueProgress show:YES];
        [self.saveDueProgress hide:YES afterDelay:1];
    }
}

- (void)collectFailed:(ASIFormDataRequest *)request
{
    self.collectButton.userInteractionEnabled = YES;
    [self.saveDueProgress setLabelText:self.isCurCollect? @"取消收藏失败":@"收藏失败"];
    self.saveDueProgress.animationType = MBProgressHUDAnimationFade;
    self.saveDueProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xxx"]];
    self.saveDueProgress.mode = MBProgressHUDModeCustomView;
    [self.saveDueProgress show:YES];
    [self.saveDueProgress hide:YES afterDelay:1];
}

- (void)fecthCollectFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"])
    {
        BOOL isFavor = [[[data dictionaryForKey:@"data"]stringForKey:@"is_favorite"]isEqualToString:@"1"];
        self.isCurCollect = isFavor;
        [self.collectButton setImage:[UIImage imageNamed:self.isCurCollect ?@"collected_icon" : @"collect_icon"] forState:UIControlStateNormal];
    }
}

- (void)fecthCollectFailed:(ASIFormDataRequest *)request
{
    
}

- (void)loginFinish
{
    [self doCollect];
}

#pragma mark- AdTapDelegate
-(void)adAction:(NSString *)title withUrl:(NSString *)url
{
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    [exteriorURL.navigationItem setTitle:title];
    [exteriorURL setLoadURL:url];
    exteriorURL.isShowCloseButton = NO;
    [self.navigationController pushViewController:exteriorURL animated:YES];
}
- (void)topicInnerUrl:(NSString *)url
{
    if ([url hasPrefix:@"http://www.babytree.com/community/topic_mobile.php"]) {
        NSArray *pramsArray = [url componentsSeparatedByString:@"?"];
        NSArray *dataArray = nil;
        NSArray *tempArray = nil;
        if([pramsArray count]>1){
            dataArray= [[pramsArray objectAtIndex:1] componentsSeparatedByString:@"&"];
        }
        NSString *topicID = @"1";
        if([dataArray count]>0){
            tempArray = [[dataArray objectAtIndex:0] componentsSeparatedByString:@"="];
        }
        if([tempArray count]>1){
            topicID  = [tempArray objectAtIndex:1];
        }
        if (![topicID isNotEmpty])
        {
            return;
        }
        if (self.m_CurVCType == KnowlegdeVCKnowlegde)
        {
            [BBStatistic visitType:BABYTREE_TYPE_TOPIC_KNOWLEDGE contentId:topicID];
            [MobClick event:@"knowledge_daily_v2" label:@"帖子点击"];
        }
        else
        {
            [MobClick event:@"knowledge_remind_v2" label:@"帖子点击"];
        }
        
        [HMShowPage showTopicDetail:self topicId:topicID topicTitle:nil];
    } else {
        BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
        [exteriorURL.navigationItem setTitle:@"详情页"];
        [exteriorURL setLoadURL:url];
        exteriorURL.isShowCloseButton = NO;
        [self.navigationController pushViewController:exteriorURL animated:YES];
    }
}
@end
