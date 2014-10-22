//
//  BBFatherInfo.h
//  pregnancy
//
//  Created by songxf on 13-5-21.
//  Copyright (c) 2013年 babytree. All rights reserved.
//
#import <Foundation/Foundation.h>

// 孩子预产期
#define BABY_PREGNANCY_TIME_KEY @"babyPregnancyTimeKey"
// 爸爸UID
#define FATHER_UID_KEY @"father_uid_key"

// 爸爸绑定邀请码
#define USER_PAPA_BIND_CODE @"userPapaBindCode"
// 备份的绑定状态
#define USER_PAPA_BIND_STATUS @"userPapaBindStatus"
// 爸爸添加的孕气值
#define USER_PAPA_YUNQI @"userPapaYunqi"

// 版本控制 是否已经选择爸爸版或者妈妈版或者还没选择
#define STATE_ABOUT_CHOSE_ROLE @"stateOfChoseRole"

// 爸爸的孩子预产期
#define BABY_PREGNANCY_TIME_KEY @"babyPregnancyTimeKey"

// 妈妈UID
#define MOTHER_UID_KEY @"mother_uid_key"

// 爸爸的邀请码
#define INVITE_CODE_OF_FATHER @"inviteCodeOfFather"

// 爸爸的性别
#define FATHER_GENDER @"1"

//本地任务日期
#define TASK_CONTENT_TODAY @"taskContentsOfLocal"

#define BACKGROUND_IMAGE_URL @"urlOfBackground"

#define FATHER_ENCODE_ID_KEY @"fatherChartEncodeID"

#define FATHER_CHANGE_STATUS_ACTION @"action"

//本地默认怀孕时间
#define DEFAULT_DAYS_PREGNANCY 28

@interface BBFatherInfo : NSObject

+ (NSString *)getFatherUID;

+ (void)setFatherUID:(NSString *)f_uid;

+ (NSString *)getFatherEncodeId;

+ (void)setFatherEncodeId:(NSString *)uid;

+ (NSString *)getMotherUID;

+ (void)setMotherUID:(NSString *)m_uid;

+ (NSDate *)currentDate;

+ (NSInteger)daysOfPregnancy;

+ (NSDate *)dateOfPregnancy;

+ (void)setBabyPregnancyTime:(NSString *)dateStr;

+ (void)setBabyPregnancyTimeWithMenstrualDate:(NSDate *)date;

// 爸爸绑定
// 爸爸绑定邀请码
+ (NSString *)getPapaBindCode;
+ (void)setPapaBindCode:(NSString *)bindCode;
// 备份的绑定状态，在无法获得服务器状态时使用
+ (BOOL)getPapaBindStatus;
+ (void)setPapaBindStatus:(BOOL)bindStatus;
// 爸爸添加的孕气值
+ (NSString *)getPapaYunqi;
+ (void)setPapaYunqi:(NSString *)yunqi;

// 获取角色状态 0：还没选择  1：爸爸  2：妈妈  3:备孕
+ (NSInteger)getChoseRoleState;

// 用户选择角色后，记忆不再显示选择界面
+ (void)setShowChoseRole:(NSInteger)choseRoleState;

// 用户选择角色清除
+ (void)clearRoleState;

+ (NSString *)getInviteCode;

+ (void)setInviteCode:(NSString *)code;

+ (void)setBackGroundImageURL:(NSString *)url;

+ (NSString *)getBackGroundImageURL;

+ (void)clearLocalData;

// 清除妈妈用户数据
+ (void)clearMamaData;

//根据参数怀孕天数和保存的预产期，格式化输出日期
+ (NSString *)pregancyDateByStringWithDays:(NSString *)theDays;

+ (void)setActionTag:(NSString *)tag;
+ (NSString *)getActionTag;

@end
