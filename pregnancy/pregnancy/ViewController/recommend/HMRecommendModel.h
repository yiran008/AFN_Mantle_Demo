//
//  HMRecommendModel.h
//  lama
//
//  Created by songxf on 13-6-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMRecommendModel : NSObject

// 标题
@property (nonatomic, retain) NSString *title;

// 图片地址
@property (nonatomic, retain) NSString *picUrl;

// 帖子ID
@property (nonatomic, retain) NSString *topicId;


- (NSURL *)getPicURL;


@end
