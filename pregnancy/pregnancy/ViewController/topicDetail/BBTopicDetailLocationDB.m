//
//  BBTopicDetailLocationDB.m
//  pregnancy
//
//  Created by whl on 13-8-20.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBTopicDetailLocationDB.h"
#import "FMDB.h"
#import "HMDBVersionCheck.h"

#define BBTopicDetailLocation_SaveCount 50

static NSString *browseTopicDBName = @"topicdetailread.db";
static NSString *browseTopicDBTableName = @"browsedata";
static NSString *browseTopicDBTableContent = @"addtime text NOT NULL, topic_id text NOT NULL PRIMARY KEY, topic_floor integer, topic_floor_id text, showall bool";
static NSString *browseTopicDBTableInsert = @"(addtime, topic_id, topic_floor, topic_floor_id, showall) VALUES (?, ?, ?, ?, ?)";

@implementation BBTopicDetailLocation

@end



@implementation BBTopicDetailLocationDB


+ (BOOL)createTopicDetalLocationDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:browseTopicDBName];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open])
    {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE if not exists %@ (%@)", browseTopicDBTableName, browseTopicDBTableContent];
    [db executeUpdate:sql];

    if ([db hadError])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return NO;
    }

    [db close];
    
    [HMDBVersionCheck setDetailRead_DBVer];
    return YES;
}

// 删除数据库
+ (BOOL)deleteTopicDetalLocationDB
{
    BOOL result = NO;
    NSError *error;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:browseTopicDBName];

    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:dbPath];
    if (!isExist)
    {
        return YES;
    }

    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (db)
    {
        [db close];
    }

    result = [fm removeItemAtPath:dbPath error:&error];
    if (!result)
    {
        NSLog(@"Failed to delete old database file with message '%@'.", [error localizedDescription]);
    }

    return result;
}

+ (BOOL)reCreateTopicDetalLocationDB
{
    if ([BBTopicDetailLocationDB deleteTopicDetalLocationDB])
    {
        return [BBTopicDetailLocationDB createTopicDetalLocationDB];
    }

    return NO;
}

+ (BBTopicDetailLocation *)getTopicDetailLocationDB:(NSString *)topic_id
{
    if (![topic_id isNotEmpty])
    {
        return nil;
    }
    NSString *dbPath = getDocumentsDirectoryWithFileName(browseTopicDBName);

    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return nil;
    }

    __block BBTopicDetailLocation *tdl = nil;

    __block BOOL result = NO;
    [queue inDatabase:^(FMDatabase *topicDetailLocationDB) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE topic_id = '%@'", browseTopicDBTableName, topic_id];

        FMResultSet *rs = [topicDetailLocationDB executeQuery:sql];
        if ([rs next])
        {
            tdl = [[BBTopicDetailLocation alloc] init];
            if (tdl != nil)
            {
                tdl.m_Topic_ID = topic_id;
                tdl.m_AddTime = [rs stringForColumn:@"addtime"];
                tdl.m_Topic_Floor = [rs intForColumn:@"topic_floor"];
                tdl.m_Topic_FloorID = [rs stringForColumn:@"topic_floor_id"];
                tdl.m_IsShowAll = [rs boolForColumn:@"showall"];

                if (![topicDetailLocationDB hadError])
                {
                    result = YES;
                }
            }
        }

        [rs close];
    }];


    if (result)
    {
        return tdl;
    }
    else
    {
        return nil;
    }
}

//插入或者更新数据
+ (BOOL)insertAndUpdateTopicDetailLacationData:(BBTopicDetailLocation *)topicData
{
    if (![topicData.m_Topic_ID isNotEmpty])// || ![topicData.m_Topic_FloorID isNotEmpty])
    {
        return NO;
    }

    NSString *dbPath = getDocumentsDirectoryWithFileName(browseTopicDBName);

    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return NO;
    }

    __block BOOL result = NO;
    __block BBTopicDetailLocation *wTopicData = topicData;

    [queue inDatabase:^(FMDatabase *topicDetailLocationDB) {
        __strong BBTopicDetailLocation *sTopicData = wTopicData;

        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ %@", browseTopicDBTableName, browseTopicDBTableInsert];
        result = [topicDetailLocationDB executeUpdate:sql, sTopicData.m_AddTime, sTopicData.m_Topic_ID, [NSNumber numberWithInteger:sTopicData.m_Topic_Floor], sTopicData.m_Topic_FloorID, [NSNumber numberWithBool:sTopicData.m_IsShowAll]];
    }];

    return result;
}

//删除数据
+ (BOOL)deleteSpareTopicDetailLacationData
{
    NSString *dbPath = getDocumentsDirectoryWithFileName(browseTopicDBName);

    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return NO;
    }

    __block BOOL result = YES;
    __block NSString *tm = nil;
    [queue inDatabase:^(FMDatabase *topicDetailLocationDB) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ WHERE addtime IS NOT NULL GROUP BY addtime ORDER BY addtime DESC", browseTopicDBTableName];
        FMResultSet *rs = [topicDetailLocationDB executeQuery:sql];
        NSUInteger count = 0;
        while ([rs next])
        {
            count++;
            if (count == BBTopicDetailLocation_SaveCount)
            {
                tm = [rs stringForColumn:@"addtime"];
                break;
            }
        }

        [rs close];

        if (tm)
        {
            sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE addtime < ?", browseTopicDBTableName];
            result = [topicDetailLocationDB executeUpdate:sql, tm];
        }
    }];

    return result;
}

@end
