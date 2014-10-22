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

@interface BBMessageChat : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,EGORefreshTableHeaderDelegate,BBMessageChatDelegate,UITextFieldDelegate,IFlyRecognizerViewDelegate>{
    UITableView *chatTableView;
    NSMutableArray *chatArr;
    ASIFormDataRequest *commentRequest;
    ASIFormDataRequest *deleteMessageRequest;
    ASIFormDataRequest *sendMessageRequest;
    BOOL isEdit;
    NSString *userEncodeId;
    EGORefreshTableHeaderView *_refresh_header_view;
    BOOL _reloading;
    NSMutableArray *messageIdsList;    
    UITapGestureRecognizer *touchRecognizer;
}
@property (nonatomic,strong) IBOutlet UITableView *chatTableView;
@property (nonatomic,strong) NSMutableArray *chatArr;
@property (nonatomic,strong) ASIFormDataRequest *commentRequest;
@property (nonatomic,strong) ASIFormDataRequest *deleteMessageRequest;
@property (nonatomic,strong)  ASIFormDataRequest *sendMessageRequest;
@property (nonatomic,strong)  ASIFormDataRequest *upLoadLogRequest;
@property (assign) BOOL	isEdit;
@property (nonatomic,strong) NSString *userEncodeId;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic,strong) IBOutlet UIView *toolbar;
@property (nonatomic,strong) IBOutlet UIButton *deleteBtn;
@property (nonatomic,strong) IBOutlet UITextField *messageTextField;
@property (nonatomic,strong) NSMutableArray *messageIdsList;

@property (nonatomic, strong) UITapGestureRecognizer *touchRecognizer;


-(IBAction)xunfeiInput:(id)sender;
@end
