//
//  BBAreaDB.m
//  pregnancy
//
//  Created by babytree babytree on 12-4-11.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBAreaDB.h"
#import "FMDatabase.h"
#import "BBTopicDB.h"

@implementation BBAreaDB

+ (NSMutableArray *)provinceList{
    NSMutableArray *provinceList = [[[NSMutableArray alloc] init] autorelease];
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"location.db" ofType:nil];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return provinceList;
    }
    FMResultSet *resultSet = [db executeQuery:@"select * from china_location_utf8 where type='province'"];
    while ([resultSet next]) {
        NSMutableDictionary *province = [[[NSMutableDictionary alloc] init] autorelease];
        [province setObject:[BBTopicDB checkNil:[resultSet stringForColumn:@"longname"]] forKey:@"province_name"];
        [province setObject:[BBTopicDB checkNil:[resultSet stringForColumn:@"id"]] forKey:@"province_code"];
        [provinceList addObject:province];
    }
    [resultSet close];
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return provinceList;
    }
    [db close];
    return provinceList;
    
}

+ (NSMutableArray *)cityList:(NSString*)provinceCode{
    
    NSMutableArray *cityList = [[[NSMutableArray alloc] init] autorelease];
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"location.db" ofType:nil];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return cityList;
    }
    FMResultSet *resultSet = [db executeQuery:@"select * from china_location_utf8 where province=?",provinceCode];
    while ([resultSet next]) {
        NSMutableDictionary *city = [[[NSMutableDictionary alloc] init] autorelease];
        [city setObject:[BBTopicDB checkNil:[resultSet stringForColumn:@"longname"]] forKey:@"name"];
        [city setObject:[BBTopicDB checkNil:[resultSet stringForColumn:@"name"]] forKey:@"shortname"];
        [city setObject:[BBTopicDB checkNil:[resultSet stringForColumn:@"id"]] forKey:@"id"];
        [city setObject:[BBTopicDB checkNil:[resultSet stringForColumn:@"province"]] forKey:@"province_id"];
        [city setObject:[BBTopicDB checkNil:[resultSet stringForColumn:@"type"]] forKey:@"type"];
        [cityList addObject:city];
    }
    [resultSet close];
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return cityList;
    }
    [db close];
    return cityList;
}

+ (NSMutableArray *)provinceAndCityList{
    NSArray *info = [NSArray arrayWithObjects:@"北京",@"上海",@"广州",@"深圳",@"天津",@"重庆",@"青岛",@"成都",@"南京",@"杭州", nil];
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"location.db" ofType:nil];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return list;
    }
    int size = [info count];
    for (int i=0; i<size; i++) {
        FMResultSet *resultSet = [db executeQuery:@"select * from china_location_utf8 where name=?",[info objectAtIndex:i]];
        while ([resultSet next]) {
            NSMutableDictionary *city = [[[NSMutableDictionary alloc] init] autorelease];
            [city setObject:[BBTopicDB checkNil:[resultSet stringForColumn:@"name"]] forKey:@"name"];
            [city setObject:[BBTopicDB checkNil:[resultSet stringForColumn:@"id"]] forKey:@"id"];
            [city setObject:[BBTopicDB checkNil:[resultSet stringForColumn:@"type"]] forKey:@"type"];
            [city setObject:[BBTopicDB checkNil:[resultSet stringForColumn:@"name"]] forKey:@"shortname"];
            [list addObject:city];
        }
        [resultSet close];
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            [db close];
            return list;
        }
    }
    NSMutableDictionary *city = [[[NSMutableDictionary alloc] init] autorelease];
    [city setObject:@"更多的地区" forKey:@"name"];
    [city setObject:@"" forKey:@"id"];
    [city setObject:@"province" forKey:@"type"];
    [list addObject:city];
    [db close];
    return list;
}

+ (NSString *)areaByCiytCode:(NSString*)cityCode{
    if (cityCode==nil) {
        return nil;
    }
    NSString *province=nil;
    NSString *city=nil;
    NSString *provinceId=nil;
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"location.db" ofType:nil];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return nil;
    }
    FMResultSet *resultSet = [db executeQuery:@"select * from china_location_utf8 where id=?",cityCode];
    while ([resultSet next]) {
        city = [resultSet stringForColumn:@"longname"];
        provinceId = [resultSet stringForColumn:@"province"];
    }
    [resultSet close];
    if (provinceId!=nil) {
        FMResultSet *resultSet2 = [db executeQuery:@"select * from china_location_utf8 where id=?",provinceId];
        while ([resultSet2 next]) {
            province = [resultSet2 stringForColumn:@"longname"];
        }
        [resultSet2 close];
    }
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    if (province==nil) {
        return city;
    }
    if (city==nil) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@ %@",province,city];
}

+ (NSString *)getProvinceByCiytCode:(NSString*)cityCode{
    if (cityCode==nil) {
        return nil;
    }
    NSString *province=nil;
    NSString *provinceId=nil;
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"location.db" ofType:nil];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return nil;
    }
    FMResultSet *resultSet = [db executeQuery:@"select * from china_location_utf8 where id=?",cityCode];
    while ([resultSet next]) {
        provinceId = [resultSet stringForColumn:@"province"];
    }
    [resultSet close];
    if (provinceId!=nil) {
        FMResultSet *resultSet2 = [db executeQuery:@"select * from china_location_utf8 where id=?",provinceId];
        while ([resultSet2 next]) {
            province = [resultSet2 stringForColumn:@"longname"];
        }
        [resultSet2 close];
    }
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    return province;
}

+ (NSString *)getCityNameByCiytCode:(NSString*)cityCode {
    if (cityCode==nil) {
        return nil;
    }
    NSString *city=nil;
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"location.db" ofType:nil];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return nil;
    }
    FMResultSet *resultSet = [db executeQuery:@"select * from china_location_utf8 where id=?",cityCode];
    while ([resultSet next]) {
        city = [resultSet stringForColumn:@"longname"];
    }
    [resultSet close];
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    if (city==nil) {
        return nil;
    }
    return city;
}

+ (NSMutableArray *)queryBabyboxProvinceList
{
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"babyboxAddressDatabase" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return nil;
    }
    FMResultSet *resultSet = [db executeQuery:@"select province from babyboxAddressDatabase group by province order by id asc"];
    NSMutableArray *provinceList = [[[NSMutableArray alloc] init] autorelease];
    while ([resultSet next]) {
        [provinceList addObject:[resultSet stringForColumn:@"province"]];
    }
    [resultSet close];

    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    
    return provinceList;
}

+ (NSMutableArray *)queryBabyboxCityList:(NSString *)provinceString
{
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"babyboxAddressDatabase" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return nil;
    }
    FMResultSet *resultSet = [db executeQuery:@"select city from babyboxAddressDatabase where province = ? group by city order by id asc", provinceString];
    NSMutableArray *cityList = [[[NSMutableArray alloc] init] autorelease];
    while ([resultSet next]) {
        [cityList addObject:[resultSet stringForColumn:@"city"]];
    }
    [resultSet close];
    
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    
    return cityList;
}

+ (NSMutableArray *)queryBabyboxAreaList:(NSString *)cityString
{
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"babyboxAddressDatabase" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return nil;
    }
    FMResultSet *resultSet = [db executeQuery:@"select area from babyboxAddressDatabase where city = ?  group by area order by id asc", cityString];
    NSMutableArray *areaList = [[[NSMutableArray alloc] init] autorelease];
    while ([resultSet next]) {
        [areaList addObject:[resultSet stringForColumn:@"area"]];
    }
    [resultSet close];
    
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
        return nil;
    }
    [db close];
    
    return areaList;
}

+ (void)insertSelectedProvince:(id)object
{
    NSDictionary *objectDict = (NSDictionary*)object;
    NSMutableArray *list = [self getSelectedProvinceList];
    int size = [list count];
    BOOL flag = NO;
    for (int i=0; i<size; i++) {
        if([[objectDict stringForKey:@"province_name"]isEqualToString:[[list objectAtIndex:i] stringForKey:@"province_name"]]){
            [list removeObjectAtIndex:i];
            [list insertObject:objectDict atIndex:0];
            flag = YES;
            break;
        }
    }
    if(flag == NO){
        [list insertObject:objectDict atIndex:0];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults safeSetContainer:list forKey:@"selectedProvinceList"];
    [defaults synchronize];
}

+ (NSMutableArray *)getSelectedProvinceList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"selectedProvinceList"] !=nil){
        return [NSMutableArray arrayWithArray:[defaults objectForKey:@"selectedProvinceList"]];
    }
    return [[[NSMutableArray alloc] init] autorelease];
}

@end
