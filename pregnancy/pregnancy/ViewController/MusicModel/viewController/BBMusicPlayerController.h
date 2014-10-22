//
//  BBMusicPlayerController.h
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-15.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBMusicPlayDelegate.h"
#import "AudioPlayer.h"
typedef enum {
    orderCycleType          = 0,
    singleCycleType         = 1,
    randomCycleType         = 2
}MusicCyleType;

@interface BBMusicPlayerController : BaseViewController<AudioPlayerDelegate,UIAlertViewDelegate>


@property (nonatomic, retain) NSDictionary  *musicInfo;
@property (nonatomic, assign) id<BBMusicPlayDelegate> delegate;
@property (nonatomic, retain) NSURL *musicUrl;
@property (nonatomic, assign) MusicCyleType     cycleType;
@property (nonatomic, retain) AudioPlayer       *musicPlayer;


- (void)play;
- (void)stop;
- (void)closeMusicPlayer;
- (id)initWithMusicInfo:(NSDictionary *)info;
- (void)resetWithMusicInfo:(NSDictionary *)info;
@end
