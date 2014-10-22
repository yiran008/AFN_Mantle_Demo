//
//  BBMusicDownloadCell.h
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBMusicDownloadCellDelegate ;
@interface BBMusicDownloadCell : UITableViewCell
@property (nonatomic, assign) id<BBMusicDownloadCellDelegate>delegate;

@end

@protocol BBMusicDownloadCellDelegate <NSObject>
@optional
- (void)downloadMusic;
- (void)shareMusic;

@end
