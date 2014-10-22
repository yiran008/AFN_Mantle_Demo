//
//  BBCircleMemberCell.h
//  pregnancy
//
//  Created by whl on 14-9-2.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBMemberClass.h"

@interface BBCircleMemberCell : UICollectionViewCell

@property(nonatomic,strong) IBOutlet UIView      *m_UserView;
@property(nonatomic,strong) IBOutlet UIImageView *m_AvtarImage;
@property(nonatomic,strong) IBOutlet UILabel     *m_NameLabel;
@property(nonatomic,strong) IBOutlet UILabel     *m_RankLabel;
@property(nonatomic,strong) IBOutlet UILabel     *m_AdressLabel;
@property(nonatomic,strong) IBOutlet UILabel     *m_PregnancyLabel;
@property(nonatomic,strong) IBOutlet UILabel     *m_HospitalLabel;

@property(nonatomic,strong) IBOutlet UILabel     *m_Dislabel;

-(void)setMemberCellData:(BBMemberClass*)memberObj;

@end
