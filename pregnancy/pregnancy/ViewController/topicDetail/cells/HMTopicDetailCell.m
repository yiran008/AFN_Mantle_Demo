//
//  BBNewTopicDetailCell.m
//  lama
//
//  Created by 王 鸿禄 on 13-5-22.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMTopicDetailCell.h"

#import "HMTopicDetailCellHeadView.h"
#import "HMTopicDetailCellFloorView.h"
#import "HMTopicDetailCellReplyView.h"
#import "HMTopicDetailCellTextView.h"
#import "HMTopicDetailCellImageView.h"
#import "ARCHelper.h"

@implementation HMTopicDetailCell
@synthesize m_CellView;
@synthesize m_PopViewController;

- (void)dealloc
{
    [m_CellView ah_release];

    [super ah_dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withtype:(HMTopicDetailCell_Type)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.m_CellView = nil;
        
        switch (type)
        {
            case TOPICDETAILCELL_MASTERHEADER_TYPE:
            case TOPICDETAILCELL_REPLYHEADER_TYPE:
                self.m_CellView = [[[NSBundle mainBundle] loadNibNamed:@"HMTopicDetailCellHeadView" owner:self options:nil] objectAtIndex:0];
                break;
                
            case TOPICDETAILCELL_MASTERFLOOR_TYPE:
            case TOPICDETAILCELL_REPLYFLOOR_TYPE:
                self.m_CellView = [[[NSBundle mainBundle] loadNibNamed:@"HMTopicDetailCellFloorView" owner:self options:nil] objectAtIndex:0];
                break;
                
            case TOPICDETAILCELL_REPLYCONTENT_TYPE:
//                if ([BBAppInfo openOldTopicDetail])
                {
                    self.m_CellView = [[[NSBundle mainBundle] loadNibNamed:@"HMTopicDetailCellReplyView" owner:self options:nil] objectAtIndex:0];
                }
                break;
                
            case TOPICDETAILCELL_TEXTCONTENT_TYPE:
            case TOPICDETAILCELL_TEXTLINK_TYPE:
                self.m_CellView = [[[NSBundle mainBundle] loadNibNamed:@"HMTopicDetailCellTextView" owner:self options:nil] objectAtIndex:0];
                break;
                
            case TOPICDETAILCELL_IMAGECONTENT_TYPE:
            case TOPICDETAILCELL_IMAGELINK_TYPE:
                self.m_CellView = [[[NSBundle mainBundle] loadNibNamed:@"HMTopicDetailCellImageView" owner:self options:nil] objectAtIndex:0];
                break;
                
            default:
                break;
        }
        
        if (self.m_CellView)
        {
            [self addSubview:self.m_CellView];
        }
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


// 获取topic的样式和展现内容
- (void)drawTopicDetailCell:(HMTopicDetailCellClass *)topicDetail withTopicDelegate:(id <HMTopicDetailCellDelegate>)topicDelagate
{
    switch (topicDetail.m_Type)
    {
        case TOPICDETAILCELL_MASTERHEADER_TYPE:
        case TOPICDETAILCELL_REPLYHEADER_TYPE:
        {
            HMTopicDetailCellHeadView *cellView = (HMTopicDetailCellHeadView *)self.m_CellView;
            [cellView drawTopicDetailCell:topicDetail withTopicDelegate:topicDelagate];
            cellView.m_PopViewController = m_PopViewController;
        }
            break;
            
        case TOPICDETAILCELL_MASTERFLOOR_TYPE:
        case TOPICDETAILCELL_REPLYFLOOR_TYPE:
        {
            HMTopicDetailCellFloorView *cellView = (HMTopicDetailCellFloorView *)self.m_CellView;
            [cellView drawTopicDetailCell:topicDetail withTopicDelegate:topicDelagate];
        }
            break;
            
        case TOPICDETAILCELL_REPLYCONTENT_TYPE:
        {
//            if ([BBAppInfo openOldTopicDetail])
            {
                HMTopicDetailCellReplyView *cellView = (HMTopicDetailCellReplyView *)self.m_CellView;
                [cellView drawTopicDetailCell:topicDetail withTopicDelegate:topicDelagate];
            }
        }
            break;
            
        case TOPICDETAILCELL_TEXTCONTENT_TYPE:
        case TOPICDETAILCELL_TEXTLINK_TYPE:
        {
            HMTopicDetailCellTextView *cellView = (HMTopicDetailCellTextView *)self.m_CellView;
            [cellView drawTopicDetailCell:topicDetail withTopicDelegate:topicDelagate];
            cellView.m_PopViewController = m_PopViewController;
        }
            break;
            
        case TOPICDETAILCELL_IMAGECONTENT_TYPE:
        case TOPICDETAILCELL_IMAGELINK_TYPE:
        {
            HMTopicDetailCellImageView *cellView = (HMTopicDetailCellImageView *)self.m_CellView;
            [cellView drawTopicDetailCell:topicDetail withTopicDelegate:topicDelagate];
            cellView.m_PopViewController = m_PopViewController;
        }
            break;
            
        default:
            break;
    }
}


@end
