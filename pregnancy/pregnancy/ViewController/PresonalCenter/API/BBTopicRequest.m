//
//  BBTopicManagement.m
//  pregnancy
//
//  Created by Jun Wang on 12-3-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBTopicRequest.h"
#import "BBDeviceUtility.h"
#import "BBLocation.h"
#import "BBUser.h"
#import "BBTimeUtility.h"
#import "ASIFormDataRequest+BBDebug.h"

@implementation BBTopicRequest

+ (ASIFormDataRequest *)getCollectTopic:(NSString *)pages
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/get_fav_list",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:pages forKey:@"page"];
    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)getCollectKnowledge:(NSString *)pages
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_knowledge/collect_list",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setGetValue:pages forKey:@"page"];
    [request setGetValue:[BBUser getLoginString] forKey:LOGIN_STRING];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

+ (ASIFormDataRequest *)uploadIcon:(NSData *)imageData withLoginString:(NSString *)loginString
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/muser/modify_avatar", BABYTREE_UPLOAD_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:loginString forKey:LOGIN_STRING_KEY];
    NSString *file_name = [BBTimeUtility stringDateWithFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *upload_name =[NSString stringWithFormat:@"%@.jpg",file_name ];
    [request setData:imageData withFileName:upload_name andContentType:@"image/jpeg" forKey:@"upload_file"];
    NSString *time_str = [BBTimeUtility stringDateWithFormat:@"yyyy-MM-dd-HH-mm-ss"];
    [request setPostValue:[NSString stringWithFormat:@"%@%@",[BBDeviceUtility macAddress],time_str] forKey:SESSION_ID_KEY];
    [request setPostValue:@"user icon" forKey:@"description"];
    [request setPostValue:@"open" forKey:@"privacy"];
    
    ASI_DEFAULT_INFO_POST
    
    [request setTimeOutSeconds:30];
    return request;
}

@end
