//
//  DiscuzRequest.h
//  pregnancy
//
//  Created by lijie on 12-3-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest+BBDebug.h"
#import "BBTopicListView.h"

@interface BBDiscuzRequest : NSObject{
}
+ (ASIFormDataRequest *)discuzListByListSort:(ListSort) listSort withGroupId:(NSString *)groupId withPage:(NSString *)page withArea:(id)area;

+ (ASIFormDataRequest *)myPostList:(NSInteger) start withUserEncodeId:(NSString *)userEncodeId;

+ (ASIFormDataRequest *)myReply:(NSInteger) start withUserEncodeId:(NSString *)userEncodeId;

@end