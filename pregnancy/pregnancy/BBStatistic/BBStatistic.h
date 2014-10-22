//
//  BBStatistic.h
//  pregnancy
//
//  Created by liumiao on 8/28/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BABYTREE_TYPE_TOPIC_HOME_RECOMMEND @"2001" //首页宝宝树推荐
#define BABYTREE_TYPE_TOPIC_RECOMMEND_MORE @"2002" //首页的宝宝树推荐模块-更多
#define BABYTREE_TYPE_TOPIC_GROUP @"2003" //圈子每个圈子的帖子列表
#define BABYTREE_TYPE_TOPIC_REPLY @"2004" //个人中心发表回复列表
#define BABYTREE_TYPE_TOPIC_KNOWLEDGE @"2005" //每日知识的推荐
#define BABYTREE_TYPE_TOPIC_EXPERT @"2006" //专家在线进入
#define BABYTREE_TYPE_TOPIC_MESSAGE @"2007" //通知列表跳转
#define BABYTREE_TYPE_TOPIC_CHAT @"2008" //私信内容带链接跳转
#define BABYTREE_TYPE_TOPIC_HOME_AD @"2009" //首页头图
#define BABYTREE_TYPE_TOPIC_SCHEME @"2010" //scheme跳转
#define BABYTREE_TYPE_TOPIC_PUSH @"2011" //push
#define BABYTREE_TYPE_TOPIC_IN_TOPIC @"2012" //帖子内容带跳转
#define BABYTREE_TYPE_TOPIC_SCAN @"2013" //扫二维码
#define BABYTREE_TYPE_TOPIC_SEARCH @"2014" //搜索帖子列表
#define BABYTREE_TYPE_TOPIC_RECOMMEND_IN_TOPIC @"2015" //帖子详情中的推荐位
#define BABYTREE_TYPE_TOPIC_USER_EVENT @"2016" //动态列表
#define BABYTREE_TYPE_TOPIC_DOCTOR @"2017" //医生讨论点击帖子
#define BABYTREE_TYPE_TOPIC_HOSPITAL_INFO @"2018" //医院建档贴点击
#define BABYTREE_TYPE_TOPIC_FAVIRATE @"2019" //我的收藏帖子点击
#define BABYTREE_TYPE_TOPIC_RECENTLY @"2020" //最近浏览记录打开帖子
#define BABYTREE_TYPE_TOPIC_SIGN @"2021" //签到弹框打开帖子

@interface BBStatistic : NSObject


+ (BBStatistic*)sharedInstance;

/**
 *  埋点统计方法
 *
 *  @param contentType 埋点的内容类型，必须
 *  @param contentId   对应埋点类型的id，必须
 */
+ (void)visitType:(NSString*)contentType contentId:(NSString*)contentId;

/**
 *  埋点统计方法
 *
 *  @param contentType 埋点的内容类型，必须
 *  @param contentId   对应埋点类型的id，必须
 *  @param date        埋点时间戳对应日期，默认为当前时刻,非必须
 */
+ (void)visitType:(NSString*)contentType contentId:(NSString*)contentId date:(NSDate*)date;

- (void)sendStatisticData;

@end
