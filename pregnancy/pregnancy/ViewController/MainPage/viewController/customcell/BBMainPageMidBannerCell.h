//
//  BBMainPageMidBannerCell.h
//  pregnancy
//
//  Created by liumiao on 4/9/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBBannerView.h"
@interface BBMainPageMidBannerCell : UITableViewCell
@property (nonatomic,strong)BBBannerView *m_BannerView;

-(void)setCellUseData:(id)data;

@end
