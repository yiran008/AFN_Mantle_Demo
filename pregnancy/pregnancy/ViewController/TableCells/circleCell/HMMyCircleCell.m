//
//  HMCircleListCell.m
//  lama
//
//  Created by mac on 13-12-25.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMMyCircleCell.h"
#import "UIImageView+WebCache.h"

@implementation HMMyCircleCell

- (void)dealloc
{
    _delegate = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellContent:(HMCircleClass *)circleClass isMine:(BOOL)isMine
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeCellStyle];
        
        [self setCellContent:circleClass isMine:isMine];
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
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.exclusiveTouch = YES;

    self.m_ContentView.backgroundColor = UI_CELL_BGCOLOR;

    //加圆角
    //[self.m_CircleIconImageView roundedRect:2.0f];

    [self.m_BgImageView setImageWithStretchableImage:@"circle_bgFrame"];

    self.m_TopBtn.backgroundColor = UI_NAVIGATION_BGCOLOR;
    self.m_TopBtn.exclusiveTouch = YES;

    self.m_CircleTitleLabel.textColor = UI_TEXT_TITLE_COLOR;
    
    self.m_MemberTodayView.backgroundColor = [UIColor clearColor];
    self.m_NoHospitalRemindLabel.text = @"点击这里，设置自己的医院圈~";
    self.m_NoHospitalRemindLabel.font = [UIFont systemFontOfSize:12.0];
    self.m_NoHospitalRemindLabel.backgroundColor = [UIColor clearColor];
    self.m_NoHospitalRemindLabel.textColor = [UIColor colorWithHex:0xff537b];
    self.m_NoHospitalRemindLabel.hidden = YES;

    self.m_MemberCountImageView.image = [UIImage imageNamed:@"circle_memberNum_icon"];
    self.m_MemberCountLabel.textColor = UI_TEXT_OTHER_COLOR;

    //self.m_TodayImageView.image = [UIImage imageNamed:@"circle_todayTopicNum_icon"];
    self.m_TodayLabel.text = @"今日话题";
    self.m_TodayLabel.textColor = UI_DEFAULT_BGCOLOR;
    self.m_TodayCountLabel.textColor = UI_TEXT_OTHER_COLOR;

    self.m_ControlButton.exclusiveTouch = YES;
    self.m_ControlButton.hidden = NO;
}


- (void)setCellContent:(HMCircleClass *)circleClass isMine:(BOOL)isMine
{
    self.m_ControlButton.hidden = NO;
    self.m_CircleClass = circleClass;

    s_IsMine = isMine;

    if (s_IsMine)
    {
        self.m_TopBtn.hidden = NO;
    }
    else
    {
        self.m_TopBtn.hidden = YES;
    }
    //默认加入了的圈子都加上角标
    if (circleClass.isDefaultJoined)
    {
        self.m_MyBirthClub.hidden = NO;
    }
    else
    {
        self.m_MyBirthClub.hidden = YES;
    }
    
    [self.m_CircleIconImageView setImageWithURL:[NSURL URLWithString:self.m_CircleClass.circleImageUrl]
                         placeholderImage:[UIImage imageNamed:@"avatar_default_circle"]];

    self.m_CircleTitleLabel.text = self.m_CircleClass.circleTitle;

    if ([self.m_CircleClass.todayTopicNum intValue] > 999999)
    {
        self.m_TodayCountLabel.text = @"999999+";
    }
    else
    {
        self.m_TodayCountLabel.text = self.m_CircleClass.todayTopicNum;
    }

    if ([self.m_CircleClass.memberNum intValue] > 999999)
    {
        self.m_MemberCountLabel.text = @"999999+";
    }
    else
    {
        self.m_MemberCountLabel.text = self.m_CircleClass.memberNum;
    }

    if (s_IsMine)
    {
        self.m_ScrollView.contentSize = CGSizeMake(self.m_ScrollView.width, self.m_ScrollView.height);
    }
    else
    {
        self.m_ScrollView.contentSize = CGSizeMake(self.m_ScrollView.width, self.m_ScrollView.height);
    }
    
    // 未设置医院圈显示
    if (circleClass.isMyHospital && [circleClass.circleId isEqualToString:@"0"])
    {
        self.m_NoHospitalRemindLabel.hidden = NO;
        self.m_MemberTodayView.hidden = YES;
        self.m_ControlButton.hidden = YES;
    }
    else
    {
        self.m_NoHospitalRemindLabel.hidden = YES;
        self.m_MemberTodayView.hidden = NO;
    }
}

#pragma mark -
#pragma mark actions

- (IBAction)ControlButton_action:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(myCircleCellControlAction:withClass:withIndexPath:)])
    {
        [self.delegate myCircleCellControlAction:self withClass:self.m_CircleClass withIndexPath:self.theCurrentIndexPath];
    }
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
