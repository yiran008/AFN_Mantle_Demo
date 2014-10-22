//
//  BBMusicActivation.h
//  pregnancy
//
//  Created by whl on 14-4-22.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMNoDataView.h"

@interface BBMusicActivation : BaseViewController
<
    HMNoDataViewDelegate
>
@property (nonatomic, strong) NSDictionary *m_ScanDic;

// 修改显示文案区别 胎教音乐和早教音乐
@property (nonatomic, strong) IBOutlet UILabel *reminderLabel;
@property (nonatomic, strong) IBOutlet UIButton *buyPregnancyBoxButton;
@property (nonatomic, strong) IBOutlet UIButton *scanMarkButton;
// 两个按钮的背景View,
@property (nonatomic, strong) IBOutlet UIView *buyPregnancyBoxBgView;
@property (nonatomic, strong) IBOutlet UIView *scanMarkBgView;
@end
