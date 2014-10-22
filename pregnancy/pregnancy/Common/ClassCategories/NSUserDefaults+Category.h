//
//  NSUserDefaults+Category.h
//  pregnancy
//
//  Created by liumiao on 14-8-20.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Category)

- (void)safeSetContainer:(id)value forKey:(NSString *)defaultName;

@end
