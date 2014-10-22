//
//  BBListView.h
//  pregnancy
//
//  Created by babytree babytree on 12-5-9.
//  Copyright (c) 2012年 babytree. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "RefreshTopicCallBack.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshPullUpTableHeaderView.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "BBListViewCellDelegate.h"
#import "BBListViewInfo.h"
#import "BBListViewDataDelegate.h"
#import "BBRefreshSetImageBg.h"
@interface BBListView : UIView<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,EGORefreshPullUpTableHeaderDelegate,BBListViewInfoDelegate>{
    UITableView *bbTableView;
    EGORefreshTableHeaderView *_refresh_header_view; 
    BOOL _reloading; 
    EGORefreshPullUpTableHeaderView *_refresh_pull_up_header_view;
    BOOL _pull_up_reloading;
    NSMutableArray *requestData;
    NSInteger loadedTotalCount;
    NSInteger listTotalCount;
    MBProgressHUD *hud;
    ASIFormDataRequest *requests;
    NSInteger page;
    id<BBListViewCellDelegate> listViewCellDelegate;
    BBListViewInfo *listViewInfo;
    id<BBListViewDataDelegate> listViewDataDelegate;
    id<BBRefreshSetImageBg> refreshSetImageBg;
    UIViewController *viewCtrl;
}

@property (nonatomic, strong) UITableView *bbTableView ;
@property (nonatomic, strong) NSMutableArray *requestData;
@property (assign) NSInteger loadedTotalCount;
@property (assign) NSInteger listTotalCount;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) ASIFormDataRequest *requests;
@property (assign) NSInteger page;
@property (assign) id<BBRefreshSetImageBg> refreshSetImageBg;
@property (assign) UIViewController *viewCtrl;
- (void)reloadTableViewDataSource; 
- (void)doneLoadingTableViewData;
- (void)reloadPullUpTableViewDataSource;
- (void)doneLoadingPullUpTableViewData;

- (void)reloadData;
- (void)reloadDataFinished:(ASIHTTPRequest *)request;
- (void)reloadDataFail:(ASIHTTPRequest *)request;
- (void)loadNextPageData;
- (void)nextLoadDataFinished:(ASIHTTPRequest *)request;
- (void)nextLoadDataFail:(ASIHTTPRequest *)request;

- (void)refresh;
- (void)addTopicRefresh;
- (id)initWithFrame:(CGRect)frame withBBListViewCellDelegate:(id<BBListViewCellDelegate>)bBListViewCellDelegate
withBBListViewData:(id)bBListViewContent;
@end