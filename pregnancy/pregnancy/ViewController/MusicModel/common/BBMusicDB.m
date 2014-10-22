//
//  BBMusicDB.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-15.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBMusicDB.h"

@implementation BBMusicDB
static FMDatabase *shareDataBase = nil;

+ (FMDatabase *)createDataBase {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDataBase = [[FMDatabase databaseWithPath:dataBasePath] retain];
    });
    return shareDataBase;

}

+ (void)closeDataBase {
    if(![shareDataBase close]) {
        NSLog(@"数据库关闭异常，请检查");
        return;
    }
}

+ (BOOL) isTableExist:(NSString *)tableName {
    FMResultSet *rs = [shareDataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"%@ isOK %d", tableName,count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;

}

+ (BOOL)openTable
{
    shareDataBase = [BBMusicDB createDataBase];
    if (![shareDataBase open])
    {
        return NO;
    }
    
    if (![BBMusicDB isTableExist:@"music_table"]) {
        NSString *sql = @"CREATE TABLE music_table(music_id TEXT PRIMARY KEY,url TEXT,title TEXT,status integer,size TEXT,category_id)";
        
        if (![shareDataBase executeUpdate:sql]) {
            return NO;
        }
        
    }
    return YES;
}


+ (BOOL)insertMusicWithDic:(NSDictionary *)musicDic {
    BOOL isOK = NO;
    if (![self openTable]) {
        return NO;
    }
    shareDataBase = [BBMusicDB createDataBase];
    
    NSString *sql = @"INSERT INTO music_table(url,music_id,title,status,size,category_id) VALUES(?,?,?,?,?,?)";
    isOK = [shareDataBase executeUpdate:sql,musicDic[MUSIC_DOWNLOADURL],musicDic[MUSIC_ID],musicDic[MUSIC_TITLE],musicDic[MUSIC_STATUS],musicDic[MUSIC_FILESIZE],musicDic[MUSIC_CATEGORYID]];
    [shareDataBase close];
    return isOK;
}

+ (BOOL)deleteMusicWithID:(NSString *)musicid
{
    
    BOOL isOK = NO;
    if (![self openTable]) {
        return NO;
    }
    shareDataBase = [BBMusicDB createDataBase];
    isOK = [shareDataBase executeUpdate:@"DELETE FROM music_table where music_id = ?",musicid];
    [shareDataBase close];
    return isOK;
    
}


+ (NSMutableArray *)getMusicList {
    if (![self openTable]) {
        return nil;
    }
    NSMutableArray *videoList = [[[NSMutableArray alloc] init] autorelease];
    shareDataBase = [BBMusicDB createDataBase];
    FMResultSet *resultSet = [shareDataBase executeQuery:@"select * from music_table"];
    while ([resultSet next]) {
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        [dic setObject:[resultSet stringForColumn:MUSIC_DOWNLOADURL] forKey:MUSIC_DOWNLOADURL];
        [dic setObject:[resultSet stringForColumn:MUSIC_ID] forKey:MUSIC_ID];
        [dic setObject:[resultSet stringForColumn:MUSIC_TITLE] forKey:MUSIC_TITLE];
        [dic setObject:[NSNumber numberWithInt:[resultSet doubleForColumn:MUSIC_STATUS]] forKey:MUSIC_STATUS];
        [dic setObject:[resultSet stringForColumn:MUSIC_FILESIZE] forKey:MUSIC_FILESIZE];
        [dic setObject:[resultSet stringForColumn:MUSIC_CATEGORYID] forKey:MUSIC_CATEGORYID];

        [videoList addObject:dic];

    }
    [resultSet close];
    
    if ([shareDataBase hadError]) {
        [shareDataBase close];
        return nil;
    }
    
    [shareDataBase close];
    return videoList;
}


+ (NSMutableArray *)getDownLoadMusic {
    if (![self openTable]) {
        return nil;
    }
    NSMutableArray *videoList = [[[NSMutableArray alloc] init] autorelease];
    shareDataBase = [BBMusicDB createDataBase];
    FMResultSet *resultSet = [shareDataBase executeQuery:@"select * from music_table where status != ? and status != ?",[NSNumber numberWithInt:DOWNLOAD_PRE],[NSNumber numberWithInt:DOWNLOAD_FINISH]];
    while ([resultSet next]) {
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        [dic setObject:[resultSet stringForColumn:MUSIC_DOWNLOADURL] forKey:MUSIC_DOWNLOADURL];
        [dic setObject:[resultSet stringForColumn:MUSIC_ID] forKey:MUSIC_ID];
        [dic setObject:[resultSet stringForColumn:MUSIC_TITLE] forKey:MUSIC_TITLE];
        [dic setObject:[NSNumber numberWithInt:[resultSet doubleForColumn:MUSIC_STATUS]] forKey:MUSIC_STATUS];
        [dic setObject:[resultSet stringForColumn:MUSIC_FILESIZE] forKey:MUSIC_FILESIZE];
        [dic setObject:[resultSet stringForColumn:MUSIC_CATEGORYID] forKey:MUSIC_CATEGORYID];

        [videoList addObject:dic];
        
    }
    [resultSet close];
    
    if ([shareDataBase hadError]) {
        [shareDataBase close];
        return nil;
    }
    
    [shareDataBase close];
    return videoList;
}

+ (NSMutableArray *)getLocalMusic
{
    if (![self openTable]) {
        return nil;
    }
    NSMutableArray *videoList = [[[NSMutableArray alloc] init] autorelease];
    shareDataBase = [BBMusicDB createDataBase];
    FMResultSet *resultSet = [shareDataBase executeQuery:@"select * from music_table where status = ?",[NSNumber numberWithInt:DOWNLOAD_FINISH]];
    while ([resultSet next]) {
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        [dic setObject:[resultSet stringForColumn:MUSIC_DOWNLOADURL] forKey:MUSIC_DOWNLOADURL];
        [dic setObject:[resultSet stringForColumn:MUSIC_ID] forKey:MUSIC_ID];
        [dic setObject:[resultSet stringForColumn:MUSIC_TITLE] forKey:MUSIC_TITLE];
        [dic setObject:[NSNumber numberWithInt:[resultSet doubleForColumn:MUSIC_STATUS]] forKey:MUSIC_STATUS];
        [dic setObject:[resultSet stringForColumn:MUSIC_FILESIZE] forKey:MUSIC_FILESIZE];
        [dic setObject:[resultSet stringForColumn:MUSIC_CATEGORYID] forKey:MUSIC_CATEGORYID];
        
        [videoList addObject:dic];
        
    }
    [resultSet close];
    
    if ([shareDataBase hadError]) {
        [shareDataBase close];
        return nil;
    }
    
    [shareDataBase close];
    return videoList;

}

+ (NSDictionary *)getMusicWithID:(NSString *)musicid
{
    if (![self openTable]) {
        return nil;
    }
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];

    shareDataBase = [BBMusicDB createDataBase];
    FMResultSet *resultSet = [shareDataBase executeQuery:@"select * from music_table where music_id = ?",musicid];
    while ([resultSet next]) {
        [dic setObject:[resultSet stringForColumn:MUSIC_DOWNLOADURL] forKey:MUSIC_DOWNLOADURL];
        [dic setObject:[resultSet stringForColumn:MUSIC_ID] forKey:MUSIC_ID];
        [dic setObject:[resultSet stringForColumn:MUSIC_TITLE] forKey:MUSIC_TITLE];
        [dic setObject:[NSNumber numberWithInt:[resultSet doubleForColumn:MUSIC_STATUS]] forKey:MUSIC_STATUS];
        [dic setObject:[resultSet stringForColumn:MUSIC_FILESIZE] forKey:MUSIC_FILESIZE];
        [dic setObject:[resultSet stringForColumn:MUSIC_CATEGORYID] forKey:MUSIC_CATEGORYID];

        
    }
    [resultSet close];
    
    if ([shareDataBase hadError]) {
        [shareDataBase close];
        return nil;
    }
    
    [shareDataBase close];
    return dic;
    
}



+ (BOOL)setDownloadStauts:(int)downloadStatus withMusicID:(NSString *)musicid {
    if (![self openTable]) {
        return NO;
    }
    shareDataBase = [BBMusicDB createDataBase];
    [shareDataBase executeUpdate:@"update music_table set status=? where music_id=?",[NSNumber numberWithInt:downloadStatus],musicid];
    if ([shareDataBase hadError]) {
        [shareDataBase close];
        return NO;
    }
    
    [shareDataBase close];
    return YES;

}

+ (NSMutableArray *)getDownLoadMusicWithCategoryID:(NSString *)categoryid
{
    if (![self openTable]) {
        return nil;
    }
    NSMutableArray *videoList = [[[NSMutableArray alloc] init] autorelease];
    shareDataBase = [BBMusicDB createDataBase];
    FMResultSet *resultSet = [shareDataBase executeQuery:@"select * from music_table where status != ? and category_id = ?",[NSNumber numberWithInt:DOWNLOAD_PRE],categoryid];
    while ([resultSet next]) {
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        [dic setObject:[resultSet stringForColumn:MUSIC_DOWNLOADURL] forKey:MUSIC_DOWNLOADURL];
        [dic setObject:[resultSet stringForColumn:MUSIC_ID] forKey:MUSIC_ID];
        [dic setObject:[resultSet stringForColumn:MUSIC_TITLE] forKey:MUSIC_TITLE];
        [dic setObject:[NSNumber numberWithInt:[resultSet doubleForColumn:MUSIC_STATUS]] forKey:MUSIC_STATUS];
        [dic setObject:[resultSet stringForColumn:MUSIC_FILESIZE] forKey:MUSIC_FILESIZE];
        [dic setObject:[resultSet stringForColumn:MUSIC_CATEGORYID] forKey:MUSIC_CATEGORYID];
        
        [videoList addObject:dic];
        
    }
    [resultSet close];
    
    if ([shareDataBase hadError]) {
        [shareDataBase close];
        return nil;
    }
    
    [shareDataBase close];
    return videoList;
}

+ (BOOL)setFileSize:(long long)fileSize withMusicID:(NSString *)musicid {
    return YES;
}


@end
