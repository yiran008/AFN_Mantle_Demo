//
//  BBRelationshipViewController.h
//  pregnancy
//
//  Created by MacBook on 14-8-29.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMTableViewController.h"

// 获取列表类型：0-关注列表 1-粉丝列表
typedef enum
{
    RelationType_Attention = 0,
    RelationType_Fans,
}RelationType;

@interface BBRelationshipViewController : HMTableViewController

@property (nonatomic, assign) RelationType relationType;
@property (nonatomic, retain) NSString *u_id;
@end
