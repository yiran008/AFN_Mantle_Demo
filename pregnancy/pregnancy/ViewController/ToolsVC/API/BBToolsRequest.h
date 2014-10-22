//
//  BBToolsRequest.h
//  pregnancy
//
//  Created by liumiao on 4/25/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest+BBDebug.h"
#import "BBConfigureAPI.h"
#import "BBUser.h"

@interface BBToolsRequest : NSObject

+ (ASIFormDataRequest *)getToolsListRequest:(NSString*)type;

@end
