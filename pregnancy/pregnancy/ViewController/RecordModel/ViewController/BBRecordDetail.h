//
//  BBRecordDetail.h
//  pregnancy
//
//  Created by whl on 13-9-22.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordConfig.h"
#import "BBRecordClass.h"

#define DELETE_ALERT_VIEW_TAG 99

@interface BBRecordDetail : BaseViewController
<
    ShareMenuDelegate,
    UMSocialUIDelegate,
    UIAlertViewDelegate
>

@property(nonatomic,strong) IBOutlet UIView *optionView;

@property(nonatomic,strong) IBOutlet UIButton *deleteButton;

@property(nonatomic,strong) IBOutlet UIButton *privateButton;

@property(assign) BOOL isPrivate;

@property(nonatomic,strong) IBOutlet UILabel *dateLabel;

@property(nonatomic,strong) BBRecordClass *recordDetailClass;

@property(nonatomic,strong) ASIFormDataRequest *deleteRequest;

@property(nonatomic,strong) ASIFormDataRequest *privateRequest;

@property(nonatomic,strong) MBProgressHUD *loadProgress;

@property(assign) BOOL isSquare;

@property(nonatomic,strong) IBOutlet UICopyLabel *contentLabel;

@property(nonatomic,strong) IBOutlet UIImageView *recordImage;

@property(nonatomic,strong) IBOutlet UIView *pictureView;

@property(nonatomic,strong) IBOutlet UIScrollView *recordScrollView;

@end
