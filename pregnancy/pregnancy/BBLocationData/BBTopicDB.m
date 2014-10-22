//
//  BBTopicDB.m
//  pregnancy
//
//  Created by babytree babytree on 12-3-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBTopicDB.h"
#import "FMDatabase.h"

@implementation BBTopicDB

+ (BOOL)insertTopic:(NSDictionary *)topic
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"pregnancy.db"];
    //NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"pregnancy.db" ofType:nil];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return NO;
    }
    [db executeUpdate:@"insert into my_discuz(url,discuz_id,title,summary,author_id,author_name,create_ts,update_ts,response_count,last_response_ts,last_response_user_id,last_response_user_name) values(?,?,?,?,?,?,?,?,?,?,?,?)",[topic valueForKey:@"url"],
      [topic valueForKey:@"id"],[topic valueForKey:@"title"],[topic valueForKey:@"summary"],[topic valueForKey:@"author_id"],[topic valueForKey:@"author_name"],[topic valueForKey:@"create_ts"],[topic valueForKey:@"update_ts"],[topic valueForKey:@"response_count"],[topic valueForKey:@"last_response_ts"],[topic valueForKey:@"last_response_user_id"],[topic valueForKey:@"last_response_user_name"]];
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return NO;
    }
    [db close];
    return YES;
}

+ (BOOL)delTopicByTopicId:(NSString *)topicId
{  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"pregnancy.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return NO;
    }
    [db executeUpdate:@"delete from my_discuz where discuz_id = ?",topicId];
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return NO;
    }
    [db close];
    return YES;
    
}
+ (NSMutableArray *)topicList
{
    NSMutableArray *topicList = [[[NSMutableArray alloc] init ]autorelease];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"pregnancy.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return nil;
    }
    FMResultSet *resultSet = [db executeQuery:@"select * from my_discuz"];
    while ([resultSet next]) {
        //retrieve values for each record
        NSMutableDictionary *like = [[[NSMutableDictionary alloc] init] autorelease];        
        [like setObject:[self checkNil:[resultSet stringForColumn:@"url"]] forKey:@"url"];
        [like setObject:[self checkNil:[resultSet stringForColumn:@"discuz_id"]] forKey:@"id"];
        [like setObject:[self checkNil:[resultSet stringForColumn:@"title"]] forKey:@"title"];
        [like setObject:[self checkNil:[resultSet stringForColumn:@"summary"]] forKey:@"summary"];
        [like setObject:[self checkNil:[resultSet stringForColumn:@"author_id"]] forKey:@"author_id"];
        [like setObject:[self checkNil:[resultSet stringForColumn:@"author_name"]] forKey:@"author_name"];
        [like setObject:[self checkNil:[resultSet stringForColumn:@"create_ts"]] forKey:@"create_ts"];
        [like setObject:[self checkNil:[resultSet stringForColumn:@"update_ts"]] forKey:@"update_ts"];
        [like setObject:[self checkNil:[resultSet stringForColumn:@"response_count"]] forKey:@"response_count"];
        [like setObject:[self checkNil:[resultSet stringForColumn:@"last_response_ts"]] forKey:@"last_response_ts"];
        [like setObject:[self checkNil:[resultSet stringForColumn:@"last_response_user_id"]] forKey:@"last_response_user_id"];
        [like setObject:[self checkNil:[resultSet stringForColumn:@"last_response_user_name"]] forKey:@"last_response_user_name"];     
        [topicList addObject:like];
    }
    [resultSet close];
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    
    return topicList;
}
+ (NSInteger)topicListCount
{
    NSInteger count = 0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"pregnancy.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return count;
    }
    FMResultSet *resultSet = [db executeQuery:@"select count(*) from my_discuz"];
    while ([resultSet next]) {
        //retrieve values for each record
        count = [resultSet intForColumnIndex:0];
    }
    [resultSet close];
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return count;
    }
    [db close];
   return count;
}
+(NSString *) checkNil:(NSString *)str{
    if(str==nil){
        return @"";
    }
    return str;
}
+(BOOL)isExsitByTopicId:(NSString *)topicId{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"pregnancy.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return NO;
    }
    FMResultSet *resultSet = [db executeQuery:@"select * from my_discuz where discuz_id = ?",topicId];
    while ([resultSet next]) {
        //retrieve values for each record
        [resultSet close];
        [db close];
        return YES;
    }
    [resultSet close];
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return NO;
    }
    [db close];
    return NO;
}

+ (NSMutableArray *)topicCollectList
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"pregnancy.db"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
        if ([self topicList] != nil) {
            return [self topicList];
        }
    }
    return nil;
}

+ (void)deleteTopicCollectDatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"pregnancy.db"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
    }
}

@end
