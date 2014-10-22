//
//  HMCircleTopicCell.h
//  lama
//
//  Created by mac on 14-1-3.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTopicClass.h"
#import "HMMulImageView.h"

@interface HMTopicListCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIView *m_ContentView;

@property (retain, nonatomic) IBOutlet UIView *m_TitleBgView;
@property (retain, nonatomic) IBOutlet UILabel *m_TitleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *m_MarkIconTopView;
@property (retain, nonatomic) IBOutlet UIImageView *m_MarkIconNewView;
@property (retain, nonatomic) IBOutlet UIImageView *m_MarkIconEtView;
@property (retain, nonatomic) IBOutlet UIImageView *m_MarkIconHelpView;
// 搜索帖子列表，需要标红关键字处理,YES:搜索标红 NO：正常显示
@property (retain, nonatomic) IBOutlet UIImageView *m_MarkIconPicView;

@property (assign, nonatomic) BOOL isSearch;

//如果是收藏里面用的，需要自定义右滑操作
@property (assign,nonatomic) BOOL m_IsForCollection;

@property (retain, nonatomic) HMMulImageView *m_PicView;

@property (retain, nonatomic) IBOutlet UIView *m_BottomBoxView;
@property (retain, nonatomic) IBOutlet UIImageView *m_MasterIconView;
@property (retain, nonatomic) IBOutlet UILabel *m_MasterNameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *m_TimeIconView;
@property (retain, nonatomic) IBOutlet UILabel *m_TimeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *m_ReplyIconView;
@property (retain, nonatomic) IBOutlet UILabel *m_ReplyCountLabel;

@property (retain, nonatomic) IBOutlet UIImageView *m_BottomLine;

@property (retain, nonatomic) HMTopicClass *m_TopicCellClass;


- (void)makeCellStyle;
- (void)setTopicCellData:(HMTopicClass *)topicCellClass topicType:(NSInteger)type;


- (IBAction)masterClick:(id)sender;


@end
