//
//  BBHospitalPregnancyListViewData.m
//  pregnancy
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBHospitalPregnancyListViewData.h"
#import "BBHospitalRequest.h"

@implementation BBHospitalPregnancyListViewData

@synthesize hospitalId;
@synthesize refreshTopicCallBackHandler;

- (void)dealloc
{
    [hospitalId release];
    
    [super dealloc];
}
- (ASIFormDataRequest *)reload
{
    return [BBHospitalRequest hospitalPregnancyListWithHospitalId:hospitalId withStartIndex:[NSString stringWithFormat:@"%d",(self.page - 1) * 20]];
}

- (NSArray *)reloadDataSuccess:(NSDictionary *)data{
    [refreshTopicCallBackHandler refreshCallBack:[[data dictionaryForKey:@"data"] stringForKey:@"total"]];
    return [[data dictionaryForKey:@"data"] arrayForKey:@"list"];
}

- (ASIFormDataRequest *)loadNext{
    return [BBHospitalRequest hospitalPregnancyListWithHospitalId:hospitalId withStartIndex:[NSString stringWithFormat:@"%d",(self.page - 1)* 20]];
}

- (NSArray *)loadNextDataSuccess:(NSDictionary *)data{
    
    return [[data dictionaryForKey:@"data"] arrayForKey:@"list"];
}

- (NSInteger)loadedTotalCount:(NSDictionary *)data{
    return [[[data dictionaryForKey:@"data"] stringForKey:@"total"] integerValue];
}
@end

