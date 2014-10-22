//
//  BBDraftBoxViewController.h
//  pregnancy
//
//  Created by mac on 13-5-7.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#if COMMON_USE_DRATFBOX

#import <UIKit/UIKit.h>
#import "HMDraftBoxCell.h"
#import "HMCreateTopicViewController.h"
#import "HMNoDataView.h"

@interface HMDraftBoxViewController : BaseViewController
<
    UITableViewDataSource,
    UITableViewDelegate,
    HMNoDataViewDelegate,
    HMDraftBoxCellDelegate,
    HMCreateTopicViewControllerDelegate
>

@property (nonatomic, retain) UITableView *m_TableView;

@property (nonatomic, retain) NSMutableArray *m_MessageArray;

@property (nonatomic, retain) HMNoDataView *m_NoDataView;

- (void)freshMessageData;


@end

#endif

