//
//  BBModifyNickName.m
//  pregnancy
//
//  Created by whl on 13-9-17.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBModifyNickName.h"
#import "BBNavigationLabel.h"
#import "BBApp.h"
#import "MobClick.h"
#import "BBUser.h"

@interface BBModifyNickName ()

@end

@implementation BBModifyNickName

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_saveNicknameRequest clearDelegatesAndCancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改昵称";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.exclusiveTouch = YES;
    [commitButton setFrame:CGRectMake(0, 0, 40, 30)];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [commitButton setTitle:@"保存" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    [self.navigationItem setRightBarButtonItem:commitBarButton];
    self.nicknameText.text = self.nickname;
    [self.nicknameText becomeFirstResponder];
    
    self.saveProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.saveProgress];
}

-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)commitAction:(id)sender
{
    if (![self.nicknameText.text isEqualToString:self.nickname])
    {
        NSString * currentNameStr = [self.nicknameText.text trim];
        self.nicknameText.text = currentNameStr;
        
        if (currentNameStr.length < 3)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"昵称太短"
                                                           delegate:nil
                                                  cancelButtonTitle:@"YES" otherButtonTitles:nil];
            [alert show];
            
            return;
        }
        else if ([currentNameStr isContainsEmojis])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"昵称不能包含表情字符"
                                                           delegate:nil
                                                  cancelButtonTitle:@"YES" otherButtonTitles:nil];
            [alert show];
            
            return;
        }
        [self saveInfoNickNameReloadData];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    IOS6_RELEASE_VIEW
}

- (void)viewDidUnload
{
    [self viewDidUnloadBabytree];
    
    [super viewDidUnload];
}

- (void)viewDidUnloadBabytree
{
    [self.saveNicknameRequest clearDelegatesAndCancel];
    self.saveNicknameRequest = nil;
    self.saveProgress = nil;
    self.nicknameText = nil;
}

- (void)saveInfoNickNameReloadData
{
    [self.saveNicknameRequest clearDelegatesAndCancel];
    self.saveNicknameRequest =[BBUserRequest modifyUserInfoNickName:self.nicknameText.text];
    [self.saveNicknameRequest setDelegate:self];
    [self.saveNicknameRequest setDidFinishSelector:@selector(saveInfoReloadDataFinished:)];
    [self.saveNicknameRequest setDidFailSelector:@selector(saveInfoReloadDataFail:)];
    [self.saveNicknameRequest startAsynchronous];
}

- (void)saveInfoReloadDataFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    NSString *status = [data stringForKey:@"status"];
    if (error == nil) {
        if ([status isEqualToString:@"success"]) {
            [self.saveProgress setLabelText:@"修改成功"];
            self.saveProgress .animationType = MBProgressHUDAnimationFade;
            self.saveProgress .customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
            self.saveProgress .mode = MBProgressHUDModeCustomView;
            [self.saveProgress  show:YES];
            [self.saveProgress  hide:YES afterDelay:1];
            [BBUser setNickname:self.nicknameText.text];
            if (self.delegate && [self.delegate respondsToSelector:@selector(successModifyNickname)])
            {
                [self.delegate successModifyNickname];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.saveProgress  setLabelText:@"修改失败"];
            self.saveProgress .animationType = MBProgressHUDAnimationFade;
            self.saveProgress .customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xxx"]];
            self.saveProgress .mode = MBProgressHUDModeCustomView;
            [self.saveProgress  show:YES];
            [self.saveProgress  hide:YES afterDelay:1];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[data stringForKey:@"message"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)saveInfoReloadDataFail:(ASIHTTPRequest *)request
{
    [self.saveNicknameRequest clearDelegatesAndCancel];
    self.saveNicknameRequest = nil;
    [self.saveProgress  setLabelText:@"保存失败"];
    self.saveProgress .animationType = MBProgressHUDAnimationFade;
    self.saveProgress .customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xxx"]];
    self.saveProgress .mode = MBProgressHUDModeCustomView;
    [self.saveProgress  show:YES];
    [self.saveProgress  hide:YES afterDelay:1];
}

@end
