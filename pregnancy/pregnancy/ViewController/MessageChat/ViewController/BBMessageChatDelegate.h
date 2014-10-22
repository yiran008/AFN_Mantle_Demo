//
//  BBMessageChatDelegate.h
//  pregnancy
//
//  Created by babytree on 12-12-25.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBMessageChatDelegate <NSObject>
- (void)addMessageId:(NSString *)messageId;
- (void)delMessageId:(NSString *)messageId;
- (void)avtarAction:(NSString *)userEncodeId;
- (void)avtarAction:(NSString *)userEncodeId userName:(NSString *)userName;
- (void)linkAction:(NSDictionary *)messageId;
@end
