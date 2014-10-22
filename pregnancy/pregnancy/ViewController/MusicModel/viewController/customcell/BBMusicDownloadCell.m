//
//  BBMusicDownloadCell.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBMusicDownloadCell.h"

@interface BBMusicDownloadCell ()
@property (nonatomic, retain) UIButton          *downloadButton;
@property (nonatomic, retain) UIButton          *shareButton;
@end

@implementation BBMusicDownloadCell

- (void)dealloc
{
    [_downloadButton release];
    [_shareButton release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        self.contentView.backgroundColor = [UIColor grayColor];
        [self addShareButton];
        [self addDownloadButton];
    }
    return self;
}

- (void)addDownloadButton {
    self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadButton.exclusiveTouch = YES;
    [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    self.downloadButton.frame = CGRectMake(180, 15, 50, 20);
    [self.downloadButton addTarget:self action:@selector(startDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.downloadButton];
}

- (void)addShareButton {
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.exclusiveTouch = YES;
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.shareButton setTitle:@"分享" forState:UIControlStateNormal];
    self.shareButton.frame = CGRectMake(250, 15, 50, 20);
    [self addSubview:self.shareButton];
}

- (void)startDownload {
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadMusic)]) {
        [self.delegate downloadMusic];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
