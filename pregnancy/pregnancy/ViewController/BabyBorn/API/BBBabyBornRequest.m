//
//  BBBabyBornRequest.m
//  pregnancy
//
//  Created by yxy on 14-4-16.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBBabyBornRequest.h"

@implementation BBBabyBornRequest

// 发表报喜贴
+ (ASIFormDataRequest *)babyBornTopicWithBrithday:(NSString *)baby_birthday babyWeight:(NSString *)baby_weight babyHeight:(NSString *)baby_height babySex:(NSString *)baby_sex topicTitle:(NSString *)title topicContent:(NSString *)content phtotoID:(NSString *)photo_id
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/create_baoxi_discussion",BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setPostValue:[BBUser getLoginString] forKey:LOGIN_STRING_KEY];
    
    if([baby_birthday isNotEmpty])
    {
       [request setPostValue:baby_birthday forKey:@"birthday"];
    }
    
    if([baby_weight isNotEmpty])
    {
        [request setPostValue:baby_weight forKey:@"baby_weight"];
    }
    
    if([baby_height isNotEmpty])
    {
        [request setPostValue:baby_height forKey:@"baby_height"];
    }
    
    if([baby_sex isNotEmpty])
    {
        [request setPostValue:baby_sex forKey:@"baby_sex"];
    }
    
    if([title isNotEmpty])
    {
        [request setPostValue:title forKey:@"title"];
    }
    
    if([content isNotEmpty])
    {
        [request setPostValue:content forKey:@"content"];
    }
    
    if([photo_id isNotEmpty])
    {
        [request setPostValue:photo_id forKey:@"photo_id"];
    }
    
    ASI_DEFAULT_INFO_POST
    
    return request;
}

// 上传照片
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
