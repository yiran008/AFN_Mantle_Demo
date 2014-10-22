//
//  HMDBVersionCheck.h
//  lama
//
//  Created by mac on 14-7-21.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMDBVersionCheck : NSObject

+ (BOOL)checkDraftBox_DBVer;
+ (void)setDraftBox_DBVer;

+ (BOOL)checkDetailRead_DBVer;
+ (void)setDetailRead_DBVer;

@end
