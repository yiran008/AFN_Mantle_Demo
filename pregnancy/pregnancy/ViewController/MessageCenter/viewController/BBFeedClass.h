//
//  BBFeedClass.h
//  pregnancy
//
//  Created by liumiao on 9/10/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ICON_HOLDER_STRING @"     "

@interface BBFeedClass : NSObject

@property (nonatomic, strong) NSString *m_TopicId;
// 标题
@property (nonatomic, strong) NSString *m_Title;
// 摘要
@property (nonatomic, strong) NSString *m_Summary;
// 用户孕周
@property (nonatomic, strong) NSString *m_BabyAge;
// 是否有图
@property (nonatomic, assign) BOOL m_HasPic;
// 是否精华
@property (nonatomic, assign) BOOL m_IsElite;
// 是否求助
@property (nonatomic, assign) BOOL m_IsHelp;
// 圈子ID
@property (nonatomic, strong) NSString *m_CircleId;
// 圈子名称
@property (nonatomic, strong) NSString *m_CircleName;
// 楼主Id
@property (nonatomic, strong) NSString *m_PosterId;
// 楼主昵称
@property (nonatomic, strong) NSString *m_PosterName;
// 楼主头像
@property (nonatomic, strong) NSString *m_PosterImage;
// 楼主等级
@property (nonatomic, assign) NSInteger m_PosterLevel;
// 回复数
@property (nonatomic, assign) NSInteger m_ResponseCount;
// 创建时间
@property (nonatomic, assign) NSInteger m_CreateTime;
// 最后回复时间
@property (nonatomic, assign) NSInteger m_ResponseTime;
// 赞次数
@property (nonatomic, assign) NSInteger m_PraiseCount;
// 高度
@property (nonatomic, assign) CGFloat m_CellHeight;

-(CGFloat)cellHeight;

@end
