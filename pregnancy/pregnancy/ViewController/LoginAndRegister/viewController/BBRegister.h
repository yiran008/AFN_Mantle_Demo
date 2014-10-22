//
//  BBRegister.h
//  pregnancy
//
//  Created by Jun Wang on 12-3-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBUserRequest.h"
#import "BBUser.h"
#import "SBJson.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "BBWeiLoginShare.h"

@protocol BBRegisterDelegate <NSObject>

- (void)registerFinish;

@end

@interface BBRegister : BaseViewController <UITextFieldDelegate,UIGestureRecognizerDelegate,BBWeiLoginShareDelegate> {
    UITextField *nicknameTextField;
    UITextField *emailTextField;
    UITextField *passwordTextField;
    MBProgressHUD *registerProgress;
    ASIFormDataRequest *registerRequest;
    CGPoint gesturePoint;
    NSInteger loginStyleCode;
    ASIHTTPRequest *requests;
    ASIHTTPRequest *checkRequests;
    ASIHTTPRequest *checkEmailRequests;
    UIView *movableView;
    UILabel *descLabelOne;
    UILabel *descLabelTwo;
    BOOL isShowDesc;
}

@property (nonatomic, strong) IBOutlet UITextField *nicknameTextField;
@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) MBProgressHUD *registerProgress;
@property (nonatomic, strong) ASIFormDataRequest *registerRequest;
@property (nonatomic, strong) ASIHTTPRequest *requests;
@property (nonatomic, strong) ASIHTTPRequest *checkRequests;
@property (nonatomic, strong) ASIHTTPRequest *checkEmailRequests;
@property (weak) id<BBRegisterDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIView *movableView;
@property (nonatomic, strong) IBOutlet UILabel *descLabelOne;
@property (nonatomic, strong) IBOutlet UILabel *descLabelTwo;
@property (assign) BOOL isShowDesc;

@property (nonatomic, strong)IBOutlet UILabel *checkNickName;
@property (nonatomic, strong)IBOutlet UILabel *checkEmail;
@property (nonatomic, strong)IBOutlet UILabel *checkPassword;

@property (nonatomic, strong) IBOutlet UIButton *registerButton;

- (IBAction)registerAction:(id)sender;

@end
