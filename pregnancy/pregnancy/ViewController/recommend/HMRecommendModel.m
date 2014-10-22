//
//  HMRecommendModel.m
//  lama
//
//  Created by songxf on 13-6-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMRecommendModel.h"

@implementation HMRecommendModel

@synthesize topicId;
@synthesize picUrl;
@synthesize title;

- (void)dealloc
{
    [title release];
    [picUrl release];
    [topicId release];
    
    [super dealloc];
}

- (NSURL *)getPicURL
{
    return [NSURL URLWithString:picUrl];
}

@end
