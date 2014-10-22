//
//  BBCircleAdminList.h
//  pregnancy
//
//  Created by whl on 14-8-29.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBAdminCell.h"

@interface BBCircleAdminList : BaseViewController
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    BBAdminCellDelegate,
    BBLoginDelegate
>

@property(nonatomic, strong) IBOutlet UICollectionView *m_AdminTable;
@property(nonatomic, strong) NSString *m_CircleID;

@end
