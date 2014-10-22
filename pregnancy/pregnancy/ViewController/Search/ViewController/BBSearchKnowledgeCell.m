//
//  BBSearchKnowledgeCell.m
//  pregnancy
//
//  Created by yxy on 14-4-15.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBSearchKnowledgeCell.h"

@implementation BBSearchKnowledgeCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BBSearchKnowledgeCell *)setSearchKnowledgeCell:(BBSearchKnowledgeCellClass *)model
{
    self.m_item = model;
    
    // 预定义颜色
    self.cellView.backgroundColor = [UIColor whiteColor];
    self.knowledgeTitleLabel.textColor = [UIColor colorWithHex:0x444444];
    self.knowledgeContentLabel.textColor = [UIColor colorWithHex:0x666666];
    self.knowledgeSourceTypeLabel.textColor = [UIColor colorWithHex:0xaaaaaa];

    [self.knowledgeTitleLabel setAttributedText:self.m_item.m_knowledgeAttribut];
    [self.knowledgeContentLabel setAttributedText:self.m_item.m_SummaryAttribut];
    self.knowledgeSourceTypeLabel.text = model.knowledge_sourceType;
    
    // 根据UI计算高度
    self.cellView.top = 8;
    self.cellView.height = model.cellHeight - 9;
    self.knowledgeTitleLabel.height = model.titleHeight;
    self.knowledgeContentLabel.top = model.titleHeight + 8;
    self.knowledgeContentLabel.height = model.cellHeight - 40 - model.titleHeight;
    self.knowledgeSourceTypeLabel.top = model.cellHeight - 30;
    self.lineImageView.top = self.cellView.bottom;
    
    return self;
}

@end
