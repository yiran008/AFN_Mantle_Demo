//
//  DiscuzRequest.m
//  pregnancy
//
//  Created by lijie on 12-3-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBDiscuzRequest.h"
#import "BBConfigureAPI.h"
#import "BBUser.h"
#import "BBPregnancyInfo.h"
#import "BBDeviceUtility.h"
#import "BBLocation.h"
#import "BBDeviceUtility.h"

@implementation BBDiscuzRequest

+ (ASIFormDataRequest *)discuzListByListSort:(ListSort) listSort withGroupId:(NSString *)groupId withPage:(NSString *)page withArea:(id)area
{
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/get_group_discuz_list",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:groupId forKey:GROUP_ID_KEY];
    [request setGetValue:page forKey:PAGE_KEY];
    [request setGetValue:@"1" forKey:@"has_group_info"];
    if(area !=nil){
        if([[area stringForKey:@"type"] isEqualToString:@"province"]){
            [request setGetValue:[area stringForKey:@"id"] forKey:@"province_id"];
        }else if([[area stringForKey:@"type"] isEqualToString:@"city"]){
            [request setGetValue:[area stringForKey:@"id"] forKey:@"city_province_id"];
        }
    }else{
        if(listSort==LastReply){
            [request setGetValue:@"last_response_ts" forKey:@"orderby"];
        }else if(listSort==LastPublish){
            [request setGetValue:@"create_ts" forKey:@"orderby"];
        }else if(listSort==LicoriceTopic){
            [request setGetValue:@"yes" forKey:@"is_elite"];
        }
    }
    if ([BBUser isLogin]) {
        [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)myPostList:(NSInteger) start withUserEncodeId:(NSString *)userEncodeId
{
   NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/get_user_discuz_list_v2",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:userEncodeId forKey:USER_ENCODE_ID_KEY];
    [request setGetValue:POSTS forKey:TYPE_KEY];
    [request setGetValue:@"20" forKey:@"limit"];
    [request setGetValue:[NSString stringWithFormat:@"%d",start] forKey:@"page"];
    if ([BBUser isLogin]) {
        [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)myReply:(NSInteger)start withUserEncodeId:(NSString *)userEncodeId
{    
      NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/get_user_discuz_list_v2",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:userEncodeId forKey:USER_ENCODE_ID_KEY];
    [request setGetValue:REPLY forKey:TYPE_KEY];
    [request setGetValue:@"20" forKey:@"limit"];
    [request setGetValue:[NSString stringWithFormat:@"%d",start] forKey:@"page"];
    if ([BBUser isLogin]) {
        [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING];
    }
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

@end
