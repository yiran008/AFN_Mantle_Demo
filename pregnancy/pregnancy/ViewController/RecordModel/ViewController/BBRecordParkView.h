//
//  BBTopicListView.h
//  pregnancy
//
//  Created by babytree babytree on 12-4-1.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordConfig.h"

@interface BBRecordParkView : UIView<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,EGORefreshPullUpTableHeaderDelegate>{
    
    EGORefreshTableHeaderView *_refresh_header_view; 
    BOOL _reloading; 
    EGORefreshPullUpTableHeaderView *_refresh_pull_up_header_view;
    BOOL _pull_up_reloading;
    
}

@property (nonatomic, strong) UITableView *tableView ;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) ASIFormDataRequest *requests;


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
+(NSMutableArray *)filterObjectByAddAraay:(NSArray *) addArray withOriginArray:(NSMutableArray *)originArray;
@end
