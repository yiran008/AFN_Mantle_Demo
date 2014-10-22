//
//  BBBabyBornViewController.m
//  pregnancy
//
//  Created by yxy on 14-4-8.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBBabyBornViewController.h"
#import "MBProgressHUD.h"
#import "HMCircleClass.h"
#import "HMShowPage.h"

#define kAlertReturnTag 10

@interface BBBabyBornViewController ()

// 选择宝宝生日蒙层
@property (nonatomic,strong) UIView *timeView;
@property (nonatomic,strong) UIDatePicker *datePickers;

// 宝宝身高 体重选择
@property (nonatomic,strong) BBCustomPickerView *weightPickerView;
@property (nonatomic,strong) BBCustomPickerView *heightPickerView;

// 宝宝身高 体重数据
@property (nonatomic,strong) NSMutableArray *babyWeightArray1;
@property (nonatomic,strong) NSMutableArray *babyWeightArray2;
@property (nonatomic,strong) NSMutableArray *babyHeightArray;

// 宝宝数据记录
@property (nonatomic,strong) NSString *firstColumn;
@property (nonatomic,strong) NSString *secondColumn;
@property (nonatomic,strong) NSString *topicTitle;
@property (nonatomic,strong) NSString *babyBrithday;
// 宝宝预产期
@property (nonatomic,strong) NSDate *babyDueDate;
@property (nonatomic,strong) NSString *babyGender;
@property (nonatomic,strong) NSString *babyWeight;
@property (nonatomic,strong) NSString *babyHeight;
@property (nonatomic,strong) NSString *topicContent;

// 上传照片
@property (nonatomic,strong) NSData *uploadImageData;
@property (nonatomic,assign) BOOL hasGetPicture;
@property (nonatomic,strong) UIActionSheet *photoActionSheet;
@property (nonatomic,strong) UIActionSheet *cameraActionSheet;
@property (nonatomic,strong) UIImagePickerController *imagePicker;

// 上次照片成功后返回的图片ID
@property (nonatomic,strong) NSString *imageID;

// 语音
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;
@property (nonatomic, strong) NSMutableString *s_IFlyString;
@property (nonatomic,assign) BOOL isInputFocusAtTitle;

// 提示
@property (nonatomic, strong) MBProgressHUD *topicProgress;

@end

@implementation BBBabyBornViewController

- (void)dealloc
{
    [_babyBornRequest clearDelegatesAndCancel];
    [_uploadImageRequest clearDelegatesAndCancel];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_iflyRecognizerView cancel];
    [IFlySpeechUtility destroy];
}


+(NSMutableArray*)readEmojPlist{
    static NSMutableArray *emojList = nil;
    if (emojList==nil) {
        emojList = [[NSMutableArray alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmojisList" ofType:@"plist"];
        //文件数据类型是*dictionary
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *natureEmoj= [dictionary arrayForKey:@"Nature"];
        NSArray *objectsEmoj= [dictionary arrayForKey:@"Objects"];
        NSArray *peopleEmoj= [dictionary arrayForKey:@"People"];
        NSArray *peoplesEmoj= [dictionary arrayForKey:@"People_5"];
        NSArray *placesEmoj= [dictionary arrayForKey:@"Places"];
        NSArray *symbplsEmoj= [dictionary arrayForKey:@"Symbols"];
        for (NSString *emojStr in natureEmoj) {
            [emojList addObject:emojStr];
        }
        for (NSString *emojStr in objectsEmoj) {
            [emojList addObject:emojStr];
        }
        for (NSString *emojStr in peopleEmoj) {
            [emojList addObject:emojStr];
        }
        for (NSString *emojStr in peoplesEmoj) {
            [emojList addObject:emojStr];
        }
        for (NSString *emojStr in placesEmoj) {
            [emojList addObject:emojStr];
        }
        for (NSString *emojStr in symbplsEmoj) {
            [emojList addObject:emojStr];
        }
    }
    return emojList;
}

+(BOOL)checkAllEmojState:(NSString *)content{
    if (content==nil) {
        return NO;
    }
    NSString *contentStr = [content copy];
    for (NSString *emojStr in [BBBabyBornViewController readEmojPlist]) {
        contentStr = [contentStr stringByReplacingOccurrencesOfString:emojStr withString:@""];
        if ([contentStr isEqualToString:@""]) {
            break;
        }
    }
    if ([contentStr isEqualToString:@""]) {
        return YES;
    }
    return NO;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self addObserver];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MobClick event:@"good_news_v2" label:@"发报喜贴页面pv"];
    [self.navigationItem setTitle:@"宝宝出生了"];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    [self addNavigationButton];
    [self setTextView];
    [self initBabyBornData];

    if(UI_SCREEN_HEIGHT == 480)
    {
        self.mainScrollView.height = 480;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            self.mainScrollView.top = 135;
        }
        else
        {
            self.mainScrollView.top = 155;
        }
        self.mainScrollView.contentSize = CGSizeMake(320, UI_SCREEN_HEIGHT + 88);
    }

    // 添加点击事件
    UITapGestureRecognizer *babyBrithdayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editBabyBrithday:)];
    [self.babyBrithdayLabel addGestureRecognizer:babyBrithdayTap];
    self.babyBrithdayLabel.userInteractionEnabled = YES;
    self.babyBrithdayLabel.exclusiveTouch = YES;
    
    UITapGestureRecognizer *babyWeightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editBabyWeight:)];
    [self.babyWeightLabel addGestureRecognizer:babyWeightTap];
    self.babyWeightLabel.userInteractionEnabled = YES;
    self.babyWeightLabel.exclusiveTouch = YES;
    
    UITapGestureRecognizer *babyHeightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editBabyHeight:)];
    [self.babyHeightLabel addGestureRecognizer:babyHeightTap];
    self.babyHeightLabel.userInteractionEnabled = YES;
    self.babyHeightLabel.exclusiveTouch = YES;

    
    self.boyButton.exclusiveTouch = YES;
    self.girlButton.exclusiveTouch = YES;
    self.imageButton.exclusiveTouch = YES;
 
    [self showKeyBoard];
    
    // 添加修改帖子内容
    [self modifyDefaultColor];
    [self initBabyBrithdayView];
    [self initBabyWeightView];
    [self initBabyHeightView];
    
    self.hasGetPicture = NO;
    
    if (self.uploadImageData != nil) {
        [self.imageButton setBackgroundImage:[UIImage imageWithData:self.uploadImageData] forState:UIControlStateNormal];
        self.hasGetPicture = YES;
    }
    
    self.topicProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.topicProgress];
    
	// init the RecognizeControl
    [BBIflyMSC firstInit];
    self.iflyRecognizerView = [BBIflyMSC CreateRecognizerView:self];
    self.s_IFlyString  = nil;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - create UI
- (void)addNavigationButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.exclusiveTouch = YES;
    [rightItemButton setFrame:CGRectMake(0, 0, 40, 30)];
    [rightItemButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(commitBabyBornTopicAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    [self.navigationItem setRightBarButtonItem:commitBarButton];
    
}


- (void)modifyDefaultColor
{
    self.tipsLabel.textColor = [UIColor colorWithHex:0xff537b];
    self.topicTitleLabel.textColor = [UIColor colorWithHex:0xaaaaaa];
    self.babyBrithdaySignLabel.textColor = [UIColor colorWithHex:0xaaaaaa];
    self.babyGenderLabel.textColor = [UIColor colorWithHex:0xaaaaaa];
    self.babyWeightSignLabel.textColor = [UIColor colorWithHex:0xaaaaaa];
    self.babyHeightSignLabel.textColor = [UIColor colorWithHex:0xaaaaaa];
    self.topicContentLabel.textColor = [UIColor colorWithHex:0xaaaaaa];
    
    self.topicTitleTF.textColor = [UIColor colorWithHex:0x666666];
    self.babyBrithdayLabel.textColor = [UIColor colorWithHex:0x666666];
    self.babyWeightLabel.textColor = [UIColor colorWithHex:0x666666];
    self.babyHeightLabel.textColor = [UIColor colorWithHex:0x666666];
    self.topicContentView.textColor = [UIColor colorWithHex:0x666666];
    
    // 宝宝性别设定
    [self.boyButton setImage:[UIImage imageNamed:@"baby_boy_dianji_icon"] forState:UIControlStateNormal];
    [self.girlButton setImage:[UIImage imageNamed:@"baby_girl_moren_icon"] forState:UIControlStateNormal];
    [self.boyButton setTitleColor:[UIColor colorWithHex:0x69b2fc] forState:UIControlStateNormal];
    [self.girlButton setTitleColor:[UIColor colorWithHex:0xaaaaaa] forState:UIControlStateNormal];
}

- (void)initBabyBornData
{
    // 宝宝身高体重预定义数据
    self.babyWeightArray1 = [[NSMutableArray alloc] init];
    self.babyWeightArray2 = [[NSMutableArray alloc] init];
    self.babyHeightArray = [[NSMutableArray alloc] init];
    for(int i=0; i<=30; i++)
    {
        NSString *babyWeight1 = [NSString stringWithFormat:@"%d斤",i];
        [self.babyWeightArray1 addObject:babyWeight1];
    }
    
    for(int i=0; i<=9; i++)
    {
        NSString *babyWeight2 = [NSString stringWithFormat:@"%d两",i];
        [self.babyWeightArray2 addObject:babyWeight2];
    }
    
    for(int i=20; i<=100; i++)
    {
        NSString *babyHeight = [NSString stringWithFormat:@"%dcm",i];
        [self.babyHeightArray addObject:babyHeight];
    }

    // 预定义数据
    self.firstColumn = @"6斤";
    self.secondColumn = @"5两";
    self.topicTitle = self.topicTitleTF.text;
    self.babyGender = @"王子";
    self.babyWeight = @"6斤5两";
    self.babyHeight = @"50cm";
}

- (void)setTextView
{
    self.topicContentView.placeholder = @"请输入内容（不少于5个字）";
    self.topicContentView.font = [UIFont systemFontOfSize:14];
    [self.topicContentView setPlaceholderTextColor:[UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1]];
}

// 格式化宝宝生日
- (NSString *)babyBrithdayWithFromat:(NSDateComponents *)components
{
    if(components.month<10&&components.day<10)
    {
        self.babyBrithday = [NSString stringWithFormat:@"%d0%d0%d",components.year,components.month,components.day];
    }
    else if(components.month<10 && components.day>=10)
    {
        self.babyBrithday = [NSString stringWithFormat:@"%d0%d%d",components.year,components.month,components.day];
    }
    else if (components.month>=10 && components.day<10)
    {
        self.babyBrithday = [NSString stringWithFormat:@"%d%d0%d",components.year,components.month,components.day];
    }
    else
    {
        self.babyBrithday = [NSString stringWithFormat:@"%d%d%d",components.year,components.month,components.day];
    }
    return self.babyBrithday;
}

- (void)initBabyBrithdayView
{
    // 宝宝生日选择显示
    self.timeView = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT-250, DEVICE_WIDTH, 250)];
    [self.timeView addSubview:[self customCompleteView]];
    self.timeView.alpha = 0.0f;
    [self.view addSubview:self.timeView];
    
    
    self.datePickers = [[UIDatePicker alloc] init];
    self.datePickers.frame = CGRectMake(0, 30, 320, 120);
    self.datePickers.backgroundColor = [UIColor whiteColor];
    self.datePickers.datePickerMode = UIDatePickerModeDate;
    // 设置日期可选范围
    self.datePickers.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
    self.datePickers.maximumDate = [NSDate date];
    
    NSDate *currentBirthday = self.datePickers.date;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:
                                    NSYearCalendarUnit|
                                    NSMonthCalendarUnit|
                                    NSDayCalendarUnit
                                          fromDate:currentBirthday];
    self.babyDueDate = currentBirthday;
    self.babyBrithday = [self babyBrithdayWithFromat:components];
    self.babyBrithdayLabel.text = [NSString stringWithFormat:@"%d-%d-%d",components.year,components.month,components.day];
    self.circleNameLabel.text = [NSString stringWithFormat:@"发布到 %d年%d月同龄圈",components.year,components.month];
    [self.datePickers addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [self.timeView addSubview:self.datePickers];
}

- (void)initBabyWeightView
{
    self.weightPickerView = [[BBCustomPickerView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT-250, DEVICE_WIDTH, 250)];
    self.weightPickerView.numberOfComponent = 2;
    self.weightPickerView.firstColumnArray = self.babyWeightArray1;
    self.weightPickerView.secondColumnArray = self.babyWeightArray2;
    self.weightPickerView.delegate = self;
    [self.weightPickerView selectRow:6 inComponent:0 animated:NO];
    [self.weightPickerView selectRow:5 inComponent:1 animated:NO];
    [self.weightPickerView addSubview:[self customCompleteView]];
    self.weightPickerView.alpha = 0.0f;
    [self.view addSubview:self.weightPickerView];
}

- (void)initBabyHeightView
{
    self.heightPickerView = [[BBCustomPickerView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT-250, DEVICE_WIDTH, 250)];
    self.heightPickerView.numberOfComponent = 1;
    self.heightPickerView.firstColumnArray = self.babyHeightArray;
    self.heightPickerView.delegate = self;
    [self.heightPickerView selectRow:30 inComponent:0 animated:NO];
    [self.heightPickerView addSubview:[self customCompleteView]];
    self.heightPickerView.alpha = 0.0f;
    [self.view addSubview:self.heightPickerView];
}


#pragma mark - IBout Action

- (IBAction)backAction:(UIButton *)button
{
    // 如果未发报喜贴返回，提示是否确认离开
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您还有未发布的内容，是否返回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = kAlertReturnTag;
    [alertView show];
}

// 选择宝宝性别
- (IBAction)chooseBabyGenderBoy:(id)sender
{
    self.babyGender = @"王子";
    [self.boyButton setImage:[UIImage imageNamed:@"baby_boy_dianji_icon"] forState:UIControlStateNormal];
    [self.girlButton setImage:[UIImage imageNamed:@"baby_girl_moren_icon"] forState:UIControlStateNormal];
    
    [self.boyButton setTitleColor:[UIColor colorWithHex:0x69b2fc] forState:UIControlStateNormal];
    [self.girlButton setTitleColor:[UIColor colorWithHex:0xaaaaaa] forState:UIControlStateNormal];
    
}


- (IBAction)chooseBabyGenderGril:(id)sender
{
    self.babyGender = @"公主";
    [self.girlButton setImage:[UIImage imageNamed:@"baby_girl_dianji_icon"] forState:UIControlStateNormal];
    [self.boyButton setImage:[UIImage imageNamed:@"baby_boy_moren_icon"] forState:UIControlStateNormal];
    
    [self.girlButton setTitleColor:[UIColor colorWithHex:0xff537b] forState:UIControlStateNormal];
    [self.boyButton setTitleColor:[UIColor colorWithHex:0xaaaaaa] forState:UIControlStateNormal];
}


// 选择发送照片
- (IBAction)addCameraAction:(id)sender
{
    if (self.hasGetPicture) {
        self.photoActionSheet = [[UIActionSheet alloc] initWithTitle:@"图片选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"清除照片", nil];
        [self.photoActionSheet showInView:self.view];
    }else {
        //        [BBStatisticsUtil setEvent:@"communicate_createTopicToCamera"];
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker = [[UIImagePickerController alloc] init];
            [self.imagePicker setDelegate:self];
            [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:self.imagePicker animated:YES completion:^{
                
            }];
        } else {
            self.cameraActionSheet = [[UIActionSheet alloc] initWithTitle:@"图片选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", @"拍照", nil];
            [self.cameraActionSheet showInView:self.view];
        }
    }
    
}

- (void)showReminderWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}


// 提交帖子
- (void)commitBabyBornTopicAction:(UIButton *)button
{
    self.topicContent = [self.topicContentView.text trim];
    self.topicTitle = [self.topicTitleTF.text trim];
    
    if(![self.topicTitle isNotEmpty])
    {
        [self showReminderWithMessage:@"请输入帖子标题"];
        return;
    }
    
    if (![self.topicContent isNotEmpty])
    {
        [self showReminderWithMessage:@"内容不能为空"];
        return;
    }
    
    if ([self.topicContent length] < 5)
    {
        [self showReminderWithMessage:@"内容不能少于5个字"];
        return;
        
    }
    
    
    if ([BBBabyBornViewController checkAllEmojState:self.topicTitle]) {
        [self showReminderWithMessage:@"标题不能为纯表情"];
        return;
    }
    
    if(![self.babyBrithday isNotEmpty])
    {
        [self showReminderWithMessage:@"请选择宝宝生日"];
        return;
    }
    
    if(![self.babyGender isNotEmpty])
    {
        [self showReminderWithMessage:@"请选择宝宝性别"];
        return;
    }
    
    if(![self.babyWeight isNotEmpty])
    {
        [self showReminderWithMessage:@"请输入宝宝体重"];
        return;
    }
    
    if(![self.babyHeight isNotEmpty])
    {
        [self showReminderWithMessage:@"请输入宝宝身长"];
        return;
    }
    
    [self publicTopic];
    
}

#pragma mark - Private Method
// 修改宝宝生日
- (void)editBabyBrithday:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.5 animations:^{
        self.mainScrollView.contentOffset = CGPointMake(0, 50);
    }completion:^(BOOL finished){
        
    }];
    
    [self.topicTitleTF resignFirstResponder];
    [self.topicContentView resignFirstResponder];
    self.weightPickerView.alpha = 0.0f;
    self.heightPickerView.alpha = 0.0f;
    
    if(self.timeView.alpha == 0.0){
        self.timeView.alpha = 1.0f;
    }
    
}


// 修改宝宝体重
- (void)editBabyWeight:(UITapGestureRecognizer *)tap
{
    self.timeView.alpha = 0.0f;
    self.heightPickerView.alpha = 0.0f;
    [self.topicTitleTF resignFirstResponder];
    [self.topicContentView resignFirstResponder];
    
    if(self.weightPickerView.alpha == 0.0f)
    {
        self.weightPickerView.alpha = 1.0f;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
         self.mainScrollView.contentOffset = CGPointMake(0, 90);
    }completion:^(BOOL finished){
        
    }];
    
}

// 修改宝宝身长
- (void)editBabyHeight:(UITapGestureRecognizer *)tap
{
    self.timeView.alpha = 0.0f;
    self.weightPickerView.alpha = 0.0f;
    [self.topicTitleTF resignFirstResponder];
    [self.topicContentView resignFirstResponder];
    
    if(self.heightPickerView.alpha == 0.0f)
    {
        self.heightPickerView.alpha = 1.0f;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
         self.mainScrollView.contentOffset = CGPointMake(0, 90);
    }completion:^(BOOL finished){
        
    }];
}


- (void)publicTopic
{
    // 隐藏键盘
    [self dismissKeyBoard];
    [self dismissPicker];
    
    [self.topicProgress setLabelText:@"正在发送"];
    [self.topicProgress show:YES];
    NSString *contentString = [self.topicContent parameterEmojis];
    
    if(self.uploadImageData != nil)
    {
        [self.uploadImageRequest clearDelegatesAndCancel];
        self.uploadImageRequest = [BBBabyBornRequest uploadPhoto:self.uploadImageData withLoginString:[BBUser getLoginString]];
        self.uploadImageRequest.delegate = self;
        [self.uploadImageRequest setDidFinishSelector:@selector(uploadImageFinish:)];
        [self.uploadImageRequest setDidFailSelector:@selector(uploadImageFail:)];
        [self.uploadImageRequest startAsynchronous];
    }
    else
    {
        [self.babyBornRequest clearDelegatesAndCancel];
        self.babyBornRequest = [BBBabyBornRequest babyBornTopicWithBrithday:self.babyBrithday babyWeight:self.babyWeight babyHeight:self.babyHeight babySex:self.babyGender topicTitle:self.topicTitle topicContent:contentString phtotoID:nil];
        self.babyBornRequest.delegate = self;
        [self.babyBornRequest setDidFinishSelector:@selector(commitBabyBornTopicFinish:)];
        [self.babyBornRequest setDidFailSelector:@selector(commitBabyBornTopicFail:)];
        [self.babyBornRequest startAsynchronous];
    }
    
}



// 保存照片
- (void)saveImage:(UIImage *)image
{
    self.hasGetPicture = YES;
    [self.imageButton setImage:nil forState:UIControlStateNormal];
    UIImage *uplodeImage = [BBImageScale scaleAndRotateImage:image];
    self.uploadImageData = UIImageJPEGRepresentation(uplodeImage, 0.5);
    [self.imageButton setImage:uplodeImage forState:UIControlStateNormal];
}


- (void)babyBornFinish
{
    BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.m_bobyBornFinish = YES;
    // 感动页显示
    [BBUser setNeedShowMovedPage:1];
    if([self.imageID isNotEmpty])
    {
        // 保存报喜贴上传图片id
        [BBUser setMovedPagePhotoID:self.imageID];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton setTag:[navigationController.viewControllers count]];
    [backButton addTarget:self action:@selector(cameraBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [viewController.navigationItem setLeftBarButtonItem:backBarButton];
    
    UIView *nilView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 32)];
    UIBarButtonItem *nilBarButton = [[UIBarButtonItem alloc] initWithCustomView:nilView];
    [viewController.navigationItem setRightBarButtonItem:nilBarButton];
    [viewController.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:viewController.navigationItem.title]];
    [viewController.navigationController setPregnancyColor];//设置导航栏颜色
    
}

- (void)cameraBackAction:(id)sender
{
    UIButton *btn = sender;
    if (btn.tag == 1)
    {
        [self.imagePicker dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }
    else
    {
        [self.imagePicker popViewControllerAnimated:YES];
        
    }
}


#pragma mark - Keyboard/Picker Show and Disappear
- (void)showKeyBoard
{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -1, 320, 30)];
    view.backgroundColor = [UIColor whiteColor];
    [topView addSubview:view];
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *flyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flyBtn.exclusiveTouch = YES;
    flyBtn.frame = CGRectMake(270, 2, 26, 26);
    [flyBtn setImage:[UIImage imageNamed:@"xunfei1"] forState:UIControlStateNormal];
    [flyBtn addTarget:self action:@selector(xunfeiInput:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *flyButton = [[UIBarButtonItem alloc] initWithCustomView:flyBtn];

    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.exclusiveTouch = YES;
    doneBtn.frame = CGRectMake(296, 2, 26, 26);
    [doneBtn setImage:[UIImage imageNamed:@"baby_cross"] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];

    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,flyButton, doneButton,nil];
    [topView setItems:buttonsArray];
    
    [self.topicTitleTF setInputAccessoryView:topView];
    [self.topicContentView setInputAccessoryView:topView];
}


-(void)dismissKeyBoard
{
    [self.topicTitleTF resignFirstResponder];
    [self.topicContentView resignFirstResponder];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // 取消其他第一响应者
    self.timeView.alpha = 0.0f;
    self.weightPickerView.alpha = 0.0f;
    self.heightPickerView.alpha = 0.0f;
    if([self.topicTitleTF isFirstResponder])
    {
        [self.topicContentView resignFirstResponder];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.mainScrollView.contentOffset = CGPointMake(0, 50);
        }completion:^(BOOL finished){
            
        }];
    }
    if([self.topicContentView isFirstResponder])
    {
        [self.topicTitleTF resignFirstResponder];
        [UIView animateWithDuration:0.5 animations:^{
            if(UI_SCREEN_HEIGHT == 480)
            {
                self.mainScrollView.contentOffset = CGPointMake(0, 268);
            }
            else
            {
                self.mainScrollView.contentOffset = CGPointMake(0, 180);
            }
        }completion:^(BOOL finished){
            
        }];
    }
    
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5 animations:^{
        self.mainScrollView.contentOffset = CGPointMake(0, 0);
    }completion:^(BOOL finished){
        
    }];
}

- (UIView *)customCompleteView
{
    UIView *doneview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    doneview.backgroundColor = [UIColor grayColor];
    
    UIButton *birthdayDone = [UIButton buttonWithType:UIButtonTypeCustom];
    birthdayDone.exclusiveTouch = YES;
    birthdayDone.frame = CGRectMake(270,3, 40, 25);
    [birthdayDone setTitle:@"完成" forState:UIControlStateNormal];
    [birthdayDone addTarget:self action:@selector(dismissPicker) forControlEvents:UIControlEventTouchUpInside];
    [doneview addSubview:birthdayDone];
    
    return doneview;
}


- (void)dismissPicker
{
    [UIView animateWithDuration:0.5 animations:^{
        self.timeView.alpha = 0;
        self.weightPickerView.alpha = 0.0f;
        self.heightPickerView.alpha = 0.0f;
        self.mainScrollView.contentOffset = CGPointMake(0, 0);
    }completion:^(BOOL finished){
    }];
}

#pragma mark -

#pragma mark - ASIHttp Request Delegate
- (void)commitBabyBornTopicFinish:(ASIFormDataRequest *)request
{
    [self.topicProgress hide:YES];
    
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *dictData = [parser objectWithString:responseString error:&error];
    
    if ([[dictData objectForKey:@"status"] isEqualToString:@"success"])
    {
        [MobClick event:@"good_news_v2" label:@"成功发送报喜贴数量"];
        [self.topicProgress show:NO withText:@"发帖成功" delay:0.2f];
        
        NSDictionary *data = [dictData objectForKey:@"data"];
        // 圈子id
        NSString *group_id = [data objectForKey:@"group_id"];
       // 成功后需要跳转到同龄圈帖子列表中
        [HMShowPage showCircleTopic:self circleId:group_id];
        
        // 发表报喜贴成功,感动页显示，育儿提醒
        [self babyBornFinish];
        
        // 存储宝宝生日
        [BBPregnancyInfo setPregnancyTimeWithDueDate:self.babyDueDate];
        // 设置用户身份
        [BBUser setNewUserRoleState:BBUserRoleStateHasBaby];
    }
    else if([[dictData objectForKey:@"status"] isEqualToString:@"group_id_or_baby_birthday_should_has_one"])
    {
        [self showReminderWithMessage:@"未知圈子"];
    }
    else if([[dictData objectForKey:@"status"] isEqualToString:@"content_or_photo_should_has_one"])
    {
        [self showReminderWithMessage:@"没有提交任何内容"];
    }
    else if([[dictData objectForKey:@"status"] isEqualToString:@"content_all_emoji"])
    {
        [self showReminderWithMessage:@"内容不允许为纯表情"];
    }
    else if ([[dictData objectForKey:@"status"] isEqualToString:@"nonexistent_age_group"])
    {
        [self showReminderWithMessage:@"同龄圈日期错误"];
    }
    else if ([[dictData objectForKey:@"status"] isEqualToString:@"no_posting"])
    {
        [self showReminderWithMessage:@"禁止发帖"];
    }
    else if ([[dictData objectForKey:@"status"] isEqualToString:@"too_mush_post"])
    {
        [self showReminderWithMessage:@"发帖次数超过限制"];
    }
    else if ([[dictData objectForKey:@"status"] isEqualToString:@"similar_error"])
    {
        [self showReminderWithMessage:@"内容重复"];
    }
    else if ([[dictData objectForKey:@"status"] isEqualToString:@"nonLogin"])
    {
        [self showReminderWithMessage:@"请先登录"];
    }
    else if ([[dictData objectForKey:@"status"] isEqualToString:@"suspended"])
    {
        [self showReminderWithMessage:@"啊呀呀，你被禁足啦，请联系管管~"];
    }
    else if([[dictData objectForKey:@"status"] isEqualToString:@"blockedUser"])
    {
        [self showReminderWithMessage:@"啊呀呀，你被禁足啦，请联系管管~"];
    }
    else
    {
        if([[dictData objectForKey:@"message"] isNotEmpty])
        {
          [self showReminderWithMessage:[dictData objectForKey:@"message"]];
        }
        else
        {
            [self showReminderWithMessage:@"发帖失败"];
        }
    }

}

- (void)commitBabyBornTopicFail:(ASIFormDataRequest *)request
{
    [self.topicProgress hide:YES];
    
    [self showReminderWithMessage:@"亲，你的网络不给力"];
}


- (void)uploadImageFinish:(ASIFormDataRequest *)request
{
    [self.topicProgress hide:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *dictData = [parser objectWithString:responseString error:&error];
   
    if ([[dictData stringForKey:@"status"] isEqualToString:@"success"])
    {
        NSArray *photoList = [[dictData objectForKey:@"data"] arrayForKey:@"photo_list"];
        self.imageID = [[photoList objectAtIndex:0] stringForKey:@"photo_id"];
        
        // 图片上传成功后，发表报喜帖
        NSString *contentString = [self.topicContent parameterEmojis];
        
        [self.babyBornRequest clearDelegatesAndCancel];
        self.babyBornRequest = [BBBabyBornRequest babyBornTopicWithBrithday:self.babyBrithday babyWeight:self.babyWeight babyHeight:self.babyHeight babySex:self.babyGender topicTitle:self.topicTitle topicContent:contentString phtotoID:self.imageID];
        self.babyBornRequest.delegate = self;
        [self.babyBornRequest setDidFinishSelector:@selector(commitBabyBornTopicFinish:)];
        [self.babyBornRequest setDidFailSelector:@selector(commitBabyBornTopicFail:)];
        [self.babyBornRequest startAsynchronous];
    }
    else if ([[dictData stringForKey:@"message"] isNotEmpty])
    {
        [self showReminderWithMessage:[dictData stringForKey:@"message"]];
    }
}

- (void)uploadImageFail:(ASIFormDataRequest *)request
{
    [self.topicProgress hide:YES];
    [self showReminderWithMessage:@"亲，你的网络不给力"];
}


#pragma mark - TextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}


#pragma mark  - UIDatePicker Delegate
- (void)dateChange:(UIDatePicker *)datePicker
{
    NSDate *currentBirthday = datePicker.date;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:
                                    NSYearCalendarUnit|
                                    NSMonthCalendarUnit|
                                    NSDayCalendarUnit
                                          fromDate:currentBirthday];
    self.babyDueDate = currentBirthday;
    self.babyBrithday = [self babyBrithdayWithFromat:components];
    self.babyBrithdayLabel.text = [NSString stringWithFormat:@"%d-%d-%d",components.year,components.month,components.day];
    self.circleNameLabel.text = [NSString stringWithFormat:@"发布到 %d年%d月同龄圈",components.year,components.month];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.photoActionSheet) {
        if (buttonIndex == 0) {
            self.hasGetPicture = NO;
            self.uploadImageData = nil;
            [self.imageButton setImage:[UIImage imageNamed:@"baby_add_photo_btn"] forState:UIControlStateNormal];
        }
        return;
    } else if (actionSheet == self.cameraActionSheet) {
        UIImagePickerControllerSourceType sourceType = 0;
        if (buttonIndex == 0) {
            [self.topicContentView resignFirstResponder];
            [self.topicTitleTF resignFirstResponder];
            [self.imageButton setImage:nil forState:UIControlStateNormal];
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else if (buttonIndex == 1) {
            [self.topicContentView resignFirstResponder];
            [self.topicTitleTF resignFirstResponder];
            sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            return;
        }
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        [self.imagePicker setDelegate:self];
        [self.imagePicker setAllowsEditing:NO];
        [self.imagePicker setSourceType:sourceType];
        [self presentViewController:self.imagePicker animated:YES completion:^{
            
        }];
    }
}



#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == kAlertReturnTag)
    {
        if(self.presentingViewController)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.5];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - BBCustomPickerView Delegate
- (void)BBCustomPickerView:(BBCustomPickerView *)pickerView withChecked:(NSString *)checked inComponent:(NSInteger)component
{
    if(component == 0)
    {
        self.firstColumn = checked;
    }
    else
    {
        self.secondColumn = checked;
    }
    
    if([pickerView isEqual:self.weightPickerView])
    {
        self.babyWeight = [NSString stringWithFormat:@"%@%@",self.firstColumn,self.secondColumn];
        self.babyWeightLabel.text = self.babyWeight;
    }
    else
    {
        self.babyHeight = self.firstColumn;
        self.babyHeightLabel.text = self.babyHeight;
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
    NSMutableString *result = [[NSMutableString alloc] init];
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
        if(self.isInputFocusAtTitle)
        {
            [self.topicTitleTF becomeFirstResponder];
            if (self.s_IFlyString)
            {
                [self.topicTitleTF insertText:self.s_IFlyString];
            }
        }
        else
        {
            [self.topicContentView becomeFirstResponder];
            if (self.s_IFlyString)
            {
                [self.topicContentView insertText:self.s_IFlyString];
            }
        }

        self.s_IFlyString = nil;
        [self enableButton];
    }

}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    NSLog(@"errorCode:%d", [error errorCode]);
    
    self.s_IFlyString = nil;
    [self enableButton];
}

#pragma mark
#pragma mark 内部调用

// to disableButton,when the recognizer view display,the function will be called
// 当显示语音识别的view时，使其他的按钮不可用
- (void)disableButton
{
	self.topicContentView.editable = NO;
    self.topicTitleTF.enabled = NO;
    
	self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

// to enable button,when you start recognizer,this function will be called
// 当语音识别view消失的时候，使其它按钮可用
- (void)enableButton
{
    self.topicContentView.editable = YES;
    self.topicTitleTF.enabled = YES;
	self.navigationItem.leftBarButtonItem.enabled  = YES;
    self.navigationItem.rightBarButtonItem.enabled  = YES;
}


// 讯飞录音
- (void)xunfeiInput:(id)sender
{
    NSLog(@"%d",[self.topicTitleTF isFirstResponder]);
    NSLog(@"%d",[self.topicContentView isFirstResponder]);
    if([self.topicTitleTF isFirstResponder]){
        self.isInputFocusAtTitle = YES;
    }else{
        self.isInputFocusAtTitle = NO;
    }
    
    if ([self.iflyRecognizerView start])
    {
        [self.topicContentView resignFirstResponder];
        [self.topicTitleTF resignFirstResponder];
        [self disableButton];
    }
}

@end
