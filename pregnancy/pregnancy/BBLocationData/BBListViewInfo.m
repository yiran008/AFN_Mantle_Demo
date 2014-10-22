//
//  BBListViewContentTemplate.m
//  pregnancy
//
//  Created by babytree babytree on 12-5-9.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBListViewInfo.h"

@implementation BBListViewInfo

//@synthesize listViewInfoDelegate;

- (NSInteger)listTotalCount{
    return [self.listViewInfoDelegate listTotalCountValue];
}
- (NSInteger)loadedTotalCount{
    return [self.listViewInfoDelegate loadedTotalCountValue];
}
- (NSInteger)page{
    return [self.listViewInfoDelegate pageValue];
}
@end
