//
//  BaseViewController.h
//  pregnancy
//
//  Created by zhangzhongfeng on 13-12-23.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMNavigation.h"

@interface BaseViewController : UIViewController
- (IBAction)backAction:(id)sender;
- (BOOL)isVisible;
@end
