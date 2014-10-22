//
//  BBStatisticsUtil.m
//  pregnancy
//
//  Created by babytree babytree on 12-8-21.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBStatisticsUtil.h"
#import "ASIFormDataRequest.h"

#define UPLOAD_DATA @"BBStatisticsUtil_uplaodData"
#define DATA @"BBStatisticsUtil_data"
#define PREVIOUS_EVENT @"BBStatisticsUtil_previousEvent"
#define MAX_DATA_SIZE (2097152)

@implementation BBStatisticsUtil

+ (NSString *)getUploadData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uplaodData = [defaults objectForKey:UPLOAD_DATA];
    if (uplaodData==nil) {
        NSString *data = [defaults objectForKey:DATA];
        if (data==nil) {
            return nil;
        }else {
            [defaults setObject:data forKey:UPLOAD_DATA];
            [defaults setObject:nil forKey:DATA];
            return data;
        }
    }else {
        NSString *data = [defaults objectForKey:DATA];
        if (data==nil) {
            return uplaodData;
        }else {
            NSString *postData = [NSString stringWithFormat:@"%@,%@",uplaodData,data];
            [defaults setObject:postData forKey:UPLOAD_DATA];
            [defaults setObject:nil forKey:DATA];
            return postData;
        }
    }
}

+ (void)clearUploadData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:UPLOAD_DATA];
}

+ (void)setEvent:(NSString *)event{
    return ;
}

@end
