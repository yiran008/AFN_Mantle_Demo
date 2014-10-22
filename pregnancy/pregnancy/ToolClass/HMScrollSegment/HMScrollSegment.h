//
//  HMScrollSegment.h
//  lama
//
//  Created by jiangzhichao on 14-4-4.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMScrollSegmentDelegate;

@interface HMScrollSegment : UIView

// 点击Button代理
@property (nonatomic, weak) id <HMScrollSegmentDelegate> delegate;


// 初始化方法
- (id)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)titlesArray;

// 刷新方法
- (void)freshButtonWithTitles:(NSArray *)titleArray;

// 滚动完成之后调用：调整Btn显示
- (void)selectBtnAtIndex:(NSUInteger)index;

// 滚动之中调用：调整line位置和大小
- (void)scrollLineFromIndex:(NSInteger)fromIndex relativeOffsetX:(CGFloat)relativeOffsetX;

// 调整背景的偏移量
- (void)scrollBackAtIndex:(NSUInteger)index;

@end

@protocol HMScrollSegmentDelegate <NSObject>

- (void)scrollSegment:(HMScrollSegment *)scrollSegment selectedButtonAtIndex:(NSUInteger)index;

@end
