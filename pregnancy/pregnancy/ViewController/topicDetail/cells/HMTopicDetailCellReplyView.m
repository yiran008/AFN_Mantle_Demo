//
//  HMTopicDetailCellReplyView.m
//  lama
//
//  Created by mac on 13-8-6.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMTopicDetailCellReplyView.h"
#import "ARCHelper.h"

@implementation HMTopicDetailCellReplyView
@synthesize m_BgImageView;
@synthesize m_NicknameLabel;
@synthesize m_ContentLabel;
@synthesize m_FloorLabel;

@synthesize m_CanShowAll;

- (void)dealloc
{
    [m_BgImageView ah_release];
    [m_NicknameLabel ah_release];
    [m_ContentLabel ah_release];
    [m_FloorLabel ah_release];
    
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

//    m_NicknameLabel.textColor = DETAIL_NICKNAME_COLOR2;
    m_ContentLabel.textColor = DETAIL_CONTENT_TEXT_COLOR2;
    m_FloorLabel.textColor = DETAIL_FLOOR_COLOR;

    m_FloorLabel.text = [NSString stringWithFormat:@"%@楼" ,topicDetail.m_ReplyInfor.m_Position];
    NSString *title = topicDetail.m_ReplyInfor.m_UserName;
    CGSize size = [title sizeWithFont:m_NicknameLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 16.0f) lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat width = size.width;
    if (width > 250)
    {
        width = 250;
    }
    
    m_NicknameLabel.width = width;
    m_NicknameLabel.text = title;
    
    [self drawContentLabel];
}

- (void)drawContentLabel
{
    self.m_TopicDetail.m_Height = 40;
    
    self.m_CanShowAll = NO;
    
    if ([self.m_TopicDetail.m_ReplyInfor.m_ContentText isNotEmpty])
    {
        CGSize size = [self.m_TopicDetail.m_ReplyInfor.m_ContentText sizeWithFont:m_ContentLabel.font constrainedToSize:CGSizeMake(m_ContentLabel.width, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail];
        CGFloat height = size.height;
        if (height > 36)
        {
            m_ContentLabel.numberOfLines = 2;
            height = 36;
        }
        
        m_ContentLabel.hidden = NO;
        m_ContentLabel.height = height;
        m_ContentLabel.text = self.m_TopicDetail.m_ReplyInfor.m_ContentText;
        
        self.m_TopicDetail.m_Height += height;
    }
    else
    {
        m_ContentLabel.hidden = YES;
    }


    m_BgImageView.height = self.m_TopicDetail.m_Height;
    UIImage *image = [UIImage imageNamed:@"topicdetail_cell_reply_bg"];
    image = [image stretchableImageWithLeftCapWidth:160 topCapHeight:14];
    [m_BgImageView setImage:image];
}

- (void)drawReplayContent
{
    //self.m_TopicDetail.m_ReplyInfor.m_ShowAll = !self.m_TopicDetail.m_ReplyInfor.m_ShowAll;
    
    [self drawContentLabel];
}

@end
