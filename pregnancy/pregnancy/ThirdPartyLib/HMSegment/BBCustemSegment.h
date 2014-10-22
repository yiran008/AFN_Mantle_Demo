//
//  BBCustemSegment.h
//  PPiFlatSegmentedControl-Demo
//
//  Created by whl on 14-4-11.
//  Copyright (c) 2014年 PPinera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//引入noDataView 枚举
#import "HMNoDataView.h"

typedef void(^selectionBlock)(NSUInteger segmentIndex);

@interface BBCustemSegment : UIView

@property (nonatomic,strong) UIColor *selectedColor;
@property (nonatomic,strong) UIColor *color;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,strong) UIColor *borderColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic,strong) NSDictionary *textAttributes;
@property (nonatomic,strong) NSDictionary *selectedTextAttributes;


- (id)initWithFrame:(CGRect)frame items:(NSArray*)items andSelectionBlock:(selectionBlock)block;
-(void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment;
-(BOOL)isEnabledForSegmentAtIndex:(NSUInteger)index;
-(void)setTitle:(id)title forSegmentAtIndex:(NSUInteger)index;
-(void)setSelectedTextAttributes:(NSDictionary*)attributes;

-(void)setNoDataViewStatusInfoWithArrayIndex:(NSUInteger)theIndex withHidden:(BOOL)theHidden;
-(void)setNoDataViewStatusInfoWithArrayIndex:(NSUInteger)theIndex withNoDataType:(HMNODATAVIEW_TYPE)theNoDataType withHidden:(BOOL)theHidden;
-(void)setNoDataViewStatusInfoWithArrayIndex:(NSUInteger)theIndex withNoDataType:(HMNODATAVIEW_TYPE)theNoDataType withHidden:(BOOL)theHidden withText:(NSString *)theText;

-(NSDictionary *)getNoDataStatusWithIndex:(NSUInteger)theIndex;
@end