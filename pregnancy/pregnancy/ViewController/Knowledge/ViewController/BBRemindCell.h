//
//  BBRemindCellTableViewCell.h
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBKonwlegdeModel.h"
#import "BBRemindCellAdView.h"
#import "BBRemindCellImageView.h"
#import "BBRemindCellContentView.h"
#import "BBAdModel.h"

#define REMIND_IMGEVIEW_MINHEIGHT 170.
#define REMIND_CONTENTVIEW_MINHEIGHT 78.
#define REMIND_ADVIEW_MINHEIGHT 0

@class BBRemindCell;

@protocol BBRemindDelegate <NSObject>
@optional
-(void)BBRemindCell:(BBRemindCell *)cell imageClicked:(UIImageView *)imageView;
@end

@interface BBRemindCell : UITableViewCell
- (void)setData:(BBKonwlegdeModel *)data AdData:(BBAdModel *)adData;
@property(nonatomic,assign)id<BBRemindDelegate>delegate;
@end
