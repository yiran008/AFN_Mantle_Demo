//
//  BBSearchUserCell.m
//  pregnancy
//
//  Created by yxy on 14-4-15.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBSearchUserCell.h"
#import "UIImageView+WebCache.h"

@implementation BBSearchUserCell

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BBSearchUserCell *)setSearchUserCell:(BBSearchUserCellClass *)model
{
    // 默认颜色设置
    self.cellView.backgroundColor = [UIColor whiteColor];
    self.userNameLabel.textColor = [UIColor colorWithHex:0xff537b];
    self.userLevelLabel.textColor = [UIColor colorWithHex:0x444444];
    self.userAgeLabel.textColor = [UIColor colorWithHex:0x888888];
    self.userPositionLabel.textColor = [UIColor colorWithHex:0x888888];
    self.user_headImageView.layer.masksToBounds = YES;
    self.user_headImageView.layer.cornerRadius = 29.f;

  
    self.m_item = model;
    
    // 默认头像
    [self.user_headImageView setImageWithURL:[NSURL URLWithString:model.user_avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.userNameLabel.text = model.user_name;
    
    if([model.user_age isNotEmpty])
    {
        self.userAgeLabel.text = model.user_age;
    }
    else
    {
        self.userAgeLabel.text = @"";
    }
    
    if([self.userAgeLabel.text isEqualToString:@""])
    {
        self.userPositionLabel.top = self.userAgeLabel.top;
    }
    
    self.userPositionLabel.text = model.user_position;
    self.userLevelLabel.text = [NSString stringWithFormat:@"LV.%@",model.user_level];
    
    CGSize userNameSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(300.0, 1000) withFont:[UIFont systemFontOfSize:14.0] withString:model.user_name];
    if(userNameSize.width >= 112)
    {
        userNameSize.width = 112;
    }
    self.userNameLabel.width = userNameSize.width;
    self.userLevelLabel.left = userNameSize.width + 86;
    
    self.cellView.top = 8;
    self.cellView.height = 69;
    self.lineImageView.top = self.cellView.bottom;
    
    self.button.u_id = model.user_encodeID;
    self.button.delegate = self;
    [self.button freshAttentionStatus:model.attentionStatus];

    return self;
}

- (UIViewController *)getPresentViewController
{
    UIViewController *controller;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            controller = (UIViewController*)nextResponder;
            break;
        }
    }
    return controller;
}

- (void)goToLoginWithLoginType:(LoginType)theLoginType
{
    BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
    login.m_LoginType = BBPresentLogin;
    BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
    [navCtrl setColorWithImageName:@"navigationBg"];
    login.delegate = self;
    UIViewController *controller = [self getPresentViewController];
    [controller  presentViewController:navCtrl animated:YES completion:^{
        
    }];
}

#pragma mark - BBAttentionButton Delegate

- (BOOL)shouldAddAttention
{
    if([BBUser isLogin])
    {
        return YES;
    }
    else
    {
        [self goToLoginWithLoginType:LoginPersonalFollowUser];
        return NO;
    }
}

- (void)changeAttentionStatusFinish:(BBAttentionButton *)button withAttentionType:(AttentionType)type
{
    self.m_item.attentionStatus = type;
    
    UIViewController *controller = [self getPresentViewController];
    if(controller != nil)
    {
        self.attentionHud = [[MBProgressHUD alloc] initWithView:controller.view];
        [controller.view addSubview:self.attentionHud];
    }
    
    NSString *attentionText;
    if(type == AttentionType_Add_Attention || type == AttentionType_Be_Attention)
    {
        attentionText = @"√ 已取消关注";
    }
    else if(type == AttentionType_Had_Attention || type == AttentionType_Both_Attention)
    {
        attentionText = @"√ 已关注";
    }
    [self.attentionHud show:NO withText:attentionText delay:1];

}

- (void)changeAttentionStatusFail:(BBAttentionButton *)button withAttentionType:(AttentionType)type
{
    UIViewController *controller = [self getPresentViewController];
    if(controller != nil)
    {
        self.attentionHud = [[MBProgressHUD alloc] initWithView:controller.view];
        [controller.view addSubview:self.attentionHud];
    }
 
    NSString *attentionText;
    if(type == AttentionType_Add_Attention || type == AttentionType_Be_Attention)
    {
        attentionText = @"加关注失败";
    }
    else if(type == AttentionType_Had_Attention || type == AttentionType_Both_Attention)
    {
        attentionText = @"取消关注失败";
    }
    [self.attentionHud show:NO withText:attentionText delay:1];

}

#pragma mark - BBLogin Delegate
- (void)loginFinish
{
    [self.button sendAttentionRequestWithType:AttentionType_Add_Attention];
}

@end
