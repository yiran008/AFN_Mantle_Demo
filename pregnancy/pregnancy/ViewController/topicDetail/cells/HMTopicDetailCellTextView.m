//
//  HMTopicDetailCellTextView.m
//  lama
//
//  Created by mac on 13-8-6.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMTopicDetailCellTextView.h"
#import "HMTopicDetailVC.h"
#import "BBSupportTopicDetail.h"
#import "ARCHelper.h"
#import "BBPersonalViewController.h"

@implementation HMTopicDetailCellTextView
@synthesize m_StyledLabel;
@synthesize m_LinkCtrl;
@synthesize m_LinkBtn;

- (void)dealloc
{
    [m_StyledLabel ah_release];
    [m_LinkCtrl ah_release];
    
    [m_LinkBtn ah_release];
    
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

    m_StyledLabel.m_textColor = DETAIL_CONTENT_TEXT_COLOR;
    
    m_LinkCtrl.exclusiveTouch = YES;
    m_LinkBtn.exclusiveTouch = YES;

    m_StyledLabel.frame = CGRectMake(TOPIC_ALL_EDGE_DISTANCE, TOPICDETAILCELL_GAP, 320-12*2, 10);
    if (IOS_VERSION >= 7.0)
    {
        m_StyledLabel.top = TOPICDETAILCELL_GAP-4;
    }
    if (topicDetail.m_LinkType == HMTopicDetailCellView_LinkType_None)
    {
        m_LinkCtrl.tag = 0;
        m_StyledLabel.hidden = NO;
        m_LinkCtrl.hidden = YES;
        m_LinkBtn.hidden = YES;
    }
    else
    {
        if (self.m_TopicDetail.m_LinkUseBtn)
        {
            m_LinkBtn.tag = topicDetail.m_LinkType;
            m_LinkBtn.hidden = NO;
            m_StyledLabel.hidden = YES;
            m_LinkCtrl.hidden = YES;
        }
        else
        {
            m_StyledLabel.m_textColor = [UIColor blueColor];
            m_LinkCtrl.tag = topicDetail.m_LinkType;
            m_StyledLabel.hidden = NO;
            m_LinkCtrl.hidden = NO;
            m_LinkBtn.hidden = YES;
        }
    }
    
    if (self.m_TopicDetail.m_LinkUseBtn)
    {
        self.height = self.m_TopicDetail.m_Height;
        
        return;
    }
    
    m_StyledLabel.m_font = TOPIC_CONTENT_TEXT_FONT;
    m_StyledLabel.m_text = topicDetail.m_Text;
    
    if (topicDetail.m_ELabelDataArray.count)
    {
        m_StyledLabel.m_DataArray = [NSMutableArray arrayWithArray:topicDetail.m_ELabelDataArray];
        
        EmojiLabelData *emojiLabelData = [m_StyledLabel.m_DataArray lastObject];
        
        CGRect rect = emojiLabelData.m_Rect;
        CGFloat hei = rect.origin.y + rect.size.height;
        
        m_StyledLabel.height = hei;
        
        [m_StyledLabel setNeedsDisplay];
    }

    //[m_StyledLabel sizeToFit];

    m_LinkCtrl.height = m_StyledLabel.height;

//    self.height = self.m_TopicDetail.m_Height;
}

- (IBAction)link_Click:(id)sender
{
    UIControl *button = (UIControl *)sender;
    
    if (!self.m_PopViewController)
    {
        return;
    }
    
    if (button.tag == HMTopicDetailCellView_LinkType_Message)
    {
        //跳转站内连接
        if (![self.m_TopicDetail.m_LinkTopicId isNotEmpty])
        {
            return;
        }
        [BBStatistic visitType:BABYTREE_TYPE_TOPIC_IN_TOPIC contentId:self.m_TopicDetail.m_LinkTopicId];
        HMTopicDetailVC *topicDetail = [[[HMTopicDetailVC alloc]initWithNibName:@"HMTopicDetailVC" bundle:nil withTopicID:self.m_TopicDetail.m_LinkTopicId topicTitle:nil isTop:NO isBest:NO] ah_autorelease];
        
        topicDetail.hidesBottomBarWhenPushed = YES;
        [self.m_PopViewController pushViewController:topicDetail animated:YES];
    }
    else if (button.tag == HMTopicDetailCellView_LinkType_Out)
    {
        NSString *url = self.m_TopicDetail.m_LinkUrl;
        
        if (![url isNotEmpty])
        {
            return;
        }
        
        NSString *userEncodeId = nil;

        if ([url hasPrefix:@"http://home.babytree.com/"])
        {
            NSString *str = [url substringFromIndex:25];
            NSArray *arr = [str componentsSeparatedByString:@"/"];
            if ([arr count])
            {
                userEncodeId = [arr objectAtIndex:0];
            }
        }
        
        if (userEncodeId.length >= 4)
        {
            BBPersonalViewController * personVC = [[[BBPersonalViewController alloc]initWithNibName:@"BBPersonalViewController" bundle:nil] ah_autorelease];
            personVC.userEncodeId = userEncodeId;
            personVC.hidesBottomBarWhenPushed = YES;

            [self.m_PopViewController pushViewController:personVC animated:YES];

            return;
        }

        if ([url hasPrefix:@"http://www.babytree.com/"])
        {
            NSString *topicId = nil;
            //NSString *page = nil;
            NSString *floor = nil;
            NSArray *arr = [url componentsSeparatedByString:@"/"];
            if ([arr count])
            {
                floor = [arr lastObject];
            }

            floor = [floor stringByReplacingString:@"topic_" withString:@""];
            floor = [floor stringByReplacingString:@".html#floor_" withString:@"#"];
            arr = [floor componentsSeparatedByString:@"#"];
            if (arr.count == 2)
            {
                floor = [arr lastObject];
                topicId = [arr firstObject];
                arr = [topicId componentsSeparatedByString:@"_"];
                if (arr.count == 2)
                {
                    topicId = [arr firstObject];
                }
                else
                {
                    topicId = nil;
                }

                NSInteger intFloor = [floor intValue];

                if ([topicId isNotEmpty] && (intFloor > 0))
                {
                    [self.delegate setFloorWithTopicId:topicId floor:intFloor];

                    return;
                }
            }
        }
        BBSupportTopicDetail *exteriorLink = [[[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil] ah_autorelease];
        exteriorLink.isShowCloseButton = NO;
        exteriorLink.loadURL = url;
        [exteriorLink.navigationItem setTitle:@"详情页"];
        [self.m_PopViewController pushViewController:exteriorLink animated:YES];
    }
}

@end
