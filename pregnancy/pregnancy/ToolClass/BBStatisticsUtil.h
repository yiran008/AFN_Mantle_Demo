//
//  BBStatisticsUtil.h
//  pregnancy
//
//  Created by babytree babytree on 12-8-21.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBStatisticsUtil : NSObject

+ (NSString *)getUploadData;

+ (void)clearUploadData;

+ (void)setEvent:(NSString *)event;

@end
