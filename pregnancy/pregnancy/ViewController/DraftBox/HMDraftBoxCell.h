//
//  HMDraftBoxCell.h
//  lama
//
//  Created by Heyanyang on 13-11-3.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDraftBoxDB.h"
#import "HMTouchScrollView.h"


@class HMDraftBoxCell;
@class HMDraftBoxData;

@protocol HMDraftBoxCellDelegate <NSObject>

- (void)deleteDraft:(HMDraftBoxData *)draftBoxData;
- (void)draftBoxCellDidSelected:(HMDraftBoxCell *)circleCell;
- (void)draftBoxCell:(HMDraftBoxCell *)circleCell changeTopState:(BOOL)topState;

@end

@interface HMDraftBoxCell : UITableViewCell
<
//    UIGestureRecognizerDelegate,
    UIScrollViewDelegate
>


@property (nonatomic, assign) id <HMDraftBoxCellDelegate> delegate;

@property (nonatomic, retain) HMDraftBoxData *m_DraftBoxData;
@property (retain, nonatomic) IBOutlet UIButton *m_delBtn;

@property (retain, nonatomic) IBOutlet UIImageView *m_PhotoIcon;
@property (retain, nonatomic) IBOutlet UILabel *m_ContentLabel;
@property (retain, nonatomic) IBOutlet UILabel *m_TimeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *m_ArrowImageView;

@property (retain, nonatomic) IBOutlet UIView *m_ContentView;
@property (retain, nonatomic) IBOutlet HMTouchScrollView *m_ScrollView;
@property (nonatomic, assign) BOOL m_CellStateLeft;

- (IBAction)deleteButtonAction:(id)sender;

- (void)makeCellStyle;
- (void)setCellContent:(HMDraftBoxData *)draftBoxData;

- (void)resetCellStateLeft;

@end
