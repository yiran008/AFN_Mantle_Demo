//
//  BBNavigationLabel.h
//  pregnancy
//
//  Created by Wang Jun on 12-8-2.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBNavigationLabel : NSObject

+ (UILabel *)customNavigationLabel:(NSString *)title;
+ (UILabel *)customKnowledgeNavigationLabel:(NSString *)title;
+ (UILabel *)customNavigationLabel:(NSString *)title withWidth:(CGFloat)width;

@end
