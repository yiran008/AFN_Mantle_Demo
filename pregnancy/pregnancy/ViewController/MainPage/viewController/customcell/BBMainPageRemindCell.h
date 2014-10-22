//
//  BBMainPageRemindCell.h
//  pregnancy
//
//  Created by liumiao on 4/9/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBMainPageRemindCell : UITableViewCell
@property (nonatomic,strong)UILabel *m_ContentLabel;
@property (nonatomic,strong)UIView *m_BgView;
@property (nonatomic,strong)UILabel *m_HeaderLabel;
@property (nonatomic,strong)UILabel *m_TitleLabel;

-(void)setCellUseData:(id)data;

@end
