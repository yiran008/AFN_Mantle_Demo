//
//  BBSelectHospitalArea.h
//  pregnancy
//
//  Created by babytree babytree on 12-10-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSelectHospitalArea : BBBaseTableViewController
{
    NSArray *hostpitalAreaData;
    BOOL startEnterFlag;
    NSDictionary *city;
}

@property(nonatomic,strong)NSArray *hostpitalAreaData;
@property(assign)BOOL startEnterFlag;
@property(nonatomic,strong)NSDictionary *city;
@end
