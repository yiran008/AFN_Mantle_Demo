//
//  BBHospitalRequest.m
//  pregnancy
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBHospitalRequest.h"

@implementation BBHospitalRequest


+ (ASIFormDataRequest *)hospitalDoctorListWithHospitalId:(NSString *)hospitalId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/hospital/get_doctor_list",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:hospitalId forKey:kHospitalIdKey];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)hospitalPregnancyListWithHospitalId:(NSString *)hospitalId withStartIndex:(NSString *)start
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/hospital/get_user_list",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:hospitalId forKey:kHospitalIdKey];
    [request setGetValue:start forKey:START_KEY];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)hospitalInformationWithHospitalId:(NSString *)hospitalId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/hospital/get_info",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:hospitalId forKey:kHospitalIdKey];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)hospitalListWithCity:(NSString *)cityName withProvinceName:(NSString *)provinceName  withHospitalId:(NSString *)hospitalId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/hospital/get_list_by_region_simple",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSString *loginStr = [BBUser getLoginString];
    if (loginStr != nil) {
        [request setGetValue:loginStr forKey:@"login_string"];
    }
    
    if (cityName != nil) {
        [request setGetValue:cityName forKey:@"city_name"];
    }
    else if (provinceName != nil) {
        [request setGetValue:provinceName forKey:@"province_name"];
    }
    else if (hospitalId != nil) {
        [request setGetValue:hospitalId forKey:@"hospital_id"];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}


+ (ASIFormDataRequest *)setHospitalWithName:(NSString *)hospitalName withId:(NSString *)hospitalId withCityCode:(NSString *)cityCode
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/hospital/set_hospital",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSString *loginStr = [BBUser getLoginString];
    if (loginStr != nil) {
        [request setPostValue:loginStr forKey:@"login_string"];
    }
    
    if (hospitalName != nil) {
        [request setPostValue:hospitalName forKey:@"hospital_name"];
    }
    if (hospitalId != nil) {
        [request setPostValue:hospitalId forKey:@"hospital_id"];
    }
    if (cityCode != nil) {
        [request setPostValue:cityCode forKey:@"city_code"];
    }
    
    ASI_DEFAULT_INFO_POST
    
    return request;
}

+ (ASIFormDataRequest *)doctorPostListByName:(NSString *)name withPage:(NSInteger)page withGroupId:(NSString *)groupId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/hospital/get_doctor_discuz_list",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:name forKey:kHospitalDoctor];
    [request setGetValue:groupId forKey:@"group_id"];
    
    NSInteger start = (page - 1) * 20;
    [request setGetValue:[NSString stringWithFormat:@"%d", start] forKey:START_KEY];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (void)setHospitalCategory:(NSDictionary *)theCategory
{
    if (!([theCategory isKindOfClass:[NSDictionary class]]||theCategory==nil)) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults safeSetContainer:theCategory forKey:kHospitalCatogeryKey];
}

+ (NSDictionary *)getHospitalCategory
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:kHospitalCatogeryKey] == nil) {
        return nil;
    } else {
        return [userDefaults objectForKey:kHospitalCatogeryKey];
    }
}

+ (void)setPostSetHospital:(NSString *)isPosted
{
    if (!([isPosted isKindOfClass:[NSString class]]||isPosted==nil)) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:isPosted forKey:kPostSetHospitalKey];
}

+ (NSString *)getPostSetHospital
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults valueForKey:kPostSetHospitalKey] == nil) {
        return nil;
    } 
    else 
    {
        return [userDefaults valueForKey:kPostSetHospitalKey];
    }
}

+ (void)setAddedHospitalName:(NSString *)theName
{
    if (!([theName isKindOfClass:[NSString class]]||theName==nil)) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:theName forKey:kAddedHospitalNameKey];
}

+ (NSString *)getAddedHospitalName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:kAddedHospitalNameKey] == nil) {
        return nil;
    } else {
        return [userDefaults objectForKey:kAddedHospitalNameKey];
    }
}

+ (ASIFormDataRequest *)hospitalListWithKey:(NSString *)key withCityId:(NSString *)cityId withProvinceId:(NSString *)provinceId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/hospital/search_simple",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:key forKey:@"key"];
    if (cityId!=nil) {
        [request setGetValue:cityId forKey:@"city_id"];
    }else if(provinceId!=nil) {
        [request setGetValue:provinceId forKey:@"province_id"];
    }
    [request setGetValue:@"0" forKey:@"start"];
    [request setGetValue:@"100" forKey:@"limit"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)hospitalPregnancyCount:(NSString *)hospitalID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/hospital/get_user_count",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:hospitalID forKey:@"hospital_id"];
    if ([[BBUser getLoginString] length] != 0) {
        [request setGetValue:[BBUser getLoginString] forKey:@"login_string"];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

@end
