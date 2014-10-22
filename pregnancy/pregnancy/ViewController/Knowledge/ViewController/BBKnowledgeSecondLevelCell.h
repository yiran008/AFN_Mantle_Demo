//
//  BBKnowledgeSecondLevelCell.h
//  pregnancy
//
//  Created by liumiao on 4/24/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBKnowledgeSecondLevelCell : UITableViewCell

//如果是收藏里面用的，需要自定义右滑操作
@property (assign,nonatomic) BOOL m_IsForCollection;

@property (nonatomic,strong)UILabel *m_KnowledgeSpeciesLabel;

@property (nonatomic,strong)UIView *m_BgView;

@property (nonatomic,strong)UIImageView *m_RelatedImageView;

-(void)setCellWithData:(id)data;
@end
