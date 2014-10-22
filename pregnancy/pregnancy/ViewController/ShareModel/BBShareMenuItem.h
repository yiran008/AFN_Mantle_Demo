//
//  BBShareMenuItem.h
//  pregnancy
//
//  Created by zhangzhongfeng on 13-7-24.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBShareMenuItem : UIButton
@property (nonatomic, assign) NSInteger indexAtMenu;
@property (nonatomic, retain) NSString      *shareTo;


- (id)initWithTitle:(NSString *)title image:(NSString *)imageName shareTo:(NSString *)shareTo;

@end
