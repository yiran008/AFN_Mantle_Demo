//
//  BBTopicHistoryDB.h
//  pregnancy
//
//  Created by liumiao on 9/2/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBBaseDB.h"

@interface BBTopicHistoryModel : NSObject

// 存储时间戳
@property (nonatomic, strong) NSString *m_AddTime;
// 帖子ID
@property (nonatomic, strong) NSString *m_TopicID;
// 浏览楼层
@property (nonatomic, assign) NSUInteger m_TopicFloor;
// 浏览楼层的ID
@property (nonatomic, strong) NSString *m_TopicFloorID;
// 是否只看楼主, NO:只看楼主
@property (nonatomic, assign) BOOL m_IsShowAll;
// 帖子标题
@property (nonatomic, strong) NSString *m_TopicTitle;
// 楼主ID
@property (nonatomic, strong) NSString *m_PosterID;
// 楼主名字
@property (nonatomic, strong) NSString *m_PosterName;

@end

@interface BBTopicHistoryDB : BBBaseDB

+ (NSArray *)topicHistoryModelArray;

+ (BOOL)deleteSpareTopicHistory;

+ (BOOL)clearTopicHistory;

+ (BOOL)insertTopicHistoryModel:(BBTopicHistoryModel *)historyModel;

@end
