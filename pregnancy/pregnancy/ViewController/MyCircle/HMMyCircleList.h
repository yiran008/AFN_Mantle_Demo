//
//  HMMyCircleList.h
//  BBHotMum
//
//  Created by songxf on 13-12-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMTableViewController.h"
#import "BBConfigureAPI.h"
//#import "HMTipView.h"
//#import "HMBannerView.h"
#import "HMMyCircleCell.h"

@interface HMMyCircleList : HMTableViewController
<
//    HMTipViewDelegate,
//    HMBannerViewDelegate,
    HMMyCircleCellDelegate
>
{
    // 首页标识
    BOOL s_IsMain;
    // 我的标识
    BOOL s_IsMine;
    // 是否显示Banner
    BOOL s_NeedBanner;
}
@property (nonatomic, retain) UIViewController *ContainerVC;
// 用户ID
@property (nonatomic, retain) NSString *m_UserID;

// Tip
//@property (nonatomic, retain) HMTipView *m_TipView;
@property (nonatomic, retain) ASIHTTPRequest *m_TipRequests;

// Banner
//@property (nonatomic, retain) HMBannerView *m_BannerView;
@property (nonatomic, retain) ASIHTTPRequest *m_BannerRequests;


// 置顶
@property (nonatomic, retain) ASIHTTPRequest *m_TopRequests;

// 领奖
@property (nonatomic, retain) ASIHTTPRequest *m_PrizeRequest;

@end
