//
//  BBListViewDataDelegate.h
//  pregnancy
//
//  Created by babytree babytree on 12-5-11.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBListViewDataDelegate <NSObject>
//负责请求初始化
- (ASIFormDataRequest *)reload;
//负责请求成功后取出List
- (NSArray *)reloadDataSuccess:(NSDictionary *)data;
//负责请求初始化
- (ASIFormDataRequest *)loadNext;
//负责请求成功后取出List
- (NSArray *)loadNextDataSuccess:(NSDictionary *)data;
//总数并返回
- (NSInteger)loadedTotalCount:(NSDictionary *)data;
@end
