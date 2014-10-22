//
//  BBTopMemberCell.h
//  pregnancy
//
//  Created by whl on 14-9-2.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBTopMemberCellDelegate <NSObject>

- (void)clickedTopMemberRule;

@end

@interface BBTopMemberCell : UICollectionViewCell

@property (nonatomic,strong) IBOutlet UIView *m_Userview;

@property (nonatomic,strong) IBOutlet UIImageView *m_AvtarImage;

@property (nonatomic,strong) IBOutlet UILabel   *m_TopLabel;

@property (nonatomic,strong) IBOutlet UILabel   *m_Contributionlabel;

@property (nonatomic,strong) IBOutlet UIButton  *m_RuleButton;

@property (assign) id<BBTopMemberCellDelegate> delegate;

@end
