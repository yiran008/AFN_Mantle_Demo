//
//  HMTopicDetailVC.h
//  lama
//
//  Created by songxf on 13-12-25.
//  Copyright (c) 2013年 babytree. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "EmojiLabel.h"
#import "HMTopicDetailCellDelegate.h"
#import "EGORefreshPullUpTableHeaderView.h"
#import "EGORefreshTableHeaderView.h"
#import "HMTopicDetailBottomView.h"
#import "HMReplyTopicView.h"
#import "BBShareMenu.h"
#import "HMNoDataView.h"
#import "BBStatistic.h"

@interface HMTopicDetailVC : BaseViewController
<
    UITableViewDataSource,
    UITableViewDelegate,
    UIActionSheetDelegate,
    UIAlertViewDelegate,
    HMTopicDetailCellDelegate,
    EGORefreshTableHeaderDelegate,
    EGORefreshPullUpTableHeaderDelegate,
    HMTDBottomViewDelegate,
    HMReplyTopicDelegate,
    HMNoDataViewDelegate,
    ShareMenuDelegate
//    HMStoreEvaluateViewDelegate
>
{
    //控制上拉下拉效果
    EGORefreshTableHeaderView *s_refresh_header_view;
    BOOL s_reloading;
    EGORefreshPullUpTableHeaderView *s_refresh_bottom_view;
    BOOL s_bottom_reloading;
        
    BOOL s_isRollTopicData;
    
    HMTopicDetailCellClass *s_DetailData;
    
    BOOL s_ShowTypeSwitch;
    HMNoDataView *s_NoDataView;
    
//    HMStoreEvaluateView *s_StoreEvaluateView;
    
    // 是否跳楼层
    BOOL s_PositionToFloor;
}

@property (retain, nonatomic) IBOutlet UITableView *m_TopicTableView;

@property (retain, nonatomic) IBOutlet UIView *m_TopicTitleView;
@property (retain, nonatomic) IBOutlet UIView *m_TopicTitleCircleBgView;
@property (retain, nonatomic) IBOutlet UILabel *m_TopicTitleCircleLabel;
@property (retain, nonatomic) IBOutlet UILabel *m_TopicViewCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *m_TopicReplyCountLabel;
@property (retain, nonatomic) IBOutlet UIControl *m_TopicTitleCircleControl;

@property (retain, nonatomic) IBOutlet UILabel *m_TopicTitleStyledLabel;
@property (retain, nonatomic) IBOutlet UIImageView *m_IsTopImageView;

@property (retain, nonatomic) IBOutlet UIImageView *m_IsNewImageView;
@property (retain, nonatomic) IBOutlet UIImageView *m_IsBestImageView;
@property (retain, nonatomic) IBOutlet UIImageView *m_IsHelpImageView;

@property (nonatomic, retain) MBProgressHUD *m_ProgressHUD;
@property (nonatomic, retain) ASIFormDataRequest *m_TopicDataRequest;
@property (nonatomic, retain) ASIFormDataRequest *m_DelTopicRequest;
@property (nonatomic, retain) ASIFormDataRequest *m_CollectTopicRequest;
//YES 表示从专家在线来源的帖子
@property (assign) BOOL m_IsFromExpertOnline;
// 帖子数据
@property (nonatomic, retain) NSMutableArray *m_TopicDataList;

// 图片列表
@property (nonatomic, retain) NSMutableArray *m_PicsList;


// 显示全部还是只显示楼主
@property (nonatomic, assign) BOOL m_IsShowAll;
// 收藏状态
@property (nonatomic, assign) BOOL m_IsCollected;
// 回复状态
@property (nonatomic, assign) BOOL m_IsReply;
// 回复楼层
@property (nonatomic, assign) NSInteger m_ReplyFloor;

// 当前页
@property (nonatomic, retain) NSString *m_CurrentPage;
// 总页数
@property (nonatomic, retain) NSString *m_PageCount;

// 帖子ID
@property (nonatomic, retain) NSString *m_TopicID;
// 帖子标题
@property (nonatomic, retain) NSString *m_TopicTitle;
// 帖子摘要
@property (nonatomic, retain) NSString *m_summary;

// 帖子浏览次数
@property (nonatomic, retain) NSString *m_ViewCount;
// 帖子回复次数
@property (nonatomic, retain) NSString *m_ReplyCount;

// 圈子ID
@property (nonatomic, retain) NSString *m_CircleID;
// 圈子名称
@property (nonatomic, retain) NSString *m_CircleName;
// 是否加入圈子
@property (nonatomic, assign) BOOL m_AddCircleStatus;
// 楼主ID
@property (nonatomic, retain) NSString *m_MasterID;
@property (nonatomic, retain) NSString *m_MasterName;

// 置顶帖
@property (assign, nonatomic) BOOL m_IsTop;
// 今日新帖
@property (assign, nonatomic) BOOL m_IsNew;
// 求助
@property (assign, nonatomic) BOOL m_IsHelp;
// 精华
@property (assign, nonatomic) BOOL m_IsBest;

// URL for copy
@property (nonatomic, retain) NSString *m_WebUrl;
// URL for share
@property (nonatomic, retain) NSString *m_ShareUrl;

@property (nonatomic, strong) HMTopicDetailBottomView *m_BottomView;
@property (nonatomic, strong) HMReplyTopicView *m_ReplyView;

// 定位楼层
@property (assign, nonatomic) NSInteger m_PositionFloor;
// 定位楼层的回复ID
@property (retain, nonatomic) NSString *m_ReplyID;
@property (nonatomic, assign) BOOL m_ShowPositionError;

// 是否打开回复
@property (assign, nonatomic) BOOL isPopReply;
// 是否已经喜欢
@property (assign, nonatomic) BOOL m_IsLoved;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTopicID:(NSString *)topicID topicTitle:(NSString *)topicTitle isTop:(BOOL)isTop isBest:(BOOL)isBest;

- (void)scrollToFloor:(NSInteger)floor toLastRow:(BOOL)last;

- (IBAction)openCircle:(id)sender;

@end

