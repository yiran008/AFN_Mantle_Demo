//
//  BBShareConfig.h
//  pregnancy
//
//  Created by zhongfeng on 13-8-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBShareConfig : NSObject

// 原分享 无手机QQ分享
+(NSMutableArray *)getShareData;
// 增加手机QQ分享
+(NSMutableArray *)getShareDataAddQQ;
// 增加保存到相册
+(NSMutableArray *)getShareDataAddAlbum;

@end
