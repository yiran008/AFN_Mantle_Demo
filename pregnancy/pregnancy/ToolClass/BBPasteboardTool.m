//
//  BBPasteboardTool.m
//  BBAuthorization
//
//  Created by 杨 東霖 on 13-7-16.
//  Copyright (c) 2013年 杨 東霖. All rights reserved.
//

#import "BBPasteboardTool.h"
#import "Security+base64.h"

@implementation BBPasteboardTool

//创建粘贴板，使用前先判断用户是否已登录。
+ (void)creatPasteboard
{
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:PASTEBOARD_NAME(@"shareLoginApp") create:YES];
    pasteboard.persistent = YES;
    
}
//在授权时将登陆信息拷贝到粘贴板
+ (void)setLoginDesToPasteboardWith:(NSDictionary *)loginDic
{
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:PASTEBOARD_NAME(@"shareLoginApp") create:NO];

    [pasteboard setValue:[NSKeyedArchiver archivedDataWithRootObject:loginDic]
       forPasteboardType:@"logintype"];
}

//在用户退出登录时要删除已创建的粘贴板
+ (void)removeLoginInfoPasteboard
{
    [UIPasteboard removePasteboardWithName:PASTEBOARD_NAME(@"shareLoginApp")];
}
@end
