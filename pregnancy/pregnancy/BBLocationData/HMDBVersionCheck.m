//
//  HMDBVersionCheck.m
//  lama
//
//  Created by mac on 14-7-21.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMDBVersionCheck.h"

#define DBVER_DRAFTBOX              @"1.0"
#define DBVER_DETAILREAD            @"1.0"

#define DBVER_DRAFTBOX_KEY          @"DBver_draftbox_key"
#define DBVER_DETAILREAD_KEY        @"DBver_detailread_key"


@implementation HMDBVersionCheck

+ (BOOL)checkDraftBox_DBVer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *detailRead_DBVer = [defaults objectForKey:DBVER_DRAFTBOX_KEY];
    
    if ([detailRead_DBVer isEqualToString:DBVER_DRAFTBOX])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (void)setDraftBox_DBVer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:DBVER_DRAFTBOX forKey:DBVER_DRAFTBOX_KEY];
    [defaults synchronize];
}

+ (BOOL)checkDetailRead_DBVer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *detailRead_DBVer = [defaults objectForKey:DBVER_DETAILREAD_KEY];

    if ([detailRead_DBVer isEqualToString:DBVER_DETAILREAD])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (void)setDetailRead_DBVer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:DBVER_DETAILREAD forKey:DBVER_DETAILREAD_KEY];
    [defaults synchronize];
}


@end
