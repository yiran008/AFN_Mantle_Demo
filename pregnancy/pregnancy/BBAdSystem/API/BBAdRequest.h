//
//  BBAdRequest.h
//  pregnancy
//
//  Created by liumiao on 5/4/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest+BBDebug.h"
#import "BBConfigureAPI.h"

typedef enum
{
    AdZoneTypeStartImage = 0,
    AdZoneTypeIndexBanner = 1,
    AdZoneTypeCareRemind =2,
    AdZoneTypeBabyGrowLogo = 3,
    AdZoneTypeTopicDetail = 4,
    
}AdZoneType;

@interface BBAdRequest : NSObject

/*
 获取广告接口
 正式：http://www.babytree.com/api/ad/show/
 测试：http://test18.babytree-dev.com/api/ad/show/
 
 触发广告写入
 正式：http://www.babytree.com/api/ad/view/
 测试：http://test18.babytree-dev.com/api/ad/view/
 */

/**
 *  获取广告请求
 *
 *  @param zoneType 广告类型
 *
 *  @return 获取广告请求的ASIFormDataRequest
 */
+ (ASIFormDataRequest *)getAdRequestForZoneType:(AdZoneType)zoneType;

/**
 *  获取广告请求
 *
 *  @param IDs  提醒的最近十条ID
 *
 *  @return 发送广告请求的ASIFormDataRequest
 */
+ (ASIFormDataRequest *)getRemindAdRequestWithIDs:(NSString *)IDs;

/**
 *  获取新的头图轮播广告
 *
 *  @param appTypeId 备孕为"4",孕期为"1",育儿为"2",准爸爸为"3"（暂时废弃）
 *
 *  @return ASIFormDataRequest
 */
+ (ASIFormDataRequest *)getNewBannerAdRequestForTypeId:(NSString*)appTypeId;

/**
 *  广告统计写入请求
 *
 *  @param data  广告数据
 *
 *  @return 发送广告请求的ASIFormDataRequest
 */
+ (ASIFormDataRequest *)sendAdPVRequestWithData:(NSString*)data;


#pragma mark- 启动画面接口定义
//启动画面
//请求参数：
//app_id=pregnancy&zone_type=welcome&login_string=XXX&bpreg_brithday=XXX&lat=X&lon=X
//
//返回结果：
//{
//    'status': 'success',
//    'message': '',
//    'data':
//    {
//        'ad':
//        {
//            'ad_img': 'http://xxx.jpg', //广告图片地址
//            'ad_img_long': 'http://xxx.jpg', //广告图片地址(ios长屏专用)
//            'ad_monitor': 'http://xxx.x', //广告检测链接
//            'ad_bannerid': 123, //广告ID
//            'ad_zoneid': 888 //广告位ID
//        }
//    }
//}
//
//具体实现：
//用app_id+zone_type取对应的zone_id
//请求openx接口获取广告数据
//返回广告数据
//
//----------------------------------------------------------------------------
//
#pragma mark- 首页轮播接口定义
//首页轮播
//
//请求参数：
//app_id=pregnancy&zone_type=index_banner&login_string=XXX&bpreg_brithday=XXX&lat=X&lon=X
//
//返回结果：
//{
//    'status': 'success',
//    'message': '',
//    'data':
//    [
//    {
//        'banner': 1,
//        'select_type': 6, //新类型：表示广告
//        'ad':
//        {
//            'ad_img': 'http://xxx.jpg', //广告图片地址
//            'ad_url': 'http://babytree.com', //广告跳转地址
//            'ad_monitor': 'http://xxx.x', //广告检测链接
//            'ad_bannerid': 123, //广告ID
//            'ad_zoneid': 888 //广告位ID
//        }
//    },
//    {
//        'banner': 2,
//        'select_type': 6, //新类型：表示广告
//        'ad':
//        {
//            'ad_img': 'http://xxx.jpg', //广告图片地址
//            'ad_url': 'http://babytree.com', //广告跳转地址
//            'ad_monitor': 'http://xxx.x', //广告检测链接
//            'ad_bannerid': 123, //广告ID
//            'ad_zoneid': 888 //广告位ID
//        }
//    },
//     ...
//     ]
//}
//
//具体实现：
//用app_id+zone_type取对应的zone_id列表
//请求openx接口获取广告数据
//根据产品需求对广告数据进行排序
//返回广告数据
//
//----------------------------------------------------------------------------
//
#pragma mark- 帖子详情接口定义
//帖子详情
//
//请求参数：
//app_id=pregnancy&zone_type=topic_detail&login_string=XXX&bpreg_brithday=XXX&lat=X&lon=X&topic_id=123
//
//返回结果：
//{
//    'status': 'success',
//    'message': '',
//    'data':
//    {
//        'ad':
//        {
//            'ad_img': 'http://xxx.jpg', //广告图片地址
//            'ad_url': 'http://babytree.com', //广告跳转地址
//            'ad_monitor': 'http://xxx.x', //广告检测链接
//            'ad_bannerid': 123, //广告ID
//            'ad_zoneid': 888 //广告位ID
//        }
//    }
//}
//
//具体实现：
//用app_id+zone_type取对应的zone_id
//请求openx接口获取广告数据
//返回广告数据
//
//----------------------------------------------------------------------------
//
#pragma mark- 关爱提醒接口定义
//关爱提醒
//
//请求参数：
//app_id=pregnancy&zone_type=knowleage_tip&login_string=XXX&bpreg_brithday=XXX&lat=X&lon=X&tip_id=123
//
//返回结果：
//{
//    'status': 'success',
//    'message': '',
//    'data':
//    [
//    {
//        'tip_id': 123, //提醒ID
//        'ad':
//        {
//            'ad_title': '标题', //例如：3月6日 孕15周+3天，有广告之后变为：XXX赞助
//            'ad_content': '文字', //广告内容文字
//            'ad_url_content': '链接文字', //广告链接文字
//            'ad_url': 'http://babytree.com', //广告跳转地址，为空表示无跳转
//            'ad_monitor': 'http://xxx.x', //广告检测链接，为空表示无检测
//            'ad_bannerid': 123, //广告ID
//            'ad_zoneid': 888 //广告位ID
//        }
//    },
//     ...
//     ]
//}
//
//具体实现：
//用app_id+zone_type+related_id(tip_id)取对应的zone_id列表
//请求openx接口获取广告数据
//返回广告数据
//
//----------------------------------------------------------------------------
//
#pragma mark- 宝宝发育LOGO接口定义
//宝宝发育LOGO
//
//请求参数：
//app_id=pregnancy&zone_type=grow_logo&login_string=XXX&bpreg_brithday=XXX&lat=X&lon=X
//
//返回结果：
//{
//    'status': 'success',
//    'message': '',
//    'data':
//    {
//        'ad':
//        {
//            'ad_img': 'http://xxx.jpg', //广告图片地址
//            'ad_monitor': 'http://xxx.x', //广告检测链接，为空表示无检测
//            'ad_bannerid': 123, //广告ID
//            'ad_zoneid': 888 //广告位ID
//        }
//    }
//}
//
//具体实现：
//用app_id+zone_type取对应的zone_id
//请求openx接口获取广告数据
//返回广告数据
//
//----------------------------------------------------------------------------
//
//知识WAP页(每日知识页+独立知识页)
//
//请求参数：
//app_id=pregnancy&zone_type=knowleage_detail&login_string=XXX&bpreg_brithday=XXX&lat=X&lon=X&knowleage_id=123
//
//返回结果：
//{
//    'status': 'success',
//    'message': '',
//    'data':
//    {
//        'ad':
//        {
//            'ad_img': 'http://xxx.jpg', //广告图片地址
//            'ad_monitor': 'http://xxx.x', //广告检测链接，为空表示无检测
//            'ad_bannerid': 123, //广告ID
//            'ad_zoneid': 888 //广告位ID
//        }
//    }
//}
//
//具体实现：
//用app_id+zone_type+related_id(knowleage_id)取对应的zone_id
//请求openx接口获取广告数据
//返回广告数据
//
//----------------------------------------------------------------------------
//
//问答详情WAP页
//
//请求参数：
//app_id=pregnancy&zone_type=ask_detail&login_string=XXX&bpreg_brithday=XXX&lat=X&lon=X&ask_id=123
//
//返回结果：
//{
//    'status': 'success',
//    'message': '',
//    'data':
//    {
//        'ad': 
//        {
//            'ad_img': 'http://xxx.jpg', //广告图片地址
//            'ad_monitor': 'http://xxx.x', //广告检测链接，为空表示无检测
//            'ad_bannerid': 123, //广告ID
//            'ad_zoneid': 888 //广告位ID
//        }
//    }
//}
//
//具体实现：
//用app_id+zone_type+related_id(ask_id)取对应的zone_id
//请求openx接口获取广告数据
//返回广告数据
//
//----------------------------------------------------------------------------
//
#pragma mark- 广告数据回传接口定义
//广告数据回传
//
//请求参数：(POST方式)
//app_id=pregnancy&login_string=XXX&bpreg_brithday=XXX&lat=X&lon=X&data=data
//
//APP记录PV次数时需要关联data.ad_bannerid和data.ad_zone_id作为唯一标识，例如：
//{
//    'ad_bannerid': 123, //广告ID
//    'ad_zoneid': 888, //广告位ID
//    'ad_pv': 5, //PV数
//    'create_ts': 1388505600, //PV数据创建时间
//}
//
//将多个APP广告记录组成特定结构，以post形式提交给回传接口，如果接口返回成功，则清空所传数据。
//
//特定结构：
//以逗号分隔每个广告记录，以分号分隔广告记录中的字段
//123;888;5;1388505600,124;889;6;1388505700
//返回结果：
//{
//    'status': 'success',
//    'message': '',
//    'data': {}
//}
//
//具体实现：
//请求openx接口获取广告数据
@end
