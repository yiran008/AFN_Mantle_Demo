//
//  AlertUtil.m
//  ask
//
//  Created by ilike1980 on 11-11-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AlertUtil.h"


@implementation AlertUtil
+ (void)showAlert:(NSString *)title withMessage:(NSString *)msg
{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:title 
                                            message:msg 
                                            delegate:nil 
                                            cancelButtonTitle:@"知道了"
                                            otherButtonTitles: nil];
    [alert show];
    [alert release];
}

+ (void)showApiAlert:(NSString *)title withJsonObject:(NSDictionary *)response
{
    [self showAlert:title withMessage:[response stringForKey:@"message"]];
}

+ (void)showErrorAlert:(NSString *)title withError:(NSError *)error
{
    [self showAlert:title withMessage:[error localizedFailureReason]];
}
@end
