//
//  BBMessageView.h
//  pregnancy
//
//  Created by mac on 12-12-24.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "BBConfigureAPI.h"
#import "BBDeviceUtility.h"
#import "SBJson.h"
#import "BBMessageCell.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "BBMessageChatDelegate.h"
#import "BBIflyMSC.h"
#import "UMFeedback.h"

@interface UMFeedbackChat : BaseViewController<
        UITableViewDelegate,
        UITableViewDataSource,
        UITextFieldDelegate,
        EGORefreshTableHeaderDelegate,
        UITextFieldDelegate,
        IFlyRecognizerViewDelegate,
        UMFeedbackDataDelegate
    >{
    UITableView *chatTableView;
    NSMutableArray *chatArr;
    EGORefreshTableHeaderView *_refresh_header_view;
    BOOL _reloading;    
    UITapGestureRecognizer *touchRecognizer;
}
@property (nonatomic,strong) IBOutlet UITableView *chatTableView;
@property (nonatomic,strong) NSMutableArray *chatArr;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic,strong) IBOutlet UIView *toolbar;
@property (nonatomic,strong) IBOutlet UITextField *messageTextField;
@property (nonatomic, strong) UITapGestureRecognizer *touchRecognizer;


-(IBAction)xunfeiInput:(id)sender;
- (IBAction)sendMessageAction:(id)sender;
@end
