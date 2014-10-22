//
//  BBSendMessage.h
//  pregnancy
//
//  Created by Jun Wang on 12-4-24.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "BBMessageRequest.h"
#import "BBIflyMSC.h"

@interface BBSendMessage : BaseViewController <UITextViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,IFlyRecognizerViewDelegate> {
    UITextView *replyTextView;
    UITextField *bogusTextField;
    NSString *replyUID;
    MBProgressHUD *replyProgress;
    ASIFormDataRequest *messageRequest;
    CGPoint gesturePoint;
    UIView *inputView;
    BOOL isRequestShow;
}

@property (nonatomic, strong) IBOutlet UITextView *replyTextView;
@property (nonatomic, strong) UITextField *bogusTextField;
@property (nonatomic, strong) NSString *replyUID;
@property (nonatomic, strong) MBProgressHUD *replyProgress;
@property (nonatomic, strong) ASIFormDataRequest *messageRequest;
@property (nonatomic,strong) IBOutlet UIView *inputView;
@property (assign) BOOL isHospitalMessage;

@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;
@property (nonatomic, strong) NSMutableString *s_IFlyString;

-(IBAction)xunfeiInput:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUID:(NSString *)theUID;

@end
