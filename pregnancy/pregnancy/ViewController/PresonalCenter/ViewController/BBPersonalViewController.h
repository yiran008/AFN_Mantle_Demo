//
//  BBPersonalViewController.h
//  pregnancy
//
//  Created by zhangzhongfeng on 14-1-7.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBLogin.h"
#import "BBSettingViewController.h"
#import "BBAttentionButton.h"

@interface BBPersonalViewController : BaseViewController
<
    UITableViewDataSource,
    UITableViewDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    UIActionSheetDelegate,
    BBLoginDelegate,
    BBSettingViewDelegate,
    BBAttentionButtonDelegate
>
@property (retain, nonatomic) IBOutlet UIImageView *bgHeadImageView;
@property (retain, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (retain, nonatomic) IBOutlet UIView *userInfoVIew;
@property (retain, nonatomic) IBOutlet UILabel *dueDateLable;
@property (retain, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (retain, nonatomic) IBOutlet UILabel *areaLabel;
@property (retain, nonatomic) IBOutlet UILabel *levelLabel;
@property (retain, nonatomic) IBOutlet UILabel *fruitLabel;
@property (retain, nonatomic) IBOutlet UIButton *actionButton;
@property (retain, nonatomic) IBOutlet UITableView *listTable;
@property (retain, nonatomic) IBOutlet UIButton *avatarButton;
@property (retain, nonatomic) IBOutlet UIImageView *avatarBgView;
@property (strong, nonatomic) IBOutlet UIButton *followListButton;
@property (strong, nonatomic) IBOutlet UIButton *fansListButton;
@property (assign, nonatomic) BOOL     isSelf;
@property (assign, nonatomic) BOOL     isPreparation;//备孕
@property (assign, nonatomic) BOOL     isFromLeftDraw;
@property (retain, nonatomic) NSString *userEncodeId;
@property (retain, nonatomic) NSString *userName;
@property (strong, nonatomic) IBOutlet BBAttentionButton *followButton;
@property (strong, nonatomic) IBOutlet UIButton *messageButton;
@property (strong, nonatomic) IBOutlet UIImageView *hospitalIcon;
@property (strong, nonatomic) IBOutlet UIImageView *duedateIcon;
@property (strong, nonatomic) IBOutlet UIImageView *locationIcon;
@property (strong, nonatomic) IBOutlet UIView *separatorLine;
@property (strong, nonatomic) IBOutlet UIImageView *fansPointView;


@property (assign) BOOL isToolBar;

- (IBAction)actionButtonPressed:(id)sender;
- (IBAction)showFruitDetail:(id)sender;
- (IBAction)avatarAction:(id)sender;

@end
