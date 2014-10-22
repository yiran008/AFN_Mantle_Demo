//
//  NSUserDefaults+Category.m
//  pregnancy
//
//  Created by liumiao on 14-8-20.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "NSUserDefaults+Category.h"

@implementation NSUserDefaults (Category)

- (void)safeSetContainer:(id)value forKey:(NSString *)defaultName
{
    if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]])
    {
        @try {
            [self setObject:value forKey:defaultName];
        }
        @catch (NSException *exception) {
#ifdef DEBUG
            NSLog(@"%@",[exception debugDescription]);
#endif
        }
    }
    else
    {
        [self setObject:value forKey:defaultName];
    }
}

@end
