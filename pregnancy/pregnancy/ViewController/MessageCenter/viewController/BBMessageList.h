//
//  BBMessageList.h
//  pregnancy
//
//  Created by Wang Jun on 12-11-19.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTableViewController.h"

typedef NS_ENUM(NSUInteger, BBMessageListType)
{
    BBMessageListTypeFeed,      // 动态
    BBMessageListTypeMessage,   // 私信
    BBMessageListTypeNotice     // 通知
};

typedef NS_OPTIONS(NSUInteger, BBMessageRedPointStatus)
{
    BBMessageRedPointStatusNone         = 0,
    BBMessageRedPointStatusFeed         = 1 << 0,
    BBMessageRedPointStatusMessage      = 1 << 1,
    BBMessageRedPointStatusNotification = 1 << 2,
    BBMessageRedPointStatusAll          = BBMessageRedPointStatusFeed | BBMessageRedPointStatusMessage | BBMessageRedPointStatusNotification
};

@interface BBMessageList : HMTableViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign)BBMessageRedPointStatus m_MessageRedPointStatus;

@property (nonatomic, assign)BBMessageListType m_CurrentMessageListType;

@end
