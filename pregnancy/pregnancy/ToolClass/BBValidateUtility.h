//
//  BBValidateUtility.h
//  pregnancy
//
//  Created by whl on 13-10-29.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBValidateUtility : NSObject

+(BOOL)checkPhoneNumInput:(NSString *)text;

+(BOOL)isValidateEmail:(NSString *)email;
@end
