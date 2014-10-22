//
//  HMCircleListCell.m
//  lama
//
//  Created by mac on 13-12-25.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMMoreCircleCell.h"
#import "UIImageView+WebCache.h"
#import "HMApiRequest.h"

@interface HMMoreCircleCell ()
@property (assign, nonatomic) LoginType s_LoginType;
@end

@implementation HMMoreCircleCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DIDCHANGE_CIRCLE_JOIN_STATE object:nil];

    _delegate = nil;

    [_m_Requests clearDelegatesAndCancel];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellContent:(HMCircleClass *)circleClass
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self makeCellStyle];
        
        [self setCellContent:circleClass];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)makeCellStyle
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCircleJoinState:) name:DIDCHANGE_CIRCLE_JOIN_STATE object:nil];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor = UI_CELL_SELECT_BGCOLOR;
    self.exclusiveTouch = YES;

    self.m_ContentView.backgroundColor = UI_CELL_BGCOLOR;

    //加圆角
    //[self.m_CircleIconImageView roundedRect:2.0f];

    [self.m_BgImageView setImageWithStretchableImage:@"circle_bgFrame"];

    self.m_CircleTitleLabel.textColor = UI_TEXT_TITLE_COLOR;

    self.m_MemberCountImageView.image = [UIImage imageNamed:@"circle_memberNum_icon"];
    self.m_MemberCountLabel.textColor = UI_TEXT_OTHER_COLOR;

    self.m_TopicCountImageView.image = [UIImage imageNamed:@"circle_topicNum_icon"];
    self.m_TopicCountLabel.textColor = UI_TEXT_OTHER_COLOR;

    self.m_CircleIntroLabel.textColor = UI_TEXT_CONTENT_COLOR;
}

- (void)setCellContent:(HMCircleClass *)circleClass
{
    self.m_CircleClass = circleClass;

    [self.m_CircleIconImageView setImageWithURL:[NSURL URLWithString:self.m_CircleClass.circleImageUrl]
                         placeholderImage:[UIImage imageNamed:@"avatar_default_circle"]];

    self.m_CircleTitleLabel.text = self.m_CircleClass.circleTitle;

    if ([self.m_CircleClass.topicNum intValue] > 999999)
    {
        self.m_TopicCountLabel.text = @"999999+";
    }
    else
    {
        self.m_TopicCountLabel.text = self.m_CircleClass.topicNum;
    }

    if ([self.m_CircleClass.memberNum intValue] > 999999)
    {
        self.m_MemberCountLabel.text = @"999999+";
    }
    else
    {
        self.m_MemberCountLabel.text = self.m_CircleClass.memberNum;
    }

    self.m_CircleIntroLabel.text = self.m_CircleClass.circleIntro;

    [self freshCircleAddBtn:self.m_CircleClass.addStatus];
}


#pragma mark -
#pragma mark actions

- (void)freshCircleAddBtn:(BOOL)isAdd
{
    if (isAdd)
    {
        [self.m_CircleAddBtn setImage:[UIImage imageNamed:@"circle_quitbtn_bg_new"] forState:UIControlStateNormal];
    }
    else
    {
        [self.m_CircleAddBtn setImage:[UIImage imageNamed:@"circle_addbtn_bg_new"] forState:UIControlStateNormal];
    }
}

- (IBAction)circleAddBtn_Click:(id)sender
{
    if([BBUser isLogin])
    {
        [self.m_Requests clearDelegatesAndCancel];

        if (self.m_CircleClass.addStatus)
        {
            self.m_Requests = [HMApiRequest quitTheCircleWithGroupID:self.m_CircleClass.circleId];
            [self.m_Requests setDelegate:self];
            [self.m_Requests setDidFinishSelector:@selector(quitFinished:)];
            [self.m_Requests setDidFailSelector:@selector(quitDataFail:)];
            [self.m_Requests startAsynchronous];
        }
        else
        {         
            self.m_Requests = [HMApiRequest addTheCircleWithGroupID:self.m_CircleClass.circleId];
            [self.m_Requests setDelegate:self];
            [self.m_Requests setDidFinishSelector:@selector(addFinished:)];
            [self.m_Requests setDidFailSelector:@selector(addDataFail:)];
            [self.m_Requests startAsynchronous];
        }
        if ([self.delegate respondsToSelector:@selector(showHud:delay:)])
        {
            [self.delegate showHud:nil delay:0];
        }
    }
    else
    {
        [self goToLoginWithLoginType:LoginDefault];
    }
}


#pragma mark -
#pragma mark ASIHTTPRequest

- (void)quitFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *dictData = [responseString objectFromJSONString];
    if (![dictData isDictionaryAndNotEmpty])
    {
        if ([self.delegate respondsToSelector:@selector(showHud:delay:)])
        {
            [self.delegate showHud:@"退出失败！请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        return ;
    }

    NSString *status = [dictData stringForKey:@"status"];
    if ([status isEqualToString:@"success"] || [status isEqualToString:@"0"])
    {
        if ([self.delegate respondsToSelector:@selector(showHud:delay:)])
        {
            [self.delegate showHud:@"退出成功！" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        NSDictionary * dictList =[dictData dictionaryForKey:@"data"];
        if ([dictList isNotEmpty])
        {
            if ([[dictList stringForKey:@"group_id"] isEqualToString:self.m_CircleClass.circleId])
            {
                NSArray *values = [NSArray arrayWithObjects:[dictList stringForKey:@"group_id"], @"0", nil];
                NSArray *keys = [NSArray arrayWithObjects:@"group_id", @"join_state",nil];
                NSDictionary *dic = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_CIRCLE_JOIN_STATE object:dic];

                self.m_CircleClass.addStatus = NO;
                [self freshCircleAddBtn:self.m_CircleClass.addStatus];
            }
        }
    }
    else if ([status isEqualToString:@"owner_cannot_quit"])
    {
        if ([self.delegate respondsToSelector:@selector(hideHud)])
        {
            [self.delegate hideHud];
        }
        [PXAlertView showAlertWithTitle:@"您不能退出自己管理的圈子！"];

        return;
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(showHud:delay:)])
        {
            [self.delegate showHud:@"退出失败！请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
    }
}

- (void)quitDataFail:(ASIHTTPRequest *)request
{
    if ([self.delegate respondsToSelector:@selector(showHud:delay:)])
    {
        [self.delegate showHud:@"退出失败！请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
}

- (void)addFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *dictData = [responseString objectFromJSONString];

    if (![dictData isDictionaryAndNotEmpty])
    {
        if ([self.delegate respondsToSelector:@selector(showHud:delay:)])
        {
            [self.delegate showHud:@"加入失败！请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        return;
    }

    NSString *status = [dictData stringForKey:@"status"];
    if ([status isEqualToString:@"success"] || [status isEqualToString:@"0"])
    {
        if ([self.delegate respondsToSelector:@selector(showHud:delay:)])
        {
            [self.delegate showHud:@"加入成功！" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        NSDictionary * dictList =[dictData dictionaryForKey:@"data"];
        if ([dictList isNotEmpty])
        {
            if ([[dictList stringForKey:@"group_id"] isEqualToString:self.m_CircleClass.circleId])
            {
                NSArray *values = [NSArray arrayWithObjects:[dictList stringForKey:@"group_id"], @"1", nil];
                NSArray *keys = [NSArray arrayWithObjects:@"group_id", @"join_state", nil];
                NSDictionary *dic = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_CIRCLE_JOIN_STATE object:dic];

                self.m_CircleClass.addStatus = YES;
                [self freshCircleAddBtn:self.m_CircleClass.addStatus];
            }
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(showHud:delay:)])
        {
            [self.delegate showHud:@"加入失败！请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
    }
}

- (void)addDataFail:(ASIHTTPRequest *)request
{
    if ([self.delegate respondsToSelector:@selector(showHud:delay:)])
    {
        [self.delegate showHud:@"加入失败！请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
}


#pragma mark -
#pragma mark NSNotificationCenter - DIDCHANGE_CIRCLE_JOIN_STATE

- (void)changeCircleJoinState:(NSNotification *)notify
{
    NSDictionary *data = notify.object;
    NSString *groupId = [data stringForKey:@"group_id"];

    if ([self.m_CircleClass.circleId isEqualToString:groupId])
    {
        BOOL state = [data boolForKey:@"join_state"];
        self.m_CircleClass.addStatus = state;
        [self freshCircleAddBtn:self.m_CircleClass.addStatus];
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
    [self circleAddBtn_Click:nil];
}

@end

/*
#pragma mark -
#pragma mark HMCircleListCellDelegate

- (void)showHud:(NSString *)text delay:(NSTimeInterval)delay
{
    if ([text isNotEmpty])
    {
        if (delay > 0)
        {
            [self.m_ProgressHUD show:YES withText:text delay:delay];
        }
        else
        {
            [self.m_ProgressHUD show:YES withText:text];
        }
    }
    else
    {
        [self.m_ProgressHUD show:YES showBackground:NO];
    }
}

- (void)hideHud
{
    [self.m_ProgressHUD hide:YES];
}
*/
