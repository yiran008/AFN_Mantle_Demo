//
//  BBMusicViewController.h
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-15.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ScanViewController.h"
#import "BBMusicPlayerController.h"
#import "BBMusicListCell.h"
#import "BBMusicDownloadCell.h"
typedef enum {
    showAllMusic        = 0,
    showDownloadMusic   = 1
}MusicShowType;//标识当前音乐列表显示的种类 音乐盒或者本地音乐

typedef enum {
    netMusic        = 0,
    localMusic      = 1
}MusicPlayType;//标识当前视频的播放列表类型，音乐盒或者本地音乐

@interface BBMusicViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,BBMusicPlayDelegate,BBMusicListDelegate,BBMusicDownloadCellDelegate>

@property (nonatomic, retain) NSDictionary *musicTypeInfo;


- (void)setDownloadStatus:(int)downloadStatus withMusicInfo:(NSMutableDictionary *)music;
@end
