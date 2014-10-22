//
//  BBRecordClass.h
//  pregnancy
//
//  Created by heyanyang on 2014年9月28日 星期日.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBRecordClass : NSObject

@property (nonatomic,strong)NSString *date;

@property(nonatomic,strong)NSString *mood_id;
@property(nonatomic,strong)NSString *publish_ts;
@property(nonatomic,strong)NSString *create_ts;
@property(nonatomic,strong)NSString *img_small;
@property(nonatomic,strong)NSString *img_middle;
@property(nonatomic,strong)NSString *img_big;
@property(nonatomic,strong)NSString *text;
@property(nonatomic,strong)NSString *is_private;
@property(nonatomic,strong)NSString *that_time_birth_ts;
@property(nonatomic,strong)NSString *that_time_age;
@property(nonatomic,strong)NSString *enc_user_id;

- (id)initWithJsonData:(NSDictionary *)jsonData;

@end