//
//  BBKnowledgeCreateTool.h
//  pregnancy
//
//  Created by liumiao on 7/15/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBKnowledgeCreateTool : NSObject
//发版前使用来生成数据库的方法，发版后绝对不要调用
+ (void)createKnowledgeDB;
@end
