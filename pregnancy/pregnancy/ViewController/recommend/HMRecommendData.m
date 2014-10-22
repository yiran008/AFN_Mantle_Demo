//
//  HMRecommendData.m
//  lama
//
//  Created by songxf on 13-6-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMRecommendData.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "HMRecommendModel.h"

// 数据库文件名
static NSString *DBName = @"localRecommend.sqlite";

// 数据库表名
static NSString *tableName = @"recommend";

// 保存数据sql
static NSString *tableInsertString = @"(recommendID,recommendTime, title1, pic1, url1, title2, pic2, url2, title3, pic3, url3, title4, pic4, url4) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";


@implementation HMRecommendData

// 初始化数据库:即把工程DB拷贝到Document
+ (void)initRecommendDB
{
    NSString *dbPath = getDocumentsDirectoryWithFileName(DBName);
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dbPath])
    {
        // 文件不存在，进行拷贝操作
        NSString *dataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/%@",DBName];
        NSError *error;
        if([fileManager copyItemAtPath:dataPath toPath:dbPath error:&error])
        {
//            NSLog(@"copy  success");
        }
        else
        {
//            NSLog(@"copy error %@",error);
        }
    }
}

// 获得数据列表
+ (NSArray *)getRecommendDB
{
    [self initRecommendDB];
    
    NSString *dbPath = getDocumentsDirectoryWithFileName(DBName);
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return nil;
    }
    
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    [queue inDatabase:^(FMDatabase *mydb) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ order by recommendTime desc",tableName];
        FMResultSet *rs = [mydb executeQuery:sql];
        // 逐条还原数据
        while ([rs next])
        {
            HMDayRecommendModel *data = [[[HMDayRecommendModel alloc] init] autorelease];
            
            if (data != nil)
            {
                data.dayTime = [rs stringForColumn:@"recommendTime"];
                data.recommendId = [rs stringForColumn:@"recommendID"];
                
                HMRecommendModel *recommend1 = [[[HMRecommendModel alloc] init] autorelease];
                recommend1.title = [rs stringForColumn:@"title1"];
                recommend1.picUrl = [rs stringForColumn:@"pic1"];
                recommend1.topicId = [rs stringForColumn:@"url1"];
                
                HMRecommendModel *recommend2 = [[[HMRecommendModel alloc] init] autorelease];
                recommend2.title = [rs stringForColumn:@"title2"];
                recommend2.picUrl = [rs stringForColumn:@"pic2"];
                recommend2.topicId = [rs stringForColumn:@"url2"];
                
                HMRecommendModel *recommend3 = [[[HMRecommendModel alloc] init] autorelease];
                recommend3.title = [rs stringForColumn:@"title3"];
                recommend3.picUrl = [rs stringForColumn:@"pic3"];
                recommend3.topicId = [rs stringForColumn:@"url3"];
                
                HMRecommendModel *recommend4 = [[[HMRecommendModel alloc] init] autorelease];
                recommend4.title = [rs stringForColumn:@"title4"];
                recommend4.picUrl = [rs stringForColumn:@"pic4"];
                recommend4.topicId = [rs stringForColumn:@"url4"];

                data.dayRecommendList = [[[NSArray alloc] initWithObjects:recommend1,recommend2,recommend3,recommend4, nil] autorelease];
                
                [array addObject:data];
            }
        }
    }];
    
    return array;
}

// 插入多条数据
+ (BOOL)insertRecommendList:(NSArray *)dataList
{    
    for (int i=0; i<[dataList count]; i++)
    {
        HMDayRecommendModel *data = [dataList objectAtIndex:i];
        [self insertRecommendDB:data];
    }
    
    return YES;
}

// 插入一条数据
+ (BOOL)insertRecommendDB:(HMDayRecommendModel *)data
{
    [self initRecommendDB];

    NSString *dbPath = getDocumentsDirectoryWithFileName(DBName);
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return NO;
    }
    
    __block BOOL result = NO;
    __block HMDayRecommendModel *bData = data;
    [queue inDatabase:^(FMDatabase *mydb) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE recommendTime = %@", tableName, data.dayTime];
        FMResultSet *rs = [mydb executeQuery:sql];
        if (![rs next])
        {
            sql = [NSString stringWithFormat:@"INSERT INTO %@ %@", tableName, tableInsertString];
            result = [mydb executeUpdate:sql,
                      bData.recommendId,
                      bData.dayTime,
                      [(HMRecommendModel *)[bData.dayRecommendList objectAtIndex:0] title],
                      [(HMRecommendModel *)[bData.dayRecommendList objectAtIndex:0] picUrl],
                      [(HMRecommendModel *)[bData.dayRecommendList objectAtIndex:0] topicId],
                      [(HMRecommendModel *)[bData.dayRecommendList objectAtIndex:1] title],
                      [(HMRecommendModel *)[bData.dayRecommendList objectAtIndex:1] picUrl],
                      [(HMRecommendModel *)[bData.dayRecommendList objectAtIndex:1] topicId],
                      [(HMRecommendModel *)[bData.dayRecommendList objectAtIndex:2] title],
                      [(HMRecommendModel *)[bData.dayRecommendList objectAtIndex:2] picUrl],
                      [(HMRecommendModel *)[bData.dayRecommendList objectAtIndex:2] topicId],
                      [(HMRecommendModel *)[bData.dayRecommendList objectAtIndex:3] title],
                      [(HMRecommendModel *)[bData.dayRecommendList objectAtIndex:3] picUrl],
                      [(HMRecommendModel *)[bData.dayRecommendList objectAtIndex:3] topicId]
                      ];
        }
        [rs close];
    }];
    
    return result;
}

// 移除缓存
+ (BOOL)removeRecommendDB
{
    NSString *dbPath = getDocumentsDirectoryWithFileName(DBName);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:dbPath])
    {
        NSError *error;
        if([fileManager removeItemAtPath:dbPath error:&error])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return YES;
}


// 获取推荐列表  pregnancy&last_ts=0&limit=3
+ (ASIFormDataRequest *)getRecommendDataFromServer:(long long)start
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_recommend/get_recommend_topic",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
    {
        [request setGetValue:@"1" forKey:@"baby_status"];
    }
    else if ([BBUser getNewUserRoleState] == BBUserRoleStatePregnant)
    {
        [request setGetValue:@"2" forKey:@"baby_status"];
    }
    else
    {
        [request setGetValue:@"3" forKey:@"baby_status"];
    }
    [request setGetValue:[NSString stringWithFormat:@"%lld",start] forKey:@"last_ts"];
    [request setGetValue:@"2" forKey:@"limit"];
    ASI_DEFAULT_INFO_GET
    
    [request setGetValue:@"pregnancy" forKey:@"app_id"];
    return request;
}

@end
