//
//  BBDueDateViewController.m
//  pregnancy
//
//  Created by zhongfeng on 13-8-22.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBDueDateViewController.h"
#import "BBAppConfig.h"
#import "BBPregnancyInfo.h"
#import "MobClick.h"
#import "BBStatisticsUtil.h"
#import "BBUser.h"
#import "NoticeUtil.h"
#import "MBProgressHUD.h"
#import "BBCacheData.h"
#import "BBApp.h"
#import "BBNavigationLabel.h"
#import "SBJsonParser.h"
#import "ASIFormDataRequest.h"
#import "BBUserRequest.h"
#import "BBAppDelegate.h"
#import "BBSupportTopicDetail.h"
#import "BBSettingViewController.h"
#import "BBEditPersonalViewController.h"
#import "BBPreparationEditViewController.h"


@interface BBDueDateViewController ()
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, retain) MBProgressHUD         *saveDueProgress;
@property (nonatomic, assign) int                   dueDateSetType;
@property (nonatomic, retain) ASIFormDataRequest    *dueDateRequest;

@end

@implementation BBDueDateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isRegisterNotice = YES;
    }
    return self;
}

- (void)dealloc
{
    [_dueDateRequest clearDelegatesAndCancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.selectDateView.frame = CGRectMake(0, DEVICE_HEIGHT - 20 - 44, 320, 260);
    self.selectCycleView.frame = CGRectMake(0, DEVICE_HEIGHT - 20 - 44, 320, 260);
    [self initDueDate];
    [self ConfigNavBar];
    [self addProgress];
    self.dueDateSetType = 0;
    [self resetViewWithType:0];
    
    self.dueDateSetTypeButton.exclusiveTouch = YES;
    self.dueDateKnowledgeButton.exclusiveTouch = YES;
    self.showPickerButton.exclusiveTouch = YES;
    self.inputCycleButton.exclusiveTouch = YES;
}

- (void)ConfigNavBar {
    [self.navigationItem setTitle:@"预产期设置"];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
//    if (self.isInitialDueDate) {
//        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        backButton.exclusiveTouch = YES;
//        [backButton setFrame:CGRectMake(0, 0, 40, 30)];
//        backButton.enabled = NO;
//        UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//        [self.navigationItem setLeftBarButtonItem:backBarButton];
//    }else {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.tag = 100;
        backButton.exclusiveTouch = YES;
        [backButton setFrame:CGRectMake(0, 0, 40, 30)];
        [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backBarButton];
//    }
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.exclusiveTouch = YES;
    [rightButton setFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(modifyDueDate:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
}

- (void)addProgress {
    self.saveDueProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.saveDueProgress];

}

- (void)resetViewWithType:(NSInteger)type {//0表示设置预产期，否则表示计算预产期
    self.calculateDateLabel.hidden = YES;
    self.calculateTipLabel.hidden = YES;
    [self hideDatePicker:nil];
    [self hideCyclePicker];
    if (type == 0) {
        NSDate *dueDate = [BBPregnancyInfo dateOfPregnancy];
        if (self.m_DefaultDateForRoleChange)
        {
            self.selectedDate = self.m_DefaultDateForRoleChange;
        }
        else
        {
            self.selectedDate = dueDate;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [dateFormatter setDateFormat:@"yyyy年M月d日"];
        self.dueDateLabel.textAlignment = NSTextAlignmentLeft;
        self.dueDateLabel.frame = CGRectMake(16,61,205,43);
        [self.dueDateSetTypeButton setTitle:@"计算预产期" forState:UIControlStateNormal];
        self.dueDateSetTypeLable.text = @"输入预产期";
        self.dueDateKnowledgeButton.hidden = YES;
        [MobClick event:@"edit_v2" label:@"输入预产期"];
        [self.showPickerButton setBackgroundImage:[UIImage imageNamed:@"inputBg"] forState:UIControlStateNormal];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(280 - 22) * 3600 * 24];
//        if ([dueDate compare:date] == NSOrderedDescending)
//        {
//            self.selectedDate =date;
//        }
       
        self.dueDateLabel.text = [dateFormatter stringFromDate:self.selectedDate];
        [self.selectDatePicker setMaximumDate:date];
        [self.selectDatePicker setMinimumDate:[NSDate dateWithTimeIntervalSince1970:0]];
        [self.selectDatePicker setDate:self.selectedDate];
        self.frameControlView.top = 95;
        self.inputCycleButton.hidden = YES;
        

    }else {
        NSInteger pregnancyCycleDay = [[BBPregnancyInfo pregnancyCycle] integerValue];
        NSDate *merDate = [NSDate dateWithTimeInterval:(-280-(pregnancyCycleDay-28))*3600*24 sinceDate:[BBPregnancyInfo dateOfPregnancy]];
        if (self.m_DefaultDateForRoleChange)
        {
            self.selectedDate = self.m_DefaultDateForRoleChange;
        }
        else
        {
            self.selectedDate = merDate;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [dateFormatter setDateFormat:@"yyyy年M月d日"];
        self.dueDateLabel.text = [dateFormatter stringFromDate:merDate];
        self.dueDateLabel.frame = CGRectMake(115,61,170,43);
        [self.dueDateSetTypeButton setTitle:@"输入预产期" forState:UIControlStateNormal];
        self.dueDateSetTypeLable.text = @"计算预产期";
        self.dueDateKnowledgeButton.hidden = NO;
        [MobClick event:@"edit_v2" label:@"计算预产期"];
        [self.showPickerButton setBackgroundImage:[UIImage imageNamed:@"input1_bg"] forState:UIControlStateNormal];
        
        [self.inputCycleButton setTitle:[BBPregnancyInfo pregnancyCycle] forState:UIControlStateNormal];
        [self.selectCyclePicker selectRow:[[BBPregnancyInfo pregnancyCycle] intValue] - 20 inComponent:0 animated:NO];
        [self.selectDatePicker setMaximumDate:[NSDate date]];
        [self.selectDatePicker setMinimumDate:[NSDate dateWithTimeIntervalSince1970:0]];
        [self.selectDatePicker setDate:self.selectedDate];
        self.frameControlView.top = 155;
        self.inputCycleButton.hidden = NO;
    }
}

- (void)initDueDate {
    NSDate *dueDate = [BBPregnancyInfo dateOfPregnancy];
    if (!dueDate) {
        [BBPregnancyInfo setPregnancyTimeWithDueDate:[NSDate dateWithTimeInterval:3600*24*258 sinceDate:[BBPregnancyInfo currentDate]]];
        dueDate = [BBPregnancyInfo dateOfPregnancy];
    }
    self.selectedDate = dueDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy年M月d日"];
    self.dueDateLabel.text = [dateFormatter stringFromDate:dueDate];
}

- (IBAction)updateyDueDate:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年M月d日"];
    if (self.dueDateSetType == 0) {
        self.dueDateLabel.text = [dateFormatter stringFromDate:self.selectDatePicker.date];
        self.selectedDate = self.selectDatePicker.date;
    }else {
        self.dueDateLabel.text = [dateFormatter stringFromDate:self.selectDatePicker.date];
        self.selectedDate = self.selectDatePicker.date;
    }
}

- (IBAction)conformSelect:(id)sender {
    [self hideDatePicker:self.selectDatePicker];
    if (self.dueDateSetType == 0) {
        
    }else {
        self.calculateTipLabel.hidden = NO;
        self.calculateDateLabel.hidden = NO;
        self.frameControlView.top = 165;

        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateCom = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:self.selectedDate];
        NSTimeInterval timeInterval = dateCom.hour*3600+dateCom.minute*60+dateCom.second;
        NSDate *dueDate = [[NSDate alloc] initWithTimeInterval:-timeInterval+3600*24*(280 + [self.inputCycleButton.titleLabel.text intValue]-28) sinceDate:self.selectedDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy'年'M'月'd'日'"];
        [ self.calculateDateLabel setText:[dateFormatter stringFromDate:dueDate]];
    }
    
}

- (IBAction)setCycle:(id)sender {
    [self hideCyclePicker];    
    self.calculateTipLabel.hidden = NO;
    self.calculateDateLabel.hidden = NO;
    self.frameControlView.top = 165;

    if ([self.inputCycleButton.titleLabel.text length] != 0 && [self.inputCycleButton.titleLabel.text length] != 0) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateCom = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:self.selectedDate];
        NSTimeInterval timeInterval = dateCom.hour*3600+dateCom.minute*60+dateCom.second;
        NSDate *dueDate = [[NSDate alloc] initWithTimeInterval:-timeInterval+3600*24*(280+[self.inputCycleButton.titleLabel.text intValue]-28) sinceDate:self.selectedDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy'年'M'月'd'日"];
        [self.calculateDateLabel setText:[dateFormatter stringFromDate:dueDate]];
    }

}

- (IBAction)changeDueDateSetType:(id)sender {
    if (self.dueDateSetType == 0) {
        self.dueDateSetType = 1;
        [self resetViewWithType:self.dueDateSetType];
    }else {
        self.dueDateSetType = 0;
        [self resetViewWithType:self.dueDateSetType];
    }
}

- (IBAction)modifyDueDate:(id)sender {
    if (self.dueDateSetType == 0) {
        if ([self.dueDateLabel.text length] == 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"预产期不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    else
    {
        if ([self.dueDateLabel.text length] == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"末次月经不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    
    if (self.isInitialDueDate) {
        //[BBUser setCheckDueDateStatus:YES];
        [BBUser setNeedSynchronizeDueDate:NO];
        [BBUser setNeedSynchronizeStatisticsDueDate:YES];
        //快乐孕期
        if (self.dueDateSetType == 0) {
            [BBPregnancyInfo setPregnancyTimeWithDueDate:self.selectedDate];
        }
        else
        {
            [BBPregnancyInfo setPregnancyTimeWithMenstrualDate:self.selectedDate withCycle:[self.inputCycleButton.titleLabel.text integerValue]];
        }
        [BBUser setNewUserRoleState:BBUserRoleStatePregnant];
        
        if ([BBUser getNewUserRoleState] == BBUserRoleStatePregnant && self.isRegisterNotice) {
            [NoticeUtil registerBBRecallParentLocalNotification];
            [NoticeUtil registerBBCutParentLocalNotification];
        }

        
        // 设置报喜贴提醒次数
        [BBUser setBabyBornReminderNum:2];
        [BBUser setBabyBornTodayReminderNum:0];
        
        [self modifyDueDatefinish];
        [MobClick event:@"edit_v2" label:@"成功保存预产期"];
        
    }else {
        [self checkSynchronizeDueDate];
    }
}

- (IBAction)showDatePicker:(id)sender {
    [self hideCyclePicker];
    [UIView animateWithDuration:.25 animations:^{
        self.selectDateView.frame = CGRectMake(0, DEVICE_HEIGHT - 20 - 44 - 260, 320, 260);

    }];
}


- (IBAction)hideDatePicker:(id)sender {
    [UIView animateWithDuration:.25 animations:^{
        self.selectDateView.frame = CGRectMake(0, DEVICE_HEIGHT - 20 - 44, 320, 260);
    }];

}

- (void)hideCyclePicker {
    [UIView animateWithDuration:.25 animations:^{
        self.selectCycleView.frame = CGRectMake(0, DEVICE_HEIGHT - 20 - 44, 320, 260);
    }];
}

- (IBAction)showCyclePicker {
    [self hideDatePicker:nil];
    [UIView animateWithDuration:.25 animations:^{
        self.selectCycleView.frame = CGRectMake(0, DEVICE_HEIGHT - 20 - 44 - 260, 320, 260);
        
    }];

}

- (IBAction)toCalculateDueDateKnowledge:(id)sender
{
    [MobClick event:@"edit_v2" label:@"如何计算预产期"];
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.isShowCloseButton = NO;
    [exteriorURL setLoadURL:@"shuomingshu.html"];
    [exteriorURL setTitle:@"准妈妈孕周的计算"];
    [self.navigationController pushViewController:exteriorURL animated:YES];
}


- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideProgerssWithTile:(NSString *)title delay:(float)delay customImageName:(NSString *)iamgeName {
    self.saveDueProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iamgeName]];
    self.saveDueProgress.mode = MBProgressHUDModeCustomView;
    self.saveDueProgress.labelText = title;
    [self.saveDueProgress hide:YES afterDelay:delay];
}

- (void)showProgressWithTitle:(NSString *)title
{
    self.saveDueProgress.mode = MBProgressHUDModeIndeterminate;
    self.saveDueProgress.labelText = title;
    [self.saveDueProgress show:YES];
}

- (NSDate *)getPregnancyTimeWithMenstrualDate:(NSDate *)theMenstrualDate withCycle:(NSInteger)cycle
{
    
    if (!([theMenstrualDate isKindOfClass:[NSDate class]]||theMenstrualDate==nil)) {
        return [BBPregnancyInfo dateOfPregnancy];
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDateComponents *dateCom = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:theMenstrualDate];
    NSTimeInterval timeInterval = dateCom.hour*3600+dateCom.minute*60+dateCom.second;
    NSDate *dueDate = [[NSDate alloc] initWithTimeInterval:-timeInterval+3600*24*(280+cycle-28) sinceDate:theMenstrualDate];
    
    return dueDate;
}

- (void)setPregnancyDueDate
{
    [self showProgressWithTitle:@"保存中..."];
    NSDate *newDate = nil;
    if (self.dueDateSetType == 0) {
        newDate = self.selectedDate;
    }else {
        newDate = [self getPregnancyTimeWithMenstrualDate:self.selectedDate withCycle:[self.inputCycleButton.titleLabel.text integerValue]];
    }
    
    [self.dueDateRequest clearDelegatesAndCancel];
    NSString *babyStatus = [BBPregnancyInfo clientStatusOfUserRoleState:BBUserRoleStatePregnant];
    self.dueDateRequest = [BBUserRequest modifyUserDueDate:newDate changeToStatus:babyStatus];
    [self.dueDateRequest setDidFinishSelector:@selector(synchronizeDueDateFinish:)];
    [self.dueDateRequest setDidFailSelector:@selector(synchronizeDueDateFail:)];
    [self.dueDateRequest setDelegate:self];
    [self.dueDateRequest startAsynchronous];
}

- (void)checkSynchronizeDueDate
{
    if (![BBUser isLogin]) {
        //判断这个是因为避免修改预产期后回到首页提示预产期已修改...
        if (self.dueDateSetType == 0) {
            [BBPregnancyInfo setPregnancyTimeWithDueDate:self.selectedDate];
            
        }
        else
        {
            [BBPregnancyInfo setPregnancyTimeWithMenstrualDate:self.selectedDate withCycle:[self.inputCycleButton.titleLabel.text integerValue]];
        }
        
        [MobClick event:@"edit_v2" label:@"成功保存预产期"];
        [self.saveDueProgress setLabelText:@"保存成功"];
        self.saveDueProgress.animationType = MBProgressHUDAnimationFade;
        self.saveDueProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        self.saveDueProgress.mode = MBProgressHUDModeCustomView;
        [self.saveDueProgress show:YES];
        [self.saveDueProgress hide:YES afterDelay:1];
        
        //[BBUser setCheckDueDateStatus:YES];
        [BBUser setNeedSynchronizeDueDate:NO];
        [BBUser setNeedSynchronizeStatisticsDueDate:YES];
        // 修改用户状态
        [BBUser setNewUserRoleState:BBUserRoleStatePregnant];
        
        if ([BBUser getNewUserRoleState] == BBUserRoleStatePregnant && self.isRegisterNotice ) {
            [NoticeUtil registerBBRecallParentLocalNotification];
            [NoticeUtil registerBBCutParentLocalNotification];
        }
        
        // 设置报喜贴提醒次数
        [BBUser setBabyBornReminderNum:2];
        [BBUser setBabyBornTodayReminderNum:0];
        [self performSelector:@selector(modifyDueDatefinish) withObject:nil afterDelay:1];
    }else {
        [self setPregnancyDueDate];
    }
}

-(void)modifyDueDatefinish
{
    if (![BBApp getAppLaunchStatus])
    {
        [BBApp setAppLaunchStatus:YES];
        BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate enterMainPage];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_PERSONAL_PREGNANCY object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];

    for (UIViewController *viewCtrl in [self.navigationController viewControllers])
    {
        if ([viewCtrl isKindOfClass:[BBSettingViewController class]] || [viewCtrl isKindOfClass:[BBEditPersonalViewController class]] || [viewCtrl isKindOfClass:[BBPreparationEditViewController class]])
        {
            [self.navigationController popToViewController:viewCtrl animated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - loginDelegate
- (void)loginFinish
{
    [self setPregnancyDueDate];
}

#pragma mark - ASIHttpRequest delegate
- (void)synchronizeDueDateFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        [self hideProgerssWithTile:@"保存失败" delay:1.5 customImageName:@"xxx"];
        return;
    }
    if ([[jsonDictionary stringForKey:@"status"] isEqualToString:@"success"]) {
        if (self.dueDateSetType == 0) {
            [BBPregnancyInfo setPregnancyTimeWithDueDate:self.selectedDate];
        }else {
            [BBPregnancyInfo setPregnancyTimeWithMenstrualDate:self.selectedDate withCycle:[self.inputCycleButton.titleLabel.text integerValue]];
        }
        [MobClick event:@"edit_v2" label:@"成功保存预产期"];
        
        //[BBUser setCheckDueDateStatus:YES];
        [BBUser setNeedSynchronizeDueDate:NO];
        [BBUser setNeedSynchronizeStatisticsDueDate:YES];
        // 修改用户状态
        [BBUser setNewUserRoleState:BBUserRoleStatePregnant];
        
        // 设置报喜贴提醒次数
        [BBUser setBabyBornReminderNum:2];
        [BBUser setBabyBornTodayReminderNum:0];

        if (self.isRegisterNotice)
        {
            [NoticeUtil registerBBRecallParentLocalNotification];
            [NoticeUtil registerBBCutParentLocalNotification];
        }
        
        [self hideProgerssWithTile:@"保存成功" delay:1.5 customImageName:@"37x-Checkmark.png"];
        [self performSelector:@selector(modifyDueDatefinish) withObject:nil afterDelay:1.5];
        
    }else {
        [self hideProgerssWithTile:@"保存失败" delay:1.5 customImageName:@"xxx"];
    }
}

- (void)synchronizeDueDateFail:(ASIFormDataRequest *)request
{
    [self hideProgerssWithTile:@"保存失败" delay:1.5 customImageName:@"xxx"];
}


#pragma mark - UIPickerView Delegate and DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 26;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d", row+20];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.inputCycleButton setTitle:[NSString stringWithFormat:@"%d", row+20] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
