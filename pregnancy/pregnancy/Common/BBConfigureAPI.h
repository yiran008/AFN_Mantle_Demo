//
//  BBConfigureAPI.h
//  pregnancy
//
//  Created by Jun Wang on 12-3-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBLocation.h"
#import "BBDeviceUtility.h"
#import "OpenUDID.h"
#import "BBPregnancyInfo.h"
#import "JSONKit.h"

#ifndef pregnancy_BBConfigureAPI_h
#define pregnancy_BBConfigureAPI_h 1

static const BOOL API_S1_AVAILABLE              = NO;//是否打开s1配置，YES打开，NO关闭
static const BOOL API_URL_PRAMA_AVAILABLE       = YES;//是否请求打开参数log，YES打开，NO关闭

//static NSString *APP_CATEGORY             = (APP_ID==0 ? @"pregnancy" : @"parenting");
#ifdef DEBUG
/**
 *  ###分支环境初始化配置###
 *  举例1：若需www环境
    即为：TEST_INIT (@"www")；UPLOAD_INIT (@"")；MALL_INIT (@"")；DEV_INIT (@"")；//后三项为空。
 *  举例2：若需8.test环境
    即为：TEST_INIT (@"8.test")；UPLOAD_INIT (@"8.test.")；MALL_INIT (@"8.test.")；DEV_INIT (@"")；//不要忘记中间两项后额外有加点。
 *  举例3：若需test5环境
     即为：TEST_INIT (@"test5")；UPLOAD_INIT (@"test5.")；MALL_INIT (@"test5.")；DEV_INIT (@"-dev")；//不要忘记中间两项后额外有加点。（人名环境亦同）
 *
 */

/*-------- 线上测试环境(X.test) --------*/
//    #define TEST_INIT (@"8.test")
//    #define UPLOAD_INIT (@"8.test.")
//    #define MALL_INIT (@"8.test.")
//    #define DEV_INIT (@"")

/*-------- dev测试环境(testX-dev) --------*/
    #define TEST_INIT (@"test25")
    #define UPLOAD_INIT (@"test25.")
    #define MALL_INIT (@"test25.")
    #define DEV_INIT (@"-dev")

/*-------- 个人测试环境(XXX.babytree-dev) --------*/
//    #define TEST_INIT (@"liujingqi")
//    #define UPLOAD_INIT (@"liujingqi.")
//    #define MALL_INIT (@"liujingqi.")
//    #define DEV_INIT (@"-dev")

/*-------- 线上正式环境(www) --------*/
//    #define TEST_INIT (@"www")
//    #define UPLOAD_INIT (@"")
//    #define MALL_INIT (@"")
//    #define DEV_INIT (@"")


    #define DEBUG_TEST_SERVER_KEY    (@"debug_test_server")
    #define TEST_SERVER   [[NSUserDefaults standardUserDefaults]objectForKey:DEBUG_TEST_SERVER_KEY]

    #define DEBUG_UPLOAD_SERVER_KEY    (@"debug_upload_server")
    #define UPLOAD_SERVER   [[NSUserDefaults standardUserDefaults]objectForKey:DEBUG_UPLOAD_SERVER_KEY]

    #define DEBUG_MALL_SERVER_KEY    (@"debug_mall_server")
    #define MALL_SERVER   [[NSUserDefaults standardUserDefaults]objectForKey:DEBUG_MALL_SERVER_KEY]

    #define DEBUG_DEV_SERVER_KEY    (@"debug_dev_server")
    #define DEV_SERVER   [[NSUserDefaults standardUserDefaults]objectForKey:DEBUG_DEV_SERVER_KEY]

    #define MOBILE_TESTER (@"mobiletester:c65jt4k588@")

    //测试环境 catch more with TestHelper class
    #define BABYTREE_URL_SERVER [NSString stringWithFormat:@"http://%@%@.babytree%@.com",MOBILE_TESTER,TEST_SERVER,DEV_SERVER]
    #define BABYTREE_UPLOAD_SERVER [NSString stringWithFormat:@"http://%@upload.%@babytree%@.com",MOBILE_TESTER,UPLOAD_SERVER,DEV_SERVER]
    #define BABYTREE_MALL_SERVER [NSString stringWithFormat:@"http://%@mall.%@babytree%@.com/flashsale",MOBILE_TESTER,MALL_SERVER,DEV_SERVER]
#else

    #define BABYTREE_URL_SERVER         (@"http://www.babytree.com")
    #define BABYTREE_UPLOAD_SERVER      (@"http://upload.babytree.com")
    #define BABYTREE_MALL_SERVER        (@"http://mall.babytree.com/flashsale")

#endif

#define TIMEOUT_SECONDS                         (7)
#define TIMEOUT_RETRY_COUNT                     (2)
#define CLIENT_TYPE_KEY                         (@"client_type")
#define IOS_CLIENT                              (@"ios")
#define ACTION_KEY                              (@"action")

//babytree.com old API head
#define BABYTREE_API_SERVER                     ([NSString stringWithFormat:@"%@/api/api.php",BABYTREE_URL_SERVER])

//babytree.com 用户管理Action
#define LOGIN_ACTION                            (@"login")
#define REGISTER_ACTION                         (@"register")
#define SIMPLE_REGISTER_ACTION                  (@"simple_register")
#define MODIFY_NICKNAME_ACTION                  (@"rename_nickname")
#define CHECK_NINCKNAME_ACTION                  (@"user_register_check")

#define GET_DISCUZ_LIST_ACTION                  (@"get_discuz_list")
#define GET_COMMUNITY_GROUP_LIST_ACTION         (@"get_community_group_list")
#define GET_USER_DISCUZ_LIST_ACTION             (@"get_user_discuz_list")
#define GET_USER_DISCUZ_COUNT_LIST_ACTION       (@"get_user_discuz_count_list")
#define GET_USER_DISCUZ_COUNT_LIST              (@"get_user_discuz_count_list")
//babytree.com 用户管理Key
#define PHONE_REGISRER_KEY                      (@"register_code")
#define PHONE_NUMBER_KEY                        (@"phone_number")
#define EMAIL_KEY                               (@"email")
#define PASSWORD_KEY                            (@"password")
#define NICKNAME_KEY                            (@"nickname")
#define LOGIN_STRING_KEY                        (@"login_string")
#define APP_ID_VALUE                            (@"pregnancy")
#define MODIFY_AVATAR_KEY                       (@"modify_avatar")
#define MAC_KEY                                 (@"mac")

//babytree.com 主题管理Action
#define OPEN_NEW_TOPIC_ACTION                   (@"post_discuz")
#define REPLY_TOPIC_ACTION                      (@"post_reply")
//babytree.com 主题管理Key
#define TOPIC_ID_KEY                            (@"discuz_id")
#define TOPIC_TITLE_KEY                         (@"title")
#define TOPIC_CONTENT_KEY                       (@"content")
#define GROUP_ID_KEY                            (@"group_id")
#define BIRTHDAY_KEY                            (@"birthday")
#define PAGE_KEY                                (@"page")
#define APP_ID_KEY                              (@"app_id")
#define TYPE_KEY                                (@"type")
#define POSTS                                    (@"post")
#define REPLY                                   (@"reply")
#define LOGIN_STRING                            (@"login_string")
#define PHOTO_ID_KEY                            (@"photo_id")
#define UPLOAD_PHOTO                            (@"upload_photo")
#define SESSION_ID_KEY                          (@"session_id")

#define POSITION_KEY                            (@"position")
#define REFER_ID_KEY                            (@"refer_id")

//babytree.com 短消息管理Action
#define UNREAD_MESSAGE_ACTION                   (@"get_user_unread_message_count")
#define MESSAGE_LIST_ACTION                     (@"get_user_message_list")
#define SEND_MESSAGE_ACTION                     (@"send_user_message")
#define DELETE_MESSAGE_ACTION                   (@"delete_user_message")
//babytree.com 短消息管理Key
#define MESSAGE_TYPE_INBOX_KEY                  (@"user_inbox")
#define MESSAGE_TYPE_OUTBOX_KEY                 (@"user_outbox")
#define MESSAGE_TYPE_KEY                        (@"message_type")
#define MESSAGE_ID_KEY                          (@"message_id")
#define MESSAGE_CONTENT_KEY                     (@"content")
#define MESSAGE_USER_ENCODE_ID_KEY              (@"to_user_encode_id")
#define USER_ENCODE_ID_KEY                      (@"user_encode_id")

//月嫂评论 Action
#define COMMENT_USER_ID_ACTION                  (@"user_id")
#define COMMENT_CONTENT_ACTION                  (@"content")
#define COMMENT_NURSE_ID_ACTION                 (@"nurse_id")
//月嫂评论 Key
#define COMMENT_GET_KEY                         (@"get_nurse_discuss")
#define COMMENT_SET_KEY                         (@"set_nurse_discuss")
#define COMMENT_START_KEY                       (@"offset")
#define COMMENT_LENGTH_KEY                      (@"length")

//用户状态管理
#define USER_LOGIN_STRING                       (@"userLoginString")
#define USER_NICKNAME                           (@"userNickname")
#define USER_AVATAR_URL                         (@"userAvatarURL")
#define USER_ENCODE_ID                          (@"userEncodeID")
#define USER_EMAIL                              (@"userEmail")
#define USER_CAN_CHANGE_NAME                    (@"userCanChangeName")


//推荐应用
#define APP_GET_RECOMMEND_LIST                  (@"get_recommend_app_list")
#define APP_NAME_KEY                            (@"app_name")
#define APP_NAME                                (@"pregnancy")

#define START_KEY                               (@"start")
#define LIMIT_KEY                               (@"limit")
#define MY_ASK_PAGE_COUNT                       (@"20")
#define MY_ANSWER_PAGE_COUNT                    (@"20")
#define MY_GROUP_PAGE_COUNT                     (@"20")
#define ALL_BIRTHCLUB_PAGE_COUNT                (@"20")

//用户反馈
#define APP_FEEDBACK_ACTION                     (@"add_app_feedback")
#define APP_VERSION_KEY                         (@"app_version")
#define APP_VERSION                             (@"130")
#define BB_USER_INFO_KEY                        (@"user_info")
#define FEEDBACK_CONTENT_KEY                    (@"content")

//gps
#define GPS_LATITUDE                            (@"latitude")
#define GPS_LONGITUDE                           (@"longitude")

//cookie
#define CHECK_LOGIN_BY_LOGIN_STRING_ACTION      (@"check_login_by_login_string")
#define CHECK_LOGIN_BY_COOKIE_ACTION            (@"check_login_by_cookie")
#define COOKIE                                  (@"cookie")

//mika
#define MIKA_NAME_KEY                           (@"name")
#define MIKA_MOBILE_KEY                         (@"mobile")
#define MIKA_PROV_KEY                           (@"prov")
#define MIKA_CITY_KEY                           (@"city")
#define MIKA_ADDRESS_KEY                        (@"address")
#define MIKA_ZIPCODE_KEY                        (@"zipcode")

#if USE_FATHER_VERSION
// father version
#define FATHER_CODE_KEY                         (@"code")
#define FATHER_GENDER_KEY                       (@"gender")
#define FATHER_TASK_ID_KEY                      (@"task_id")
#endif

//AFNetwork
#define AFN_PUBLIC_PARAMS \
if (IOS_VERSION >= 7.0)\
{\
[parameters setObject:[OpenUDID value] forKey:MAC_KEY];\
}\
else\
{\
[parameters setObject:[BBDeviceUtility macAddress] forKey:MAC_KEY];\
}\
[parameters setObject:[BBPregnancyInfo pregancyDateYMDByStringForAPI] forKey:@"bpreg_brithday"];\
[parameters setObject:[BBPregnancyInfo pregnanyClientAndStatus] forKey:@"client_baby_status"];\
[parameters setObject:IOS_CLIENT forKey:CLIENT_TYPE_KEY];\
[parameters setObject:@"text_json" forKey:@"result_format"];\
[parameters setObject:@"pregnancy" forKey:@"app_id"];\
[parameters setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];\
[parameters setObject:[BBLocation userLocationLongitude] forKey:GPS_LONGITUDE];\
[parameters setObject:[BBLocation userLocationLatitude] forKey:GPS_LATITUDE];

#define ASI_DEFAULT_INFO_POST \
    [request setGetValue:[BBPregnancyInfo pregancyDateYMDByStringForAPI] forKey:@"bpreg_brithday"];\
    [request setGetValue:[BBPregnancyInfo pregnanyClientAndStatus] forKey:@"client_baby_status"];\
    [request setGetValue:@"pregnancy" forKey:@"app_id"];\
    [request setGetValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];\
    [request setGetValue:@"text_json" forKey:@"result_format"];\
    [request setGetValue:IOS_CLIENT forKey:CLIENT_TYPE_KEY];\
    [request setNumberOfTimesToRetryOnTimeout:TIMEOUT_RETRY_COUNT];\
    [request setTimeOutSeconds:TIMEOUT_SECONDS];\
    [request setPostValue:[BBLocation userLocationLongitude] forKey:GPS_LONGITUDE];\
    [request setPostValue:[BBLocation userLocationLatitude] forKey:GPS_LATITUDE];\
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0){\
    [request setGetValue:[OpenUDID value] forKey:MAC_KEY];\
    }else{\
    [request setGetValue:[BBDeviceUtility macAddress] forKey:MAC_KEY];\
    }\
    if (API_S1_AVAILABLE) {\
        [request setUsername:@"mobiletester"];\
        [request setPassword:@"c65jt4k588"];\
    }

#define ASI_DEFAULT_INFO_GET \
    [request setGetValue:[BBPregnancyInfo pregancyDateYMDByStringForAPI] forKey:@"bpreg_brithday"];\
    [request setGetValue:[BBPregnancyInfo pregnanyClientAndStatus] forKey:@"client_baby_status"];\
    [request setGetValue:@"text_json" forKey:@"result_format"];\
    [request setGetValue:@"pregnancy" forKey:@"app_id"];\
    [request setGetValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];\
    [request setGetValue:IOS_CLIENT forKey:CLIENT_TYPE_KEY];\
    [request setNumberOfTimesToRetryOnTimeout:TIMEOUT_RETRY_COUNT];\
    [request setTimeOutSeconds:TIMEOUT_SECONDS];\
    [request setGetValue:[BBLocation userLocationLongitude] forKey:GPS_LONGITUDE];\
    [request setGetValue:[BBLocation userLocationLatitude] forKey:GPS_LATITUDE];\
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0){\
    [request setGetValue:[OpenUDID value] forKey:MAC_KEY];\
    }else{\
    [request setGetValue:[BBDeviceUtility macAddress] forKey:MAC_KEY];\
    }\
    if (API_S1_AVAILABLE) {\
        [request setUsername:@"mobiletester"];\
        [request setPassword:@"c65jt4k588"];\
    }\
    [request setRequestMethod:@"GET"];


#endif
