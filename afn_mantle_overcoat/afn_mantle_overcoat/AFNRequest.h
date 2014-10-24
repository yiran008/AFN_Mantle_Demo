//
//  AFNRequest.h
//  afn_mantle_overcoat
//
//  Created by liumiao on 10/24/14.
//  Copyright (c) 2014 liumiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBHTTPRequestOperationManager.h"

@interface AFNRequest : NSObject

//期望加入每个API时候加入如下的方法说明，方便查看、使用、调试

/**
 *  根据用户名关键词搜索用户列表
 *
 *  @param param      参数说明
 *  @param completion afnCompletionBlock
 *
 *  @return AFHTTPRequestOperationManager
 */
+(BBHTTPRequestOperationManager*)api_UserNameSearchParam:(NSDictionary*)param completion:(AFNCompletionBlock)completion;
@end
