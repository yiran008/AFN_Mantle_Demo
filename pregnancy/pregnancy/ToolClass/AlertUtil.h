//
//  AlertUtil.h
//  ask
//
//  Created by ilike1980 on 11-11-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlertUtil : NSObject 

+ (void)showAlert:(NSString *)title withMessage:(NSString *)msg ;
+ (void)showApiAlert:(NSString *)title withJsonObject:(NSDictionary *)response;
+ (void)showErrorAlert:(NSString *)title withError:(NSError *)error;

@end
