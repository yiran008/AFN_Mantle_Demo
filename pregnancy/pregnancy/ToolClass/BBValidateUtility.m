//
//  BBValidateUtility.m
//  pregnancy
//
//  Created by whl on 13-10-29.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBValidateUtility.h"

@implementation BBValidateUtility

+(BOOL)checkPhoneNumInput:(NSString *)text{
    NSString *regex =@"(13[0-9]|0[1-9]|0[1-9][0-9]|0[1-9][0-9][0-9]|15[0-9]|18[02356789])\\d{8}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [mobileTest evaluateWithObject:text];
}

+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
