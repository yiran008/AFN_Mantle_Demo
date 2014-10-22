//
//  CommonMacros.h
//  lama
//
//  Created by mac on 13-12-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#ifndef lama_CommonMacros_h
#define lama_CommonMacros_h


#pragma mark - Device macro

#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#ifndef IOS_VERSION
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#endif


#pragma mark - data change macro

#define DEGREES_TO_RADIANS(x)       ((x) * (M_PI / 180.0))

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]


#pragma mark -
#pragma mark Func

// 关闭讯飞语音输入
#define CLOSE_VOICE_INPUT       1

// 表情输入
#define COMMON_USE_EMOJI        1
// 获取位置
#define DO_LOCATION             1
// 草稿箱
#define COMMON_USE_DRATFBOX     1

// 使用新版本SDWebImage控件
#define UES_NEW_SDWEBIMAGE      0

// api_event统计
#define MOBCLICK_API_EVENT      0

#define USE_FATHER_VERSION      1

// 生产环境标识
#define COMMON_RUNFOR_DISTRIBUTION    0



#pragma mark -
#pragma mark Log

// DEBUG开关
#ifndef __OPTIMIZE__
#define COMMON_DEBUG    1
#endif

// Log写入文件标识
#if (COMMON_DEBUG)
#define COMMON_LOGINFILE 0
#endif

#if (__OPTIMIZE__ ) //(__OPTIMIZE__ && (COMMON_RUNFOR_DISTRIBUTION == 0))
#define COMMON_DEBUG    0
#define COMMON_LOGINFILE 0
#endif

#if COMMON_DEBUG
#define HMLog SCLog
#else
#define HMLog DummyLog
#endif

#if COMMON_DEBUG
#define BBLog SCLog
#else
#define BBLog DummyLog
#endif

#if COMMON_DEBUG
#define HMDebugLog SCLog
#else
#define HMDebugLog DummyLog
#endif

#if COMMON_DEBUG
#define LHMLog CLog
#else
#define LHMLog DummyLog
#endif


#pragma mark - 去重比较基数

#define DUPLICATE_COMPARECOUNT  40


#pragma mark - Text lenth macro

// lengthByUnicode
#define USER_NICKNAME_MINLENGTH 4
#define USER_NICKNAME_MAXLENGTH 12

#define USER_DESCRIPTION_MAXLENGTH 30


#pragma mark - NSNotificationCenter macro

// 登录、退出刷新更多圈（含tabs）
#define DIDCHANGE_MORECIRCLE_LOGIN_STATE       @"didChangeMoreCircleLoginState"
// 登录成功消息 （在圈子详情点击发帖、帖子详情回复点击发送的时候，触发登录，然后成功后发送消息）
#define DIDCHANGE_CIRCLE_LOGIN_STATE       @"didChangeCircleLoginState"
// 收藏帖子成功
#define DIDCHANGE_PERSON_COLLECT        @"didChangePersonCollectTopic"
// 发帖成功
#define DIDCHANGE_PERSON_POST           @"didChangePersonPostTopic"
// 回帖成功
#define DIDCHANGE_PERSON_REPLY          @"didChangePersonReplyTopic"
// 加入新圈子消息 （在发帖成功的同时加入圈子、回复成功同时加入圈子触发）
// 退出圈子消息 （在更多圈、圈子详情退出触发）
#define DIDCHANGE_CIRCLE_JOIN_STATE     @"didChangeCircleJoinState"
// 发送失败保存、手动保存草稿箱或从草稿箱成功发送一个帖子的时候触发
#define DIDCHANGE_DRAFTBOX              @"didChangeDraftBox"

#define RECEIVE_AND_VIEW_REMOTENOTIFY   @"receiveAndLookRemoteNotification"
#define DELETE_PHOTO_NOTIFICATION       @"deletePhotoNotification"
//帖子详情的广告点击
#define REMIND_AD_TAP              @"remindAdTap"

// 照片删除通知
#define DIDCHANGE_DELETEPHOTO           @"didChangeDeletePhoto"
#define DIDCHANGE_NEEDFRESHPHOTO        @"didChangeNeedFreshPhoto"

#define DIDCHANGE_PERSONAL_PREPARE      @"didChangePersonalPrepare"
#define DIDCHANGE_PERSONAL_PREGNANCY    @"didChangePersonalPregnancy"

#define DOWNLOAD_URL                @""


#pragma mark - UI macro

#define UI_NAVIGATION_BAR_DEFAULTHEIGHT 44
#define UI_NAVIGATION_BAR_HEIGHT        44
#define UI_NAVIGATION_BAR_HEIGHT_GAP    4
#define UI_TOOL_BAR_HEIGHT              44
#define UI_TAB_BAR_HEIGHT               49
#define UI_STATUS_BAR_HEIGHT            20
#define UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)
#define UI_MAINSCREEN_HEIGHT            (UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT)
#define UI_MAINSCREEN_HEIGHT_ROTATE     (UI_SCREEN_WIDTH - UI_STATUS_BAR_HEIGHT)
#define UI_WHOLE_SCREEN_FRAME           CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)
#define UI_WHOLE_SCREEN_FRAME_ROTATE    CGRectMake(0, 0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH)
#define UI_MAIN_VIEW_FRAME              CGRectMake(0, UI_STATUS_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT)
#define UI_MAIN_VIEW_FRAME_ROTATE       CGRectMake(0, UI_STATUS_BAR_HEIGHT, UI_SCREEN_HEIGHT, UI_MAINSCREEN_HEIGHT_ROTATE)


#pragma mark - Default define
// 动画默认时长
#define DEFAULT_DELAY_TIME (0.25f)
// 等待默认时长
#define PROGRESSBOX_DEFAULT_HIDE_DELAY  (1.0f)

#define TIMEZONE_BEIJING [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]

#define PREGNANCY_APPSTORE_CHECK_VERSON_ADDRESS @"http://itunes.apple.com/lookup?id=523063187"
#define PARENTING_APPSTROE_CHECK_VERSION_ADDRESS @"http://itunes.apple.com/lookup?id=570934785"

#define BABYTREE_IPHONE_ADDRESS                 @"http://m.babytree.com"


#pragma mark - color config
//#define UI_NAVIGATION_BUTTON_NORMALCOLOR [UIColor colorWithHex:0xFFFFFF]


#define UI_DEFAULT_BGCOLOR [UIColor colorWithRed:255/255.f green:83/255.f blue:123/255.f alpha:1.0f]


// 导航条背景颜色
//#define UI_NAVIGATION_BGCOLOR [UIColor colorWithHex:0xFF6699]
#define UI_NAVIGATION_BGCOLOR [UIColor colorWithRed:255/255.f green:83/255.f blue:123/255.f alpha:1.0f]
// View背景颜色
#define UI_VIEW_BGCOLOR [UIColor colorWithRed:239/255.f green:239/255.f blue:244/255.f alpha:1.0f]
#define UI_VIEW_BGCOLOR_1 [UIColor colorWithHex:0xFAFAFA]
#define UI_POPVIEW_BGCOLOR [UIColor colorWithHex:0xF6F6F6]
// View选中状态背景颜色
#define UI_VIEW_SELECT_BGCOLOR [UIColor colorWithHex:0xE0E0E0]

// Cell背景颜色
#define UI_CELL_BGCOLOR [UIColor whiteColor]
// Cell选中状态背景颜色
#define UI_CELL_SELECT_BGCOLOR [UIColor colorWithHex:0xEEEEEE]

#define UI_TEXT_TITLE_COLOR [UIColor colorWithHex:0x111111]
#define UI_TEXT_CONTENT_COLOR [UIColor colorWithHex:0x666666]

#define UI_TEXT_DETAIL_COLOR [UIColor colorWithHex:0x444444]
#define UI_TEXT_QUOTE_COLOR [UIColor colorWithHex:0x999999]

#define UI_TEXT_OTHER_COLOR [UIColor colorWithHex:0x999999]

#define UI_TEXT_SELECTED_COLOR [UIColor colorWithHex:0xFF6699]

//  ******** 帖子详情UI颜色配置

// 圈子标题颜色
#define DETAIL_CIRCLENAME_COLOR [UIColor colorWithHex:0x666666]
// 浏览次数、评论次数颜色
#define DETAIL_COUNT_COLOR [UIColor colorWithHex:0x999999]
// 帖子标题颜色
#define DETAIL_Title_COLOR [UIColor colorWithHex:0x111111]
// 正文颜色
#define DETAIL_CONTENT_TEXT_COLOR [UIColor colorWithHex:0x444444]
// 用户昵称颜色
#define DETAIL_NICKNAME_COLOR [UIColor colorWithHex:0xFF6699]
// 宝宝生日颜色
#define DETAIL_BABYAGE_COLOR [UIColor colorWithHex:0x999999]
// 楼层lab颜色
#define DETAIL_FLOOR_COLOR [UIColor colorWithHex:0x999999]
// 发布、回复时间颜色
#define DETAIL_TIME_COLOR [UIColor colorWithHex:0x999999]
// “喜欢”文字颜色
#define DETAIL_LOVE_COLOR [UIColor colorWithHex:0x666666]
// “喜欢”个数颜色
#define DETAIL_LOVECOUNT_COLOR [UIColor colorWithHex:0x999999]
// “回复”文字颜色
#define DETAIL_REPLY_COLOR [UIColor colorWithHex:0xFF6699]
// 引用回复用户昵称颜色
#define DETAIL_NICKNAME_COLOR2 [UIColor colorWithHex:0xFF99BB]
// 引用回复正文颜色
#define DETAIL_CONTENT_TEXT_COLOR2 [UIColor colorWithHex:0x999999]

//  ******** 帖子详情翻页颜色配置
#define DETAIL_PAGE_NORMAL_COLOR [UIColor colorWithHex:0x666666]
#define DETAIL_PAGE_INVALID_COLOR [UIColor colorWithHex:0xCCCCCC]
#define DETAIL_PAGE_BUTTONBG_COLOR [UIColor colorWithHex:0xFF6699]

#define DETAIL_PAGE_SLIDER_COLOR1 [UIColor colorWithHex:0xFF6699]
#define DETAIL_PAGE_SLIDER_COLOR2 [UIColor colorWithHex:0xEBECEE]

#define RGBColor(r,g,b,a) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]
#define PregnancyColor          RGBColor(255,83,123,1)
#define ParentingColor          RGBColor(76,217,100,1)
#define PregnancyBabaColor      RGBColor(61,183,229,1)
#define commonBgColor           RGBColor(244, 244, 244, 1);


#pragma mark -
#define MUSIC_DOWNLOADURL               @"url"
#define MUSIC_ID                        @"music_id"
#define MUSIC_TITLE                     @"title"
#define MUSIC_STATUS                    @"status"
#define MUSIC_FILESIZE                  @"size"
#define MUSIC_CATEGORYID                @"category_id"

#define DOWNLOAD_PRE                    0
#define DOWNLOAD_WAIT                   1
#define DOWNLOAD_DOWNLOADING            2
#define DOWNLOAD_FAIL                   3
#define DOWNLOAD_FINISH                 4
#define DOWNLOAD_PASUE                  5


#define DEFAULT_OPENAPPCHECK            3

// Appdelegate
#define ApplicationDelegate     ((BBAppDelegate *)[UIApplication sharedApplication].delegate)

#define EGOHEAD_REFRESH_DELAY   (0.5)

#endif
