//
//  LineView.h
//  画直线
//
//  Created by babytree on 14-9-17.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

// 可以在其中画线的view
@interface LineView : UIView
// 粗细为1的黑线
- (void)drawRect:(CGRect)rect LineFromPoint:(CGPoint)startPoint toPointX2:(CGPoint)endPoint;
// 粗细为可选的黑线
- (void)drawRect:(CGRect)rect LineFromPoint:(CGPoint)startPoint toPointX2:(CGPoint)endPoint LineWith:(CGFloat)lineWith;
// 粗细为可选的颜色可选的直线
- (void)drawRect:(CGRect)rect LineFromPoint:(CGPoint)startPoint toPointX2:(CGPoint)endPoint LineWith:(CGFloat)lineWith LineColor:(UIColor *)color;

@end
