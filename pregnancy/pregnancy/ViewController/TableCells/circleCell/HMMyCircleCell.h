//
//  HMCircleListCell.h
//  lama
//
//  Created by mac on 13-12-25.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMCircleClass.h"
#import "BBConfigureAPI.h"
#import "HMTouchScrollView.h"

@protocol HMMyCircleCellDelegate;

@interface HMMyCircleCell : UITableViewCell
<
    UIScrollViewDelegate
>
{
    BOOL s_IsMine;
}

@property (assign, nonatomic) id <HMMyCircleCellDelegate> delegate;

@property (retain, nonatomic) HMCircleClass *m_CircleClass;
@property (retain, nonatomic) NSIndexPath *theCurrentIndexPath;
@property (retain, nonatomic) IBOutlet UIImageView *m_BgImageView;
@property (retain, nonatomic) IBOutlet UIControl *m_TopBtn;
@property (nonatomic ,strong) IBOutlet UIImageView *m_MyBirthClub;

@property (retain, nonatomic) IBOutlet HMTouchScrollView *m_ScrollView;
@property (retain, nonatomic) IBOutlet UIView *m_ContentView;

@property (retain, nonatomic) IBOutlet UIImageView *m_CircleIconImageView;
@property (retain, nonatomic) IBOutlet UILabel *m_CircleTitleLabel;

@property (retain, nonatomic) IBOutlet UIImageView *m_MemberCountImageView;
@property (retain, nonatomic) IBOutlet UILabel *m_MemberCountLabel;
@property (retain, nonatomic) IBOutlet UIImageView *m_TodayImageView;
@property (retain, nonatomic) IBOutlet UILabel *m_TodayLabel;
@property (retain, nonatomic) IBOutlet UILabel *m_TodayCountLabel;

@property (retain, nonatomic) IBOutlet UIView *m_MemberTodayView;
@property (retain, nonatomic) IBOutlet UILabel *m_NoHospitalRemindLabel;

@property (weak, nonatomic) IBOutlet UIButton *m_ControlButton;

- (IBAction)ControlButton_action:(id)sender;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellContent:(HMCircleClass *)circleClass isMine:(BOOL)isMine;

- (void)makeCellStyle;
- (void)setCellContent:(HMCircleClass *)circleClass isMine:(BOOL)isMine;

@end


@protocol HMMyCircleCellDelegate <NSObject>

- (void)myCircleCellDidSelected:(HMMyCircleCell *)circleCell;
- (void)myCircleCellControlAction:(HMMyCircleCell *)circleCell withClass:(HMCircleClass *)circleCellClass withIndexPath:(NSIndexPath *)theIndexPath;

@optional
- (void)showHud:(NSString *)text delay:(NSTimeInterval)delay;
- (void)hideHud;

- (void)myCircleCell:(HMMyCircleCell *)circleCell changeTopState:(BOOL)topState;
- (void)myCircleCellSetTop:(HMMyCircleCell *)circleCell;

@end

