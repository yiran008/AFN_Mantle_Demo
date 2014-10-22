//
//  BBHospitalRequest.h
//  pregnancy
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHospitalIdKey                  (@"hospital_id")
#define kHospitalDiscuzListPage                  (@"page")
#define kHospitalDiscuzIsElite                  (@"is_elite")
#define kHospitalDoctor                  (@"doctor")

#define kHospitalCatogeryKey                  (@"HospitalCatogeryKey")
#define kHospitalNameKey                  (@"HospitalNameKey")
#define kHospitalGroupIdKey                  (@"HospitalGroupIdKey")
#define kHospitalHospitalIdKey                  (@"HospitalHospitalIdKey")
#define kPostSetHospitalKey                 (@"PostSetHospitalKey")

#define kAddedHospitalNameKey                  (@"AddedHospitalNameKey")

@interface BBHospitalRequest : NSObject
//医院的医生列表
+ (ASIFormDataRequest *)hospitalDoctorListWithHospitalId:(NSString *)hospitalId;
//同院孕妈列表
+ (ASIFormDataRequest *)hospitalPregnancyListWithHospitalId:(NSString *)hospitalId withStartIndex:(NSString *)start;
//医院信息
+ (ASIFormDataRequest *)hospitalInformationWithHospitalId:(NSString *)hospitalId;
//医院列表
+ (ASIFormDataRequest *)hospitalListWithCity:(NSString *)cityName withProvinceName:(NSString *)provinceName  withHospitalId:(NSString *)hospitalId;
//设置用户医院信息
+ (ASIFormDataRequest *)setHospitalWithName:(NSString *)hospitalName withId:(NSString *)hospitalId withCityCode:(NSString *)cityCode;
//根据医生名字获取该医生相关讨论的帖子列表
+ (ASIFormDataRequest *)doctorPostListByName:(NSString *)name withPage:(NSInteger)page withGroupId:(NSString *)groupId;

//设置为我的医院
+ (void)setHospitalCategory:(NSDictionary *)theCategory;
+ (NSDictionary *)getHospitalCategory;
//是否已将设置好的医院上传给服务器： 0-未上传，1-上传
+ (void)setPostSetHospital:(NSString *)isPosted;
+ (NSString *)getPostSetHospital;

//添加医院信息
+ (void)setAddedHospitalName:(NSString *)theName;
+ (NSString *)getAddedHospitalName;

+ (ASIFormDataRequest *)hospitalListWithKey:(NSString *)key withCityId:(NSString *)cityId withProvinceId:(NSString *)provinceId;

//医院孕妈数量
+ (ASIFormDataRequest *)hospitalPregnancyCount:(NSString *)hospitalID;

@end
