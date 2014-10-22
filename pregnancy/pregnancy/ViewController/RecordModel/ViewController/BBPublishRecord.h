//
//  BBPublishRecord.h
//  pregnancy
//
//  Created by whl on 13-9-22.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordConfig.h"
#import "BBIflyMSC.h"

@interface BBPublishRecord : BaseViewController
<
    UITextViewDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    UIActionSheetDelegate,
    UIAlertViewDelegate,
    IFlyRecognizerViewDelegate,
    BBWaterMarkDelegate
>

//写记录的View
@property (nonatomic,strong) IBOutlet UIView *recordView;

@property (nonatomic,strong) IBOutlet UIView *dateView;


//记录选择日期
@property (nonatomic,strong) IBOutlet UIDatePicker *selectDate;

@property (nonatomic,strong) NSDate *recordDate;

//显示日期的Button
@property (nonatomic,strong) IBOutlet UIButton *dateButton;

//添加图片的Button
@property (nonatomic,strong) IBOutlet UIButton *imageButton;

//选择是否隐私
@property (nonatomic,strong) IBOutlet UIButton *statusButton;

//记录内容
@property (nonatomic,strong) IBOutlet BBPlaceholderTextView *contentView;

//计数的Label
@property (nonatomic,strong) IBOutlet UILabel *countLabel;

//私有状态的标记
@property (assign) BOOL isPrivate;

//图片的日记
@property (nonatomic,strong)  NSData *uploadImageData;

//图片选择
@property (nonatomic,strong) UIImagePickerController *imagePicker;

//选择图片方式
@property (nonatomic,strong) UIActionSheet *photoActionSheet;

//发表记录的请求
@property (nonatomic,strong) ASIFormDataRequest *recordRequest;

//加载状态
@property (nonatomic,strong) MBProgressHUD *loadProgress;

//是否在请求中
@property (assign) BOOL isRequestShow;

//临时保存当前输入内容
@property (nonatomic,strong) NSString *currentContentString;


//语音输入
-(IBAction)xunfeiInput:(id)sender;
@end
