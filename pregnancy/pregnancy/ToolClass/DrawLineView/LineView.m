//
//  LineView.m
//  画直线
//
//  Created by babytree on 14-9-17.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "LineView.h"

@interface LineView()
// 直线起始点坐标
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) CGPoint endPoint;

// 线条颜色
@property (nonatomic,strong) UIColor *lineColor;
//线条粗细宽度
@property (nonatomic,assign) CGFloat lineWidth;


@end

@implementation LineView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.startPoint = CGPointZero;
        self.endPoint = CGPointMake(frame.size.width, 0);
        self.lineColor = [UIColor blackColor];
        self.lineWidth = 1.0f;
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //线条颜色
    static CGFloat red = 0,green = 0,blue = 0,alpha = 1.0;
    [self.lineColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    CGContextSetRGBStrokeColor(context,red, green, blue, alpha);
    
    //设置线条粗细宽度
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextMoveToPoint(context, self.startPoint.x, self.startPoint.y);
    CGContextAddLineToPoint(context, self.endPoint.x,self.endPoint.y);
    
    CGContextStrokePath(context);

    
}
- (void)drawRect:(CGRect)rect LineFromPoint:(CGPoint)startPoint toPointX2:(CGPoint)endPoint{
    [self drawRect:rect LineFromPoint:startPoint toPointX2:endPoint LineWith:1.0];
}

- (void)drawRect:(CGRect)rect LineFromPoint:(CGPoint)startPoint toPointX2:(CGPoint)endPoint LineWith:(CGFloat)lineWith{
    [self drawRect:rect LineFromPoint:startPoint toPointX2:endPoint LineWith:lineWith LineColor:[UIColor blackColor]];
}

- (void)drawRect:(CGRect)rect LineFromPoint:(CGPoint)startPoint toPointX2:(CGPoint)endPoint LineWith:(CGFloat)lineWith LineColor:(UIColor *)color
{
    self.startPoint = startPoint;
    self.endPoint = endPoint;

    self.lineWidth = lineWith;
    
    self.lineColor = color;
        
    [self setNeedsDisplay];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
