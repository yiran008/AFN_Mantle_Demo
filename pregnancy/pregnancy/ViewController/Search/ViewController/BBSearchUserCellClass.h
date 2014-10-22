//
//  BBSearchUserCellClass.h
//  pregnancy
//
//  Created by yxy on 14-4-15.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBAttentionType.h"

@interface BBSearchUserCellClass : NSObject

// 用户userEncodeId
@property (nonatomic, strong) NSString *user_encodeID;
// 用户头像
@property (nonatomic, strong) NSString *user_avatar;
// 用户名称
@property (nonatomic, strong) NSString *user_name;
// 用户年龄
@property (nonatomic, strong) NSString *user_age;
// 用户地址
@property (nonatomic, strong) NSString *user_position;
// 用户等级
@property (nonatomic, strong) NSString *user_level;
// 用户关注状态
@property (nonatomic, assign) AttentionType attentionStatus;

// cell高度
@property (nonatomic, assign) CGFloat cellHeight;

// 标题
@property (nonatomic, retain) NSAttributedString *m_nicknameAttribut;
@property (nonatomic, retain) NSArray *m_nicknameArr;

+ (BBSearchUserCellClass *)getSearchUserClass:(NSDictionary *)dict;


@end
