//
//  BBLoginAndRegisterRequest.h
//  pregnancy
//
//  Created by whl on 14-4-8.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBLoginAndRegisterRequest : NSObject

+ (ASIFormDataRequest *)loginWithEmail:(NSString *)theEmail withPassword:(NSString *)thePassword;

@end
