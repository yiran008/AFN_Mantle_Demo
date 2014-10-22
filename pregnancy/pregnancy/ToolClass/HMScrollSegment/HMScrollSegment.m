//
//  HMScrollSegment.m
//  lama
//
//  Created by jiangzhichao on 14-4-4.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMScrollSegment.h"

#define SCROLL_LINE_HEIGHT 2
#define BUTTON_MAX_WIDTH 80
#define BUTTON_LEFTGAP 0
#define BUTTON_GAP 36
#define BUTTON_START_TAG 100

@interface HMScrollSegment ()

// 存储btn
@property (nonatomic, strong) NSMutableArray *s_BtnArray;

// 整体的滚动View
@property (nonatomic, strong) UIScrollView *s_BackScrollView;

// 可滚动的线
@property (nonatomic, strong) UIView *s_LineView;

// 背景灰色细线
@property (nonatomic, strong) UIImageView *s_BackLineView;

@end


@implementation HMScrollSegment
{
    NSUInteger s_CurrentIndex;
}


#pragma mark - init Method

- (id)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)titlesArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.s_BtnArray = [NSMutableArray arrayWithCapacity:0];
        self.backgroundColor = UI_VIEW_BGCOLOR_1;

        // 背景线
        self.s_BackLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
        self.s_BackLineView.image = [UIImage imageNamed:@"topiccell_line_bottom"];
        [self addSubview:self.s_BackLineView];
        
        // Btn的滚动背景
        self.s_BackScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.s_BackScrollView.backgroundColor = [UIColor clearColor];
        self.s_BackScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.s_BackScrollView];
        
        // 可滚动的线
        self.s_LineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.s_BackScrollView.height - SCROLL_LINE_HEIGHT, 0, SCROLL_LINE_HEIGHT)];
        self.s_LineView.backgroundColor = UI_DEFAULT_BGCOLOR;
        [self.s_BackScrollView addSubview:self.s_LineView];
        
        [self freshButtonWithTitles:titlesArray];
    }
    
    return self;
}

- (void)freshButtonWithTitles:(NSArray *)titleArray
{
    // 移除Btn
    for (UIButton *btn in self.s_BtnArray)
    {
        if (btn.superview)
        {
            [btn removeFromSuperview];
        }
    }

    [self.s_BtnArray removeAllObjects];
    
    CGFloat xOffset = BUTTON_LEFTGAP;

    // 创建Btn
    for (NSInteger i=0; i<titleArray.count; i++)
    {
        NSString *title = titleArray[i];
        CGSize btnSize = [title sizeWithFont:[UIFont systemFontOfSize:16]];
        CGFloat buttonWidth = btnSize.width + BUTTON_GAP;
        buttonWidth = buttonWidth < BUTTON_MAX_WIDTH ? buttonWidth : BUTTON_MAX_WIDTH;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(xOffset, 0, buttonWidth, self.s_BackScrollView.height);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:UI_TEXT_OTHER_COLOR forState:UIControlStateNormal];
        [btn setTitleColor:UI_TEXT_SELECTED_COLOR forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.tag = i + BUTTON_START_TAG;
        [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.exclusiveTouch = YES;
        [self.s_BackScrollView addSubview:btn];
        [self.s_BtnArray addObject:btn];
        
        xOffset += buttonWidth;
    }
    xOffset = xOffset + BUTTON_LEFTGAP;
    
    xOffset = xOffset > self.s_BackScrollView.width ? xOffset : self.s_BackScrollView.width;

    self.s_BackScrollView.contentSize = CGSizeMake(xOffset, self.s_BackScrollView.height);
}


#pragma mark - public Method

// 滚动完成之后调用：调整Btn显示
- (void)selectBtnAtIndex:(NSUInteger)index
{
    if (index < self.s_BtnArray.count)
    {
        UIButton *btn = self.s_BtnArray[index];
        [self selectBtn:btn];
    }
}

// 滚动之中调用：调整line位置和大小
- (void)scrollLineFromIndex:(NSInteger)fromIndex relativeOffsetX:(CGFloat)relativeOffsetX
{
    BOOL isLeft = relativeOffsetX < 0 ? YES : NO;
    NSInteger toIndex = 0;
    
    for (NSInteger i=1; i<self.s_BtnArray.count; i++)
    {
        if (i >= fabsf(relativeOffsetX))
        {
            toIndex = isLeft ? (fromIndex - i) : (fromIndex + i);
            break;
        }
    }
    
    //    NSLog(@"%d", fromIndex);
    //    NSLog(@"%d", toIndex);
    //    NSLog(@"%f", relativeOffsetX);
    
    if (toIndex != fromIndex && toIndex >=0 &&
        fromIndex <self.s_BtnArray.count && toIndex < self.s_BtnArray.count)
    {
        UIButton *currentBtn = self.s_BtnArray[fromIndex];
        UIButton *toBtn = self.s_BtnArray[toIndex];
        // 线需要滚动的总宽度
        CGFloat lineScrollWidth = fabsf(toBtn.left + (toBtn.width - toBtn.titleLabel.width)/2 - (currentBtn.left +(currentBtn.width - currentBtn.titleLabel.width)/2));
        // 线需要滚动的时时宽度
        CGFloat lineOffsetX = relativeOffsetX * lineScrollWidth/fabsf(toIndex - fromIndex);
        // 设置线的left
        self.s_LineView.left = (currentBtn.left +(currentBtn.width - currentBtn.titleLabel.width)/2) + lineOffsetX;
        // 设置线的宽度
        CGFloat lineChangeWidth = toBtn.titleLabel.width - currentBtn.titleLabel.width;
        CGFloat lineCurrentChange = fabsf(relativeOffsetX) * lineChangeWidth/fabsf(toIndex - fromIndex);
        self.s_LineView.width = currentBtn.titleLabel.width + lineCurrentChange;
    }
}

// 调整背景的偏移量
- (void)scrollBackAtIndex:(NSUInteger)index
{
    if (index < self.s_BtnArray.count)
    {
        s_CurrentIndex = index;
        
        UIButton *btn = self.s_BtnArray[index];
        btn.selected = YES;
        [self scrollBack:btn];
    }
}


#pragma mark - private Method

// 点击某个Btn
- (void)selectBtn:(UIButton *)btn;
{
    if (s_CurrentIndex < self.s_BtnArray.count) {
        UIButton *currentBtn = self.s_BtnArray[s_CurrentIndex];
        currentBtn.selected = NO;
    }

    btn.userInteractionEnabled = NO;
    btn.selected = YES;
    s_CurrentIndex = btn.tag - BUTTON_START_TAG;
    
    [self scrollBack:btn];
    [self scrollLine:btn];

    if ([self.delegate respondsToSelector:@selector(scrollSegment:selectedButtonAtIndex:)])
    {
        [self.delegate scrollSegment:self selectedButtonAtIndex:s_CurrentIndex];
    }
}

// 滚动Line
- (void)scrollLine:(UIButton *)btn
{
    CGFloat lineWidth = btn.titleLabel.size.width;
    CGFloat x = (btn.width - lineWidth)/2;

    [UIView animateWithDuration:0.25 animations:^{
        self.s_LineView.frame = CGRectMake(btn.left + x, self.s_BackScrollView.height - SCROLL_LINE_HEIGHT, lineWidth, SCROLL_LINE_HEIGHT);
    } completion:^(BOOL finished) {
        btn.userInteractionEnabled = YES;
    }];
}

// 调整背景位置
- (void)scrollBack:(UIButton *)btn
{
    // 如果当前显示的最右侧一个Btn超出右边界
    if (self.s_BackScrollView.contentOffset.x + self.s_BackScrollView.width < btn.right)
    {
        // 向左滚动视图，显示完整Btn
        [self.s_BackScrollView setContentOffset:CGPointMake(btn.right - self.s_BackScrollView.width, 0) animated:YES];
    }
    // 如果当前显示的最左侧一个Btn超出左边界
    else if (self.s_BackScrollView.contentOffset.x > btn.left)
    {
        // 向右滚动视图，显示完整Btn
        [self.s_BackScrollView setContentOffset:CGPointMake(btn.left, 0) animated:YES];
    }
    
    CGFloat halfDisplayWidth = self.s_BackScrollView.width/2;
    if (btn.centerX > halfDisplayWidth && btn.centerX < self.s_BackScrollView.contentSize.width - halfDisplayWidth)
    {
        [self.s_BackScrollView setContentOffset:CGPointMake(btn.centerX - halfDisplayWidth , 0) animated:YES];
    }
}

@end
