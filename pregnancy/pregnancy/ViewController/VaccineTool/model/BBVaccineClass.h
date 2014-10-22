//
//  BBVaccineClass.h
//  pregnancy
//
//  Created by Heyanyang on 14-9-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBVaccineClass : NSObject

@property (nonatomic, strong) NSString *m_ageStage;
@property (nonatomic, assign) BOOL m_tag;
@property (nonatomic, strong) NSString *m_vaccineName;
@property (nonatomic, strong) NSString *m_remark;
@property (nonatomic, assign) BOOL m_isFree;
@property (nonatomic, assign) BOOL m_isNeed;
@property (nonatomic, strong) NSString *m_doTimesStr;
@property (nonatomic, strong) NSString *m_introduceID;
@property (nonatomic, strong) NSString *m_offsetMonth;

@property (nonatomic, assign)BOOL m_isRemind;
@property (nonatomic, assign)CGFloat m_vaccineNameStrWitdh;
@property (nonatomic, assign)BOOL m_isHiddenCellLine;
@end
