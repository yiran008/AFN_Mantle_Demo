//
//  BBMainPageBabyGrowCell.h
//  pregnancy
//
//  Created by liumiao on 4/9/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBMainPageBabyGrowCell : UITableViewCell

@property (nonatomic,strong)UIImageView *m_BabyImageView;
@property (nonatomic,strong)UILabel *m_ContentLabel;
@property (nonatomic,strong)UIImageView *m_SeplineView;
@property (nonatomic,strong)UIView *m_BgView;

+ (CGFloat)CalculateCellHeightUseData:(id)data;

- (void)setData:(id)data cellHeight:(CGFloat)cellHeight;

@end
