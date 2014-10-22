//
//  BBModifyUserName.h
//  pregnancy
//
//  Created by whl on 14-4-8.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBModifyUserNameDelegate <NSObject>

- (void)modifyUserNameCall;

@end


@interface BBModifyUserName : BaseViewController
<
    UITextFieldDelegate
>

@property (nonatomic, strong) IBOutlet UITextField *m_UserNameTextField;
@property (nonatomic, strong) IBOutlet UIButton *m_commitButton;
@property (nonatomic, strong) ASIHTTPRequest *m_ModifyRequest;
@property (nonatomic, strong) ASIHTTPRequest *m_CheckRequest;
@property (nonatomic, strong) MBProgressHUD *m_LoadProgress;
@property (nonatomic, strong) NSString *m_UserName;
@property (nonatomic, strong) IBOutlet UILabel *m_MessageLabel;
@property (weak) id<BBModifyUserNameDelegate> m_Delegate;

@end
