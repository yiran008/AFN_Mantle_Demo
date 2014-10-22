//
//  HMTopicDetailCellView.h
//  lama
//
//  Created by mac on 13-8-1.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTopicDetailCellDelegate.h"
#import "HMTopicDetailCellClass.h"

@interface HMTopicDetailCellView : UIView
<
    UIGestureRecognizerDelegate
>

@property (nonatomic, assign) id <HMTopicDetailCellDelegate> delegate;
@property (nonatomic, assign) UINavigationController *m_PopViewController;

@property (nonatomic, retain) HMTopicDetailCellClass *m_TopicDetail;


- (void)drawTopicDetailCell:(HMTopicDetailCellClass *)topicDetail withTopicDelegate:(id <HMTopicDetailCellDelegate>)topicDelagate;

@end
