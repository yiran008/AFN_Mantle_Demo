//
//  BBRecordAFRequest.m
//  pregnancy
//
//  Created by heyanyang on 2014年9月28日 星期日.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBRecordAFRequest.h"
#import "AFAppDotNetAPIClient.h"

@implementation BBRecordAFRequest

//我的心情
+ (NSURLSessionDataTask *)recordMoonWithTime:(NSString *)timeTs theBlock:(void (^)(id jsonData, NSError *error))block
{
    return [self recordMoonWithTime:timeTs withUserEncodeId:nil theBlock:block];
}

//someone的心情
+ (NSURLSessionDataTask *)recordMoonWithTime:(NSString *)timeTs withUserEncodeId:(NSString *)userEncodeId theBlock:(void (^)(id jsonData, NSError *error))block
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:timeTs forKey:@"last_ts"];
    [parameters setObject:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    if ([userEncodeId isNotEmpty])
    {
         [parameters setObject:userEncodeId forKey:@"enc_user_id"];
    }
    AFN_PUBLIC_PARAMS
    
    NSURLSessionDataTask *task = [[AFAppDotNetAPIClient sharedClientWithUrl:BABYTREE_API_SERVER] POST:@"/api/mobile_mood/mood_time_axis" parameters:parameters success:^(NSURLSessionDataTask * __unused task, id JSON) {
        if (block)
        {
            block(JSON, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block)
        {
            block(nil, error);
        }
    }];
    
    return task;
}

@end
