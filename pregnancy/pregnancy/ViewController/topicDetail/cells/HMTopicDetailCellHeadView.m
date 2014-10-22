//
//  HMTopicDetailCellTopView.m
//  lama
//
//  Created by mac on 13-8-1.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMTopicDetailCellHeadView.h"
#import "UIButton+WebCache.h"
#import "BBPersonalViewController.h"
#import "BBAppInfo.h"
#import "ARCHelper.h"

@implementation HMTopicDetailCellHeadView
@synthesize m_TopLineImageView;
@synthesize m_HeadImageView;
@synthesize m_NameLabel;
@synthesize m_NameCtrl;
@synthesize m_MasterMarkView;
@synthesize m_FloorLabel;
@synthesize m_BabyAgeLab;

- (void)dealloc
{
    [self.layer removeAllAnimations];
    
    [m_TopLineImageView ah_release];
    [m_HeadImageView ah_release];
    [m_NameLabel ah_release];
    [m_MasterMarkView ah_release];
    [m_FloorLabel ah_release];
    [m_NameCtrl ah_release];
    
    [m_BabyAgeLab ah_release];
    [_delButton ah_release];
    [_m_TopicUserSign ah_release];
    [super ah_dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)drawTopicDetailCell:(HMTopicDetailCellClass *)topicDetail withTopicDelegate:(id <HMTopicDetailCellDelegate>)topicDelagate
{
    [super drawTopicDetailCell:topicDetail withTopicDelegate:topicDelagate];

//    m_NameLabel.textColor = DETAIL_NICKNAME_COLOR;
    m_BabyAgeLab.textColor = DETAIL_BABYAGE_COLOR;
    m_FloorLabel.textColor = DETAIL_FLOOR_COLOR;
    
    self.m_HeadImageView.exclusiveTouch = YES;
    self.delButton.exclusiveTouch = YES;

    NSString *url = self.m_TopicDetail.m_TopicInfor.m_UserIcon;
    NSString *avaUrl = [url getValidHeadImageUrl];
    if ([avaUrl isNotEmpty])
    {
        NSURL *authorImage = [NSURL URLWithString:url];
        [m_HeadImageView setImageWithURL:authorImage forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    }
    else
    {
        [m_HeadImageView setImage:[UIImage imageNamed:@"avatar_default"] forState:UIControlStateNormal];
    }

    // 设置圆形
    [m_HeadImageView.layer setMasksToBounds:YES];
    [m_HeadImageView.layer setCornerRadius:20.0f];
    //增加用户徽章
    [self.m_TopicUserSign setImage:nil];
    if ([self.m_TopicDetail.m_TopicInfor.m_UserSign isNotEmpty])
    {
        [self.m_TopicUserSign setImageWithURL:[NSURL URLWithString:self.m_TopicDetail.m_TopicInfor.m_UserSign] placeholderImage:nil];
    }
    
    // 刷新时间
    if ([topicDetail.m_PublishTime isNotEmpty])
    {
        m_BabyAgeLab.hidden = NO;
        m_BabyAgeLab.text = topicDetail.m_TopicInfor.m_BabyAge;
    }
    else
    {
        m_BabyAgeLab.text = @"";
        m_BabyAgeLab.hidden = YES;
    }
    
    if ((self.m_TopicDetail.m_Type == TOPICDETAILCELL_MASTERHEADER_TYPE) && [BBUser isLogin] && [self.m_TopicDetail.m_TopicInfor.m_UserId isEqualToString:[BBUser getEncId]])
    {
        CGSize size = [m_BabyAgeLab.text sizeWithFont:m_BabyAgeLab.font constrainedToSize:CGSizeMake(240, 20) lineBreakMode:m_BabyAgeLab.lineBreakMode];
        m_BabyAgeLab.width = size.width;
        _delButton.left = m_BabyAgeLab.left + m_BabyAgeLab.width + 2;
        _delButton.hidden = NO;
    }
    else
    {
        _delButton.hidden = YES;
    }
    
    NSString *authorname = self.m_TopicDetail.m_TopicInfor.m_UserName;
    CGSize size = [authorname sizeWithFont:m_NameLabel.font constrainedToSize:CGSizeMake(160.0f, 16.0f) lineBreakMode:NSLineBreakByCharWrapping];
    [m_NameLabel setText:authorname];
    m_NameLabel.width = size.width;
    m_NameCtrl.frame = m_NameLabel.frame;
    
    self.m_TopicAdmin.hidden = !self.m_TopicDetail.m_TopicInfor.m_IsAdmin;

    if (self.m_TopicDetail.m_TopicInfor.m_IsMaster)
    {
        m_MasterMarkView.hidden = NO;
        m_MasterMarkView.left = m_NameLabel.left + m_NameLabel.width + 6;
        if (!self.m_TopicAdmin.hidden)
        {
            self.m_TopicAdmin.left = m_MasterMarkView.left + m_MasterMarkView.width + 6 ;
        }
    }
    else
    {
        m_MasterMarkView.hidden = YES;
        if (!self.m_TopicAdmin.hidden)
        {
            self.m_TopicAdmin.left = m_NameLabel.left + m_NameLabel.width + 6;
        }
    }
    

    
    if (![self.m_TopicDetail.m_TopicInfor.m_Floor isNotEmpty] || [self.m_TopicDetail.m_TopicInfor.m_Floor isEqualToString:@"0"])
    {
        m_FloorLabel.hidden = YES;
        m_TopLineImageView.hidden = NO;
        m_TopLineImageView.left = 10;
        m_TopLineImageView.width = UI_SCREEN_WIDTH - 20;
    }
    else
    {
        m_TopLineImageView.hidden = NO;
        m_TopLineImageView.left = 0;
        m_TopLineImageView.width = UI_SCREEN_WIDTH;
        m_FloorLabel.text = [NSString stringWithFormat:@"%@楼", self.m_TopicDetail.m_TopicInfor.m_Floor];
    }
    
    self.height = self.m_TopicDetail.m_Height;
}

- (IBAction)pressHeadBtn:(id)sender
{
    [MobClick event:@"discuz_v2" label:@"用户头像昵称"];
    if ([self.m_TopicDetail.m_TopicInfor.m_UserId isNotEmpty] && self.m_PopViewController != nil)
    {
        BBPersonalViewController * personVC = [[[BBPersonalViewController alloc]initWithNibName:@"BBPersonalViewController" bundle:nil] ah_autorelease];
        personVC.hidesBottomBarWhenPushed = YES;
        personVC.userEncodeId = self.m_TopicDetail.m_TopicInfor.m_UserId;
        personVC.userName = self.m_TopicDetail.m_TopicInfor.m_UserName;
        [self.m_PopViewController pushViewController:personVC animated:YES];
    }
}

- (IBAction)delTopic:(id)sender
{
    [MobClick event:@"discuz_v2" label:@"删除主帖"];
    if ([self.delegate respondsToSelector:@selector(deleteTopicClicked)])
    {
        [self.delegate deleteTopicClicked];
    }
}

@end
