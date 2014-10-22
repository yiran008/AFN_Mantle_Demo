//
//  BBRecordAFRequest.h
//  pregnancy
//
//  Created by heyanyang on 2014年9月28日 星期日.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBRecordAFRequest : NSObject
//我的心情
+ (NSURLSessionDataTask *)recordMoonWithTime:(NSString *)timeTs theBlock:(void (^)(id jsonData, NSError *error))block;
//someone的心情
+ (NSURLSessionDataTask *)recordMoonWithTime:(NSString *)timeTs withUserEncodeId:(NSString *)userEncodeId theBlock:(void (^)(id jsonData, NSError *error))block;

@end
