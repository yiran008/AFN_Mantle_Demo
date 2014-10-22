//
//  BBEncryptionUtil.m
//  Encryption
//
//  Created by 柏旭 肖 on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BBEncryptionUtil.h"
#import "NSString+MD5.h"



@implementation BBEncryptionUtil

+ (NSString*)encodeString:(NSString*)string
{
    NSInteger   length = [string length];
    NSString    *encodeString = string;
    for (NSInteger i = 0 ; i < length-2; i+=2) {
        NSRange range_1 = NSMakeRange(0, i);
        NSString *subString_1 = [encodeString substringWithRange:range_1];
        NSRange range_2 = NSMakeRange(i, 1);
        NSString *subString_2 = [encodeString substringWithRange:range_2];
        
        const   char *utf8string_2 = [subString_2 UTF8String];
        char    encodeUtf8String_2[2];
        encodeUtf8String_2[0] = utf8string_2[0] + 3;
        encodeUtf8String_2[1] = 0;
        NSString    *subStringEncode_2 = [[[NSString alloc] initWithUTF8String:encodeUtf8String_2] autorelease];
        
        NSRange range_3 = NSMakeRange(i+1, 1);
        NSString *subString_3 = [encodeString substringWithRange:range_3];
        
        const   char *utf8string_3 = [subString_3 UTF8String];
        char    encodeUtf8String_3[2];
        encodeUtf8String_3[0] = utf8string_3[0] + 7;
        encodeUtf8String_3[1] = 0;
        NSString    *subStringEncode_3 = [[[NSString alloc] initWithUTF8String:encodeUtf8String_3] autorelease];
        
        NSRange range_4 = NSMakeRange(i+2, length - i - 2);
        NSString *subString_4 = [encodeString substringWithRange:range_4];
        
        encodeString = [NSString stringWithFormat:@"%@%@%@%@",subString_1,subStringEncode_3,subStringEncode_2,subString_4];
    }

    return encodeString;
}
+ (NSString*)decodeString:(NSString*)string
{
    NSInteger   length = [string length];
    NSString    *encodeString = string;
    for (NSInteger i = 0 ; i < length-2; i+=2) {
        NSRange range_1 = NSMakeRange(0, i);
        NSString *subString_1 = [encodeString substringWithRange:range_1];
        NSRange range_2 = NSMakeRange(i, 1);
        NSString *subString_2 = [encodeString substringWithRange:range_2];
        
        const   char *utf8string_2 = [subString_2 UTF8String];
        char    utf8String_2[2];
        utf8String_2[0] = utf8string_2[0] - 7;
        utf8String_2[1] = 0;
        NSString    *subStringDecode_2 = [[[NSString alloc] initWithUTF8String:utf8String_2] autorelease];
        
        NSRange range_3 = NSMakeRange(i+1, 1);
        NSString *subString_3 = [encodeString substringWithRange:range_3];
        
        const   char *utf8string_3 = [subString_3 UTF8String];
        char    utf8String_3[2];
        utf8String_3[0] = utf8string_3[0] - 3;
        utf8String_3[1] = 0;
        NSString    *subStringDecode_3 = [[[NSString alloc] initWithUTF8String:utf8String_3] autorelease];
        
        NSRange range_4 = NSMakeRange(i+2, length - i - 2);
        NSString *subString_4 = [encodeString substringWithRange:range_4];
        
        encodeString = [NSString stringWithFormat:@"%@%@%@%@",subString_1,subStringDecode_3,subStringDecode_2,subString_4];
    }
    
    
    return encodeString;
}

+ (NSString*)clientToken
{
    NSDate      *date = [NSDate date];
    NSString    *dateStr = [NSString stringWithFormat:@"%0.f", [date timeIntervalSince1970]] ;
    NSString    *privateKey = [self decodeString:PRIVATE_KEY];
    NSString    *str = [NSString stringWithFormat:@"%@%@",dateStr,privateKey];
    NSString    *token = [NSString stringWithFormat:@"%@_%@",dateStr,[str MD5]];
    return token;
}

@end
