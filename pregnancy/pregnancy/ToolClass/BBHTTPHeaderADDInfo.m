//
//  BBHTTPHeaderADDInfo.m
//  pregnancy
//
//  Created by whl on 13-9-6.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBHTTPHeaderADDInfo.h"
#import "BBPregnancyInfo.h"

@implementation BBHTTPHeaderADDInfo

+(NSMutableURLRequest*)addHTTPRequestHeaderInfo:(NSURL*)requestUrl{
    
    NSMutableURLRequest *mutableRequest = [[[NSMutableURLRequest alloc]initWithURL:requestUrl]autorelease];
    NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *versionNum =[infoDict stringForKey:@"CFBundleVersion"];
    NSString *appName =[infoDict stringForKey:@"CFBundleExecutable"];
    [mutableRequest addValue:appName forHTTPHeaderField:@"babytree-app-id"];
    [mutableRequest addValue:@"ios" forHTTPHeaderField:@"babytree-client-type"];
    [mutableRequest addValue:versionNum forHTTPHeaderField:@"babytree-app-version"];
    //http头里面传入是否备孕状态，备孕传1，其它传0
    [mutableRequest addValue:[BBUser getNewUserRoleState] == BBUserRoleStatePrepare ? @"1" : @"0"
          forHTTPHeaderField:@"babytree-app-is-prepare"];
    [mutableRequest addValue:[BBPregnancyInfo pregancyDateYMDByStringForAPI] forHTTPHeaderField:@"bpreg-brithday"];
    NSLog(@"%@", mutableRequest.allHTTPHeaderFields);
    return mutableRequest;
}
@end
