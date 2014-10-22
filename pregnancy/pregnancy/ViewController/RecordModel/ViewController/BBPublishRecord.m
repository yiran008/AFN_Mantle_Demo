//
//  BBPublishRecord.m
//  pregnancy
//
//  Created by whl on 13-9-22.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBPublishRecord.h"
#import "BBRecordRequest.h"
#import "BBRecordMainPage.h"
#define BACK_ALERT_VIEW_TAG 3
#define MAX_CONTENT_LENGTH  500

@interface BBPublishRecord ()
@property (assign) NSInteger recordContentCount;
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;
@property (nonatomic, strong) NSMutableString *s_IFlyString;

@end

@implementation BBPublishRecord
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_dateButton release];
    [_selectDate release];
    [_dateView release];
    [_statusButton release];
    [_contentView release];
    [_countLabel release];
    [_imageButton release];
    [_imagePicker release];
    [_photoActionSheet release];
    [_uploadImageData release];
    [_loadProgress release];
    [_recordRequest clearDelegatesAndCancel];
    [_recordRequest release];
    [_currentContentString release];
    [_recordDate release];
    [_iflyRecognizerView cancel];
    [IFlySpeechUtility destroy];
    [_iflyRecognizerView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self addObserver];
        self.isRequestShow = YES;
        self.isPrivate = NO;
        self.recordContentCount = 0;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"新建记录";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.exclusiveTouch = YES;
    [commitButton setFrame:CGRectMake(0, 0, 40, 30)];
    [commitButton setTitle:@"完成" forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [commitButton addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    [self.navigationItem setRightBarButtonItem:commitBarButton];
    [commitBarButton release];
    
    NSDateComponents *comp = [[[NSDateComponents alloc]init]autorelease];
    [comp setMonth:01];
    [comp setDay:01];
    [comp setYear:2008];
    NSCalendar *myCal = [[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    NSDate *myDate1 = [myCal dateFromComponents:comp];
    
    NSDate *now = [[[NSDate alloc]init]autorelease];
    [self.selectDate setMaximumDate:now];
    [self.selectDate setMinimumDate:myDate1];
    [self.selectDate setDate:now animated:NO];
    self.recordDate = now;
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:now];
    [self.dateButton setTitle:destDateString forState:UIControlStateNormal];
    
    if (self.isPrivate) {
        [self.statusButton setImage:[UIImage imageNamed:@"recordprivate"] forState:UIControlStateNormal];
    }else{
        [self.statusButton setImage:[UIImage imageNamed:@"recordpublic"] forState:UIControlStateNormal];
    }
    
    [BBIflyMSC firstInit];
    self.iflyRecognizerView = [BBIflyMSC CreateRecognizerView:self];
    self.s_IFlyString  = nil;
    
    self.loadProgress = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:self.loadProgress];
    
    self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    [self.imagePicker setDelegate:self];
    if (IS_IPHONE5) {
        [self.dateView setFrame:CGRectMake(self.dateView.frame.origin.x, self.dateView.frame.origin.y+88, 320, self.dateView.frame.size.height)];
    }
    
    self.dateButton.exclusiveTouch = YES;
    self.imageButton.exclusiveTouch = YES;
    self.statusButton.exclusiveTouch = YES;
}

-(IBAction)backAction:(id)sender
{
    if ([self.loadProgress isShow] && self.isRequestShow) {
        self.isRequestShow = NO;
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
        return;
    }
    
    if ([[self.contentView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || self.contentView.text==nil){
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还有未发布的内容，是否返回" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setTag:BACK_ALERT_VIEW_TAG];
        [alertView show];
        [alertView release];
        
    }
}

-(IBAction)commitAction:(id)sender
{
    if ([self.loadProgress isShow]) {
        return;
    }
    if (([[self.contentView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || self.contentView.text==nil) && self.uploadImageData == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入内容,或者选择图片" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    if (self.recordContentCount > MAX_CONTENT_LENGTH)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲！内容已超过500字了！" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    [self.contentView resignFirstResponder];
    [self keyboardCancelChangeFrame];
    [self publishTopic];

}

-(IBAction)privateAction:(id)sender
{
    [self.contentView resignFirstResponder];
    [self keyboardCancelChangeFrame];
    [self closeDatePicker];
    if (self.isPrivate) {
        [MobClick event:@"mood_v2" label:@"设置为公开"];
        self.isPrivate = NO;
        [self.statusButton setImage:[UIImage imageNamed:@"recordpublic"] forState:UIControlStateNormal];
    }else{
        [MobClick event:@"mood_v2" label:@"设置为私密"];
        self.isPrivate = YES;
        [self.statusButton setImage:[UIImage imageNamed:@"recordprivate"] forState:UIControlStateNormal];
    }
}


- (void)publishTopic
{
    [self.loadProgress setLabelText:@"正在保存"];
    [self.loadProgress show:YES];
    

    if (self.uploadImageData == nil)
    {
        [MobClick event:@"mood_v2" label:@"成功写心情-纯文字"];
    }
    else
    {
        [MobClick event:@"mood_v2" label:@"成功写心情-含图片"];
    }

    NSString *strPrivate = @"yes";
    if (self.isPrivate) {
        strPrivate = @"yes";
    }else{
        strPrivate = @"no";
    }
    NSString *recordTS = [NSString stringWithFormat:@"%lld", (long long)[self.recordDate timeIntervalSince1970]];
    [self.recordRequest clearDelegatesAndCancel];
    self.recordRequest = [BBRecordRequest publishRecord:self.contentView.text withRecodTimes:recordTS withPhotoData:self.uploadImageData withPrivate:strPrivate];
    [self.recordRequest setDidFinishSelector:@selector(submitRecordFinish:)];
    [self.recordRequest setDidFailSelector:@selector(submitRecordFail:)];
    [self.recordRequest setDelegate:self];
    [self.recordRequest startAsynchronous];
}
#pragma mark - ASIHttp Request Delegate

- (void)submitRecordFinish:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *submitTopicData = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        [self.loadProgress hide:YES];
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"发送主题失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    if ([[submitTopicData stringForKey:@"status"] isEqualToString:@"success"])
    {
        [MobClick event:@"mood_v2" label:@"全部成功写心情"];
        if (self.isRequestShow) {
            self.isRequestShow = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:UPADATE_RECORD_MOON_VIEW object:nil userInfo:nil];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        self.recordContentCount = 0;
    }
    else
    {
        [self.loadProgress hide:YES];
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"发送主题失败" message:[[submitTopicData dictionaryForKey:@"data"] stringForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)submitRecordFail:(ASIHTTPRequest *)request
{
    [self.loadProgress hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}


- (void)setTextView {
    self.contentView.placeholder = @"今天，想对宝宝说......";
    self.contentView.font = [UIFont systemFontOfSize:15];
    [self.contentView setPlaceholderTextColor:[UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1]];
}

-(void)closeDatePicker
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.dateView setFrame:CGRectMake(self.dateView.frame.origin.x, IPHONE5_ADD_HEIGHT(416), self.dateView.frame.size.width, self.dateView.frame.size.height)];
    }];
}

- (IBAction)clickedSelectDate:(id)sender
{
    [MobClick event:@"mood_v2" label:@"新建记录日期修改"];
    [self.contentView resignFirstResponder];
    [self keyboardCancelChangeFrame];
    [self.view bringSubviewToFront:self.dateView];
    [UIView animateWithDuration:0.2 animations:^{
        [self.dateView setFrame:CGRectMake(self.dateView.frame.origin.x, IPHONE5_ADD_HEIGHT(200), self.dateView.frame.size.width, self.dateView.frame.size.height)];
    }];
    
    NSDate *selected = [self.selectDate date];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    
    [self.dateButton setTitle:destDateString forState:UIControlStateNormal];
    
}

- (IBAction)getSelectDate:(id)sender
{
    NSDate *selected = [self.selectDate date];
    self.recordDate = selected;
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    
    [self.dateButton setTitle:destDateString forState:UIControlStateNormal];
    
    [self closeDatePicker];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    IOS6_RELEASE_VIEW
}

- (void)viewDidUnload
{
    [self viewDidUnloadBabytree];
    
    [super viewDidUnload];
}

- (void)viewDidUnloadBabytree
{
    self.dateButton = nil;
    self.selectDate = nil;
    self.statusButton = nil;
    self.contentView = nil;
    self.countLabel = nil;
    self.imageButton  = nil;
    self.loadProgress = nil;
    [self.recordRequest clearDelegatesAndCancel];
    self.recordRequest = nil;
    self.dateView = nil;
}

-(IBAction)addcamerAction:(id)sender{
    
    [self.contentView resignFirstResponder];
    [self keyboardCancelChangeFrame];
    [self closeDatePicker];
    if (self.uploadImageData != nil) {
        self.photoActionSheet = [[[UIActionSheet alloc] initWithTitle:@"图片选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除照片", nil] autorelease];
        [self.photoActionSheet setTag:6];
    }else{
        self.photoActionSheet = [[[UIActionSheet alloc] initWithTitle:@"图片选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", @"拍照", nil] autorelease];
        [self.photoActionSheet setTag:5];
    }
    [self.photoActionSheet showInView:self.view];
}

#pragma mark - UIAction Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType = 0;
    if (actionSheet.tag == 5) {
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else if (buttonIndex == 1) {
            [MobClick event:@"mood_v2" label:@"拍照"];
            sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            return;
        }
    }else if (actionSheet.tag == 6) {
        if (buttonIndex == 0) {
            [MobClick event:@"mood_v2" label:@"从手机相册里选择"];
            self.uploadImageData = nil;
            [self.imageButton setImage:[UIImage imageNamed:@"createrecordaddpicture"] forState:UIControlStateNormal];
            return;
        }else{
            return;
        }
    }
    [self.imagePicker setSourceType:sourceType];
    self.imagePicker.allowsEditing = YES;
    self.currentContentString = self.contentView.text;
    [self presentViewController:self.imagePicker animated:YES completion:^{
        
    }];
    
}

- (void)saveImage:(UIImage *)image
{
    self.contentView.text = self.currentContentString;
    [self.imageButton setImage:nil forState:UIControlStateNormal];
    self.uploadImageData = UIImageJPEGRepresentation(image, 0.8);
    [self.imageButton setImage:image forState:UIControlStateNormal];
}

#pragma mark - Camera View Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    BBWaterMarkViewController *waterMarkView = [[[BBWaterMarkViewController alloc]initWithNibName:@"BBWaterMarkViewController" bundle:nil]autorelease];
    if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
    {
        //备孕状态不加水印，直接提交
        [self saveImage:image];
    }
    else
    {
        waterMarkView.imageView.image = image;
        waterMarkView.delegate = self;
        if([[[UIDevice currentDevice] systemVersion] floatValue]>5.0){
            [self.navigationController presentViewController:waterMarkView animated:YES completion:^{
            
        }];
        }else{
            [self.navigationController presentViewController:waterMarkView animated:YES completion:^{
                
            }];
        }
    }
   
}

- (void)getWaterMarkImage:(UIImage*)image
{
    [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.5];
}

#pragma mark - UINavigationController Delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(cameraBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [viewController.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    UIView *nilView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 32)]autorelease];
    UIBarButtonItem *nilBarButton = [[UIBarButtonItem alloc] initWithCustomView:nilView];
    [viewController.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:viewController.navigationItem.title]];
    [viewController.navigationItem setRightBarButtonItem:nilBarButton];
    [nilBarButton release];
    [viewController.navigationController setColorWithImageName:@"navigationBg"];
}

- (IBAction)cameraBackAction:(id)sender
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Custom Method

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}
#pragma mark - keyboard delegate

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    [MobClick event:@"mood_v2" label:@"输入框写心情点击"];
    if (IS_IPHONE5) {
        return;
    }
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (kbSize.height == 216) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.recordView  setFrame:CGRectMake(0, -44, 320, 300)];
        }];
    }
    else if(kbSize.height == 252){
        [UIView animateWithDuration:0.2 animations:^{
            [self.recordView  setFrame:CGRectMake(0, -74, 320, 300)];
        }];
    }
}

-(void)keyboardCancelChangeFrame{
    [UIView animateWithDuration:0.2 animations:^{
        [self.recordView  setFrame:CGRectMake(0, 0, 320, 300)];
    }];
}

-(IBAction)clickedCancelKeyboard:(id)sender
{
    [self.contentView resignFirstResponder];
    [self keyboardCancelChangeFrame];
    [self closeDatePicker];
}


#pragma mark - TextView Delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    if (range.location >= MAX_CONTENT_LENGTH){
//        return NO;
//    }else{
        return YES;
//    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSString *textContent = textView.text;
    int existTextNum = [textContent length];
    self.countLabel.text = [NSString stringWithFormat:@"还可以输入%d个字",MAX_CONTENT_LENGTH-existTextNum];
    self.recordContentCount = existTextNum;
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == BACK_ALERT_VIEW_TAG) {
        if (buttonIndex == 1) {
//            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

#pragma mark - 讯飞输入接口回调
#pragma mark IFlyRecognizerViewDelegate
/** 识别结果回调方法
 @param resultArray 结果列表
 @param isLast YES 表示最后一个，NO表示后面还有结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
    
    if ([result isNotEmpty])
    {
        if (!self.s_IFlyString)
        {
            self.s_IFlyString = [NSMutableString stringWithCapacity:0];
        }
        
        [self.s_IFlyString appendString:result];
        
    }
    
    if (isLast)
    {
        [self enableButton];
        [self.contentView becomeFirstResponder];
        if (self.s_IFlyString && self.recordContentCount < MAX_CONTENT_LENGTH)
        {
            [self.contentView insertText:self.s_IFlyString];
        }
        int existTextNum = [self.contentView.text  length];
        self.countLabel.text = [NSString stringWithFormat:@"还可以输入%d个字",MAX_CONTENT_LENGTH-existTextNum];
        self.recordContentCount = existTextNum;
        self.s_IFlyString = nil;
    }
    
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    NSLog(@"errorCode:%d", [error errorCode]);
    
    [self enableButton];
}


#pragma mark
#pragma mark 内部调用

// to disableButton,when the recognizer view display,the function will be called
// 当显示语音识别的view时，使其他的按钮不可用
- (void)disableButton
{
	self.contentView.editable = NO;
	self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

// to enable button,when you start recognizer,this function will be called
// 当语音识别view消失的时候，使其它按钮可用
- (void)enableButton
{
	self.contentView.editable = YES;
	self.navigationItem.leftBarButtonItem.enabled  = YES;
    self.navigationItem.rightBarButtonItem.enabled  = YES;
}

-(IBAction)xunfeiInput:(id)sender
{
    [MobClick event:@"mood_v2" label:@"语音点击"];
    [self.contentView resignFirstResponder];
    [self keyboardCancelChangeFrame];
    [self closeDatePicker];
    NSLog(@"%d",[self.contentView isFirstResponder]);
    if ([self.iflyRecognizerView start])
    {
        [self disableButton];
    }
}

@end
