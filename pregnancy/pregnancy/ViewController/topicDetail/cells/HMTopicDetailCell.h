//
//  BBNewTopicDetailCell.h
//  lama
//
//  Created by 王 鸿禄 on 13-5-22.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTopicDetailCellView.h"

@interface HMTopicDetailCell : UITableViewCell

@property (nonatomic, strong) HMTopicDetailCellView *m_CellView;
@property (nonatomic, assign) UINavigationController *m_PopViewController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withtype:(HMTopicDetailCell_Type)type;

- (void)drawTopicDetailCell:(HMTopicDetailCellClass *)topicDetail withTopicDelegate:(id <HMTopicDetailCellDelegate>)topicDelagate;


@end
