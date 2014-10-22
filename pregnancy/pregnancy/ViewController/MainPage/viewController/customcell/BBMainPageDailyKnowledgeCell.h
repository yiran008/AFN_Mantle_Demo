//
//  BBMainPageDailyKnowledgeCell.h
//  pregnancy
//
//  Created by liumiao on 4/9/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBMainPageDailyKnowledgeCell : UITableViewCell
@property (nonatomic,strong)UILabel *m_CellHeaderLabel;
@property (nonatomic,strong)UIView *m_BgView;
@property (nonatomic,strong)UIImageView *m_KnowledgeImageView;
@property (nonatomic,strong)UILabel *m_KnowledgeLabel;
@property (nonatomic,strong)UILabel *m_KnowledgeSummaryLabel;
-(void)setCellUseData:(id)data;

@end
