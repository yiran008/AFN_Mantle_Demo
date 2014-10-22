//
//  BBBabyBornRequest.h
//  pregnancy
//
//  Created by yxy on 14-4-16.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBBabyBornRequest : NSObject

// 报喜贴发表
+ (ASIFormDataRequest *)babyBornTopicWithBrithday:(NSString *)baby_birthday babyWeight:(NSString *)baby_weight babyHeight:(NSString *)baby_height babySex:(NSString *)baby_sex topicTitle:(NSString *)title topicContent:(NSString *)content phtotoID:(NSString *)photo_id ;

// 上传照片
+ (ASIFormDataRequest *)uploadPhoto:(NSData *)imageData withLoginString:(NSString *)loginString;
@end
