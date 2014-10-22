//
//  wiPageControl.m
//  wiIos
//
//  Created by qq on 12-2-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMPageControl.h"
#import "ARCHelper.h"

@interface HMPageControl (private)  // 声明一个私有方法, 该方法不允许对象直接使用
- (void)updateDots;
@end

@implementation HMPageControl
@synthesize imagePageStateNormal;
@synthesize imagePageStateHighlighted;

- (void)dealloc
{
    // 释放内存
    [imagePageStateNormal ah_release], imagePageStateNormal = nil;
    [imagePageStateHighlighted ah_release], imagePageStateHighlighted = nil;
    [super ah_dealloc];
}

- (void)awakeFromNib
{
    self.imagePageStateNormal = [UIImage imageNamed:@"black_page_control"];
    self.imagePageStateHighlighted = [UIImage imageNamed:@"black_page_control_active"];
}

- (id)initWithFrame:(CGRect)frame
{
    // 初始化
    self = [super initWithFrame:frame];
    
    self.imagePageStateNormal = [UIImage imageNamed:@"black_page_control"];
    self.imagePageStateHighlighted = [UIImage imageNamed:@"black_page_control_active"];
    
    return self;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    // 点事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

- (void)updateDots
{
    if (IOS_VERSION >= 6.0)
    {
        return;
    }
    else
    {
        // 更新显示所有的点按钮
        if (imagePageStateNormal && imagePageStateHighlighted)
        {
            // 获取所有子视图
            NSArray *subview = self.subviews;
            for (NSInteger i = 0; i < [subview count]; i++)
            {
                UIView *view = [subview objectAtIndex:i];
                
                if ([view isKindOfClass:[UIImageView class]])
                {
                    UIImageView *dot = (UIImageView *)view;
                    //NSLog(@"%d", self.currentPage);
                    dot.image = self.currentPage == i ? imagePageStateHighlighted : imagePageStateNormal;
                }
            }
        }
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    [super setNumberOfPages:numberOfPages];
    //NSLog(@"pages:%d,%d",numberOfPages,[self.subviews count]);
    [self updateDots];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    //NSLog(@"setCurrentPage:%d",currentPage);
    [self updateDots];
}

@end
