//
//  BBTopListMemberCell.h
//  pregnancy
//
//  Created by whl on 14-9-3.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBMemberClass.h"

@interface BBTopListMemberCell : UICollectionViewCell

@property(nonatomic,strong) IBOutlet UIView      *m_UserView;
@property(nonatomic,strong) IBOutlet UIImageView *m_AvtarImage;
@property(nonatomic,strong) IBOutlet UILabel     *m_NameLabel;
@property(nonatomic,strong) IBOutlet UILabel     *m_RankLabel;
@property(nonatomic,strong) IBOutlet UILabel     *m_AdressLabel;
@property(nonatomic,strong) IBOutlet UILabel     *m_PregnancyLabel;
@property(nonatomic,strong) IBOutlet UILabel     *m_ContributionLabel;

@property(nonatomic,strong) IBOutlet UILabel     *m_TopLabel;

@property(nonatomic,strong) IBOutlet UILabel     *m_SignLabel;

@property(nonatomic,strong) IBOutlet UIImageView *m_SignImage;

-(void)setMemberCellData:(BBMemberClass*)memberObj;


@end
