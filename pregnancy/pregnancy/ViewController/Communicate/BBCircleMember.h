//
//  BBCircleMember.h
//  pregnancy
//
//  Created by whl on 14-9-1.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBMemberClass.h"
#import "EGORefreshPullUpTableHeaderView.h"
#import "HMRefreshTableHeaderView.h"
#import "BBTopMemberCell.h"


@interface BBCircleMember : BaseViewController
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    HMRefreshTableHeaderViewDelegate,
    EGORefreshPullUpTableHeaderDelegate,
    BBTopMemberCellDelegate
>
{
    BOOL _header_reloading;
    HMRefreshTableHeaderView *_refresh_header_view;
    
    BOOL _bottom_reloading;
    EGORefreshPullUpTableHeaderView *_refresh_bottom_view;

}
@property(nonatomic, assign) BBCircleMemberType m_CircleMembertype;

@property(nonatomic, strong) NSString *m_CircleID;

@property(nonatomic, strong) IBOutlet UIImageView *m_TopView;

@property(nonatomic, strong) IBOutlet UICollectionView *m_CollectionTable;

@property(assign) BOOL m_IsBirthdayClub;

@end
