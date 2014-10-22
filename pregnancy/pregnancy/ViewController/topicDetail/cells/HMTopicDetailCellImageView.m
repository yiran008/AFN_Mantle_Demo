//
//  HMTopicDetailCellImageView.m
//  lama
//
//  Created by mac on 13-8-6.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMTopicDetailCellImageView.h"
#import "UIImageView+WebCache.h"
#import "HMTopicDetailVC.h"
#import "BBSupportTopicDetail.h"
#if OPENPIC_MODE
#import "PicReviewView.h"
#endif
#import "ARCHelper.h"

@implementation HMTopicDetailCellImageView
@synthesize m_ImageView;
@synthesize m_LinkCtrl;
@synthesize m_BigImageArray;
@synthesize m_BigImageUrlArray;

- (void)dealloc
{
    [m_ImageView ah_release];
    [m_LinkCtrl ah_release];
    [m_BigImageArray ah_release];
    [m_BigImageUrlArray ah_release];
    
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
    
    m_ImageView.top = TOPICDETAILCELL_GAP;
    m_ImageView.height = topicDetail.m_ImageHeight;
    m_ImageView.width = topicDetail.m_ImageWidth;
    m_ImageView.left = TOPIC_ALL_EDGE_DISTANCE;// (UI_SCREEN_WIDTH - m_ImageView.width)/2;

    if (![topicDetail.m_PreImageUrl isNotEmpty])
    {
        m_ImageView.contentMode = UIViewContentModeScaleAspectFit;
        [m_ImageView setImage:[UIImage imageNamed:@"topicPictureDefault"]];
    }
    else
    {
        m_ImageView.contentMode = UIViewContentModeScaleAspectFit;
        NSURL *url = [NSURL URLWithString:topicDetail.m_PreImageUrl];
        [m_ImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"topicPictureDefault"] options:0];
    }

    m_LinkCtrl.tag = topicDetail.m_LinkType;
    m_LinkCtrl.frame = m_ImageView.frame;
    m_LinkCtrl.exclusiveTouch = YES;
    
//    self.height = self.m_TopicDetail.m_Height;
    
    // 居中
    //[m_ImageView centerInSuperView];
}

- (IBAction)link_Click:(id)sender
{
    UIControl *button = (UIControl *)sender;
    
    NSString *photoUrl = self.m_TopicDetail.m_ImageUrl;
    if (button.tag == HMTopicDetailCellView_LinkType_None && photoUrl != nil)
    {                
        if ([m_BigImageUrlArray isNotEmpty])
        {
            NSMutableArray *photos = [NSMutableArray array];
            
            for (NSInteger i = 0; i<m_BigImageUrlArray.count; i++)
            {
                NSString *bigUrl = [m_BigImageUrlArray objectAtIndex:i];
            
                if ([bigUrl isNotEmpty])
                {
                    MJPhoto *photo = [[[MJPhoto alloc] init] ah_autorelease];
                    photo.url = [NSURL URLWithString:bigUrl]; // 图片路径
                    photo.shareEnable = YES;
                    [photos addObject:photo];
                    if (self.m_TopicDetail.m_ImageIndex == i)
            {
                        photo.srcImageView = m_ImageView;
            }
        }
        }
        
            if ([photos count])
            {
                MJPhotoBrowser *browser = [[[MJPhotoBrowser alloc] init] ah_autorelease];
                if (self.m_TopicDetail.m_ImageIndex < m_BigImageUrlArray.count)
        {
                    browser.currentPhotoIndex = self.m_TopicDetail.m_ImageIndex;
                    browser.firstPhotoIndex = self.m_TopicDetail.m_ImageIndex;
                }
                browser.photos = photos;
                browser.delegate = self;
                [browser show];
            }
        }
    }
    else if (button.tag == HMTopicDetailCellView_LinkType_Message)
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
        BBSupportTopicDetail *exteriorLink = [[[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil] ah_autorelease];
        exteriorLink.isShowCloseButton = NO;
        exteriorLink.loadURL = url;
        //        [exteriorLink.navigationItem setTitle:HM_WEB_DEFAULT_TITLE];
        [self.m_PopViewController pushViewController:exteriorLink animated:YES];
    }
}


#pragma mark - MJPhotoBrowserDelegate

// 切换到某一页图片
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(setFloorWithPicIndex:)])
    {
        [self.delegate setFloorWithPicIndex:index];
    }
}

- (void)photoBrowserClose
{
    if ([self.delegate respondsToSelector:@selector(closeMJPhotoShow)])
    {
        [self.delegate closeMJPhotoShow];
    }
}

@end
