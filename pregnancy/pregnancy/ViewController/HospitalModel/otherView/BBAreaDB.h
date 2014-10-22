//
//  BBAreaDB.h
//  pregnancy
//
//  Created by babytree babytree on 12-4-11.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBAreaDB : NSObject

+ (NSMutableArray *)provinceList;

+ (NSMutableArray *)cityList:(NSString*)provinceCode;

+ (NSMutableArray *)provinceAndCityList;

+ (NSString *)areaByCiytCode:(NSString*)cityCode;

+ (NSString *)getProvinceByCiytCode:(NSString*)cityCode;

+ (NSString *)getCityNameByCiytCode:(NSString*)cityCode;

+ (NSMutableArray *)queryBabyboxProvinceList;

+ (NSMutableArray *)queryBabyboxCityList:(NSString *)provinceString;

+ (NSMutableArray *)queryBabyboxAreaList:(NSString *)cityString;


+ (void)insertSelectedProvince:(id)object;
+ (NSMutableArray *)getSelectedProvinceList;

@end
