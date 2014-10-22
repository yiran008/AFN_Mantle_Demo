//
//  BBKonwlegdeDB.m
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBKonwlegdeDB.h"
#import "FMDatabase.h"
#import "BBPregnancyInfo.h"
#import "BBUpdataRequest.h"

#define KNOWLEDGE_PRIOR_NUM 20
#define KNOWLEDGE_LATER_NUM 50
#define KNOWLEDGE_TOTAL_NUM (KNOWLEDGE_PRIOR_NUM + KNOWLEDGE_LATER_NUM)

@implementation BBKonwlegdeDB

+ (NSString *)KnowledgePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *sourceDirPath = [documentDirectory stringByAppendingPathComponent:KNOWLEDGE_DB_DIR_NAME];
    NSString *sourcePath = [sourceDirPath stringByAppendingPathComponent:KNOWLEDGE_DB_FILE_NAME];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:sourcePath];
    if (!isExist){
        sourcePath =[[NSBundle mainBundle] pathForResource:KNOWLEDGE_DB_NAME ofType:@".db"];
    }
    return sourcePath;
}

+ (BOOL)isDBConnectionGood
{
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
    BOOL dbConnectionGood = YES;
    if ([db open])
    {
        dbConnectionGood = [db goodConnection];
        [db close];
    }
    return dbConnectionGood;
}

+ (NSString *)checkNilValueForString:(NSString *)aString
{
    if (aString == nil) {
        return @"";
    }
    return aString;
}

+ (BBKonwlegdeModel *)creatLibObjectWithDBSet:(FMResultSet * )resultSet
{
    BBKonwlegdeModel * obj = [[BBKonwlegdeModel alloc]init];
    obj.ID = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"id"]];
    obj.title = [resultSet stringForColumn:@"title"];
    obj.category = [resultSet stringForColumn:@"category"];
    obj.imgArrStr = [resultSet stringForColumn:@"images"];
    return obj;
}

+ (BBKonwlegdeModel *)creatKnowledgeTabObjectWithDBSet:(FMResultSet * )resultSet
{
    BBKonwlegdeModel * obj = [[BBKonwlegdeModel alloc]init];
    obj.ID = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"id"]];
    obj.days = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"day_num"]];
    obj.period = [resultSet intForColumn:@"age_type"];
    return obj;
}

+ (BBKonwlegdeModel *)creatRemindObjectWithDBSet:(FMResultSet * )resultSet
{
    BBKonwlegdeModel * obj = [[BBKonwlegdeModel alloc]init];
    obj.ID = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"id"]];
    obj.days = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"day_num"]];
    obj.period = [resultSet intForColumn:@"age_type"];
    obj.type = [resultSet intForColumn:@"content_type"];
    obj.title = [resultSet stringForColumn:@"title"];
    obj.content = [resultSet stringForColumn:@"content"];
    obj.description = [resultSet stringForColumn:@"summary"];
    obj.imgArrStr = [resultSet stringForColumn:@"images"];
    //TO-DO
//    obj.image = [resultSet stringForColumn:@"<#string#>"];
    return obj;
}

+ (BBKonwlegdeModel *)creatSimpelRemindObjectWithDBSet:(FMResultSet * )resultSet
{
    BBKonwlegdeModel * obj = [[BBKonwlegdeModel alloc]init];
    obj.ID = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"id"]];
    obj.days = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"day_num"]];
    obj.period = [resultSet intForColumn:@"age_type"];
    obj.title = [resultSet stringForColumn:@"title"];
    obj.imgArrStr = [resultSet stringForColumn:@"images"];
    //TO-DO
    //    obj.image = [resultSet stringForColumn:@"<#string#>"];
    return obj;
}

#pragma mark- DBInterface

//获得某一天的知识
+ (BBKonwlegdeModel *)knowledgeInDays
{
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
    if (![db open]) {
        return nil;
    }
    //获取知识类型的对应天数的所有条目，应该是一条。
    BBKonwlegdeModel * obj = nil;
    
    int theDay = [BBPregnancyInfo daysOfPregnancy];

    BBUserRoleState state = [BBUser getNewUserRoleState];
    //处理22天以前的情况，统一显示一条知识
    if (state == BBUserRoleStatePregnant)
    {
        if (theDay < 22 && theDay > 0)
        {
            theDay =21;
        }
    }
    
    FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat: @"SELECT * FROM knowledge WHERE day_num='%d' AND content_type='1' AND age_type='%d' AND status='1'",theDay,state == BBUserRoleStatePregnant ? 1 : 2]];
    while ([resultSet next])
    {
        obj = [BBKonwlegdeDB creatRemindObjectWithDBSet:resultSet];
        break;
    }
    [resultSet close];
    
    //为了知识扩充做准备，超过范围取最后一天
    if(state == BBUserRoleStateHasBaby && !obj)
    {
        resultSet = [db executeQuery:[NSString stringWithFormat: @"SELECT * FROM knowledge WHERE content_type='1' AND age_type='2' AND day_num = (SELECT MAX(day_num) FROM knowledge WHERE content_type='1' AND age_type='2') AND status='1'"]];
        while ([resultSet next])
        {
            obj = [BBKonwlegdeDB creatRemindObjectWithDBSet:resultSet];
            break;
        }
        [resultSet close];
    }
    
    if ([db hadError])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    
    return obj;
}

//通过ID获取知识
+ (BBKonwlegdeModel *)knowledgeByID:(NSString *)ID
{
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
    if (![db open]) {
        return nil;
    }
    //获取知识类型的对应天数的所有条目，应该是一条。
    BBKonwlegdeModel * obj = nil;
    
    FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat: @"SELECT * FROM knowledge WHERE id='%d' AND status='1'",ID.integerValue]];
    while ([resultSet next])
    {
        obj = [BBKonwlegdeDB creatRemindObjectWithDBSet:resultSet];
        break;
    }
    [resultSet close];
    
    if ([db hadError])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    
    return obj;
}

//获得某一天的关爱提醒数据
+ (BBKonwlegdeModel *)remindRecordOfDay
{
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
    if (![db open]) {
        return nil;
    }
    //获取知识类型的对应天数的所有条目，应该是一条。
    BBKonwlegdeModel * obj = nil;
    
    int theDay = [BBPregnancyInfo daysOfPregnancy];
    BBUserRoleState state = [BBUser getNewUserRoleState];
    if (state == BBUserRoleStatePregnant)
    {
        if (theDay < 22 && theDay > 0)
        {
            theDay =21;
        }
    }
    
    FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat: @"SELECT * FROM knowledge WHERE day_num='%d' AND content_type='2' AND age_type='%d' AND status='1'",theDay,state == BBUserRoleStatePregnant ? 1 : 2]];
    while ([resultSet next])
    {
        obj = [BBKonwlegdeDB creatRemindObjectWithDBSet:resultSet];
        break;
    }
    [resultSet close];
    
    //为了知识扩充做准备
    if(state == BBUserRoleStateHasBaby && !obj)
    {
        resultSet = [db executeQuery:[NSString stringWithFormat: @"SELECT * FROM knowledge WHERE content_type='2' AND age_type='2' AND day_num = (SELECT MAX(day_num) FROM knowledge WHERE content_type='2' AND age_type='2') AND status='1'"]];
        while ([resultSet next])
        {
            obj = [BBKonwlegdeDB creatRemindObjectWithDBSet:resultSet];
            break;
        }
        [resultSet close];
    }
    
    if ([db hadError])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    
    return obj;
}

//获得某一天的发育
+ (BBKonwlegdeModel *)babyGrowthRecordOfDay
{
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
    if (![db open]) {
        return nil;
    }
    //获取知识类型的对应天数的所有条目，应该是一条。
    BBKonwlegdeModel * obj = nil;
    
    int theDay = [BBPregnancyInfo daysOfPregnancy];
    BBUserRoleState state = [BBUser getNewUserRoleState];
    if (state == BBUserRoleStatePregnant)
    {
        if (theDay < 22 && theDay > 0)
        {
            theDay =21;
        }
    }
    
    FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat: @"SELECT * FROM knowledge WHERE day_num='%d' AND content_type='3' AND age_type='%d' AND status='1'",theDay,state == BBUserRoleStatePregnant ? 1 : 2]];
    while ([resultSet next])
    {
        obj = [BBKonwlegdeDB creatRemindObjectWithDBSet:resultSet];
        break;
    }
    [resultSet close];
    
    //为了知识扩充做准备，超过范围取最后一天
    if(state == BBUserRoleStateHasBaby && !obj)
    {
        resultSet = [db executeQuery:[NSString stringWithFormat: @"SELECT * FROM knowledge WHERE content_type='3' AND age_type='2' AND day_num = (SELECT MAX(day_num) FROM knowledge WHERE content_type='3' AND age_type='2') AND status='1'"]];
        while ([resultSet next])
        {
            obj = [BBKonwlegdeDB creatRemindObjectWithDBSet:resultSet];
            break;
        }
        [resultSet close];
    }
    
    //处理当天没有图片的情况
    BOOL isHasImage = NO;
    if (obj.imgArrStr && obj.period == knowlegdePeriodPregnancy)
    {
        NSArray *imageArray = [NSJSONSerialization JSONObjectWithData:[obj.imgArrStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        if (imageArray && [imageArray isKindOfClass:[NSArray class]] && imageArray.count) {
            isHasImage = YES;
        }
    }
    if (!isHasImage && obj)
    {
        //第一天是22天，3周+1，不是整数周，特殊处理
        if (theDay < 28)
        {
            resultSet = [db executeQuery:[NSString stringWithFormat: @"SELECT * FROM knowledge WHERE day_num='%d' AND content_type='3' AND age_type='%d' AND status='1'",22,state == BBUserRoleStatePregnant ? 1 : 2]];

        }else
        {
            resultSet = [db executeQuery:[NSString stringWithFormat: @"SELECT * FROM knowledge WHERE day_num='%d' AND content_type='3' AND age_type='%d' AND status='1'",theDay - (theDay%7),state == BBUserRoleStatePregnant ? 1 : 2]];
        }
        while ([resultSet next])
        {
            BBKonwlegdeModel * imgObj = [BBKonwlegdeDB creatRemindObjectWithDBSet:resultSet];
            if (imgObj) {
                //重新插入整数周的图片
                obj.imgArrStr = imgObj.imgArrStr;
            }
            break;
        }
        [resultSet close];
    }
    
    if ([db hadError])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    
    return obj;
}

//通过天数获取一定天数的关爱提醒
+ (NSArray *)someRecentRemindsOfCurDay:(NSInteger)theDay
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
    if (![db open]) {
        return nil;
    }
    //获取知识类型的对应天数的所有条目，应该是一条。
    FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM knowledge WHERE content_type='2' AND day_num <= ? AND day_num >= ? ORDER BY day_num DESC",theDay,theDay - KNOWLEDGE_PRIOR_NUM];
    
    while ([resultSet next])
    {
        BBKonwlegdeModel * obj = [BBKonwlegdeDB creatRemindObjectWithDBSet:resultSet];
        [arr addObject:obj];
    }
    //获取当前列表后面的部分
    BBKonwlegdeModel * firstDay = arr.firstObject;
    int endDay = KNOWLEDGE_TOTAL_NUM - (theDay - [firstDay.days intValue]);
    resultSet = [db executeQuery:@"SELECT * FROM knowledge WHERE content_type='2' AND day_num > ? AND day_num <= ? AND ORDER BY day_num DESC",theDay,endDay];
    
    while ([resultSet next])
    {
        BBKonwlegdeModel * obj = [BBKonwlegdeDB creatRemindObjectWithDBSet:resultSet];
        [arr addObject:obj];
    }
    
    //如果取到孕期和育儿的交界处，继续获取育儿知识
    BBKonwlegdeModel * lastDay = arr.lastObject;
    if ([lastDay.days intValue] > endDay)
    {
        BBKonwlegdeModel * firstDay = arr.firstObject;
        int endDay = KNOWLEDGE_TOTAL_NUM - (theDay - [firstDay.days intValue]);
        resultSet = [db executeQuery:@"SELECT * FROM knowledge WHERE content_type='2' AND day_num > ? AND day_num <= ? ORDER BY day_num DESC",theDay,endDay];
        
        while ([resultSet next])
        {
            BBKonwlegdeModel * obj = [BBKonwlegdeDB creatRemindObjectWithDBSet:resultSet];
            [arr addObject:obj];
        }
    }
    
    [resultSet close];
    
    if ([db hadError])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    
    return arr;
}

//获取所有的提醒
+ (NSMutableArray *)allReminds
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
    if (![db open]) {
        return nil;
    }
    //获取知识类型的对应天数的所有条目，应该是一条。
    FMResultSet *resultSet = [db executeQuery:@"SELECT id,day_num,age_type,title,images FROM knowledge WHERE content_type='2'  AND status='1' ORDER BY age_type,day_num ASC"];
    
    while ([resultSet next])
    {
        BBKonwlegdeModel * obj = [BBKonwlegdeDB creatSimpelRemindObjectWithDBSet:resultSet];
        [arr addObject:obj];
    }
    
    [resultSet close];
    
    if ([db hadError])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    return arr;
}

//获取所有宝宝发育
+ (NSMutableArray *)allBabyGrowth
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
    if (![db open]) {
        return nil;
    }
    //获取知识类型的对应天数的所有条目，应该是一条。
    FMResultSet *resultSet = [db executeQuery:@"SELECT id,day_num,age_type,title,images FROM knowledge WHERE content_type='3' AND status='1' ORDER BY age_type,day_num ASC"];
//    FMResultSet *resultSet = [db executeQuery:@"SELECT id,day_num,age_type FROM knowledge WHERE content_type='1' AND day_num>'0' AND status='1' ORDER BY age_type,day_num ASC"];
    
    while ([resultSet next])
    {
        BBKonwlegdeModel * obj = [BBKonwlegdeDB creatSimpelRemindObjectWithDBSet:resultSet];
        [arr addObject:obj];
    }
    
    [resultSet close];
    
    if ([db hadError])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    return arr;
}

//通过天数获取一定数量的指定天数之前的提醒
+ (NSArray *)somePriorRemindsOfDay:(NSInteger)theDay
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    return arr;
}

//通过天数获取一定数量的指定天数之后的提醒
+ (NSArray *)someLaterRemindsOfDay:(NSInteger)theDay
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    return arr;
}

//通过天数获取一定天数的宝宝发育
+ (NSArray *)someRecentBabyGrowthOfCurDay:(NSInteger)theDay
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    return arr;
}

//通过天数获取一定数量的指定天数之前的宝宝发育
+ (NSArray *)somePriorGrowthOfDay:(NSInteger)theDay
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    return arr;
}

//通过天数获取一定数量的指定天数之后的宝宝发育
+ (NSArray *)someLaterGrowthOfDay:(NSInteger)theDay
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    return arr;
}

//更新知识库
+ (BOOL)upDataKnowledgeData:(NSArray *)arr
{
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
    if (![db open])
    {
        return false;
    }
    
    [db beginDeferredTransaction];
    BOOL isRollBack = NO;
    @try {
        for (NSDictionary * data in arr)
        {
            NSData * da = [NSJSONSerialization dataWithJSONObject:[data valueForKey:@"images"] options:NSJSONWritingPrettyPrinted error:nil];
            NSString * imgsStr = [[NSString alloc]initWithData:da encoding:NSUTF8StringEncoding];
            
            [db executeUpdate:@"REPLACE INTO knowledge(id,age_type,content_type,day_num,category_id,title,summary,content,status,create_ts,update_ts,category,images,ad_json) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",[data valueForKey:@"id"],[data valueForKey:@"age_type"] ,[data valueForKey:@"content_type"] ,[data valueForKey:@"day_num"],[data valueForKey:@"category_id"],[data valueForKey:@"title"],[data valueForKey:@"summary"],[data valueForKey:@"content"],[data valueForKey:@"status"],[data valueForKey:@"create_ts"],[data valueForKey:@"update_ts"],[data valueForKey:@"category"],imgsStr,[data valueForKey:@"ad_json"]];
            
            if ([db hadError]) {
                NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                [db close];
                return NO;
            }
        }
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        [db rollback];
    }
    @finally {
        if (!isRollBack) {
            [db commit];
        }
    }
    
//    [db executeUpdate:@"REPLACE INTO knowledge(id,age_type) VALUES(?,?)",0,1];
    
    [db close];
    return YES;
}

+ (BOOL)setKnownledgeTS:(NSString *)ts
{
    if (ts && [ts isKindOfClass:[NSString class]])
    {
        FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
        if (![db open])
        {
            return false;
        }
        [db executeUpdate:@"update knowledge_config set update_ts = ? where id = ?", ts,[NSNumber numberWithInt:1]];
        //数据库访问是否错误
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            [db close];
            return NO;
        }
        
        [db close];
        return YES;
    }
    return NO;
}

+ (NSString *)getKnowledgeTS
{
    NSString * retStr = nil;
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
    if (![db open]) {
        return nil;
    }
    //获取知识类型的对应天数的所有条目，应该是一条。
    FMResultSet *resultSet = [db executeQuery:@"SELECT update_ts FROM knowledge_config"];
    while ([resultSet next])
    {
        retStr = [resultSet stringForColumn:@"update_ts"];
    }
    
    [resultSet close];
    
    if ([db hadError])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    return retStr;
}

//插入或者修改一条知识库条目
+ (BOOL)replaceIntoKnowledgeData:(NSDictionary *)data
{
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
    if (![db open])
    {
        return false;
    }
    [db executeUpdate:@"REPLACE INTO knowledge(_id,category_id,days_number,title,summary_image,summary_content,type_id,topics,is_important,status,type_name,remote_url) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",[[data valueForKey:@"_id"] integerValue] ,[[data valueForKey:@"category_id"] integerValue],[[data valueForKey:@"days_number"] integerValue] ,[data valueForKey:@"title"],[data valueForKey:@"summary_image"],[data valueForKey:@"summary_content"],[[data valueForKey:@"type_id"] integerValue],[data valueForKey:@"topics"],[[data valueForKey:@"is_important"] integerValue],0,[data valueForKey:@"type_name"],[data valueForKey:@"remote_url"]];
    //数据库访问是否错误
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return NO;
    }

    [db close];
    return YES;
}

+ (NSMutableArray *)allKonwledgeTabsData
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
    if (![db open]) {
        return nil;
    }
    //获取知识类型的对应天数的所有条目，应该是一条。
    FMResultSet *resultSet = [db executeQuery:@"SELECT id,day_num,age_type FROM knowledge WHERE content_type='1' AND day_num>'0' AND status='1' ORDER BY age_type,day_num ASC"];
    while ([resultSet next])
    {
        BBKonwlegdeModel * obj = [BBKonwlegdeDB creatKnowledgeTabObjectWithDBSet:resultSet];
        [arr addObject:obj];
    }
    
    [resultSet close];
    
    if ([db hadError])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    return arr;
}

//获取所有的知识库
+ (NSDictionary *)allKonwledgeLibData
{
    NSMutableDictionary * totalDic = [[NSMutableDictionary alloc]init];
    NSMutableArray *allKeys = [NSMutableArray array];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
    if (![db open]) {
        return nil;
    }
    //获取知识类型的对应天数的所有条目，应该是一条。
    FMResultSet *resultSet = [db executeQuery:@"SELECT id,category,title,images FROM knowledge WHERE content_type='1' AND status='1' ORDER BY age_type,day_num ASC"];
    while ([resultSet next])
    {
        BBKonwlegdeModel * obj = [BBKonwlegdeDB creatLibObjectWithDBSet:resultSet];
        if (obj.category && obj.category.length)
        {
            if (![totalDic objectForKey:obj.category])
            {
                [allKeys addObject:obj.category];
                BBKonwlegdeModel *arrModel = [[BBKonwlegdeModel alloc]init];
                arrModel.customArr = [[NSMutableArray alloc]init];
                [totalDic setObject:arrModel forKey:obj.category];
            }
            BBKonwlegdeModel * arrModel = [totalDic objectForKey:obj.category];
            if (arrModel)
            {
                [arrModel.customArr addObject:obj];
            }
        }
    }
    
    [resultSet close];
    
    if ([db hadError])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    
    if (totalDic && allKeys) {
        [totalDic setObject:allKeys forKey:KNOWLEDGE_ALLKEYS];
    }
    return totalDic;
}

//根据天数获得某一天的发育
+ (BBKonwlegdeModel *)babyGrowthRecord:(NSInteger)days
{
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
    if (![db open]) {
        return nil;
    }
    //获取知识类型的对应天数的所有条目，应该是一条。
    BBKonwlegdeModel * obj = nil;
    
    BBUserRoleState state = [BBUser getNewUserRoleState];
    
    FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat: @"SELECT * FROM knowledge WHERE day_num='%d' AND content_type='3' AND age_type='%d' AND status='1'",days,state == BBUserRoleStatePregnant ? 1 : 2]];
    while ([resultSet next])
    {
        obj = [BBKonwlegdeDB creatRemindObjectWithDBSet:resultSet];
        break;
    }
    [resultSet close];
    
    if ([db hadError])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    
    return obj;
}

//孕期用户获取每孕周第一天的关爱提醒 育儿用户获取宝宝每周第一天的关爱提醒
+ (NSMutableArray*)allLocalReminds
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKonwlegdeDB KnowledgePath]];
    if (![db open]) {
        return nil;
    }
    //获取知识类型的对应天数的所有条目，应该是一条。
    NSString *queryStr = nil;
    if ([BBUser getNewUserRoleState] == BBUserRoleStatePregnant)
    {
       //孕期用户
       queryStr = @"SELECT * FROM knowledge WHERE day_num%7=0 AND day_num>0 AND content_type='2' AND age_type='1' AND status='1' ORDER BY day_num ASC";
    }
    
    if ([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
    {
        //育儿用户
        queryStr = @"SELECT * FROM knowledge WHERE day_num%7=1 AND day_num>0 AND content_type='2' AND age_type='2' AND status='1' ORDER BY day_num ASC";
    }
    
    if (!queryStr)
    {
        return nil;
    }
    
    FMResultSet *resultSet = [db executeQuery:queryStr];
    while ([resultSet next])
    {
        BBKonwlegdeModel * obj = [BBKonwlegdeDB creatRemindObjectWithDBSet:resultSet];
        [arr addObject:obj];
    }
    
    [resultSet close];
    
    if ([db hadError])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    return arr;

}
@end
