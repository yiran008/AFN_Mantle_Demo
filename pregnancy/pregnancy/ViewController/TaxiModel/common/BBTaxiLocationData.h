//
//  BBTaxiLocationData.h
//  pregnancy
//
//  Created by whl on 13-12-12.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBTaxiLocationData : NSObject

+ (void)setDisclaimerStatus:(BOOL)statusBool;
+ (BOOL)getDisclaimerStatus;

+ (void)setUserTaxiPhoneNumber:(NSString *)phoneNumber;
+ (NSString *)getUserTaxiPhoneNumber;

+ (void)setCallBackTimerString:(NSString *)callBackTimer;
+ (NSString *)getCallBackTimerString;


+ (void)setAppleWordString:(NSString *)applyWord;
+ (NSString *)getAppleWordString;

+ (void)setTaxiPartnerData:(NSArray *)list;
+ (NSArray*)getTaxiPartnerData;

+ (void)setCurrentLongitudeString:(NSString *)longitude;
+ (NSString *)getCurrentLongitudeString;

+ (void)setCurrentLatitudeString:(NSString *)latitude;
+ (NSString *)getCurrentLatitudeString;

+ (void)setTaxiPartnerTitle:(NSString *)partnerTitle;
+ (NSString *)getTaxiPartnerTitle;


+ (BOOL)enableShowTaxiMainPageGuideImage;

@end
