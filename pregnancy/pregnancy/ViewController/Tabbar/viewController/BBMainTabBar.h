//
//  HMHotMomTabBar.h
//  BBHotMum
//
//  Created by songxf on 13-12-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBTabBarItemView.h"

#define MAIN_TAB_INDEX_MAINPAGE 0
#define MAIN_TAB_INDEX_CIRCLE 1
#define MAIN_TAB_INDEX_MALL 2
#define MAIN_TAB_INDEX_TOOLPAGE 3
#define MAIN_TAB_INDEX_PERSONCENTER 4
/**
 *  用通知触发tabbar显示和隐藏 BOOL值为YES表示显示 NO为隐藏
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINTABBAR_ISHIDE_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"show", nil]];
 */
#define MAINTABBAR_ISHIDE_NOTIFICATION @"MAINTABBAR_ISHIDE_NOTIFICATION"

#define UPDATE_TIP_TIME 10*60

@interface BBMainTabBar : UITabBarController
{
    // 目前界面显示的item的个数
    NSInteger numberOfItems;
    BOOL isNotFirst;
}

// 自定义TabBar的背景Image
@property (nonatomic, strong) UIImageView *m_TabBarBgView;

// button上的text list
@property (nonatomic, strong) NSMutableArray *tab_textlist;

// item list
@property (nonatomic, strong) NSMutableArray *tab_itemlist;

// button背景图片名list
@property (nonatomic, strong) NSMutableArray *btn_bg_imagelist;

// button选中时的图片名list
@property (nonatomic, strong) NSMutableArray *btn_selectbg_imagelist;

// button按下高亮时的图片名list
@property (nonatomic, strong) NSMutableArray *btn_highlightbg_imagelist;

// 生日统计用
//@property (nonatomic, strong) ASIHTTPRequest *m_BirthRequests;


// 选中某个Tab
- (void)selectedTabWithIndex:(NSInteger)index;

// 隐藏原来的tabbar
- (void)hideOriginTabBar;

// 一次性创建所有VC
- (void)addViewControllers;

// 添加模拟的TabBar
- (void)addViewReplaceTabBar;

// 某个Tab上可能push了很多层，回到初始页面
- (void)backTopLeverView:(NSInteger)index;

// 在某个Tab上显示提醒红点
- (void)showTipPointWithIndex:(NSInteger)index;

// 隐藏在某个Tab上的提醒红点
- (void)hideTipPointWithIndex:(NSInteger)index;

// 某个Tab上的提醒红点状态
- (BOOL)getTipPointStateWithIndex:(NSInteger)index;

// 根据索引找到VC
- (UIViewController *)getViewControllerAtIndex:(NSInteger)index;

// 设置某个VC隐藏
- (void)setViewControllersHide:(BOOL)hide atIndex:(NSInteger)index;

@end
