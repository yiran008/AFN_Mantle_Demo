
//
//  NoticeUtil.m
//  pregnancy
//
//  Created by 柏旭 肖 on 12-5-29.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "NoticeUtil.h"
#import "BBPregnancyInfo.h"
#import "BBKonwlegdeDB.h"
#import "BBAppInfo.h"
#import "BBBabyAgeCalculation.h"

@implementation NoticeUtil

+ (void)initNotice
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *initFlagStr = [defaults objectForKey:@"notice_init_flag"];
    if (nil == initFlagStr) {
        [self resetLocalNoticeWithNoticeTime:20];
        [self setNoticeFlag:YES];
        [self setNoticeTime:20];
        [defaults setValue:@"inited" forKey:@"notice_init_flag"];
    }
}

+ (BOOL)isNoticeOn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *flagStr = [defaults objectForKey:@"notice_switch_flag"];
    if ([flagStr isEqualToString:@"NO"] ) {
        return NO;
    }
    return YES;
}

+ (void)setNoticeFlag:(BOOL)flag
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (flag) {
        [defaults setValue:@"YES" forKey:@"notice_switch_flag"];
    }else {
        [defaults setValue:@"NO" forKey:@"notice_switch_flag"];
    }
    [defaults synchronize];
}

+ (NSInteger)getNoticeTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *time = [defaults objectForKey:@"notice_time"];
    return [time intValue];
}

+ (void)setNoticeTime:(NSInteger)time
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithInt:time] forKey:@"notice_time"];
    [defaults synchronize];
}

+ (void)cancelAllNotice
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

+ (void)resetLocalNoticeWithNoticeTime:(NSInteger)time
{
    [self cancelAllNotice];
    
//    for (NSDictionary *remindData in [BBDailyKnowledgeDB remindRecordForLocalNotification]) {
//        NSInteger pregnancyDays = [[remindData stringForKey:@"days"] integerValue];
//        
//        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//        NSDate *notifDate = [NSDate dateWithTimeInterval:-3600*24*(280-pregnancyDays+1)+time*3600 sinceDate:[BBPregnancyInfo dateOfPregnancy]];
//        NSLog(@"%@", notifDate);
//        localNotif.fireDate = notifDate;
//        localNotif.timeZone = [NSTimeZone localTimeZone];
//        NSString *tipsStr = [remindData stringForKey:@"remindText"];
//        localNotif.alertBody = [NSString stringWithFormat:@"亲，明天是您怀孕%d周，《快乐孕期》提醒您 ‘%@’", (pregnancyDays-1)/7, tipsStr];
//        localNotif.alertAction = @"查看";
//        localNotif.userInfo = remindData;
//        localNotif.soundName = UILocalNotificationDefaultSoundName;
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
//        [localNotif release];
//    }
//    
//    if ([BBAppInfo enableShowLocalNotificationSwitchParenting]) {
//
//        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//        NSDate *notifDate = [NSDate dateWithTimeInterval:3600*24*8 sinceDate:[BBPregnancyInfo dateOfPregnancy]];
//        localNotif.fireDate = notifDate;
//        localNotif.timeZone = [NSTimeZone localTimeZone];
//        localNotif.alertBody = @"您的宝宝已经诞生了吧 ，快来看看为您准备的贴心育儿内容";
//        localNotif.alertAction = @"查看";
//        localNotif.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"switchParenting", @"localPushNotification", nil];
//        localNotif.soundName = UILocalNotificationDefaultSoundName;
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
//        [localNotif release];
//    }
}


+(void)registerCustomLocationNoti:(NSString*)notiContent withNotiInfoName:(NSString*)notiName withNotiDate:(NSDate*)notiDate{
    //设置三天之后
    //    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:3600*24*3];
    //创建一个本地推送
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    if (noti) {
        //设置推送时间
        noti.fireDate = notiDate;
        //设置时区
        noti.timeZone = [NSTimeZone localTimeZone];
        //设置重复间隔
        //        noti.repeatInterval = NSWeekCalendarUnit;
        //推送声音
        noti.soundName = UILocalNotificationDefaultSoundName;
        //内容
        noti.alertBody = notiContent;
        noti.alertAction = @"确认";
        //显示在icon上的红色圈中的数子
        noti.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *infoDic = [NSDictionary dictionaryWithObject:notiName forKey:@"localPushNotification"];
        noti.userInfo = infoDic;
        //添加推送到uiapplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:noti];
    }
}

+(void)cancelCustomLocationNoti:(NSString*)noticeKey{
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArr = [app scheduledLocalNotifications];
    
    //声明本地通知对象
    //    UILocalNotification *localNoti;
    
    if (localArr)
    {
        for (UILocalNotification *localNoti in localArr)
        {
            NSDictionary *dict = localNoti.userInfo;
            if (dict)
            {
                NSString *inKey = [dict stringForKey:@"localPushNotification"];
                if ([inKey isEqualToString:noticeKey])
                {
                    [app cancelLocalNotification:localNoti];
                    
                }
            }
        }
    }
}


+(BOOL)isRegisterLocationNotice:(NSString*)noticeInfo{

    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArr = [app scheduledLocalNotifications];
    
    if (localArr) {
        for (UILocalNotification *noti in localArr) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                NSString *inKey = [dict stringForKey:@"localPushNotification"];
                if ([inKey isEqualToString:noticeInfo]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

+(void)cancelCareRemindLocationNoti
{
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArr = [app scheduledLocalNotifications];
    
    //声明本地通知对象
    //    UILocalNotification *localNoti;
    
    if (localArr)
    {
        for (UILocalNotification *localNoti in localArr)
        {
            NSDictionary *dict = localNoti.userInfo;
            if (dict)
            {
                NSString *inKey = [dict stringForKey:@"localPushNotification"];
                if (!([inKey isEqualToString:@"BBMotherBindingNoti"] || [inKey isEqualToString:@"BBBabyBornLocationNotice"] || [inKey isEqualToString:@"BBNewCareRemindNoti"] || [inKey isEqualToString:@"BBCutParentRemindNotice"]))
                {
                    [app cancelLocalNotification:localNoti];
                    
                }
            }
        }
    }
}

+(void)cancelNewCareRemindLocationNoti
{
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArr = [app scheduledLocalNotifications];
    
    //声明本地通知对象
    //    UILocalNotification *localNoti;
    
    if (localArr)
    {
        for (UILocalNotification *localNoti in localArr)
        {
            NSDictionary *dict = localNoti.userInfo;
            if (dict)
            {
                NSString *inKey = [dict stringForKey:@"localPushNotification"];
                if ([inKey isEqualToString:@"BBNewCareRemindNoti"])
                {
                    [app cancelLocalNotification:localNoti];
                    
                }
            }
        }
    }
}

//添加新的关爱提醒
+ (void)resetNewRemindLocalNotifications
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //删除目前的push
        [NoticeUtil cancelNewCareRemindLocationNoti];
        
        if ([BBUser getNewUserRoleState] == BBUserRoleStateNone || [BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
        {
            //备孕或者没身份用户不加提醒
            return;
        }
        //获取符合条件的关爱提醒列表
        NSMutableArray *reminds = [BBKonwlegdeDB allLocalReminds];
        if ([reminds isNotEmpty])
        {
            NSDate *startDate = nil;
            BOOL isHasBaby = NO;
            //计算出开始添加push的起点日期
            if ([BBUser getNewUserRoleState] == BBUserRoleStatePregnant)
            {
                //怀孕的日期 早上9点半
                startDate = [[[[BBPregnancyInfo dateOfPregnancy]dateAtEndOfDay]dateBySubtractingDays:280]dateByAddingMinutes:570];
            }
            if ([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
            {
                //宝宝出生日期 早上9点半
                isHasBaby = YES;
                startDate = [[[BBPregnancyInfo dateOfPregnancy]dateAtStartOfDay]dateByAddingMinutes:570];
            }
            if (!startDate)
            {
                return;
            }
            //从起点日期开始，遍历添加列表里面所有的关爱提醒
            for (BBKonwlegdeModel *model in reminds)
            {
                NSString *title = model.title;
                if (title)
                {
                    NSString *notiContent = @"";
                    NSString *ID = model.ID;
                    NSString *days = model.days;
                    NSDate *fireDate = [startDate dateByAddingDays:[days integerValue]-1];
                    if ([fireDate compare:[NSDate date]] == NSOrderedAscending)
                    {
                        //过滤触发日期早于当前日期的push
                        continue;
                    }
                    if (isHasBaby)
                    {
                        NSString *babyAge = [BBBabyAgeCalculation babyAgeWithStartDate:startDate withStopDate:fireDate];
                        NSArray *contentArray = [babyAge componentsSeparatedByString:@";"];
                        NSString *contentText = [contentArray componentsJoinedByString:@""];
                        notiContent = [NSString stringWithFormat:@"宝妈，今天是宝宝出生第%@，《宝宝树孕育》提醒您 %@",contentText,title];
                    }
                    else
                    {
                        notiContent = [NSString stringWithFormat:@"宝妈，今天是您怀孕第%d周，《宝宝树孕育》提醒您 %@",[days integerValue]/7,title];
                    }
                    UILocalNotification *noti = [[UILocalNotification alloc] init];
                    noti.fireDate = fireDate;
                    noti.timeZone = [NSTimeZone localTimeZone];
                    noti.soundName = UILocalNotificationDefaultSoundName;
                    noti.alertBody = notiContent;
                    noti.alertAction = @"确认";
                    noti.applicationIconBadgeNumber = 1;
                    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@"BBNewCareRemindNoti",@"localPushNotification",ID,@"remindID",days,@"remindDay", nil];
                    noti.userInfo = infoDic;
                    UIApplication *app = [UIApplication sharedApplication];
                    [app scheduleLocalNotification:noti];
                }
            }
//=====================下面信息调试用 要删掉
//            NSString *alertStr = @"";
//            for (UILocalNotification * notify in [[UIApplication sharedApplication]scheduledLocalNotifications])
//            {
//                if ([[notify.userInfo stringForKey:@"localPushNotification"]isEqualToString:@"BBNewCareRemindNoti"])
//                {
//                    alertStr = [alertStr stringByAppendingFormat:@"%@\n",[notify.fireDate description]];
//                }
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:alertStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//            });
//=====================
        }
    });
}

+ (void)registerBBRecallParentLocalNotification
{
    [NoticeUtil cancelCustomLocationNoti:@"BBBabyBornLocationNotice"];
    NSDate *preDay = [BBPregnancyInfo dateOfPregnancy];
    preDay = [preDay dateByAddingDays:14];
    NSDate *notidate = [[preDay dateAtStartOfDay]dateByAddingHours:9];
    NSString *preStr = @"亲爱的，宝宝已经出生了吗？快去圈子里报个喜吧，大家都等着你的好消息！";
    [NoticeUtil registerCustomLocationNoti:preStr withNotiInfoName:@"BBBabyBornLocationNotice" withNotiDate:notidate];
}

+ (void)registerBBCutParentLocalNotification
{
    [NoticeUtil cancelCustomLocationNoti:@"BBCutParentRemindNotice"];
    NSDate *prepareDay = [BBPregnancyInfo dateOfPregnancy];
    // 如果孕42周时间大于今天日期不注册该通知
    NSDate *currentDate = [NSDate date];
    if([[prepareDay dateByAddingDays:14] compare:currentDate] != NSOrderedDescending)
    {
        return;
    }
        
    prepareDay = [prepareDay dateBySubtractingDays:14];
    NSDate *noticedate = [[prepareDay dateAtStartOfDay]dateByAddingHours:9];
    NSString *preString = @"恭喜您的宝宝已经足月了，宝宝出生后建议您及时修改宝宝生日，获得更多育儿经验";
    [NoticeUtil registerCustomLocationNoti:preString withNotiInfoName:@"BBCutParentRemindNotice" withNotiDate:noticedate];
}

@end
