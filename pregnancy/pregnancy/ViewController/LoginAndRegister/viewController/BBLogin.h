//
//  BBLogin.h
//  pregnancy
//
//  Created by whl on 14-4-8.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBWeiLoginShare.h"
#import "BBSelectRegisterController.h"
#import "BBPerfectInformation.h"
#import "BBNumberRegister.h"

typedef enum
{
    BBPushLogin,
    BBPresentLogin,
    
}BBLoginType;

typedef enum
{
    BBDefauleLogin,
    BBSinaLogin,
    BBQQLogin
    
} BBLoginFashion;

typedef enum {
    LoginDefault,
    LoginMessage,
    LoginBindBaba,
    LoginSign,
    LoginBabyBox,
    LoginActivity,
    LoginKuaiDi,
    LoginFeedback,
    LoginRecordMainPage,
    LoginMusic,
    LoginReplyTopic,
    LoginCreateTopic,
    LoginCollectTopic,
    LoginReportTopic,
    LoginAddCircle,
    LoginQuitCircle,
    LoginSetPage,
    LoginSetPageCenter,
    LoginBabyBorn,
    LoginBandFather,
    LoginPersonalAvatar,
    LoginPersonalEdit,
    LoginPersonalPost,
    LoginPersonalReply,
    LoginPersonalCollect,
    LoginPersonalDraftBox,
    LoginPersonalSendMessage,
    LoginPersonalFollowList,
    LoginPersonalFansList,
    LoginPersonalFollowUser,
    LoginMallPage
} LoginType;

@protocol BBLoginDelegate <NSObject>

- (void)loginFinish;

@optional
- (void)backActionFromLoginVC;

@end

@interface BBLogin : BaseViewController
<
    UITextFieldDelegate,
    UIGestureRecognizerDelegate,
    BBWeiLoginShareDelegate,
//    BBSelectRegisterDelegate,
    BBPerfectInformationDelegate,
    BBNumberRegisterDelegate
>

@property (nonatomic, strong) IBOutlet UITextField *m_EmailTextField;
@property (nonatomic, strong) IBOutlet UITextField *m_PasswordTextField;
@property (nonatomic, strong) MBProgressHUD *m_ProgressBox;
@property (nonatomic, strong) ASIFormDataRequest *m_LoginRequest;
@property (weak) id<BBLoginDelegate> delegate;
@property (nonatomic, strong) ASIHTTPRequest *m_Requests;
@property (assign) BBLoginType m_LoginType;
@property (assign) BBLoginFashion m_LoginFashion;


@end
