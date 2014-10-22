//
//  BBHistoryDeleteDelegate.h
//  pregnancy
//
//  Created by 柏旭 肖 on 12-7-9.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBHistoryDeleteDelegate <NSObject>
- (void)deleteHistory:(NSInteger)index;
@end
