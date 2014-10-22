//
//  BBHospitalIntroduce.h
//  pregnancy
//
//  Created by whl on 14-9-1.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTableViewController.h"

typedef enum
{
    BBHosIntroduce, //排行
    BBHosDoctor  //距离进
    
} BBHospitalType;


@interface BBHospitalIntroduce : HMTableViewController

@property (nonatomic, strong) NSString *m_HospitalID;

@property (nonatomic, strong) NSString *m_CircleID;

@property (nonatomic, strong) IBOutlet UIImageView *m_TopView;

@property (nonatomic, assign) BBHospitalType m_HosType;

@end
