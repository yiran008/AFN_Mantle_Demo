//
//  HMMoreCircleTableView.h
//  lama
//
//  Created by jiangzhichao on 14-6-6.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMSuperTableView.h"
#import "HMMoreCircleCell.h"

@interface HMMoreCircleTableView : HMSuperTableView
<
    UITableViewDelegate,
    UITableViewDataSource,
    HMMoreCircleCellDelegate
>

@property (nonatomic, strong) NSString *m_CircleId;

@end
