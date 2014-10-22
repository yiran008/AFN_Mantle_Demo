//
//  NoticeUtil.h
//  pregnancy
//
//  Created by 柏旭 肖 on 12-5-29.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeUtil : NSObject
+ (void)initNotice;
+ (BOOL)isNoticeOn;
+ (void)setNoticeFlag:(BOOL)flag;
+ (NSInteger)getNoticeTime;
+ (void)setNoticeTime:(NSInteger)time;
+ (void)cancelAllNotice;
+ (void)resetLocalNoticeWithNoticeTime:(NSInteger)time;

+(void)registerCustomLocationNoti:(NSString*)notiContent withNotiInfoName:(NSString*)notiName withNotiDate:(NSDate*)notiDate;
+(void)cancelCustomLocationNoti:(NSString*)noticeKey;

+(BOOL)isRegisterLocationNotice:(NSString*)noticeInfo;

//清除老版本 本地关爱提醒
+(void)cancelCareRemindLocationNoti;

//清除新版本 本地关爱提醒
+(void)cancelNewCareRemindLocationNoti;

//添加新的关爱提醒
+ (void)resetNewRemindLocalNotifications;

//添加孕42周，育儿召回本地提醒
+ (void)registerBBRecallParentLocalNotification;

//添加孕38周，育儿版切换本地提醒
+ (void)registerBBCutParentLocalNotification;
@end
