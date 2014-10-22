//
//  BBCircleView.m
//  pregnancy
//
//  Created by liumiao on 5/13/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBCircleView.h"

@implementation BBCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithHex:0xff537b] setFill];
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGContextAddArc(context, center.x, center.y, self.bounds.size.width/2, 0, 2*M_PI, 1); //添加一个圆
    CGContextDrawPath(context, kCGPathFill);
}


@end
