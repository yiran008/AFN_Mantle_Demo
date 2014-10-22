//
//  HMTableViewController.h
//  lama
//
//  Created by songxf on 13-12-20.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "EGORefreshPullUpTableHeaderView.h"
#import "ASIFormDataRequest+BBDebug.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "HMNoDataView.h"

#import "HMRefreshTableHeaderView.h"

#define TABLE_EACH_LOAD_COUNT 20

typedef NS_OPTIONS(NSInteger, EGORefreshType)
{
    EGORefreshType_NONE = 0,
    EGORefreshType_Head = 1 << 0 ,
    EGORefreshType_Bottom = 1 << 1
};


@interface HMTableViewController : BaseViewController
<
    HMNoDataViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    HMRefreshTableHeaderViewDelegate,
    EGORefreshPullUpTableHeaderDelegate
>
{
    // 当前页
    NSInteger s_LoadedPage;
    // 备份当前页，用于发请求
    NSInteger s_BakLoadedPage;
    // 服务器应答总数量
    NSInteger s_LoadedTotalCount;
    // 每次应获取最大数量
    NSInteger s_EachLoadCount;
    BOOL s_CanLoadNextPage;

    BOOL _header_reloading;
    HMRefreshTableHeaderView *_refresh_header_view;

    BOOL _bottom_reloading;
    EGORefreshPullUpTableHeaderView *_refresh_bottom_view;

    BOOL _isRollTopicData;
}

// 上拉下拉类型
@property (nonatomic, assign) EGORefreshType m_RefreshType;

// 网络请求
@property (nonatomic, retain) ASIFormDataRequest *m_DataRequest;
// 可显示出来的推荐内容数据
@property(nonatomic, retain) NSMutableArray *m_Data;
// 显示推荐的table
@property (nonatomic, retain) UITableView *m_Table;
// 网络等待
@property (nonatomic, retain) MBProgressHUD *m_ProgressHUD;

@property (nonatomic, retain) HMNoDataView *m_NoDataView;

// 将等待和错误提示等上移
- (void)bringSomeViewToFront;
// 模拟下拉效果
- (void)rollFreshData;

- (void)doneLoadingPullUpTableViewData;
- (void)doneLoadingTableViewData;
- (void)hideEGORefreshView;

// 检测是否是最后一页了
- (void)checkIsLastPage;

// 刷新数据
- (void)freshData;
// 获取下一页
- (void)loadNextData;

@end
