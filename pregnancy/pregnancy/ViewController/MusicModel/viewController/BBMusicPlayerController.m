//
//  BBMusicPlayerController.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-15.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBMusicPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BBDownloadManager.h"
@interface BBMusicPlayerController ()
@property (nonatomic, retain) UIButton              *playButton;
@property (nonatomic, retain) UIButton              *cycleButton;
@property (nonatomic, retain) UILabel               *timeLabel;
@property (nonatomic, retain) UIProgressView        *progressView;
@property (nonatomic, retain) UILabel               *titleLabel;
@property (nonatomic, retain) NSTimer               *timer;

@property (nonatomic, assign) UIBackgroundTaskIdentifier    newTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier    oldTaskId;
@property (nonatomic, assign) BOOL                  isInBackground;
@property (nonatomic, assign) BOOL                  continuePlayInWAN;

@end

@implementation BBMusicPlayerController

#pragma mark - lifecyle
- (void)dealloc
{
    [_musicInfo release];
    [_musicUrl release];
    _musicPlayer.delegate = nil;
    [_musicPlayer release];
    [_playButton release];
    [_cycleButton release];
    [_progressView release];
    [_timeLabel release];
    [_titleLabel release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addBgImageView];
    [self addPlayButton];
    [self addPreButton];
    [self addCycleButton];
    [self addNextButton];
    [self addTimeLabel];
    [self addTitleLabel];
    [self addProcessSlider];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    
    //后台播放音频设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    self.musicPlayer = [[[AudioPlayer alloc] init] autorelease];
    self.musicPlayer.delegate = self;
    
    _timer = [NSTimer timerWithTimeInterval:0.25 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
	
	[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    self.playButton.exclusiveTouch = YES;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}



- (void)didBecomeActive:(NSNotification *)notification
{
    self.isInBackground = NO;
    if (self.oldTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.oldTaskId];
    }
    //    [self resetWithMusicInfo:nil];
}

- (void)willResignActive:(NSNotification *)notification
{
    self.isInBackground = YES;
    [self startBackgoundTask];
}

#pragma mark - create UI

- (void)addBgImageView {
    UIImageView *bgImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
    bgImageView.image = [UIImage imageNamed:@"music_control_bg"];
    [self.view addSubview:bgImageView];
}


- (void)addPlayButton {
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.exclusiveTouch = YES;
    self.playButton.frame = CGRectMake(141, 19, 38, 38);
    self.playButton.backgroundColor = [UIColor clearColor];
    [self.playButton setImage:[UIImage imageNamed:@"music_player_star"] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
}

- (void)addNextButton {
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.exclusiveTouch = YES;
    nextButton.frame = CGRectMake(195, 23, 30, 30);
    [nextButton setImage:[UIImage imageNamed:@"music_player_foward"] forState:UIControlStateNormal];
    [nextButton setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    [nextButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}

- (void)addPreButton {
    UIButton *preButton = [UIButton buttonWithType:UIButtonTypeCustom];
    preButton.exclusiveTouch = YES;
    preButton.frame = CGRectMake(95, 23, 30, 30);
    //    [preButton setTitle:@"pre" forState:UIControlStateNormal];
    [preButton setImage:[UIImage imageNamed:@"music_player_pre"] forState:UIControlStateNormal];
    [preButton setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    [preButton addTarget:self action:@selector(preButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:preButton];
}

- (void)addProcessSlider {
    self.progressView = [[[UIProgressView alloc] initWithFrame:CGRectMake(0, -4, 320, 10)] autorelease];
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    UIImage *minImage = [UIImage imageNamed:@"slider-metal-track.png"];
	UIImage *maxImage = [UIImage imageNamed:@"music_track.png"];
    CGAffineTransform transform =CGAffineTransformMakeScale(1.0f,0.2f);
    self.progressView.transform = transform;
    
	minImage=[minImage stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
	maxImage=[maxImage stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    
    [self.progressView setProgressImage:minImage];
    [self.progressView setTrackImage:maxImage];
    self.progressView.progress = 0;
    
    [self.view addSubview:self.progressView];
}

- (void)addTitleLabel {
    self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 7, 180, 15)] autorelease];
    self.titleLabel.text = [self.musicInfo stringForKey:@"title"];//@"我们都有一个家";
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithRed:102/255. green:102/255. blue:102/255. alpha:1];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.titleLabel];
}

- (void)addTimeLabel {
    self.timeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(230, 7, 100, 15)] autorelease];
    self.timeLabel.text = @"00:00/00:00";
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor colorWithRed:102/255. green:102/255. blue:102/255. alpha:1];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.timeLabel];
}

- (void)addCycleButton {
    self.cycleButton = [[[UIButton alloc] initWithFrame:CGRectMake(260, 25, 60, 30)] autorelease];
    self.cycleButton.exclusiveTouch = YES;
    [self.cycleButton setImage:[UIImage imageNamed:@"sequence"] forState:UIControlStateNormal];
    [self.cycleButton setImageEdgeInsets:UIEdgeInsetsMake(3, 14, 3, 14)];
    [self.cycleButton addTarget:self action:@selector(cycleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cycleButton];
}


#pragma mark - private method

- (id)initWithMusicInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        // Initialization code
        self.musicInfo = info;
        self.cycleType = orderCycleType;
        self.continuePlayInWAN = NO;
    }
    return self;
    
}

- (void)startBackgoundTask
{
    self.newTaskId = UIBackgroundTaskInvalid;
    self.newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    if (self.newTaskId != UIBackgroundTaskInvalid && self.oldTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.oldTaskId];
    }
    self.oldTaskId  = self.newTaskId;
    
}

- (NSString *)getTimeStringFromCount:(int)timeCount {
    int minute = 0, second = 0;
    minute = timeCount / 60;
    second = timeCount - 60 * minute;
    
    NSString *minuteString;
    NSString *secondString;
    
    if (minute < 10) {
        minuteString = [NSString stringWithFormat:@"0%d",minute];
    }else {
        minuteString = [NSString stringWithFormat:@"%d",minute];
    }
    
    if (second < 10) {
        secondString = [NSString stringWithFormat:@"0%d",second];
    }else {
        secondString = [NSString stringWithFormat:@"%d",second];
    }
    
    return [NSString stringWithFormat:@"%@:%@",minuteString,secondString];
    
}

#pragma mark - music play control


- (void)playButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (self.musicPlayer.state == AudioPlayerStatePlaying) {
        [button setImage:[UIImage imageNamed:@"music_player_star"] forState:UIControlStateNormal];
        [self.musicPlayer pause];
    }else if(self.musicPlayer.state == AudioPlayerStatePaused){
        [button setImage:[UIImage imageNamed:@"music_player_pause"] forState:UIControlStateNormal];
        [self.musicPlayer resume];
    }else {
        [button setImage:[UIImage imageNamed:@"music_player_pause"] forState:UIControlStateNormal];
        [self play];
    }
    
}

- (void)nextButtonPressed:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(nextMusic:)]) {
        [self.delegate nextMusic:self];
    }
}

- (void)preButtonPressed:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(preMusic:)]) {
        [self.delegate preMusic:self];
    }
}

- (void)cycleButtonPressed:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    
    
    if (self.cycleType == orderCycleType) {
        self.cycleType = singleCycleType;
        [button setImage:[UIImage imageNamed:@"one"] forState:UIControlStateNormal];
    }else if(self.cycleType == singleCycleType) {
        self.cycleType = randomCycleType;
        [button setImage:[UIImage imageNamed:@"random"] forState:UIControlStateNormal];
        
    }else if(self.cycleType == randomCycleType) {
        self.cycleType = orderCycleType;
        [button setImage:[UIImage imageNamed:@"sequence"] forState:UIControlStateNormal];
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(setCycleType:)]) {
        [self.delegate setCycleType:self];
    }
}


- (void)play
{
    NSURL *playUrl = [NSURL URLWithString:[self.musicInfo stringForKey:@"url"]];
    [self resetWithMusicInfo:nil];
    if ([self.musicInfo intForKey:MUSIC_STATUS] == DOWNLOAD_FINISH) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = nil;
        if ([paths count] > 0)
            documentsDirectory = [paths objectAtIndex:0];
        NSString *str = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",[self.musicInfo stringForKey:MUSIC_ID]]];
        playUrl = [NSURL fileURLWithPath:str];
        
    }else {
        BBDownloadManager *downloadManager = [BBDownloadManager sharedInstance];
        if (downloadManager.netStatus == ReachableViaWWAN) {
            if (!self.continuePlayInWAN) {
                [self.musicPlayer stop];
                [self.playButton setImage:[UIImage imageNamed:@"music_player_star"] forState:UIControlStateNormal];
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"你当前处于2g/3g网络下，继续播放可能会产生流量费用，你确定要继续下载。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续播放", nil] autorelease];
                alert.tag = 100;
                [alert show];
                return;
            }
            
            
        }else if (downloadManager.netStatus == NotReachable) {
            [self.playButton setImage:[UIImage imageNamed:@"music_player_star"] forState:UIControlStateNormal];
            [AlertUtil showAlert:nil withMessage:@"请打开网络！"];
            
        }

        
    }
//    [self configNowPlayingInfoCenter];
    [self.musicPlayer setDataSource:[self.musicPlayer dataSourceFromURL:playUrl] withQueueItemId:playUrl];
    
}



- (void)stop
{
    
    [self.musicPlayer stop];
}

#pragma mark - update musicController data

- (void)resetWithMusicInfo:(NSDictionary *)info
{
    self.titleLabel.text = [self.musicInfo stringForKey:@"title"];
    self.timeLabel.text = @"00:00/00:00";
}

- (void)updateProgress
{
    if (!self.musicPlayer || self.musicPlayer.duration == 0)
	{
		self.progressView.progress = 0;
		
		return;
	}
	
    self.progressView.progress = self.musicPlayer.progress * 1.0 / self.musicPlayer.duration;
    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",[self getTimeStringFromCount:self.musicPlayer.progress],[self getTimeStringFromCount:self.musicPlayer.duration]];
    [self configNowPlayingInfoCenter];
}

- (void)closeMusicPlayer
{
    [self.musicPlayer stop];
    [_timer invalidate];
    _timer = nil;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlPause:
                [self playButtonPressed:self.playButton];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self playButtonPressed:self.playButton];
                break;
            case UIEventSubtypeRemoteControlPlay:
                [self playButtonPressed:self.playButton];
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self preButtonPressed:nil];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [self nextButtonPressed:nil];
                break;
                
            default:
                break;
        }
    }
}


- (void)configNowPlayingInfoCenter {
    NSMutableDictionary * dict = [[[NSMutableDictionary alloc] init]autorelease];
    [dict setObject:[self.musicInfo objectForKey:MUSIC_TITLE] forKey:MPMediaItemPropertyTitle];
    
    //    MPMediaItemArtwork * mArt = [[[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"backgroundSoundImage"]] autorelease];
    //    [dict setObject:mArt forKey:MPMediaItemPropertyArtwork];
    [dict setObject:[NSNumber numberWithInt:self.musicPlayer.duration] forKey:MPMediaItemPropertyPlaybackDuration];
    [dict setObject:[NSNumber numberWithLong:(long)self.musicPlayer.progress] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    
}

#pragma mark - AudioPlayerDelegate

-(void) audioPlayer:(AudioPlayer*)audioPlayer stateChanged:(AudioPlayerState)state
{
    if (audioPlayer.state == AudioPlayerStatePaused)
	{
        [self.playButton setImage:[UIImage imageNamed:@"music_player_star"] forState:UIControlStateNormal];
	}
	else if (audioPlayer.state == AudioPlayerStatePlaying)
	{
        [self.playButton setImage:[UIImage imageNamed:@"music_player_pause"] forState:UIControlStateNormal];
	}
	else
	{
        [self.playButton setImage:[UIImage imageNamed:@"music_player_star"] forState:UIControlStateNormal];
	}
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didEncounterError:(AudioPlayerErrorCode)errorCode
{
    //网络断的时候会进入AudioPlayerErrorDataNotFound
    if (errorCode == AudioPlayerErrorDataNotFound) {
        if ([BBDownloadManager sharedInstance].netStatus == NotReachable) {
            if (self.musicPlayer.state == AudioPlayerStateError) {
                [self.musicPlayer stop];
            }
        }
    }
    
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
    
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(AudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    if (stopReason == AudioPlayerStopReasonNoStop && progress > duration - 3 && duration > 0) {
        //AudioPlayerStopReasonNoStop表示正常播放结束，但是有些异常情况下不正常结束也进入这里，所以用progress > duration - 3增加了一个保护判断.
        if (self.delegate && [self.delegate respondsToSelector:@selector(musicDidFinish:)]) {
            if (self.isInBackground) {
                [self startBackgoundTask];
            }
            [self.delegate musicDidFinish:self];
        }
    }else if(stopReason == AudioPlayerStopReasonEof) {
        if (self.isInBackground) {
            [self startBackgoundTask];
        }
        [self.delegate musicDidFinish:self];
    }if (stopReason == AudioPlayerStopReasonNoStop && progress == 0 && duration == 0) {
        
    }
    
}

#pragma mark - UIAlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [self.playButton setImage:[UIImage imageNamed:@"music_player_pause"] forState:UIControlStateNormal];
            self.continuePlayInWAN = YES;
            [self play];
        }
    }
}

@end
