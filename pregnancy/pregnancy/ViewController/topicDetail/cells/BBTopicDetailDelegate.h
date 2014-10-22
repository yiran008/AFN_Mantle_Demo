//
//  BBTopicDetailDelegate.h
//  pregnancy
//
//  Created by 王 鸿禄 on 13-5-29.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBTopicDetailDelegate <NSObject>

@optional
//回复了帖子
- (void)replyTopicFinish:(NSInteger)dataIndex;
//对帖子进行了收藏操作
- (void)collectTopicAction:(NSInteger)dataIndex withTopicID:(NSString *)topicID withCollectState:(BOOL)theBool;
//对帖子进行删除
- (void)deleteTopicFinish:(NSInteger)dataIndex;
//返回刷新话题列表
- (void)refreshCallBack;
//在帖子详情页加入此帖子对应的帮后对帮页面的相应操作
- (void)refreshAboutAddCircleStatus;
@end
