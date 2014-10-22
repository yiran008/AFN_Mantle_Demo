//
//  HMPhotoClass.m
//  lama
//
//  Created by mac on 14-3-27.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMPhotoClass.h"

@implementation HMPhotoItem

- (void)dealloc
{
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code
        _m_isDeleted = NO;
    }

    return self;
}


@end


@implementation HMPhotoClass

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code
        //self.m_PhotoList = [NSMutableArray arrayWithCapacity:0];
        _m_ShowDetail = NO;
        _m_CanDelete = NO;
    }

    return self;
}

- (NSInteger)m_PhotoCount
{
    return self.m_PhotoList.count;
}

@end
