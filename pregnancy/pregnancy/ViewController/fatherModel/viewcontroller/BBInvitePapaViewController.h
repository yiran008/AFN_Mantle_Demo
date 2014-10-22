//
//  BBInvitePapaViewController.h
//  pregnancy
//
//  Created by mac on 13-5-27.
//  Copyright (c) 2013年 babytree. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BBShareMenu.h"

@protocol BBInvitePapaViewControllerDelegate <NSObject>

- (void)InvitePapaViewControllerClose;

@optional
// 获取绑定状态
- (void)InvitePapaViewControllerGetBindStatus;
// 取消绑定
- (void)InvitePapaViewControllerUnBind;

@end

@interface BBInvitePapaViewController : BaseViewController
<
    MFMessageComposeViewControllerDelegate,
    ShareMenuDelegate,
    UIAlertViewDelegate
>

@property (nonatomic, assign) id <BBInvitePapaViewControllerDelegate> delegate;


@property (retain, nonatomic) IBOutlet UILabel *m_TitleLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *m_ActivityIndicatorView;

@property (retain, nonatomic) IBOutlet UIView *m_ContentView;
@property (retain, nonatomic) IBOutlet UILabel *m_CodeLabel;

@property (retain, nonatomic) IBOutlet UIButton *m_InviteBtn;
@property (retain, nonatomic) IBOutlet UIButton *m_UnbindBtn;
@property (retain, nonatomic) IBOutlet UIButton *m_FreshBtn;
@property (nonatomic, strong) IBOutlet UIImageView *m_InviteBg;

@property (nonatomic, strong) ASIHTTPRequest *m_Request;
@property (nonatomic, strong) ASIHTTPRequest *m_UnBandRequest;

// 绑定状态
@property (nonatomic, assign) BOOL m_BindStatus;
// 邀请码
@property (nonatomic, retain) NSString *m_BindCode;

// 刷新状态
@property (nonatomic, assign) BOOL m_IsFresh;

- (IBAction)invitePress:(id)sender;
- (IBAction)unbindPress:(id)sender;
- (IBAction)freshPress:(id)sender;

- (void)refreshView;

@end
