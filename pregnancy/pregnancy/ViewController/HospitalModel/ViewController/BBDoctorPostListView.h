//
//  BBNewBirthclubListView.h
//  pregnancy
//
//  Created by babytree babytree on 12-5-10.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSelectArea.h"
#import "BBDoctorPostListViewData.h"
#import "BBRefreshSetImageBg.h"

@interface BBDoctorPostListView : BaseViewController
<
    CallBack,
    RefreshTopicCallBack,
    RefreshCallBack,
    BBRefreshSetImageBg,
    BBLoginDelegate
>
{
    NSString *navigationTitle;
    UILabel *headTitleLabel;
    NSString *groupId;
    BBDoctorPostListViewData *bbDoctorPostListViewData;
    BBListView *listView;
    NSDictionary *doctorData;
}

@property (nonatomic,strong) NSString *navigationTitle;
@property (nonatomic,strong) UILabel *headTitleLabel;
@property (nonatomic,strong) NSString *groupId;
@property (nonatomic,strong) BBDoctorPostListViewData *bbDoctorPostListViewData;
@property (nonatomic,strong) BBListView *listView;
@property (nonatomic,strong) NSDictionary *doctorData;
- (void)createTopic;
@end