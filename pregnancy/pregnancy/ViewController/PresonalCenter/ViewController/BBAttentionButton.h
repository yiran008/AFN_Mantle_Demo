//
//  BBAttentionButton.h
//  pregnancy
//
//  Created by MacBook on 14-9-1.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBAttentionRequest.h"
#import "BBAttentionType.h"

#define STATE_ADD_NORMAL @"stateAddNormal"
#define STATE_ADD_PRESSED @"stateAddPressed"
#define STATE_HAD_NORMAL @"stateHadNormal"
#define STATE_HAD_PRESSED @"stateHadPressed"
#define STATE_BOTH_NORMAL @"stateBothNormal"
#define STATE_BOTH_PRESSED @"stateBothPressed"

@class BBAttentionButton;
@protocol BBAttentionButtonDelegate <NSObject>

@required
// 是否需要关注按钮执行加关注操作
- (BOOL)shouldAddAttention;

@optional
// 更改关注状态成功/失败，通过代理方法改变主界面UI及相关提示
- (void)changeAttentionStatusFinish:(BBAttentionButton *)button withAttentionType:(AttentionType)type;
- (void)changeAttentionStatusFail:(BBAttentionButton *)button withAttentionType:(AttentionType)type;

@end

@interface BBAttentionButton : UIButton
{
    AttentionType currentAttentionType;
}

@property (nonatomic, assign)id<BBAttentionButtonDelegate> delegate;
@property (nonatomic, retain)ASIFormDataRequest *addAttentionRequest;
@property (nonatomic, retain)ASIFormDataRequest *cancelAttentionRequest;
// 用户u_id
@property (nonatomic, retain) NSString *u_id;

- (id)initWithFrame:(CGRect)frame withType:(AttentionType)type;
- (void)freshAttentionStatus:(AttentionType)type;
- (void)changeButtonStateImageWithDict:(NSDictionary*)dict;
- (void)sendAttentionRequestWithType:(AttentionType)type;
@end
