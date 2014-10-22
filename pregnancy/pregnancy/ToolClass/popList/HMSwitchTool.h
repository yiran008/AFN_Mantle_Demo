//
//  HMSwitchTool.h
//  lama
//
//  Created by songxf on 13-8-10.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SWITCH_TOOL_WIDTH 180
#define SWITCH_TOOL_HEIGHT 32

@protocol HMSwitchToolDelegate <NSObject>

@optional
- (void)haveSelectedBtnIndex:(NSInteger)index;

@end

@interface HMSwitchTool : UIView

@property (nonatomic, retain) UIButton *leftBtn;
@property (nonatomic, retain) UIButton *rightBtn;

@property (nonatomic,assign)id<HMSwitchToolDelegate> delegate;

- (id)initWithFrame:(CGRect)frame  dataList:(NSArray *)data delegate:(id)delegat;
- (void)pressBtn:(UIButton *)btn;

@end
