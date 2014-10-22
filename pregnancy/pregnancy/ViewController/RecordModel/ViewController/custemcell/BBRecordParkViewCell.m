//
//  BBRecordParkViewCell.m
//  pregnancy
//
//  Created by babytree on 13-9-27.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBRecordParkViewCell.h"
#import "BBPersonalViewController.h"

@implementation BBRecordParkViewCell

- (void)dealloc {
    [_avatarButton release];
    [_nicknameLabel release];
    [_contentBgImageView release];
    [_titleLabel release];
    [_photoButton release];
    [_babyAgeLabel release];
    [_createTsLabel release];
    [_lineView release];
    [_data release];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (void)setCellWithData:(NSDictionary *)dataDic
{
    self.data = dataDic;
    
    [self.avatarButton setImageWithURL:[NSURL URLWithString:[dataDic stringForKey:@"avatar_url"]] placeholderImage:[UIImage imageNamed:@"recordAvatar"]];
    [self.avatarButton.layer setMasksToBounds:YES];
    [self.avatarButton.layer setCornerRadius:20.0f];
    [self.nicknameLabel setText:[dataDic stringForKey:@"nickname"]];
    
    NSString *content=[dataDic stringForKey:@"text"];
    if (content==nil) {
        content = @"";
    }
    NSMutableString *contentStl = [[[NSMutableString alloc]initWithString:content]autorelease];
    [contentStl replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [contentStl length])];
    [contentStl replaceOccurrencesOfString:@"\r" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [contentStl length])];
    CGSize size = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(MAXFLOAT, 16.0) withFont:[UIFont systemFontOfSize:16.0f] withString:contentStl];
    NSInteger height = 0;
    if (size.width<=230) {
        height = 16;
    }else{
        height = 40;
    }
    self.titleLabel.height = height+2;
    [self.titleLabel setText:contentStl];
    
    if ([dataDic stringForKey:@"img_middle"]!=nil && ![[dataDic stringForKey:@"img_middle"]isEqualToString:@""]) {
        [self.photoButton setHidden:NO];
        if (content==nil || [content isEqualToString:@""]) {
            self.photoButton.top = 26;
            height += 180-16;
        }else{
            self.photoButton.top = 26+height+10;
            height += 190;
        }
        [self.photoButton setImageWithURL:[NSURL URLWithString:[dataDic stringForKey:@"img_middle"]] placeholderImage:nil];
       
    }else{
        [self.photoButton setHidden:YES];
    }
    
    UIImage *image = [[UIImage imageNamed:@"recordMoonContentBg"] stretchableImageWithLeftCapWidth:20 topCapHeight:32];
    self.contentBgImageView.height = 20+height;
    [self.contentBgImageView setImage:image];
    self.photoButton.exclusiveTouch = YES;
    
    self.babyAgeLabel.top = 70 + height - 18;
    [self.babyAgeLabel setText:[dataDic stringForKey:@"baby_age"]];
    self.createTsLabel.top  = 70 + height - 18;
    [self.createTsLabel setText:[BBTimeUtility stringDateWithPastTimestamp:[[dataDic stringForKey:@"create_ts"]intValue]]];
    self.lineView.top = 70+height-2;
    
    self.avatarButton.exclusiveTouch = YES;
    
}

- (IBAction)avatarEvent:(id)sender {
#if USE_RECORD_MODEL
    BBPersonalViewController *userInformation = [[[BBPersonalViewController alloc]initWithNibName:@"BBPersonalViewController" bundle:nil]autorelease];
    userInformation.userEncodeId = [self.data stringForKey:@"enc_user_id"];
    userInformation.userName = [self.data stringForKey:@"nickname"];
    [self.viewController.navigationController pushViewController:userInformation animated:YES];
#endif
}

- (IBAction)photoEvent:(id)sender {
    if (self.photoButton.imageView.image != nil) {
        [BBCacheData setCurrentTitle:@" "];
        NSString *photoUrl=[self.data stringForKey:@"img_big"];
        CGRect rect = [self.photoButton  convertRect:self.photoButton.bounds toView:self.viewController.view ];
        PicReviewView *pView = [[[PicReviewView alloc] initWithRect:rect placeholderImage:self.photoButton.imageView.image] autorelease];
        pView.shareTypeMark = BBShareTypeRecord;
        [pView loadUrl:[NSURL URLWithString:photoUrl]];
        [self.viewController.view addSubview:pView];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [self.viewController.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

+ (CGFloat) cellHeight:(NSDictionary *)dataDic
{
    NSString *content=[dataDic stringForKey:@"text"];
    if (content==nil) {
        content = @"";
    }
    NSMutableString *contentStl = [[[NSMutableString alloc]initWithString:content]autorelease];
    [contentStl replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [contentStl length])];
    [contentStl replaceOccurrencesOfString:@"\r" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [contentStl length])];
    CGSize size = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(MAXFLOAT, 16.0f) withFont:[UIFont systemFontOfSize:16.0f] withString:contentStl];
    NSInteger height = 0;
    if (size.width<=230) {
        height = 16;
    }else{
        height = 40;
    }
    if ([dataDic stringForKey:@"img_middle"]!=nil && ![[dataDic stringForKey:@"img_middle"]isEqualToString:@""]) {
        if (content==nil || [content isEqualToString:@""]) {
            height += 180-16;
        }else{
            height += 190;
        }
    }
    return 70+height;
}

@end
