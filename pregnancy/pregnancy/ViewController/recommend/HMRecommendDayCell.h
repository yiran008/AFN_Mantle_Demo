//
//  HMRecommendDayCell.h
//  lama
//
//  Created by songxf on 13-6-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDayRecommendModel.h"
#import "HMRecommendItemCell.h"
#import "HMRecommendModel.h"


@interface HMRecommendDayCell : UITableViewCell
<
    UITableViewDataSource,
    UITableViewDelegate
>

// 当天推荐内容所有数据
@property(nonatomic, strong) HMDayRecommendModel *cellData;

// 用tableview加载多条帖子
@property (retain, nonatomic) UITableView *c_table;

// 显示推荐发布时间
@property(nonatomic, strong) UILabel *timeLab;


// 设置对应数据并刷新
- (void)setNewData:(HMDayRecommendModel *)Data;

@end
