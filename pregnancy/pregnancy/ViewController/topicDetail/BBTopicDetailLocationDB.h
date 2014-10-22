//
//  BBTopicDetailLocationDB.h
//  pregnancy
//
//  Created by whl on 13-8-20.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface BBTopicDetailLocation : NSObject

// 存储时间戳
@property (nonatomic, strong) NSString *m_AddTime;
// 帖子ID
@property (nonatomic, strong) NSString *m_Topic_ID;
// 浏览楼层
@property (nonatomic, assign) NSUInteger m_Topic_Floor;
@property (nonatomic, strong) NSString *m_Topic_FloorID;
// 是否只看楼主, NO:只看楼主
@property (nonatomic, assign) BOOL m_IsShowAll;

@end

@interface BBTopicDetailLocationDB : NSObject

// 删除数据库
+ (BOOL)deleteTopicDetalLocationDB;

// 创建数据库
+ (BOOL)createTopicDetalLocationDB;

// 重建数据库
+ (BOOL)reCreateTopicDetalLocationDB;

// 查询数据
+ (BBTopicDetailLocation *)getTopicDetailLocationDB:(NSString *)topic_id;

// 插入或者更新数据
+ (BOOL)insertAndUpdateTopicDetailLacationData:(BBTopicDetailLocation *)topicData;

// 删除最新的50条之前的所有数据
+ (BOOL)deleteSpareTopicDetailLacationData;

@end
