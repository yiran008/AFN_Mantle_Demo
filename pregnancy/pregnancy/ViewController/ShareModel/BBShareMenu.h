//
//  BBShareMenu.h
//  pregnancy
//
//  Created by zhangzhongfeng on 13-7-24.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBShareMenuItem.h"
@protocol ShareMenuDelegate;

@interface BBShareMenu : UIView

@property (nonatomic, retain) UIImageView   *qrImageView;
@property (nonatomic, assign) id<ShareMenuDelegate> delegate;
@property (nonatomic, retain) NSString      *qrUrl;



- (id)initWithType:(NSInteger)menuType dataArray:(NSMutableArray *)dataArray title:(NSString *)title;
- (id)initWithTitle:(NSString *)title;
- (id)initWithType:(NSInteger)menuType title:(NSString *)title;
- (id)initWithTitle:(NSString *)title dataArray:(NSMutableArray *)dataArray;
- (void)show;

@end

@protocol ShareMenuDelegate <NSObject>
- (void)shareMenu:(BBShareMenu *)shareMenu clickItem:(BBShareMenuItem *)item;
@optional
- (void)closeMenu:(BBShareMenu *)shareMenu;
@end
