//
//  BBModifyNickName.h
//  pregnancy
//
//  Created by whl on 13-9-17.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBUserRequest.h"

@protocol ModifyNicknameDelegate <NSObject>

- (void)successModifyNickname;

@end

@interface BBModifyNickName : BaseViewController<UITextFieldDelegate>

@property(nonatomic,strong)IBOutlet UITextField *nicknameText;
@property(nonatomic,strong) NSString *nickname;
@property(nonatomic,strong) ASIFormDataRequest *saveNicknameRequest;
@property(nonatomic,strong) MBProgressHUD *saveProgress;
@property(nonatomic,assign) id<ModifyNicknameDelegate>delegate;
@end
