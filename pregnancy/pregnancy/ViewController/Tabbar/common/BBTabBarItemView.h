//
//  HMTabBarItemView.h
//  HMHotMom
//
//  Created by songxf on 13-6-9.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ITEM_TAG_START 100000
#define TABBAR_BUTTON_WIDTH 40
#define TABBAR_HEIGHT 40
@interface BBTabBarItemView : UIButton

// item小图标
@property (nonatomic, strong) UIImageView *m_icon;

// item标题
@property (nonatomic, strong) UILabel     *m_titleLable;

// 提醒红标
@property (nonatomic, strong) UILabel     *m_tipLab;

// icon在正常、选中、高亮三种状态的时候对应的图片名
@property (nonatomic, strong) NSArray     *m_iconImages;


// 设置图标背景图组
- (void)setNormalImageName:(NSString *)normal
        highLightImageName:(NSString *)high
         selectedImageName:(NSString *)selected;

- (void)showTipPoint;
- (void)hideTipPoint;
- (BOOL)isTipShow;

// 0 隐藏
- (void)setTipNumber:(NSInteger)number;

@end
