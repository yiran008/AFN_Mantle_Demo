//
//  HMTouchScrollView.m
//  lama
//
//  Created by mac on 14-4-16.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMTouchScrollView.h"

@implementation HMTouchScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.dragging)
    {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }

    [super touchesBegan:touches withEvent:event];
    //NSLog(@"MyScrollView touch Began");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.dragging)
    {
        [[self nextResponder] touchesMoved:touches withEvent:event];
    }

    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.dragging)
    {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }

    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"supper touchesCancelled %d", self.dragging);

    if(!self.dragging)
    {
        [[self nextResponder] touchesCancelled:touches withEvent:event];
    }

    [super touchesCancelled:touches withEvent:event];
}

@end
