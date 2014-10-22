//
//  BBPerfectInformation.h
//  pregnancy
//
//  Created by whl on 14-4-8.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBWeiLoginShare.h"

@protocol BBPerfectInformationDelegate <NSObject>

- (void)perfectInformationFinish;

@end

@interface BBPerfectInformation : BaseViewController
<
    BBWeiLoginShareDelegate
>

@property (nonatomic, strong) MBProgressHUD *m_LoadProgress;
@property (nonatomic, strong) IBOutlet UITextField *m_UserNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *m_EmailTextField;
@property (nonatomic, strong) ASIHTTPRequest *m_PerfectRequest;
@property (nonatomic, strong) ASIHTTPRequest *m_CheckUserNameRequest;
@property (nonatomic, strong) ASIHTTPRequest *m_CkeckEmailRequest;
@property (nonatomic, strong) ASIHTTPRequest *m_BindingUserRequest;
@property (nonatomic, strong) NSString *m_UserName;
@property (nonatomic, strong) IBOutlet UILabel *m_UserNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *m_EmailLabel;
@property (weak) id<BBPerfectInformationDelegate> m_Delagate;
@property (nonatomic, strong) NSDictionary *m_BindingUserData;

@end
