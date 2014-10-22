//
//  HMReplyTopicView.m
//  lama
//
//  Created by songxf on 13-7-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMReplyTopicView.h"
#import "BBImageScale.h"
#import "BbUser.h"
#import "AlertUtil.h"
#import "BBTimeUtility.h"
#import "ARCHelper.h"
#import "HMApiRequest.h"

//#import "HMNetworkError.h"

#define BTN_TAG_START   500

@interface HMReplyTopicView ()

@property (nonatomic, retain) UIButton *picButton;
@property (nonatomic, retain) UIButton *emojiButton;
@property (nonatomic, retain) UIView *gestureBgView;
@property (nonatomic, retain) UIView *editBgView;
@property (nonatomic, retain) UIActionSheet *cameraActionSheet;
@property (nonatomic, retain) UIActionSheet *photoActionSheet;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, strong) ASIFormDataRequest *replyRequest;
@property (nonatomic, retain) UILabel *placeLab;
@property (nonatomic, retain) MBProgressHUD *loadProgress;
@property (assign, nonatomic) LoginType s_LoginType;

@end

@implementation HMReplyTopicView
@synthesize groupId;
@synthesize isJoin;
@synthesize editBgView;
@synthesize contentTextView;
@synthesize gestureBgView;
@synthesize m_cacheContent;
@synthesize m_cacheImageData;
@synthesize m_cacheFloorNumber;
@synthesize cameraActionSheet;
@synthesize photoActionSheet;
@synthesize imagePicker;
@synthesize loadProgress;
//@synthesize m_cacheFloorImageData;
//@synthesize m_cacheMasterImageData;
@synthesize emojiButton;
@synthesize picButton;
@synthesize placeLab;
@synthesize replyRequest;
@synthesize topicID;
@synthesize referID;
@synthesize delegate;

-(void)dealloc
{
    delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [topicID ah_release];
    [referID ah_release];
    [groupId ah_release];
    [loadProgress ah_release];

    [replyRequest clearDelegatesAndCancel];
    [replyRequest ah_release];

    [placeLab ah_release];
    [picButton ah_release];
    [emojiButton ah_release];
    [cameraActionSheet ah_release];
    [photoActionSheet ah_release];
    [imagePicker ah_release];
    [m_cacheImageData ah_release];
    [m_cacheContent ah_release];
    [m_cacheFloorNumber ah_release];
    [editBgView ah_release];
    [contentTextView ah_release];
    [gestureBgView ah_release];

    [super ah_dealloc];
}

- (id)init
{
    CGRect rect = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];

        // 添加滑动手势
        self.gestureBgView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-REAL_INTERFACE_HEIGHT)] ah_autorelease];
        gestureBgView.backgroundColor = [UIColor clearColor];
        [self addSubview:gestureBgView];

        UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)] ah_autorelease];
        [tapGesture setNumberOfTapsRequired:1];
        [self.gestureBgView addGestureRecognizer:tapGesture];

        UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)] ah_autorelease];
        [self.gestureBgView addGestureRecognizer:panRecognizer];
        self.gestureBgView.exclusiveTouch = YES;

        // 添加编辑区域
        self.editBgView = [[[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-REAL_INTERFACE_HEIGHT, UI_SCREEN_WIDTH, REAL_INTERFACE_HEIGHT)] ah_autorelease];
        editBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topicReply_page_bg"]];
        [self addSubview:editBgView];

        NSArray *arr = nil;
#if REPLY_OPEN_EMOJI
        arr = [NSArray arrayWithObjects:@"topicReply_close_icon",
               @"topicReply_emoji_icon",
               @"topicReply_photo_icon", nil];
#elif
        arr = [NSArray arrayWithObjects:@"topicReply_close_icon",
               @"topicReply_photo_icon", nil];
#endif
        for (NSInteger i=0; i<[arr count]; i++)
        {
            UIButton *btn = [[[UIButton alloc] initWithFrame:CGRectMake(50*i, 0, 50, 50)] ah_autorelease];
            btn.tag = BTN_TAG_START+i;
            [btn setImage:[UIImage imageNamed:[arr objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.exclusiveTouch = YES;
            [editBgView addSubview:btn];

#if REPLY_OPEN_EMOJI
            if (i == 2)
            {
                self.picButton = btn;
            }
            else if (i == 1)
            {
                self.emojiButton = btn;
            }
#else
            if (i == 1)
            {
                self.picButton = btn;
            }
#endif
        }

        UIButton *btn = [[[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH -(14+60), 0, 60, 50)] ah_autorelease];
        [btn setTitle:@"发送" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:0xcccccc] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"topicReply_send_btn"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        btn.exclusiveTouch = YES;
        btn.tag = 800;
        btn.userInteractionEnabled = NO;
        [editBgView addSubview:btn];


        // 内容输入框
        UIImageView *inputBg = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 50, UI_SCREEN_WIDTH-30, 80)] ah_autorelease];
        inputBg.userInteractionEnabled = YES;
        inputBg.image = [UIImage imageNamed:@"topicReply_input_bg"];
        [editBgView addSubview:inputBg];

        UITextView *textview = [[[UITextView alloc] initWithFrame:inputBg.bounds] ah_autorelease];
        textview.delegate = self;
        textview.font = [UIFont systemFontOfSize:16];
        textview.backgroundColor = [UIColor clearColor];
        textview.textColor = [UIColor colorWithHex:0x3F3F3F];
        self.contentTextView = textview;
        [inputBg addSubview:textview];

        self.placeLab = [[[UILabel alloc] initWithFrame:CGRectMake(8, 10, 270, 21)] ah_autorelease];
        placeLab.backgroundColor = [UIColor clearColor];
        placeLab.textColor = [UIColor colorWithHex:0x999999];
        [textview addSubview:placeLab];

        self.loadProgress = [[[MBProgressHUD alloc] initWithView:editBgView] ah_autorelease];
        [editBgView addSubview:self.loadProgress];

    }
    return self;
}

// 关闭
- (void)closeView
{
    if (self.hidden)
    {
        return;
    }

    if (contentTextView.text)
    {
        self.m_cacheContent = self.contentTextView.text;
    }

    [self hide];
}

// 隐藏
- (void)hide
{
    [contentTextView resignFirstResponder];
    self.hidden = YES;
    self.editBgView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-REAL_INTERFACE_HEIGHT, UI_SCREEN_WIDTH, REAL_INTERFACE_HEIGHT);

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 显示出来
- (void)show
{
    if([BBUser isLogin])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        self.hidden = NO;
        
        [contentTextView becomeFirstResponder];
    }
    else
    {
       [self goToLoginWithLoginType:LoginReplyTopic];
    }
}

// floor = 0 表示回复楼主
- (void)showWithFloor:(NSString *)floor referID:(NSString *)referId isJoin:(BOOL)join groupId:(NSString *)gId
{
    if (self.hidden == NO)
    {
        return;
    }

    self.isJoin = join;
    self.groupId = gId;

    if ([floor isEqualToString:@"0"] || [floor isEqualToString:@""] || floor == nil)
    {
        isReplyMaster = YES;

        placeLab.text = @"回复楼主";
    }
    else
    {
        isReplyMaster = NO;

        self.m_cacheFloorNumber = floor;
        self.referID = referId;


        placeLab.text = [NSString stringWithFormat:@"回复%@楼",m_cacheFloorNumber];
    }

    [self updatePlaceLab];

    [self show];
}


- (void)showWithFloor:(NSString *)floor referID:(NSString *)referId isJoin:(BOOL)join groupId:(NSString *)gId floorName:(NSString *)name
{
    [self showWithFloor:floor referID:referID isJoin:join groupId:gId];

    if ([floor isEqualToString:@"0"] || [floor isEqualToString:@""] || floor == nil)
    {
        isReplyMaster = YES;
        if ([name isNotEmpty])
        {
            placeLab.text = [NSString stringWithFormat:@"回复楼主 %@",name];
        }
        else
        {
            placeLab.text = [NSString stringWithFormat:@"回复楼主"];
        }
    }
    else
    {
        isReplyMaster = NO;

        self.m_cacheFloorNumber = floor;
        self.referID = referId;

        if ([name isNotEmpty])
        {
            placeLab.text = [NSString stringWithFormat:@"回复%@楼 %@",m_cacheFloorNumber,name];
        }
        else
        {
            placeLab.text = [NSString stringWithFormat:@"回复%@楼",m_cacheFloorNumber];
        }
    }
}

- (BOOL)isAnyReplyCached
{
    if (m_cacheImageData)
    {
        return YES;
    }

    return self.m_cacheContent.length>0? YES:NO;
}

- (void)updateSendButtonState
{
    UIButton *button = (UIButton *)[self viewWithTag:800];
    if ([[contentTextView.text trim] isNotEmpty])
    {
        [button setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
        button.userInteractionEnabled = YES;
    }
    else
    {
        [button setTitleColor:[UIColor colorWithHex:0xcccccc] forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
    }
}

- (void)updatePlaceLab
{
    if (contentTextView.text.length>0)
    {
        placeLab.hidden = YES;
    }
    else
    {
        placeLab.hidden = NO;
    }

    [self updateSendButtonState];
}
#pragma mark  Gesture

- (void)tapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    [self closeView];
}

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    [self closeView];
}

- (void)sendMessage:(id)sender
{
//    if([BBUser isLogin])
//    {
        [self replyTopicAction];
//    }
//    else
//    {
//        [self goToLoginWithLoginType:LoginReplyTopic];
//    }
}

-(void)replyTopicAction
{
    if (!isReplyMaster)
    {
        self.m_cacheContent = contentTextView.text;

        if (![[self.m_cacheContent trim] isNotEmpty])
        {
            [PXAlertView showAlertWithTitle:@"发送内容不能为空"];
            return;
        }
    }
    else
    {
        self.m_cacheContent = contentTextView.text;

        if (![[self.m_cacheContent trim] isNotEmpty])
        {
            [PXAlertView showAlertWithTitle:@"发送内容不能为空"];
            return;
        }
    }

    //    if (!isJoin)
    //    {
    //        [PXAlertView showAlertWithTitle:@"加入这个圈子再回帖吧！" message:nil cancelTitle:@"取消" otherTitle:@"加入并回复" completion:^(BOOL cancelled, NSInteger buttonIndex)
    //         {
    //             if (!cancelled)
    //             {
    //                 [self addCircleReloadData];
    //             }
    //         }];
    //
    //        return;
    //    }
    self.loadProgress.mode = MBProgressHUDModeIndeterminate;
    self.loadProgress.color = [UIColor clearColor];
    self.loadProgress.labelText = nil;
    [self.loadProgress show:YES];

    [self.replyRequest clearDelegatesAndCancel];


#if REPLY_OPEN_EMOJI
    NSString *contentstring = [m_cacheContent parameterEmojis];

    if (!isReplyMaster)
    {
        self.replyRequest = [HMApiRequest replyTopicWithLoginString:[BBUser getLoginString] withTopicID:self.topicID withContentArray:contentstring withPhotoData:m_cacheImageData withPosition:self.m_cacheFloorNumber withReferID:self.referID];
    }
    else
    {
        self.replyRequest = [HMApiRequest replyTopicWithLoginString:[BBUser getLoginString] withTopicID:self.topicID withContentArray:contentstring withPhotoData:m_cacheImageData withPosition:nil withReferID:nil];
    }
#else
    if (!isReplyMaster)
    {
        self.replyRequest = [HMReplyRequest replyTopicNewWithLoginString:[HMUser getLoginString] withTopicID:self.topicID withContent:m_cacheContent withPhotoData:m_cacheImageData withPosition:self.m_cacheFloorNumber withReferID:self.referID];
    }
    else
    {
        self.replyRequest = [HMReplyRequest replyTopicNewWithLoginString:[HMUser getLoginString] withTopicID:self.topicID withContent:m_cacheContent withPhotoData:m_cacheImageData withPosition:nil withReferID:nil];
    }
#endif
    [replyRequest setDidFinishSelector:@selector(submitReplyFinish:)];
    [replyRequest setDidFailSelector:@selector(submitReplyFail:)];
    [replyRequest setDelegate:self];
    [replyRequest startAsynchronous];

}

- (void)pressBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag)
    {
        case BTN_TAG_START:
        {
            [self closeView];
        }
            break;
        case BTN_TAG_START+1://表情
        {
            if (isEmojiInput)
            {
                [self.emojiButton setImage:[UIImage imageNamed:@"topicReply_emoji_icon"] forState:UIControlStateNormal];

                self.contentTextView.inputView = nil;
                [self.contentTextView reloadInputViews];
            }
            else
            {
                [self.emojiButton setImage:[UIImage imageNamed:@"topicReply_keyboard_icon"] forState:UIControlStateNormal];

                EmojiInputView *emojiView = [[[EmojiInputView alloc] init] ah_autorelease];
                [emojiView changeEmojiCategoryByIndex:EMOJI_CATEGORY_MOOD];
                emojiView.delegate = self;

                self.contentTextView.inputView = emojiView;
                [self.contentTextView reloadInputViews];
            }

            isEmojiInput = !isEmojiInput;
        }
            break;
        case BTN_TAG_START+2:// 照片
        {
            BOOL hasGetPicture = NO;
            if (isReplyMaster && self.m_cacheImageData)
            {
                hasGetPicture = YES;
            }
            if (!isReplyMaster && self.m_cacheImageData)
            {
                hasGetPicture = YES;
            }

            if (hasGetPicture)
            {
                self.photoActionSheet = [[[UIActionSheet alloc] initWithTitle:@"图片选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"清除照片", nil] ah_autorelease];
                [photoActionSheet showInView:self];
            }
            else
            {
                if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
                {
                    self.imagePicker = [[[UIImagePickerController alloc] init] ah_autorelease];
                    [imagePicker setDelegate:self];
                    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

                    [self hide];

                    BBAppDelegate *appdelegate=(BBAppDelegate*)[[UIApplication sharedApplication]delegate];
                    [appdelegate.m_mainTabbar.navigationController setPregnancyColor];
                    [appdelegate.m_mainTabbar presentViewController:imagePicker animated:YES completion:nil];

                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePresentWindow) name:RECEIVE_AND_VIEW_REMOTENOTIFY object:nil];

                    if (IOS_VERSION >= 7.0)
                    {
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
                    }
                }
                else
                {
                    self.cameraActionSheet = [[[UIActionSheet alloc] initWithTitle:@"图片选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", @"拍照", nil] ah_autorelease];
                    [cameraActionSheet showInView:self];
                }
            }
        }
            break;

        default:
            break;
    }
}


#pragma mark - UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!textView.window.isKeyWindow)
    {
        [textView.window makeKeyAndVisible];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self updatePlaceLab];
}

#pragma mark - NSNotification keyboardChange

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;

    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    editBgView.top = UI_SCREEN_HEIGHT - keyboardHeight - REAL_INTERFACE_HEIGHT;
    gestureBgView.height = editBgView.top;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    // Get the duration of the animation.
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    editBgView.top = UI_SCREEN_HEIGHT - REAL_INTERFACE_HEIGHT;
    gestureBgView.height = editBgView.top;

    [UIView commitAnimations];
}

#pragma mark - Emojidelegate

- (void)setEmojiFromEmojiInputView:(NSString *)emojiStr
{
    placeLab.hidden = YES;
    [self.contentTextView insertText:emojiStr];
}

- (void)switchEmojiInputView
{
    [self.emojiButton setImage:[UIImage imageNamed:@"topicReply_emoji_icon"] forState:UIControlStateNormal];
    isEmojiInput = !isEmojiInput;
    self.contentTextView.inputView = nil;
    [self.contentTextView reloadInputViews];
}

- (void)deleteEmoji
{
    [self.contentTextView deleteBackward];
    if (contentTextView.text.length == 0)
    {
        placeLab.hidden = NO;
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
        [self imagePickerControllerDidCancel:self.imagePicker];
        //        [self.imagePicker dismissViewControllerAnimated:YES completion:^{
//            
//        }];

    }
    else
    {
        [self.imagePicker popViewControllerAnimated:YES];

    }
}

#pragma mark - Camera View Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_AND_VIEW_REMOTENOTIFY object:nil];

    UIImage *image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([image1 isNotEmpty])
    {
        [self saveImage:image1];
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
    [self show];

    if (IOS_VERSION >= 7.0)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_AND_VIEW_REMOTENOTIFY object:nil];

    [picker dismissViewControllerAnimated:YES completion:nil];
    [self show];

    if (IOS_VERSION >= 7.0)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

- (void)closePresentWindow
{
    if (self.imagePicker && imagePicker.visibleViewController)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIAction Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == photoActionSheet)
    {
        if (buttonIndex == 0)
        {
            if (isReplyMaster)
            {
                self.m_cacheImageData = nil;
            }
            else
            {
                self.m_cacheImageData = nil;
            }

            [picButton setImage:[UIImage imageNamed:@"topicReply_photo_icon"] forState:UIControlStateNormal];
            [self updateSendButtonState];

#if REPLY_OPEN_EMOJI
            picButton.frame = CGRectMake(100, 0, 50, 50);
#else
            picButton.frame = CGRectMake(50, 0, 50, 50);
#endif
        }

        return;
    }
    else if (actionSheet == cameraActionSheet)
    {
        UIImagePickerControllerSourceType sourceType = 0;
        if (buttonIndex == 0)
        {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 1)
        {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [PXAlertView showAlertWithTitle:@"相机不可用"];
                return;
            }
        }
        else
        {
            return;
        }

        self.imagePicker = [[[UIImagePickerController alloc] init] ah_autorelease];
        [imagePicker setDelegate:self];
        [imagePicker setAllowsEditing:NO];
        [imagePicker setSourceType:sourceType];

        [self hide];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePresentWindow) name:RECEIVE_AND_VIEW_REMOTENOTIFY object:nil];

        BBAppDelegate *appdelegate=(BBAppDelegate*)[[UIApplication sharedApplication]delegate];
        [appdelegate.m_mainTabbar.navigationController setPregnancyColor];
        [appdelegate.m_mainTabbar presentViewController:imagePicker animated:YES completion:nil];

        if (IOS_VERSION >= 7.0)
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        }
    }
}

- (void)saveImage:(UIImage *)image
{
    UIImage *uplodeImage = [BBImageScale scaleAndRotateImage:image];

    CGSize size = [BBImageScale imageSmallSizeWithOriginImage:uplodeImage];

    NSData *imageData = UIImageJPEGRepresentation(uplodeImage, 0.5);

    if (isReplyMaster)
    {
        self.m_cacheImageData = imageData;
    }
    else
    {
        self.m_cacheImageData = imageData;
    }

    [picButton setImage:uplodeImage forState:UIControlStateNormal];
    [self updateSendButtonState];

#if REPLY_OPEN_EMOJI
    picButton.frame = CGRectMake(105 + (40-size.width)/2, 5 + (40-size.height)/2, size.width, size.height);
#else
    picButton.frame = CGRectMake(55 + (40-size.width)/2, 5 + (40-size.height)/2, size.width, size.height);
#endif
}

#pragma mark - reply topic ASIHttpRequest Delegate

- (void)submitReplyFinish:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *submitReplyData = [responseString objectFromJSONString];

    if (![submitReplyData isDictionaryAndNotEmpty]) {
        [self.loadProgress hide:YES];
        [PXAlertView showAlertWithTitle:@"发送失败!" message:nil];

        return;
    }

    NSString *status = [submitReplyData stringForKey:@"status"];
    if ([status isEqualToString:@"success"])
    {
        if(self.m_IsFromExpertOnline)
        {
            [MobClick event:@"expert_online_v2" label:@"成功回帖子数量"];
        }

        [MobClick event:@"discuz_v2" label:@"成功回复数量"];
        if ([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
        {
            [MobClick event:@"discuz_v2" label:@"成功回复数量-育儿"];
        }
        else if([BBUser getNewUserRoleState] == BBUserRoleStatePregnant)
        {
            [MobClick event:@"discuz_v2" label:@"成功回复数量-孕期"];
        }
        else
        {
            [MobClick event:@"discuz_v2" label:@"成功回复数量-备孕"];
        }

        loadProgress.labelText = @"发送成功";
        loadProgress.color = [UIColor blackColor];
        loadProgress.mode = MBProgressHUDModeCustomView;
        [loadProgress hide:YES afterDelay:0.3];

        self.m_cacheImageData = nil;
        self.m_cacheContent = nil;

        self.contentTextView.text = self.m_cacheContent;

        [picButton setImage:[UIImage imageNamed:@"topicReply_photo_icon"] forState:UIControlStateNormal];

#if REPLY_OPEN_EMOJI
        picButton.frame = CGRectMake(100, 0, 50, 50);
#else
        picButton.frame = CGRectMake(50, 0, 50, 50);
#endif


        if ([delegate respondsToSelector:@selector(didReplySuccess:)])
        {
            [delegate didReplySuccess:[submitReplyData dictionaryForKey:@"data"]];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_PERSON_REPLY object:nil];

        [self performSelector:@selector(closeView) withObject:nil afterDelay:0.5];
    }
    else if ([status isEqualToString:@"community_no_join_group"])
    {
        [self.loadProgress hide:YES];
        [PXAlertView showAlertWithTitle:@"发送失败!" message:@"加入这个圈子再回帖吧！"];
    }
    else if ([status isEqualToString:@"forbidden"])
    {
        [self.loadProgress hide:YES];

        NSString *message = @"话题太辣，请改改再发~";

        [PXAlertView showAlertWithTitle:@"发送失败!" message:message];
    }
    else if ([status isEqualToString:@"blockedUser"] || [status isEqualToString:@"no_posting"] || [status isEqualToString:@"suspended"])
    {
        [self.loadProgress hide:YES];

        NSString *message = @"啊呀呀，辣妈被禁足啦，请联系管管~";

        [PXAlertView showAlertWithTitle:@"发送失败!" message:message];
    }
    else if ([status isEqualToString:@"discussion_locked"])
    {
        [self.loadProgress hide:YES];

        NSString *message = @"话题被锁定了，不能回复~";

        [PXAlertView showAlertWithTitle:@"发送失败!" message:message];
    }
    else
    {
        [self.loadProgress hide:YES];

        NSString *message = [submitReplyData stringForKey:@"message"];

        if ([message isNotEmpty])
        {
            [PXAlertView showAlertWithTitle:@"发送失败!" message:message];
        }
        else
        {
            [PXAlertView showAlertWithTitle:@"发送失败!"];
        }
    }
}

- (void)submitReplyFail:(ASIHTTPRequest *)request
{
    [self.loadProgress hide:YES];
    [PXAlertView showAlertWithTitle:[CommonErrorCode errorWithErrorCode:ErrorCode_NetError]];
}

//#pragma mark - AddCircle request
//
//- (void)addCircleReloadData
//{
//    if (replyRequest!=nil)
//    {
//        [replyRequest clearDelegatesAndCancel];
//    }
//    self.replyRequest = [HMApiRequest addTheCircleWithGroupID:self.groupId];
//    [replyRequest setDelegate:self];
//    [replyRequest setDidFinishSelector:@selector(addCircleReloadDataFinished:)];
//    [replyRequest setDidFailSelector:@selector(addCircleReloadDataFail:)];
//    [replyRequest startAsynchronous];
//
//    self.loadProgress.mode = MBProgressHUDModeIndeterminate;
//    self.loadProgress.color = [UIColor clearColor];
//    self.loadProgress.labelText = nil;
//    [self.loadProgress show:YES];
//}

//- (void)addCircleReloadDataFinished:(ASIHTTPRequest *)request
//{
//
//    NSString *responseString = [request responseString];
//    NSDictionary *dictData = [responseString objectFromJSONString];
//
//    if (![dictData isDictionaryAndNotEmpty])
//    {
//        if (!loadProgress.isHidden)
//        {
//            [loadProgress hide:YES];
//        }
//        return ;
//    }
//
//    NSString *status = [dictData stringForKey:@"status"];
//    if ([status isEqualToString:@"success"] || [status isEqualToString:@"0"])
//    {
//        NSDictionary * dictList =[dictData dictionaryForKey:@"data"];
//        if ([dictList isNotEmpty])
//        {
//            if ([dictList intForKey:@"group_id"] == [self.groupId intValue])
//            {
//                NSArray *values = [NSArray arrayWithObjects:[dictList stringForKey:@"group_id"], @"1", nil];
//                NSArray *keys = [NSArray arrayWithObjects:@"group_id", @"join_state", nil];
//                NSDictionary *dic = [NSDictionary dictionaryWithObjects:values forKeys:keys];
//                [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_CIRCLE_JOIN_STATE object:dic];
//
//                /*
//                 只有在传过来的圈子id当前帖子所对应的圈子id相同时，才执行回调刷新等操作，原因是有些置顶的帖子会出现在很多圈子内的帖子列表。而往往她的置顶贴子却不属于她这个圈子。
//                 */
//                if ([[delegate topicFromGroupId] intValue] == [self.groupId intValue])
//                {
//                    //回调 刷新加入状态与UI
//                    if ([delegate respondsToSelector:@selector(refreshAboutAddCircleStatus)])
//                    {
//                        [delegate refreshAboutAddCircleStatus];
//                    }
//                }
//                [self.loadProgress hide:NO];
//                self.isJoin = YES;
//                [self sendMessage:nil];
//            }
//        }
//    }
//    else
//    {
//        if (!loadProgress.isHidden)
//        {
//            [loadProgress hide:YES];
//        }
//        NSString *error = [CommonErrorCode netErrorWithErrorCode:[dictData stringForKey:@"status"]];
//
//        if ([error isNotEmpty])
//        {
//            [AlertUtil showApiAlert:error withJsonObject:dictData];
//        }
//        else
//        {
//            NSString * failStr = @"加入失败！请稍后再试";
//            [AlertUtil showApiAlert:failStr withJsonObject:dictData];
//        }
//    }
//    return;
//}
//
//- (void)addCircleReloadDataFail:(ASIHTTPRequest *)request
//{
//    if (!loadProgress.isHidden)
//    {
//        loadProgress.labelText = @"加入失败！请稍后再试";
//        loadProgress.color = [UIColor blackColor];
//        loadProgress.mode = MBProgressHUDModeCustomView;
//        [loadProgress hide:YES afterDelay:0.2];
//    }
//    NSError *error = [request error];
//    [AlertUtil showErrorAlert:[CommonErrorCode errorWithErrorCode:ErrorCode_NetError] withError:error];
//}

#pragma mark -
#pragma mark loginDelegate  and method

- (void)goToLoginWithLoginType:(LoginType)theLoginType
{
    BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
    login.m_LoginType = BBPresentLogin;
    BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
    [navCtrl setColorWithImageName:@"navigationBg"];
    self.s_LoginType = theLoginType;
    login.delegate = self;
    [self.viewController  presentViewController:navCtrl animated:YES completion:^{
        
    }];
    return ;
}

-(void)loginFinish
{
    [self show];
//    [self.contentTextView becomeFirstResponder];
//    [self replyTopicAction];
}

- (void)backActionFromLoginVC
{
//    [self show];
//    [self.contentTextView becomeFirstResponder];
}

@end


