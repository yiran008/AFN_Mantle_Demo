//
//  BBGuideDB.m
//  pregnancy
//
//  Created by whl on 14-7-16.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBGuideDB.h"
#import "FMDB.h"
#import "FMDatabase.h"
#import "BBAppInfo.h"

#define COVERLAYERDBNAME @"appCoverLayer.db"
#define COVERLAYERDBTABLENAME @"coverLayerInfo"

/*
 * 表字段的含义:
 *  appVersion 应用的版本号
 *  coverLayer 蒙层对Key
 *  isShow     是否已经显示过
 */

@implementation BBCoverLayerClass

@end

@implementation BBGuideDB

+(BOOL)isExistCorverLayer
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:COVERLAYERDBNAME];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:dbPath];
    if (isExist)
    {
        return YES;
    }
    return NO;
}

+(BOOL)createCoverLayerLocationDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:COVERLAYERDBNAME];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:dbPath];
    if (isExist)
    {
        return YES;
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open])
    {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE if not exists %@ (coverLayer text PRIMARY KEY, appVersion text, isShow bool)", COVERLAYERDBTABLENAME];
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

//插入或者更新数据
+(BOOL)insertAndUpdateCoverLayerData:(BBCoverLayerClass *)coverLayerData
{
    if (![coverLayerData.m_CoverLayerKey isNotEmpty])
    {
        return NO;
    }
    
    NSString *dbPath = getDocumentsDirectoryWithFileName(COVERLAYERDBNAME);
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return NO;
    }
    
    __block BOOL result = NO;
    __block BBCoverLayerClass *coverLayerClass = coverLayerData;
    
    [queue inDatabase:^(FMDatabase *coverLayerDB) {
        __strong BBCoverLayerClass *sCoverLayerClass = coverLayerClass;
        
        result = [coverLayerDB executeUpdate:[NSString stringWithFormat:@"REPLACE INTO %@(coverLayer,appVersion,isShow) VALUES (?, ?, ?)", COVERLAYERDBTABLENAME],sCoverLayerClass.m_CoverLayerKey,sCoverLayerClass.m_AppVersion,[NSNumber numberWithBool:sCoverLayerClass.m_IsShow]];
    }];
    
    return result;
}


+ (BBCoverLayerClass *)getCoverLayerData:(NSString *)coverLayerKey
{
    if (![coverLayerKey isNotEmpty])
    {
        return nil;
    }
    NSString *dbPath = getDocumentsDirectoryWithFileName(COVERLAYERDBNAME);
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return nil;
    }
    
    __block BBCoverLayerClass *coverLayer = nil;
    
    __block BOOL result = NO;
    [queue inDatabase:^(FMDatabase *coverLayerDB) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE coverLayer = '%@'", COVERLAYERDBTABLENAME, coverLayerKey];
        
        FMResultSet *rs = [coverLayerDB executeQuery:sql];
        if ([rs next])
        {
            coverLayer = [[BBCoverLayerClass alloc] init];
            if (coverLayer != nil)
            {
                coverLayer.m_CoverLayerKey = coverLayerKey;
                coverLayer.m_AppVersion = [rs stringForColumn:@"appVersion"];
                coverLayer.m_IsShow = [rs boolForColumn:@"isShow"];
                
                if (![coverLayerDB hadError])
                {
                    result = YES;
                }
            }
        }
        
        [rs close];
    }];
    
    
    if (result)
    {
        return coverLayer;
    }
    else
    {
        return nil;
    }
}

+ (BBCoverLayerClass *)getCoverLayerClass:(NSString *)coverLayerKey withIsShow:(BOOL)isShow
{
    BBCoverLayerClass *cover = [[BBCoverLayerClass alloc]init];
    cover.m_AppVersion = [BBAppInfo getCurrentVersion];
    cover.m_CoverLayerKey = coverLayerKey;
    cover.m_IsShow  = isShow;
    return cover;
}

+(NSString *)getGuideImageName:(NSString*)guideKey
{
    if ([guideKey isEqualToString:GUIDE_SHOW_HOME_PAGE])
    {
        if (DEVICE_HEIGHT>480)
        {
          return @"mainPageGuide-1136";
        }
        return @"mainPageGuide-960";
    }
    else if([guideKey isEqualToString:ENABLE_SHOW_TAXI_MAINHOME_PAGE])
    {
        return @"taxihomePageGuide";
    }
    else if([guideKey isEqualToString:GUIDE_SHOW_TOPIC_PAGE])
    {
        return @"topicListGuide";
    }
    else if([guideKey isEqualToString:ENABLE_SHOW_TOPIC_PAGE])
    {
        return @"topicDetailGuide";
    }
    return nil;
}

@end
