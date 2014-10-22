//
//  HMSearchVC.h
//  lama
//
//  Created by songxf on 13-12-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMTableViewController.h"
#import "HMSearchBarView.h"
#import "ASIFormDataRequest.h"
#import "HMSearchHistoryCell.h"

typedef NS_ENUM(NSUInteger, HMSEARCHTYPE)
{
    HMSEARCH_TYPE_TOPIC,       //0 搜帖子
    HMSEARCH_TYPE_KNOWLEDGE,   // 1 搜知识
    HMSEARCH_TYPE_USER         // 2 搜用户
};


@interface HMSearchVC : HMTableViewController
<
    HMSearchBarViewDelegate,
    HMSearchHistoryCellDelegate,
    UITextFieldDelegate
>
{
    CGPoint gesturePoint;
    
    HMSEARCHTYPE enterSearchType;
    HMSEARCHTYPE curSearchType;
}

@property (nonatomic, assign) UINavigationController *nav;
@property (nonatomic, retain) HMSearchBarView *searchBarView;

@property (retain, nonatomic) UIImageView *tabBgImageView;
@property (retain, nonatomic) UIImageView *buttonImageView;
// 是否需要弹出键盘
@property (nonatomic, assign) BOOL isShowKeyboard;

@end
