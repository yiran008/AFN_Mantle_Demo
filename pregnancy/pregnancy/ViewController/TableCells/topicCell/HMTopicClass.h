//
//  HMTopicCellClass.h
//  lama
//
//  Created by mac on 13-12-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>



#define TOPIC_CELL_TITLE_TWOLINE_HEIGHT     50.0f
#define TOPIC_CELL_TITLE_ONELINE_HEIGHT     32.0f


typedef NS_OPTIONS(NSInteger, HMTopicMark)
{
    TopicMark_NONE = 0,
    TopicMark_Top = 1 << 0,
    TopicMark_New = 1 << 1,
    TopicMark_Extractive = 1 << 2,
    TopicMark_Help = 1 << 3,
    TopicMark_HasPic = 1 << 4
};


@interface HMTopicClass : NSObject

// 标签
@property (nonatomic, assign) HMTopicMark m_Mark;


// 话题ID
@property (nonatomic, retain) NSString *m_TopicId;

// 标题
@property (nonatomic, retain) NSString *m_Title;
// 摘要
@property (nonatomic, retain) NSString *m_Summary;

// 图片数组
@property (nonatomic, retain) NSMutableArray *m_PicArray;
// 图片显示区域大小
@property (nonatomic, assign) CGFloat m_ImageHeight;
@property (nonatomic, assign) CGFloat m_ImageWidth;
// 图片本身大小
@property (nonatomic, assign) CGFloat m_PicHeight;
@property (nonatomic, assign) CGFloat m_PicWidth;

// 圈子ID
@property (nonatomic, retain) NSString *m_CircleId;
// 圈子名称
@property (nonatomic, retain) NSString *m_CircleName;
// 隐私圈子
@property (nonatomic, assign) BOOL m_CircleIsPrivate;

// 楼主Id
@property (nonatomic, retain) NSString *m_MasterId;
// 楼主昵称
@property (nonatomic, retain) NSString *m_MasterName;
// 楼主头像
@property (nonatomic, retain) NSString *m_MasterImage;
// 楼主等级
@property (nonatomic, assign) NSInteger m_MasterLevel;

// 回复数
@property (nonatomic, assign) NSInteger m_ResponseCount;
// 创建时间
@property (nonatomic, assign) NSInteger m_CreateTime;
// 修改时间
//@property (nonatomic, assign) NSInteger m_UpdateTime;
// 最后回复时间
@property (nonatomic, assign) NSInteger m_ResponseTime;

// 赞次数
@property (nonatomic, assign) NSInteger m_PraiseCount;
// 是否赞过
@property (nonatomic, assign) BOOL m_IsPraised;


// 收藏
@property (nonatomic, assign) BOOL m_IsFavourite;

// 个人回复列表用回复楼层
@property (nonatomic, assign) NSInteger m_Floor;
@property (nonatomic, strong) NSString *m_ReplyID;

// title行数
@property (nonatomic, assign) NSInteger m_TitleLines;
// summary行数
@property (nonatomic, assign) NSInteger m_SummaryLines;

// 显示圈子
@property (nonatomic, assign) BOOL m_ShowCircle;
// 无图模式
@property (nonatomic, assign) BOOL m_IsPicType;

// 有图高
@property (nonatomic, assign, readonly) CGFloat m_CellHeight;
// 无图高
@property (nonatomic, assign, readonly) CGFloat m_CellShortHeight;

// 标题高亮处理
@property (nonatomic, retain) NSAttributedString *m_TitleAttribut;
@property (nonatomic, retain) NSArray *m_TitleArr;

// 用户徽章
@property (nonatomic, strong) NSString *m_UserSign;


- (void)calcHeight;

@end
