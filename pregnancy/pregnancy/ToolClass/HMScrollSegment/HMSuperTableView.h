//
//  HMTableView.h
//  lama
//
//  Created by jiangzhichao on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "EGORefreshPullUpTableHeaderView.h"
#import "ASIFormDataRequest+BBDebug.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "HMNoDataView.h"

#import "HMRefreshTableHeaderView.h"

#define HMTABLEVIEW_EACH_LOAD_COUNT 20
#define HMTABLEVIEW_TOTAL_LOAD_COUNT 2000

typedef NS_OPTIONS(NSInteger, HMRefreshType)
{
    HMRefreshType_NONE = 0,
    HMRefreshType_Head = 1 << 0 ,
    HMRefreshType_Bottom = 1 << 1
};

@interface HMSuperTableView : UIView
<
    HMNoDataViewDelegate,
    HMRefreshTableHeaderViewDelegate,
    EGORefreshPullUpTableHeaderDelegate
>
{
    BOOL _header_reloading;
    HMRefreshTableHeaderView *_refresh_header_view;
    
    BOOL _bottom_reloading;
    EGORefreshPullUpTableHeaderView *_refresh_bottom_view;
    
    BOOL _isRollTopicData;
}

- (id)initWithFrame:(CGRect)frame refreshType:(HMRefreshType)refreshType;

// 上拉下拉类型
@property (nonatomic, assign, readonly) HMRefreshType m_RefreshType;


// 当前页
@property (nonatomic, assign) NSInteger m_LoadedPage;
// 备份当前页，用于发请求
@property (nonatomic, assign) NSInteger m_BakLoadedPage;
// 服务器应答总数量
@property (nonatomic, assign) NSInteger m_LoadedTotalCount;
// 每次应获取最大数量
@property (nonatomic, assign) NSInteger m_EachLoadCount;
// 是否可以加载下一页
@property (nonatomic, assign) BOOL m_CanLoadNextPage;


// 可显示出来的推荐内容数据
@property(nonatomic, strong) NSMutableArray *m_Data;
// 显示推荐的table
@property (nonatomic, strong) UITableView *m_Table;

// 网络
@property (nonatomic, strong) ASIFormDataRequest *m_DataRequest;
@property (nonatomic, strong) MBProgressHUD *m_ProgressHUD;
@property (nonatomic, strong) HMNoDataView *m_NoDataView;

// 将等待和错误提示等上移
- (void)bringSomeViewToFront;
// 模拟下拉效果
- (void)rollFreshData;


// 检测是否是最后一页了
- (void)checkIsLastPage;

// 刷新数据
- (void)freshData;
// 获取下一页
- (void)loadNextData;
// reloadData
- (void)reloadTableData;
// 刷新或加载完数据，处理MBProgressHUD、HMNoDataView、刷新状态
- (void)doneLoadingData;

@end
