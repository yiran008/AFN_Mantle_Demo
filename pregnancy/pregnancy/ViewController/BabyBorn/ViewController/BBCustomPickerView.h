//
//  BBCustomPickerView.h
//  pregnancy
//
//  Created by yxy on 14-4-9.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBCustomPickerView;
@protocol BBCustomPickerViewDelegate <NSObject>

- (void )BBCustomPickerView:(BBCustomPickerView *)pickerView  withChecked:(NSString *)checked inComponent:(NSInteger)component;

@end

@interface BBCustomPickerView : UIView
<
    UIPickerViewDataSource,
    UIPickerViewDelegate
>

@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,assign) NSInteger numberOfComponent;
// 滑轮第一列显示数据
@property (nonatomic,strong) NSArray *firstColumnArray;
// 滑轮第二列显示数据
@property (nonatomic,strong) NSArray *secondColumnArray;
@property (nonatomic,assign) id <BBCustomPickerViewDelegate>delegate;

// 设置默认显示数据
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
@end
