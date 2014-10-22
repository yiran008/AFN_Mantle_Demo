//
//  HMScrollSegmentTable.m
//  lama
//
//  Created by jiangzhichao on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMScrollSegmentTable.h"
#import "HMMoreCircleTableView.h"
#import "HMTableViewController.h"

#define SCROLL_SEGMENT_HEIGHT 44
@interface HMScrollSegmentTable  ()

@property (nonatomic, strong)NSMutableArray *s_allClassidArr;

@end
@implementation HMScrollSegmentTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        s_TableViewCurrentIndex = 0;
        self.m_TableArray = [NSMutableArray arrayWithCapacity:0];
        self.s_allClassidArr = [NSMutableArray arrayWithCapacity:0];
        self.m_TableBackScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCROLL_SEGMENT_HEIGHT, self.width, self.height - SCROLL_SEGMENT_HEIGHT)];
        self.m_TableBackScrollView.pagingEnabled = YES;
        self.m_TableBackScrollView.delegate = self;
        self.m_TableBackScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.m_TableBackScrollView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)titlesArray idArray:(NSArray *)idArray;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        s_TableViewCurrentIndex = 0;
        self.m_TableArray = [NSMutableArray arrayWithCapacity:0];
        self.s_allClassidArr = [NSMutableArray arrayWithCapacity:0];
        self.m_TableBackScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCROLL_SEGMENT_HEIGHT, self.width, self.height - SCROLL_SEGMENT_HEIGHT)];
        self.m_TableBackScrollView.contentSize = CGSizeMake(titlesArray.count * self.width, self.m_TableBackScrollView.height);
        self.m_TableBackScrollView.pagingEnabled = YES;
        self.m_TableBackScrollView.delegate = self;
        self.m_TableBackScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.m_TableBackScrollView];
        
        [self freshAllTableViewWithbuttonTitles:titlesArray idArray:idArray];
    }
    return self;
}

- (void)freshAllTableViewWithbuttonTitles:(NSArray *)titlesArray idArray:(NSArray *)idArray
{
    [self freshAllTableViewWithTables:nil tableTitles:nil otherTitles:titlesArray otherIds:idArray];
}

- (void)freshAllTableViewWithTables:(NSArray *)tables tableTitles:(NSArray *)tableTitles otherTitles:(NSArray *)otherTitles otherIds:(NSArray *)otherIds
{
    if (self.m_ScrollSegment.superview)
    {
        [self.m_ScrollSegment removeFromSuperview];
    }
    
    [self.m_TableBackScrollView removeAllSubviews];
    [self.m_TableArray removeAllObjects];
    [self.s_allClassidArr removeAllObjects];
    
    NSMutableArray *titleArray = [NSMutableArray arrayWithArray:tableTitles];
    [titleArray addObjectsFromArray:otherTitles];
    self.m_ScrollSegment = [[HMScrollSegment alloc] initWithFrame:CGRectMake(0, 0, self.width, SCROLL_SEGMENT_HEIGHT) buttonTitles:titleArray];
    self.m_TitleArray = titleArray;
    self.m_ScrollSegment.delegate = self;
    [self addSubview:self.m_ScrollSegment];
    self.m_TableBackScrollView.contentSize = CGSizeMake(titleArray.count * self.width, self.m_TableBackScrollView.height);
    
    for (NSInteger i=0; i<tables.count; i++)
    {
        HMTableViewController *tableView = tables[i];
        tableView.view.frame = CGRectMake(i * self.m_TableBackScrollView.width, 0, self.m_TableBackScrollView.width, self.m_TableBackScrollView.height);
        tableView.m_Table.frame = tableView.view.bounds;
        [self.m_TableBackScrollView addSubview:tableView.view];
        [self.m_TableArray addObject:tableView];
        [self.s_allClassidArr addObject:@""];
    }
    
    // others
    self.m_IdArray = otherIds;
    for (int i=0; i<self.m_IdArray.count; i++)
    {
        HMMoreCircleTableView *tableView = [[HMMoreCircleTableView alloc] initWithFrame:CGRectMake((i+tables.count) * self.m_TableBackScrollView.width, 0, self.m_TableBackScrollView.width, self.m_TableBackScrollView.height) refreshType:(HMRefreshType_Bottom | HMRefreshType_Head)];
        
        tableView.m_CircleId = self.m_IdArray[i];
        
        [self.m_TableBackScrollView addSubview:tableView];
        [self.m_TableArray addObject:tableView];
    }
    [self.s_allClassidArr addObjectsFromArray:otherIds];
}

- (void)scrollTableViewToIndex:(NSUInteger)index dataArray:(NSArray *)dataArray totalDataCount:(NSInteger)totalDataCount
{
    if (index < self.m_TableArray.count)
    {
        self.m_TableBackScrollView.contentOffset = CGPointMake(index * self.m_TableBackScrollView.width, 0);
        s_TableViewCurrentIndex = index;
        [self.m_ScrollSegment scrollLineFromIndex:0 relativeOffsetX:index];
        [self.m_ScrollSegment scrollBackAtIndex:index];
        
        HMSuperTableView *tableView = self.m_TableArray[index];
        tableView.m_Data = [dataArray mutableCopy];
        tableView.m_LoadedPage++;
        tableView.m_LoadedTotalCount = totalDataCount;
        [tableView reloadTableData];
    }
}

- (void)freshAllTableData
{
    for (NSInteger i=0; i<self.m_TableArray.count; i++)
    {
        HMSuperTableView *tableView = self.m_TableArray[i];
        
        if (i == s_TableViewCurrentIndex)
        {
            [tableView freshData];
        }
        else
        {
            [tableView.m_Data removeAllObjects];
            [tableView.m_Table reloadData];
        }
    }
}

- (void)freshFirshTableView
{
    if (self.m_TableArray > 0)
    {
        NSInteger index = 0;
        self.m_TableBackScrollView.contentOffset = CGPointMake(index * self.m_TableBackScrollView.width, 0);
        s_TableViewCurrentIndex = index;
        [self.m_ScrollSegment scrollLineFromIndex:0 relativeOffsetX:index];
        [self.m_ScrollSegment scrollBackAtIndex:index];
        
        HMSuperTableView *tableView = self.m_TableArray[0];
        [tableView freshData];
    }
}

- (NSString *)getCurrentTabTitle
{
    if (s_TableViewCurrentIndex<self.m_TitleArray.count)
    {
         return self.m_TitleArray[s_TableViewCurrentIndex];
    }
    
    return nil;
}

#pragma mark - UIScrollViewDelegate

// TableView开始滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger fromIndex = s_TableViewCurrentIndex;

    CGFloat scaleOffsetX = (scrollView.contentOffset.x - s_TableViewCurrentIndex * self.m_TableBackScrollView.width) / self.m_ScrollSegment.width;
    [self.m_ScrollSegment scrollLineFromIndex:fromIndex relativeOffsetX:scaleOffsetX];
}

// TableView滚动结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 根据滚动的偏移量，计算出Button的位置
    NSInteger index = scrollView.contentOffset.x/self.m_TableBackScrollView.width;
    
    [self.m_ScrollSegment selectBtnAtIndex:index];
}


#pragma mark - HMScrollSegmentDelegate

// 点击Segment上的Button之后调用的方法
- (void)scrollSegment:(HMScrollSegment *)scrollSegment selectedButtonAtIndex:(NSUInteger)index
{
    NSString *label = self.m_TitleArray[index];
    
    if ([label isEqualToString:@"我的圈"])
    {
        [MobClick event:@"discuz_v2" label:@"我的圈页pv"];//tag1
    }
    else
    {
        [MobClick event:@"discuz_v2" label:[NSString stringWithFormat:@"更多圈-二级标签点击（%@）",label]];
    }

    [self.m_TableBackScrollView setContentOffset:CGPointMake(index * self.m_TableBackScrollView.width,0) animated:YES];

    HMMoreCircleTableView *tableView = self.m_TableArray[index];
    
    if (![tableView.m_Data isNotEmpty])
    {
        [tableView rollFreshData];
    }
    
    s_TableViewCurrentIndex = index;
    
}

-(NSString *)getCurrentTabClassId
{
    if (s_TableViewCurrentIndex<self.s_allClassidArr.count)
    {
        return self.s_allClassidArr[s_TableViewCurrentIndex];
    }
    return nil;
}
@end
