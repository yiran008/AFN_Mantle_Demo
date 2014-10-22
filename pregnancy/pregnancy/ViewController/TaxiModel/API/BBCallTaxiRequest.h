//
//  BBCallTaxiRequest.h
//  pregnancy
//
//  Created by whl on 13-12-16.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BAIDU_API_AK @"25GfFoFvw6WPp5Zhwyl8z1Yq"

@interface BBCallTaxiRequest : NSObject

//打车规则
+ (ASIFormDataRequest *)taxiCallRule;

//百度反解析
+ (ASIFormDataRequest *)baiduMapResolve:(NSString *)currentlocation;

//获取打车是否返现
+ (ASIFormDataRequest *)taxiCallbackStatus;

//创建打车订单
+ (ASIFormDataRequest *)taxiCreateOrders:(NSString *)userPhone withFromAddress:(NSString *)formAddress withToAddress:(NSString *)toAddress withFromLongitude:(NSString *)currentLongitude withFromLatitude:(NSString *)currentLatitude;

//取消打车订单
+ (ASIFormDataRequest *)taxiCancelOrders:(NSString *)cancelOrdersID;

//打车订单是否被接受
+ (ASIFormDataRequest *)taxiAcceptOrders:(NSString *)acceptOrdersID;

//打车订单详情
+ (ASIFormDataRequest *)taxiOrdersDetail:(NSString *)orderID;

//打车合作伙伴
+ (ASIFormDataRequest *)taxiPartner:(NSString *)currentLongitude withLatitude:(NSString *)currentLatitude;

//打车公告页
+ (ASIFormDataRequest *)taxiNotice:(NSString *)currentLongitude withLatitude:(NSString *)currentLatitude;

//是否有打车权限
+ (ASIFormDataRequest *)taxiCompetence:(NSString *)currentLongitude withLatitude:(NSString *)currentLatitude;


+ (ASIFormDataRequest *)fetchKuaidiVerificaition;
+ (ASIFormDataRequest *)fetchKuaidiRecordsWithLat:(NSString *)lat lng:(NSString *)lng;
+ (ASIFormDataRequest *)fetchKuaidiPersonalWithLat:(NSString *)lat lng:(NSString *)lng;
+ (ASIFormDataRequest *)postVerificaitionWithAlipayAccount:(NSString *)alipayAccount withPhotoType:(NSString *)type withPhotoData:(NSData *)imageData lat:(NSString *)lat lng:(NSString *)lng;
+ (ASIFormDataRequest *)modifyAlipayAccount:(NSString *)account;
+ (ASIFormDataRequest *)cancelVerification;

+ (ASIFormDataRequest *)packageAPI:(NSArray*)requestArray;

@end
