//
//  BBRecordRequest.m
//  pregnancy
//
//  Created by whl on 13-9-22.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBRecordRequest.h"

@implementation BBRecordRequest


+ (ASIFormDataRequest *)publishRecord:(NSString *)recordContent withRecodTimes:(NSString *)recordTimes withPhotoData:(NSData *)imageData withPrivate:(NSString *)isPrivate
{    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_mood/create_mood",BABYTREE_UPLOAD_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:recordContent forKey:@"text"];
    [request setPostValue:recordTimes   forKey:@"publish_ts"];
    [request setPostValue:isPrivate     forKey:@"is_private"];
    if (imageData != nil && imageData.length != 0) {
        NSString *file_name = [BBTimeUtility stringDateWithFormat:@"yyyy-MM-dd-HH-mm-ss"];
        NSString *upload_name =[NSString stringWithFormat:@"%@.jpg",file_name ];
        [request setData:imageData withFileName:upload_name andContentType:@"image/jpeg" forKey:@"upload_file"];
        NSString *time_str = [BBTimeUtility stringDateWithFormat:@"yyyy-MM-dd-HH-mm-ss"];
        [request setPostValue:[NSString stringWithFormat:@"%@%@",[BBDeviceUtility macAddress],time_str] forKey:SESSION_ID_KEY];
    }
    ASI_DEFAULT_INFO_POST
    [request setTimeOutSeconds:30];
    
    return request;
}


+ (ASIFormDataRequest *)setRecordPrivate:(NSString *)isPrivate withRecodID:(NSString *)recordID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_mood/set_private",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:recordID   forKey:@"mood_id"];
    [request setPostValue:isPrivate     forKey:@"is_private"];
    ASI_DEFAULT_INFO_POST
    return request;
}

+ (ASIFormDataRequest *)deleteRecord:(NSString *)recordID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_mood/delete_mood",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:recordID   forKey:@"mood_id"];
    ASI_DEFAULT_INFO_POST
    return request;
}

+ (ASIFormDataRequest *)recordMoon:(NSString *)timeTs
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_mood/mood_time_axis",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:timeTs   forKey:@"last_ts"];
    ASI_DEFAULT_INFO_POST
    return request;
}

+ (ASIFormDataRequest *)recordMoon:(NSString *)timeTs withUserEncodeId:(NSString *)userEncodeId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_mood/mood_time_axis",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:userEncodeId forKey:@"enc_user_id"];
    [request setPostValue:timeTs   forKey:@"last_ts"];
    ASI_DEFAULT_INFO_POST
    return request;
}

+ (ASIFormDataRequest *)recordPark:(NSString *)start
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_mood/mood_ground",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    [request setPostValue:start   forKey:@"start"];
    [request setPostValue:@"20"  forKey:@"limit"];
    ASI_DEFAULT_INFO_POST
    return request;
}

@end
