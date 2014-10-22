//
//  HMRecommendVC.h
//  lama
//
//  Created by songxf on 13-6-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "Recommend_EGORefreshPullUpTableHeaderView.h"
#import "Recommend_EGORefreshTableHeaderView.h"
#import "ASIFormDataRequest+BBDebug.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "HMRecommendDayCell.h"

#define NUMBER_LOAD_EVERYTIME 2


@interface HMRecommendVC : BaseViewController
<
    UITableViewDelegate,
    UITableViewDataSource,
    Recommend_EGORefreshTableHeaderDelegate,
    Recommend_EGORefreshPullUpTableHeaderDelegate
>
{
    BOOL isUpLoad;
    BOOL _reloading;
    CGFloat dayRowHeight;
    BOOL _pull_up_reloading;
    Recommend_EGORefreshTableHeaderView *_refresh_header_view;
    Recommend_EGORefreshPullUpTableHeaderView *_refresh_pull_up_header_view;
}

// 需要新加载的数据
@property(nonatomic, strong) NSMutableArray *dataArrToAdd;

// 网络请求
@property (nonatomic, retain) ASIFormDataRequest *dataRequest;

// 可显示出来的推荐内容数据
@property(nonatomic, strong) NSMutableArray *r_data;

// 显示推荐的table
@property (retain, nonatomic) UITableView *r_table;

// 网络等待
@property (nonatomic, strong) MBProgressHUD *hud;


@end
