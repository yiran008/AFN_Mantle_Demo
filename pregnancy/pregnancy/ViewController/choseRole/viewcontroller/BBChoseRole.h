//
//  BBChoseRole.h
//  pregnancy
//
//  Created by babytree on 13-7-25.
//  Copyright (c) 2013年 babytree. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface BBChoseRole : BaseViewController<UIAlertViewDelegate>
@property (nonatomic,strong) IBOutlet UIView *roleView;
- (IBAction)choseRole:(id)sender;

@end