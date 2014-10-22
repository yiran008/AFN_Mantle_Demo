//
//  HMCreateTopicRequest.m
//  lama
//
//  Created by mac on 13-10-31.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMApiRequest.h"
#import "BBTimeUtility.h"

@implementation HMApiRequest (HMCreateTopicRequest)

+ (ASIFormDataRequest *)createTopicWithLoginString:(NSString *)loginString gourpID:(NSString *)groupID title:(NSString *)title content:(NSString *)content photoIDList:(NSString *)photoIDList is_question:(BOOL)is_question
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/create_discussion", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setPostValue:loginString forKey:LOGIN_STRING_KEY];
    
    [request setPostValue:groupID forKey:GROUP_ID_KEY];

    if ([title isNotEmpty])
    {
        [request setPostValue:title forKey:TOPIC_TITLE_KEY];
    }

    if ([content isNotEmpty])
    {
        [request setPostValue:content forKey:TOPIC_CONTENT_KEY];
    }

    if ([photoIDList isNotEmpty] != 0)
    {
        [request setPostValue:photoIDList forKey:PHOTO_ID_KEY];
    }

    if (is_question)
    {
        [request setPostValue:@"1" forKey:@"is_question"];
    }
    else
    {
        [request setPostValue:@"0" forKey:@"is_question"];
    }


    ASI_DEFAULT_INFO_POST
    
    [request setTimeOutSeconds:20];
    [request setNumberOfTimesToRetryOnTimeout:0];

    return request;
}

/*
 http://test5.babytree-dev.com/api/mobile_community/create_discussion?mac=70bb863769c0e53436fc345eb2c6e8a398021808&client_type=ios&result_format=text_json&app_id=lama&version=1.4&login_string=83100478_a13a9c46e08dfb1f55a87e08909c1a13_1390378035&group_id=111&title=[{"tag":"text","text":"赶紧4"}]&content=[{"tag":"text","text":"都v辉"}]&is_question=1&longitude=116.455445&latitude=39.926327
 2014-01-22 16:09:26.701 lama[10740:720f] retryCount = 0
 2014-01-22 16:09:37.208 lama[10740:720f] retryCount = 1
 2014-01-22 16:09:40.479 lama[10740:60b] status: similar_error
 */

+ (ASIFormDataRequest *)replyTopicNewWithLoginString:(NSString *)theLoginString withTopicID:(NSString *)theTopicID withContent:(NSString *)theContent withPhotoData:(NSData *)imageData withPosition:(NSString *)position withReferID:(NSString *)referID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/create_photo_reply",BABYTREE_UPLOAD_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:theLoginString forKey:LOGIN_STRING_KEY];
    [request setPostValue:theTopicID forKey:TOPIC_ID_KEY];
    [request setPostValue:theContent forKey:TOPIC_CONTENT_KEY];

    if (position != nil)
    {
        [request setPostValue:position forKey:POSITION_KEY];
    }

    if (referID != nil)
    {
        [request setPostValue:referID forKey:REFER_ID_KEY];
    }

    if (imageData != nil && imageData.length != 0)
    {
        NSString *file_name = [BBTimeUtility stringDateWithFormat:@"yyyy-MM-dd-HH-mm-ss"];
        NSString *upload_name =[NSString stringWithFormat:@"%@.jpg",file_name ];
        [request setData:imageData withFileName:upload_name andContentType:@"image/jpeg" forKey:@"upload_file"];
        NSString *time_str = [BBTimeUtility stringDateWithFormat:@"yyyy-MM-dd-HH-mm-ss"];
        [request setPostValue:[NSString stringWithFormat:@"%@%@",[BBDeviceUtility macAddress],time_str] forKey:SESSION_ID_KEY];
        [request setPostValue:@"1" forKey:@"with_photo"];
    }
    else
    {
        [request setPostValue:@"2" forKey:@"with_photo"];
    }

    ASI_DEFAULT_INFO_POST

    [request setTimeOutSeconds:30];
    [request setNumberOfTimesToRetryOnTimeout:0];

    return request;
}

+ (ASIFormDataRequest *)replyTopicWithLoginString:(NSString *)theLoginString withTopicID:(NSString *)theTopicID withContentArray:(NSString *)contentString withPhotoData:(NSData *)imageData withPosition:(NSString *)position withReferID:(NSString *)referID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/new_create_photo_reply", BABYTREE_UPLOAD_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    [request setPostValue:theLoginString forKey:LOGIN_STRING_KEY];
    [request setPostValue:theTopicID forKey:TOPIC_ID_KEY];

    if ([contentString isNotEmpty])
    {
        [request setPostValue:contentString forKey:TOPIC_CONTENT_KEY];
    }

    if (position != nil)
    {
        [request setPostValue:position forKey:POSITION_KEY];
    }

    if (referID != nil)
    {
        [request setPostValue:referID forKey:REFER_ID_KEY];
    }

    if (imageData != nil && imageData.length != 0)
    {
        NSString *file_name = [BBTimeUtility stringDateWithFormat:@"yyyy-MM-dd-HH-mm-ss"];
        NSString *upload_name =[NSString stringWithFormat:@"%@.jpg",file_name ];
        [request setData:imageData withFileName:upload_name andContentType:@"image/jpeg" forKey:@"upload_file"];
        NSString *time_str = [BBTimeUtility stringDateWithFormat:@"yyyy-MM-dd-HH-mm-ss"];
        [request setPostValue:[NSString stringWithFormat:@"%@%@",[BBDeviceUtility macAddress],time_str] forKey:SESSION_ID_KEY];
        [request setPostValue:@"1" forKey:@"with_photo"];
    }
    else
    {
        [request setPostValue:@"2" forKey:@"with_photo"];
    }

    ASI_DEFAULT_INFO_POST

    [request setTimeOutSeconds:30];
    [request setNumberOfTimesToRetryOnTimeout:0];

    return request;
}

+ (ASIFormDataRequest *)uploadPhoto:(NSData *)imageData withLoginString:(NSString *)loginString
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_image/upload_images", BABYTREE_UPLOAD_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:loginString forKey:LOGIN_STRING_KEY];
    NSString *file_name = [BBTimeUtility stringDateWithFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *upload_name = [NSString stringWithFormat:@"%@.jpg", file_name];
    [request setData:imageData withFileName:upload_name andContentType:@"image/jpeg" forKey:@"upload_file"];
    
    ASI_DEFAULT_INFO_POST
    
    [request setTimeOutSeconds:30];
    [request setNumberOfTimesToRetryOnTimeout:0];
    
    return request;
}

@end