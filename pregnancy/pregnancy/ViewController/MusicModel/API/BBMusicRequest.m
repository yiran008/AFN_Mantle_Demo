//
//  BBMusicRequest.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBMusicRequest.h"
#import "BBConfigureAPI.h"
@implementation BBMusicRequest
+ (ASIFormDataRequest*)getMusicList
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/yunqi_mobile/music_category_list",BABYTREE_URL_SERVER]];

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:[BBUser getEncId] forKey:@"enc_user_id"];

    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)getMusicListWithCategoryID:(NSString *)categoryid
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/yunqi_mobile/music_list",BABYTREE_URL_SERVER]];

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:categoryid forKey:@"category_id"];
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)getScanMap
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/yunqi_mobile/scan_map",BABYTREE_URL_SERVER]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}
@end
