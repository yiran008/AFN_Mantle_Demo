//
//  BBKonwlegdeDB.h
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBKonwlegdeModel.h"

#define KNOWLEDGE_ALLKEYS @"knowledgeallkeys"

#define KNOWLEDGE_DB_NAME (@"knowledge_5_1_0")

#define KNOWLEDGE_DB_FILE_NAME [NSString stringWithFormat:@"%@%@",KNOWLEDGE_DB_NAME,@".db"]

#define KNOWLEDGE_DB_DIR_NAME @"KnowledgeDir"
@interface BBKonwlegdeDB : NSObject

//获得某一天的知识
+ (BBKonwlegdeModel *)knowledgeInDays;

//通过ID获取知识
+ (BBKonwlegdeModel *)knowledgeByID:(NSString *)ID;

//获得某一天的关爱提醒数据
+ (BBKonwlegdeModel *)remindRecordOfDay;

//获得某一天的发育
+ (BBKonwlegdeModel *)babyGrowthRecordOfDay;

//通过天数获取一定天数的关爱提醒
+ (NSArray *)someRecentRemindsOfCurDay:(NSInteger)theDay;

//通过天数获取一定数量的指定天数之前的提醒
+ (NSArray *)somePriorRemindsOfDay:(NSInteger)theDay;

//通过天数获取一定数量的指定天数之后的提醒
+ (NSArray *)someLaterRemindsOfDay:(NSInteger)theDay;

//通过天数获取一定天数的宝宝发育
+ (NSArray *)someRecentBabyGrowthOfCurDay:(NSInteger)theDay;

//通过天数获取一定数量的指定天数之前的宝宝发育
+ (NSArray *)somePriorGrowthOfDay:(NSInteger)theDay;

//通过天数获取一定数量的指定天数之后的宝宝发育
+ (NSArray *)someLaterGrowthOfDay:(NSInteger)theDay;

//更新知识库
+ (BOOL)upDataKnowledgeData:(NSArray *)arr;

//获得所有的知识的标题数据
+ (NSMutableArray *)allKonwledgeTabsData;

//获取所有的提醒
+ (NSMutableArray *)allReminds;

//获取所有宝宝发育
+ (NSMutableArray *)allBabyGrowth;

//获取所有的知识库数据
+ (NSDictionary *)allKonwledgeLibData;

//根据天数获得某一天的发育
+ (BBKonwlegdeModel *)babyGrowthRecord:(NSInteger)days;

//孕期用户获取每孕周第一天的关爱提醒 育儿用户获取宝宝每周第一天的关爱提醒
+ (NSMutableArray*)allLocalReminds;

+ (NSString *)getKnowledgeTS;

+ (BOOL)setKnownledgeTS:(NSString *)ts;

+ (BOOL)isDBConnectionGood;
@end
