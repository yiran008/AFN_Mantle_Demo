//
//  HMDraftBoxCell.m
//  lama
//
//  Created by Heyanyang on 13-11-3.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMDraftBoxCell.h"

@implementation HMDraftBoxCell
@synthesize delegate;
@synthesize m_DraftBoxData;

@synthesize m_ContentView;
@synthesize m_ScrollView;
@synthesize m_CellStateLeft;

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

- (void)makeCellStyle
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.m_ContentView.backgroundColor = UI_CELL_BGCOLOR;

//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPressed:)];
//    [self.m_ScrollView addGestureRecognizer:tapGestureRecognizer];
//    self.m_ScrollView.exclusiveTouch = YES;
//    [tapGestureRecognizer release];
}

- (void)resetCellStateLeft
{
    self.m_CellStateLeft = NO;
    self.m_ScrollView.contentOffset = CGPointZero;
}

- (void)setCellContent:(HMDraftBoxData *)draftBoxData
{
    self.m_ScrollView.contentSize = CGSizeMake(self.contentView.width + self.m_delBtn.width, self.contentView.height);
    
    [self resetCellStateLeft];
    
    self.m_DraftBoxData = draftBoxData;

    if ([m_DraftBoxData.m_Title isNotEmpty])
    {
        self.m_ContentLabel.text = m_DraftBoxData.m_Title;
        self.m_ContentLabel.textColor = UI_TEXT_CONTENT_COLOR;
    }
    else if ([m_DraftBoxData.m_Content isNotEmpty])
    {
        self.m_ContentLabel.text = m_DraftBoxData.m_Content;
        self.m_ContentLabel.textColor = UI_TEXT_CONTENT_COLOR;
    }
    else
    {
        self.m_ContentLabel.text = @"分享图片";
        self.m_ContentLabel.textColor = UI_TEXT_CONTENT_COLOR;
    }
    
    if (m_DraftBoxData.m_PicArray.count > 0)
    {
        self.m_PhotoIcon.hidden = NO;
        self.m_ContentLabel.left = 45;
        self.m_ContentLabel.width = 240;
    }
    else
    {
        self.m_PhotoIcon.hidden = YES;
        self.m_ContentLabel.left = 10;
        self.m_ContentLabel.width = 275;
    }
    
    self.m_TimeLabel.text = [NSDate hmStringDateFromDate:m_DraftBoxData.m_Timetmp];
    self.m_TimeLabel.textColor = [UIColor colorWithHex:0xCCCCCC];
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.m_CellStateLeft)
    {
        if (velocity.x <= -0.5f)
        {
            targetContentOffset->x = 0;
            self.m_CellStateLeft = NO;
        }
        else
        {
            if (targetContentOffset->x <= self.m_delBtn.width/2)
            {
                targetContentOffset->x = 0;
                self.m_CellStateLeft = NO;
            }
            else
            {
                targetContentOffset->x = self.m_delBtn.width;
                self.m_CellStateLeft = YES;
            }
        }
    }
    else
    {
        if (velocity.x >= 0.5f)
        {
            targetContentOffset->x = self.m_delBtn.width;
            self.m_CellStateLeft = YES;
        }
        else
        {
            if (targetContentOffset->x <= self.m_delBtn.width/2)
            {
                targetContentOffset->x = 0;
                self.m_CellStateLeft = NO;
            }
            else
            {
                targetContentOffset->x = self.m_delBtn.width;
                self.m_CellStateLeft = YES;
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(draftBoxCell:changeTopState:)])
    {
        [self.delegate draftBoxCell:self changeTopState:self.m_CellStateLeft];
    }
}


#pragma mark -
#pragma mark cell Selection

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *array = [touches allObjects];

    if (array.count == 1)
    {
        UITouch *touch = array[0];

        CGPoint point = [touch locationInView:self];

        if (self.m_CellStateLeft)
        {
            if (point.x >= self.m_delBtn.left && point.x <= self.m_delBtn.right)
            {
                // 点击置顶不换色
                return;
            }
        }
    }

    self.m_ContentView.backgroundColor = UI_CELL_SELECT_BGCOLOR;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.m_ContentView.backgroundColor = UI_CELL_BGCOLOR;

    NSArray *array = [touches allObjects];

    if (array.count == 1)
    {
        UITouch *touch = array[0];
        
        //NSLog(@"%@", NSStringFromCGPoint([touch locationInView:self.m_BgImageView]));

        CGPoint point = [touch locationInView:self];

        if (self.m_CellStateLeft)
        {
            if (point.x >= self.m_delBtn.left && point.x <= self.m_delBtn.right)
            {
                [self deleteButtonAction:nil];

                return;
            }
        }

        [self resetCellStateLeft];

        if ([self.delegate respondsToSelector:@selector(draftBoxCellDidSelected:)])
        {
            [self.delegate draftBoxCellDidSelected:self];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
    self.m_ContentView.backgroundColor = UI_CELL_BGCOLOR;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.m_ContentView.backgroundColor = UI_CELL_BGCOLOR;
}

//- (void)scrollViewPressed:(UITapGestureRecognizer *)gestureRecognizer
//{
//    CGPoint point = [gestureRecognizer locationInView:self];
//
//    //NSLog(@"%@", NSStringFromCGPoint(point));
//
//    if (self.m_CellStateLeft)
//    {
//        if (point.x >= self.m_delBtn.left)
//        {
//            [self deleteButtonAction:nil];
//
//            return;
//        }
//    }
//
//    [self resetCellStateLeft];
//
//    if ([self.delegate respondsToSelector:@selector(draftBoxCellDidSelected:)])
//    {
//        [self.delegate draftBoxCellDidSelected:self];
//    }
//}


#pragma mark -
#pragma mark action

- (IBAction)deleteButtonAction:(id)sender
{
    [self.delegate deleteDraft:self.m_DraftBoxData];
}


@end
