//
//  HMCircleTopicVC.h
//  lama
//
//  Created by jiangzhichao on 14-4-17.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMTableViewController.h"
#import "HMCircleClass.h"
#import "HMApiRequest.h"
#import "BBSelectMoreArea.h"

@interface HMCircleTopicVC : HMTableViewController
<
  BBSelectAreaCallBack
>

// 当前圈子id
@property (nonatomic, strong) HMCircleClass *m_CircleClass;
// 当前话题分类,默认为：最后回复
@property (nonatomic, assign) POPLISTROW m_TopicStyle;

@property (nonatomic, assign) BOOL isSetHospitial;

@end
