//
//  HMReplyTopicView.h
//  lama
//
//  Created by songxf on 13-7-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiInputView.h"
#import "BBAppDelegate.h"
#import "ASIFormDataRequest+BBDebug.h"
#import "BBConfigureAPI.h"

#define REAL_INTERFACE_HEIGHT 144

// 是否开启回复帖子输入表情功能  0关闭 1开启
#if COMMON_USE_EMOJI
#define REPLY_OPEN_EMOJI 1
#else
#define REPLY_OPEN_EMOJI 0
#endif

@protocol HMReplyTopicDelegate <NSObject>

@required

- (NSString *)topicFromGroupId;


@optional
- (void)didReplySuccess:(NSDictionary *)data;
- (void)refreshAboutAddCircleStatus;

@end


@interface HMReplyTopicView : UIView
<
    UITextViewDelegate,
    UIAlertViewDelegate,
    UIActionSheetDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    EmojiInputViewDelegate,
    BBLoginDelegate
>
{
    BOOL isEmojiInput;
    BOOL isReplyMaster;
}

// 记忆楼层及内容
@property (nonatomic, retain) NSString *m_cacheFloorNumber;
// 记忆回复楼主的内容
@property (nonatomic, retain) NSString *m_cacheContent;
// 缓存图片数据
@property (nonatomic,strong)  NSData *m_cacheImageData;
@property (nonatomic, retain) UITextView *contentTextView;

@property (nonatomic, retain) NSString *topicID;
@property (nonatomic, retain) NSString *referID;
@property (nonatomic, retain) NSString *groupId;
@property (nonatomic, assign) BOOL isJoin;
//YES 表示从专家在线来源的帖子
@property (assign) BOOL m_IsFromExpertOnline;

@property (nonatomic, assign) id<HMReplyTopicDelegate> delegate;

// 关闭与隐藏
- (void)hide;

// floor = 0 表示回复楼主
- (void)showWithFloor:(NSString *)floor referID:(NSString *)referId isJoin:(BOOL)join groupId:(NSString *)gId;

- (void)showWithFloor:(NSString *)floor referID:(NSString *)referId isJoin:(BOOL)join groupId:(NSString *)gId floorName:(NSString *)name;

// 是否有对楼主的回复缓存  帖子页返回时候判断是不是提示放弃
- (BOOL)isAnyReplyCached;

- (void)closeView;

@end




