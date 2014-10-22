//
//  BBUserCollection.h
//  pregnancy
//
//  Created by whl on 14-4-11.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshPullUpTableHeaderView.h"

@interface BBUserCollection : BaseViewController
<
    UITableViewDataSource,
    UITableViewDelegate,
    EGORefreshTableHeaderDelegate,
    EGORefreshPullUpTableHeaderDelegate
>
{
    EGORefreshTableHeaderView *_refresh_header_view;
    BOOL _reloading;
    
    BOOL _pull_up_reloading;
    EGORefreshPullUpTableHeaderView *_refresh_pull_up_header_view;
}

@property(nonatomic, strong) ASIHTTPRequest *m_CollectRequest;
@property(nonatomic, strong) ASIHTTPRequest *m_KnowladgeRequest;
@property(nonatomic, strong) ASIHTTPRequest *m_DeleteRequest;
@property(nonatomic, strong) IBOutlet UITableView *m_TopicTable;
@property(nonatomic, strong) MBProgressHUD *m_LoadProgress;


@end
