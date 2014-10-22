//
//  BBDueDateViewController.h
//  pregnancy
//
//  Created by zhongfeng on 13-8-22.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBLogin.h"
@interface BBDueDateViewController : BaseViewController <UIPickerViewDataSource,UIPickerViewDelegate,BBLoginDelegate>
@property (nonatomic, retain) IBOutlet UIView        *selectDateView;
@property (nonatomic, retain) IBOutlet UIView        *selectCycleView;
@property (nonatomic, retain) IBOutlet UIDatePicker  *selectDatePicker;
@property (nonatomic, retain) IBOutlet UIPickerView  *selectCyclePicker;
@property (nonatomic, retain) IBOutlet UILabel       *dueDateLabel;
@property (nonatomic, retain) IBOutlet UILabel       *calculateTipLabel;
@property (nonatomic, retain) IBOutlet UILabel       *calculateDateLabel;
@property (nonatomic, retain) IBOutlet UIButton      *dueDateSetTypeButton;
@property (nonatomic, retain) IBOutlet UILabel       *dueDateSetTypeLable;
@property (nonatomic, retain) IBOutlet UIButton      *dueDateKnowledgeButton;
@property (nonatomic, retain) IBOutlet UIButton      *showPickerButton;
@property (nonatomic, retain) IBOutlet UIButton      *inputCycleButton;
@property (nonatomic, retain) IBOutlet UIView        *frameControlView;
@property (nonatomic, assign) BOOL                   isInitialDueDate;
@property (assign) BOOL isRegisterNotice;
// 判断修改完成后页面跳转: YES:跳转到对应首页 NO:返回上一页
@property (nonatomic, assign) BOOL                   isGoBack;
@property (nonatomic, strong) NSDate *m_DefaultDateForRoleChange;



- (IBAction)updateyDueDate:(id)sender;
- (IBAction)showDatePicker:(id)sender;
- (IBAction)hideDatePicker:(id)sender;
- (IBAction)modifyDueDate:(id)sender;
- (IBAction)toCalculateDueDateKnowledge:(id)sender;
- (IBAction)changeDueDateSetType:(id)sender;
- (IBAction)conformSelect:(id)sender;
- (IBAction)setCycle:(id)sender;

@end
