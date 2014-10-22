//
//  BBPersonalViewController.m
//  pregnancy
//
//  Created by zhangzhongfeng on 14-1-7.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBPersonalViewController.h"
#import "BBApp.h"
#import "BBNavigationLabel.h"
#import "BBUser.h"
#import "BBPregnancyInfo.h"
#import "BBHospitalRequest.h"
#import "BBAreaDB.h"
#import "BBThirdUserRequest.h"
#import "SBJsonParser.h"
#import "MobClick.h"
#import "BBSupportTopicDetail.h"
#import "UIButton+WebCache.h"
#import "BBStatisticsUtil.h"
#import "BBImageScale.h"
#import "BBTopicRequest.h"
#import "BBPersonalListCell.h"
#import "BBUserRequest.h"
#import "BBUserPersonalTopicViewController.h"
#import "BBSendMessage.h"
#import "BBRefreshPersonalTopicList.h"
#import "BBTimeUtility.h"
#import "BBEditPersonalViewController.h"
#import "BBUserRecordMoon.h"
#import "BBPreparationEditViewController.h"
#import "BBUmengAdScrollView.h"
#import "BBUserCollection.h"
#import "HMDraftBoxViewController.h"
#import "BBBabyAgeCalculation.h"
#import "BBRelationshipViewController.h"
#import "BBTopicHistoryViewController.h"

#define kImageHiddenHeight       80
#define ERROR_ALERT_VIEW_TAG 100
#define kTopicHistoryKey @"最近浏览的帖子"
#define kPostTopicKey @"发表的帖子"
#define kReplyTopicKey @"回复的帖子"
#define kCollectionKey @"我的收藏"
#define kDraftKey @"草稿箱"
#define kMoodKey @"心情记录"

@interface BBPersonalViewController ()<UIAlertViewDelegate>
@property (nonatomic, retain) ASIFormDataRequest        *fruitRequest;
@property (nonatomic, retain) ASIFormDataRequest        *avatarUploadRequest;
@property (nonatomic, retain) ASIFormDataRequest        *userInfoRequest;
@property (nonatomic, retain) UIImagePickerController   *imagePicker;
@property (nonatomic, retain) NSMutableDictionary       *userInfoDic;
@property (nonatomic, retain) NSMutableArray            *listTitleArray;
@property (nonatomic, retain) MBProgressHUD     *progressHUD;
@property (strong, nonatomic) IBOutlet UIButton *s_LevelButton;
@property (strong, nonatomic) IBOutlet UIButton *s_FruitButton;
@property (assign) BBUserRoleState s_CurrentPersonalRoleState;
@property (assign, nonatomic) LoginType s_LoginType;
@property (assign) BOOL s_SucceedGetUserInfo;
@property (assign) BOOL s_IsPendingRequest;
@property (assign) BOOL s_IsErrorAlertShowing;
@end

@implementation BBPersonalViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.fruitRequest clearDelegatesAndCancel];
    [self.avatarUploadRequest clearDelegatesAndCancel];
    [self.userInfoRequest clearDelegatesAndCancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.isToolBar)
    {
        self.userEncodeId = [BBUser getEncId];
        [self registerPersonalNotification];
    }
    if ([self.userEncodeId isEqualToString:[BBUser getEncId]] || self.isToolBar)
    {
        self.isSelf = YES;
        self.listTitleArray = [NSMutableArray arrayWithObjects:kTopicHistoryKey,kPostTopicKey,kReplyTopicKey,kCollectionKey, kDraftKey,nil];
    }
    else
    {
        self.isSelf = NO;
        self.listTitleArray = [NSMutableArray arrayWithObjects:kPostTopicKey,kReplyTopicKey,kMoodKey, nil];
    }
    
    self.s_SucceedGetUserInfo = NO;
    self.s_IsPendingRequest = NO;
    
    self.s_CurrentPersonalRoleState = [BBUser getNewUserRoleState];
    
    self.userInfoDic = [[NSMutableDictionary alloc] init];
    
    [self setSubViews];
    [self addBackButton];
    [self addProgressHUD];
    [self initializeUI];
    
    [self getUserInfo];
}

-(void)initializeUI
{
    self.view.backgroundColor = RGBColor(239, 239, 244, 1);
    
    [self.dueDateLable setShadowOffset:CGSizeMake(0, 0.5f)];
    [self.hospitalLabel setShadowOffset:CGSizeMake(0, 0.5f)];
    [self.areaLabel setShadowOffset:CGSizeMake(0, 0.5f)];
    [self.levelLabel setShadowOffset:CGSizeMake(0, 0.5f)];
    [self.fruitLabel setShadowOffset:CGSizeMake(0, 0.5f)];
    [self.separatorLine setSize:CGSizeMake(320, 0.5)];
    [self.listTable.layer setBorderColor:[[UIColor colorWithHex:0xcccccc] CGColor]];
    [self.listTable.layer setBorderWidth:0.5f];
    
    NSMutableAttributedString *followString = [self combineString:@"关注  " font:[UIFont systemFontOfSize:12] withString:@"0" appendFont:[UIFont systemFontOfSize:14]];
    [self.followListButton setAttributedTitle:followString forState:UIControlStateNormal];
    NSMutableAttributedString *fansString = [self combineString:@"粉丝  " font:[UIFont systemFontOfSize:12] withString:@"0" appendFont:[UIFont systemFontOfSize:14]];
    [self.fansListButton setAttributedTitle:fansString forState:UIControlStateNormal];
    
    self.followButton.u_id = self.userEncodeId;
    self.followButton.delegate = self;
    [self.followButton changeButtonStateImageWithDict:@{STATE_ADD_NORMAL: @"btn_center_follow_nor",STATE_ADD_PRESSED: @"btn_center_follow_sel",STATE_HAD_NORMAL: @"center_followed_normal",STATE_HAD_PRESSED: @"center_followed_pressed",STATE_BOTH_NORMAL: @"center_both_normal",STATE_BOTH_PRESSED: @"center_both_pressed"}];
    
    self.avatarButton.exclusiveTouch = YES;
    self.s_LevelButton.exclusiveTouch = YES;
    self.s_FruitButton.exclusiveTouch = YES;
    self.followListButton.exclusiveTouch = YES;
    self.fansListButton.exclusiveTouch = YES;
    self.messageButton.exclusiveTouch = YES;
    self.followButton.exclusiveTouch = YES;
}

-(void)registerPersonalNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:DIDCHANGE_PERSON_COLLECT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:DIDCHANGE_PERSON_POST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:DIDCHANGE_PERSON_REPLY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePrePare) name:DIDCHANGE_PERSONAL_PREPARE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePregnancy) name:DIDCHANGE_PERSONAL_PREGNANCY object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isSelf || self.isToolBar || [self.userEncodeId isEqualToString:[BBUser getEncId]])
    {
        if (!self.isSelf)
        {
            self.isSelf = YES;
            self.listTitleArray = [NSMutableArray arrayWithObjects:kTopicHistoryKey,kPostTopicKey,kReplyTopicKey,kCollectionKey,kDraftKey,nil];
        }
        if ([BBUser isLogin])
        {
            if([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
            {
                self.isPreparation = YES;
            }
            else
            {
                self.isPreparation = NO;
                
            }
            self.userEncodeId = [BBUser getEncId];
            if (self.s_CurrentPersonalRoleState != [BBUser getNewUserRoleState] || [BBRefreshPersonalTopicList NeedRefreshPersonalCenter])
            {
                [BBRefreshPersonalTopicList setNeedRefreshPersonalCenter:NO];
                self.s_CurrentPersonalRoleState = [BBUser getNewUserRoleState];
                [self setSubViews];
            }
        }
        [self getUserInfo];
        [self setNav];
        [self checkUpdateAvatarUrl];
    }
    [self changeButtonStatus];
    [self checkNewFansPointStatus];
}

#pragma mark - Create UI

- (BOOL)isLoginAndSelfCenter
{
    return [BBUser isLogin] && (self.isSelf || self.isToolBar || [self.userEncodeId isEqualToString:[BBUser getEncId]]);
}
- (void)checkNewFansPointStatus
{
    self.fansPointView.hidden = YES;
    if([self isLoginAndSelfCenter])
    {
        if ([BBUser getUserNewFansCount]>0)
        {
            self.fansPointView.hidden = NO;
        }
    }
}

-(void)changeButtonStatus
{
    self.actionButton.hidden = !self.isSelf;
    self.messageButton.hidden = self.isSelf;
    self.followButton.hidden = self.isSelf;
}

- (void)setSubViews
{
    //导航栏
    [self setNav];
    
    //视图坐标
    self.userInfoVIew.clipsToBounds = NO;
    
    self.listTable.top = 254;
    self.listTable.height = [self.listTitleArray count] * 54;
    self.bgScrollView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 20 - 44);
    if (self.isToolBar)
    {
        self.bgScrollView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 20 - 44 - UI_TAB_BAR_HEIGHT);
    }
    
    [self resetScrollView];
    
    [self.avatarButton.layer setMasksToBounds:YES];
    [self.avatarButton.layer setCornerRadius:30.0f];
}

- (void)setNav
{
    [self.navigationItem setTitle:self.userName];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    if (self.isToolBar)
    {
         NSString *centerTitle = @"我";
       
        if ([BBUser isLogin] && [[BBUser getNickname] isNotEmpty])
        {
            centerTitle = [BBUser getNickname];
        }
         self.navigationItem.title = centerTitle;
        [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    }
}

- (void)resetScrollView
{
    if (self.listTable.top + CGRectGetHeight(self.listTable.frame) > CGRectGetHeight(self.bgScrollView.frame))
    {
        self.bgScrollView.contentSize = CGSizeMake(320, self.listTable.top + CGRectGetHeight(self.listTable.frame)+10);
    }
    else
    {
        self.bgScrollView.contentSize = CGSizeMake(320, CGRectGetHeight(self.bgScrollView.frame) + 1+10);
    }
}

- (void)addBackButton {
    
    
    if (self.isToolBar)
    {
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.view setHeight:DEVICE_HEIGHT- UI_TAB_BAR_HEIGHT - 64];
        UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightItemButton.exclusiveTouch = YES;
        [rightItemButton setFrame:CGRectMake(0, 0, 40, 30)];
        [rightItemButton setImage:[UIImage imageNamed:@"personal_set_icon"] forState:UIControlStateNormal];
        [rightItemButton setImage:[UIImage imageNamed:@"personal_set_icon_pressed"] forState:UIControlStateHighlighted];
        [rightItemButton addTarget:self action:@selector(setPageAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
        [self.navigationItem setRightBarButtonItem:commitBarButton];
        return;
    }
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
}

-(IBAction)setPageAction:(id)sender
{
    [MobClick event:@"my_center_v2" label:@"设置"];
    BBSettingViewController *setPage = [[BBSettingViewController alloc]initWithNibName:@"BBSettingViewController" bundle:nil];
    setPage.hidesBottomBarWhenPushed = YES;
    setPage.m_delegate = self;
    [self.navigationController pushViewController:setPage animated:YES];
}

- (void)addProgressHUD
{
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.progressHUD setLabelText:@"加载中..."];
    [self.view addSubview:self.progressHUD];
}

- (void)showErrorWithWarning:(NSString *)warning
{
    if (!self.s_IsErrorAlertShowing)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:warning delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        alert.tag = ERROR_ALERT_VIEW_TAG;
        [alert show];
    }
    
    if (self.isToolBar)
    {
        [self updateInfo];
        [self.listTable reloadData];
    }
//
//    [self hideError];
//
//    UIView *errorView = [[UIView alloc] initWithFrame:CGRectMake(0, (DEVICE_HEIGHT - 20 - 44 - 180 - 78)/2 + 130, 320, 78)];
//    [errorView setUserInteractionEnabled:YES];
//    errorView.tag = kErrorImageViewTag;
//    errorView.backgroundColor = [UIColor clearColor];
//    
//    UIImageView *errorImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH - 48)/2, 0, 48, 48)];
//    errorImageView.image = [UIImage imageNamed:@"personal_error"];
//    errorImageView.tag = kErrorImageViewTag;
//    [errorView addSubview:errorImageView];
//    
//    UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 58, 320, 20)];
//    errorLabel.backgroundColor = [UIColor clearColor];
//    errorLabel.textColor = RGBColor(170, 170, 170, 1);
//    errorLabel.font = [UIFont systemFontOfSize:12];
//
//    errorLabel.text = warning;
//    [errorLabel setTextAlignment:NSTextAlignmentCenter];
//    [errorView addSubview:errorLabel];
//    
//    [self.bgScrollView addSubview:errorView];
//    [self.bgScrollView sendSubviewToBack:errorView];
//    [self resetScrollView];
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if(alertView.tag == ERROR_ALERT_VIEW_TAG)
    {
        self.s_IsErrorAlertShowing = YES;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == ERROR_ALERT_VIEW_TAG)
    {
        self.s_IsErrorAlertShowing = NO;
    }
}

- (void)updateUIFrameAfterSuccessGetUserInfo
{
    if (!self.isToolBar)
    {
        self.hospitalIcon.hidden = NO;
        self.duedateIcon.hidden = NO;
        self.locationIcon.hidden = NO;
        self.dueDateLable.hidden = NO;
        self.hospitalLabel.hidden = NO;
        self.areaLabel.hidden = NO;
        self.listTable.height = [self.listTitleArray count] * 54;
        [self resetScrollView];
    }
}

- (void)updateUIFrameAfterFailGetUserInfo
{
    if (!self.isToolBar)
    {
        self.dueDateLable.hidden = ![self.dueDateLable.text isNotEmpty];
        self.hospitalLabel.hidden = ![self.hospitalLabel.text isNotEmpty];
        self.areaLabel.hidden = ![self.areaLabel.text isNotEmpty];
        
        self.duedateIcon.hidden = self.dueDateLable.hidden;
        self.hospitalIcon.hidden = self.hospitalLabel.hidden;
        self.locationIcon.hidden = self.areaLabel.hidden;
        
        self.listTable.height = [self.listTitleArray count] * 54;
        [self resetScrollView];
    }
}

#pragma mark - private method
- (void)updateInfo
{

    if ([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
    {
        self.dueDateLable.text = [NSString stringWithFormat:@"宝宝生日：%@",[BBPregnancyInfo pregancyDateByString]];
    }
    else  if([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
    {
        self.dueDateLable.text = @"备孕中";
    }
    else
    {
        self.dueDateLable.text = [NSString stringWithFormat:@"预产期：%@",[BBPregnancyInfo pregancyDateByString]];
    }
    //医院
    NSDictionary *hospitalData = [BBHospitalRequest getHospitalCategory];
    if (hospitalData != nil)
    {
        self.hospitalLabel.text = [hospitalData stringForKey:kHospitalNameKey];
    }
    else if ([[BBHospitalRequest getAddedHospitalName] isNotEmpty])
    {
        self.hospitalLabel.text = [BBHospitalRequest getAddedHospitalName];
    }
    else
    {
        self.hospitalLabel.text = @"未设置医院";
    }
    //地区
    [self setLocationShow];
}

//检查更新头像
- (void)checkUpdateAvatarUrl
{
    if ([BBUser getLocalAvatar] != nil)
    {
        UIImage *avatarImage = [[UIImage alloc] initWithContentsOfFile:[BBUser getLocalAvatar]];
        [self.avatarButton setImage:avatarImage forState:UIControlStateNormal];
        [self.avatarButton setImage:avatarImage forState:UIControlStateHighlighted];
    }
    else
    {
        [self.avatarButton setImageWithURL:[NSURL URLWithString:[BBUser getAvatarUrl]] placeholderImage:[UIImage imageNamed:@"personal_default_avatar"]];
    }
    
}

- (void)getUserInfo
{
    if (self.isToolBar && ![BBUser isLogin])
    {
        self.levelLabel.text = @"LV.0";
        self.fruitLabel.text = @"0";
        NSMutableAttributedString *followString = [self combineString:@"关注  " font:[UIFont systemFontOfSize:12] withString:@"0" appendFont:[UIFont systemFontOfSize:14]];
        [self.followListButton setAttributedTitle:followString forState:UIControlStateNormal];
        NSMutableAttributedString *fansString = [self combineString:@"粉丝  " font:[UIFont systemFontOfSize:12] withString:@"0" appendFont:[UIFont systemFontOfSize:14]];
        [self.fansListButton setAttributedTitle:fansString forState:UIControlStateNormal];
        [self updateInfo];
        [self.listTable reloadData];
    }
    else
    {
        if (self.isToolBar || self.isSelf)
        {
            [self checkUploadAvatar];
            NSArray  *draftCount = [HMDraftBoxDB getDraftBoxDBSendList:[BBUser getEncId] isSending:NO];
            if ([draftCount isNotEmpty])
            {
                [self.userInfoDic setObject:[NSString stringWithFormat:@"%d",draftCount.count] forKey:kDraftKey];
            }
            else
            {
                [self.userInfoDic setObject:[NSString stringWithFormat:@"%d",0] forKey:kDraftKey];
            }
            
            [self.listTable reloadData];
        }
        NSMutableString *getStr = [[NSMutableString alloc] initWithString:@"fruit_total,post_count,reply_count,avatar_url,mood_count,level,location_id,babybirthday,hospital,hasbaby,gender,nickname,konwledge_count,mom_father_relation,followed_count,follower_count,is_followed"];
        
        if (!self.s_SucceedGetUserInfo)
        {
            [self.progressHUD show:YES];
        }
        [self.userInfoRequest clearDelegatesAndCancel];
        self.userInfoRequest = [BBUserRequest getUserInfoWithID:self.userEncodeId param:getStr];
        [self.userInfoRequest setDidFinishSelector:@selector(updateUserInfoFinish:)];
        [self.userInfoRequest setDidFailSelector:@selector(updateUserInfoFail:)];
        [self.userInfoRequest setDelegate:self];
        [self.userInfoRequest startAsynchronous];
        self.s_IsPendingRequest = YES;
    }

}

- (NSMutableAttributedString*)combineString:(NSString *)string font:(UIFont*)font withString:(NSString*)appendString appendFont:(UIFont*)appendFont
{
    NSInteger length1 = [string length];
    
    NSInteger length2 = [appendString length];
    
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",string,appendString]];
    [contentText addAttribute:NSFontAttributeName
                        value:font
                        range:NSMakeRange(0, length1)];
    
    [contentText addAttribute:NSFontAttributeName
                        value:appendFont
                        range:NSMakeRange(length1, length2)];
    [contentText addAttribute:NSForegroundColorAttributeName
                        value:[UIColor whiteColor]
                        range:NSMakeRange(0, [contentText length])];
    return contentText;
}

- (void)setLocationShow
{
    //加载用户城市
    NSString *cityId = [BBUser getLocation];
    
    if ([cityId isNotEmpty])
    {
        NSString *tmpLocation = [BBAreaDB areaByCiytCode:cityId];
        if ([tmpLocation length]>12)
        {
            tmpLocation = [BBAreaDB getCityNameByCiytCode:cityId];
        }
        if ([tmpLocation isEqualToString:@""]||tmpLocation ==nil)
        {
            tmpLocation = @"未设置地区";
        }
        self.areaLabel.text = tmpLocation;
    }
    else
    {
        self.areaLabel.text = @"未设置地区";
    }
}

//判断是否需要上传头像
- (void)checkUploadAvatar
{
    if ([BBUser needUploadAvatar] && [BBUser isLogin]) {
        UIImage *imageAvatar = [[UIImage alloc] initWithContentsOfFile:[BBUser getLocalAvatar]];
        NSData *imageData = UIImageJPEGRepresentation(imageAvatar, 1.0);
        if (imageData) {
            [self.avatarUploadRequest clearDelegatesAndCancel];
            self.avatarUploadRequest = [BBTopicRequest uploadIcon:imageData withLoginString:[BBUser getLoginString]];
            [self.avatarUploadRequest setDidFinishSelector:@selector(avatarRequestFinish:)];
            [self.avatarUploadRequest setDidFailSelector:@selector(avatarRequestFail:)];
            [self.avatarUploadRequest setDelegate:self];
            [self.avatarUploadRequest startAsynchronous];
        }
    }
}

#pragma mark - interaction aciton

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionButtonPressed:(id)sender {
    
    if (self.isSelf || self.isToolBar)
    {
        
        if ([BBUser isLogin])
        {
            [self clickPersonalEdit];
        }
        else
        {
            [self goToLoginWithLoginType:LoginPersonalEdit];
        }

    }
}
- (IBAction)messageButtonPressed:(id)sender {
    if (!self.isSelf && !self.isToolBar)
    {
        if ([BBUser isLogin])
        {
            [self clickPersonalSendMessage];
        }
        else
        {
            [self goToLoginWithLoginType:LoginPersonalSendMessage];
        }

    }
}

- (IBAction)followListButtonPressed:(id)sender {
    [MobClick event:@"my_center_v2" label:@"关注点击"];
    if (self.isToolBar)
    {
        if ([BBUser isLogin])
        {
            [self clickPersonalFollowList];
        }
        else
        {
            [self goToLoginWithLoginType:LoginPersonalFollowList];
        }
    }
    else
    {
        [self clickPersonalFollowList];
    }
}

- (IBAction)fansListButtonPressed:(id)sender {
    [MobClick event:@"my_center_v2" label:@"粉丝点击"];
    if (self.isToolBar)
    {
        if ([BBUser isLogin])
        {
            [self clickPersonalFansList];
        }
        else
        {
            [self goToLoginWithLoginType:LoginPersonalFansList];
        }
    }
    else
    {
        [self clickPersonalFansList];
    }
}

-(void)clickPersonalFollowList
{
    BBRelationshipViewController *relation = [[BBRelationshipViewController alloc] init];
    relation.u_id = self.userEncodeId;
    relation.relationType = RelationType_Attention;
    relation.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:relation animated:YES];
}

-(void)clickPersonalFansList
{
    if([self isLoginAndSelfCenter])
    {
        [BBUser setUserNewFansCount:0];
        [ApplicationDelegate.m_mainTabbar hideTipPointWithIndex:MAIN_TAB_INDEX_PERSONCENTER];
    }
    BBRelationshipViewController *relation = [[BBRelationshipViewController alloc] init];
    relation.u_id = self.userEncodeId;
    relation.relationType = RelationType_Fans;
    relation.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:relation animated:YES];
}

-(void)clickPersonalSendMessage
{
    
    BBSendMessage *sendMessage = [[BBSendMessage alloc]initWithNibName:@"BBSendMessage" bundle:nil withUID:self.userEncodeId];
    sendMessage.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sendMessage animated:YES];
}

-(void)clickPersonalEdit
{
    //修改个人信息
    if (self.isPreparation) {
        BBPreparationEditViewController *editController = [[BBPreparationEditViewController alloc] initWithNibName:@"BBPreparationEditViewController" bundle:nil];
        editController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editController animated:YES];
    }else {
        [MobClick event:@"my_center_v2" label:@"编辑"];
        BBEditPersonalViewController *editController = [[BBEditPersonalViewController alloc] initWithNibName:@"BBEditPersonalViewController" bundle:nil];
        editController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editController animated:YES];
    }
}


- (IBAction)showFruitDetail:(id)sender {
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.isShowCloseButton = NO;
    [exteriorURL setLoadURL:@"http://m.babytree.com/rule/level.php"];
    [exteriorURL setTitle:@"等级和水果介绍"];
    exteriorURL.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:exteriorURL animated:YES];
}

- (IBAction)avatarAction:(id)sender
{
    if (self.isSelf || self.isToolBar)
    {
        if ([BBUser isLogin])
        {
            [self clickPersonalAvatar];
        }
        else
        {
            [self goToLoginWithLoginType:LoginPersonalAvatar];
        }
    }
}

-(void)clickPersonalAvatar
{
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePicker = [[UIImagePickerController alloc] init];
        [self.imagePicker setDelegate:self];
        [self.imagePicker setAllowsEditing:YES];
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:self.imagePicker animated:YES completion:^{
            
        }];
    }
    else
    {
        UIActionSheet *photoActionSheet = [[UIActionSheet alloc] initWithTitle:@"头像选择方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", @"拍照", nil];
        photoActionSheet.tag = 1;
        [photoActionSheet showInView:self.tabBarController.view];
    }
}

- (void)cameraBackAction:(id)sender
{
    UIButton *btn = sender;
    if (btn.tag == 1)
    {
        [self.imagePicker dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }
    else
    {
        [self.imagePicker popViewControllerAnimated:YES];
        
    }
}

- (void)loginFinish
{
    //这里防止在没有登录的情况下，单击了自己的头像，这里重新就判断当前页面是不是自己的个人中心。
    if (self.isToolBar)
    {
        if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
        {
            self.isPreparation = YES;
        }
        else
        {
            self.isPreparation = NO;
        }
        
        self.userEncodeId = [BBUser getEncId];
    }
    
    if ([self.userEncodeId isEqualToString:[BBUser getEncId]]) {
        if (!self.isSelf || self.isToolBar) {
            self.isSelf = YES;
            self.listTitleArray = [NSMutableArray arrayWithObjects:kTopicHistoryKey,kPostTopicKey,kReplyTopicKey,kCollectionKey,kDraftKey,nil];
            [self getUserInfo];
        }
    }
    

    if (self.s_LoginType == LoginPersonalAvatar)
    {
        return;
    }
    else if (self.s_LoginType == LoginPersonalEdit)
    {
        [self clickPersonalEdit];
    }
    else if (self.s_LoginType == LoginPersonalSendMessage)
    {
        [self clickPersonalSendMessage];
    }
    else if (self.s_LoginType == LoginPersonalPost)
    {
        [self clickPersonPostTopic];
    }
    else if (self.s_LoginType == LoginPersonalReply)
    {
        [self clickPersonReplyTopic];
    }
    else if (self.s_LoginType == LoginPersonalCollect)
    {
        [self clickPersonCollectTopic];
    }
    else if (self.s_LoginType == LoginPersonalDraftBox)
    {
        [self clickPersonDraftBox];
    }
    else if (self.s_LoginType == LoginPersonalFollowList)
    {
        [self clickPersonalFollowList];
    }
    else if (self.s_LoginType == LoginPersonalFansList)
    {
        [self clickPersonalFansList];
    }
    else if (self.s_LoginType == LoginPersonalFollowUser)
    {
        [self changeButtonStatus];
        //别人的个人中心，通过关注按钮点击，需要获取个人信息
        if(![self.userEncodeId isEqualToString:[BBUser getEncId]])
        {
            [self.followButton sendAttentionRequestWithType:AttentionType_Add_Attention];
        }
    }
}

#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1){
        UIImagePickerControllerSourceType sourceType = 0;
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else if (buttonIndex == 1) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            return;
        }
        self.imagePicker = [[UIImagePickerController alloc] init];
        [self.imagePicker setDelegate:self];
        [self.imagePicker setAllowsEditing:YES];
        [self.imagePicker setSourceType:sourceType];
        [self presentViewController:self.imagePicker animated:YES completion:^{
            
        }];
    }
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [BBImageScale imageScalingForSize:CGSizeMake(100, 100) withImage:[info objectForKey:UIImagePickerControllerEditedImage]];
    
    [self.avatarButton setImage:image forState:UIControlStateNormal];
    [self.avatarButton setImage:image forState:UIControlStateHighlighted];
    
    NSString  *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserAvatar.png"];
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:NO];
    [BBUser setLocalAvatar:imagePath];
    [BBUser setNeedUploadAvatar:YES];
    
    [self checkUploadAvatar];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UINavigationController Delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton setTag:[navigationController.viewControllers count]];
    [backButton addTarget:self action:@selector(cameraBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [viewController.navigationItem setLeftBarButtonItem:backBarButton];
    
    UIView *nilView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 32)];
    UIBarButtonItem *nilBarButton = [[UIBarButtonItem alloc] initWithCustomView:nilView];
    [viewController.navigationItem setRightBarButtonItem:nilBarButton];
    [viewController.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:viewController.navigationItem.title]];
    [viewController.navigationController setPregnancyColor];//设置导航栏颜色
    
}


#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listTitleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    BBPersonalListCell *cell = (BBPersonalListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[BBPersonalListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.titleLabel.text = [self.listTitleArray objectAtIndex:indexPath.row];
    if(indexPath.row == [self.listTitleArray count]-1)
    {
        cell.separatorLine.hidden = YES;
    }
    else
    {
        cell.separatorLine.hidden = NO;
    }
    if (self.isToolBar && ![BBUser isLogin])
    {
        cell.countLabel.text = @"";
        
    }
    else
    {
        if ([[self.userInfoDic objectForKey:[self.listTitleArray objectAtIndex:indexPath.row]] isNotEmpty])
        {
            cell.countLabel.text = [self.userInfoDic objectForKey:[self.listTitleArray objectAtIndex:indexPath.row]];
        }
        else if([[self.listTitleArray objectAtIndex:indexPath.row]isEqualToString:kTopicHistoryKey])
        {
            cell.countLabel.text = @"";
        }
        else
        {
            cell.countLabel.text = @"0";
        }
    }
    NSString *iconName = [self getIconNameForTitle:cell.titleLabel.text];
    cell.iconImageView.image = [UIImage imageNamed:iconName];
    return cell;
}

-(NSString *)getIconNameForTitle:(NSString *)title
{
    NSString *iconName = nil;
    if ([title isEqualToString:kPostTopicKey])
    {
        iconName = @"personal_publish_icon";
    }
    else if ([title isEqualToString:kReplyTopicKey])
    {
        iconName = @"personal_reply_icon";
    }
    else if ([title isEqualToString:kCollectionKey])
    {
        iconName = @"personal_shoucang_icon";
    }
    else if ([title isEqualToString:kMoodKey])
    {
        iconName = @"personal_mood_icon";
    }
    else if ([title isEqualToString:kDraftKey])
    {
        iconName = @"personal_draft_icon";
    }
    else if ([title isEqualToString:kTopicHistoryKey])
    {
        iconName = @"personal_history_icon";
    }
    return iconName;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //可以改成根据cell的title压新界面这样就不用判断是否自己的个人中心
    if (self.isSelf || self.isToolBar) {
        if (indexPath.row == 0)
        {
            [MobClick event:@"my_center_v2" label:@"最近浏览的帖子"];
            [self clickPersonHistoryTopic];
        }
        else if (indexPath.row == 1)
        {
            if (self.isToolBar && ![BBUser isLogin])
            {
                [self goToLoginWithLoginType:LoginPersonalPost];
            }
            else
            {
                [self clickPersonPostTopic];
            }
        }
        else if (indexPath.row == 2)
        {
            if (self.isToolBar && ![BBUser isLogin])
            {
                [self goToLoginWithLoginType:LoginPersonalReply];
            }
            else
            {
                [self clickPersonReplyTopic];
            }
        }
        else if (indexPath.row == 3)
        {
            if (self.isToolBar && ![BBUser isLogin])
            {
                [self goToLoginWithLoginType:LoginPersonalCollect];
            }
            else
            {
                [self clickPersonCollectTopic];
            }
        }
        else if (indexPath.row == 4)
        {
            if (self.isToolBar && ![BBUser isLogin])
            {
                [self goToLoginWithLoginType:LoginPersonalDraftBox];
            }
            else
            {
                [self clickPersonDraftBox];
            }
        }
        
    }else {
        if (indexPath.row == 2) {
            [MobClick event:@"other_center_v2" label:@"心情记录"];
            BBUserRecordMoon *recordMood = [[BBUserRecordMoon alloc] init];
            recordMood.userEncodeId = self.userEncodeId;
            recordMood.title = [NSString stringWithFormat:@"%@的心情记录",self.userName];
            recordMood.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:recordMood animated:YES];
            
        }else {
            BBUserPersonalTopicViewController *topicViewController = [[BBUserPersonalTopicViewController alloc] initWithNibName:@"BBUserPersonalTopicViewController" bundle:nil];
            topicViewController.userEncodeId = self.userEncodeId;
            if (indexPath.row == 0) {
                topicViewController.topicType = BBTOPIC_TYPE_POST;
                topicViewController.title = kPostTopicKey;
            } else if (indexPath.row == 1) {
                topicViewController.topicType = BBTOPIC_TYPE_REPLAY;
                topicViewController.title = kReplyTopicKey;
            }
            topicViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:topicViewController animated:YES];
        }
    }
}

- (void)clickPersonHistoryTopic
{
    BBTopicHistoryViewController *historyViewController = [[BBTopicHistoryViewController alloc] init];
    historyViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:historyViewController animated:YES];
}

-(void)clickPersonPostTopic
{
    BBUserPersonalTopicViewController *topicViewController = [[BBUserPersonalTopicViewController alloc] initWithNibName:@"BBUserPersonalTopicViewController" bundle:nil];
    topicViewController.userEncodeId = [BBUser getEncId];
    topicViewController.topicType = BBTOPIC_TYPE_POST;
    [MobClick event:@"my_center_v2" label:@"发表的帖子"];
    topicViewController.title = kPostTopicKey;
    topicViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:topicViewController animated:YES];

}
-(void)clickPersonReplyTopic
{
    BBUserPersonalTopicViewController *topicViewController = [[BBUserPersonalTopicViewController alloc] initWithNibName:@"BBUserPersonalTopicViewController" bundle:nil];
    topicViewController.userEncodeId = [BBUser getEncId];
    topicViewController.topicType = BBTOPIC_TYPE_REPLAY;
    [MobClick event:@"my_center_v2" label:@"回复的帖子"];
    topicViewController.title = kReplyTopicKey;
    topicViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:topicViewController animated:YES];
}
-(void)clickPersonCollectTopic
{
    [MobClick event:@"my_center_v2" label:@"我的收藏"];
    BBUserCollection *collectViewController = [[BBUserCollection alloc] initWithNibName:@"BBUserCollection" bundle:nil];
    collectViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collectViewController animated:YES];

}
-(void)clickPersonDraftBox
{
    HMDraftBoxViewController *draftBoxVC = [[HMDraftBoxViewController alloc] init];
    draftBoxVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:draftBoxVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}


#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.bgScrollView && scrollView.contentOffset.y < 0) {
        if (scrollView.contentOffset.y + kImageHiddenHeight < 0) {
            scrollView.contentOffset = CGPointMake(0, -kImageHiddenHeight);
            if (!self.s_IsPendingRequest)
            {
                [self getUserInfo];
            }
        }else {
            self.bgHeadImageView.frame = CGRectMake(0, -kImageHiddenHeight - scrollView.contentOffset.y, 320, CGRectGetHeight(self.bgHeadImageView.frame));
        }
    }else {
        self.bgHeadImageView.top = -scrollView.contentOffset.y - kImageHiddenHeight;
    }
}

#pragma mark - ASIHttpRequest delegate

- (void)updateUserInfoFinish:(ASIFormDataRequest *)request
{
    if (self.progressHUD.isShow)
    {
        [self.progressHUD hide:YES];
    }
    self.s_IsPendingRequest = NO;
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *requestData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
         [self showErrorWithWarning:@"数据加载失败，请下拉界面重新加载"];
        return;
    }
    
    if ([[requestData stringForKey:@"status"] isEqualToString:@"success"] || [[requestData stringForKey:@"status"] isEqualToString:@"1"])
    {
        NSDictionary *data = [requestData dictionaryForKey:@"data"];
        if ([data isNotEmpty]) {
            [self updateUIFrameAfterSuccessGetUserInfo];
            
            self.s_SucceedGetUserInfo = YES;
            self.followButton.u_id = self.userEncodeId;
            if ([BBUser isLogin] && [self.userEncodeId isEqualToString: [BBUser getEncId]]) {
                
                NSDictionary *bandInfo = [data dictionaryForKey:@"mom_father_relation"];
                if ([[bandInfo stringForKey:@"gender"] isEqualToString:@"1"])
                {
                    [BBUser setCurrentUserBabyFather:YES];
                }
                else
                {
                    [BBUser setCurrentUserBabyFather:NO];
                }
                if ([[bandInfo stringForKey:@"bind_status"] isEqualToString:@"1"])
                {
                    [BBUser setBandFatherStatus:YES];
                }
                else
                {
                    [BBUser setBandFatherStatus:NO];
                }
            }
            
            NSString *tmpFruit = [data stringForKey:@"fruit_total"];
            NSString *userRank = [data stringForKey:@"level_num"];
            NSString *postTopic = [data stringForKey:@"post_count"];
            NSString *replyTopic = [data stringForKey:@"reply_count"];
            NSString *collectionTopic = [data stringForKey:@"collection_count"];
            NSString *moodRecord = [data stringForKey:@"mood_count"];
            NSString *locationName = [data stringForKey:@"location_name"];
            NSString *collectionKnowledge = [data stringForKey:@"konwledge_count"];
            NSString *followedCount = [data stringForKey:@"followed_count" defaultString:@"0"];
            NSString *followerCount = [data stringForKey:@"follower_count" defaultString:@"0"];
            NSString *followStatus = [data stringForKey:@"is_followed" defaultString:@"4"];
            
            NSMutableAttributedString *followString = [self combineString:@"关注  " font:[UIFont systemFontOfSize:12] withString:([followedCount integerValue]>9999?@"9999+":followedCount) appendFont:[UIFont systemFontOfSize:14]];
            [self.followListButton setAttributedTitle:followString forState:UIControlStateNormal];
            NSMutableAttributedString *fansString = [self combineString:@"粉丝  " font:[UIFont systemFontOfSize:12] withString:([followerCount integerValue]>9999?@"9999+":followerCount) appendFont:[UIFont systemFontOfSize:14]];
            [self.fansListButton setAttributedTitle:fansString forState:UIControlStateNormal];
            
            [self.followButton freshAttentionStatus:[followStatus integerValue]];
            
            NSString *nickName = [data stringForKey:@"nickname"];
            if (self.userName == nil && [nickName isNotEmpty])
            {
                self.userName = nickName;
                [self setNav];
            }
            
            NSString *collectionCount = [NSString stringWithFormat:@"%d",[collectionTopic integerValue]+[collectionKnowledge integerValue]];
            
            if ([tmpFruit isNotEmpty]) {
                self.fruitLabel.text = [NSString stringWithFormat:@"%@", tmpFruit];
            }
            if ([userRank isNotEmpty]) {
                userRank = [NSString stringWithFormat:@"LV.%@",userRank];
                self.levelLabel.text = userRank;
                [BBUser setUserLevel:userRank];
            }
            
            if ([postTopic isNotEmpty]) {
                [self.userInfoDic setObject:postTopic forKey:kPostTopicKey];
            }
            
            if ([replyTopic isNotEmpty]) {
                [self.userInfoDic setObject:replyTopic forKey:kReplyTopicKey];
            }
            
            if ([collectionCount isNotEmpty]) {
                [self.userInfoDic setObject:collectionCount forKey:kCollectionKey];
            }
            
            if ([moodRecord isNotEmpty]) {
                [self.userInfoDic setObject:moodRecord forKey:kMoodKey];
            }
            
        
            
            if ([locationName isNotEmpty]) {
                self.areaLabel.text = locationName;
            }else {
                self.areaLabel.text = @"未设置地区";
            }
            
            NSDictionary *dic = [data dictionaryForKey:@"hospital"];
            if ([dic isNotEmpty]) {
                NSString *hospitalName = [dic stringForKey:@"hospital_name"];
                if ([hospitalName isNotEmpty]) {
                    self.hospitalLabel.text = hospitalName;
                }else {
                    self.hospitalLabel.text = @"未设置医院";
                }
            }else {
                self.hospitalLabel.text = @"未设置医院";
            }
            
            if ([[data stringForKey:@"avatar_url"] isNotEmpty])
            {
                if (self.isToolBar || self.isSelf)
                {
                    [BBUser setAvatarUrl:[data stringForKey:@"avatar_url"]];
                }
                [self.avatarButton setImageWithURL:[NSURL URLWithString:[data stringForKey:@"avatar_url"]] placeholderImage:[UIImage imageNamed:@"personal_default_avatar"]];
            }
            
            if ([[data stringForKey:@"hasbaby"] isEqualToString:@"true"]) {
                self.dueDateLable.text = [BBTimeUtility babyAgeWithDueDate:[data stringForKey:@"babybirthday"]];
            }else {
                if ([[data stringForKey:@"hasbaby"] isEqualToString:@"preg"]) {
                    if ([[data stringForKey:@"babybirthday"] isNotEmpty]) {
                        if ([self.userEncodeId isEqualToString:[BBUser getEncId]]) {
                            [self updateInfo];
                        }else {
                            self.dueDateLable.text = [NSString stringWithFormat:@"%@",[BBTimeUtility babyAgeWithDueDate:[data stringForKey:@"babybirthday"]]];
                        }
                    }else {
                        self.dueDateLable.text = @"未设置预产期";
                    }
                    
                }else if ([[data stringForKey:@"hasbaby"] isEqualToString:@"prepare"]) {
                    self.dueDateLable.text = @"备孕中";
                }else {
                    if ([[data stringForKey:@"babybirthday"] isNotEmpty]) {
                        if ([self.userEncodeId isEqualToString:[BBUser getEncId]]) {
                            [self updateInfo];
                        }else {
                            self.dueDateLable.text = [NSString stringWithFormat:@"%@",[BBTimeUtility babyAgeWithDueDate:[data stringForKey:@"babybirthday"]]];
                        }
                    }else {
                        self.dueDateLable.text = @"未设置预产期";
                    }
                }
            }
            
            if ([self.userEncodeId isEqualToString:[BBUser getEncId]]) {
                [self updateInfo];
            }
            
        }
    }
    [self.listTable reloadData];
}

- (void)updateUserInfoFail:(ASIFormDataRequest *)request
{
    if (self.progressHUD.isShow)
    {
        [self.progressHUD hide:YES];
    }
    self.s_IsPendingRequest = NO;
    [self updateUIFrameAfterFailGetUserInfo];
    [self showErrorWithWarning:@"亲，你的网络不给力"];
}

#pragma mark - ASIHttpRequest Delegate Request

- (void)avatarRequestFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"]) {
        [BBUser setAvatarUrl:[[data dictionaryForKey:@"data"] stringForKey:@"url"]];
        [BBUser setNeedRefreshNotificationList:YES];
        [BBUser setNeedUploadAvatar:NO];
        [self checkUpdateAvatarUrl];
    }
}

- (void)avatarRequestFail:(ASIFormDataRequest *)request
{
    
}

-(IBAction)clickedLogin:(id)sender
{
    if (![BBUser isLogin]) {
        BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
        login.delegate = self;
        login.m_LoginType = BBPresentLogin;
        BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
        [navCtrl setColorWithImageName:@"navigationBg"];
        [self  presentViewController:navCtrl animated:YES completion:^{
            
        }];
        return;
    }
}

#pragma Mark -- setView delegate
-(void)modifyPresonalCenter
{
    if (![BBUser isLogin])
    {
        [self setSubViews];
        [self getUserInfo];
        [self checkUpdateAvatarUrl];
    }
    else
    {
        if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
        {
            self.isPreparation = YES;
        }
        else
        {
            self.isPreparation = NO;
        }
        self.userEncodeId = [BBUser getEncId];
        self.isSelf = YES;
        self.listTitleArray = [NSMutableArray arrayWithObjects:kTopicHistoryKey, kPostTopicKey,kReplyTopicKey,kCollectionKey,kDraftKey,nil];
        [self getUserInfo];
        [self checkUpdateAvatarUrl];

    }
}
#pragma mark - BBAttentionButton Delegate

- (BOOL)shouldAddAttention
{
    if ([BBUser isLogin])
    {
        return YES;
    }
    else
    {
        [self goToLoginWithLoginType:LoginPersonalFollowUser];
        return NO;
    }
}

- (void)changeAttentionStatusFinish:(BBAttentionButton *)button withAttentionType:(AttentionType)type
{
    NSString *attentionText;
    if(type == AttentionType_Add_Attention || type == AttentionType_Be_Attention)
    {
        attentionText = @"√ 已取消关注";
    }
    else if(type == AttentionType_Had_Attention || type == AttentionType_Both_Attention)
    {
        attentionText = @"√ 已关注";
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:NO withText:attentionText delay:1];
    [self getUserInfo];
}

- (void)changeAttentionStatusFail:(BBAttentionButton *)button withAttentionType:(AttentionType)type
{
    NSString *attentionText;
    if(type == AttentionType_Add_Attention || type == AttentionType_Be_Attention)
    {
        attentionText = @"加关注失败";
    }
    else if(type == AttentionType_Had_Attention || type == AttentionType_Both_Attention)
    {
        attentionText = @"取消关注失败";
    }
    //[self.progressHUD show:NO withText:attentionText delay:1];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:NO withText:attentionText delay:1];
}

#pragma Mark -- change role status notification

-(void)changePrePare
{
    self.isPreparation = YES;
    [self setSubViews];
    [self getUserInfo];
    [self checkUpdateAvatarUrl];
}

-(void)changePregnancy
{
    self.isPreparation = NO;
    [self setSubViews];
    [self getUserInfo];
    [self checkUpdateAvatarUrl];
}


- (void)goToLoginWithLoginType:(LoginType)theLoginType
{
    BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
    login.m_LoginType = BBPresentLogin;
    BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
    [navCtrl setColorWithImageName:@"navigationBg"];
    self.s_LoginType = theLoginType;
    login.delegate = self;
    [self.navigationController  presentViewController:navCtrl animated:YES completion:^{
        
    }];
    return ;
}

@end
