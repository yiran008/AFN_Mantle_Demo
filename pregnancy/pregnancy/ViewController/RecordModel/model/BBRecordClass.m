//
//  BBRecordClass.m
//  pregnancy
//
//  Created by heyanyang on 2014年9月28日 星期日.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBRecordClass.h"

@implementation BBRecordClass

- (id)initWithJsonData:(NSDictionary *)jsonData
{
    self = [self init];
    
    if (self)
    {
        self.date = [jsonData stringForKey:@"date"];
        self.mood_id = [jsonData stringForKey:@"mood_id"];
        self.publish_ts = [jsonData stringForKey:@"publish_ts"];
        self.create_ts = [jsonData stringForKey:@"create_ts"];
        self.img_small = [jsonData stringForKey:@"img_small"];
        self.img_middle = [jsonData stringForKey:@"img_middle"];
        self.img_big = [jsonData stringForKey:@"img_big"];
        self.text = [jsonData stringForKey:@"text"];
        self.is_private = [jsonData stringForKey:@"is_private"];
        self.that_time_birth_ts = [jsonData stringForKey:@"that_time_birth_ts"];
        self.that_time_age = [jsonData stringForKey:@"that_time_age"];
        self.enc_user_id = [jsonData stringForKey:@"enc_user_id"];
    }
    
    return self;
}

@end