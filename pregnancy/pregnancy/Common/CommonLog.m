//
//  CommonLog.m
//  
//
//  Created by Dengjiang on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonLog.h"
#import "ARCHelper.h"

@implementation CommonLog

+ (void)file:(char*)sourceFile function:(char*)functionName lineNumber:(NSInteger)lineNumber format:(NSString*)format, ...
{
    va_list ap;
    NSString *print, *file, *function;
    
    va_start(ap,format);
    
    file = [[NSString alloc] initWithBytes: sourceFile length: strlen(sourceFile) encoding: NSUTF8StringEncoding];
    function = [NSString stringWithUTF8String:functionName];
    print = [[NSString alloc] initWithFormat: format arguments: ap];
    
    va_end(ap);
    
    NSLog(@"%@:%ld %@; %@", [file lastPathComponent], (long)lineNumber, function, print);
    
    [print ah_autorelease];
    
    [file ah_autorelease];
}

+ (void)sfile:(char*)sourceFile lineNumber:(NSInteger)lineNumber format:(NSString*)format, ...
{
    va_list ap;
    NSString *print, *file;
    
    va_start(ap,format);
    
    file = [[NSString alloc] initWithBytes: sourceFile length: strlen(sourceFile) encoding: NSUTF8StringEncoding];
    print = [[NSString alloc] initWithFormat: format arguments: ap];
    
    va_end(ap);
    
    NSLog(@"%@[%ld] %@", [file lastPathComponent], (long)lineNumber, print);
    
    [print ah_autorelease];
    [file ah_autorelease];
}

@end
