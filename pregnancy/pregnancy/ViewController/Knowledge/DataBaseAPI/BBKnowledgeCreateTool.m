//
//  BBKnowledgeCreateTool.m
//  pregnancy
//
//  Created by liumiao on 7/15/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBKnowledgeCreateTool.h"
#import "BBKonwlegdeDB.h"
#import "FMDatabase.h"
#import "BBUpdataRequest.h"

//生成数据库时使用的初始ts
#define KNOWEDGE_CREATE_TS (@"0")

@implementation BBKnowledgeCreateTool



+ (void)deleteOldDB
{
    NSString *sourcePath = [BBKnowledgeCreateTool DBPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:sourcePath error:nil];
}

+(NSString *)DBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *sourcePath = [documentDirectory stringByAppendingPathComponent:KNOWLEDGE_DB_FILE_NAME];
    return sourcePath;
}

+(void)initDB
{
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKnowledgeCreateTool DBPath]];
    if (![db open]) {
        return;
    }
    [db executeUpdate:@"create table if not exists knowledge(id integer PRIMARY KEY,age_type integer,content_type integer,day_num integer,category_id integer,title text,summary text,content text,status integer,create_ts integer,update_ts integer,category text,images text,ad_json text)"];
    [db executeUpdate:@"create table if not exists knowledge_config(id integer PRIMARY KEY,update_ts text)"];
    [db executeUpdate:@"REPLACE INTO knowledge_config(id,update_ts) VALUES(?,?)",[NSNumber numberWithInt:1],@"0"];
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db close];
}

+(NSString*)getUpdateTS
{
    NSString * curTS = nil;
    FMDatabase *db = [FMDatabase databaseWithPath:[BBKnowledgeCreateTool DBPath]];
    if (![db open]) {
        return curTS;
    }
    //获取知识类型的对应天数的所有条目，应该是一条。
    FMResultSet *resultSet = [db executeQuery:@"SELECT update_ts FROM knowledge_config"];
    while ([resultSet next])
    {
        curTS = [resultSet stringForColumn:@"update_ts"];
    }
    
    [resultSet close];
    
    if ([db hadError])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    [db close];
    return curTS;
}

+(void)setUpdateTS:(NSString*)curTS
{
    if (curTS && [curTS isKindOfClass:[NSString class]])
    {
        FMDatabase *db = [FMDatabase databaseWithPath:[BBKnowledgeCreateTool DBPath]];
        if (![db open])
        {
            return;
        }
        [db executeUpdate:@"update knowledge_config set update_ts = ? where id = ?", curTS,[NSNumber numberWithInt:1]];
        //数据库访问是否错误
        if ([db hadError])
        {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        
        [db close];
    }
}
#pragma mark- 发版前使用来生成数据库的方法，发版后绝对不要调用！
+ (void)createKnowledgeDB
{
    //删除旧数据库
    [BBKnowledgeCreateTool deleteOldDB];
    //初始化新数据库
    [BBKnowledgeCreateTool initDB];
    
    ASIHTTPRequest * request;
    while (TRUE)
    {
        //获取上次更新的时间戳
        NSString * curTS = [BBKnowledgeCreateTool getUpdateTS];
        
        //发送请求，获取数据库数据
        [request clearDelegatesAndCancel];
        request =[BBUpdataRequest updataKnowledgeWithTS:curTS?curTS:KNOWEDGE_CREATE_TS];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error)
        {
            NSString *responseString = [request responseString];
            NSError *error = nil;
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            NSDictionary *data = [parser objectWithString:responseString error:&error];
            if (error != nil)
            {
                exit(0);
            }
            if ([[data stringForKey:@"status"] isEqualToString:@"success"])
            {
                NSDictionary * dic = [data dictionaryForKey:@"data"];
                
                NSArray * knowledgeArr = [dic arrayForKey:@"knowledge_list"];
                if ([dic stringForKey:@"update_ts"])
                {
                    curTS = [dic stringForKey:@"update_ts"];
                    //更新时间戳
                    [BBKnowledgeCreateTool setUpdateTS:curTS];
                    
                }
                
                if (knowledgeArr && knowledgeArr.count)
                {
                    FMDatabase *db = [FMDatabase databaseWithPath:[BBKnowledgeCreateTool DBPath]];
                    if (![db open])
                    {
                        exit(0);
                    }
                    
                    [db beginDeferredTransaction];
                    BOOL isRollBack = NO;
                    @try {
                        for (NSMutableDictionary * data in knowledgeArr)
                        {
                            if ([[data valueForKey:@"status"]intValue]!=0)
                            {
                                NSData * da = [NSJSONSerialization dataWithJSONObject:[data valueForKey:@"images"] options:NSJSONWritingPrettyPrinted error:nil];
                                NSString * imgsStr = [[NSString alloc]initWithData:da encoding:NSUTF8StringEncoding];
                                
                                [db executeUpdate:@"REPLACE INTO knowledge(id,age_type,content_type,day_num,category_id,title,summary,content,status,create_ts,update_ts,category,images,ad_json) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",[data valueForKey:@"id"],[data valueForKey:@"age_type"] ,[data valueForKey:@"content_type"] ,[data valueForKey:@"day_num"],[data valueForKey:@"category_id"],[data valueForKey:@"title"],[data valueForKey:@"summary"],[data valueForKey:@"content"],[data valueForKey:@"status"],[data valueForKey:@"create_ts"],[data valueForKey:@"update_ts"],[data valueForKey:@"category"],imgsStr,[data valueForKey:@"ad_json"]];
                                
                                if ([db hadError]) {
                                    NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                                }
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
                    
                    [db close];
                    
                }
                else
                {
                    //完成数据库生成了
                    break;
                }
            }
        }
    }
    //如果服务器数据没错，此时数据库一定生成完成了，
    exit(0);
}


@end
