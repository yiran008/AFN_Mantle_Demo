//
//  HMApiRequest.h
//  lama
//
//  Created by mac on 14-4-21.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONKit.h"
#import "ASIFormDataRequest+BBDebug.h"
#import "BBUser.h"
#import "BBConfigureAPI.h"

@interface HMApiRequest : NSObject

typedef NS_ENUM(NSInteger, HM_AD_Source)
{
    // 力美
    HM_AD_LIMEI,
    // 百度
    HM_AD_BAIDU
};

typedef NS_ENUM(NSInteger, POPLISTROW)
{
    POPLIST_LASTREPLY = 0,
    POPLIST_NEWEST,
    POPLIST_ONLYGOOD,
    POPLIST_ONLYCITY
};


#define THIRD_PART_LOGIN_SINA @"1"
#define THIRD_PART_LOGIN_TENCENT @"2"

#define DEFAULT_PUSHTOKEN_LAMA @"u1591872179_5d683f29950827bd702728288de7aa26_1337249944"

@end


#pragma mark -
#pragma mark Circle

@interface HMApiRequest (HMCircleRequest)

// 分类的更多圈子
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/更多圈（辣妈V2.0版）
+ (ASIFormDataRequest *)circleListwithStart:(NSInteger)page withClassId:(NSString *)theClassId;

// 某人已加入的圈子(我的圈子)
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/用户加入的圈子列表
+ (ASIFormDataRequest *)myCircleListwithStart:(NSInteger)page WithUserID:(NSString *)theUserID;

// 加入和退出推荐圈子
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/加入圈子
+ (ASIFormDataRequest *)addTheCircleWithGroupIDS:(NSString *)theGroupIDS andQuitGroups:(NSString *)quitStr;

// 加入圈子
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/加入圈子
+ (ASIFormDataRequest *)addTheCircleWithGroupID:(NSString *)theGroupID;

// 退出圈子
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/退出圈子
+ (ASIFormDataRequest *)quitTheCircleWithGroupID:(NSString *)theGroupID;

// 圈子置顶
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/圈子置顶（辣妈V2.0版）
+ (ASIFormDataRequest *)setCircleTop:(NSString *)theGroupID;

// 获取圈子管理员
+ (ASIFormDataRequest *)setCircleAdminList:(NSString *)groupID;

// 获取圈子排行列表
+ (ASIFormDataRequest *)setCircleTopMemberList:(NSString *)groupID;

// 获取圈子距离近列表
+ (ASIFormDataRequest *)setCircleDisMemberList:(NSString *)groupID;

// 获取圈子同孕龄列表
+ (ASIFormDataRequest *)setCircleAgeMemberList:(NSString *)groupID;

@end


#pragma mark -
#pragma mark Topic

@interface HMApiRequest (HMTopicRequest)

// 喜欢
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/赞帖
+ (ASIFormDataRequest *)lovetTopicWithID:(NSString *)topicId;

// 关注辣妈话题
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/移动/关注、信息流/Http-API/获取关注用户的话题
//+ (ASIFormDataRequest *)focusMomTopicListwithStart:(NSInteger)page withEndTime:(NSString *)theEndTime;

// 进入某个圈的话题列表
//+ (ASIFormDataRequest *)theCircleTopicListwithStart:(NSInteger)page withGroupID:(NSString *)theGroupID withTypeOfTopic:(NSInteger)theTypeOfTopic;

// 进入某个圈的话题列表- 返回数据为文字形式或者是图片形式
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/获取圈子数据列表_瀑布流图片或帖子
//+ (ASIFormDataRequest *)theCircleTopicListTextOrPicwithStart:(NSInteger)page withGroupID:(NSString *)theGroupID withTypeOfTopic:(NSInteger)theTypeOfTopic withGettype:(NSInteger)theGettype;

// 进入某个圈的话题列表
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/获取圈子帖子列表（辣妈v1.2版）
+ (ASIFormDataRequest *)theCircleTopicListwithStart:(NSInteger)page withGroupID:(NSString *)theGroupID listType:(NSInteger)theTypeOfTopic defaultType:(NSInteger)theDefaultType;

// 活动数据
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/移动/Http-API/获取精彩活动列表
//+ (ASIFormDataRequest *)huodongRequestWithStatr:(NSInteger)start limit:(NSInteger)limit;

// 加精话题
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/移动/Http-API/获取精华热帖列表(辣妈v2.0)
//+ (ASIFormDataRequest *)eliteTopicRequesWithStart:(NSInteger)start limit:(NSInteger)limit;

// 发现
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/移动/Http-API/发现页接口(辣妈v2.0)
//+ (ASIFormDataRequest *)discoverReques;

// 辣妈达人
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/移动/推荐/Http-API/辣妈达人
//+ (ASIFormDataRequest *)getLamaDarenData:(NSInteger)page;

@end


#pragma mark -
#pragma mark Topic detail

@interface HMApiRequest (HMTopicDetailRequest)

// 请求帖子详情内容
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/帖子详情
//+ (ASIFormDataRequest *)requestNewTopicDetail:(NSString *)topicID withCurentPage:(NSString*)page withIsUserType:(NSString *)isType;
+ (ASIFormDataRequest *)requestNewTopicDetail:(NSString *)topicID withCurentPage:(NSString*)page orReplyId:(NSString *) replyId withIsUserType:(NSString *)isType;
 
// 从孕期移植的举报
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/其他/Http-API/举报
+ (ASIFormDataRequest *)reportSendRequest:(NSString *)topicId withReplyId:(NSString *)replyID withReportType:(NSString*)reportType;

// 收藏
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/取消、收藏帖子（V2）
+ (ASIFormDataRequest *)collectTopicAction:(BOOL)theBool withTopicID:(NSString *)topicID;

// 删除主贴
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/删除帖子
+ (ASIFormDataRequest *)delTopicAction:(NSString *)topicID;
// 删除自己的回复
+ (ASIFormDataRequest *)delMyReply:(NSString *)replyID;

@end


#pragma mark -
#pragma mark Create topic

@interface HMApiRequest (HMCreateTopicRequest)

// 新建话题
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/发表帖子（支持emoji表情）
+ (ASIFormDataRequest *)createTopicWithLoginString:(NSString *)loginString gourpID:(NSString *)groupID title:(NSString *)title content:(NSString *)content photoIDList:(NSString *)photoIDList is_question:(BOOL)is_question;

// 回复帖子或楼层
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/回复帖子（不支持emoji表情）
+ (ASIFormDataRequest *)replyTopicNewWithLoginString:(NSString *)theLoginString withTopicID:(NSString *)theTopicID withContent:(NSString *)theContent withPhotoData:(NSData *)imageData withPosition:(NSString *)position withReferID:(NSString *)referID;

// 回复帖子或楼层Emoji数据
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/回复帖子（支持emoji表情）
+ (ASIFormDataRequest *)replyTopicWithLoginString:(NSString *)theLoginString withTopicID:(NSString *)theTopicID withContentArray:(NSString *)contentString withPhotoData:(NSData *)imageData withPosition:(NSString *)position withReferID:(NSString *)referID;

// 上传一张照片
// http://s1.babytree.com/wiki/宝宝树开发文档/产品/论坛/Http-API/上传照片
+ (ASIFormDataRequest *)uploadPhoto:(NSData *)imageData withLoginString:(NSString *)loginString;

@end
