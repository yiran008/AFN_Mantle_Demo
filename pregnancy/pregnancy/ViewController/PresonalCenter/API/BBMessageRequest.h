//
//  BBMessageRequest.h
//  pregnancy
//
//  Created by Jun Wang on 12-4-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest+BBDebug.h"
#import "BBConfigureAPI.h"
#import "BBUser.h"

@interface BBMessageRequest : NSObject

+ (ASIFormDataRequest *)numberOfUnreadMessage;

+ (ASIFormDataRequest *)topicMsgListWithStart:(NSInteger)start withLimit:(NSInteger)limit;

+ (ASIFormDataRequest *)sendMessage:(NSString *)theUID withMessageContent:(NSString *)theMessageContent;

+ (ASIFormDataRequest *)userChatInfoUserEncodeId:(NSString *)userEncodeId withStart:(NSInteger)start withLimit:(NSInteger)limit;

+ (ASIFormDataRequest *)userChatUserList;

+ (ASIFormDataRequest *)deleteChatInfoMessages:(NSString *)messageIds;

+ (ASIFormDataRequest *)deleteUserChatUserList:(NSString *)userEncodeID;
// 点击消息链接 向服务器反馈统计
+ (ASIFormDataRequest *)uploadLogToBabytree:(NSString *)refcode;

+ (ASIFormDataRequest *)feedListwithStart:(NSInteger)page withEndTime:(NSString *)theEndTime;
@end
