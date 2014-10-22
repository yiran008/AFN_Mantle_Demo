//
//  HMCircleTopicHeaderView.h
//  lama
//
//  Created by jiangzhichao on 14-4-17.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HMCircleTopicHeaderViewDelegate;

@interface HMCircleTopicHeaderView : UIView

@property (nonatomic, assign) id<HMCircleTopicHeaderViewDelegate> delegate;

@property (nonatomic, strong) NSString *m_HeadImgUrl;
@property (nonatomic, strong) NSString *m_CircleTitle;
@property (nonatomic, strong) NSString *m_TopicCount;
@property (nonatomic, strong) NSString *m_PeopleCount;

@property (nonatomic, assign) BOOL m_IsJoin;
// 是否为默认加入的圈子
@property (nonatomic, assign) BOOL m_IsDefaultJoined;

@property (nonatomic, assign) BOOL m_IsHospital;
// 是否为同龄圈
@property (nonatomic, assign) BOOL isBirthdayClub;

@property (nonatomic, strong) NSArray *m_TopicArray;

- (void)freshData;

- (void)changeJoinBtnStyle:(BOOL)isJoin;

- (void)hiddeHeadView;

@end

@interface HMCircleTopicView : UIView

@property (nonatomic, assign) BOOL m_IsNew;
@property (nonatomic, assign) BOOL m_IsElite;
@property (nonatomic, assign) BOOL m_IsHelp;
@property (nonatomic, assign) BOOL m_HasPic;
@property (nonatomic, assign) BOOL m_LineNotShow;

@property (nonatomic, strong) NSString *m_TopicId;
@property (nonatomic, strong) NSString *m_TopicTitle;

- (void)loadData;

@end

@protocol HMCircleTopicHeaderViewDelegate <NSObject>

- (void)HMCircleTopicHeaderView:(HMCircleTopicHeaderView *)headerView clickJoinBtnWithisJoin:(BOOL)isJoin;
- (void)clickCircleTopicView:(HMCircleTopicView *)topicView;

@optional
-(void)clickedCircleUserList;
-(void)clickedAdminList;
-(void)clickedHospitalIntroduction;

@end
