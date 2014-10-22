//
//  BBListViewContentTemplate.h
//  pregnancy
//
//  Created by babytree babytree on 12-5-9.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@protocol BBListViewInfoDelegate <NSObject>
-(NSInteger)listTotalCountValue;
-(NSInteger)loadedTotalCountValue;
-(NSInteger)pageValue;
@end

@interface BBListViewInfo : NSObject{
//     id<BBListViewInfoDelegate> listViewInfoDelegate;
}
@property(assign)id<BBListViewInfoDelegate> listViewInfoDelegate;

- (NSInteger)listTotalCount;
- (NSInteger)loadedTotalCount;
- (NSInteger)page;

@end
