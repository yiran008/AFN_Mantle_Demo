//
//  RefreshTopicCallBack.h
//  pregnancy
//
//  Created by babytree babytree on 12-4-17.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RefreshTopicCallBack <NSObject>
- (void)refreshCallBack:(NSString *)count;
@optional
- (void)refreshCallBackWithTitle:(NSString *)title GroupID:(NSString *)goupID isJoined:(BOOL)isJoined;
@end
