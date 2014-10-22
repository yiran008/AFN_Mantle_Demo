//
//  BBSign.m
//  pregnancy
//
//  Created by babytree on 12-11-30.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBSign.h"
#import "SBJsonParser.h"
#import "AlertUtil.h"
#import "UIImageView+WebCache.h"
#import "BBApp.h"
#import "BBNavigationLabel.h"
#import "MobClick.h"
#import "BBStatisticsUtil.h"
#import "BBAppConfig.h"
#import "BBUser.h"
#import "BBSupportTopicDetail.h"
#import "BBPrizeRequest.h"
#import "BBFatherInfo.h"
#import "BBCustomsAlertView.h"
#import "HMShowPage.h"

@interface BBSign ()

@property (assign) BOOL s_isFirstView;
@property (assign) float extraAdd;
@property (nonatomic,strong) NSDictionary * urlDic;

@end

@implementation BBSign
@synthesize treeImageView;
@synthesize progressImageView;
@synthesize signRequest;
@synthesize userInfoRequest;
@synthesize hud;
@synthesize userPrizeInfo;
@synthesize preValueLabel;
@synthesize signLabel1;
@synthesize signLabel2;
@synthesize scrollView;
@synthesize signButton;
@synthesize gradeDescLabel;
@synthesize badgeScrollView;

@synthesize papaLabel1;
@synthesize papaLabel2;
@synthesize papaLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"签到加孕气";
        self.s_isFirstView = YES;
    }
    return self;
}

- (void)dealloc
{
    [signRequest clearDelegatesAndCancel];
    [userInfoRequest clearDelegatesAndCancel];
    [_popLayerRequest clearDelegatesAndCancel];
}

-(UIView*)getBadgeImages:(UIImage*)imageName{
    UIView  *prizeimage=[[UIView alloc]init];
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 55, 55)];
    [iv setImage:imageName];
    iv.tag=0;
    UILabel *signLabelOne = [[UILabel alloc]init];
    [signLabelOne setFrame:CGRectMake(0, 60, 45,21)];
    signLabelOne.textAlignment = NSTextAlignmentRight;
    [signLabelOne setFont:[UIFont systemFontOfSize:15]];
    [signLabelOne setTextColor:[UIColor colorWithRed:255/255.0 green:60/255.0 blue:60/255.0 alpha:1.0]];
    [signLabelOne setBackgroundColor:[UIColor clearColor]];
    signLabelOne.tag=1;
    UILabel *signlabelTwo = [[UILabel alloc]init];
    [signlabelTwo setFrame:CGRectMake(45, 60, 35, 21)];
    [signlabelTwo setFont:[UIFont systemFontOfSize:15]];
    [signlabelTwo setTextColor:[UIColor colorWithRed:143/255.0 green:105/255.0 blue:105/255.0 alpha:1.0]];
    [signlabelTwo setText:@"孕气"];
    signlabelTwo.tag=2;
    [signlabelTwo setBackgroundColor:[UIColor clearColor]];
    UILabel *signLabelThr = [[UILabel alloc]init];
    [signLabelThr setFrame:CGRectMake(18, 77, 60, 21)];
    signLabelThr.textAlignment = NSTextAlignmentCenter;
    [signLabelThr setFont:[UIFont systemFontOfSize:15]];
    [signLabelThr setTextColor:[UIColor colorWithRed:38/255.0 green:106/255.0 blue:14/255.0 alpha:1.0]];
    [signLabelThr setBackgroundColor:[UIColor clearColor]];
    [signLabelThr setText:@"可获得"];
    signLabelThr.tag=3;
    [prizeimage addSubview:iv];
    [prizeimage addSubview:signLabelOne];
    [prizeimage addSubview:signlabelTwo];
    [prizeimage addSubview:signLabelThr];
    
    return prizeimage;
}
-(void)deriveImage:(int)currentPrevalue{
    //显示的徽章图标数组
    NSArray *dreBadgeImageNames=[NSArray arrayWithObjects:@"sign_dre1",@"sign_dre2",@"sign_dre3",@"sign_dre4",@"sign_dre5",@"sign_dre6",@"sign_dre7",@"sign_dre8" ,nil];
    //可获得的孕气值数组
    NSArray *numArray=[NSArray arrayWithObjects:@"50",@"200",@"1000",@"3000",@"5000",@"7000",@"10000",@"15000", nil];
    //获取徽章视图的所有子视图数组
    NSArray *prizeimage=[badgeScrollView subviews];
    //遍历子视图数组
    for (UIView *prizeview in prizeimage) {
        //遍历子视图上对应的控件视图数组
        for (UIView *currentView in [prizeview subviews]) {
            //判断当前视图的类型  并根据对应的父视图的tag值获取当前视图的索引值
            if ([currentView isKindOfClass:[UIImageView class]] && currentPrevalue>=[[numArray objectAtIndex:prizeview.tag] intValue]) {
                [(UIImageView*)currentView setImage:[UIImage imageNamed:[dreBadgeImageNames objectAtIndex:prizeview.tag]]];
                //判断当前视图的类型  并根据对应的父视图的tag值获取当前视图的索引值
            } else if ([currentView isKindOfClass:[UILabel class]]){
                UILabel  *currentLabel=(UILabel*)currentView;
                //根据当前视图的tag值设置对应label的值，通过父视图的tag获取对应数组的索引值
                if (currentLabel.tag == 1) {
                    [currentLabel setText:[numArray objectAtIndex:prizeview.tag]];
                }  else if (currentLabel.tag == 3){
                    if (currentPrevalue>=[[numArray objectAtIndex:prizeview.tag] intValue]) {
                        [currentLabel setText:@"已获得"];
                    }
                }
            }
        }
    }
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self sendPopLayerRequest];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    if (![BBUser isCurrentUserBabyFather])
    {
        self.extraAdd = 30.f;
        UIButton *activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [activityBtn setFrame:CGRectMake(82, papaLabel2.top + self.extraAdd, 155, 35)];
        [activityBtn setBackgroundImage:[UIImage imageNamed:@"mother_invite_btn_normal"] forState:UIControlStateNormal];
        [activityBtn setBackgroundImage:[UIImage imageNamed:@"mother_invite_btn_highlight"] forState:UIControlStateHighlighted];
        [activityBtn setTitle:@"每天抽奖，百分百中奖!" forState:UIControlStateNormal];
        activityBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        [activityBtn addTarget:self action:@selector(activityAction:) forControlEvents:UIControlEventTouchUpInside];
        activityBtn.exclusiveTouch = YES;
        [scrollView addSubview:activityBtn];
    }else
    {
        self.extraAdd = 0.f;
    }

    
    float activityHeight = 40.0f + self.extraAdd;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    
    self.signLabel1 = [[OHAttributedLabel alloc] init];
    [signLabel1 setFont:[UIFont systemFontOfSize:12]];
    [signLabel1 setTextColor:[UIColor colorWithRed:143/255.0 green:105/255.0 blue:105/255.0 alpha:1.0]];
    [signLabel1 setBackgroundColor:[UIColor clearColor]];
    [signLabel1 setFrame:CGRectMake(80, 50, 190, 21)];
    [scrollView addSubview:signLabel1];
    
    self.signLabel2 = [[OHAttributedLabel alloc] init];
    [signLabel2 setFont:[UIFont systemFontOfSize:12]];
    [signLabel2 setTextColor:[UIColor colorWithRed:143/255.0 green:105/255.0 blue:105/255.0 alpha:1.0]];
    [signLabel2 setBackgroundColor:[UIColor clearColor]];
    [signLabel2 setFrame:CGRectMake(78, 67, 170, 21)];
    [scrollView addSubview:signLabel2];
    signButton.exclusiveTouch = YES;
    papaLabel1.top += activityHeight;
    preValueLabel.top += activityHeight;
    papaLabel2.top += activityHeight;
    self.presentLabel.top +=activityHeight;
//    [self refreshCreateView];
    //iphone5适配
    IPHONE5_ADAPTATION
    if (IS_IPHONE5) {
        [scrollView setFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height + 88)];
    }
}

-(void)refreshCreateView
{
    CGFloat addHeight = 0.0f;
    if([BBUser isCurrentUserBabyFather])
    {
        [signButton setBackgroundImage:[UIImage imageNamed:@"submit_user_info"] forState:UIControlStateNormal];
        [signButton setTitle:@"给准妈妈加孕气" forState:UIControlStateNormal];
        
        [self.view viewWithTag:1101].height = 0;
        [(UIButton*)[self.view viewWithTag:1101] setTitle:@"" forState:UIControlStateNormal];
        [[self.view viewWithTag:1001] removeFromSuperview];
    }
    else
    {
        if (![BBUser isBandFatherStatus])
        {
            UIButton *papaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            papaBtn.exclusiveTouch = YES;
            [papaBtn setFrame:CGRectMake(82, papaLabel2.top, 155, 35)];
            [papaBtn setBackgroundImage:[UIImage imageNamed:@"mother_invite_btn_normal"] forState:UIControlStateNormal];
            [papaBtn setBackgroundImage:[UIImage imageNamed:@"mother_invite_btn_highlight"] forState:UIControlStateHighlighted];
            [papaBtn setTitle:@"邀请准爸爸一起集孕气" forState:UIControlStateNormal];
            papaBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            papaBtn.tag = 1101;
            [papaBtn addTarget:self action:@selector(invitePapa:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:papaBtn];
        }
        else
        {
            self.papaLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(80, papaLabel2.top+15, 220, 35)];
            papaLabel.backgroundColor = [UIColor clearColor];
            [papaLabel setFont:[UIFont systemFontOfSize:14]];
            NSMutableAttributedString *papaLabelAttri = nil;
            NSString *str = [BBFatherInfo getPapaYunqi];
            NSString *string = [NSString stringWithFormat:@"准爸爸共为您加了%@孕气", str];
            papaLabelAttri = [NSMutableAttributedString attributedStringWithString:string];
            [papaLabelAttri setTextIsUnderlined:NO];
            [papaLabelAttri setTextColor:[UIColor blueColor]];
            [papaLabelAttri setTextColor:[UIColor colorWithRed:255/255.0 green:60/255.0 blue:60/255.0 alpha:1.0] range:[string rangeOfString:str]];
            [papaLabelAttri setFont:[UIFont systemFontOfSize:14]];
            [papaLabel setAttributedText:papaLabelAttri];
            papaLabel.textAlignment = NSTextAlignmentCenter;
            
            [scrollView addSubview:papaLabel];
        }
        addHeight = 45.0f;
    }
    papaLabel1.top += addHeight;
    preValueLabel.top += addHeight;
    papaLabel2.top += addHeight;
    self.presentLabel.top +=addHeight;
    [self addBagePrize:addHeight+self.extraAdd];
}

-(void)addBagePrize:(CGFloat)addHeight
{
    if (!self.badgeScrollView)
    {
        NSArray *preBadgeImageNames=[NSArray arrayWithObjects:@"sign_pre1",@"sign_pre2",@"sign_pre3",@"sign_pre4",@"sign_pre5",@"sign_pre6",@"sign_pre7",@"sign_pre8" ,nil];
        self.badgeScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 430+addHeight, 320, 110)];
        [badgeScrollView setContentSize:CGSizeMake(640, 110)];
        badgeScrollView.showsHorizontalScrollIndicator=YES;
        badgeScrollView.showsVerticalScrollIndicator=NO;
        [badgeScrollView setUserInteractionEnabled:YES];
        for (int i=0; i<[preBadgeImageNames count]; i++) {
            UIView *prizecurrentview=[self getBadgeImages:[UIImage imageNamed:[preBadgeImageNames objectAtIndex:i]]];
            prizecurrentview.tag=i;
            prizecurrentview.frame=CGRectMake(i*80, 0, 80, 110);
            [badgeScrollView addSubview:prizecurrentview];
        }
        [scrollView setContentSize:CGSizeMake(320, 540+addHeight)];
        [scrollView addSubview:badgeScrollView];
    }
    else
    {
         [self.badgeScrollView setFrame:CGRectMake(0, 430+addHeight, 320, 110)];
         [scrollView setContentSize:CGSizeMake(320, 540+addHeight)];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prizeInfoRequest];
}

-(void)prizeInfoRequest
{
    hud.labelText =@"加载中...";
    [hud show:YES];
    [self sendPrizeRequest];
}

-(void)sendPrizeRequest
{
    [self.userInfoRequest clearDelegatesAndCancel];
    self.userInfoRequest = [BBPrizeRequest prizeUserInfo];
    [self.userInfoRequest setDelegate:self];
    [self.userInfoRequest setDidFailSelector:@selector(userInfoRequestFailed:)];
    [self.userInfoRequest setDidFinishSelector:@selector(userInfoRequestFinished:)];
    [self.userInfoRequest startAsynchronous];
}

#pragma mark - 弹层请求数据
-(void)sendPopLayerRequest
{
    [self.popLayerRequest clearDelegatesAndCancel];
    self.popLayerRequest = [BBPrizeRequest popLayerRequest];
    [self.popLayerRequest setDelegate:self];
    [self.popLayerRequest setDidFinishSelector:@selector(popLayerRequestFinished:)];
    [self.popLayerRequest setDidFailSelector:@selector(popLayerRequestFailed:)];
    [self.popLayerRequest startAsynchronous];
}

#pragma mark - 点击签到额外增加孕气的弹框

-(void)additionalPrize:(NSString *)theStr
{
    MBProgressHUD *theHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [theHud show:NO withText:theStr delay:3];
}

#pragma mark - 点击签到按钮
- (IBAction)touchUpInsideSignIn:(id)sender
{
    if (userPrizeInfo) {
        if ([[userPrizeInfo stringForKey:@"is_sign"] isEqualToString:@"0"])
        {
            hud.labelText =@"请求中...";
            [hud show:YES];
            [self.signRequest clearDelegatesAndCancel];
            self.signRequest = [BBPrizeRequest prizeSign];
            [self.signRequest setDelegate:self];
            [self.signRequest setDidFailSelector:@selector(signRequestFailed:)];
            [self.signRequest setDidFinishSelector:@selector(signRequestFinished:)];
            [self.signRequest startAsynchronous];
            
        }
    }
    
    if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
    {
        if(![BBUser isCurrentUserBabyFather])
        {
            [MobClick event:@"checkin_prepare_v2" label:@"签到领孕气"];
        }
        else
        {
            [MobClick event:@"invite_husband_v2" label:@"给准妈妈加孕气"];
        }
        
    }
    else if([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
    {
        if(![BBUser isCurrentUserBabyFather])
        {
            [MobClick event:@"checkin_baby_v2" label:@"签到领孕气"];
        }
        else
        {
            [MobClick event:@"invite_husband_v2" label:@"给准妈妈加孕气"];
        }
        
    }
    else
    {
        if(![BBUser isCurrentUserBabyFather])
        {
            [MobClick event:@"checkin_pregnant_v2" label:@"签到领孕气"];
        }
        else
        {
            [MobClick event:@"invite_husband_v2" label:@"给准妈妈加孕气"];
        }
    }
}

#pragma mark - IBAction Event Handler Mehthod

- (IBAction)backAction:(id)sender
{
    if (self.m_SignType == BBPushSign)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
- (void)activityAction:(id)sender
{
    if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
    {
        [MobClick event:@"checkin_pregnant_v2" label:@"精彩活动"];
    }
    else if([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
    {
        [MobClick event:@"checkin_baby_v2" label:@"精彩活动"];
    }
    else
    {
        [MobClick event:@"checkin_prepare_v2" label:@"精彩活动"];
    }
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    [exteriorURL setLoadURL:[BBUser getNewUserRoleState] == BBUserRoleStateHasBaby?@"http://m.babytree.com/promo/parenting.php":@"http://m.babytree.com/promo/pregnancy.php"];
    [self.navigationController pushViewController:exteriorURL animated:YES];
}

#pragma mark - btn delegate 

-(void)clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex && [_urlDic isDictionaryAndNotEmpty] && [[_urlDic stringForKey:@"url_type"] isNotEmpty])
    {
        if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
        {
            [MobClick event:@"checkin_pregnant_v2" label:@"活动弹层跳转按钮点击次数"];
        }
        else if([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
        {
            [MobClick event:@"checkin_baby_v2" label:@"活动弹层跳转按钮点击次数"];
        }
        else
        {
            [MobClick event:@"checkin_prepare_v2" label:@"活动弹层跳转按钮点击次数"];
        }

        if([[_urlDic stringForKey:@"url_type"] intValue] == 2)
        {
            if([[_urlDic stringForKey:@"btn_url"] isNotEmpty])
            {
                BBSupportTopicDetail *popTheView = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
                [popTheView.navigationItem setTitle:[_urlDic stringForKey:@"navTitle"]];
                [popTheView setLoadURL:[_urlDic stringForKey:@"btn_url"]];
                popTheView.isShowCloseButton = NO;
                [self.navigationController pushViewController:popTheView animated:YES];
            }
        }
        else if([[_urlDic stringForKey:@"url_type"] intValue] == 1)
        {
            if([[_urlDic stringForKey:@"topicID"] isNotEmpty])
            {
                [BBStatistic visitType:BABYTREE_TYPE_TOPIC_SIGN contentId:[_urlDic stringForKey:@"topicID"]];
                [HMShowPage showTopicDetail:self topicId:[_urlDic stringForKey:@"topicID"] topicTitle:nil];
            }
        }
    }
}

#pragma mark - ASIHttpRequest Delegate
- (void)userInfoRequestFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *responseData = [parser objectWithString:responseString error:&error];
    if (!hud.isHidden) {
        [hud hide:YES];
    }
    if (error != nil) {
        return;
    }
    NSString *status =[responseData stringForKey:@"status"] ;
    if ([status isEqualToString:@"success"]) {
        NSDictionary *bandInfo = [[responseData dictionaryForKey:@"data"] dictionaryForKey:@"mom_father_relation"];
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
        
        if (self.s_isFirstView)
        {
            self.s_isFirstView = NO;
            [self refreshCreateView];
        }
        
        self.userPrizeInfo = [[responseData dictionaryForKey:@"data"]dictionaryForKey:@"user_info"];
        NSString *profileImg = [self.userPrizeInfo stringForKey:@"tree_image"];
        if (profileImg!=nil && ![profileImg isEqual:[NSNull null]]) {
            [treeImageView setImageWithURL:[NSURL URLWithString:profileImg]
                          placeholderImage:nil];
        }
        
        if (![BBUser isCurrentUserBabyFather]) {
            NSMutableAttributedString *topicTitleAttri = nil;
            NSString *titleString = [NSString stringWithFormat:@"签到获得%@孕气，已连续签到%@天", [userPrizeInfo stringForKey:@"sign_value"], [userPrizeInfo stringForKey:@"sign_days"]];
            topicTitleAttri = [NSMutableAttributedString attributedStringWithString:titleString];
            [topicTitleAttri setTextIsUnderlined:NO];
            [topicTitleAttri setTextColor:[UIColor colorWithRed:143/255.0 green:105/255.0 blue:105/255.0 alpha:1.0]];
            [topicTitleAttri setTextColor:[UIColor colorWithRed:255/255.0 green:60/255.0 blue:60/255.0 alpha:1.0] range:[titleString rangeOfString:[userPrizeInfo stringForKey:@"sign_value"]]];
            [topicTitleAttri setTextColor:[UIColor colorWithRed:255/255.0 green:60/255.0 blue:60/255.0 alpha:1.0] range:[titleString rangeOfString:[userPrizeInfo stringForKey:@"sign_days"]]];
            [topicTitleAttri setFont:[UIFont systemFontOfSize:11]];
            [signLabel1 setAttributedText:topicTitleAttri];
            
            NSMutableAttributedString *topicTitleAttri2 = nil;
            NSString *str = @"50";
            NSString *titleString2 = [NSString stringWithFormat:@"连续签到7天以上每次获得%@孕气", str];
            topicTitleAttri2 = [NSMutableAttributedString attributedStringWithString:titleString2];
            [topicTitleAttri2 setTextIsUnderlined:NO];
            [topicTitleAttri2 setTextColor:[UIColor colorWithRed:143/255.0 green:105/255.0 blue:105/255.0 alpha:1.0]];
            [topicTitleAttri2 setTextColor:[UIColor colorWithRed:255/255.0 green:60/255.0 blue:60/255.0 alpha:1.0] range:[titleString2 rangeOfString:str]];
            [topicTitleAttri2 setFont:[UIFont systemFontOfSize:11]];
            [signLabel2 setAttributedText:topicTitleAttri2];
            self.papaLabel1.text = @"我的孕气值:";
        }
        else
        {
            self.papaLabel1.text = @"老婆的孕气值:";
        }
        
//        OHAttributedLabel * label3 = [[OHAttributedLabel alloc] init];
//        [label3 setFont:[UIFont systemFontOfSize:11]];
//        [label3 setTextColor:[UIColor colorWithRed:143/255.0 green:105/255.0 blue:105/255.0 alpha:1.0]];
//        [label3 setBackgroundColor:[UIColor clearColor]];
//        [label3 setFrame:CGRectMake(38, 82, 270, 21)];
//        label3.text = @"【四月签到赢大奖 iPadmini、京东卡等你拿】";
//        [scrollView addSubview:label3];
//        
//        OHAttributedLabel * label4 = [[OHAttributedLabel alloc] init];
//        [label4 setFont:[UIFont systemFontOfSize:11]];
//        [label4 setTextColor:[UIColor colorWithRed:143/255.0 green:105/255.0 blue:105/255.0 alpha:1.0]];
//        [label4 setBackgroundColor:[UIColor clearColor]];
//        [label4 setFrame:CGRectMake(66, 98, 263, 21)];
//        label4.text = @"获奖机会多多，点击下方按钮参加";
//        [scrollView addSubview:label4];
        
        
        NSString *preStr= [self.userPrizeInfo stringForKey:@"full_yunqi_num"];
        if (preStr ==nil || [preStr isEqualToString:@""]) {
        }else{
            NSMutableAttributedString *presentTitleAttri= nil;
            NSString *presentString = [NSString stringWithFormat:@"已经有%@个妈妈集满孕气", preStr];
            presentTitleAttri = [NSMutableAttributedString attributedStringWithString:presentString];
            [presentTitleAttri setTextIsUnderlined:NO];
            [presentTitleAttri setBBTextAlignment:kCTTextAlignmentCenter lineBreakMode:kCTLineBreakByWordWrapping];
            [presentTitleAttri setTextColor:[UIColor colorWithRed:143/255.0 green:105/255.0 blue:105/255.0 alpha:1.0]];
            [presentTitleAttri setTextColor:[UIColor colorWithRed:255/255.0 green:60/255.0 blue:60/255.0 alpha:1.0] range:[presentString rangeOfString:preStr]];
            [self.presentLabel setAttributedText:presentTitleAttri];
        }

        [self.preValueLabel setText:[userPrizeInfo stringForKey:@"pre_value"]];
        
        if([BBUser isCurrentUserBabyFather])
        {
            if ([[userPrizeInfo stringForKey:@"is_sign"] isEqualToString:@"0"]) {
                [signButton setBackgroundImage:[UIImage imageNamed:@"submit_user_info"] forState:UIControlStateNormal];
                [signButton setTitle:@"给准妈妈加孕气" forState:UIControlStateNormal];
            }else{
                [signButton setBackgroundImage:[UIImage imageNamed:@"prize_lotteried"] forState:UIControlStateNormal];
                [signButton setTitle:@"给准妈妈加孕气" forState:UIControlStateNormal];
                [BBUser setTodaySignState];
            }
        }
        else
        {
            if ([[userPrizeInfo stringForKey:@"is_sign"] isEqualToString:@"0"]) {
                [signButton setBackgroundImage:[UIImage imageNamed:@"submit_user_info"] forState:UIControlStateNormal];
                [signButton setTitle:@"签到领孕气" forState:UIControlStateNormal];
            }else{
                [signButton setBackgroundImage:[UIImage imageNamed:@"prize_lotteried"] forState:UIControlStateNormal];
                [signButton setTitle:@"您已签到" forState:UIControlStateNormal];
                [BBUser setTodaySignState];
            }
        }
        UIImage *backgroundImage = nil;
        if ([[UIImage imageNamed:@"topicBg"] respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
            backgroundImage = [[UIImage imageNamed:@"prize_progress"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        } else {
            backgroundImage = [[UIImage imageNamed:@"prize_progress"] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
        }
        [self.progressImageView setImage:backgroundImage];
        int prevalue = [[userPrizeInfo stringForKey:@"pre_value"] intValue];
        [self deriveImage:prevalue];
        
        float percent=0;
        //定义等级数组
        NSArray *gradeArray=[NSArray arrayWithObjects:@"L0",@"L1",@"L2",@"L3",@"L4",@"L5",@"L6",@"L7",@"L8", nil];
        //定义对应等级数组的值
        NSArray *prevalues=[NSArray arrayWithObjects:@"0",@"50",@"200",@"1000",@"3000",@"5000",@"7000",@"10000", @"15000",nil];
        //遍历数组的是和当前孕气的值进行比较设置视图对象
        for (int i= [prevalues count]-1; i>0; i--) {
            //判断最大值情况
            if (prevalue >= 15000) {
                percent=1.0f;
                //索引到等级数组的最大值
                [gradeDescLabel setText:[gradeArray objectAtIndex:[gradeArray count]-1]];
                break;
                //判断当前的孕气值对应的等级的百分比视图
            }else if (prevalue >= [[prevalues objectAtIndex:i-1] floatValue]) {
                //获取到当前的分母值
                float tempValue=[[prevalues objectAtIndex:i] floatValue] - [[prevalues objectAtIndex:i-1] floatValue];
                //获取当前的百分比 并获取当前等级的索引值
                percent=(prevalue - [[prevalues objectAtIndex:i-1] floatValue])/tempValue;
                [gradeDescLabel setText:[gradeArray objectAtIndex:i-1]];
                break;
            }
        }
        int height = 93.0 * percent;
        if (height<=6) {
            height=6;
        }
        [self.progressImageView setFrame:CGRectMake(272, 321-height, 8, height)];
        if(![BBUser isCurrentUserBabyFather] && [BBUser isBandFatherStatus])
        {
            NSMutableAttributedString *papaLabelAttri = nil;
            NSString *papastr = [userPrizeInfo stringForKey:@"baba_yunqi"];
            [BBFatherInfo setPapaYunqi:papastr];
            NSString *string = [NSString stringWithFormat:@"准爸爸共为您加了%@孕气", papastr];
            papaLabelAttri = [NSMutableAttributedString attributedStringWithString:string];
            [papaLabelAttri setTextIsUnderlined:NO];
            [papaLabelAttri setTextColor:[UIColor blueColor]];
            [papaLabelAttri setTextColor:[UIColor colorWithRed:255/255.0 green:60/255.0 blue:60/255.0 alpha:1.0] range:[string rangeOfString:papastr]];
            [papaLabelAttri setFont:[UIFont systemFontOfSize:14]];
            [papaLabel setAttributedText:papaLabelAttri];
            papaLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    else
    {
        [AlertUtil showAlert:@"提示！" withMessage:status];
        if (self.s_isFirstView)
        {
            self.s_isFirstView = NO;
            [self refreshCreateView];
        }
    }
}

- (void)userInfoRequestFailed:(ASIFormDataRequest *)request
{
    if (!hud.isHidden) {
        [hud hide:YES];
    }
    [AlertUtil showAlert:@"提示！" withMessage:@"亲，您的网络不给力！"];
    
    if (self.s_isFirstView)
    {
        self.s_isFirstView = NO;
        [self refreshCreateView];
    }
}
- (void)userInfoRequestFailedNoRemind:(ASIFormDataRequest *)request
{
    if (!hud.isHidden) {
        [hud hide:YES];
    }
}
- (void)signRequestFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *responseData = [parser objectWithString:responseString error:&error];

    if (error != nil)
    {
        if (hud.isHidden==NO)
        {
            [hud hide:YES];
        }
        return;
    }
    NSString *status =[responseData stringForKey:@"status"] ;
    if ([status isEqualToString:@"success"])
    {
        [BBUser setTodaySignState];
        NSDictionary *requestDict=[responseData dictionaryForKey:@"data"];
        if([requestDict isDictionaryAndNotEmpty])
        {
            NSString *prompt=[requestDict stringForKey:@"extern_yunqi_str"];
            if([prompt isNotEmpty])
            {
                [self additionalPrize:prompt];
            }
        }
        [self sendPrizeRequest];
    }
    else if ([status isEqualToString:@"failed"])
    {
        [self sendPrizeRequest];
    }
    else
    {
        if (hud.isHidden==NO)
        {
            [hud hide:YES];
        }
        [AlertUtil showAlert:@"提示！" withMessage:status];
    }
}

- (void)signRequestFailed:(ASIFormDataRequest *)request
{
    if (hud.isHidden==NO) {
        [hud hide:YES];
    }
    [AlertUtil showAlert:@"提示！" withMessage:@"亲，您的网络不给力！"];
}

#pragma mark - 弹层请求数据后调用的代理
-(void)popLayerRequestFinished:(ASIFormDataRequest *)request
{
   NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *responseData = [parser objectWithString:responseString error:&error];
    NSString *status=[responseData stringForKey:@"status"];
    if([status isEqualToString:@"success"])
    {
        NSDictionary *requestDict=[responseData dictionaryForKey:@"data"];
        BOOL theStatus=[requestDict boolForKey:@"status"];
        if(theStatus)
        {
            NSDictionary *infoDict = [requestDict dictionaryForKey:@"info"];
            BOOL show = [infoDict boolForKey:@"show_button"];
            NSArray *btnTitles;
            NSArray *imageArray;
            if(show)
            {
                btnTitles = [[NSArray alloc] initWithObjects:@"我知道了",[infoDict objectForKey:@"button_title"], nil];
                imageArray = [[NSArray alloc] initWithObjects:@"huise_03.png",@"sekuai_05.png", nil];
                _urlDic = [[NSDictionary alloc] initWithObjectsAndKeys:[infoDict stringForKey:@"redirect_type"],@"url_type",[infoDict stringForKey:@"button_url"],@"btn_url",[infoDict stringForKey:@"discussion_id"],@"topicID",[infoDict stringForKey:@"title"],@"navTitle", nil];
            }
            else
            {
                btnTitles = [[NSArray alloc] initWithObjects:@"我知道了", nil];
                imageArray = [[NSArray alloc] initWithObjects:@"huise_03.png", nil];
            }
            
            //创建弹层
            BBCustomsAlertView *alertView = [[BBCustomsAlertView alloc] initWithTheTitle:[infoDict stringForKey:@"name"] WithTittles:btnTitles AndColors:imageArray WithDelegate:self];
            //显示弹层
            if([[infoDict stringForKey:@"activity_type"] isNotEmpty])
            {
                if([[infoDict stringForKey:@"activity_type"] intValue] == 1)
                {
                    [alertView showWithImage:[infoDict stringForKey:@"image"]];
                }
                else if ([[infoDict stringForKey:@"activity_type"] intValue] == 2)
                {
                    [alertView showWithText:[infoDict stringForKey:@"content"]];
                }
            }
        }
        
    }
    else
    {
        if([status isEqualToString:@"failed"])
        {
            NSLog(@"%@",[responseData stringForKey:@"message"]);
        }
    }
    
}

-(void)popLayerRequestFailed:(ASIFormDataRequest *)request
{


}

- (void)invitePapa:(id)sender
{
    if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
    {
        [MobClick event:@"checkin_pregnant_v2" label:@"邀请准爸爸"];
    }
    else if([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
    {
        [MobClick event:@"checkin_baby_v2" label:@"邀请准爸爸"];
    }
    else
    {
        [MobClick event:@"checkin_prepare_v2" label:@"邀请准爸爸"];
    }
    BBBandInfomation *bandInfo = [[BBBandInfomation alloc] initWithNibName:@"BBBandInfomation" bundle:nil];
    bandInfo.delegate = self;
    [self.navigationController pushViewController:bandInfo animated:YES];
}

-(void)closeBandInfomationView
{
    CGFloat addHeight= 45.0f;
    papaLabel1.top -= addHeight;
    preValueLabel.top -= addHeight;
    papaLabel2.top -= addHeight;
    self.presentLabel.top -=addHeight;
    signLabel1.text = nil;
    signLabel2.text = nil;
    [self refreshCreateView];
}

@end
