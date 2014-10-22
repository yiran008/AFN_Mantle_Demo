//
//  BBHTTPHeaderADDInfo.h
//  pregnancy
//
//  Created by whl on 13-9-6.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBHTTPHeaderADDInfo : NSObject

+(NSMutableURLRequest*)addHTTPRequestHeaderInfo:(NSURL*)requestUrl;

@end
