//
//  BBUserPersonalTopicViewController.h
//  pregnancy
//
//  Created by zhangzhongfeng on 14-1-8.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBTopicDetailDelegate.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshPullUpTableHeaderView.h"

typedef NS_ENUM(NSUInteger, BBTOPIC_TYPE)
{
    BBTOPIC_TYPE_REPLAY = 0,
    BBTOPIC_TYPE_POST,
    BBTOPIC_TYPE_COLLECTION
};

@interface BBUserPersonalTopicViewController : BaseViewController
<
    UITableViewDataSource,
    UITableViewDelegate,
    BBTopicDetailDelegate,
    EGORefreshTableHeaderDelegate,
    EGORefreshPullUpTableHeaderDelegate
>
{
    EGORefreshTableHeaderView *_refresh_header_view;
    BOOL _reloading;
    
    BOOL _pull_up_reloading;
    EGORefreshPullUpTableHeaderView *_refresh_pull_up_header_view;
}

@property (nonatomic, assign) BBTOPIC_TYPE topicType;
@property (retain, nonatomic) NSString *userEncodeId;

@end

