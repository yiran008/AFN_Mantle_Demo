//
//  BBBaseDB.h
//  pregnancy
//
//  Created by liumiao on 9/2/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface BBBaseDB : NSObject

+ (BOOL)isDataBaseExit;
+ (BOOL)createDataBase;
+ (BOOL)deleteDataBase;
+ (NSString *)dataBasePath;

#pragma mark- 子类需要重写的方法
+ (NSString *)createTableSQL;
+ (NSString *)dataBaseName;
+ (NSString *)tableName;

@end
