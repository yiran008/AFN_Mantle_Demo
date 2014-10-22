//
//  BBPregnancyMap.h
//  pregnancy
//
//  Created by MacBook on 14-8-5.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBPregnancyMap : NSObject

- (void)addPregnancyMapValue:(id<NSObject>)value forKey:(NSString *)key;

- (NSString *)sortDictOrderbyAlphabet;

@end
