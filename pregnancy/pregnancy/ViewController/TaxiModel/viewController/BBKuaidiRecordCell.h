//
//  BBKuaidiRecordCell.h
//  pregnancy
//
//  Created by MAYmac on 13-12-12.
//  Copyright (c) 2013年 babytree. All rights reserved.
//
//  打车记录
#import <UIKit/UIKit.h>

@protocol BBKuaidiRecordCellDelegate <NSObject>
//点击返现按钮
- (void)applyForCashBackAtIndex:(int)index;

@end

@interface BBKuaidiRecordCell : UITableViewCell

@property(nonatomic,assign)id <BBKuaidiRecordCellDelegate>delegate;

- (void)setData:(NSDictionary *)cellData atIndex:(int)_index;

@end
