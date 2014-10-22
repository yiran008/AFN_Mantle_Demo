//
//  BBAdminCell.h
//  pregnancy
//
//  Created by whl on 14-8-29.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCircleAdminClass.h"

@protocol BBAdminCellDelegate <NSObject>

-(void)clickedSendMessage:(BBCircleAdminClass*)adminObj;

@end

@interface BBAdminCell : UICollectionViewCell

@property(nonatomic, strong) IBOutlet UIImageView  *m_AvatarImage;
@property(nonatomic, strong) IBOutlet UILabel      *m_NameLabel;
@property(nonatomic, strong) IBOutlet UILabel      *m_AdressLabel;
@property(nonatomic, strong) IBOutlet UILabel      *m_PregnancyLabel;
@property(nonatomic, strong) IBOutlet UIButton     *m_SendMessageButton;
@property(nonatomic, strong) IBOutlet UILabel      *m_RankLabel;

@property(nonatomic, strong)BBCircleAdminClass *m_AdminObj;

@property(assign) id<BBAdminCellDelegate> delegate;

-(void)setCollectionCellData:(BBCircleAdminClass*)adminObj;

@end
