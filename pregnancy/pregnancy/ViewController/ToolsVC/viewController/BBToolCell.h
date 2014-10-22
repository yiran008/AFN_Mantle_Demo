//
//  BBToolCell.h
//  pregnancy
//
//  Created by liumiao on 9/15/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBBadgeButton.h"

@interface BBToolCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet BBBadgeButton *m_ToolButton;
@property (strong, nonatomic) IBOutlet UILabel *m_ToolNameLabel;
@end
