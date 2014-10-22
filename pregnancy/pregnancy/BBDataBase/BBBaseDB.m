//
//  BBBaseDB.m
//  pregnancy
//
//  Created by liumiao on 9/2/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBBaseDB.h"

@implementation BBBaseDB

+(NSString *)dataBasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:[self dataBaseName]];
    return dbPath;
}

+ (BOOL)isDataBaseExit
{
    NSString *dbPath = [self dataBasePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:dbPath];
    return isExist;
}

+ (BOOL)createDataBase
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dataBasePath]];
    if (![db open])
    {
        return NO;
    }
    NSString *sql = [self createTableSQL];
    [db executeUpdate:sql];
    
    if ([db hadError])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return NO;
    }
    
    [db close];
    
    return YES;
}

+ (BOOL)deleteDataBase
{
    BOOL result = NO;
    NSError *error;
    NSString *dbPath = [self dataBasePath];
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

#pragma mark- 子类需要重写的方法
+ (NSString *)createTableSQL
{
    return [NSString stringWithFormat:@"CREATE TABLE if not exists %@ (%@)",[self tableName],@"id text NOT NULL PRIMARY KEY"];
}

+ (NSString *)dataBaseName
{
    return @"basedb.db";
}

+ (NSString *)tableName
{
    return @"table";
}


@end
