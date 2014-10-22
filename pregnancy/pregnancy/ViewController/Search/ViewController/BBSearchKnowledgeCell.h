//
//  BBSearchKnowledgeCell.h
//  pregnancy
//
//  Created by yxy on 14-4-15.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSearchKnowledgeCellClass.h"

@interface BBSearchKnowledgeCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *cellView;
// 知识标题
@property (nonatomic, strong) IBOutlet UILabel *knowledgeTitleLabel;
// 知识正文
@property (nonatomic, strong) IBOutlet UILabel *knowledgeContentLabel;
// 知识所属分类
@property (nonatomic, strong) IBOutlet UILabel *knowledgeSourceTypeLabel;
// cell下划线
@property (nonatomic, strong) IBOutlet UIImageView *lineImageView;

@property (nonatomic,retain) BBSearchKnowledgeCellClass *m_item;


- (BBSearchKnowledgeCell *)setSearchKnowledgeCell:(BBSearchKnowledgeCellClass *)model;

@end
