//
//  BBBandInfomation.h
//  pregnancy
//
//  Created by whl on 14-4-14.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBFillBandCode.h"

@protocol BBBandInfomationDelegate  <NSObject>

-(void)closeBandInfomationView;

@end


@interface BBBandInfomation : BaseViewController
<
    BBFillBandCodeDelegate
>

@property(nonatomic, strong) IBOutlet UIButton *m_InviteButton;
@property(nonatomic, strong) IBOutlet UIButton *m_FillButton;
@property (nonatomic, assign) id <BBBandInfomationDelegate> delegate;

@end
