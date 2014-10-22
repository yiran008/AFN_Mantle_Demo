//
//  UINavigationItem+margin.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-12-26.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "UINavigationItem+Margin.h"

@implementation UINavigationItem (Margin)
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = 0;
        
        if (_leftBarButtonItem)
        {
            [self setLeftBarButtonItems:@[negativeSeperator, _leftBarButtonItem]];
        }
        else
        {
            [self setLeftBarButtonItems:@[negativeSeperator]];
        }
    }
    else
    {
        [self setLeftBarButtonItem:_leftBarButtonItem animated:NO];
    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -12;
        
        if (_rightBarButtonItem)
        {
            [self setRightBarButtonItems:@[negativeSeperator, _rightBarButtonItem] animated:NO];
        }
        else
        {
            [self setRightBarButtonItems:@[negativeSeperator] animated:NO];
        }
    }
    else
    {
        [self setRightBarButtonItem:_rightBarButtonItem animated:NO];
    }
}
- (void)setRightBarButtonItems:(NSArray *)rightBarButtonItems
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -12;
        NSMutableArray *right = [[NSMutableArray alloc]init];
        
        if (rightBarButtonItems)
        {
            [right addObject:negativeSeperator];
            [right addObjectsFromArray:rightBarButtonItems];
            [self setRightBarButtonItems:right animated:NO];
        }
        else
        {
            [self setRightBarButtonItems:@[negativeSeperator] animated:NO];
        }
    }
    else
    {
        [self setRightBarButtonItems:rightBarButtonItems animated:NO];
    }
}

- (void)setLeftBarButtonItems:(NSArray *)leftBarButtonItems
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -12;
        NSMutableArray *right = [[NSMutableArray alloc]init];
        
        if (leftBarButtonItems)
        {
            [right addObject:negativeSeperator];
            [right addObjectsFromArray:leftBarButtonItems];
            [self setLeftBarButtonItems:right animated:NO];
        }
        else
        {
            [self setLeftBarButtonItems:@[negativeSeperator] animated:NO];
        }
    }
    else
    {
        [self setLeftBarButtonItems:leftBarButtonItems animated:NO];
    }
}


#endif
@end
