//
//  BBMemberClass.h
//  pregnancy
//
//  Created by whl on 14-9-2.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    BBTopMember, //排行
    BBDistancemember, //距离进
    BBAgeMember //同龄
    
} BBCircleMemberType;

@interface BBMemberClass : NSObject

@property (nonatomic, strong) NSString *m_UserEncodeID;
@property (nonatomic, strong) NSString *m_UserName;
@property (nonatomic, strong) NSString *m_UserAdress;
@property (nonatomic, strong) NSString *m_UserAvatar;
@property (nonatomic, strong) NSString *m_UserPregnancy;
@property (nonatomic, strong) NSString *m_UserRank;
@property (nonatomic, strong) NSString *m_UserHospital;
@property (nonatomic, strong) NSString *m_UserTop;
@property (nonatomic, strong) NSString *m_Distance;
@property (nonatomic, strong) NSString *m_Contribution;
@property (nonatomic, strong) NSString *m_SignName;
@property (nonatomic, strong) NSString *m_SignImage;

@property (nonatomic, assign) BBCircleMemberType m_MemberType;

@end
