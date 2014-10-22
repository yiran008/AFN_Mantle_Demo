//
//  BBTopicListView.h
//  pregnancy
//
//  Created by babytree babytree on 12-4-1.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordConfig.h"
#import "HMNoDataView.h"

@interface BBRecordMoonView : UIView
<
    UITableViewDelegate,
    UITableViewDataSource,
    EGORefreshTableHeaderDelegate,
    EGORefreshPullUpTableHeaderDelegate,
    HMNoDataViewDelegate
>
{
    
    EGORefreshTableHeaderView *_refresh_header_view; 
    BOOL _reloading; 
    EGORefreshPullUpTableHeaderView *_refresh_pull_up_header_view;
    BOOL _pull_up_reloading;
}

@property (nonatomic, strong) UITableView *tableView ;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) ASIFormDataRequest *requests;
@property (nonatomic,strong) NSString *lastTimeTs;
@property (nonatomic,strong) NSString *userEncodeId;
@property (assign) BOOL isUserRecord;
@property (nonatomic, retain) HMNoDataView *m_NoDataView;


- (void)reloadTableViewDataSource; 
- (void)doneLoadingTableViewData;
- (void)reloadPullUpTableViewDataSource;
- (void)doneLoadingPullUpTableViewData;

- (void)loadNextPageData;
- (void)reloadData;


- (void)refresh;
+(NSMutableArray *)filterObjectByAddAraay:(NSArray *) addArray withOriginArray:(NSMutableArray *)originArray;
@end
