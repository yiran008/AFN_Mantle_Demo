//
//  BBMusicDB.h
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-15.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#define dataBasePath [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:dataBaseName]
#define dataBaseName @"musicDatabase.sqlite"

@interface BBMusicDB : NSObject

+ (FMDatabase *)createDataBase;


/**
 *	@brief	关闭数据库
 */
+ (void)closeDataBase;

/**
 *	@brief	判断表是否存在
 *
 *	@param 	tableName 	表明
 *
 *	@return	创建是否成功
 */
+ (BOOL) isTableExist:(NSString *)tableName;


/**
 *	@brief	创建所有表
 *
 *	@return
 */

+ (BOOL)insertMusicWithDic:(NSDictionary *)musicDic;

+ (NSMutableArray *)getMusicList;

+ (NSMutableArray *)getDownLoadMusic;

+ (NSMutableArray *)getLocalMusic;

+ (NSDictionary *)getMusicWithID:(NSString *)musicid;

+ (NSMutableArray *)getDownLoadMusicWithCategoryID:(NSString *)categoryid;

+ (BOOL)deleteMusicWithID:(NSString *)musicid;

+ (BOOL)setDownloadStauts:(int)downloadStatus withMusicID:(NSString *)musicid;
+ (BOOL)setFileSize:(long long)fileSize withMusicID:(NSString *)musicid;

@end
