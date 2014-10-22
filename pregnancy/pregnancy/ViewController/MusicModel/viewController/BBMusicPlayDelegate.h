//
//  BBMusicPlayDelegate.h
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-15.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BBMusicPlayerController;

@protocol BBMusicPlayDelegate <NSObject>
@optional
- (void)play:(BBMusicPlayerController *)musicPlayerController;
- (void)pause:(BBMusicPlayerController *)musicPlayerController;

- (void)nextMusic:(BBMusicPlayerController *)musicPlayerController;
- (void)preMusic:(BBMusicPlayerController *)musicPlayerController;
- (void)changePlayTime:(BBMusicPlayerController *)musicPlayerController;
- (void)setCycleType:(BBMusicPlayerController *)musicPlayerController;
- (void)musicDidFinish:(BBMusicPlayerController *)musicPlayerController;
@end
