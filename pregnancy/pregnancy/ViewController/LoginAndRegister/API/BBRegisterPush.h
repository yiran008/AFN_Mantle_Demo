//
//  BBRegisterPush.h
//  pregnancy
//
//  Created by Jun Wang on 12-5-17.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBConfigureAPI.h"
#import "ASIFormDataRequest+BBDebug.h"

@interface BBRegisterPush : NSObject

+ (ASIFormDataRequest *)registerPushNofitycation:(NSString *)deviceToken;

@end
