//
//  CommonLog.h
//  
//
//  Created by Dengjiang on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonLog : NSObject

+(void)file:(char*)sourceFile function:(char*)functionName lineNumber:(NSInteger)lineNumber format:(NSString*)format, ...;
+ (void)sfile:(char*)sourceFile lineNumber:(NSInteger)lineNumber format:(NSString*)format, ...;

#define CLog(s, ...) [CommonLog file:__FILE__ function: (char *)__FUNCTION__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]
#define SCLog(s, ...) [CommonLog sfile:__FILE__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]

@end
