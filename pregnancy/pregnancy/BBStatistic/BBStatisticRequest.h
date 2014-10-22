//
//  BBStatisticRequest.h
//  pregnancy
//
//  Created by liumiao on 9/12/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBStatisticRequest : NSObject
+ (ASIFormDataRequest *)statisticRequestWithContent:(NSString *)content;
@end
