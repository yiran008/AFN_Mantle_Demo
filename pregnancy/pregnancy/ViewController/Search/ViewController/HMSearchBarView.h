//
//  HMSearchBarView.h
//  lama
//
//  Created by songxf on 13-12-26.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SEARCHBAR_MAXWIDTH 300

#define INPUTVIEW_WIDTH_BIG 244
#define INPUTVIEW_WIDTH_SMALL 244

@class HMSearchBarView;


@protocol HMSearchBarViewDelegate <NSObject>
// 取消搜索
- (void)searchBarViewCancleSearch;
@end


@interface HMSearchBarView : UIView<UITextFieldDelegate>

@property (nonatomic, assign) id<HMSearchBarViewDelegate> delegate;

@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIButton *searchIconButton;
@property (nonatomic, retain) UIButton *cancleButton;

- (void) setUserInputEnabled:(BOOL)inputEnable;

@end


