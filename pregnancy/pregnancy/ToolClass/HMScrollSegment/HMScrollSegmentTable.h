//
//  HMScrollSegmentTable.h
//  lama
//
//  Created by jiangzhichao on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMScrollSegment.h"

@interface HMScrollSegmentTable : UIView
<
    UIScrollViewDelegate,
    HMScrollSegmentDelegate
>
{
    NSUInteger s_TableViewCurrentIndex;
}

// 存储TableView
@property (nonatomic, strong) NSMutableArray *m_TableArray;
// 存储title
@property (nonatomic, strong) NSArray *m_TitleArray;
// 存储id
@property (nonatomic, strong) NSArray *m_IdArray;
// 上方滚动条
@property (nonatomic, strong) HMScrollSegment *m_ScrollSegment;
// TableView的滚动背景
@property (nonatomic, strong) UIScrollView *m_TableBackScrollView;

// 初始化方法
- (id)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)titlesArray idArray:(NSArray *)idArray;
// 刷新TableView的方法
- (void)freshAllTableViewWithbuttonTitles:(NSArray *)titlesArray idArray:(NSArray *)idArray;
// 刷新TableView的方法+others
- (void)freshAllTableViewWithTables:(NSArray *)tables tableTitles:(NSArray *)tableTitles otherTitles:(NSArray *)otherTitles otherIds:(NSArray *)otherIds;

// 滚动到相应位置并刷新Table
- (void)scrollTableViewToIndex:(NSUInteger)index dataArray:(NSArray *)dataArray totalDataCount:(NSInteger)totalDataCount;

// 孕期：刷新全部table
- (void)freshAllTableData;

// 刷新第一个Table
- (void)freshFirshTableView;

// 返回当前tab标题
- (NSString *)getCurrentTabTitle;

-(NSString *)getCurrentTabClassId;
@end
