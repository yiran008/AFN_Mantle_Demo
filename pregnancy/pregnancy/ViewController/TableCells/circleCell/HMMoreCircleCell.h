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

@protocol HMMoreCircleCellDelegate;

@interface HMMoreCircleCell : UITableViewCell
<
    BBLoginDelegate
>

@property (assign, nonatomic) id <HMMoreCircleCellDelegate> delegate;

@property (retain, nonatomic) HMCircleClass *m_CircleClass;

@property (nonatomic, retain) ASIFormDataRequest *m_Requests;

@property (retain, nonatomic) IBOutlet UIImageView *m_BgImageView;

@property (retain, nonatomic) IBOutlet UIView *m_ContentView;

@property (retain, nonatomic) IBOutlet UIImageView *m_CircleIconImageView;
@property (retain, nonatomic) IBOutlet UILabel *m_CircleTitleLabel;


@property (retain, nonatomic) IBOutlet UIImageView *m_TopicCountImageView;
@property (retain, nonatomic) IBOutlet UILabel *m_TopicCountLabel;

@property (retain, nonatomic) IBOutlet UIImageView *m_MemberCountImageView;
@property (retain, nonatomic) IBOutlet UILabel *m_MemberCountLabel;


@property (retain, nonatomic) IBOutlet UILabel *m_CircleIntroLabel;

@property (retain, nonatomic) IBOutlet UIButton *m_CircleAddBtn;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellContent:(HMCircleClass *)circleClass;

- (void)makeCellStyle;

- (void)setCellContent:(HMCircleClass *)circleClass;


- (IBAction)circleAddBtn_Click:(id)sender;


@end


@protocol HMMoreCircleCellDelegate <NSObject>

- (void)showHud:(NSString *)text delay:(NSTimeInterval)delay;
- (void)hideHud;

@end

