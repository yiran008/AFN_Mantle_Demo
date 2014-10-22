//
//  wiNSString+MD5HexDigest.m
//  wiIos
//
//  Created by qq on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "ARCHelper.h"

#import "NSURL+Category.h"
#import "NSString+Category.h"

#import "OpenUDID.h"

@implementation NSString (Category)

//- (NSString*)uuid
//{
//    CFUUIDRef puuid = CFUUIDCreate( nil );
//    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
//    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
//    CFRelease(puuid);
//    CFRelease(uuidString);
//    return [result autorelease];
//}

+ (NSString *)getOpenUDID
{
    NSString *appUID = [OpenUDID value];
    
    return appUID;
}

// 转换16进制字符串为10进制数字
+ (NSUInteger) intFromHexStr:(NSString *)hexString
{
    return strtoul([hexString UTF8String], 0, 16);
}

+ (NSUInteger) intFromStr:(NSString *)string withBase:(NSInteger)base
{
    return strtoul([string UTF8String], 0, base);
}

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString
{
    if (![hexString isNotEmpty])
    {
        return nil;
    }

    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2)
    {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[[NSScanner alloc] initWithString:hexCharStr] ah_autorelease];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }

    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@", unicodeString);

    free(myBuffer);

    return unicodeString;
}

// 普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string
{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];

    //下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i=0; i<myD.length; i++)
    {
        // 16进制数
        NSString *newHexStr = [NSString stringWithFormat:@"%x", bytes[i]&0xff];

        if(newHexStr.length == 1)
        {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else
        {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }

    return hexStr; 
}


- (NSString *) md5HexDigest32
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];

    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);

    NSMutableString *hash = [NSMutableString string];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];

    return [hash lowercaseString];
}

- (NSString *) md5HexDigest16
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    for (NSInteger i = 4; i < 12; i++)
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
}

- (NSString *) getFileName
{
    NSString *fileName;
    NSArray *pathComponents = [self pathComponents];

    if (pathComponents.count > 0)
    {
        fileName = [NSString stringWithString:[pathComponents lastObject]];
    }
    else
    {
        return @"";
    }
    
    return fileName;
}

- (NSString *) getFilePath
{
    return [self stringByDeletingLastPathComponent];
}

+ (NSString *)storeString:(NSInteger)bsize
{
    if (bsize < 1024)
    {
        return [NSString stringWithFormat:@"%ldB", (long)bsize];
    }
    else if (bsize < 1024*1024)
    {
        CGFloat kbsize = (CGFloat)bsize / 1024;
        return [NSString stringWithFormat:@"%0.2fKB", kbsize];
    }
    else if (bsize < 1024*1024*1024)
    {
        CGFloat kbsize = (CGFloat)bsize / (1024*1024);
        return [NSString stringWithFormat:@"%0.2fM", kbsize];
    }
    else
    {
        CGFloat kbsize = (CGFloat)bsize / (1024*1024*1024);
        return [NSString stringWithFormat:@"%0.2fG", kbsize];
    }
}

- (NSString *)getFullFileExtension
{
    NSString *extension = [self pathExtension];
    if (![extension isEqualToString:@""])
    {
        extension = [NSString stringWithFormat:@".%@", extension];
    }
    
    return extension;
}

- (CGSize)calcSizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont*)font
{
    CGSize textSize = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        CGRect expectedFrame = [self boundingRectWithSize:CGSizeMake(maxWidth, 9999)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                font, NSFontAttributeName,
                                                                nil]
                                                       context:nil];
        textSize = expectedFrame.size;
#endif
    }
    else
    {
        textSize = [self sizeWithFont:font constrainedToSize:CGSizeMake(maxWidth, 9999) lineBreakMode:NSLineBreakByCharWrapping];
    }
    textSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
    return textSize;
}

- (CGSize)calcSizeWithFont:(UIFont*)font
{
    CGSize textSize = CGSizeZero;
    if (IOS_VERSION < 7.0)
    {
        textSize = [self sizeWithFont:font];
    }
    else
    {
        NSDictionary *attributes = @{NSFontAttributeName : font};
        textSize = [self sizeWithAttributes:attributes];
    }
    return textSize;
}

- (NSString *)escapeHTML
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:self];
    
    [result replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"'" withString:@"&#39;" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    return result;
}

/*
 sma  小图
 mid  中图
 big  大图
 */
/*
- (NSString *) getLogoImageName:(NSString *)addStr
{
    lhAppDelegate* appDelegate = getAppDelegate();
    
    NSString *imageUrl;
    
    NSString *fileName = [self getFileName];
    NSString *filePath = [self getFilePath];
    NSString *newFileName = [addStr stringByAppendingString:fileName];
    
    if(appDelegate.g_userLogonInfo.imageServerUrl != nil)
    {
        WILog(@"%@", appDelegate.g_userLogonInfo.imageServerUrl);
        imageUrl = [appDelegate.g_userLogonInfo.imageServerUrl stringByAppendingString:[filePath stringByAppendingPathComponent:newFileName]];
    }
    else
    {
        imageUrl = [filePath stringByAppendingPathComponent:newFileName];
    }
    
    WILog(@"getLogoImageName = %@", imageUrl);
    
    return imageUrl;
}

- (NSString *) getContentPreViewImageName
{
    NSString *fileName = [self getLogoImageName:@"m_"];
    
    WILog(@"getContentPreViewImageName = %@", fileName);
    
    return fileName;
}

- (NSString *) getContentArtworkImageName
{
    NSString *fileName = [self getLogoImageName:@"l_"];
    
    WILog(@"getContentArtworkImageName = %@", fileName);
    
    return fileName;
}
*/
/*
 NSString *f = @"/dfdsfsd/1/2/ppp.jpeg";
 
 NSArray *pathComponents = [f pathComponents];
 for (NSString *d in pathComponents)
 {
 NSLog(@"%@", d);
 }
 
 2012-02-16 18:25:54.889 wiIos[7264:f803] /
 2012-02-16 18:25:54.890 wiIos[7264:f803] dfdsfsd
 2012-02-16 18:25:54.891 wiIos[7264:f803] 1
 2012-02-16 18:25:54.891 wiIos[7264:f803] 2
 2012-02-16 18:25:54.892 wiIos[7264:f803] ppp.jpeg


 */

// 校验邮箱格式  
- (BOOL) isEmail
{
    NSString *emailRegEx =  
	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"  
	@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" 
	@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"  
	@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"  
	@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"  
	@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"  
	@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    BOOL result;
	
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    result = [regExPredicate evaluateWithObject:[self lowercaseString]];
    
    return result;
}

// 校验用户密码  
- (BOOL) isUserPasswd
{
    NSString *patternStr = @"^[a-zA-Z0-9]{6,16}$";
    
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", patternStr];
    if ([strTest evaluateWithObject:self])
    {
        NSLog(@"%@ is Valid UserPasswd", self);
        return YES;
    }
    
    NSLog(@"%@ is inValid UserPasswd", self);  
    return NO;
}

// 校验手机号
- (BOOL) isPhoneNum
{
    if (![self isNotEmpty])
        return NO;
    
    if (self.length != 11)
        return NO;
    
    NSString *num = @"^((147)|(13\\d{1})|(15\\d{1})|(18\\d{1}))\\d{8}$";
    
    NSPredicate *phoneNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
    if ([phoneNum evaluateWithObject:self])
    {
        NSLog(@"%@ is Valid mobil Number", self);  
        return YES;
    }

    NSLog(@"%@ is inValid mobil Number", self);  
    return NO;
}

// 一个汉字当两个字符 长度的计算
- (NSInteger)lengthByUnicode
{
    NSInteger i,n=[self length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[self characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return a+b+2*l;
}

// 校验验证码  
- (BOOL) isVerifyCode
{
    NSString *patternStr = @"^[0-9]{4,8}$";
    
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", patternStr];
    if ([strTest evaluateWithObject:self])
    {
        NSLog(@"%@ is Valid VerifyCode", self);  
        return YES;
    }
    
    NSLog(@"%@ is inValid VerifyCode", self);
    return NO;
}

+ (NSString *) stringTrim:(NSString *)str
{
    NSString *string1;
    
    string1 = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return string1;
}

+ (NSString *) stringTrimEnd:(NSString *)str
{
    NSString *string1;
    
    string1 = [[@"a" stringByAppendingString:str] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return [string1 substringFromIndex:1];
}

+ (NSString *) stringTrimStart:(NSString *)str
{
    NSString *string1;
    
    string1 = [[str stringByAppendingString:@"a"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return [string1 substringToIndex:[string1 length]-1];
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimSpace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSString*) TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    //    NSString *key = @"123456789012345678901234";
    NSString *initVec = @"init Vec";
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    if (kCCSuccess != ccStatus)
    {
        free(bufferPtr);
        return @"";
    }
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                length:(NSUInteger)movedBytes]
                                        encoding:NSUTF8StringEncoding]
                  ah_autorelease];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    free(bufferPtr);
    return result;
}

// 编码
+ (NSString *) encodeDES:(NSString*)plainText key:(NSString*)key
{
    NSString* ret = [NSString TripleDES:plainText encryptOrDecrypt:kCCEncrypt key:key];        
    NSLog(@"3DES/Base64 Encode Result=%@", ret);
    
    return ret;
}

// 解码
+ (NSString *) decodeDES:(NSString*)plainText key:(NSString*)key
{
    NSString* ret = [NSString TripleDES:plainText encryptOrDecrypt:kCCDecrypt key:key];
    NSLog(@"3DES/Base64 Decode Result=%@", ret);
    
    return ret;
}

//添加随机数
+ (NSString *) string:(NSString *)str appendRandom:(NSInteger)ram
{
    int randValue = arc4random();
    if (randValue < 0) 
    {
        randValue = randValue * -1;
    }
    randValue = randValue % (ram+1);
    return [NSString stringWithFormat:@"%@%d", str, randValue];
}

//判断是否为整形
- (BOOL) isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形
- (BOOL) isPureFloat
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    
    float val;
    
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (NSUInteger) hexStrToInt
{
    return strtoul([self UTF8String], 0, 16);
}


#define WI_IMAGE_PARSER_LENGTH  4

//解析文本，根据文本信息分析出哪些是表情，哪些是文字
-(void) getImageRange:(NSMutableArray *)array
{
    if (array == nil)
    {
        return;
    }
    
	NSRange range = [self rangeOfString:@"\\"];
    //判断当前字符串是否还有表情的标志，及是否符合格式(4字节长度)
    if (range.length > 0 && (self.length - range.location) >= WI_IMAGE_PARSER_LENGTH)
    {
        // 处理'\'前的子串
        NSString *str = [self substringToIndex:range.location];
        if (str.length > 0)
        {
            [array addObject:str];
        }
        
        // 处理表情的标志子串，这里可直接保存UIImage
        str = [self substringWithRange:NSMakeRange(range.location, WI_IMAGE_PARSER_LENGTH)];
        NSString *strsub = [str substringFromIndex:1];
        // 查找是否还包含'\'字符
        NSRange rangesub = [strsub rangeOfString:@"\\"];
        if (rangesub.length > 0)
        {
            // 处理'\'前的子串
            strsub = [self substringWithRange:NSMakeRange(range.location, rangesub.location+ 1)];
            [array addObject:strsub];
            
            // 处理剩下的子串
            strsub = [self substringFromIndex:range.location + rangesub.location + 1];
            if (strsub.length > 0)
            {
                // 递归解析
                [strsub getImageRange:array];
            }
            
            return;
        }
        else
        {
            // 找到表情子串
            [array addObject:str];
        }
        
        // 处理剩下的子串
        str = [self substringFromIndex:range.location + WI_IMAGE_PARSER_LENGTH];
        if (str.length > 0)
        {
            // 递归解析
            [str getImageRange:array];
        }
        
        return;
    }
    else
    {
        [array addObject:self];
    }
}


- (NSString *)changeToUnicode6String
{
    if (self.length == 0)
    {
        return @"";
    }
    
    NSMutableDictionary *softToUnicode6Dic = nil;
    
    NSMutableString *emojiString = [NSMutableString stringWithString:self];
    
    NSString *plistpath = [NSBundle pathForResource:@"SoftToUnicode6" 
                                                 ofType:@"plist" inDirectory:[[NSBundle mainBundle] bundlePath]];
    softToUnicode6Dic = [NSMutableDictionary dictionaryWithContentsOfFile:plistpath];
    
    for (NSInteger i = 0; i < [emojiString length]; i++)
    {
        if ([softToUnicode6Dic objectForKey:[emojiString substringWithRange:NSMakeRange(i, 1)]] != [NSNull null] && [softToUnicode6Dic objectForKey:[emojiString substringWithRange:NSMakeRange(i, 1)]] != nil)
        {
            [emojiString replaceCharactersInRange:NSMakeRange(i, 1) withString:[softToUnicode6Dic objectForKey:[emojiString substringWithRange:NSMakeRange(i, 1)]]];
        }
    }
    
    NSString *unicode6Str = [NSString stringWithString:emojiString];
    
    return unicode6Str;
}

- (NSString *)changeToSoftBankString
{
    NSInteger count;
    
    if (self.length == 0)
    {
        return @"";
    }
    
    NSMutableDictionary *unicode6ToSoftDic = nil;
    
    NSMutableString *emojiString = [NSMutableString stringWithString:self];
    
    NSString *plistpath = [NSBundle pathForResource:@"Unicode6ToSoft" 
                                                 ofType:@"plist" inDirectory:[[NSBundle mainBundle] bundlePath]];
    unicode6ToSoftDic = [NSMutableDictionary dictionaryWithContentsOfFile:plistpath];
    
    count = [emojiString length];
    for (NSInteger i = 0; i < count; i++)
    {
        if ([unicode6ToSoftDic objectForKey:[emojiString substringWithRange:NSMakeRange(i, 1)]] != [NSNull null] && [unicode6ToSoftDic objectForKey:[emojiString substringWithRange:NSMakeRange(i, 1)]] != nil)
        {
            NSString *str = [unicode6ToSoftDic objectForKey:[emojiString substringWithRange:NSMakeRange(i, 1)]];
            [emojiString replaceCharactersInRange:NSMakeRange(i, 1) withString:str];
            count = [emojiString length];
        }
    }
    
    count = [emojiString length];
    for (NSInteger i = 0; i < count - 1; i++)
    {
        if ([unicode6ToSoftDic objectForKey:[emojiString substringWithRange:NSMakeRange(i, 2)]] != [NSNull null] && [unicode6ToSoftDic objectForKey:[emojiString substringWithRange:NSMakeRange(i, 2)]] != nil)
        {
            NSString *str = [unicode6ToSoftDic objectForKey:[emojiString substringWithRange:NSMakeRange(i, 2)]];
            [emojiString replaceCharactersInRange:NSMakeRange(i, 2) withString:str];
            count = [emojiString length];
        }
    }

    count = [emojiString length];
    for (NSInteger i = 0; i < count - 2; i++)
    {
        if ([unicode6ToSoftDic objectForKey:[emojiString substringWithRange:NSMakeRange(i, 3)]] != [NSNull null] && [unicode6ToSoftDic objectForKey:[emojiString substringWithRange:NSMakeRange(i, 3)]] != nil)
        {
            NSString *str = [unicode6ToSoftDic objectForKey:[emojiString substringWithRange:NSMakeRange(i, 3)]];
            [emojiString replaceCharactersInRange:NSMakeRange(i, 3) withString:str];
            count = [emojiString length];
        }
    }
    
    count = [emojiString length];
    for (NSInteger i = 0; i < count - 3; i++)
    {
        if ([unicode6ToSoftDic objectForKey:[emojiString substringWithRange:NSMakeRange(i, 4)]] != [NSNull null] && [unicode6ToSoftDic objectForKey:[emojiString substringWithRange:NSMakeRange(i, 4)]] != nil)
        {
            NSString *str = [unicode6ToSoftDic objectForKey:[emojiString substringWithRange:NSMakeRange(i, 4)]];
            [emojiString replaceCharactersInRange:NSMakeRange(i, 4) withString:str];
            count = [emojiString length];
        }
    }
    
    NSString *softBankStr = [NSString stringWithString:emojiString];
    
    return softBankStr;
}

- (BOOL)isVideoNotMp4
{
    NSRange range = [self rangeOfString:@".3gp" options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound)
    {
        return YES;
    }

    range = [self rangeOfString:@".avi" options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound)
    {
        return YES;
    }

    range = [self rangeOfString:@".flv" options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound)
    {
        return YES;
    }
    
    range = [self rangeOfString:@".asf" options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound)
    {
        return YES;
    }
    
    range = [self rangeOfString:@".mkv" options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound)
    {
        return YES;
    }
    
    range = [self rangeOfString:@".rm" options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound)
    {
        return YES;
    }
    
    range = [self rangeOfString:@".rmvb" options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound)
    {
        return YES;
    }
    
    range = [self rangeOfString:@".wmv" options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound)
    {
        return YES;
    }
    
    range = [self rangeOfString:@".swf" options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound)
    {
        return YES;
    }
    
    return NO;
}

// only the first one
- (NSTextCheckingResult*)checkLinkWithType:(NSTextCheckingTypes)type
{
	__block NSTextCheckingResult* foundResult = nil;
	
	if (self && (type > 0))
    {
		NSError* error = nil;
		NSDataDetector* linkDetector = [NSDataDetector dataDetectorWithTypes:type error:&error];
		[linkDetector enumerateMatchesInString:self options:0 range:NSMakeRange(0,[self length])
									usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
		 {
#if __has_feature(objc_arc)
             foundResult = result;
#else
             foundResult = [[result retain] autorelease];
#endif
             *stop = YES;
		 }];
	}
	
	return foundResult;
}

// only the first one
- (NSURL*)extendedURLWithType:(NSTextCheckingTypes)type
{
    NSTextCheckingResult *checkingResult = [self checkLinkWithType:type];
    
    if (checkingResult == nil)
    {
        return nil;
    }
    
    NSURL* url = checkingResult.URL;
    if (checkingResult.resultType == NSTextCheckingTypeAddress)
    {
        NSString* baseURL = ([UIDevice currentDevice].systemVersion.floatValue >= 6.0) ? @"maps.apple.com" : @"maps.google.com";
        NSString* mapURLString = [NSString stringWithFormat:@"http://%@/maps?q=%@", baseURL,
                                  [checkingResult.addressComponents.allValues componentsJoinedByString:@","]];
        url = [NSURL URLWithString:mapURLString];
    }
    else if (checkingResult.resultType == NSTextCheckingTypePhoneNumber)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [checkingResult.phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""]]];
    }
    
    return url;
}

// check all links
-(NSArray *)computeLinksWithType:(NSTextCheckingTypes)type
{
    NSMutableArray *checkingResultArray = [[[NSMutableArray alloc] initWithCapacity:0] ah_autorelease];
    NSMutableArray *urlArray = nil;
	
    if (self && (type > 0))
    {
		NSError* error = nil;
		NSDataDetector* linkDetector = [NSDataDetector dataDetectorWithTypes:type error:&error];
		[linkDetector enumerateMatchesInString:self options:0 range:NSMakeRange(0,[self length])
                                      usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
		 {
             [checkingResultArray addObject:result];
         }];
	}
    
    if (checkingResultArray.count > 0)
    {
        urlArray = [[[NSMutableArray alloc] initWithCapacity:0] ah_autorelease];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
        
        for (NSTextCheckingResult *checkingResult in checkingResultArray)
        {
            NSURL* url = [self extendedURLWithType:type];
            
            if (url != nil)
            {
                [urlArray addObject:url];
            }
        }
        
#pragma clang diagnostic pop
    }
    
    return urlArray;
}

/*
- (void)detectLinks
{
	if (![self length])
	{
		return;
	}
	
	NSMutableArray *tempLinks = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	NSArray *expressions = [[[NSArray alloc] initWithObjects:@"(@[a-zA-Z0-9_]+)", // screen names
                             @"(#[a-zA-Z0-9_-]+)", // hash tags
                             nil] autorelease];
	//get #hashtags and @usernames
	for (NSString *expression in expressions)
	{
		NSError *error = NULL;
		NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
																			   options:NSRegularExpressionCaseInsensitive
																				 error:&error];
		NSArray *matches = [regex matchesInString:self
										  options:0
											range:NSMakeRange(0, [self length])];
		
		NSString *matchedString = nil;
		for (NSTextCheckingResult *match in matches)
		{
			matchedString = [[self substringWithRange:[match range]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			
			if ([matchedString hasPrefix:@"@"]) // usernames
			{
				NSString *username = [matchedString	substringFromIndex:1];
				
//                [NSString stringWithFormat:@"http://twitter.com/%@", username]
//				[tempLinks addObject:hyperlink];
			}
			else if ([matchedString hasPrefix:@"#"]) // hash tag
			{
				NSString *searchTerm = [[matchedString substringFromIndex:1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				
//				[NSString stringWithFormat:@"http://twitter.com/search?q=%@"];
//				[tempLinks addObject:hyperlink];
			}
		}
	}	
}
*/

+ (NSString *)getCGFormattedFileSize:(long long)size
{
    if (size > 1024*1024)
    {
        float s = size/1024.0/1024.0;
        return [NSString stringWithFormat:@"%.1fM",s];
    }
    else if(size > 1024)
    {
        float s = size/1024.0;
        return [NSString stringWithFormat:@"%.1fK",s];
    }
    
    return [NSString stringWithFormat:@"%lld",size];
}

- (NSString *)getValidHeadImageUrl
{
    if ([self hasSuffix:@"100x100.gif"])
    {
        return nil;
    }
    
    if ([self hasSuffix:@"50x50.gif"])
    {
        return nil;
    }
    if ([self isEqualToString:@""])
    {
        return nil;
    }
    return self;
}

+ (NSString *)spaceWithFont:(UIFont *)font top:(BOOL)bTop new:(BOOL)bNew best:(BOOL)bBest help:(BOOL)bHelp pic:(BOOL)bPic add:(NSInteger)addSpaceCount
{
    CGFloat topWidth = bTop ? 30 : 0;
    CGFloat newWidth = bNew ? 16 : 0;
    CGFloat bestWidth = bBest ? 16 : 0;
    CGFloat helpWidth = bHelp ? 16 : 0;
    CGFloat picWidth = bPic ? 16 : 0;

    return [NSString spaceWithFont:font topWidth:topWidth newWidth:newWidth bestWidth:bestWidth helpWidth:helpWidth picWidth:picWidth add:0];
}

+ (NSString *)spaceWithFont:(UIFont *)font topWidth:(CGFloat)topWidth newWidth:(CGFloat)newWidth bestWidth:(CGFloat)bestWidth helpWidth:(CGFloat)helpWidth picWidth:(CGFloat)picWidth add:(NSInteger)addSpaceCount
{
    NSString *space = @"";
    CGFloat gap = 4.0f;

    CGSize size;

    if (IOS_VERSION < 7.0)
    {
        size = [@" " sizeWithFont:font];
    }
    else
    {
        NSDictionary *attributes = @{NSFontAttributeName : font};
        size = [@" " sizeWithAttributes:attributes];
    }

    CGFloat spaceWidth = size.width;
    CGFloat width = 0;
    NSInteger spaceCount = 0;

    if (topWidth>0)
    {
        width += topWidth+gap;
    }

    if (newWidth>0)
    {
        width += newWidth+gap;
    }

    if (bestWidth)
    {
        width += bestWidth+gap;
    }

    if (helpWidth)
    {
        width += helpWidth+gap;
    }

    if (picWidth)
    {
        width += picWidth+gap;
    }

    spaceCount = (NSInteger)(width/spaceWidth+0.99) + addSpaceCount;

    for (NSInteger i=0; i<spaceCount; i++)
    {
        space = [NSString stringWithFormat:@"%@ ", space];
    }

    return space;
}

@end

@implementation NSString (URL)


- (NSString *)URLDecode
{
	return [NSURL decode:self];
}

- (NSString *)URLEncode
{
	return [NSURL encode:self];
}

- (NSString *)URLEncodeComponent
{
	return [NSURL encodeComponent:self];
}

- (NSString *)URLEscapeAll
{
	return [NSURL escapeAll:self];
}

@end


@implementation NSString (Emoji)

+ (NSDictionary *)getEmojiDic
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emojiDic"
                                                          ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

+ (NSDictionary *)getNationalFlagEmojiDic
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"nationalFlagEmojiDic"
                                                          ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

+ (NSDictionary *)getNationalFlagEmojiCode
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"nationalFlagEmojiCode"
                                                          ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

+ (NSDictionary *)getNationalFlagEmojiCodeFirst
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"nationalFlagEmojiCodeFirst"
                                                          ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}


+ (NSDictionary *)getInnerEmojiDic
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmojisList"
                                                          ofType:@"plist"];
    NSDictionary *emojiDicArray = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    return [emojiDicArray objectForKey:@"lamadic"];
}

- (BOOL)isAllEmojisAndSpace
{
    NSArray *array = [self componentsSeparatedByCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableString *output = [[[NSMutableString alloc] initWithCapacity:0] ah_autorelease];
    for(NSString *word in array)
    {
        [output appendString:word];
    }
    
    return [output isAllEmojis];
}

- (BOOL)isAllEmojisAndSpaceNotInnerEmoji
{
    NSArray *array = [self componentsSeparatedByCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];

    NSMutableString *output = [[[NSMutableString alloc] initWithCapacity:0] ah_autorelease];
    for(NSString *word in array)
    {
        [output appendString:word];
    }

    return [output isAllEmojisNotInnerEmoji];
}

- (BOOL)isAllEmojis
{
    __block BOOL returnValue = YES;
    
    __block NSDictionary *emojiDic = [NSString getEmojiDic];
    __block NSDictionary *nationalFlagEmojiDic = [NSString getNationalFlagEmojiDic];

    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         
         if ([substring isNotEmpty] && ![emojiDic stringForKey:[substring getEmojiUTF8]])
         {
            // 国旗双字节，需要单独判断
             if (![nationalFlagEmojiDic stringForKey:[substring getEmojiUTF8]])
             {
                 NSLog(@"%@, %@", substring, [substring getEmojiUTF8]);
                 returnValue = NO;
                 *stop = YES;
             }
         }

    }];

    return returnValue;
}

- (BOOL)isAllEmojisNotInnerEmoji
{
    __block BOOL returnValue = YES;
    __block BOOL notInner = YES;

    __block NSDictionary *emojiDic = [NSString getEmojiDic];
    __block NSDictionary *innerEmojiDic = [NSString getInnerEmojiDic];

    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {

         if ([substring isNotEmpty])
         {
             if (![emojiDic stringForKey:[substring getEmojiUTF8]])
             {
                 returnValue = NO;
                 *stop = YES;
             }
             else if (notInner && [innerEmojiDic stringForKey:substring])
             {
                 notInner = NO;
             }
         }

     }];

    return returnValue && notInner;
}



// 是否有表情
- (BOOL)isContainsEmojis
{
    __block BOOL returnValue = NO;

    __block NSDictionary *emojiDic = [NSString getEmojiDic];

    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         
         if ([substring isNotEmpty] && [emojiDic stringForKey:[substring getEmojiUTF8]])
         {
             returnValue = YES;
             *stop = YES;
         }
         
     }];
    
    return returnValue;
}

- (BOOL)isInnerEmoji
{
    if (![self isNotEmpty])
    {
        return NO;
    }
    if (self.length > 2)
    {
        return NO;
    }

    NSDictionary *emojiDic = [NSString getInnerEmojiDic];

    if ([emojiDic stringForKey:self])
    {
        return YES;
    }

    return NO;
}

- (BOOL)isEmoji
{
    if (![self isNotEmpty])
    {
        return NO;
    }
    if (self.length > 2)
    {
        return NO;
    }

    NSDictionary *emojiDic = [NSString getEmojiDic];

    if ([emojiDic stringForKey:[self getEmojiUTF8]])
    {
        return YES;
    }

    return NO;
}

/*
- (BOOL)isEmoji
{
    if (![self isNotEmpty])
    {
        return NO;
    }
    if (self.length > 2)
    {
        return NO;
    }
    
    const unichar hs = [self characterAtIndex:0];
    
    if (0xd800 <= hs && hs <= 0xdbff)
    {
        if (self.length > 1)
        {
            const unichar ls = [self characterAtIndex:1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f)
            {
                return YES;
            }
        }
    }
    else if (self.length > 1)
    {
        const unichar ls = [self characterAtIndex:1];
        if (ls == 0x20e3)
        {
            return YES;
        }
    }
    else
    {
        if (0x2100 <= hs && hs <= 0x27ff)
        {
            return YES;
        }
        else if (0x2B05 <= hs && hs <= 0x2b07)
        {
            return YES;
        }
        else if (0x2934 <= hs && hs <= 0x2935)
        {
            return YES;
        }
        else if (0x3297 <= hs && hs <= 0x3299)
        {
            return YES;
        }
        else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
        {
            return YES;
        }
    }

    return NO;
}
*/

- (NSArray *)disassembleEmojis
{
    __block NSMutableString *string = [[[NSMutableString alloc] init] ah_autorelease];
    __block NSMutableArray *strArray = [[[NSMutableArray alloc] initWithCapacity:0] ah_autorelease];

    __block NSDictionary *emojiDic = [NSString getEmojiDic];

    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         
         if ([substring isNotEmpty] && [emojiDic stringForKey:[substring getEmojiUTF8]])
         {
             NSDictionary *strDic = nil;
             NSDictionary *emojiDic = nil;
             
             if ([string isNotEmpty])
             {
                 strDic = [[[NSDictionary alloc] initWithObjectsAndKeys:string, @"text", @"text", @"tag", nil] ah_autorelease];
                 [strArray addObject:strDic];
                 string = [[[NSMutableString alloc] init] ah_autorelease];
             }
             
             emojiDic = [[[NSDictionary alloc] initWithObjectsAndKeys:substring, @"text", @"emoji", @"tag", nil] ah_autorelease];
             [strArray addObject:emojiDic];
         }
         else
         {
             [string appendString:substring];
         }
         
     }];

    if ([string isNotEmpty])
    {
        NSDictionary *strDic = nil;
        strDic = [[[NSDictionary alloc] initWithObjectsAndKeys:string, @"text", @"text", @"tag", nil] ah_autorelease];
        [strArray addObject:strDic];
    }
    
    return strArray;
}

- (NSString *)parameterEmojis
{
    __block NSMutableArray *stringArray = [[[NSMutableArray alloc] init] ah_autorelease];
    NSString *allText = nil;

    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {

         [stringArray addObject:substring];

     }];

    NSDictionary *emojiDic = [NSString getEmojiDic];
    NSDictionary *nationalFlagEmojiCodeFirst = [NSString getNationalFlagEmojiCodeFirst];
    NSDictionary *nationalFlagEmojiCode = [NSString getNationalFlagEmojiCode];

    NSMutableArray *stringDicArray = [[[NSMutableArray alloc] init] ah_autorelease];

    NSMutableString *subText = [[[NSMutableString alloc] init] ah_autorelease];

    for (NSInteger i=0; i<stringArray.count; i++)
    {
        NSString *substring = stringArray[i];

        NSString *utf8 = [substring getEmojiUTF8];

        if ([emojiDic stringForKey:utf8])
        {
            if ([subText isNotEmpty])
            {
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"text", @"tag", subText, @"text", nil];
                [stringDicArray addObject:dic];

                subText = [[[NSMutableString alloc] init] ah_autorelease];
            }
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"emoji", @"tag", substring, @"text", nil];
            [stringDicArray addObject:dic];
        }
        else if ([nationalFlagEmojiCodeFirst stringForKey:utf8])
        {
            if ([subText isNotEmpty])
            {
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"text", @"tag", subText, @"text", nil];
                [stringDicArray addObject:dic];

                subText = [[[NSMutableString alloc] init] ah_autorelease];
            }

            if (i+1 < stringArray.count)
            {
                NSString *nationalFlagString = [[[NSString alloc] initWithFormat:@"%@%@", stringArray[i], stringArray[i+1]] ah_autorelease];

                if ([nationalFlagEmojiCode stringForKey:[nationalFlagString getEmojiUTF8]])
                {
                    i++;
                    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"emoji", @"tag", nationalFlagString, @"text", nil];
                    [stringDicArray addObject:dic];
                }
                else
                {
                    [subText appendString:substring];
                }
            }
            else
            {
                [subText appendString:substring];
            }
        }
        else
        {
            if ([substring isEqualToString:@"\""])
            {
                substring = @"\\\"";
            }
            if ([substring isEqualToString:@"\\"])
            {
                substring = @"\\\\";
            }
            [subText appendString:substring];
        }
    }

    if ([subText isNotEmpty])
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"text", @"tag", subText, @"text", nil];
        [stringDicArray addObject:dic];
    }

    NSMutableString *string = [[[NSMutableString alloc] init] ah_autorelease];
    for (NSDictionary *dic in stringDicArray)
    {
        if (string.length > 0)
        {
            [string appendString:@","];
        }

        NSString *tag = [dic stringForKey:@"tag"];
        NSString *text = [dic stringForKey:@"text"];

        if ([tag isEqual:@"emoji"])
        {
            NSString *str = [NSString stringWithFormat:@"{\"tag\":\"emoji\",\"text\":\"%@\"}", text];
            [string appendString:str];
        }
        else if ([tag isEqual:@"text"])
        {
            NSString *str = [NSString stringWithFormat:@"{\"tag\":\"text\",\"text\":\"%@\"}", text];
            [string appendString:str];
        }
    }

    allText = [NSString stringWithFormat:@"[%@]", string];
    return allText;
}

/*
- (NSString *)parameterEmojis
{
    nationalFlag = [[[NSMutableString alloc] init] ah_autorelease];
    __block NSMutableString *string = [[[NSMutableString alloc] init] ah_autorelease];
    __block NSMutableString *subText = [[[NSMutableString alloc] init] ah_autorelease];
    NSString *allText = nil;

    __block NSDictionary *emojiDic = [NSString getEmojiDic];

    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         
         if ([substring isNotEmpty] && [emojiDic stringForKey:[substring getEmojiUTF8]])
         {
             if (string.length > 0)
             {
                 [string appendString:@","];
             }
             
             if ([subText isNotEmpty])
             {
                 NSString *str = [NSString stringWithFormat:@"{\"tag\":\"text\",\"text\":\"%@\"},", subText];
                 [string appendString:str];
                 subText = [[[NSMutableString alloc] init] ah_autorelease];
             }
             
             NSString *str = [NSString stringWithFormat:@"{\"tag\":\"emoji\",\"text\":\"%@\"}", substring];
             [string appendString:str];
         }
         else
         {
             if ([substring isEqualToString:@"\""])
             {
                 substring = @"\\\"";
             }
             if ([substring isEqualToString:@"\\"])
             {
                 substring = @"\\\\";
             }
             [subText appendString:substring];
         }
         
     }];

    if ([subText isNotEmpty])
    {
        if (string.length > 0)
        {
            [string appendString:@","];
        }
        
        NSString *str = [NSString stringWithFormat:@"{\"tag\":\"text\",\"text\":\"%@\"}", subText];
        [string appendString:str];
    }

    allText = [NSString stringWithFormat:@"[%@]", string];
    return allText;
}
*/

- (NSString *)getEmojiUniCode;
{
    if (![self isNotEmpty])
    {
        return nil;
    }
    if (self.length > 4)
    {
        return nil;
    }

    NSData *data = [self dataUsingEncoding:NSUTF32LittleEndianStringEncoding];
    uint32_t unicode;
    [data getBytes:&unicode length:sizeof(uint32_t)];
    NSString *unicodeStr = [NSString stringWithFormat:@"%04x", unicode];

    uint32_t unicode1 = 0;
    if (data.length > 4)
    {
        NSRange range = NSMakeRange(sizeof(uint32_t), sizeof(uint32_t));
        [data getBytes:&unicode1 range:range];
        unicodeStr = [NSString stringWithFormat:@"%04x-%04x", unicode, unicode1];
    }
    uint32_t unicode2 = 0;
    if (data.length > 8)
    {
        NSRange range = NSMakeRange(sizeof(uint32_t)*2, sizeof(uint32_t));
        [data getBytes:&unicode2 range:range];
        unicodeStr = [NSString stringWithFormat:@"%04x-%04x-%04x", unicode, unicode1, unicode2];
    }

    return unicodeStr;
}

- (NSString *)getEmojiUTF8
{
    if (![self isNotEmpty])
    {
        return nil;
    }
    if (self.length > 4)
    {
        return nil;
    }

    NSString *utf8 = nil;

    uint8_t utf8_1 = 0;
    uint8_t utf8_2 = 0;
    uint8_t utf8_3 = 0;
    uint8_t utf8_4 = 0;
    uint8_t utf8_5 = 0;
    uint8_t utf8_6 = 0;
    uint8_t utf8_7 = 0;
    uint8_t utf8_8 = 0;

    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

    if (data.length <= 1)
    {
        return nil;
    }

    [data getBytes:&utf8_1 length:sizeof(uint8_t)];
    if (data.length > 1)
    {
        NSRange range = NSMakeRange(sizeof(uint8_t), sizeof(uint8_t));
        [data getBytes:&utf8_2 range:range];
        utf8 = [NSString stringWithFormat:@"%x%x", utf8_1, utf8_2];
    }
    if (data.length > 2)
    {
        NSRange range = NSMakeRange(sizeof(uint8_t)*2, sizeof(uint8_t));
        [data getBytes:&utf8_3 range:range];
        utf8 = [NSString stringWithFormat:@"%x%x%x", utf8_1, utf8_2, utf8_3];
    }
    if (data.length > 3)
    {
        NSRange range = NSMakeRange(sizeof(uint8_t)*3, sizeof(uint8_t));
        [data getBytes:&utf8_4 range:range];
        utf8 = [NSString stringWithFormat:@"%x%x%x%x", utf8_1, utf8_2, utf8_3, utf8_4];
    }
    if (data.length > 4)
    {
        NSRange range = NSMakeRange(sizeof(uint8_t)*4, sizeof(uint8_t));
        [data getBytes:&utf8_5 range:range];
        utf8 = [NSString stringWithFormat:@"%x%x%x%x%x", utf8_1, utf8_2, utf8_3, utf8_4, utf8_5];
    }
    if (data.length > 5)
    {
        NSRange range = NSMakeRange(sizeof(uint8_t)*5, sizeof(uint8_t));
        [data getBytes:&utf8_6 range:range];
        if (utf8_4 == 0xef && utf8_5 == 0xb8 && utf8_6 == 0x8f)
        {
            utf8 = [NSString stringWithFormat:@"%x%x%x", utf8_1, utf8_2, utf8_3];
        }
        else
        {
            utf8 = [NSString stringWithFormat:@"%x%x%x%x%x%x", utf8_1, utf8_2, utf8_3, utf8_4, utf8_5, utf8_6];
        }
    }
    if (data.length > 6)
    {
        NSRange range = NSMakeRange(sizeof(uint8_t)*6, sizeof(uint8_t));
        [data getBytes:&utf8_7 range:range];
        if (utf8_5 == 0xef && utf8_6 == 0xb8 && utf8_7 == 0x8f)
        {
            utf8 = [NSString stringWithFormat:@"%x%x%x%x", utf8_1, utf8_2, utf8_3, utf8_4];
        }
        else
        {
            utf8 = [NSString stringWithFormat:@"%x%x%x%x%x%x%x", utf8_1, utf8_2, utf8_3, utf8_4, utf8_5, utf8_6, utf8_7];
        }
    }
    if (data.length > 7)
    {
        NSRange range = NSMakeRange(sizeof(uint8_t)*7, sizeof(uint8_t));
        [data getBytes:&utf8_8 range:range];

            utf8 = [NSString stringWithFormat:@"%x%x%x%x%x%x%x%x", utf8_1, utf8_2, utf8_3, utf8_4, utf8_5, utf8_6, utf8_7, utf8_8];
        }

    return utf8;
}

@end


@implementation NSString (paths)

#pragma mark Standard Paths

+ (NSString *)cachesPath
{
    static dispatch_once_t onceToken;
    static NSString *cachedPath;
    
    dispatch_once(&onceToken, ^{
        cachedPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    });
    
    return cachedPath;
}

+ (NSString *)documentsPath
{
    static dispatch_once_t onceToken;
    static NSString *cachedPath;
    
    dispatch_once(&onceToken, ^{
        cachedPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    });
    
    return cachedPath;
}

+ (NSString *)libraryPath
{
    static dispatch_once_t onceToken;
    static NSString *cachedPath;
    
    dispatch_once(&onceToken, ^{
        cachedPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    });
    
    return cachedPath;
}

+ (NSString *)bundlePath
{
    return [[NSBundle mainBundle] bundlePath];
}


#pragma mark Temporary Paths

+ (NSString *)temporaryPath
{
    static dispatch_once_t onceToken;
    static NSString *cachedPath;
    
    dispatch_once(&onceToken, ^{
        cachedPath = NSTemporaryDirectory();
    });
    
    return cachedPath;
}

+ (NSString *)pathForTemporaryFile
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    NSString *tmpPath = [[NSString temporaryPath] stringByAppendingPathComponent:(__bridge NSString *)newUniqueIdString];
    CFRelease(newUniqueId);
    CFRelease(newUniqueIdString);
    
    return tmpPath;
}

#pragma mark Working with Paths

// sdfds123 --> sdfds124
- (NSString *)pathByIncrementingSequenceNumber
{
    NSString *baseName = [self stringByDeletingPathExtension];
    NSString *extension = [self pathExtension];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\(([0-9]+)\\)$" options:0 error:NULL];
    __block NSInteger sequenceNumber = 0;
    
    [regex enumerateMatchesInString:baseName options:0 range:NSMakeRange(0, [baseName length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        
        NSRange range = [match rangeAtIndex:1]; // first capture group
        NSString *substring= [self substringWithRange:range];
        
        sequenceNumber = [substring integerValue];
        *stop = YES;
    }];
    
    NSString *nakedName = [baseName pathByDeletingSequenceNumber];
    
    if ([extension isEqualToString:@""])
    {
        return [nakedName stringByAppendingFormat:@"(%ld)", (long)sequenceNumber+1];
    }
    
    return [[nakedName stringByAppendingFormat:@"(%ld)", (long)sequenceNumber+1] stringByAppendingPathExtension:extension];
}

// sdfds123 --> sdfds
- (NSString *)pathByDeletingSequenceNumber
{
    NSString *baseName = [self stringByDeletingPathExtension];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\([0-9]+\\)$" options:0 error:NULL];
    __block NSRange range = NSMakeRange(NSNotFound, 0);
    
    [regex enumerateMatchesInString:baseName options:0 range:NSMakeRange(0, [baseName length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
        
        range = [match range];
        
        *stop = YES;
    }];
    
    if (range.location != NSNotFound)
    {
        return [self stringByReplacingCharactersInRange:range withString:@""];
    }
    
    return self;
}

@end


