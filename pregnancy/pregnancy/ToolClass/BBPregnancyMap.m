//
//  BBPregnancyMap.m
//  pregnancy
//
//  Created by MacBook on 14-8-5.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBPregnancyMap.h"
#import "NSString+MD5.h"
#import "EncodeAPI.h"

@implementation BBPregnancyMap
{
    NSMutableDictionary *pregnancyMapDic;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        pregnancyMapDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addPregnancyMapValue:(id<NSObject>)value forKey:(NSString *)key
{
    if (![key isNotEmpty])
    {
        return;
    }
    
   // 不保存secret对应的键值对
    if([key isEqualToString:@"secret"])
    {
        return;
    }
    
    if (!pregnancyMapDic)
    {
        pregnancyMapDic = [[NSMutableDictionary alloc] init];
    }
    
    NSObject *object = (NSObject *)value;

    if (![object isNotEmpty])
    {
        value = @"";
    }

    [pregnancyMapDic setValue:value forKey:key];
}

// 对字典中的数据按照key的字母顺序排序
- (NSString *)sortDictOrderbyAlphabet
{
    NSMutableString *value = [NSMutableString stringWithString:@""];

    NSArray* keyArray = [pregnancyMapDic allKeys];
    keyArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    [value appendString:[NSString stringWithFormat:@"%@&",[pregnancyMapDic stringForKey:@"local_ts" defaultString:@""]]];
    for (NSString *key in keyArray)
    {
        if (![key isEqualToString:@"local_ts"]) {
            [value appendString:[NSString stringWithFormat:@"%@=%@&",key,[pregnancyMapDic stringForKey:key defaultString:@""]]];
        }
    }
    return [EncodeAPI encode:value];
}

@end
