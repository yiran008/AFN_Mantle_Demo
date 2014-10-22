//
//  DraftBoxDB.h
//  DraftBox
//
//  Created by mac on 13-4-11.
//  Copyright (c) 2013年 DJ. All rights reserved.
//

#if COMMON_USE_DRATFBOX

#import <Foundation/Foundation.h>

#define DRAFTBOX_PICTURE_MAXCOUNT   9

typedef enum
{
    DraftBoxSendNoError = 0,
    DraftBoxSendPicFailed,
    DraftBoxSendTextFailed
} HMDraftBoxSendErrors;

typedef enum
{
    DraftBoxStatus_NotSend = 0,
    DraftBoxStatus_SendPicSucceed,
    DraftBoxStatus_SendTextSucceed,
} HMDraftBoxSendStatus;


typedef enum
{
    // 不同步
    HMTopicShareNone = 0,
    // 同步到新浪微博
    HMTopicShareSina = 1 << 0,
    // 同步到QQ空间
    HMTopicShareQzone = 1 << 1,
    // 同步到腾讯微博
    HMTopicShareTenc = 1 << 2
} HMTopicShareType;


@interface HMDraftBoxPic : NSObject

// photo_id (图片上传成功后赋值服务器返回的ID)
@property (nonatomic, retain) NSString *m_Photo_id;
// 图片数据 (图片上传成功后清空)
@property (nonatomic, retain) NSData *m_Photo_data;     // blob
// 是否已上传
@property (nonatomic, readonly) BOOL m_IsUpload;

@end


@interface HMDraftBoxData : NSObject

// 上传完成标志
@property (nonatomic, assign) BOOL m_IsSent;

// 保存草稿时间
@property (nonatomic, retain) NSDate *m_Timetmp;      // double
// 登陆用户id
@property (nonatomic, retain) NSString *m_UserId;
// 登陆用户token
//@property (nonatomic, retain) NSString *m_UserLogin_String;


// 发新帖

// 圈子ID
@property (nonatomic, retain) NSString *m_Group_id;
// 用于草稿编辑显示
@property (nonatomic, retain) NSString *m_GroupName;

// 帖子标题
@property (nonatomic, retain) NSString *m_Title;
// 帖子内容
@property (nonatomic, retain) NSString *m_Content;

// 求助
@property (nonatomic, assign) BOOL m_HelpMark;


// 回复贴

// reply回复标志
@property (nonatomic, assign) BOOL m_IsReply;
// 回复的帖子ID
@property (nonatomic, retain) NSString *m_Topic_id;
// 回复的楼层
@property (nonatomic, retain) NSString *m_Floor;
// 回复或者引用的回复ID
@property (nonatomic, retain) NSString *m_ReplyRefer_id;


// 状态
@property (nonatomic, assign) HMDraftBoxSendStatus m_SendStatus;


// 图片列表
@property (nonatomic, retain) NSMutableArray *m_PicArray;

// 同步类型
@property (nonatomic, assign) HMTopicShareType m_ShareType;
// 同步内容详情URL
@property (nonatomic, retain) NSString *m_ShareUrl;

@end


@interface HMDraftBoxDB : NSObject
// 初始化草稿
+ (BOOL)createDraftBoxDB;
// 插入草稿数据
+ (BOOL)insertDraftBoxDB:(HMDraftBoxData *)draftData;
// 修改草稿数据
+ (BOOL)modifyDraftBoxDB:(HMDraftBoxData *)draftData;
+ (BOOL)modifyDraftBoxDBText:(HMDraftBoxData *)draftData;
+ (BOOL)modifyDraftBoxDBAllPic:(HMDraftBoxData *)draftData;
+ (BOOL)modifyDraftBoxDBOnePic:(HMDraftBoxData *)draftData atindex:(NSInteger)index;
// 删除草稿数据
+ (BOOL)removeDraftBoxDB:(HMDraftBoxData *)draftData;
// 删除数据库 需要重新初始化
+ (BOOL)deleteDraftBoxDB;
// 清除已发送数据
+ (BOOL)clearDraftBoxDB;
+ (BOOL)clearDraftBoxDBSendingState;

// 设置发送成功
+ (BOOL)setDraftBoxDBSend:(HMDraftBoxData *)draftData;
+ (BOOL)setDraftBoxDBSend:(NSString *)userId withTime:(NSDate *)timetmp;

// 设置发送状态
+ (BOOL)setDraftBoxDB:(HMDraftBoxData *)draftData withStatus:(HMDraftBoxSendStatus)status;

// 设置发送中
+ (BOOL)setDraftBoxDB:(HMDraftBoxData *)draftData isSending:(BOOL)isSending;
+ (BOOL)setDraftBoxDB:(NSString *)userId withTime:(NSDate *)timetmp isSending:(BOOL)isSending;



// 获得数据列表
+ (NSArray *)getDraftBoxDBSendList:(NSString *)userId isSending:(BOOL)isSending;
+ (NSArray *)getDraftBoxDBSendList:(NSString *)userId;


@end

#endif

