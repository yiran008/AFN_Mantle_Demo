//
//  BBMainPageRecommendCell.h
//  pregnancy
//
//  Created by liumiao on 4/9/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RecommendBlock)(int);
@interface BBMainPageRecommendCell : UITableViewCell
@property (nonatomic,strong)UIView *m_BgView;
@property (nonatomic,strong)UILabel *m_CellHeaderLabel;
@property (nonatomic,strong)UIButton *m_MoreButton;
@property (nonatomic,copy) RecommendBlock m_RecommendBlock;
-(void)setCellUseData:(id)data;

@end
