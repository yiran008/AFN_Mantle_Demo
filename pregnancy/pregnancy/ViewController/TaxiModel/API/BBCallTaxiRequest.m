//
//  BBCallTaxiRequest.m
//  pregnancy
//
//  Created by whl on 13-12-16.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBCallTaxiRequest.h"

@implementation BBCallTaxiRequest

+ (ASIFormDataRequest *)packageAPI:(NSArray*)requestArray {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_package/get_all",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    if ([requestArray count]>0) {
        for (int i=0; i<requestArray.count; i++) {
            if ([[requestArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                [[requestArray objectAtIndex:i] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    [request setPostValue:obj forKey:[NSString stringWithFormat:@"package[%d][%@]",i,key]];
                }];
            }
        }
    }
    [request logUrlPrama];
    return request;
}

+ (ASIFormDataRequest *)taxiCallRule
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_taxi/agreement",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    ASI_DEFAULT_INFO_POST
    return request;
}

+ (ASIFormDataRequest *)baiduMapResolve:(NSString *)currentlocation
{
    NSURL *url = [NSURL URLWithString:@"http://api.map.baidu.com/geocoder/v2/"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:BAIDU_API_AK forKey:@"ak"];
    [request setGetValue:@"json" forKey:@"output"];
    [request setGetValue:currentlocation forKey:@"location"];
    [request setGetValue:@"1" forKey:@"pois"];
    [request setGetValue:@"wgs84ll" forKey:@"coordtype"];
    [request setRequestMethod:@"GET"];
    if (API_URL_PRAMA_AVAILABLE) {
        [request logUrlPrama];
    }
    return request;
}

+ (ASIFormDataRequest *)taxiCallbackStatus
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_taxi/back",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    ASI_DEFAULT_INFO_POST
    return request;
}


+ (ASIFormDataRequest *)taxiCreateOrders:(NSString *)userPhone withFromAddress:(NSString *)formAddress withToAddress:(NSString *)toAddress withFromLongitude:(NSString *)currentLongitude withFromLatitude:(NSString *)currentLatitude
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_taxi/create",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:userPhone forKey:@"telephone"];
    [request setPostValue:formAddress forKey:@"from_add"];
    [request setPostValue:toAddress forKey:@"to_add"];
    [request setPostValue:currentLongitude forKey:@"lng"];
    [request setPostValue:currentLatitude forKey:@"lat"];
    
    ASI_DEFAULT_INFO_POST
    return request;
}


+ (ASIFormDataRequest *)taxiCancelOrders:(NSString *)cancelOrdersID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_taxi/cancel",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:cancelOrdersID forKey:@"order_id"];
    ASI_DEFAULT_INFO_POST
    return request;
}


+ (ASIFormDataRequest *)taxiAcceptOrders:(NSString *)acceptOrdersID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_taxi/accept",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:acceptOrdersID forKey:@"order_id"];
    ASI_DEFAULT_INFO_POST
    return request;
}


+ (ASIFormDataRequest *)taxiOrdersDetail:(NSString *)orderID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_taxi/get_order_detail",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:orderID forKey:@"order_id"];
    ASI_DEFAULT_INFO_POST
    return request;
}

+ (ASIFormDataRequest *)taxiPartner:(NSString *)currentLongitude withLatitude:(NSString *)currentLatitude
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_taxi/partner",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:currentLongitude forKey:@"lng"];
    [request setPostValue:currentLatitude  forKey:@"lat"];
    ASI_DEFAULT_INFO_POST
    return request;
}

+ (ASIFormDataRequest *)taxiNotice:(NSString *)currentLongitude withLatitude:(NSString *)currentLatitude
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_taxi/notice",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:currentLongitude forKey:@"lng"];
    [request setPostValue:currentLatitude  forKey:@"lat"];
    ASI_DEFAULT_INFO_POST
    return request;
}


//获取审核状态
+ (ASIFormDataRequest *)fetchKuaidiVerificaition
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_taxi/apply_status",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    ASI_DEFAULT_INFO_POST
    return request;
}

//获取打车记录
+ (ASIFormDataRequest *)fetchKuaidiRecordsWithLat:(NSString *)lat lng:(NSString *)lng
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_taxi/get_list",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:lng forKey:@"lng"];
    [request setPostValue:lat forKey:@"lat"];
    ASI_DEFAULT_INFO_POST
    return request;
}

//获取个人信息
+ (ASIFormDataRequest *)fetchKuaidiPersonalWithLat:(NSString *)lat lng:(NSString *)lng
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_taxi/center",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:lng forKey:@"lng"];
    [request setPostValue:lat forKey:@"lat"];
    ASI_DEFAULT_INFO_POST
    return request;
}

//提交审核材料
+ (ASIFormDataRequest *)postVerificaitionWithAlipayAccount:(NSString *)alipayAccount withPhotoType:(NSString *)type withPhotoData:(NSData *)imageData lat:(NSString *)lat lng:(NSString *)lng
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_taxi/apply",BABYTREE_UPLOAD_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:alipayAccount forKey:@"alipay_account"];
    [request setPostValue:type forKey:@"photo_type"];
    [request setPostValue:lng forKey:@"lng"];
    [request setPostValue:lat forKey:@"lat"];
    
    if (imageData != nil && imageData.length != 0)
    {
        NSString *file_name = [BBTimeUtility stringDateWithFormat:@"yyyy-MM-dd-HH-mm-ss"];
        NSString *upload_name =[NSString stringWithFormat:@"%@.jpg",file_name ];
        [request setData:imageData withFileName:upload_name andContentType:@"image/jpeg" forKey:@"upload_file"];
        NSString *time_str = [BBTimeUtility stringDateWithFormat:@"yyyy-MM-dd-HH-mm-ss"];
        [request setPostValue:[NSString stringWithFormat:@"%@%@",[BBDeviceUtility macAddress],time_str] forKey:SESSION_ID_KEY];
    }
    
    ASI_DEFAULT_INFO_POST
    [request setTimeOutSeconds:30];
    
    return request;
}

//修改支付宝账号
+ (ASIFormDataRequest *)modifyAlipayAccount:(NSString *)account
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_taxi/modify_alipay_account",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:account forKey:@"alipay_account"];
    ASI_DEFAULT_INFO_POST
    return request;
}

//取消订单申请
+ (ASIFormDataRequest *)cancelVerification
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_taxi/cancel_apply",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    ASI_DEFAULT_INFO_POST
    return request;
}

+ (ASIFormDataRequest *)taxiCompetence:(NSString *)currentLongitude withLatitude:(NSString *)currentLatitude
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_taxi/can_join",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:currentLongitude forKey:@"lng"];
    [request setPostValue:currentLatitude  forKey:@"lat"];
    ASI_DEFAULT_INFO_POST
    return request;
}

@end
