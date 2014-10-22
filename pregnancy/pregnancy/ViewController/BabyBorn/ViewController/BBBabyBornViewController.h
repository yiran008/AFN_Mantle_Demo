//
//  BBBabyBornViewController.h
//  pregnancy
//
//  Created by yxy on 14-4-8.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCustomPickerView.h"
#import "BBPlaceholderTextView.h"
#import "BBBabyBornRequest.h"
#import "BBIflyMSC.h"

@interface BBBabyBornViewController : BaseViewController
<
    UITextFieldDelegate,
    UITextViewDelegate,
    UIActionSheetDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    IFlyRecognizerViewDelegate,
    BBCustomPickerViewDelegate,
    UIAlertViewDelegate
>

@property (nonatomic, strong) IBOutlet UIScrollView *mainScrollView;
// 提示
@property (nonatomic, strong) IBOutlet UILabel *tipsLabel;
// 帖子标题
@property (nonatomic, strong) IBOutlet UILabel *topicTitleLabel;
@property (nonatomic, strong) IBOutlet UITextField *topicTitleTF;
// 宝宝生日
@property (nonatomic, strong) IBOutlet UILabel *babyBrithdaySignLabel;
@property (nonatomic, strong) IBOutlet UILabel *babyBrithdayLabel;
// 宝宝性别
@property (nonatomic, strong) IBOutlet UILabel *babyGenderLabel;
@property (nonatomic, strong) IBOutlet UIButton *boyButton;
@property (nonatomic, strong) IBOutlet UIButton *girlButton;
// 宝宝体重
@property (nonatomic, strong) IBOutlet UILabel *babyWeightSignLabel;
@property (nonatomic, strong) IBOutlet UILabel *babyWeightLabel;
// 宝宝身长
@property (nonatomic, strong) IBOutlet UILabel *babyHeightSignLabel;
@property (nonatomic, strong) IBOutlet UILabel *babyHeightLabel;
// 帖子内容
@property (nonatomic, strong) IBOutlet UILabel *topicContentLabel;
@property (nonatomic, strong) IBOutlet BBPlaceholderTextView *topicContentView;
// 发送到同龄圈名称
@property (nonatomic, strong) IBOutlet UILabel *circleNameLabel;
@property (nonatomic, strong) IBOutlet UIButton *imageButton;

// 用户所在同龄圈
@property (nonatomic, strong) NSString *userCircle;
// 发表报喜贴
@property (nonatomic, strong) ASIFormDataRequest *babyBornRequest;
// 上传图片
@property (nonatomic, strong) ASIFormDataRequest *uploadImageRequest;
@end
