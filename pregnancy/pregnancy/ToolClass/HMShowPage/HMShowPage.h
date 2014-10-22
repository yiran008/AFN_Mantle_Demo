//
//  HMShowPage.h
//  lama
//
//  Created by babytree on 1/17/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMCircleClass.h"
#import "HMDraftBoxDB.h"

@interface HMShowPage : NSObject

// webview
+ (void)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title;
+ (void)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title showClose:(BOOL)showClose;
+ (void)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title showClose:(BOOL)showClose showBackAlter:(BOOL)showBackAlter alterMessage:(NSString *)alterMessage;

// 帖子详情页
+ (void)showTopicDetail:(UIViewController *)pushVC topicId:(NSString *)topicId topicTitle:(NSString *)topicTitle;
+ (void)showCollectedTopicDetail:(UIViewController *)pushVC topicId:(NSString *)topicId topicTitle:(NSString *)topicTitle;
+ (void)showTopicDetail:(UIViewController *)pushVC topicId:(NSString *)topicId topicTitle:(NSString *)topicTitle positionFloor:(NSInteger)positionFloor;
+ (void)showTopicDetail:(UIViewController *)pushVC topicId:(NSString *)topicId topicTitle:(NSString *)topicTitle replyID:(NSString *)replyID;
+ (void)showTopicDetail:(UIViewController *)pushVC topicId:(NSString *)topicId topicTitle:(NSString *)topicTitle replyID:(NSString *)replyID showError:(BOOL)showError;

// 更多圈
+ (void)showMoreCircle:(UIViewController *)pushVC categoryId:(NSString *)categoryId;
// 发现
+ (void)showDiscover:(UIViewController *)pushVC;
// 达人
+ (void)showDaren:(UIViewController *)pushVC;
// 个人中心
+ (void)showPersonalCenter:(UIViewController *)pushVC userEncodeId:(NSString *)userEncodeId;
+ (void)showPersonalCenter:(UIViewController *)pushVC userEncodeId:(NSString *)userEncodeId vcTitle:(NSString *)title;
+ (void)showPersonalCenter:(UIViewController *)pushVC listFollowType:(NSInteger)listFollowType userEncodeId:(NSString *)userEncodeId vcTitle:(NSString *)title;
// 精华
+ (void)showEliteTopic:(UIViewController *)pushVC;
// 活动
+ (void)showHuodong:(UIViewController *)pushVC;
// 圈子帖子
+ (void)showCircleTopic:(UIViewController *)pushVC circleId:(NSString *)circleId;
+ (void)showCircleTopic:(UIViewController *)pushVC circleClass:(HMCircleClass *)circleClass;
// 新建帖子
+ (void)showBabyBoxFeedBackTopic:(UIViewController *)pushVC;
+ (void)showCreateTopic:(UIViewController *)pushVC circleId:(NSString *)circleId;
+ (void)showCreateTopic:(UIViewController *)pushVC circleId:(NSString *)circleId  circleName:(NSString *)circleName;
+ (void)showCreateTopic:(UIViewController *)pushVC circleInfo:(HMCircleClass *)circleInfo;
+ (void)showCreateTopic:(UIViewController *)pushVC delegate:(id)delegate draft:(HMDraftBoxData *)draft;
// 显示图片
+ (void)showImageShow:(UIViewController *)pushVC delegate:(id)delegate iamges:(NSMutableArray *)images index:(NSInteger)index;
// 消息聊天
+ (void)showMessageChat:(UIViewController *)pushVC title:(NSString *)title userEncodeId:(NSString *)userEncodeId;
// 选择注册
+ (void)showSelectRegist:(UIViewController *)pushVC delegate:(id)delegate;
// 注册页
+ (void)showRegist:(UIViewController *)pushVC delegate:(id)delegate isRegist:(BOOL)isRegist;
// 医院页
+ (void)showUserInfoHospital:(UIViewController *)pushVC delegate:(id)delegate;

@end
