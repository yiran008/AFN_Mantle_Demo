//
//  HMTopicDetailCellTextView.h
//  lama
//
//  Created by mac on 13-8-6.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTopicDetailCellView.h"
#import "EmojiLabel.h"

@interface HMTopicDetailCellTextView : HMTopicDetailCellView

@property (retain, nonatomic) IBOutlet EmojiLabel *m_StyledLabel;

@property (retain, nonatomic) IBOutlet UIControl *m_LinkCtrl;

@property (retain, nonatomic) IBOutlet UIButton *m_LinkBtn;

- (IBAction)link_Click:(id)sender;

@end
