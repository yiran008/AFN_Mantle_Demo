//
//  BBMusicRequest.h
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest+BBDebug.h"
#import "BBConfigureAPI.h"
@interface BBMusicRequest : NSObject

+ (ASIFormDataRequest*)getMusicList;
+ (ASIFormDataRequest *)getMusicListWithCategoryID:(NSString *)categoryid;
+ (ASIFormDataRequest *)getScanMap;
@end
