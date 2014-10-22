//
//  HMRecommendItemCell.h
//  lama
//
//  Created by songxf on 13-6-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMRecommendModel.h"

#define BIG_ITEM_HEIGHT 170
#define SMALL_PIC_HEIGHT 45
#define SMALL_PIC_WIDTH 62
#define SMALL_ITEM_HEIGHT 65
#define DIFHEIGHT_IPHONE5_IPHONE4 0
#define DISTANCE_ABOUT_SCREENLEFT 15
#define DISTANCE_ABOUT_TABLELEFT 12


@interface HMRecommendItemCell : UITableViewCell


// cell对用数据
@property(nonatomic, strong) HMRecommendModel *itemData;

// 帖子标题
@property(nonatomic, strong) UILabel *titleLab;

// 帖子小图
@property (retain, nonatomic) UIImageView *picView;

// cell选中高亮区域view
@property (retain, nonatomic) UIView *bgView;

// 等待图片加载菊花
@property (nonatomic, retain) UIActivityIndicatorView *activity;


// 设置cell数据 并刷新
- (void)setNewData:(HMRecommendModel *)data style:(BOOL)isBig itemHeight:(float)height;


@end
