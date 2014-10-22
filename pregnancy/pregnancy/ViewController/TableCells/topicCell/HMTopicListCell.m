//
//  HMCircleTopicCell.m
//  lama
//
//  Created by mac on 14-1-3.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMTopicListCell.h"
#import "UIButton+WebCache.h"
#import "HMShowPage.h"

@implementation HMTopicListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    //自定义删除按钮UI，只对收藏列表有效
    if (!self.m_IsForCollection)
    {
        return;
    }
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask)
    {
        [self recurseAndReplaceSubViewIfDeleteConfirmationControl:self.subviews];
        [self performSelector:@selector(recurseAndReplaceSubViewIfDeleteConfirmationControl:) withObject:self.subviews afterDelay:0];
    }
}

-(void)recurseAndReplaceSubViewIfDeleteConfirmationControl:(NSArray*)subviews
{
    for (UIView *subview in subviews)
    {
        //handles ios6 and earlier
//        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"])
//        {
//            //we'll add a view to cover the default control as the image used has a transparent BG
//            UIView *deleteView = (UIView *)[subview.subviews objectAtIndex:0];
//            UIView *backgroundCoverDefaultControl = [[UIView alloc] initWithFrame:CGRectMake(0,0, deleteView.size.width, 33)];
//            [backgroundCoverDefaultControl setBackgroundColor:[UIColor whiteColor]];//assuming your view has a white BG
//            [[subview.subviews objectAtIndex:0] addSubview:backgroundCoverDefaultControl];
//            UIImage *deleteImage = [UIImage imageNamed:delete_button_name];
//            UIImageView *deleteBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,deleteImage.size.width, deleteImage.size.height)];
//            [deleteBtn setImage:[UIImage imageNamed:delete_button_name]];
//            [[subview.subviews objectAtIndex:0] addSubview:deleteBtn];
//        }
        //the rest handles ios7
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationButton"])
        {
            UIButton *deleteButton = (UIButton *)subview;
            if ([self.m_TopicCellClass.m_PicArray isNotEmpty])
            {
                //带有图的固定尺寸
                deleteButton.top = 8;
                deleteButton.height = 64;
            }
            else
            {
                deleteButton.top = 8;
                deleteButton.height = deleteButton.frame.size.height-9;
            }
            //[deleteButton setImage:[UIImage imageNamed:delete_button_name] forState:UIControlStateNormal];
            //[deleteButton setTitle:@"取消收藏" forState:UIControlStateNormal];
//            for(UIView* view in subview.subviews){
//                if([view isKindOfClass:[UILabel class]]){
//                    [view removeFromSuperview];
//                }
//            }
        }
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"])
        {
            for(UIView* innerSubView in subview.subviews){
                if(![innerSubView isKindOfClass:[UIButton class]]){
                    [innerSubView removeFromSuperview];
                }
            }
        }
        if([subview.subviews count]>0){
            [self recurseAndReplaceSubViewIfDeleteConfirmationControl:subview.subviews];
        }
        
    }
}

- (void)makeCellStyle
{
    self.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor = UI_CELL_SELECT_BGCOLOR;
    self.exclusiveTouch = YES;

    self.m_ContentView.backgroundColor = UI_CELL_BGCOLOR;

    self.m_TitleBgView.backgroundColor = [UIColor clearColor];
    self.m_TitleLabel.textColor = UI_TEXT_TITLE_COLOR;
    self.m_TitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.m_BottomBoxView.backgroundColor = [UIColor clearColor];

    self.m_MasterIconView.image = [UIImage imageNamed:@"topiccell_icon_head"];
    self.m_TimeIconView.image = [UIImage imageNamed:@"topiccell_icon_time"];
    self.m_ReplyIconView.image = [UIImage imageNamed:@"topiccell_icon_reply"];
    self.m_MasterNameLabel.textColor = UI_TEXT_QUOTE_COLOR;
    self.m_TimeLabel.textColor = UI_TEXT_QUOTE_COLOR;
    self.m_ReplyCountLabel.textColor = UI_DEFAULT_BGCOLOR;

    self.m_PicView = [[HMMulImageView alloc] init];
    [self.m_ContentView addSubview:self.m_PicView];
}

- (void)setTopicCellData:(HMTopicClass *)topicCellClass topicType:(NSInteger)type
{
    self.m_TopicCellClass = topicCellClass;

    self.m_MarkIconTopView.hidden = YES;
    self.m_MarkIconNewView.hidden = YES;
    self.m_MarkIconEtView.hidden = YES;
    self.m_MarkIconHelpView.hidden = YES;
    self.m_MarkIconPicView.hidden = YES;

    self.m_MarkIconTopView.left = 10;
    self.m_MarkIconNewView.left = 10;
    self.m_MarkIconEtView.left = 10;
    self.m_MarkIconHelpView.left = 10;
    self.m_MarkIconPicView.left = 10;

//    if (self.m_TopicCellClass.m_Mark & TopicMark_Top)
//    {
//        self.m_MarkIconTopView.hidden = NO;
//
//        self.m_MarkIconNewView.left = self.m_MarkIconTopView.right + 4;
//        self.m_MarkIconEtView.left = self.m_MarkIconTopView.right + 4;
//        self.m_MarkIconHelpView.left = self.m_MarkIconTopView.right + 4;
//        self.m_MarkIconPicView.left = self.m_MarkIconTopView.right + 4;
//    }

    if (self.m_TopicCellClass.m_Mark & TopicMark_New)
    {
        self.m_MarkIconNewView.hidden = NO;

        self.m_MarkIconEtView.left = self.m_MarkIconNewView.right + 4;
        self.m_MarkIconHelpView.left = self.m_MarkIconNewView.right + 4;
        self.m_MarkIconPicView.left = self.m_MarkIconNewView.right + 4;
    }
    
    if (self.m_TopicCellClass.m_Mark & TopicMark_Extractive)
    {
        self.m_MarkIconEtView.hidden = NO;

        self.m_MarkIconHelpView.left = self.m_MarkIconEtView.right + 4;
        self.m_MarkIconPicView.left = self.m_MarkIconEtView.right + 4;
    }

    if (self.m_TopicCellClass.m_Mark & TopicMark_Help)
    {
        self.m_MarkIconHelpView.hidden = NO;
        self.m_MarkIconPicView.left = self.m_MarkIconHelpView.right + 4;
    }

    if (self.m_TopicCellClass.m_Mark & TopicMark_HasPic)
    {
        self.m_MarkIconPicView.hidden = NO;
    }

    NSString *title = [NSString spaceWithFont:[UIFont systemFontOfSize:16.0f] top:NO new:(self.m_TopicCellClass.m_Mark & TopicMark_New) best:(self.m_TopicCellClass.m_Mark & TopicMark_Extractive) help:(self.m_TopicCellClass.m_Mark & TopicMark_Help)  pic:(self.m_TopicCellClass.m_Mark & TopicMark_HasPic) add:0];
    
    if(self.isSearch)
    {
      [self.m_TitleLabel setAttributedText:self.m_TopicCellClass.m_TitleAttribut];
    }
    else
    {
        self.m_TitleLabel.text = [NSString stringWithFormat:@"%@%@", title, self.m_TopicCellClass.m_Title];
    }
    
    if (self.m_TopicCellClass.m_TitleLines == 2)
    {
        self.m_TitleLabel.height = 42;
        self.m_TitleBgView.height = TOPIC_CELL_TITLE_TWOLINE_HEIGHT;
    }
    else
    {
        self.m_TitleLabel.height = 24;
        self.m_TitleBgView.height = TOPIC_CELL_TITLE_ONELINE_HEIGHT;
    }

    self.m_BottomBoxView.top = self.m_TitleBgView.bottom;
    self.m_PicView.top = self.m_TitleBgView.bottom;

    if ([self.m_TopicCellClass.m_PicArray isNotEmpty])
    {
        self.m_PicView.hidden = NO;
        
        [self.m_PicView refreshView:self.m_TopicCellClass.m_PicArray WithFrame:CGRectMake(0, self.m_TitleBgView.bottom, self.m_TopicCellClass.m_ImageWidth, self.m_TopicCellClass.m_ImageHeight)];

        self.m_BottomBoxView.top = self.m_PicView.bottom;
    }
    else
    {
        self.m_PicView.hidden = YES;
    }

    self.m_MasterNameLabel.text = self.m_TopicCellClass.m_MasterName;
    if (type == 1)
    {
        self.m_TimeLabel.text = [NSDate hmStringDateFromTs:self.m_TopicCellClass.m_CreateTime];
    }
    else
    {
        self.m_TimeLabel.text = [NSDate hmStringDateFromTs:self.m_TopicCellClass.m_ResponseTime];
    }
    self.m_ReplyCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.m_TopicCellClass.m_ResponseCount];

    self.m_ContentView.height = self.m_BottomBoxView.bottom;
    self.m_BottomLine.top = self.m_ContentView.bottom;
    
    [self.m_MasterIconView setImage:[UIImage imageNamed:@"topiccell_icon_head"]];
    if ([self.m_TopicCellClass.m_UserSign isNotEmpty])
    {
        [self.m_MasterIconView setImageWithURL:[NSURL URLWithString:self.m_TopicCellClass.m_UserSign] placeholderImage:[UIImage imageNamed:@"topiccell_icon_head"]];
    }
}

- (IBAction)masterClick:(id)sender
{
    if ([self.m_TopicCellClass.m_MasterId isNotEmpty] && self.viewController != nil && self.viewController.navigationController != nil)
    {
        [HMShowPage showPersonalCenter:self.viewController userEncodeId:self.m_TopicCellClass.m_MasterId];
    }
}

@end
