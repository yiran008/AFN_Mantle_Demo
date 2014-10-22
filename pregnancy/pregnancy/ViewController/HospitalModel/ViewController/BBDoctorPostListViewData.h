//
//  BBDoctorPostListViewData.h
//  pregnancy
//
//  Created by babytree babytree on 12-10-24.
//  Copyright (c) 2012年 babytree. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface BBDoctorPostListViewData : BBListViewInfo{
    NSString *doctorName;
    NSString *groupId;
    id<RefreshTopicCallBack> refreshTopicCallBackHandler;
}
@property(nonatomic,strong) NSString *doctorName;
@property(nonatomic,strong) NSString *groupId;
@property(assign)id<RefreshTopicCallBack> refreshTopicCallBackHandler;
@end