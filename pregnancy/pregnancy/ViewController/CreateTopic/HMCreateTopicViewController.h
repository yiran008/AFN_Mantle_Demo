//
//  HMCreateTopicViewController.h
//  lama
//
//  Created by Heyanyang on 14-1-8.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#define USE_IFlyRecognize   1

#import <UIKit/UIKit.h>
#import "BBPlaceHolderTextView.h"
#import "HMCircleClass.h"
#if (USE_IFlyRecognize)
#import "BBIflyMSC.h"
#endif
#import "EmojiInputView.h"
#import "ASIFormDataRequest.h"
#import "HMDraftBoxDB.h"
#import "HMImageWallView.h"
#import "QBImagePickerController.h"
#import "HMImageShowViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"


@protocol HMCreateTopicViewControllerDelegate;

@interface HMCreateTopicViewController : BaseViewController
<
    UITextFieldDelegate,
    UITextViewDelegate,
    UIScrollViewDelegate,
    //UIGestureRecognizerDelegate,
    //UIAlertViewDelegate,
    UIActionSheetDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
#if (USE_IFlyRecognize)
    IFlyRecognizerViewDelegate,
#endif
    EmojiInputViewDelegate,
    HMImageWallViewDelegate,
    QBImagePickerControllerDelegate,
    HMImageShowViewDelegate,
    MJPhotoBrowserDelegate
>
{
    float s_KeyboardHeight;
    BOOL s_KeyboardWillShow;
    NSTimeInterval s_AnimationDuration;
    
    //CGPoint s_GesturePoint;
        
    BBPlaceholderTextView *s_PlaceHolderTextView;
    HMImageWallView *s_ImageWallView;
    
    QBImagePickerController *s_ImagePickerController;
    
    BOOL _scrollViewDragging;
    CGFloat _lastY;
    
    UIActionSheet *s_ActionSheet;
    
    BOOL s_HadModified;
}

@property (nonatomic, assign) id <HMCreateTopicViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIScrollView *m_ScrollView;

//@property (retain, nonatomic) IBOutlet UILabel *m_CircleLabel;

@property (retain, nonatomic) IBOutlet UIView *m_TopicTitleView;
@property (retain, nonatomic) IBOutlet UITextField *m_TopicTitleTextField;

@property (retain, nonatomic) IBOutlet UIImageView *m_InputBgImageView;

// 选择图片或者拍照选取照片控件
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UINavigationController *manyImagesPickerNav;

@property (retain, nonatomic) IBOutlet UIView *m_BottomView;


@property (retain, nonatomic) IBOutlet UILabel *m_HelpLabel;
@property (retain, nonatomic) IBOutlet UIButton *m_HelpMarkBtn;

@property (retain, nonatomic) IBOutlet UILabel *m_ShareLabel;
@property (retain, nonatomic) IBOutlet UIButton *m_ShareQQZoneBtn;
@property (retain, nonatomic) IBOutlet UIButton *m_ShareSinaBtn;
@property (retain, nonatomic) IBOutlet UIButton *m_ShareTencentBtn;


@property (retain, nonatomic) IBOutlet UIView *m_ToolBarView;
@property (retain, nonatomic) IBOutlet UIButton *m_EmojiBtn;
@property (retain, nonatomic) IBOutlet UIButton *m_KeyBoardBtn;
@property (retain, nonatomic) IBOutlet UIButton *m_YuyinBtn;
@property (retain, nonatomic) IBOutlet UIButton *m_CameraBtn;
@property (retain, nonatomic) IBOutlet UIButton *m_PhotoBtn;
@property (retain, nonatomic) IBOutlet UIButton *m_CloseBtn;


@property (nonatomic, retain) HMCircleClass *m_CircleInfo;

@property (nonatomic, retain) NSString *m_iFlyString;

@property (nonatomic, strong) HMDraftBoxData *m_DraftBoxData;
@property (nonatomic, assign) BOOL m_IsModify;

@property (nonatomic, strong) ASIFormDataRequest *m_Request;

@property (assign) BOOL m_IsCustomCreateTopic;

@property (nonatomic, strong) NSString *topicTitle;
@property (nonatomic, strong) NSString *tip;

- (IBAction)HelpMarkBtn_Click:(id)sender;

- (IBAction)btnClick:(id)sender;

//- (IBAction)QQZoneBindingBtn_Click:(id)sender;
- (IBAction)sinaBindingBtn_Click:(id)sender;
- (IBAction)tencentBindingBtn_Click:(id)sender;

- (void)setMessageWithDraft:(HMDraftBoxData *)draftBoxData;

@end


@protocol HMCreateTopicViewControllerDelegate <NSObject>

@optional
- (void)createTopicViewControllerDidFinished:(HMCreateTopicViewController *)createTopicViewController;


@end
