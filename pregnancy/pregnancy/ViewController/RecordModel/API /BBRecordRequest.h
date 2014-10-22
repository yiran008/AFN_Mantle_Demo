//
//  BBRecordRequest.h
//  pregnancy
//
//  Created by whl on 13-9-22.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordConfig.h"

@interface BBRecordRequest : NSObject

//发表记录API
+ (ASIFormDataRequest *)publishRecord:(NSString *)recordContent withRecodTimes:(NSString *)recordTimes withPhotoData:(NSData *)imageData withPrivate:(NSString *)isPrivate;

//设置记录是否隐私的API
+ (ASIFormDataRequest *)setRecordPrivate:(NSString *)isPrivate withRecodID:(NSString *)recordID;

//删除记录的API
+ (ASIFormDataRequest *)deleteRecord:(NSString *)recordID;

+ (ASIFormDataRequest *)recordMoon:(NSString *)timeTs withUserEncodeId:(NSString *)userEncodeId;

//我的心情的API
+ (ASIFormDataRequest *)recordMoon:(NSString *)timeTs;

//心情广场API
+ (ASIFormDataRequest *)recordPark:(NSString *)start;
@end
