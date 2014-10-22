//
//  HMCircleClass.h
//  lama
//
//  Created by Heyanyang on 13-6-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HMCIRCLE_CELL_HEIGHT        86.0f

#define HMMYCIRCLE_CELL_HEIGHT      70.0f
#define HMMORECIRCLE_CELL_HEIGHT    85.0f

@interface HMCircleClass : NSObject

@property (nonatomic, retain) NSString *topicTitle01;
@property (nonatomic, retain) NSString *topicTitle02;
@property (nonatomic, assign) NSInteger iconForTopicTitle01ImageType;
@property (nonatomic, assign) NSInteger iconForTopicTitle02ImageType;
// 头像
@property (retain, nonatomic) NSString *buttonImageUrl;
// 是否已经加入本圈的状态
@property (nonatomic, assign) BOOL addStatus;
// 是否推荐
@property (nonatomic, assign) BOOL recommendStatus;

@property (nonatomic, retain) NSString *circleTitle;
@property (nonatomic, retain) NSString *circleImageUrl;
@property (nonatomic, retain) NSString *circleId;
// 是否为我的医院圈子
@property (nonatomic, assign) BOOL isMyHospital;
// 是否为默认加入的圈子
@property (nonatomic, assign) BOOL isDefaultJoined;
// 是否为默认同龄圈
@property (nonatomic, assign) BOOL isMyBirthClub;
// 是否为默认同城圈
@property (nonatomic, assign) BOOL isMyCityCircle;
// 圈子类型 0 其他 ， 1医院圈 ， 2 同龄圈 ，3 快乐孕期
@property (nonatomic, copy) NSString *type;
// 医院的ID
@property (nonatomic, strong) NSString *m_HospitalID;
// 圈子介绍
@property (nonatomic, retain) NSString *circleIntro;

@property (nonatomic, retain) NSString *topicNum;
@property (nonatomic, retain) NSString *todayTopicNum;
@property (nonatomic, retain) NSString *memberNum;
// 是否被选中  add by sxf
@property (nonatomic, assign) BOOL isSelected;
// 创建者ID
@property (nonatomic, retain) NSString *ownedUID;

@end
