//
//  HMTopicDetailCellTopView.h
//  lama
//
//  Created by mac on 13-8-1.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTopicDetailCellView.h"

@interface HMTopicDetailCellHeadView : HMTopicDetailCellView

@property (retain, nonatomic) IBOutlet UIImageView *m_TopLineImageView;

@property (retain, nonatomic) IBOutlet UIButton *m_HeadImageView;
@property (retain, nonatomic) IBOutlet UILabel *m_NameLabel;
@property (retain, nonatomic) IBOutlet UIControl *m_NameCtrl;

@property (retain, nonatomic) IBOutlet UILabel *m_BabyAgeLab;
@property (retain, nonatomic) IBOutlet UIImageView *m_MasterMarkView;

@property (retain, nonatomic) IBOutlet UILabel *m_FloorLabel;

@property (retain, nonatomic) IBOutlet UIButton *delButton;
@property (nonatomic, strong) IBOutlet UIImageView *m_TopicAdmin;
@property (nonatomic, strong) IBOutlet UIImageView *m_TopicUserSign;

- (IBAction)pressHeadBtn:(id)sender;
- (IBAction)delTopic:(id)sender;

@end
