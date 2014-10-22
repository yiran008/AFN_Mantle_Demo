//
//  BBRollCycleView.h
//  pregnancy
//
//  Created by whl on 13-12-11.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBRollCycleView : UIView

@property (nonatomic, strong)  NSTimer  *timer;
@property (nonatomic, retain)  NSArray *contentArray;
//直接传入字符串
@property (nonatomic, retain)  NSArray *strArray;
@property (nonatomic, strong)  UILabel *rollFristLabel;
@property (nonatomic, strong)  UILabel *rollSecondLabel;
@property (assign) BOOL isRoll;
@property (assign) NSInteger indexCount;

- (void)startTimer;

- (void)stopTimer;
- (void)resetTimer;
@end
