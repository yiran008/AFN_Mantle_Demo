//
//  HMCircleTopicHeaderView.m
//  lama
//
//  Created by jiangzhichao on 14-4-17.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMCircleTopicHeaderView.h"
#import "UIImageView+WebCache.h"
#import "HMTopicClass.h"

@interface HMCircleTopicHeaderView ()
<
    BBLoginDelegate
>

@property (nonatomic, strong) UIView *s_TopView;
@property (nonatomic, strong) UIImageView *s_HeadImgView;
@property (nonatomic, strong) UILabel *s_CircleTitleLabel;
@property (nonatomic, strong) UIImageView *s_TopicCountImgView;
@property (nonatomic, strong) UILabel *s_TopicCountLabel;
@property (nonatomic, strong) UIImageView *s_PeopleCountImgView;
@property (nonatomic, strong) UILabel *s_PeopleCountLabel;
@property (nonatomic, strong) UIButton *s_JoinBtn;
@property (nonatomic, strong) UIImageView *m_TopicImgView;
@property (assign, nonatomic) LoginType s_LoginType;

@property (nonatomic, strong) UIButton *s_CircleUserButton;
@property (nonatomic, strong) UIButton *s_AdminButton;
@property (nonatomic, strong) UIButton *s_HospitalButton;

@end


@implementation HMCircleTopicHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.width = UI_SCREEN_WIDTH;
        CGFloat width = 82.0;
        
        self.s_TopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 86)];
        self.s_TopView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.s_TopView];
        
        self.s_HeadImgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 9, 68, 68)];
        [self.s_TopView addSubview:self.s_HeadImgView];
        
        self.s_CircleTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, 10, self.width - 82 - 48, 16)];
        self.s_CircleTitleLabel.backgroundColor = [UIColor clearColor];
        self.s_CircleTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.s_CircleTitleLabel.textColor = [UIColor colorWithHex:0x111111];
        [self.s_TopView addSubview:self.s_CircleTitleLabel];
        
        self.s_JoinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.s_JoinBtn.exclusiveTouch = YES;
        self.s_JoinBtn.frame = CGRectMake(self.width - 48, 20, 32, 32);
        [self.s_JoinBtn addTarget:self action:@selector(joinBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.s_TopView addSubview:self.s_JoinBtn];
        
        self.s_TopicCountImgView = [[UIImageView alloc] initWithFrame:CGRectMake(width, 32, 12, 12)];
        self.s_TopicCountImgView.image = [UIImage imageNamed:@"circle_topicNum_icon"];
        [self.s_TopView addSubview:self.s_TopicCountImgView];
        
        self.s_TopicCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(width + 14, 32, 60, 12)];
        self.s_TopicCountLabel.backgroundColor = [UIColor clearColor];
        self.s_TopicCountLabel.font = [UIFont systemFontOfSize:12];
        self.s_TopicCountLabel.textColor = [UIColor colorWithHex:0x999999];
        [self.s_TopView addSubview:self.s_TopicCountLabel];
        
        self.s_PeopleCountImgView = [[UIImageView alloc] initWithFrame:CGRectMake(width + 70, 32, 12, 12)];
        self.s_PeopleCountImgView.image = [UIImage imageNamed:@"circle_memberNum_icon"];
        [self.s_TopView addSubview:self.s_PeopleCountImgView];
        
        self.s_PeopleCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(width + 84, 32, 60, 12)];
        self.s_PeopleCountLabel.backgroundColor = [UIColor clearColor];
        self.s_PeopleCountLabel.font = [UIFont systemFontOfSize:12];
        self.s_PeopleCountLabel.textColor = [UIColor colorWithHex:0x999999];
        [self.s_TopView addSubview:self.s_PeopleCountLabel];
        
        self.s_CircleUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.s_CircleUserButton.exclusiveTouch = YES;
        self.s_CircleUserButton.frame = CGRectMake(width, 53, 59, 24);
        [self.s_CircleUserButton setImage:[UIImage imageNamed:@"topic_head_circle"] forState:UIControlStateNormal];
        [self.s_CircleUserButton addTarget:self action:@selector(circleUserList) forControlEvents:UIControlEventTouchUpInside];
        [self.s_TopView addSubview:self.s_CircleUserButton];
        
        self.s_AdminButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.s_AdminButton.exclusiveTouch = YES;
        self.s_AdminButton.frame = CGRectMake(width + 69, 53, 59, 24);
        [self.s_AdminButton setImage:[UIImage imageNamed:@"topic_head_manger"] forState:UIControlStateNormal];
        [self.s_AdminButton addTarget:self action:@selector(circleAdminList) forControlEvents:UIControlEventTouchUpInside];
        [self.s_TopView addSubview:self.s_AdminButton];

        self.s_HospitalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.s_HospitalButton.exclusiveTouch = YES;
        self.s_HospitalButton.frame = CGRectMake(width + 69*2, 53, 59, 24);
        [self.s_HospitalButton setImage:[UIImage imageNamed:@"topic_head_hospital"] forState:UIControlStateNormal];
        self.s_HospitalButton.hidden = YES;
        [self.s_HospitalButton addTarget:self action:@selector(hospitalIntroduction) forControlEvents:UIControlEventTouchUpInside];
        [self.s_TopView addSubview:self.s_HospitalButton];

        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 85, self.width, 1)];
        bottomLine.image = [UIImage imageNamed:@"topiccell_line_bottom"];
        [self.s_TopView addSubview:bottomLine];
    }
    return self;
}

- (void)freshData
{
    [self.s_HeadImgView setImageWithURL:[NSURL URLWithString:self.m_HeadImgUrl] placeholderImage:[UIImage imageNamed:@"avatar_default_circle"]];
    self.s_CircleTitleLabel.text = self.m_CircleTitle;
    self.s_TopicCountLabel.text = self.m_TopicCount;
    self.s_PeopleCountLabel.text = self.m_PeopleCount;
    [self changeJoinBtnStyle:self.m_IsJoin];
    self.s_JoinBtn.hidden =  self.m_IsDefaultJoined;
    if(self.m_IsHospital)
    {
        self.s_HospitalButton.hidden = NO;
    }
    else
    {
        self.s_HospitalButton.hidden = YES;
    }
    [self freshTopics];
}

- (void)hiddeHeadView
{
    self.s_TopView.hidden = YES;
    self.m_TopicImgView.top = 8;
    self.height -= 86;
}

- (void)joinBtnClick
{
    if([BBUser isLogin])
    {
        if([self.delegate respondsToSelector:@selector(HMCircleTopicHeaderView:clickJoinBtnWithisJoin:)])
        {
            [self.delegate HMCircleTopicHeaderView:self clickJoinBtnWithisJoin:self.m_IsJoin];
        }
    }
    else
    {
        [self goToLoginWithLoginType:LoginDefault];
    }
}

- (void)circleUserList
{
    if([self.delegate respondsToSelector:@selector(clickedCircleUserList)])
    {
        [self.delegate clickedCircleUserList];
    }
}

- (void)circleAdminList
{
    if([self.delegate respondsToSelector:@selector(clickedAdminList)])
    {
        [self.delegate clickedAdminList];
    }
}
- (void)hospitalIntroduction
{
    if([self.delegate respondsToSelector:@selector(clickedHospitalIntroduction)])
    {
        [self.delegate clickedHospitalIntroduction];
    }
}

- (void)freshTopics
{
    [self.m_TopicImgView removeAllSubviews];
    if ([self.m_TopicArray isNotEmpty])
    {
        CGFloat topicImgViewHeight = 0;
        if (!self.m_TopicImgView)
        {
            self.m_TopicImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 85, 320, topicImgViewHeight)];
            self.m_TopicImgView.userInteractionEnabled = YES;

            [self addSubview:self.m_TopicImgView];
        }
        NSInteger i = 0;
        for (NSDictionary *dic in self.m_TopicArray)
        {
            HMCircleTopicView *circleTopicView = [[HMCircleTopicView alloc] initWithFrame:CGRectMake(0, topicImgViewHeight, 0, 0)];
            circleTopicView.m_IsNew = [dic boolForKey:@"is_new"];
            circleTopicView.m_IsElite = [dic boolForKey:@"is_elite"];
            circleTopicView.m_IsHelp = [dic boolForKey:@"is_question"];
            circleTopicView.m_HasPic = [dic boolForKey:@"has_pic"];
            circleTopicView.m_TopicTitle = [dic stringForKey:@"title" defaultString:@""];
            circleTopicView.m_TopicId = [dic stringForKey:@"id"];
            circleTopicView.m_LineNotShow = (i == self.m_TopicArray.count - 1) ? YES : NO;
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCircleTopicView:)];
            [circleTopicView addGestureRecognizer:ges];
            [self.m_TopicImgView addSubview:circleTopicView];
            [circleTopicView loadData];

            topicImgViewHeight = circleTopicView.bottom;
            i++;
        }
        
        self.m_TopicImgView.height = topicImgViewHeight;
        self.m_TopicImgView.image = [[UIImage imageNamed:@"cricletopic_zhiding_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
        self.height = self.s_TopView.height + topicImgViewHeight + 8 ;
    }
    else
    {
        self.m_TopicImgView.hidden = YES;
        self.height = self.s_TopView.height;
    }
    [self.m_TopicImgView setImageWithStretchableImage:@"circletopic_zhiding_bg"];
}

- (void)changeJoinBtnStyle:(BOOL)isJoin
{
    if (isJoin)
    {
        [self.s_JoinBtn setBackgroundImage:[UIImage imageNamed:@"circle_quitbtn_bg_new"] forState:UIControlStateNormal];
    }
    else
    {
        [self.s_JoinBtn setBackgroundImage:[UIImage imageNamed:@"circle_addbtn_bg_new"] forState:UIControlStateNormal];
    }
}

- (void)clickCircleTopicView:(UITapGestureRecognizer *)ges
{
    HMCircleTopicView *circleTopicView = (HMCircleTopicView *)ges.view;
    if ([self.delegate respondsToSelector:@selector(clickCircleTopicView:)])
    {
        [self.delegate clickCircleTopicView:circleTopicView];
    }
}

#pragma mark -
#pragma mark loginDelegate  and method

- (void)goToLoginWithLoginType:(LoginType)theLoginType
{
    BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
    login.m_LoginType = BBPresentLogin;
    BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
    [navCtrl setColorWithImageName:@"navigationBg"];
    self.s_LoginType = theLoginType;
    login.delegate = self;
    [self.viewController  presentViewController:navCtrl animated:YES completion:^{
        
    }];
    return ;
}

-(void)loginFinish
{
    [self joinBtnClick];
}

@end

@interface HMCircleTopicView ()


@property (nonatomic, strong) UIImageView *s_DingImgView;
@property (nonatomic, strong) UIImageView *s_NewImgView;
@property (nonatomic, strong) UIImageView *s_EliteImgView;
@property (nonatomic, strong) UIImageView *s_HelpImgView;
@property (nonatomic, strong) UIImageView *s_PicImgView;
@property (nonatomic, strong) UIImageView *s_LineImgView;


@property (nonatomic, strong) UILabel *s_TopicTitleLabel;

@end

@implementation HMCircleTopicView
{
    CGFloat viewHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.width = 320;
        self.backgroundColor = [UIColor clearColor];
        
        self.s_DingImgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 30, 16)];
        self.s_DingImgView.image = [UIImage imageNamed:@"topicdetail_cell_top_icon"];
        [self addSubview:self.s_DingImgView];
        
        self.s_NewImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 16, 16)];
        self.s_NewImgView.image = [UIImage imageNamed:@"topicdetail_cell_new_icon"];
        self.s_NewImgView.hidden = YES;
        [self addSubview:self.s_NewImgView];
        
        self.s_EliteImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 16, 16)];
        self.s_EliteImgView.image = [UIImage imageNamed:@"topicdetail_cell_best_icon"];
        self.s_EliteImgView.hidden = YES;
        [self addSubview:self.s_EliteImgView];
        
        self.s_HelpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 16, 16)];
        self.s_HelpImgView.image = [UIImage imageNamed:@"topiccell_mark_help"];
        self.s_HelpImgView.hidden = YES;
        [self addSubview:self.s_HelpImgView];

        self.s_PicImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 16, 16)];
        self.s_PicImgView.image = [UIImage imageNamed:@"topiccell_mark_pic"];
        self.s_PicImgView.hidden = YES;
        [self addSubview:self.s_PicImgView];

        self.s_TopicTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8,self.width-16, 14)];
        self.s_TopicTitleLabel.backgroundColor = [UIColor clearColor];
        self.s_TopicTitleLabel.font = [UIFont systemFontOfSize:14];
        self.s_TopicTitleLabel.textColor = [UIColor colorWithHex:0x111111];
        self.s_TopicTitleLabel.numberOfLines = 0;
        [self addSubview:self.s_TopicTitleLabel];
        
        self.s_LineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        self.s_LineImgView.image = [UIImage imageNamed:@"topiccell_line_bottom"];
        [self addSubview:self.s_LineImgView];
    }
    return self;
}

-(void)loadData
{
    CGFloat offsetX = self.s_DingImgView.right;
    CGFloat gap = 4;
    viewHeight = 0;
    
    NSString *title = [NSString spaceWithFont:[UIFont systemFontOfSize:14.0f] top:YES new:self.m_IsNew best:self.m_IsElite help:self.m_IsHelp pic:self.m_HasPic add:0];
    
    if (self.m_IsNew)
    {
        self.s_NewImgView.hidden = NO;
        self.s_NewImgView.left = offsetX + gap;
        offsetX = self.s_NewImgView.right;
    }
    
    if (self.m_IsElite)
    {
        self.s_EliteImgView.hidden = NO;
        self.s_EliteImgView.left = offsetX + gap;
        offsetX = self.s_EliteImgView.right;
    }
    
    if (self.m_IsHelp)
    {
        self.s_HelpImgView.hidden = NO;
        self.s_HelpImgView.left = offsetX + gap;
        offsetX = self.s_HelpImgView.right;
    }
    
    if (self.m_HasPic)
    {
        self.s_PicImgView.hidden = NO;
        self.s_PicImgView.left = offsetX + gap;
        offsetX = self.s_PicImgView.right;
    }

    title = [NSString stringWithFormat:@"%@%@", title, self.m_TopicTitle];
    
    self.s_TopicTitleLabel.text = title;
    
    CGSize size;
    
    if (IOS_VERSION < 7.0)
    {
        size = [title sizeWithFont:[UIFont systemFontOfSize:14.0f]];
    }
    else
    {
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]};
        size = [title sizeWithAttributes:attributes];
    }
    
    if (size.width >= 288)
    {
        self.s_TopicTitleLabel.top = 8;
        self.s_TopicTitleLabel.height = 34;
        viewHeight = 48;
    }
    else
    {
        self.s_TopicTitleLabel.top = 8;
        self.s_TopicTitleLabel.height = 14;
        viewHeight = 32;
    }
    self.height = viewHeight;
    
    if (self.m_LineNotShow)
    {
        self.s_LineImgView.hidden = YES;
    }
    else
    {
        self.s_LineImgView.top = viewHeight - 1;
    }
}

@end
