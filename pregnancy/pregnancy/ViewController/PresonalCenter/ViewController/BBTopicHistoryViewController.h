//
//  BBTopicHistoryViewController.h
//  pregnancy
//
//  Created by MacBook on 14-9-3.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMNoDataView.h"

@interface BBTopicHistoryViewController : BaseViewController
<
    UITableViewDataSource,
    UITableViewDelegate,
    UIActionSheetDelegate,
    HMNoDataViewDelegate
>

@end
