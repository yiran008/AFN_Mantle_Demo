//
//  HMCreateTopicViewController.m
//  lama
//
//  Created by Heyanyang on 14-1-8.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMCreateTopicViewController.h"
#import "BBAppDelegate.h"
#import "BBImageScale.h"
#import "BBUser.h"
#import "HMNavigation.h"
//#import "HMShadeGuideControl.h"
#import "UMSocial.h"
#import "HMShowPage.h"
#import "UINavigationController+BackgroundColor.h"
#import "MBProgressHUD.h"

#define CHECK_EMOJI         0
#define CHECK_EMOJI_STEP1   0
#define CHECK_EMOJI_STEP2   0

#define TAG_ALERT_START     120
#define TAG_ACTION_START    150

#define TAG_BUTTON_EMOJI        150
#define TAG_BUTTON_KEYBOARD     151
#define TAG_BUTTON_CAMERA       152
#define TAG_BUTTON_PICKPHOTO    153
#define TAG_BUTTON_VOICE        154
#define TAG_BUTTON_CLOSE        160

#define TOPIC_TEXTVIEW_GAP      6

@interface HMCreateTopicViewController ()
{
    float _lineH;
    BOOL _textViewDidChangeing;
#if CHECK_EMOJI
    NSMutableArray *emojiArray;
#endif
    UIView *s_FirstResponderView;
}

@property(assign) BOOL isXUFEITextView;
@property (retain, nonatomic) MBProgressHUD * remindHud;
@property (retain, nonatomic) UIImageView *lineImage;

@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;
@property (nonatomic, strong) NSMutableString *s_IFlyString;



@end

@implementation HMCreateTopicViewController

@synthesize delegate;

@synthesize m_ScrollView;

//@synthesize m_CircleLabel;

@synthesize m_TopicTitleTextField;

@synthesize m_InputBgImageView;

@synthesize m_BottomView;

@synthesize m_HelpMarkBtn;
@synthesize m_HelpLabel;

@synthesize m_ShareLabel;
//@synthesize m_ShareQQZoneBtn;
@synthesize m_ShareSinaBtn;
@synthesize m_ShareTencentBtn;

@synthesize m_ToolBarView;
@synthesize m_EmojiBtn;
@synthesize m_KeyBoardBtn;
@synthesize m_YuyinBtn;
@synthesize m_CameraBtn;
@synthesize m_PhotoBtn;
@synthesize m_CloseBtn;
@synthesize imagePicker;
@synthesize manyImagesPickerNav;
@synthesize m_iFlyString;
@synthesize m_CircleInfo;
@synthesize m_DraftBoxData;

@synthesize m_IsModify;

@synthesize m_Request;


- (void)dealloc
{
    if (s_ActionSheet)
    {
        s_ActionSheet.delegate = nil;
    }
    
    [m_Request clearDelegatesAndCancel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isXUFEITextView = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.umeng_VCname = @"新建帖子页面";
    
    self.remindHud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.remindHud];
    
    [self setNavBar:@"发布新帖" bgColor:nil leftTitle:nil leftBtnImage:@"backButton" leftToucheEvent:@selector(leftAction:) rightTitle:@"发布" rightBtnImage:nil rightToucheEvent:@selector(rightAction:)];
    if (self.m_IsCustomCreateTopic)
    {
        [self setNavTitle:self.title];
    }
    
    if (m_DraftBoxData == nil)
    {
        self.m_DraftBoxData = [[HMDraftBoxData alloc] init];
        m_DraftBoxData.m_UserId = [BBUser getEncId];
        m_DraftBoxData.m_Group_id = m_CircleInfo.circleId;
        m_DraftBoxData.m_GroupName = m_CircleInfo.circleTitle;
        
        m_DraftBoxData.m_IsReply = NO;
        self.m_IsModify = NO;
        s_HadModified = NO;
    }
    
    m_EmojiBtn.enabled = NO;
    m_KeyBoardBtn.enabled = NO;
    m_YuyinBtn.enabled = NO;

    m_HelpMarkBtn.exclusiveTouch = YES;
//    m_ShareQQZoneBtn.exclusiveTouch = YES;
    m_ShareSinaBtn.exclusiveTouch = YES;
    m_ShareTencentBtn.exclusiveTouch = YES;

    m_EmojiBtn.exclusiveTouch = YES;
    m_KeyBoardBtn.exclusiveTouch = YES;
    m_YuyinBtn.exclusiveTouch = YES;
    m_CameraBtn.exclusiveTouch = YES;
    m_PhotoBtn.exclusiveTouch = YES;
    m_CloseBtn.exclusiveTouch = YES;

    
    self.view.backgroundColor = UI_VIEW_BGCOLOR;
    self.m_TopicTitleView.backgroundColor = [UIColor whiteColor];
    m_ScrollView.delegate = self;
    m_ScrollView.height = UI_MAINSCREEN_HEIGHT;

    m_TopicTitleTextField.textColor = [UIColor colorWithHex:0x111111];
    m_TopicTitleTextField.text = m_DraftBoxData.m_Title;

    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:m_TopicTitleTextField.placeholder];
    [mutaString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorWithHex:0x999999]
                       range:NSMakeRange(0, m_TopicTitleTextField.placeholder.length)];
    m_TopicTitleTextField.attributedPlaceholder = mutaString;
    m_TopicTitleTextField.exclusiveTouch = YES;
    
    if (self.m_IsCustomCreateTopic)
    {
        m_TopicTitleTextField.text = self.topicTitle;
        m_DraftBoxData.m_Title = m_TopicTitleTextField.text;
        m_TopicTitleTextField.userInteractionEnabled = NO;
    }

    //UIImage *image =[UIImage imageNamed:@""];
    //m_InputBgImageView.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    
    s_PlaceHolderTextView = [[BBPlaceholderTextView alloc] initWithFrame:CGRectMake(6, 0, UI_SCREEN_WIDTH-TOPIC_TEXTVIEW_GAP*2, MAXFLOAT)];
    s_PlaceHolderTextView.delegate = self;
    s_PlaceHolderTextView.bounces = NO;
    s_PlaceHolderTextView.backgroundColor = [UIColor clearColor];
    s_PlaceHolderTextView.exclusiveTouch = YES;
    [m_InputBgImageView addSubview:s_PlaceHolderTextView];
    
    s_PlaceHolderTextView.font = [UIFont systemFontOfSize:14.0f];
    s_PlaceHolderTextView.placeholderTextColor = [UIColor colorWithHex:0x999999];
    s_PlaceHolderTextView.textColor = [UIColor colorWithHex:0x666666];
    if (self.m_IsCustomCreateTopic)
    {
        s_PlaceHolderTextView.placeholder = self.tip;
    }
    else
    {
        s_PlaceHolderTextView.placeholder = @"输入正文（不少于5个字）";
    }
    s_PlaceHolderTextView.scrollEnabled = NO;//是否可以拖动
    //s_PlaceHolderTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    //s_PlaceHolderTextView.text = @"AAA";
    [s_PlaceHolderTextView sizeToFit];
    s_PlaceHolderTextView.width = UI_SCREEN_WIDTH-TOPIC_TEXTVIEW_GAP*2;
    //NSLog(@"%@", NSStringFromCGRect(s_PlaceHolderTextView.frame));
    _lineH = s_PlaceHolderTextView.height;
    s_PlaceHolderTextView.text = m_DraftBoxData.m_Content;
    s_PlaceHolderTextView.height = 96;
//    [s_PlaceHolderTextView sizeToFit];
    s_PlaceHolderTextView.width = UI_SCREEN_WIDTH-TOPIC_TEXTVIEW_GAP*2;
    CGFloat h = s_PlaceHolderTextView.height > _lineH ? s_PlaceHolderTextView.height : _lineH;
    m_InputBgImageView.frame = CGRectMake(0, 37, UI_SCREEN_WIDTH, h);
    m_InputBgImageView.backgroundColor = [UIColor whiteColor];
    
    s_ImageWallView = [[HMImageWallView alloc] initWithFrame:CGRectMake(6, m_InputBgImageView.bottom+8, UI_SCREEN_WIDTH-12, 100)];
    s_ImageWallView.backgroundColor = [UIColor clearColor];
    s_ImageWallView.delegate = self;
    
    self.lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topiccell_line"]];
    self.lineImage.top = m_InputBgImageView.frame.size.height;
    [m_InputBgImageView addSubview:self.lineImage];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (HMDraftBoxPic *boxPic in m_DraftBoxData.m_PicArray)
    {
        [array addObject:boxPic.m_Photo_data];
    }
    
    [s_ImageWallView drawWithArray:array];
    
    [m_ScrollView addSubview:s_ImageWallView];
    
#if (USE_IFlyRecognize)
    // 语音
    [BBIflyMSC firstInit];
    self.iflyRecognizerView = [BBIflyMSC CreateRecognizerView:self];
    self.s_IFlyString  = nil;
    s_FirstResponderView = nil;
    
    m_YuyinBtn.hidden = NO;
#else
    m_YuyinBtn.hidden = YES;
#endif
    
//     UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
//     //[panRecognizer setDelegate:self];
//     [self.m_ScrollView addGestureRecognizer:panRecognizer];
//     [panRecognizer release];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapRecognizer.cancelsTouchesInView = YES;
    [self.m_ScrollView addGestureRecognizer:tapRecognizer];

    //m_ToolBarView.backgroundColor = [UIColor whiteColor];
    //m_ToolBarView.backgroundColor = [UIColor flatGrayColor];
    m_ToolBarView.top = UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT;
    m_ToolBarView.backgroundColor = [UIColor colorWithHex:0xF4F4F4];
    
    [self setScrollViewContentSize];
    
//    m_CircleLabel.textColor = [UIColor colorWithHex:0x999999];
    m_HelpLabel.textColor = [UIColor colorWithHex:0x999999];
    m_ShareLabel.textColor = [UIColor colorWithHex:0x999999];
    
//    if ([m_CircleInfo.circleTitle isNotEmpty])
//    {
//        m_CircleLabel.hidden = NO;
//        m_CircleLabel.text = [NSString stringWithFormat:@"发布到 %@", m_CircleInfo.circleTitle];
//    }
//    else
//    {
//        m_CircleLabel.hidden = YES;
//    }

    [self freshHelpTagBtn];
    
    [self freshShareBtn];
   
    if(self.m_IsCustomCreateTopic)
    {
        [self hideHelpAndShareArea];
    }

    
#if CHECK_EMOJI
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emoji"
                                                          ofType:@"plist"];
    //输入写入
    emojiArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];

    if ([emojiArray isNotEmpty])
    {
        //获取应用程序沙盒的Documents目录
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        NSString *plistPath1 = [paths objectAtIndex:0];

        //得到完整的文件名
        NSString *filename = nil;

#if CHECK_EMOJI_STEP1

        // step 1
        filename = [plistPath1 stringByAppendingPathComponent:@"emoji.plist"];

        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:filename error:nil];

#elif CHECK_EMOJI_STEP2

        // step 2
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:emojiArray.count];
        for (NSDictionary *dic in emojiArray)
        {
            [array addObject:[dic stringForKey:@"unicode"]];
        }
        filename = [plistPath1 stringByAppendingPathComponent:@"array.plist"];
        [array writeToFile:filename atomically:YES];

        NSMutableArray *intArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSInteger startInt = 0;
        NSInteger endInt = 0;
        NSString *start;
        NSString *end;
        for (NSString *str in array)
        {
            NSInteger strInt = strtoul([str UTF8String], 0, 16);

            if (startInt == 0 && startInt != strInt)
            {
                startInt = strInt;
                start = str;
                endInt = strInt;
                end = str;
            }
            else if (strInt == endInt+1)
            {
                endInt = strInt;
                end = str;
            }
            else if (strInt != endInt+1)
            {
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:start, @"start", end, @"end", nil];
                [intArray addObject:dic];

                startInt = strInt;
                start = str;
                endInt = strInt;
                end = str;
            }
        }

        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:start, @"start", end, @"end", nil];
        [intArray addObject:dic];

        filename = [plistPath1 stringByAppendingPathComponent:@"intarray.plist"];
        [intArray writeToFile:filename atomically:YES];

        NSMutableString *codeStr = [[NSMutableString alloc] init];
        for (NSDictionary *dic in intArray)
        {
            NSString *start = [dic objectForKey:@"start"];
            NSString *end = [dic objectForKey:@"end"];
            [codeStr appendFormat:@"else if (%@ <= unicode && unicode <= %@)\n", start, end];
            [codeStr appendFormat:@"{\n"];
            [codeStr appendFormat:@"    return YES;\n"];
            [codeStr appendFormat:@"}\n"];
        }
        NSLog(@"%@", codeStr);
        
#endif
    }
    else
    {
        emojiArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
#endif
}

- (void)checkDisplayOperateGuide
{
//    [HMShadeGuideControl controlWithSynchronizePost];
}

- (void)setScrollViewContentSize
{
    CGFloat h = s_ImageWallView.bottom + m_BottomView.height + 20;
    if (h < UI_SCREEN_HEIGHT)
    {
        h = UI_SCREEN_HEIGHT;
    }
    
    m_ScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, h);
    
    m_BottomView.top = s_ImageWallView.bottom;
    
    if (DRAFTBOX_PICTURE_MAXCOUNT <= m_DraftBoxData.m_PicArray.count)
    {
        m_CameraBtn.enabled = NO;
        m_PhotoBtn.enabled = NO;
    }
    else
    {
        m_CameraBtn.enabled = YES;
        m_PhotoBtn.enabled = YES;
    }
}

- (void)setMessageWithDraft:(HMDraftBoxData *)draftBoxData
{
    self.m_IsModify = YES;
    s_HadModified = NO;
    self.m_DraftBoxData = draftBoxData;
    
    self.m_CircleInfo = [[HMCircleClass alloc] init];
    m_CircleInfo.circleTitle = draftBoxData.m_GroupName;
    m_CircleInfo.circleId = draftBoxData.m_Group_id;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //如果应用程序不支持后台模式，则unActive事件时，需要执行cancel
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    //[s_PlaceHolderTextView becomeFirstResponder];
    
//    [self checkDisplayOperateGuide];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark- 隐藏标签和同步区域
-(void)hideHelpAndShareArea
{
    self.m_HelpLabel.hidden = YES;
    self.m_HelpMarkBtn.hidden = YES;
    self.m_ShareLabel.hidden = YES;
//    self.m_ShareQQZoneBtn.hidden = YES;
    self.m_ShareSinaBtn.hidden = YES;
    self.m_ShareTencentBtn.hidden = YES;
}
 #pragma mark - UIGestureRecognizer Delegate
/*
 - (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:[self view]];

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        s_GesturePoint = location;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        if (location.y - s_GesturePoint.y >= 30)
        {
            [m_TopicTitleTextField resignFirstResponder];
            [s_PlaceHolderTextView resignFirstResponder];
        }
    }
}
*/

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.m_TopicTitleTextField resignFirstResponder];
    [s_PlaceHolderTextView resignFirstResponder];
}


#pragma mark -
#pragma mark Navigation Btn Events

- (void)leftAction:(id)sender
{
#if CHECK_EMOJI
    //获取应用程序沙盒的Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];

    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"emoji.plist"];
    //输入写入
    BOOL re = [[self sorted] writeToFile:filename atomically:YES];
    NSLog(@"%d", re);
#endif

    BOOL showAlert = NO;
    
    [m_TopicTitleTextField resignFirstResponder];
    [s_PlaceHolderTextView resignFirstResponder];

    if(self.m_IsCustomCreateTopic)
    {
        [self dismiss];
        return;
    }
    NSString *title = [m_DraftBoxData.m_Title trim];
    m_DraftBoxData.m_Title = title;

    NSString *content = [m_DraftBoxData.m_Content trim];
    m_DraftBoxData.m_Content = content;
        
    if (self.m_IsModify)
    {
        if (s_HadModified)
        {
            showAlert = YES;
        }
    }
    else
    {
        if ([m_DraftBoxData.m_Title isNotEmpty] || [m_DraftBoxData.m_Content isNotEmpty] || [m_DraftBoxData.m_PicArray isNotEmpty])
        {
            showAlert = YES;
        }
    }

    if (showAlert)
    {
        if (self.m_IsModify)
        {
            if (![m_DraftBoxData.m_Title isNotEmpty] && ![m_DraftBoxData.m_Content isNotEmpty] && ![m_DraftBoxData.m_PicArray isNotEmpty])
            {
                s_ActionSheet = [[UIActionSheet alloc] initWithTitle:@"退出编辑" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"不保存草稿", @"删除草稿", nil];
                s_ActionSheet.tag = TAG_ACTION_START+1;
                s_ActionSheet.destructiveButtonIndex = 1;
                [s_ActionSheet showInView:self.view];
            }
            else
            {
                s_ActionSheet = [[UIActionSheet alloc] initWithTitle:@"退出编辑" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"不保存草稿", @"保存草稿", nil];
                s_ActionSheet.tag = TAG_ACTION_START;
                s_ActionSheet.destructiveButtonIndex = 0;
                [s_ActionSheet showInView:self.view];
            }
        }
        else
        {
            s_ActionSheet = [[UIActionSheet alloc] initWithTitle:@"退出编辑" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"不保存草稿", @"保存草稿", nil];
            s_ActionSheet.tag = TAG_ACTION_START;
            s_ActionSheet.destructiveButtonIndex = 0;
            [s_ActionSheet showInView:self.view];
        }
        
        return;
    }
    
    [self dismiss];
}

- (void)dismiss
{
    if ([delegate respondsToSelector:@selector(createTopicViewControllerDidFinished:)])
    {
        [delegate createTopicViewControllerDidFinished:self];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#if CHECK_EMOJI
- (NSArray *)sorted
{
    NSArray *resultArray = [emojiArray sortedArrayUsingComparator:
                            ^(id obj1, id obj2){
                                NSDictionary *dic1 = (NSDictionary *)obj1;
                                NSDictionary *dic2 = (NSDictionary *)obj2;
                                NSString *str1 = [dic1 stringForKey:@"unicode"];
                                NSString *str2 = [dic2 stringForKey:@"unicode"];
                                //return [str1 compare:str2];
                                NSInteger int1 = strtoul([str1 UTF8String],0,16);
                                NSInteger int2 = strtoul([str2 UTF8String],0,16);

                                if (int1 < int2)
                                {
                                    return -1;
                                }
                                else if (int1 == int2)
                                {
                                    return 0;
                                }
                                else
                                {
                                    return 1;
                                }
                            }];
    return resultArray;
}

- (BOOL)comp:(NSDictionary *)dic
{
    for (NSDictionary *dica in emojiArray)
    {
        NSString *str1 = [dic stringForKey:@"unicode"];
        NSString *str2 = [dica stringForKey:@"unicode"];

        if ([str1 isEqual:str2])
        {
            return YES;
        }
    }

    return NO;
}
#endif
- (void)rightAction:(id)sender
{
    [m_TopicTitleTextField resignFirstResponder];
    [s_PlaceHolderTextView resignFirstResponder];

#if CHECK_EMOJI
    //获取应用程序沙盒的Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];

    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"emoji.plist"];
    //输入写入
    BOOL re = [[self sorted] writeToFile:filename atomically:YES];
    NSLog(@"%d", re);

    return;
#endif

    NSString *title = [m_DraftBoxData.m_Title trim];
    m_DraftBoxData.m_Title = title;

    NSString *content = [m_DraftBoxData.m_Content trim];
    m_DraftBoxData.m_Content = content;
    
    if (![m_DraftBoxData.m_Title isNotEmpty])
    {
        [self showReminderHudWithText:@"标题还空着呢"];
        
        return;
    }

    if (m_DraftBoxData.m_Title.length > 30)
    {
        [self showReminderHudWithText:@"标题超长了呀，30字以内呦"];

        return;
    }
    
    if (![m_DraftBoxData.m_Content isNotEmpty])
    {
        [self showReminderHudWithText:@"正文还空着呢"];
        
        return;
    }
    if ([m_DraftBoxData.m_Content length]<5)
    {
        [self showReminderHudWithText:@"正文不能少于5个字"];
        
        return;
    }

    if ([m_DraftBoxData.m_Title isNotEmpty])
    {
        if ([m_DraftBoxData.m_Title isAllEmojisAndSpace])
        {
            [self showReminderHudWithText:@"标题不能全是表情呦"];

            return;
        }
    }

    if ([m_DraftBoxData.m_Content isNotEmpty])
    {
        if ([m_DraftBoxData.m_Content isAllEmojisAndSpace])
        {
            [self showReminderHudWithText:@"正文不能全是表情呦"];
            
            return;
        }
    }
    
// 检查网络状态
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if([reachability currentReachabilityStatus] == NotReachable)
    {
        MBProgressHUD * errorHud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:errorHud];
        errorHud.animationType = MBProgressHUDAnimationFade;
        errorHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xxx.png"] ];
        errorHud.mode = MBProgressHUDModeCustomView;
        errorHud.labelText = @"网络不给力";
        errorHud.userInteractionEnabled = NO;
        [errorHud show:YES];
        [errorHud hide:YES afterDelay:2.0];
        return;
    }

    BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate sendWithDraftBox:self.m_DraftBoxData modify:m_IsModify];
    
    [self dismiss];
}

- (void)showReminderHudWithText:(NSString *)text
{
    self.remindHud.animationType = MBProgressHUDAnimationFade;
    self.remindHud.mode = MBProgressHUDModeCustomView;
    self.remindHud.labelText = text;
    self.remindHud.userInteractionEnabled = NO;
    [self.remindHud show:YES];
    [self.remindHud hide:YES afterDelay:3.0];
}

#pragma mark - keyboard events

- (void)keyboardWillShow:(NSNotification *)notification
{
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    s_KeyboardHeight = keyboardRect.size.height;
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //NSTimeInterval animationDuration;
    [animationDurationValue getValue:&s_AnimationDuration];
    
    //NSLog(@"dsgasdgbdfs fdah df %f", s_KeyboardHeight);
    s_KeyboardWillShow = YES;
    //NSLog(@"keyboardWillShow %d", s_KeyboardWillShow);
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    //[self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
    
    m_EmojiBtn.enabled = YES;
    m_KeyBoardBtn.enabled = YES;
    m_YuyinBtn.enabled = YES;
    m_CloseBtn.hidden = NO;
    //    m_VoiceButton.enabled = YES;
    //    m_PickphotoButton.enabled = YES;
    
    //s_PlaceHolderTextView.selectedRange = NSMakeRange(s_PlaceHolderTextView.text.length, 0);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:s_AnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    m_ToolBarView.hidden = NO;
    m_ToolBarView.top = UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - m_ToolBarView.height - s_KeyboardHeight;
    
    [UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    m_EmojiBtn.enabled = NO;
    m_KeyBoardBtn.enabled = NO;
    m_YuyinBtn.enabled = NO;
    m_CloseBtn.hidden = YES;
    //    m_VoiceButton.enabled = NO;
    //    m_PickphotoButton.enabled = NO;
    
    //    __block UIView *_aView = m_ToolView;
    //    __block HMEditNewTopicVC *_self = self;
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        m_ToolBarView.top = UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT;
        m_ToolBarView.hidden = YES;
        
    } completion:^(BOOL finished) {
    }];
}


#if (USE_IFlyRecognize)
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
        if (s_PlaceHolderTextView == s_FirstResponderView)
        {
            [s_PlaceHolderTextView becomeFirstResponder];
            if (self.s_IFlyString)
            {
                [s_PlaceHolderTextView insertText:self.s_IFlyString];
            }
            
            [self textViewDidChange:s_PlaceHolderTextView];
        }
        else if (m_TopicTitleTextField == s_FirstResponderView)
        {
            [m_TopicTitleTextField becomeFirstResponder];
            if (self.s_IFlyString)
            {
                [m_TopicTitleTextField insertText:self.s_IFlyString];
            }
            
            [self textFieldDidEndEditing:m_TopicTitleTextField];
        }
        self.s_IFlyString = nil;
        [self enableButton];
        s_FirstResponderView = nil;
    }
    
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    NSLog(@"errorCode:%d", [error errorCode]);
    
    [self enableButton];
    s_FirstResponderView = nil;

}



#pragma mark - 内部调用

// to disableButton,when the recognizer view display,the function will be called
// 当显示语音识别的view时，使其他的按钮不可用
- (void)disableButton
{
    s_ImageWallView.userInteractionEnabled = NO;
    m_BottomView.userInteractionEnabled = NO;
    
    m_EmojiBtn.enabled = NO;
    m_KeyBoardBtn.enabled = NO;
    m_CameraBtn.enabled = NO;
    m_PhotoBtn.enabled = NO;
    m_CloseBtn.enabled = NO;
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

// to enable button,when you start recognizer,this function will be called
// 当语音识别view消失的时候，使其它按钮可用
- (void)enableButton
{
    s_ImageWallView.userInteractionEnabled = YES;
    m_BottomView.userInteractionEnabled = YES;
    
    m_EmojiBtn.enabled = YES;
    m_KeyBoardBtn.enabled = YES;
    m_CameraBtn.enabled = YES;
    m_PhotoBtn.enabled = YES;
    m_CloseBtn.enabled = YES;
    
    self.navigationItem.leftBarButtonItem.enabled  = YES;
    self.navigationItem.rightBarButtonItem.enabled  = YES;
}

#endif


#pragma mark - UITextField events

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!textField.window.isKeyWindow)
    {
        [textField.window makeKeyAndVisible];
    }

    if (textField.inputView)
    {
        m_EmojiBtn.hidden = YES;
        m_KeyBoardBtn.hidden = NO;
    }
    else
    {
        m_EmojiBtn.hidden = NO;
        m_KeyBoardBtn.hidden = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![m_DraftBoxData.m_Title isEqualToString:m_TopicTitleTextField.text])
    {
        s_HadModified = YES;

        m_DraftBoxData.m_Title = m_TopicTitleTextField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#if CHECK_EMOJI
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isNotEmpty])
    {
        NSData *data = [string dataUsingEncoding:NSUTF32LittleEndianStringEncoding];
        uint32_t unicode;
        [data getBytes:&unicode length:sizeof(unicode)];

        uint32_t unicode1 = 0;
        if (data.length > 4)
        {
            NSRange range = NSMakeRange(sizeof(unicode1), sizeof(unicode1));
            [data getBytes:&unicode1 range:range];
        }
        uint32_t unicode2 = 0;
        if (data.length > 8)
        {
            NSRange range = NSMakeRange(sizeof(unicode2), sizeof(unicode2));
            [data getBytes:&unicode2 range:range];
        }

        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"0x%X", unicode], @"unicode", string, @"string", nil];

        if (![self comp:dic])
        {
            s_PlaceHolderTextView.text = [NSString stringWithFormat:@"0x%X 0x%X 0x%X %d", unicode, unicode1, unicode2, [string isInnerEmoji]];
            [emojiArray addObject:dic];
        }
        else
        {
            s_PlaceHolderTextView.text = [NSString stringWithFormat:@"0x%X 0x%X 0x%X %d  已存在", unicode, unicode1, unicode2, [string isInnerEmoji]];
        }

    }

    return YES;
}
#endif

#pragma mark - UITextView delegate
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    m_EmojiBtn.userInteractionEnabled = NO;
//    m_KeyBoardBtn.userInteractionEnabled = NO;
//}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!textView.window.isKeyWindow)
    {
        [textView.window makeKeyAndVisible];
    }
    
//    m_EmojiBtn.userInteractionEnabled = YES;
//    m_KeyBoardBtn.userInteractionEnabled = YES;
    
    if (textView.inputView)
    {
        m_EmojiBtn.hidden = YES;
        m_KeyBoardBtn.hidden = NO;
    }
    else
    {
        m_EmojiBtn.hidden = NO;
        m_KeyBoardBtn.hidden = YES;
    }
}

// 输入框可见区域高度
- (CGFloat)getTextViewShowHeight
{
    // 窗口高-键盘-nav-title-toolbar
    return UI_MAINSCREEN_HEIGHT-s_KeyboardHeight-UI_NAVIGATION_BAR_HEIGHT-m_ToolBarView.height-m_InputBgImageView.top;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
//    UITextRange *startTextRange = [textView characterRangeAtPoint:CGPointZero];
//    CGRect caretRect = [textView caretRectForPosition:startTextRange.end];
//    CGFloat topMargin = CGRectGetMinY(caretRect);
//    CGFloat lineHeight = CGRectGetHeight(caretRect);

//    caretRect = [textView caretRectForPosition:textView.selectedTextRange.end];
//    CGFloat caretTop = CGRectGetMinY(caretRect);
//    NSInteger lineIndex = (caretTop - topMargin) / lineHeight;
    
    if (s_KeyboardWillShow)
    {
        CGRect caretRect = [textView caretRectForPosition:textView.selectedTextRange.end];
        
        //NSLog(@"dsgasdgbdfs fdah df %@, %f, %f, %f, %f", NSStringFromCGRect(caretRect), m_ScrollView.contentOffset.y, caretRect.origin.y-m_ScrollView.contentOffset.y, UI_MAINSCREEN_HEIGHT-s_KeyboardHeight-44, s_KeyboardHeight);
        
        if (caretRect.origin.y+_lineH-m_ScrollView.contentOffset.y > [self getTextViewShowHeight])
        {
            //NSLog(@"m_ScrollView.contentOffset");
            
            CGFloat off = caretRect.origin.y - [self getTextViewShowHeight] + _lineH*1.5;
            
            if (!isnan(off))
            {
            [self performSelector:@selector(ScrollContent:) withObject:[NSNumber numberWithFloat:off] afterDelay:s_AnimationDuration+0.1];
        }
        }
//        else
//        {
//            [self performSelector:@selector(ScrollContent:) withObject:[NSNumber numberWithFloat:m_ScrollView.contentOffset.y] afterDelay:s_AnimationDuration+0.15];
//        }
    }
}

- (void)ScrollContent:(NSNumber *)offset
{
    s_KeyboardWillShow = YES;
    
    float off = [offset floatValue];
    
    if (off > 9999999)
    {
        off = 0;
    }
    
    if (off > m_ScrollView.contentSize.height)
    {
        off = m_ScrollView.contentSize.height - _lineH*1.5;
    }
    
    if (off < 0)
    {
        off = 0;
    }
    
    m_ScrollView.contentOffset = CGPointMake(0, off);
    //NSLog(@"m_ScrollView.contentOffset %f", off);
    
    s_KeyboardWillShow = NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _textViewDidChangeing = YES;
    
    s_HadModified = YES;
    
    s_PlaceHolderTextView.height = MAXFLOAT;
    [s_PlaceHolderTextView sizeToFit];
    s_PlaceHolderTextView.width = UI_SCREEN_WIDTH-TOPIC_TEXTVIEW_GAP*2;
    if (![textView.text isNotEmpty])
    {
        s_PlaceHolderTextView.height = _lineH;
    }
    
    [textView scrollRangeToVisible:textView.selectedRange];
    //textView.contentOffset = CGPointZero;
    
    if(s_PlaceHolderTextView.height <= 96)
    {
        s_PlaceHolderTextView.height = 96;
    }
    m_InputBgImageView.height = s_PlaceHolderTextView.height;
    s_ImageWallView.top = m_InputBgImageView.bottom + 8;
    self.lineImage.top = s_PlaceHolderTextView.height;
    
    [self setScrollViewContentSize];
    
    m_DraftBoxData.m_Content = s_PlaceHolderTextView.text;
    
    CGRect caretRect = [textView caretRectForPosition:textView.selectedTextRange.end];
    
    if (caretRect.origin.y+_lineH-m_ScrollView.contentOffset.y > [self getTextViewShowHeight])
    {
        float off = caretRect.origin.y - [self getTextViewShowHeight]+ _lineH*1.5;
        
        if (!isnan(off))
        {
            if (off < 0)
            {
                off = 0;
            }
            
            m_ScrollView.contentOffset = CGPointMake(0, off);
        }
    }
    _textViewDidChangeing = NO;
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (m_ScrollView == scrollView)
    {
        //NSLog(@"s_KeyboardWillShow %d", s_KeyboardWillShow);
        if (!_scrollViewDragging || s_KeyboardWillShow || _textViewDidChangeing)
        {
            _lastY = scrollView.contentOffset.y;
            //NSLog(@"_lastY %f", _lastY);
        }
        _scrollViewDragging = YES;
        
        if (fabsf(scrollView.contentOffset.y - _lastY) > _lineH+2)
        {
            //NSLog(@"resignFirstResponder %f, %f, %d", scrollView.contentOffset.y, _lastY, _textViewDidChangeing);
            if (!_textViewDidChangeing)
            {
                [s_PlaceHolderTextView resignFirstResponder];
                [m_TopicTitleTextField resignFirstResponder];
            }
            _scrollViewDragging = NO;
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _lastY = scrollView.contentOffset.y;
    s_KeyboardWillShow = NO;
    //NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXX %d", s_KeyboardWillShow);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _scrollViewDragging = NO;
    s_KeyboardWillShow = NO;
    //NSLog(@"scrollViewDidEndDragging %d", s_KeyboardWillShow);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _lastY = scrollView.contentOffset.y;
    _scrollViewDragging = NO;
    s_KeyboardWillShow = NO;
    //NSLog(@"scrollViewDidEndDecelerating %d", s_KeyboardWillShow);
}


#pragma mark -
#pragma mark HMImageWallViewDelegate

- (void)imageWallView:(UIImage *)image didSelecte:(NSInteger)index
{
    
    [s_PlaceHolderTextView resignFirstResponder];
    [m_TopicTitleTextField resignFirstResponder];

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (HMDraftBoxPic *boxPic in m_DraftBoxData.m_PicArray)
    {
        [array addObject:boxPic.m_Photo_data];
    }
    
    if ([array isNotEmpty])
    {
//        [HMShowPage showImageShow:self delegate:self iamges:array index:index];
        NSMutableArray *photos = [NSMutableArray array];
        
        for (NSInteger i = 0; i<array.count; i++)
        {
            NSData *imageData = [array objectAtIndex:i];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.image = [UIImage imageWithData:imageData]; 
            photo.shareEnable = NO;
            [photos addObject:photo];
            if (index == i)
            {
                photo.srcImageView = [[UIImageView alloc]initWithImage:photo.image];
            }
        }
        if ([photos count])
        {
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            if (index < array.count)
            {
                browser.currentPhotoIndex = index;
                browser.firstPhotoIndex = index;
            }
            browser.photos = photos;
            browser.delegate = self;
            [browser show];
        }

    }
}

#pragma mark - MJPhotoBrowserDelegate

// 切换到某一页图片
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
//    if ([self.delegate respondsToSelector:@selector(setFloorWithPicIndex:)])
//    {
//        [self.delegate setFloorWithPicIndex:index];
//    }
}

- (void)photoBrowserClose
{
//    if ([self.delegate respondsToSelector:@selector(closeMJPhotoShow)])
//    {
//        [self.delegate closeMJPhotoShow];
//    }
}


- (void)imageWallViewAddImage
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"图片选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", @"拍照", nil];
    [actionSheet showInView:self.view];
}


- (void)fromPicture
{
    //    self.s_ImagePickerController = [[QBImagePickerController alloc] init];
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
    
    //imagePickerController.limitsMinimumNumberOfSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    //imagePickerController.limitsMaximumNumberOfSelection = YES;
    imagePickerController.maximumNumberOfSelection = DRAFTBOX_PICTURE_MAXCOUNT - m_DraftBoxData.m_PicArray.count;
    
    //NSLog(@"QBImagePickerController %d", DRAFTBOX_PICTURE_MAXCOUNT - m_DraftBoxData.m_PicArray.count);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePresentWindow) name:RECEIVE_AND_VIEW_REMOTENOTIFY object:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [imagePickerController.navigationController setPregnancyColor];
    self.manyImagesPickerNav = navigationController;

    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)fromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePresentWindow) name:RECEIVE_AND_VIEW_REMOTENOTIFY object:nil];
    
        self.imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setDelegate:self];
        [imagePicker setAllowsEditing:NO];

        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        [PXAlertView showAlertWithTitle:@"相机不可用"];
    }
}

#pragma mark - UIAction Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == TAG_ACTION_START)
    {
        s_ActionSheet = nil;
        
        if (buttonIndex == 0)
        {
            // 放弃
            [self dismiss];
        }
        else if (buttonIndex == 1)
        {
            BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate saveToDraftBox:self.m_DraftBoxData modify:m_IsModify];
            
            [self dismiss];
        }
    }
    else if (actionSheet.tag == TAG_ACTION_START+1)
    {
        s_ActionSheet = nil;
        
        if (buttonIndex == 0)
        {
            // 放弃
            [self dismiss];
        }
        else if (buttonIndex == 1)
        {
            if ([HMDraftBoxDB removeDraftBoxDB:self.m_DraftBoxData])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_DRAFTBOX object:nil];
            }
            
            [self dismiss];
        }
    }
    else
    {
        if (buttonIndex == 0)
        {
            //[m_PickphotoButton setImage:nil forState:UIControlStateNormal];
            [m_TopicTitleTextField resignFirstResponder];
            [s_PlaceHolderTextView resignFirstResponder];
            
            [self fromPicture];
        }
        else if (buttonIndex == 1)
        {
            [m_TopicTitleTextField resignFirstResponder];
            [s_PlaceHolderTextView resignFirstResponder];
            [self fromCamera];
        }
        else
        {
            return;
        }
    }
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
/*
    if ([picker isKindOfClass:[QBImagePickerController class]])
    {
        QBImagePickerController *imagePickerController = (QBImagePickerController *)picker;
        
        if (imagePickerController.allowsMultipleSelection)
        {
            NSArray *mediaInfoArray = (NSArray *)info;
            
            //NSLog(@"Selected %d photos", mediaInfoArray.count);
            
            for (NSDictionary *mediaInfo in mediaInfoArray)
            {
                UIImage *image = [mediaInfo objectForKey:@"UIImagePickerControllerOriginalImage"];
                UIImage *uplodeImage = [HMImageScale scaleAndRotateImage:image];
                NSData *ploadImageData = UIImageJPEGRepresentation(uplodeImage, 0.5);

                if (ploadImageData)
                {
                    HMDraftBoxPic *draftBoxPic = [[[HMDraftBoxPic alloc] init] autorelease];
                    draftBoxPic.m_Photo_data = ploadImageData;
                    [m_DraftBoxData.m_PicArray addObject:draftBoxPic];
                }
            }
        }
        else
        {
            NSDictionary *mediaInfo = (NSDictionary *)info;
            NSLog(@"Selected: %@", mediaInfo);
        }
    }
    else
*/
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if ([image isNotEmpty])
        {
            UIImage *uplodeImage = [BBImageScale scaleAndRotateImage:image];
            NSData *ploadImageData = UIImageJPEGRepresentation(uplodeImage, 0.5);
            
            if (ploadImageData)
            {
                HMDraftBoxPic *draftBoxPic = [[HMDraftBoxPic alloc] init];
                draftBoxPic.m_Photo_data = ploadImageData;
                [m_DraftBoxData.m_PicArray addObject:draftBoxPic];
            }
        }
    }
    
    s_HadModified = YES;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (HMDraftBoxPic *boxPic in m_DraftBoxData.m_PicArray)
    {
        [array addObject:boxPic.m_Photo_data];
    }
    
    [s_ImageWallView drawWithArray:array];
    
    [self setScrollViewContentSize];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_AND_VIEW_REMOTENOTIFY object:nil];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.imagePicker = nil;
    self.manyImagesPickerNav = nil;
}

#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    //NSLog(@"%@", assets);

    for (ALAsset *asset in assets)
    {
        UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        UIImage *uplodeImage = [BBImageScale scaleAndRotateImage:image];
        NSData *ploadImageData = UIImageJPEGRepresentation(uplodeImage, 0.5);

        if (ploadImageData)
        {
            HMDraftBoxPic *draftBoxPic = [[HMDraftBoxPic alloc] init];
            draftBoxPic.m_Photo_data = ploadImageData;
            [m_DraftBoxData.m_PicArray addObject:draftBoxPic];
        }
    }

    s_HadModified = YES;

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (HMDraftBoxPic *boxPic in m_DraftBoxData.m_PicArray)
    {
        [array addObject:boxPic.m_Photo_data];
    }

    [s_ImageWallView drawWithArray:array];

    [self setScrollViewContentSize];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_AND_VIEW_REMOTENOTIFY object:nil];

    [self dismissViewControllerAnimated:YES completion:NULL];
    self.imagePicker = nil;
    self.manyImagesPickerNav = nil;
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    //NSLog(@"Cancelled");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_AND_VIEW_REMOTENOTIFY object:nil];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.imagePicker = nil;
    self.manyImagesPickerNav = nil;
}

- (void)closePresentWindow
{
    if (self.imagePicker && imagePicker.visibleViewController)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        [self.imagePicker dismissModalViewControllerAnimated:YES];
        [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    }else if (self.manyImagesPickerNav && manyImagesPickerNav.visibleViewController)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        [self.manyImagesPickerNav dismissModalViewControllerAnimated:YES];
        [self.manyImagesPickerNav dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark -
#pragma mark HMImageShowViewDelegate

- (void)imageShowViewCancle
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)imageShowViewDidFinish:(NSArray *)imageDataArray isChanged:(BOOL)bChanged
{
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (bChanged)
    {
        [s_ImageWallView drawWithArray:imageDataArray];
        [m_DraftBoxData.m_PicArray removeAllObjects];
        for (NSData *imageData in imageDataArray) {
            HMDraftBoxPic *draftBoxPic = [[HMDraftBoxPic alloc] init];
            draftBoxPic.m_Photo_data = imageData;
            [m_DraftBoxData.m_PicArray addObject:draftBoxPic];
        }

        
        s_HadModified = YES;
        [self setScrollViewContentSize];
        
        //NSLog(@"%d", array.count);
    }
}


#pragma mark -
#pragma mark HelpTag Btn Events

- (void)freshHelpTagBtn
{
    if (m_DraftBoxData.m_HelpMark)
    {
        [self.m_HelpMarkBtn setImage:[UIImage imageNamed:@"createNewTopic_helpIcon_on"] forState:UIControlStateNormal];
    }
    else
    {
        [self.m_HelpMarkBtn setImage:[UIImage imageNamed:@"createNewTopic_helpIcon_off"] forState:UIControlStateNormal];
    }
}

- (IBAction)HelpMarkBtn_Click:(id)sender
{
    s_HadModified = YES;
    
    m_DraftBoxData.m_HelpMark = !m_DraftBoxData.m_HelpMark;

    [self freshHelpTagBtn];
}

#pragma mark -
#pragma mark Tool Btn Events

- (IBAction)btnClick:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    switch (button.tag)
    {
        case TAG_BUTTON_EMOJI:
        {
            m_EmojiBtn.hidden = YES;
            m_KeyBoardBtn.hidden = NO;
            
            EmojiInputView *emojiView = [[EmojiInputView alloc] init];
            [emojiView changeEmojiCategoryByIndex:EMOJI_CATEGORY_MOOD];
            emojiView.delegate = self;

            if ([s_PlaceHolderTextView isFirstResponder])
            {
                s_PlaceHolderTextView.inputView = emojiView;
                [s_PlaceHolderTextView reloadInputViews];
            }
            else if ([m_TopicTitleTextField isFirstResponder])
            {
                m_TopicTitleTextField.inputView = emojiView;
                [m_TopicTitleTextField reloadInputViews];
            }
        }
            break;
            
        case TAG_BUTTON_KEYBOARD:
        {
            m_KeyBoardBtn.hidden = YES;
            m_EmojiBtn.hidden = NO;
            
            if ([s_PlaceHolderTextView isFirstResponder])
            {
                s_PlaceHolderTextView.inputView = nil;
                [s_PlaceHolderTextView reloadInputViews];
            }
            else if ([m_TopicTitleTextField isFirstResponder])
            {
                m_TopicTitleTextField.inputView = nil;
                [m_TopicTitleTextField reloadInputViews];
            }
        }
            break;
            
        case TAG_BUTTON_CAMERA:
        {
//            [self fromCamera];
            
            [self imageWallViewAddImage];
        }
            break;
            
        case TAG_BUTTON_PICKPHOTO:
        {
            [self fromPicture];
        }
            break;
            
        case TAG_BUTTON_CLOSE:
        {
            [m_TopicTitleTextField resignFirstResponder];
            [s_PlaceHolderTextView resignFirstResponder];
        }
            break;
            
        case TAG_BUTTON_VOICE:
        {
#if (USE_IFlyRecognize)
            if ([self.iflyRecognizerView start])
            {
                if ([m_TopicTitleTextField isFirstResponder])
                {
                    s_FirstResponderView = m_TopicTitleTextField;
                }
                else if ([s_PlaceHolderTextView isFirstResponder])
                {
                    s_FirstResponderView = s_PlaceHolderTextView;
                }
                
                [m_TopicTitleTextField resignFirstResponder];
                [s_PlaceHolderTextView resignFirstResponder];
                
                [self disableButton];
            }
#endif
        }
            break;
    }
}


#pragma mark - Emojidelegate

- (void)setEmojiFromEmojiInputView:(NSString *)emojiStr
{
//    NSData *data = [emojiStr dataUsingEncoding:NSUTF8StringEncoding];
//
//    emojiStr = [emojiStr stringByAppendingString:data.description];
    
    if ([s_PlaceHolderTextView isFirstResponder])
    {
        [s_PlaceHolderTextView insertText:emojiStr];
        
        [self textViewDidChange:s_PlaceHolderTextView];
    }
    else if ([m_TopicTitleTextField isFirstResponder])
    {
        [m_TopicTitleTextField insertText:emojiStr];

        [self textFieldDidEndEditing:m_TopicTitleTextField];


#if CHECK_EMOJI
        if ([emojiStr isNotEmpty])
        {
            NSData *data = [emojiStr dataUsingEncoding:NSUTF32LittleEndianStringEncoding];
            uint32_t unicode;
            [data getBytes:&unicode length:sizeof(unicode)];

            uint32_t unicode1 = 0;
            if (data.length > 4)
            {
                NSRange range = NSMakeRange(sizeof(unicode1), sizeof(unicode1));
                [data getBytes:&unicode1 range:range];
            }
            uint32_t unicode2 = 0;
            if (data.length > 8)
            {
                NSRange range = NSMakeRange(sizeof(unicode2), sizeof(unicode2));
                [data getBytes:&unicode2 range:range];
            }

            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"0x%X", unicode], @"unicode", emojiStr, @"string", nil];

            if (![self comp:dic])
            {
                s_PlaceHolderTextView.text = [NSString stringWithFormat:@"0x%X 0x%X 0x%X %d", unicode, unicode1, unicode2, [emojiStr isInnerEmoji]];
                [emojiArray addObject:dic];
            }
            else
            {
                s_PlaceHolderTextView.text = [NSString stringWithFormat:@"0x%X 0x%X 0x%X %d  已存在", unicode, unicode1, unicode2, [emojiStr isInnerEmoji]];
            }

        }
#endif

    }
}

- (void)switchEmojiInputView
{
    m_EmojiBtn.hidden = NO;
    m_KeyBoardBtn.hidden = YES;
    
    if ([s_PlaceHolderTextView isFirstResponder])
    {
        s_PlaceHolderTextView.inputView = nil;
        [s_PlaceHolderTextView reloadInputViews];
    }
    else if ([m_TopicTitleTextField isFirstResponder])
    {
        m_TopicTitleTextField.inputView = nil;
        [m_TopicTitleTextField reloadInputViews];
    }
}

- (void)deleteEmoji
{
    if ([s_PlaceHolderTextView isFirstResponder])
    {
        [s_PlaceHolderTextView deleteBackward];
        
        [self textViewDidChange:s_PlaceHolderTextView];
    }
    else if ([m_TopicTitleTextField isFirstResponder])
    {
        [m_TopicTitleTextField deleteBackward];

        [self textFieldDidEndEditing:m_TopicTitleTextField];
    }
}


#pragma mark -
#pragma mark BindThird

- (void)freshShareType:(UMSocialSnsType)snsType
{
//    if (snsType == UMSocialSnsTypeQzone)
//    {
//        m_DraftBoxData.m_ShareType |= HMTopicShareQzone;
//    }
//    else
    if (snsType == UMSocialSnsTypeSina)
    {
        m_DraftBoxData.m_ShareType |= HMTopicShareSina;
    }
    else if (snsType == UMSocialSnsTypeTenc)
    {
        m_DraftBoxData.m_ShareType |= HMTopicShareTenc;
    }
    
    [self freshShareBtn];
}

- (BOOL)bindingThird:(UMSocialSnsType)snsType
{
    //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:snsType];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    
    if ([UMSocialAccountManager isOauthWithPlatform:snsPlatform.platformName])
    {
        [self freshShareType:snsType];
        return YES;
    }
    
    __block BOOL bindingState = NO;
    
    snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response)
    {
        if (response.responseCode == UMSResponseCodeSuccess)
        {
            bindingState = YES;
            [self freshShareType:snsType];
        }
        else
        {
            bindingState = NO;
        }
    });

    return bindingState;
}

- (void)freshShareBtn
{
    HMTopicShareType bindingType = m_DraftBoxData.m_ShareType;
    
//    if (bindingType & HMTopicShareQzone)
//    {
//        m_ShareQQZoneBtn.selected = YES;
//    }
//    else
//    {
//        m_ShareQQZoneBtn.selected = NO;
//    }
    
    if (bindingType & HMTopicShareSina)
    {
        m_ShareSinaBtn.selected = YES;
    }
    else
    {
        m_ShareSinaBtn.selected = NO;
    }
    
    if (bindingType & HMTopicShareTenc)
    {
        m_ShareTencentBtn.selected = YES;
    }
    else
    {
        m_ShareTencentBtn.selected = NO;
    }
}


#pragma mark -
#pragma mark BindThird click

//- (IBAction)QQZoneBindingBtn_Click:(id)sender
//{
//    HMTopicShareType bindingType = m_DraftBoxData.m_ShareType;
//    
//    if ((bindingType ^ HMTopicShareQzone) & HMTopicShareQzone)
//    {
//        [self bindingThird:UMSocialSnsTypeQzone];
//        
//        return;
//    }
//    m_DraftBoxData.m_ShareType &= ~HMTopicShareQzone;
//    [self freshShareBtn];
//}

- (IBAction)sinaBindingBtn_Click:(id)sender
{
    HMTopicShareType bindingType = m_DraftBoxData.m_ShareType;
    
    if ((bindingType ^ HMTopicShareSina) & HMTopicShareSina)
    {
        [self bindingThird:UMSocialSnsTypeSina];
        
        return;
    }
    m_DraftBoxData.m_ShareType &= ~HMTopicShareSina;
    [self freshShareBtn];
}

- (IBAction)tencentBindingBtn_Click:(id)sender
{
    HMTopicShareType bindingType = m_DraftBoxData.m_ShareType;
    
    if ((bindingType ^ HMTopicShareTenc) & HMTopicShareTenc)
    {
        [self bindingThird:UMSocialSnsTypeTenc];
        
        return;
    }
    m_DraftBoxData.m_ShareType &= ~HMTopicShareTenc;
    [self freshShareBtn];
}



@end
