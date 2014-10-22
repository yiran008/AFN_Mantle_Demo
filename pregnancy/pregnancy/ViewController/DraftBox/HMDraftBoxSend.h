//
//  DraftBoxSend.h
//  DraftBox
//
//  Created by mac on 13-4-12.
//  Copyright (c) 2013年 DJ. All rights reserved.
//

#if COMMON_USE_DRATFBOX

#import <Foundation/Foundation.h>
#import "BBConfigureAPI.h"
#import "HMDraftBoxDB.h"


@protocol HMDraftBoxSendOneDelegate;

@interface HMDraftBoxSendOne : NSObject
{
    // stop
    BOOL s_IsStop;
}

@property (nonatomic, assign) id <HMDraftBoxSendOneDelegate> delegate;
// 草稿数据
@property (nonatomic, retain) HMDraftBoxData *m_DraftData;
// 当前发送图片index, <0发送文本
@property (nonatomic, assign) NSInteger m_PicIndex;

// 文字Request
@property (nonatomic, retain) ASIFormDataRequest *m_DataRequest;
// 图片Request
@property (nonatomic, retain) ASIFormDataRequest *m_ImageRequest;

// 状态
@property (nonatomic, readonly) HMDraftBoxSendStatus m_Status;
@property (nonatomic, readonly) BOOL m_IsRunning;

// 初始化
- (id)initWithData:(HMDraftBoxData *)draftData index:(NSInteger)index;

// 停止发送
- (void)stop;
// 启动发送
- (BOOL)send;

@end

@protocol HMDraftBoxSendOneDelegate <NSObject>

// 上传成功
- (void)draftBoxUploadOneSucceed:(HMDraftBoxData *)draftData atIndex:(NSInteger)index;
// 上传失败
- (void)draftBoxUploadOneFail:(HMDraftBoxData *)draftData atIndex:(NSInteger)index error:(NSString *)errorText;

@optional
// 图片上传进度
- (void)draftBoxUploadOnePicProgress:(HMDraftBoxData *)draftData atIndex:(NSInteger)index progress:(float)progress;


@end




@protocol HMDraftBoxSendDelegate;

@interface HMDraftBoxSend : NSObject
<
    HMDraftBoxSendOneDelegate
>

@property (nonatomic, assign) id <HMDraftBoxSendDelegate> delegate;

// 待发送草稿列表
@property (nonatomic, retain) NSMutableArray *m_DraftSendArray;
// 当前发送中数据
@property (nonatomic, retain) HMDraftBoxSendOne *m_DraftBoxSendOne;
// 当前发送图片index
@property (nonatomic, assign) NSInteger m_PicIndex;

- (void)prepareDraftBoxData:(NSString *)userId;
- (BOOL)sendWithDraftBoxData:(HMDraftBoxData *)draftData;

- (void)stop;

@end


@protocol HMDraftBoxSendDelegate <NSObject>

@optional
// 图片上传进度
- (void)draftBoxUploadPicProgress:(HMDraftBoxData *)draftData atIndex:(NSInteger)index progress:(float)progress;
// 上传成功
- (void)draftBoxSendSucceed:(HMDraftBoxData *)draftData atIndex:(NSInteger)index;
// 上传失败
- (void)draftBoxSendFail:(HMDraftBoxData *)draftData atIndex:(NSInteger)index error:(NSString *)errorText;


@end

#endif

