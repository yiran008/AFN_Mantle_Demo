//
//  BBNumberRegister.h
//  pregnancy
//
//  Created by whl on 13-10-23.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "BBInsetsTextField.h"
#import "BBModifyUserName.h"

@protocol BBNumberRegisterDelegate <NSObject>

- (void)numberRegisterFinish;

@end

@interface BBNumberRegister : BaseViewController
<
    UITextFieldDelegate,
    UIGestureRecognizerDelegate,
    BBModifyUserNameDelegate
>


@property(nonatomic,strong) IBOutlet UIView *registerView;
@property(nonatomic,strong) IBOutlet BBInsetsTextField *numberText;
@property(nonatomic,strong) IBOutlet UILabel *numberLabel;
@property(nonatomic,strong) IBOutlet BBInsetsTextField *passwordText;

@property(nonatomic,strong) IBOutlet UILabel *passwordLabel;

@property (nonatomic, strong) ASIHTTPRequest *registerRequest;
@property (nonatomic, strong) ASIHTTPRequest *checkNumberRequests;
@property (nonatomic, strong) ASIHTTPRequest *validateRequest;
@property (nonatomic, strong) ASIHTTPRequest *registerPushRequest;
@property (nonatomic, strong) MBProgressHUD *loadProgress;
@property (weak) id<BBNumberRegisterDelegate> delegate;

@property (nonatomic, strong) IBOutlet BBInsetsTextField *validateText;
@property (nonatomic, strong) IBOutlet UIButton *againButton;


@property (nonatomic, strong) ASIHTTPRequest *SMSRequest;
@property (nonatomic, strong) IBOutlet UIView *validateView;
@property (nonatomic, strong) IBOutlet BBInsetsTextField *codeText;
@property (nonatomic, strong) IBOutlet UIButton *validateButton;
@property (nonatomic, strong) IBOutlet UIButton *finishButton;

@property (nonatomic, strong) IBOutlet UIButton *registerButton;
@property (nonatomic, strong) ASIHTTPRequest *babyboxRequest;

@end
