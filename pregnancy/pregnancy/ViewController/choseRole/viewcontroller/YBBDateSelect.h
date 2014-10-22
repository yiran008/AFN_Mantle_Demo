//
//  BBDateSelect.h
//  pregnancy
//
//  Created by Jun Wang on 12-4-12.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBBDateSelect : BaseViewController {
    UIDatePicker *dueDatePicker;
    UIButton *datePickerButton;
    UIView *datePickerView;
    UILabel *dateInfoLabel;
}

@property (nonatomic, strong) IBOutlet UIDatePicker *dueDatePicker;
@property (nonatomic, strong) IBOutlet UIButton *datePickerButton;
@property (nonatomic, strong) IBOutlet UIView *datePickerView;
@property (assign) BOOL m_IsChoseRole;
@property (nonatomic, strong) NSDate *m_DefaultDateForRoleChange;
// 保存成功后是否跳转设置页面 yes:返回设置页面 no:返回上一页面
@property (nonatomic, assign) BOOL isGoBack;
@property (nonatomic, retain) MBProgressHUD         *saveDueProgress;
@property (nonatomic, retain) ASIFormDataRequest    *dueDateRequest;

@end
