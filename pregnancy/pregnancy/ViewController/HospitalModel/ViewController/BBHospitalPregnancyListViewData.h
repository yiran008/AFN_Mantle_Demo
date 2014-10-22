//
//  BBHospitalPregnancyListViewData.h
//  pregnancy
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BBHospitalPregnancyListViewData : BBListViewInfo{
    NSString *hospitalId;
    id<RefreshTopicCallBack> refreshTopicCallBackHandler;
}

@property(nonatomic,strong) NSString *hospitalId;
@property(assign)id<RefreshTopicCallBack> refreshTopicCallBackHandler;
@end

