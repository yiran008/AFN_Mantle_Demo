//
//  DraftBoxDB.m
//  DraftBox
//
//  Created by mac on 13-4-11.
//  Copyright (c) 2013年 DJ. All rights reserved.
//

#if COMMON_USE_DRATFBOX

#import "HMDraftBoxDB.h"
#import "FMDB.h"
#import "HMDBVersionCheck.h"

// isSending 发送中
static NSString *draftBoxDBName = @"draftBox.db";
static NSString *draftBoxDBTableName = @"draftMessages";
static NSString *draftBoxDBTableContent =
    @"userId text, timestr text, timetmp double, \
    group_name text, group_id text, title text, content text, \
    isReply integer, topic_id text, floor text, replyrefer_id text, \
    photo_id1 text, photo_data1 blob, \
    photo_id2 text, photo_data2 blob, \
    photo_id3 text, photo_data3 blob, \
    photo_id4 text, photo_data4 blob, \
    photo_id5 text, photo_data5 blob, \
    photo_id6 text, photo_data6 blob, \
    photo_id7 text, photo_data7 blob, \
    photo_id8 text, photo_data8 blob, \
    photo_id9 text, photo_data9 blob, \
    sendStatus integer, isSent integer, isSending integer, \
    extra1 text, extra2 text, extra3 text";

static NSString *draftBoxDBTableInsert =
    @"(userId, timestr, timetmp, \
    group_name, group_id, title, content, \
    isReply, topic_id, floor, replyrefer_id, \
    photo_id1, photo_data1, \
    photo_id2, photo_data2, \
    photo_id3, photo_data3, \
    photo_id4, photo_data4, \
    photo_id5, photo_data5, \
    photo_id6, photo_data6, \
    photo_id7, photo_data7, \
    photo_id8, photo_data8, \
    photo_id9, photo_data9, \
    sendStatus, isSent, isSending, \
    extra1, extra2, extra3) \
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

static NSString *draftBoxDBTableModifyAllPic =
    @"photo_id1 = ?, photo_data1 = ?, \
    photo_id2 = ?, photo_data2 = ?, \
    photo_id3 = ?, photo_data3 = ?, \
    photo_id4 = ?, photo_data4 = ?, \
    photo_id5 = ?, photo_data5 = ?, \
    photo_id6 = ?, photo_data6 = ?, \
    photo_id7 = ?, photo_data7 = ?, \
    photo_id8 = ?, photo_data8 = ?, \
    photo_id9 = ?, photo_data9 = ?";

@implementation HMDraftBoxPic
@synthesize m_Photo_id;
@synthesize m_Photo_data;

- (BOOL)m_IsUpload
{
    if ([m_Photo_id isNotEmpty])
    {
        return YES;
    }
    
    return NO;
}

@end

@implementation HMDraftBoxData
@synthesize m_Timetmp;
@synthesize m_UserId;
//@synthesize m_UserLogin_String;
@synthesize m_GroupName;
@synthesize m_Group_id;

@synthesize m_Title;
@synthesize m_Content;

@synthesize m_HelpMark;

@synthesize m_IsReply;

@synthesize m_Topic_id;
@synthesize m_Floor;
@synthesize m_ReplyRefer_id;

@synthesize m_SendStatus;
@synthesize m_IsSent;

@synthesize m_PicArray;

@synthesize m_ShareType;
@synthesize m_ShareUrl;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.m_Timetmp = [NSDate date];
        m_HelpMark = NO;
        m_IsReply = NO;
        m_IsSent = NO;
        m_SendStatus = DraftBoxStatus_NotSend;
        self.m_PicArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        return self;
    }
    
    return nil;
}


@end

@implementation HMDraftBoxDB

+ (BOOL)createDraftBoxDBWithTableName:(NSString *)tableName content:(NSString *)content
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:draftBoxDBName];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open])
    {
        return NO;
    }
    
    // 创建Table
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE if not exists %@ (%@)", tableName, content];
    [db executeUpdate:sql];
    
    if ([db hadError])
    {
        NSLog(@"DraftBoxDB draftBoxPicListName:%@ Error %d: %@", tableName, [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return NO;
    }
    
    [db close];
    [HMDBVersionCheck setDraftBox_DBVer];
    return YES;
}

+ (BOOL)createDraftBoxDB
{
    // 草稿箱
    if (![HMDraftBoxDB createDraftBoxDBWithTableName:draftBoxDBTableName content:draftBoxDBTableContent])
    {
        return NO;
    }
    
    if (![HMDraftBoxDB clearDraftBoxDB])
    {
        return NO;
    }
    
    return [HMDraftBoxDB clearDraftBoxDBSendingState];
}

// 清空表
+ (BOOL)deleteDraftBoxDB
{
    NSString *dbPath = getDocumentsDirectoryWithFileName(draftBoxDBName);
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open])
    {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", draftBoxDBTableName];
    if (![db executeUpdate:sql])
    {
        NSLog(@"DraftBoxDB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        
        return NO;
    }
        
    [db close];
    
    return YES;
}


#pragma mark -
#pragma mark 草稿箱

+ (BOOL)insertDraftBoxDB:(HMDraftBoxData *)draftData
{
    if (draftData.m_IsSent)
    {
        // 已发送的不再操作
        return NO;
    }
    
    NSString *dbPath = getDocumentsDirectoryWithFileName(draftBoxDBName);

    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return NO;
    }
    
    __block BOOL result = NO;

    [queue inDatabase:^(FMDatabase *draftDB) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userId = '%@' AND timestr = '%@'", draftBoxDBTableName, draftData.m_UserId, [NSDate stringFromDate:draftData.m_Timetmp]];
        // 查找是否已有
        FMResultSet *rs = [draftDB executeQuery:sql];
        // 判断没有
        if (![rs next])
        {
            sql = [NSString stringWithFormat:@"INSERT INTO %@ %@", draftBoxDBTableName, draftBoxDBTableInsert];
            NSString *photo_id1 = nil;
            NSData *photo_data1 = nil;
            if (draftData.m_PicArray.count >= 1)
            {
                HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:0];
                photo_id1 = draftBoxPic.m_Photo_id;
                photo_data1 = draftBoxPic.m_Photo_data;
            }
            NSString *photo_id2 = nil;
            NSData *photo_data2 = nil;
            if (draftData.m_PicArray.count >= 2)
            {
                HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:1];
                photo_id2 = draftBoxPic.m_Photo_id;
                photo_data2 = draftBoxPic.m_Photo_data;
            }
            NSString *photo_id3 = nil;
            NSData *photo_data3 = nil;
            if (draftData.m_PicArray.count >= 3)
            {
                HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:2];
                photo_id3 = draftBoxPic.m_Photo_id;
                photo_data3 = draftBoxPic.m_Photo_data;
            }
            NSString *photo_id4 = nil;
            NSData *photo_data4 = nil;
            if (draftData.m_PicArray.count >= 4)
            {
                HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:3];
                photo_id4 = draftBoxPic.m_Photo_id;
                photo_data4 = draftBoxPic.m_Photo_data;
            }
            NSString *photo_id5 = nil;
            NSData *photo_data5 = nil;
            if (draftData.m_PicArray.count >= 5)
            {
                HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:4];
                photo_id5 = draftBoxPic.m_Photo_id;
                photo_data5 = draftBoxPic.m_Photo_data;
            }
            NSString *photo_id6 = nil;
            NSData *photo_data6 = nil;
            if (draftData.m_PicArray.count >= 6)
            {
                HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:5];
                photo_id6 = draftBoxPic.m_Photo_id;
                photo_data6 = draftBoxPic.m_Photo_data;
            }
            NSString *photo_id7 = nil;
            NSData *photo_data7 = nil;
            if (draftData.m_PicArray.count >= 7)
            {
                HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:6];
                photo_id7 = draftBoxPic.m_Photo_id;
                photo_data7 = draftBoxPic.m_Photo_data;
            }
            NSString *photo_id8 = nil;
            NSData *photo_data8 = nil;
            if (draftData.m_PicArray.count >= 8)
            {
                HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:7];
                photo_id8 = draftBoxPic.m_Photo_id;
                photo_data8 = draftBoxPic.m_Photo_data;
            }
            NSString *photo_id9 = nil;
            NSData *photo_data9 = nil;
            if (draftData.m_PicArray.count >= 9)
            {
                HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:8];
                photo_id9 = draftBoxPic.m_Photo_id;
                photo_data9 = draftBoxPic.m_Photo_data;
            }

            NSString *helpMark = draftData.m_HelpMark ? @"YES" : @"NO";

            result = [draftDB executeUpdate:sql,
                      draftData.m_UserId,
                      [NSDate stringFromDate:draftData.m_Timetmp],
                      draftData.m_Timetmp,
                      draftData.m_GroupName,
                      draftData.m_Group_id,
                      draftData.m_Title,
                      draftData.m_Content,
                      [NSNumber numberWithBool:draftData.m_IsReply],
                      draftData.m_Topic_id,
                      draftData.m_Floor,
                      draftData.m_ReplyRefer_id,
                      photo_id1,
                      photo_data1,
                      photo_id2,
                      photo_data2,
                      photo_id3,
                      photo_data3,
                      photo_id4,
                      photo_data4,
                      photo_id5,
                      photo_data5,
                      photo_id6,
                      photo_data6,
                      photo_id7,
                      photo_data7,
                      photo_id8,
                      photo_data8,
                      photo_id9,
                      photo_data9,
                      [NSNumber numberWithInteger:draftData.m_SendStatus],
                      [NSNumber numberWithBool:draftData.m_IsSent],
                      [NSNumber numberWithBool:NO],
                      helpMark,
                      nil, nil
                      ];
        }
        
        [rs close];
    }];
    
    return result;
}


#pragma mark 草稿箱 修改

+ (BOOL)modifyDraftBoxDB:(HMDraftBoxData *)draftData
{
    BOOL result = NO;
    
    result = [self modifyDraftBoxDBText:draftData];
    
    if (!result)
    {
        return NO;
    }
    
    result = [self modifyDraftBoxDBAllPic:draftData];
    
    return result;
}

+ (BOOL)modifyDraftBoxDBText:(HMDraftBoxData *)draftData
{
    if (draftData.m_IsSent)
    {
        // 已发送的不再操作
        return NO;
    }
    
    NSString *dbPath = getDocumentsDirectoryWithFileName(draftBoxDBName);
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return NO;
    }
    
    __block BOOL result = NO;
    [queue inDatabase:^(FMDatabase *draftDB) {
        NSString *helpMark = draftData.m_HelpMark ? @"YES" : @"NO";
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE userId = '%@' AND timestr = '%@'", draftBoxDBTableName, @"title = ?, content = ?, extra1 = ?", draftData.m_UserId, [NSDate stringFromDate:draftData.m_Timetmp]];
        result = [draftDB executeUpdate:sql, draftData.m_Title, draftData.m_Content, helpMark];
    }];
        
    return result;
}

+ (BOOL)modifyDraftBoxDBAllPic:(HMDraftBoxData *)draftData
{
    if (draftData.m_IsSent)
    {
        // 已发送的不再操作
        return NO;
    }
    
    NSString *dbPath = getDocumentsDirectoryWithFileName(draftBoxDBName);
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return NO;
    }
    
    __block BOOL result = NO;
    [queue inDatabase:^(FMDatabase *draftDB) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE userId = '%@' AND timestr = '%@'", draftBoxDBTableName, draftBoxDBTableModifyAllPic, draftData.m_UserId, [NSDate stringFromDate:draftData.m_Timetmp]];
        
        NSString *photo_id1 = nil;
        NSData *photo_data1 = nil;
        if (draftData.m_PicArray.count >= 1)
        {
            HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:0];
            photo_id1 = draftBoxPic.m_Photo_id;
            photo_data1 = draftBoxPic.m_Photo_data;
        }
        NSString *photo_id2 = nil;
        NSData *photo_data2 = nil;
        if (draftData.m_PicArray.count >= 2)
        {
            HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:1];
            photo_id2 = draftBoxPic.m_Photo_id;
            photo_data2 = draftBoxPic.m_Photo_data;
        }
        NSString *photo_id3 = nil;
        NSData *photo_data3 = nil;
        if (draftData.m_PicArray.count >= 3)
        {
            HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:2];
            photo_id3 = draftBoxPic.m_Photo_id;
            photo_data3 = draftBoxPic.m_Photo_data;
        }
        NSString *photo_id4 = nil;
        NSData *photo_data4 = nil;
        if (draftData.m_PicArray.count >= 4)
        {
            HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:3];
            photo_id4 = draftBoxPic.m_Photo_id;
            photo_data4 = draftBoxPic.m_Photo_data;
        }
        NSString *photo_id5 = nil;
        NSData *photo_data5 = nil;
        if (draftData.m_PicArray.count >= 5)
        {
            HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:4];
            photo_id5 = draftBoxPic.m_Photo_id;
            photo_data5 = draftBoxPic.m_Photo_data;
        }
        NSString *photo_id6 = nil;
        NSData *photo_data6 = nil;
        if (draftData.m_PicArray.count >= 6)
        {
            HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:5];
            photo_id6 = draftBoxPic.m_Photo_id;
            photo_data6 = draftBoxPic.m_Photo_data;
        }
        NSString *photo_id7 = nil;
        NSData *photo_data7 = nil;
        if (draftData.m_PicArray.count >= 7)
        {
            HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:6];
            photo_id7 = draftBoxPic.m_Photo_id;
            photo_data7 = draftBoxPic.m_Photo_data;
        }
        NSString *photo_id8 = nil;
        NSData *photo_data8 = nil;
        if (draftData.m_PicArray.count >= 8)
        {
            HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:7];
            photo_id8 = draftBoxPic.m_Photo_id;
            photo_data8 = draftBoxPic.m_Photo_data;
        }
        NSString *photo_id9 = nil;
        NSData *photo_data9 = nil;
        if (draftData.m_PicArray.count >= 9)
        {
            HMDraftBoxPic *draftBoxPic = [draftData.m_PicArray objectAtIndex:8];
            photo_id9 = draftBoxPic.m_Photo_id;
            photo_data9 = draftBoxPic.m_Photo_data;
        }

        result = [draftDB executeUpdate:sql,
                      photo_id1,
                      photo_data1,
                      photo_id2,
                      photo_data2,
                      photo_id3,
                      photo_data3,
                      photo_id4,
                      photo_data4,
                      photo_id5,
                      photo_data5,
                      photo_id6,
                      photo_data6,
                      photo_id7,
                      photo_data7,
                      photo_id8,
                      photo_data8,
                      photo_id9,
                      photo_data9
                  ];
    }];
    
    return result;
}

+ (BOOL)modifyDraftBoxDBOnePic:(HMDraftBoxData *)draftData atindex:(NSInteger)index
{
    if (draftData.m_IsSent)
    {
        // 已发送的不再操作
        return NO;
    }
    
    if (index < 0 || index >= draftData.m_PicArray.count)
    {
        return NO;
    }
    
    NSString *dbPath = getDocumentsDirectoryWithFileName(draftBoxDBName);
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return NO;
    }
    
    HMDraftBoxPic *draftPic = [draftData.m_PicArray objectAtIndex:index];
    
    __block BOOL result = NO;
    [queue inDatabase:^(FMDatabase *draftDB) {
        NSString *modifyString = nil;
        switch (index)
        {
            case 0:
                modifyString = @"photo_id1 = ?, photo_data1 = ?";
                break;
                
            case 1:
                modifyString = @"photo_id2 = ?, photo_data2 = ?";
                break;
                
            case 2:
                modifyString = @"photo_id3 = ?, photo_data3 = ?";
                break;
                
            case 3:
                modifyString = @"photo_id4 = ?, photo_data4 = ?";
                break;
                
            case 4:
                modifyString = @"photo_id5 = ?, photo_data5 = ?";
                break;
                
            case 5:
                modifyString = @"photo_id6 = ?, photo_data6 = ?";
                break;
                
            case 6:
                modifyString = @"photo_id7 = ?, photo_data7 = ?";
                break;
                
            case 7:
                modifyString = @"photo_id8 = ?, photo_data8 = ?";
                break;
                
            case 8:
                modifyString = @"photo_id9 = ?, photo_data9 = ?";
                break;
                
            default:
                return;
        }

        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE userId = '%@' AND timestr = '%@'", draftBoxDBTableName, modifyString, draftData.m_UserId, [NSDate stringFromDate:draftData.m_Timetmp]];
        
        
        result = [draftDB executeUpdate:sql, draftPic.m_Photo_id, draftPic.m_Photo_data];
    }];
    
    return result;
}


#pragma mark 草稿箱 删除

+ (BOOL)removeDraftBoxDB:(HMDraftBoxData *)draftData
{
    NSString *dbPath = getDocumentsDirectoryWithFileName(draftBoxDBName);
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return NO;
    }
    
    __block BOOL result = NO;
    [queue inDatabase:^(FMDatabase *draftDB) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE userId = '%@' AND timestr = '%@'", draftBoxDBTableName, draftData.m_UserId, [NSDate stringFromDate:draftData.m_Timetmp]];
        result = [draftDB executeUpdate:sql];
    }];
    
    return result;
}

// 删除发送过的
+ (BOOL)clearDraftBoxDB
{
    NSString *dbPath = getDocumentsDirectoryWithFileName(draftBoxDBName);
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return NO;
    }
    
    __block BOOL result = YES;
    [queue inDatabase:^(FMDatabase *draftDB) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE isSent = ?", draftBoxDBTableName];
            result = [draftDB executeUpdate:sql, [NSNumber numberWithBool:YES]];
    }];
    
    return result;
}

+ (BOOL)clearDraftBoxDBSendingState
{
    NSString *dbPath = getDocumentsDirectoryWithFileName(draftBoxDBName);
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return NO;
    }
    
    __block BOOL result = NO;
    [queue inDatabase:^(FMDatabase *draftDB) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET isSending = '0' WHERE isSending = '1'", draftBoxDBTableName];
        result = [draftDB executeUpdate:sql];
    }];
    
    return result;
}

#pragma mark 草稿箱 设置

+ (BOOL)setDraftBoxDBSend:(HMDraftBoxData *)draftData
{
    return [HMDraftBoxDB setDraftBoxDBSend:draftData.m_UserId withTime:draftData.m_Timetmp];
}

+ (BOOL)setDraftBoxDBSend:(NSString *)userId withTime:(NSDate *)timetmp
{
    NSString *dbPath = getDocumentsDirectoryWithFileName(draftBoxDBName);
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return NO;
    }
    
    __block BOOL result = NO;
    [queue inDatabase:^(FMDatabase *draftDB) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE userId = '%@' AND timestr = '%@'", draftBoxDBTableName, @"isSending = '0', sendStatus = ?, isSent = '1'", userId, [NSDate stringFromDate:timetmp]];
        result = [draftDB executeUpdate:sql, [NSNumber numberWithInteger:DraftBoxStatus_SendTextSucceed]];
    }];
    
    return result;
}

+ (BOOL)setDraftBoxDB:(HMDraftBoxData *)draftData withStatus:(HMDraftBoxSendStatus)status
{
    draftData.m_SendStatus = status;
    if (draftData.m_SendStatus >= DraftBoxStatus_SendTextSucceed)
    {
        draftData.m_IsSent = YES;
        
        return [HMDraftBoxDB setDraftBoxDBSend:draftData.m_UserId withTime:draftData.m_Timetmp];
    }
    else
    {
        draftData.m_IsSent = NO;
    }
    

    NSString *dbPath = getDocumentsDirectoryWithFileName(draftBoxDBName);
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return NO;
    }
    
    __block BOOL result = NO;
    [queue inDatabase:^(FMDatabase *draftDB) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE userId = '%@' AND timestr = '%@'", draftBoxDBTableName, @"sendStatus = ?, isSent = ?", draftData.m_UserId, [NSDate stringFromDate:draftData.m_Timetmp]];

        result = [draftDB executeUpdate:sql, [NSNumber numberWithInteger:draftData.m_SendStatus], [NSNumber numberWithBool:draftData.m_IsSent]];
    }];
    
    return result;
}

+ (BOOL)setDraftBoxDB:(HMDraftBoxData *)draftData isSending:(BOOL)isSending
{
    return [self setDraftBoxDB:draftData.m_UserId withTime:draftData.m_Timetmp isSending:isSending];
}

+ (BOOL)setDraftBoxDB:(NSString *)userId withTime:(NSDate *)timetmp isSending:(BOOL)isSending
{
    NSString *dbPath = getDocumentsDirectoryWithFileName(draftBoxDBName);
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return NO;
    }
    
    __block BOOL result = NO;
    [queue inDatabase:^(FMDatabase *draftDB) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE userId = '%@' AND timestr = '%@'", draftBoxDBTableName, @"isSending = ?", userId, [NSDate stringFromDate:timetmp]];
        result = [draftDB executeUpdate:sql, [NSNumber numberWithBool:isSending]];
    }];
    
    return result;
}


#pragma mark 草稿箱 获取数据
+ (NSArray *)getDraftBoxDBSendList:(NSString *)userId isSending:(BOOL)isSending
{
    return [self getDraftBoxDBSendList:userId getAll:NO isSending:isSending];
}

+ (NSArray *)getDraftBoxDBSendList:(NSString *)userId
{
    return [self getDraftBoxDBSendList:userId getAll:YES isSending:NO];
}

+ (NSArray *)getDraftBoxDBSendList:(NSString *)userId getAll:(BOOL)isAll isSending:(BOOL)isSending
{
    if (![userId isNotEmpty])
    {
        return nil;
    }
    
    NSString *dbPath = getDocumentsDirectoryWithFileName(draftBoxDBName);
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!queue)
    {
        return nil;
    }
//!!!:=====
    __block NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    [queue inDatabase:^(FMDatabase *draftDB) {
        NSString *sql;
        if (isAll)
        {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userId = '%@' AND  isSent = '0' ORDER BY timetmp DESC", draftBoxDBTableName, userId];
        }
        else
        {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userId = '%@' AND  isSent = '0' AND isSending = '%d' ORDER BY timetmp DESC", draftBoxDBTableName, userId, isSending];
        }
        
        FMResultSet *rs = [draftDB executeQuery:sql];
        while ([rs next])
        {
            HMDraftBoxData *data = [[HMDraftBoxData alloc] init];
            if (data != nil)
            {
                data.m_UserId = userId;
                data.m_Timetmp = [rs dateForColumn:@"timetmp"];
                data.m_GroupName = [rs stringForColumn:@"group_name"];
                data.m_Group_id = [rs stringForColumn:@"group_id"];
                data.m_Title = [rs stringForColumn:@"title"];
                data.m_Content = [rs stringForColumn:@"content"];
                data.m_IsReply = [rs boolForColumn:@"isReply"];
                data.m_Topic_id = [rs stringForColumn:@"topic_id"];
                data.m_Floor = [rs stringForColumn:@"floor"];
                data.m_ReplyRefer_id = [rs stringForColumn:@"replyrefer_id"];
                data.m_SendStatus = [rs intForColumn:@"sendStatus"];
                data.m_IsSent = [rs boolForColumn:@"isSent"];

                NSString *helpMark = [rs stringForColumn:@"extra1"];

                if ([helpMark isEqualToString:@"YES"])
                {
                    data.m_HelpMark = YES;
                }
                else
                {
                    data.m_HelpMark = NO;
                }

                BOOL bHave = NO;
                HMDraftBoxPic *draftPic;
                NSString *photo_id = [rs stringForColumn:@"photo_id1"];
                NSData *photo_data = [rs dataForColumn:@"photo_data1"];
                if ([photo_data isNotEmpty])
                {
                    draftPic = [[HMDraftBoxPic alloc] init];
                    if ([photo_id isNotEmpty])
                    {
                        draftPic.m_Photo_id = photo_id;
                    }
                    draftPic.m_Photo_data = photo_data;
                    
                    [data.m_PicArray addObject:draftPic];
                    
                    bHave = YES;
                }
                
                if (bHave)
                {
                    bHave = NO;
                    
                    photo_id = [rs stringForColumn:@"photo_id2"];
                    photo_data = [rs dataForColumn:@"photo_data2"];
                    if ([photo_data isNotEmpty])
                    {
                        draftPic = [[HMDraftBoxPic alloc] init];
                        if ([photo_id isNotEmpty])
                        {
                            draftPic.m_Photo_id = photo_id;
                        }
                        draftPic.m_Photo_data = photo_data;
                        
                        [data.m_PicArray addObject:draftPic];
                        
                        bHave = YES;
                    }
                }
 
                if (bHave)
                {
                    bHave = NO;
                    
                    photo_id = [rs stringForColumn:@"photo_id3"];
                    photo_data = [rs dataForColumn:@"photo_data3"];
                    if ([photo_data isNotEmpty])
                    {
                        draftPic = [[HMDraftBoxPic alloc] init];
                        if ([photo_id isNotEmpty])
                        {
                            draftPic.m_Photo_id = photo_id;
                        }
                        draftPic.m_Photo_data = photo_data;
                        
                        [data.m_PicArray addObject:draftPic];
                        
                        bHave = YES;
                    }
                }
                
                if (bHave)
                {
                    bHave = NO;
                    
                    photo_id = [rs stringForColumn:@"photo_id4"];
                    photo_data = [rs dataForColumn:@"photo_data4"];
                    if ([photo_data isNotEmpty])
                    {
                        draftPic = [[HMDraftBoxPic alloc] init];
                        if ([photo_id isNotEmpty])
                        {
                            draftPic.m_Photo_id = photo_id;
                        }
                        draftPic.m_Photo_data = photo_data;
                        
                        [data.m_PicArray addObject:draftPic];
                        
                        bHave = YES;
                    }
                }
                
                if (bHave)
                {
                    bHave = NO;
                    
                    photo_id = [rs stringForColumn:@"photo_id5"];
                    photo_data = [rs dataForColumn:@"photo_data5"];
                    if ([photo_data isNotEmpty])
                    {
                        draftPic = [[HMDraftBoxPic alloc] init];
                        if ([photo_id isNotEmpty])
                        {
                            draftPic.m_Photo_id = photo_id;
                        }
                        draftPic.m_Photo_data = photo_data;
                        
                        [data.m_PicArray addObject:draftPic];
                        
                        bHave = YES;
                    }
                }
                
                if (bHave)
                {
                    bHave = NO;
                    
                    photo_id = [rs stringForColumn:@"photo_id6"];
                    photo_data = [rs dataForColumn:@"photo_data6"];
                    if ([photo_data isNotEmpty])
                    {
                        draftPic = [[HMDraftBoxPic alloc] init];
                        if ([photo_id isNotEmpty])
                        {
                            draftPic.m_Photo_id = photo_id;
                        }
                        draftPic.m_Photo_data = photo_data;
                        
                        [data.m_PicArray addObject:draftPic];
                        
                        bHave = YES;
                    }
                }
                
                if (bHave)
                {
                    bHave = NO;
                    
                    photo_id = [rs stringForColumn:@"photo_id7"];
                    photo_data = [rs dataForColumn:@"photo_data7"];
                    if ([photo_data isNotEmpty])
                    {
                        draftPic = [[HMDraftBoxPic alloc] init];
                        if ([photo_id isNotEmpty])
                        {
                            draftPic.m_Photo_id = photo_id;
                        }
                        draftPic.m_Photo_data = photo_data;
                        
                        [data.m_PicArray addObject:draftPic];
                        
                        bHave = YES;
                    }
                }
                
                if (bHave)
                {
                    bHave = NO;
                    
                    photo_id = [rs stringForColumn:@"photo_id8"];
                    photo_data = [rs dataForColumn:@"photo_data8"];
                    if ([photo_data isNotEmpty])
                    {
                        draftPic = [[HMDraftBoxPic alloc] init];
                        if ([photo_id isNotEmpty])
                        {
                            draftPic.m_Photo_id = photo_id;
                        }
                        draftPic.m_Photo_data = photo_data;
                        
                        [data.m_PicArray addObject:draftPic];
                        
                        bHave = YES;
                    }
                }
                
                if (bHave)
                {
                    photo_id = [rs stringForColumn:@"photo_id9"];
                    photo_data = [rs dataForColumn:@"photo_data9"];
                    if ([photo_data isNotEmpty])
                    {
                        draftPic = [[HMDraftBoxPic alloc] init];
                        if ([photo_id isNotEmpty])
                        {
                            draftPic.m_Photo_id = photo_id;
                        }
                        draftPic.m_Photo_data = photo_data;
                        
                        [data.m_PicArray addObject:draftPic];
                    }
                }
                
                if (![draftDB hadError])
                {
                    [array addObject:data];
                }
            }
        }

        [rs close];
    }];
    
    return array;
}

@end


#endif

