//
//  BBMusicListCell.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBMusicListCell.h"

@interface BBMusicListCell ()
@property (nonatomic, retain) UILabel       *titleLabel;
@property (nonatomic, retain) UILabel       *sizeLabel;
@property (nonatomic, retain) UIButton      *actionButton;
@end

@implementation BBMusicListCell


- (void)dealloc
{
    [_musicInfo release];
    [_titleLabel release];
    [_sizeLabel release];
    [_actionButton release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier musicInfo:(NSDictionary *)info
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.musicInfo = info;
        [self addTitleLable];
        [self addSizeLabel];
        [self addActionButton];
        [self addSeparateLine];
    }
    return self;
}

- (void)addSeparateLine {
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 49, 320, 1)] autorelease];
    imageView.image = [UIImage imageNamed:@"sound_list_separate_line"];
    [self addSubview:imageView];
}
- (void)addTitleLable
{
    self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 220, 20)] autorelease];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16]; 
    self.titleLabel.textColor = [UIColor colorWithRed:102/255. green:102/255. blue:102/255. alpha:1];
    self.titleLabel.text = [self.musicInfo objectForKey:MUSIC_TITLE];
    [self addSubview:self.titleLabel];
}

- (void)addSizeLabel
{
    self.sizeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 220, 15)] autorelease];
    self.sizeLabel.textAlignment = NSTextAlignmentLeft;
    self.sizeLabel.backgroundColor = [UIColor clearColor];
    self.sizeLabel.font = [UIFont systemFontOfSize:12];
    self.sizeLabel.textColor = [UIColor colorWithRed:102/255. green:102/255. blue:102/255. alpha:1];
    self.sizeLabel.text = @"1.5M";
    [self addSubview:self.sizeLabel];
}

- (void)addActionButton
{
    self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.actionButton.exclusiveTouch = YES;
    [self changeStatusTitle];
    self.actionButton.frame = CGRectMake(230, 0, 80, 50);
    self.actionButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.actionButton setTitleColor:[UIColor colorWithRed:170/255. green:170/255. blue:170/255. alpha:1] forState:UIControlStateNormal];
    [self.actionButton addTarget:self action:@selector(actionButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.actionButton];
}

- (void)actionButtonPressed
{
    if (self.cellType == listCellType) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadMusic:)]) {
            [self.delegate downloadMusic:self];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteMusic:)]) {
            [self.delegate deleteMusic:self];
        }
    }
    
}

- (void)resetCell
{
    self.titleLabel.text = [self.musicInfo objectForKey:MUSIC_TITLE];
    long long size = [self.musicInfo longForKey:MUSIC_FILESIZE];
    
    self.sizeLabel.text = [NSString stringWithFormat:@"%2.1fM",size * 1.0/1024/1024];
    
    
    if (self.cellType == listCellType) {
        [self changeStatusTitle];
    }else {
        [self.actionButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.actionButton setImage:[UIImage imageNamed:@"music_delete"] forState:UIControlStateNormal];

    }
}

- (void)changeStatusTitle
{
    int status = [self.musicInfo intForKey:MUSIC_STATUS];
    [self changeStatusWith:status];
}

- (void)changeStatusWith:(int)status
{
    NSString *downloadStr = nil;
    NSString *imageName = nil;
    switch (status) {
        case DOWNLOAD_PRE:
            downloadStr = @"下载";
            imageName = @"download_pre";
            break;
        case DOWNLOAD_WAIT:
            downloadStr = @"等待";
            imageName = @"download_waiting";
            break;
        case DOWNLOAD_DOWNLOADING:
            downloadStr = @"下载中";
            imageName = @"downloading";
            break;
        case DOWNLOAD_PASUE:
            downloadStr = @"继续下载";
            imageName = @"download_pause";
            break;
        case DOWNLOAD_FAIL:
            downloadStr = @"下载失败";
            imageName = @"download_error";
            break;
        case DOWNLOAD_FINISH:
            downloadStr = @"已下载";
            imageName = @"download_done";
            break;
            
        default:
            break;
    }
    [self.actionButton setTitle:downloadStr forState:UIControlStateNormal];
    [self.actionButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setCellPlaying
{
    self.titleLabel.textColor = [UIColor colorWithRed:255/255. green:94/255. blue:122/255. alpha:1];
    self.sizeLabel.textColor = [UIColor colorWithRed:255/255. green:94/255. blue:122/255. alpha:1];
}
- (void)cancelCellPlaying
{
    self.sizeLabel.textColor = [UIColor colorWithRed:102/255. green:102/255. blue:102/255. alpha:1];
    self.titleLabel.textColor = [UIColor colorWithRed:102/255. green:102/255. blue:102/255. alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
