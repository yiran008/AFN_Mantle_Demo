//
//  HMTopicDetailCellReplyView.h
//  lama
//
//  Created by mac on 13-8-6.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTopicDetailCellView.h"

@interface HMTopicDetailCellReplyView : HMTopicDetailCellView


@property (retain, nonatomic) IBOutlet UIImageView *m_BgImageView;

@property (retain, nonatomic) IBOutlet UILabel *m_NicknameLabel;
@property (retain, nonatomic) IBOutlet UILabel *m_ContentLabel;
@property (retain, nonatomic) IBOutlet UILabel *m_FloorLabel;



@property (nonatomic, assign) BOOL m_CanShowAll;

- (void)drawReplayContent;

@end
