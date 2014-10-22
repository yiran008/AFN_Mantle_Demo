//
//  User.h
//  ask
//
//  Created by ilike1980 on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    BBUserRoleStateNone = 0,
    BBUserRoleStatePrepare = 1,
    BBUserRoleStatePregnant = 2,
    BBUserRoleStateHasBaby = 3,
    BBUserRoleStateFather = 4
}BBUserRoleState;

@interface BBUser : NSObject

//用户登录信息 LoginString
+ (NSString *)getLoginString;
+ (void)setLoginString:(NSString *)loginString;
//用户账号昵称
+ (NSString *)getNickname;
+ (void)setNickname:(NSString *)nickname;
//用户登录信息 EncodeID
+ (NSString *)getEncId;
+ (void)setEncodeID:(NSString *)encodeID;
//用户头像URL
+ (NSString *)getAvatarUrl;
+ (void)setAvatarUrl:(NSString *)url;
//用户性别
+ (NSString *)getGender;
+ (void)setGender:(NSString *)gender;
//用户所属地区
+ (NSString *)getLocation;
+ (void)setLocation:(NSString *)location;
//用户账号注册时间
+ (NSString *)getRegisterTime;
+ (void)setRegisterTime:(NSString *)registerTime;
//用户宝宝生日
+ (NSString *)getBabyBirthday;
+ (void)setBabyBirthday:(NSString *)birthdayTime;
//是否登录
+ (BOOL)isLogin;
//账号登出
+ (void)logout;
//用户登录账号
+ (NSString *)getEmailAccount;
+ (void)setEmailAccount:(NSString *)theEmailAccount;
//用户登录密码
+ (NSString *)getPassword;
+ (void)setPassword:(NSString *)password;
//用户本地头像Image路径
+ (NSString *)getLocalAvatar;
+ (void)setLocalAvatar:(NSString *)theLocalAvatar;
//是否需要同步用户头像到网上
+ (BOOL)needUploadAvatar;
+ (void)setNeedUploadAvatar:(BOOL)theBool;
//是否需要同步用户预产期到网上
+ (BOOL)needSynchronizeDueDate;
+ (void)setNeedSynchronizeDueDate:(BOOL)theBool;
//检查预产期状态
+ (BOOL)checkDueDateStatus;
+ (void)setCheckDueDateStatus:(BOOL)theBool;
// 报喜提醒次数 提醒3次
+ (NSInteger)getBabyBornReminderNum;
+ (void)setBabyBornReminderNum:(NSInteger)num;
// 育儿报喜提醒 每日提醒1次
+ (NSInteger)getBabyBornTodayReminderNum;
+ (void)setBabyBornTodayReminderNum:(NSInteger)num;
// 育儿报喜提醒最后日期
+ (NSDate *)getBabyBornReminderTime;
+ (void)setBabyBornReminderTime:(NSDate *)reminderTime;
// 感动页显示
+ (NSInteger)needShowMovedPage;
+ (void)setNeedShowMovedPage:(NSInteger)isShow;
// 感动页显示图片id
+ (NSString *)getMovedPagePhotoID;
+ (void)setMovedPagePhotoID:(NSString *)photoID;
//是否需要请求加孕气
+ (BOOL)needAddPreValue;
+ (void)setNeedAddPreValue:(BOOL)theBool;
//Cookie
+ (NSString *)localCookie;
+ (void)localCookie:(NSString *)theCookie;

+ (void)setTopBgUrl:(NSString *)url;
+ (NSString *)getTopBgUrl;
+ (BOOL)needGetTopBg;
+ (void)setNeedGetTopBg:(BOOL)theBool;

+ (NSString *)getTopBgLink;
+ (NSString *)getTopBgTitle;
+ (void)setTopBgLink:(NSString *)url;
+ (void)setTopBgTitle:(NSString *)url;
+ (NSString *)getTopBgTopicId;
+ (void)setTopBgTopicId:(NSString *)url;

+ (void)setTodaySignState;
+ (BOOL)todaySignState;
+ (BOOL)needRefreshActionData;
+ (void)setNeedRefreshActionData:(BOOL)theBool;
+ (BOOL)needRecommendTopic;
+ (void)setNeedRecommendTopic:(BOOL)theBool;

+ (void)setRecommendTopicArray:(NSArray *)recommendTopicArray;
+ (NSArray *)recommendTopicArray;

+ (void)setBannerArray:(NSArray *)recommendTopicArray;
+ (NSArray *)bannerArray;

+ (BOOL)needRefreshNotificationList;
+ (void)setNeedRefreshNotificationList:(BOOL)theBool;

+ (BOOL)needSynchronizeStatisticsDueDate;
+ (void)setNeedSynchronizeStatisticsDueDate:(BOOL)theBool;
+ (NSString *)smartWatchCode;
+ (void)setSmartWatchCode:(NSString *)smartWatchCode;

//我的圈子的列表缓存
+ (NSMutableArray *)getAddedCommunitys;
+ (void)setAddedCommunitys:(NSArray *)arr;
//用户等级
+ (void)setUserLevel:(NSString *)str;
+ (NSString *)getUserLevel;

//5.0新的用户状态
+ (BOOL)isUseNewRoleState;
+ (void)setNewUserRoleState:(BBUserRoleState)roleState;
+ (BBUserRoleState)getNewUserRoleState;

+ (BOOL)isCurrentUserBabyFather;
+ (void)setCurrentUserBabyFather:(BOOL)isFather;

// 未读私信数
+ (NSInteger)getUserUnreadSiXinCount;
+ (void)setUserUnreadSiXinCount:(NSInteger)count;

// 未读通知数
+ (NSInteger)getUserUnreadTongZhiCount;
+ (void)setUserUnreadTongZhiCount:(NSInteger)count;

// 新增粉丝数
+ (NSInteger)getUserNewFansCount;
+ (void)setUserNewFansCount:(NSInteger)count;

+ (BOOL)isBandFatherStatus;
+ (void)setBandFatherStatus:(BOOL)bandStatus;

//知识更新接口TS
+ (NSString *)getKnowledgeUpdataTS;
+ (void)setKnowledgeUpdataTS:(NSString *)bandStatus;


// 爸爸绑定邀请码
+ (NSString *)getPapaBindCode;
+ (void)setPapaBindCode:(NSString *)bindCode;

//知识收藏本地字典
+ (NSMutableDictionary *)getKnowledgeCollects;
+ (void)setKnowledgeCollects:(NSMutableDictionary *)dic;

// moreCircle category backup
+ (NSString *)moreCircleCategory;
+ (void )setMoreCircleCategory:(NSString *)category;

+ (BOOL)needBandFatherNotice;
+ (void)setNeedBandFatherNotice:(BOOL)bandBool;

//宝宝发育冠名广告
+ (NSDictionary *)getRemindLogoData;
+ (void)removeRemindLogoData;
+ (void )setRemindLogoData:(NSDictionary *)data;

//发育提醒插入广告
+ (NSArray *)getRemindAds;
+ (void)setRemindAds:(NSArray *)arr;

//首页中部banner缓存
+ (void)setMidBannerArray:(NSArray *)midBannerArray;
+ (NSArray *)midBannerArray;

//设置只看同城
+ (NSString *)getUserOnlyCity;
+ (void)setUserOnlyCity:(NSString *)city;

//特卖点标状态上次获取ts
+ (void)setLastQueryMallStatusTS:(NSString *)lastTS;
+ (NSString*)getLastQueryMallStatusTS;

//每个tab点标显示状态 用字典存储 [key：@"0",@"1"... value:YES,NO...]
+ (void)setTabbarIndex:(NSInteger)tabIndex Status:(BOOL)isShow;
+ (BOOL)getTabbarStatusForIndex:(NSInteger)tabIndex;

//设置备孕状态是否需要同步指定的预产期
+ (BOOL)needSynchronizePrepareDueDate;
+ (void)setNeedSynchronizePrepareDueDate:(BOOL)theBool;

@end
