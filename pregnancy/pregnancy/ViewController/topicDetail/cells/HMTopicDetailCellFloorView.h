//
//  HMTopicDetailCellFloorView.h
//  lama
//
//  Created by mac on 13-8-5.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTopicDetailCellView.h"
#import "ASIFormDataRequest.h"

#import "GDTMobBannerView.h"
#import "BaiduMobAdDelegateProtocol.h"

@interface HMTopicDetailCellFloorView : HMTopicDetailCellView
<
    GDTMobBannerViewDelegate,
    BaiduMobAdViewDelegate
>
{
    BOOL isSendingLove;
}


@property (retain, nonatomic) IBOutlet UIImageView *m_PublishImageView;
@property (retain, nonatomic) IBOutlet UILabel *m_PublishLabel;
@property (weak, nonatomic) IBOutlet UIImageView *m_CityImageView;
@property (weak, nonatomic) IBOutlet UILabel *m_CityLabel;

@property (retain, nonatomic) IBOutlet UIButton *m_ReplyBtn;

// 添加喜欢
@property (nonatomic, retain) ASIFormDataRequest *m_LoveRequest;
@property (nonatomic, retain) UIActivityIndicatorView *m_ActivityView;

@property (nonatomic, retain) UIImageView *m_adImageView;
@end
