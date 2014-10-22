//
//  BBTopicListView.h
//  pregnancy
//
//  Created by babytree babytree on 12-4-1.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTopicCallBack.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshPullUpTableHeaderView.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "BBRefreshSetImageBg.h"
#import "BBTopicDetailDelegate.h"
#import "HMCircleTopicHeaderView.h"

typedef enum{
    retryBtonTypeNetworkFailed,
    retryBtonTypeError
}retryBtonType;

typedef enum {
    GroupList
} ListType;

typedef enum {
    LastReply,
    LastPublish,
    LicoriceTopic
} ListSort;

@interface BBTopicListView : UIView<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,EGORefreshPullUpTableHeaderDelegate,UIAlertViewDelegate,BBTopicDetailDelegate,HMCircleTopicHeaderViewDelegate>{
    UITableView *tableView ;
    EGORefreshTableHeaderView *_refresh_header_view; 
    BOOL _reloading; 
    EGORefreshPullUpTableHeaderView *_refresh_pull_up_header_view;
    BOOL _pull_up_reloading;
    NSMutableArray *groupData;
    NSInteger loadedTotalCount;
    NSInteger listTotalCount;
    MBProgressHUD *hud;
    ASIFormDataRequest *requests;
    NSString *groupId;
    NSInteger page;
    ListType listType;
    ListSort listSort;
    id area;
    id<RefreshTopicCallBack> refreshTopicCallBackHandler;
    NSString *tagContent;
    NSString *userEncodeId;
    NSInteger pergMonth;
    NSString *headViewTitle;
    
    BOOL isElite;
     id<BBRefreshSetImageBg> refreshSetImageBg;
    UIViewController *viewCtrl;
}

@property (nonatomic, strong) HMCircleTopicHeaderView *m_HeaderView;

@property (nonatomic, strong) UITableView *tableView ;
@property (nonatomic, strong) NSMutableArray *groupData;
@property (nonatomic, strong) NSMutableArray *dingTopicArray;
@property (assign) NSInteger loadedTotalCount;
@property (assign) NSInteger listTotalCount;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) ASIFormDataRequest *requests;
@property (nonatomic,strong) NSString *groupId;
@property (assign) NSInteger page;
@property (assign) ListType listType;
@property (assign) ListSort listSort;
@property (nonatomic,strong) id area;
@property (assign) id<RefreshTopicCallBack> refreshTopicCallBackHandler;
@property (nonatomic,strong)NSString *tagContent;
@property (nonatomic,strong)NSString *userEncodeId;
@property (nonatomic,assign)NSInteger pergMonth;
@property (nonatomic,strong)NSString *headViewTitle;
@property (nonatomic, assign) BOOL isElite;
@property (assign) id<BBRefreshSetImageBg> refreshSetImageBg;
@property (assign) UIViewController *viewCtrl;
//指定同龄圈模式使用
@property (nonatomic,retain)NSString * pregnancyYearAndMoth;
//无网加载失败重新加载按钮
@property (nonatomic,retain)UIButton * retryButton;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)reloadPullUpTableViewDataSource;
- (void)doneLoadingPullUpTableViewData;

- (void)loadNextPageData;
- (void)reloadData;
- (void)reloadDataFinished:(ASIHTTPRequest *)request;
- (void)reloadDataFail:(ASIHTTPRequest *)request;
- (void)nextLoadDataFinished:(ASIHTTPRequest *)request;
- (void)nextLoadDataFail:(ASIHTTPRequest *)request;

- (void)refresh;
- (void)addTopicRefresh;
- (void)setSectionTitleIsShow:(BOOL)isShow withSectionTitle:(NSString *)sectionTitle;
+(NSMutableArray *)filterRepeatObjectByAddAraay:(NSArray *) addArray withOriginArray:(NSMutableArray *)originArray;
@end
