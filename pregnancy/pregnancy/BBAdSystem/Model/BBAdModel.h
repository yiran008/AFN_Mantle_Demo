//
//  BBAdModel.h
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-16.
//  Copyright (c) 2014年 babytree. All rights reserved.
//  广告数据模型

#import <Foundation/Foundation.h>

//广告来源（other：广告联盟；babytree：广告系统）
#define AD_DICT_STATUS_KEY @"ad_status"
//广告联盟（gdt：广点通；baidu：百度）
#define AD_DICT_UNION_KEY @"ad_union"

#define AD_DICT_BANNERID_KEY @"ad_bannerid"
#define AD_DICT_ZONEID_KEY @"ad_zoneid"
#define AD_DICT_SERVER_KEY @"ad_server"

#define AD_DICT_NORMAL_IMG_KEY @"ad_img"
#define AD_DICT_CONTENT_KEY @"ad_content"

#define AD_DICT_TITLE_KEY @"ad_title"
#define AD_DICT_URL_KEY @"ad_url"

#define AD_DICT_MONITOR_KEY @"ad_monitor"

#define AD_DICT_LONG_IMG_KEY @"ad_img_long"

@interface BBAdModel : NSObject
@property(nonatomic,strong) NSString *adContent;
@property(nonatomic,strong) NSString *adUrl;
@property(nonatomic,strong) NSString *adMonitor;
@property(nonatomic,strong) NSString *adBannerID;
@property(nonatomic,strong) NSString *adZoneID;
@property(nonatomic,strong) NSString *adServer;
@property(nonatomic,strong) NSString *adTitle;
@property(nonatomic,assign) int adContextHeight;
@end
