//
//  BBUpdataManger.h
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBUpdataManger : NSObject
+ (BBUpdataManger *)sharedManager;
- (void)startUpdate;

//删除历史数据库相关文件和文件夹内容
- (void)removeKnowledgeDirectory;
@end
