//
//  BBKnowlegeViewController.h
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"

typedef NS_ENUM(NSInteger, KnowledgeVCType)
{
    KnowlegdeVCKnowlegde,
    KnowlegdeVCRemind
};

@interface BBKnowlegeViewController:ViewPagerController

@property int days;
@property (nonatomic,strong)NSString *startID;
@property (nonatomic,assign)KnowledgeVCType m_CurVCType;
@end
