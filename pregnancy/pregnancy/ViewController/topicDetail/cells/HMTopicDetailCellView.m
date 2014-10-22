//
//  HMTopicDetailCellView.m
//  lama
//
//  Created by mac on 13-8-1.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMTopicDetailCellView.h"
#import "ARCHelper.h"

@implementation HMTopicDetailCellView
@synthesize delegate;
@synthesize m_PopViewController;

@synthesize m_TopicDetail;

- (void)dealloc
{
    [m_TopicDetail ah_release];
    
    [super ah_dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        lpress.minimumPressDuration = 0.5;
        lpress.allowableMovement = 5;
        lpress.delegate = self;
        [self addGestureRecognizer:lpress];
        [lpress ah_release];
    }
    
    return self;
}

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

- (void)drawTopicDetailCell:(HMTopicDetailCellClass *)topicDetail withTopicDelegate:(id <HMTopicDetailCellDelegate>)topicDelagate
{
    self.m_TopicDetail = topicDetail;
    self.delegate = topicDelagate;
}

-(void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(topicClicked:isLong:)])
        {
            [self.delegate topicClicked:self.m_TopicDetail isLong:YES];
        }
    }
}

@end
