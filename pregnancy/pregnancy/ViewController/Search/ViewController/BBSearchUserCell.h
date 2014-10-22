//
//  BBSearchUserCell.h
//  pregnancy
//
//  Created by yxy on 14-4-15.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSearchUserCellClass.h"
#import "BBAttentionButton.h"
#import "BBLogin.h"

@interface BBSearchUserCell : UITableViewCell
<
    BBAttentionButtonDelegate,
    BBLoginDelegate
>

@property (nonatomic, strong) IBOutlet UIView *cellView;
// 用户头像
@property (nonatomic, strong) IBOutlet UIImageView *user_headImageView;
// 用户名称
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
// 用户年龄
@property (nonatomic, strong) IBOutlet UILabel *userAgeLabel;
// 用户地址
@property (nonatomic, strong) IBOutlet UILabel *userPositionLabel;
// cell下分界线
@property (nonatomic, strong) IBOutlet UIImageView *lineImageView;
// 用户级别
@property (nonatomic, strong) IBOutlet UILabel *userLevelLabel;
// 关注按钮
@property (nonatomic, strong)IBOutlet BBAttentionButton *button;

@property (nonatomic,retain) BBSearchUserCellClass *m_item;

@property (nonatomic, strong) MBProgressHUD * attentionHud;

- (BBSearchUserCell *)setSearchUserCell:(BBSearchUserCellClass *)model;

@end
