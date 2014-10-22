//
//  BBDoctorPostListViewData.m
//  pregnancy
//
//  Created by babytree babytree on 12-10-24.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBDoctorPostListViewData.h"
#import "BBHospitalRequest.h"

@implementation BBDoctorPostListViewData

@synthesize doctorName;
@synthesize groupId;
@synthesize refreshTopicCallBackHandler;

- (void)dealloc
{
    [doctorName release];
    [groupId release];
    
    [super dealloc];
}
- (ASIFormDataRequest *)reload{
    return [BBHospitalRequest doctorPostListByName:self.doctorName withPage:self.page withGroupId:self.groupId];
}

- (NSArray *)reloadDataSuccess:(NSDictionary *)data{
    [refreshTopicCallBackHandler refreshCallBack:[[data dictionaryForKey:@"data"]stringForKey:@"total"]];
    return [[data dictionaryForKey:@"data"]arrayForKey:@"list"];
}

- (ASIFormDataRequest *)loadNext{
    return [BBHospitalRequest doctorPostListByName:self.doctorName withPage:self.page withGroupId:self.groupId];
}

- (NSArray *)loadNextDataSuccess:(NSDictionary *)data{
    
    return[[data dictionaryForKey:@"data"]arrayForKey:@"list"];
}

- (NSInteger)loadedTotalCount:(NSDictionary *)data{
    return [[[data dictionaryForKey:@"data"]stringForKey:@"total"] integerValue];
}
@end