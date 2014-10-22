//
//  BBPasteboardTool.h
//  BBAuthorization
//
//  Created by 杨 東霖 on 13-7-16.
//  Copyright (c) 2013年 杨 東霖. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LOGIN_TYPE                                @"type"
#define LOGIN_NAME                                @"name"
#define LOGIN_PASSWORD                            @"password"
#define LOGIN_TOKEN                               @"token"
#define LOGIN_OPENID                              @"openid"
#define PASTEBOARD_NAME(appName)  [NSString stringWithFormat:@"%@Pasteboard",appName]

@interface BBPasteboardTool : NSObject

+ (void)creatPasteboard;
+ (void)setLoginDesToPasteboardWith:(NSDictionary *)loginDic;
+ (void)removeLoginInfoPasteboard;
@end
