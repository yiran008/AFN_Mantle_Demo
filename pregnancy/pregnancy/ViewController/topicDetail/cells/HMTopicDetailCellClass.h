//
//  HMTopicDetailCellClass.h
//  lama
//
//  Created by mac on 13-7-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

// 帖子详情正文的字体
#define TOPIC_CONTENT_TEXT_FONT [UIFont systemFontOfSize:16.0f]
// 帖子详情边距
#define TOPIC_ALL_EDGE_DISTANCE 12

#define TOPICDETAILCELL_GAP                     12.0f

#define TOPICDETAILCELLTOPVIEW_HEIGHT           50.0f
#define TOPICDETAILCELLFLOORVIEW_HEIGHT         44.0f
#define TOPICDETAILCELLFLOOR_AD_HEIGHT           76.f
#define TOPICDETAILCELLFLOOR_AD_WIDTH           298.f
#define TOPICDETAILCELLFLOOR_AD_EDGE              7.f

#define TOPICDETAILCELL_IMAGE_DEFAULTWIDTH      250.0f
#define TOPICDETAILCELL_IMAGE_DEFAULTHEIGHT     250.0f

#define TOPICDETAILCELL_IMAGE_MAXWIDTH          288.0f
#define TOPICDETAILCELL_IMAGE_MAXHEIGHT         288.0f

#define TOPICDETAILCELL_TEXTLINKBTN_HEIGHT      30.0f

typedef enum
{
    TOPICDETAILCELL_NONE_TYPE = 0,
    TOPICDETAILCELL_MASTERHEADER_TYPE = 1,
    TOPICDETAILCELL_REPLYHEADER_TYPE,
    TOPICDETAILCELL_REPLYCONTENT_TYPE,
    TOPICDETAILCELL_TEXTCONTENT_TYPE,
    TOPICDETAILCELL_IMAGECONTENT_TYPE,
    TOPICDETAILCELL_TEXTLINK_TYPE,
    TOPICDETAILCELL_IMAGELINK_TYPE,
    TOPICDETAILCELL_MASTERFLOOR_TYPE,
    TOPICDETAILCELL_REPLYFLOOR_TYPE,
    TOPICDETAILCELL_EMOJI_TYPE        = 100,
    TOPICDETAILCELL_FACE_TYPE
} HMTopicDetailCell_Type;

typedef enum
{
    HMTopicDetailCellView_LinkType_None = 0,
    HMTopicDetailCellView_LinkType_Message,
    HMTopicDetailCellView_LinkType_Out
} HMTopicDetailCell_LinkType;

@class HMNewTopicInfor;
@class HMNewReplyInfor;

@interface HMTopicDetailCellClass : NSObject

// 数据类型
@property (nonatomic, assign) HMTopicDetailCell_Type m_Type;

// 高度
@property (nonatomic, assign) CGFloat m_Height;

// 帖子基本信息
@property (nonatomic, retain) HMNewTopicInfor *m_TopicInfor;


// TOPICDETAILCELL_MASTERFLOOR_TYPE
// TOPICDETAILCELL_REPLYFLOOR_TYPE
@property (nonatomic, retain) NSString *m_LocalCity;
@property (nonatomic, retain) NSString *m_PublishTime;


// TOPICDETAILCELL_REPLYCONTENT_TYPE
@property (nonatomic, retain) HMNewReplyInfor *m_ReplyInfor;

// for link
// 链接类型
@property (nonatomic, assign) HMTopicDetailCell_LinkType m_LinkType;
// 链接BTN
@property (nonatomic, assign) BOOL m_LinkUseBtn;
// 链接地址
@property (retain, nonatomic) NSString *m_LinkUrl;
// 链接帖子ID
@property (retain, nonatomic) NSString *m_LinkTopicId;


// TOPICDETAILCELL_TEXTCONTENT_TYPE
// TOPICDETAILCELL_TEXTLINK_TYPE
@property (nonatomic, retain) NSString *m_Text;
@property (nonatomic, retain) NSArray *m_ELabelDataArray;


// TOPICDETAILCELL_IMAGECONTENT_TYPE
// TOPICDETAILCELL_IMAGELINK_TYPE
@property (nonatomic, retain) NSString *m_PreImageUrl;
@property (nonatomic, retain) NSString *m_ImageUrl;
// 多图预览的图片位置
@property (nonatomic, assign) NSInteger m_ImageIndex;
@property (nonatomic, assign) CGFloat m_ImageHeight;
@property (nonatomic, assign) CGFloat m_ImageWidth;

//帖子详情广告相关参数
//广告来源
@property (nonatomic, retain) NSString *m_adStatus;
//广告联盟来源
@property (nonatomic, retain) NSString *m_adUnion;
//广告图片地址
@property (nonatomic, retain) NSString *m_adImg;
//广告跳转地址
@property (nonatomic, retain) NSString *m_adUrl;
//广告检测链接
@property (nonatomic, retain) NSString *m_adMonitor;
//广告 ID
@property (nonatomic, retain) NSString *m_adBannerid;
//广告位 ID
@property (nonatomic, retain) NSString *m_adZoneid;
//广告位 Title
@property (nonatomic, retain) NSString *m_adTitle;

+ (NSString *)getImageHeight:(NSDictionary *)imageLinkDic;
+ (NSString *)getImageWidth:(NSDictionary *)imageLinkDic;

- (id)initWithData:(NSDictionary *)dic topicInfor:(HMNewTopicInfor *)topicInfor masterID:(NSString *)masterID;

// TOPICDETAILCELL_REPLYCONTENT_TYPE
- (id)initWithData:(NSDictionary *)dic topicInfor:(HMNewTopicInfor *)topicInfor masterID:(NSString *)masterID replyInfor:(HMNewReplyInfor *)replyInfor;

- (void)makeData:(NSDictionary *)dic masterID:(NSString *)masterID;


- (void)calcTextHeight;

@end


/*
 同一楼帖子共用 帖子基本信息
 */
@interface HMNewTopicInfor : NSObject

// 是否楼主
@property (nonatomic, assign) BOOL m_IsMaster;
// 是否是管理员
@property (nonatomic, assign) BOOL m_IsAdmin;

// ID(楼主/回复人)
@property (nonatomic, retain) NSString *m_UserId;
// 用户昵称
@property (nonatomic, retain) NSString *m_UserName;
// 用户头像
@property (nonatomic, retain) NSString *m_UserIcon;
// 宝宝生日
@property (nonatomic, retain) NSString *m_BabyAge;

// 楼层
@property (nonatomic, retain) NSString *m_Floor;

// 帖子全部文本内容
@property (nonatomic, retain) NSString *m_ContentText;

// 回复ID
@property (nonatomic, retain) NSString *m_ReplyID;

// 是否已经喜欢
@property (assign, nonatomic) BOOL m_IsLoved;
@property (assign, nonatomic) NSInteger totalLoveTime;

@property (nonatomic, strong) NSString *m_UserSign;


@end


/*
 原回复的帖子信息
 */
@interface HMNewReplyInfor : NSObject

// 原帖楼层
@property (nonatomic, retain) NSString *m_Position;

// 原帖回复人ID
@property (nonatomic, retain) NSString *m_UserId;

// 原帖回复人昵称
@property (nonatomic, retain) NSString *m_UserName;
// 原帖回复人头像
@property (nonatomic, retain) NSString *m_UserIcon;

// 原帖回复文本内容
@property (nonatomic, retain) NSString *m_ContentText;

// 是否有图
@property (nonatomic, assign) BOOL m_HavePic;

// YES:显示全部  NO:最多2行
@property (nonatomic, assign) BOOL m_ShowAll;

@end

