//
//  BBEncryptionUtil.h
//  Encryption
//
//  Created by 柏旭 肖 on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PRIVATE_KEY (@"r=<me)=)o7Vl@;Kx0+KV*&")

@interface BBEncryptionUtil : NSObject

+ (NSString*)encodeString:(NSString*)string;
+ (NSString*)decodeString:(NSString*)string;

+ (NSString*)clientToken;

@end
