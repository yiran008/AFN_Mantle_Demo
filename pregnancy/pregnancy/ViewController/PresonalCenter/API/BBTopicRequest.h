//
//  BBTopicManagement.h
//  pregnancy
//
//  Created by Jun Wang on 12-3-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest+BBDebug.h"
#import "BBConfigureAPI.h"
#import "BBTimeUtility.h"

@interface BBTopicRequest : NSObject

+ (ASIFormDataRequest *)getCollectTopic:(NSString *)pages;

+ (ASIFormDataRequest *)uploadIcon:(NSData *)imageData withLoginString:(NSString *)loginString;

//收藏的知识列表
+ (ASIFormDataRequest *)getCollectKnowledge:(NSString *)pages;

@end
