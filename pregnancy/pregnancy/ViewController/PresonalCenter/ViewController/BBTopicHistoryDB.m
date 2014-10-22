//
//  BBTopicHistoryDB.m
//  pregnancy
//
//  Created by liumiao on 9/2/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBTopicHistoryDB.h"
#import "FMDatabaseQueue.h"

#define MAX_HISTORY_COUNT 100

static NSString *createHistoryDBSQL = @"addtime text NOT NULL, topic_id text NOT NULL PRIMARY KEY, topic_floor integer, topic_floor_id text, showall bool, topic_title text, poster_id text, poster_name text";
static NSString *insertHistoryModelSQL = @"(addtime, topic_id, topic_floor, topic_floor_id, showall, topic_title, poster_id, poster_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
@implementation BBTopicHistoryModel
@end
@implementation BBTopicHistoryDB

+(NSArray *)topicHistoryModelArray
{
    __block NSMutableArray *modelArray = [NSMutableArray array];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self dataBasePath]];
    if (queue)
    {
        [queue inDatabase:^(FMDatabase *topicDetailLocationDB) {
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ WHERE addtime IS NOT NULL GROUP BY addtime ORDER BY addtime DESC", [self tableName]];
            FMResultSet *rs = [topicDetailLocationDB executeQuery:sql];
            NSUInteger count = 0;
            while ([rs next])
            {
                BBTopicHistoryModel *historyModel = [[BBTopicHistoryModel alloc] init];
                historyModel.m_TopicID = [rs stringForColumn:@"topic_id"];
                historyModel.m_AddTime = [rs stringForColumn:@"addtime"];
                historyModel.m_TopicFloor = [rs intForColumn:@"topic_floor"];
                historyModel.m_TopicFloorID = [rs stringForColumn:@"topic_floor_id"];
                historyModel.m_IsShowAll = [rs boolForColumn:@"showall"];
                historyModel.m_TopicTitle  = [rs stringForColumn:@"topic_title"];
                historyModel.m_PosterID  = [rs stringForColumn:@"poster_id"];
                historyModel.m_PosterName  = [rs stringForColumn:@"poster_name"];
                [modelArray addObject:historyModel];
                
                count += 1;
                if (count == MAX_HISTORY_COUNT)
                {
                    break;
                }
            }
            [rs close];
        }];
    }
    
    return modelArray;

}

+(BOOL)insertTopicHistoryModel:(BBTopicHistoryModel *)historyModel
{
    if (![historyModel.m_TopicID isNotEmpty])
    {
        return NO;
    }
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self dataBasePath]];
    if (!queue)
    {
        return NO;
    }
    
    __block BOOL result = NO;
    __block BBTopicHistoryModel *wHistoryModel = historyModel;
    
    [queue inDatabase:^(FMDatabase *topicDetailLocationDB) {
        __strong BBTopicHistoryModel *sHistoryModel = wHistoryModel;
        
        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ %@", [self tableName], insertHistoryModelSQL];
        result = [topicDetailLocationDB executeUpdate:sql, sHistoryModel.m_AddTime, sHistoryModel.m_TopicID, [NSNumber numberWithInteger:sHistoryModel.m_TopicFloor], sHistoryModel.m_TopicFloorID, [NSNumber numberWithBool:sHistoryModel.m_IsShowAll], sHistoryModel.m_TopicTitle,sHistoryModel.m_PosterID,sHistoryModel.m_PosterName];
    }];
    
    return result;

}

+ (BOOL)deleteSpareTopicHistory
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self dataBasePath]];
    if (!queue)
    {
        return NO;
    }
    
    __block BOOL result = YES;
    __block NSString *tm = nil;
    [queue inDatabase:^(FMDatabase *topicDetailLocationDB) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ WHERE addtime IS NOT NULL GROUP BY addtime ORDER BY addtime DESC", [self tableName]];
        FMResultSet *rs = [topicDetailLocationDB executeQuery:sql];
        NSUInteger count = 0;
        while ([rs next])
        {
            count++;
            if (count == MAX_HISTORY_COUNT)
            {
                tm = [rs stringForColumn:@"addtime"];
                break;
            }
        }
        
        [rs close];
        
        if (tm)
        {
            sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE addtime < ?", [self tableName]];
            result = [topicDetailLocationDB executeUpdate:sql, tm];
        }
    }];
    
    return result;
}

+ (BOOL)clearTopicHistory
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self dataBasePath]];
    if (!queue)
    {
        return NO;
    }
    
    __block BOOL result = YES;
    [queue inDatabase:^(FMDatabase *topicDetailLocationDB){
            result = [topicDetailLocationDB executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@", [self tableName]]];
    }];
    
    return result;
}

+ (NSString *)createTableSQL
{
    return [NSString stringWithFormat:@"CREATE TABLE if not exists %@ (%@)",[self tableName],createHistoryDBSQL];
}

+ (NSString *)dataBaseName
{
    return @"topichistory.db";
}

+ (NSString *)tableName
{
    return @"history";
}

@end
