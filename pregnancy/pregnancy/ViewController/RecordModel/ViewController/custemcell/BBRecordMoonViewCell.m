//
//  BBRecordMoonViewCell.m
//  pregnancy
//
//  Created by babytree on 13-9-27.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBRecordMoonViewCell.h"

@implementation BBRecordMoonViewCell

- (void)dealloc {
    [_pointImageView release];
    [_contentBgImageView release];
    [_titleLabel release];
    [_photoButton release];
    [_timeBgImageView release];
    [_thatAgeLabel release];
    [_createTsLabel release];
    [_theCurrentClass release];
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
- (void)setCellWithData:(BBRecordClass *)theClass
{
    self.theCurrentClass = theClass;
    if (self.theCurrentClass.date == nil) {
        self.pointImageView.top = 28;
        [self.contentBgImageView setHidden:NO];
        [self.titleLabel setHidden:NO];
        [self.photoButton setHidden:NO];
        [self.timeBgImageView setHidden:YES];
        [self.thatAgeLabel setHidden:YES];
        [self.createTsLabel setHidden:YES];

        [self.pointImageView setImage:[UIImage imageNamed:@"recordMoonPoint2"]];
        
        
        NSString *content=theClass.text;
        NSInteger height = 0;
        if (content==nil) {
            content = @"";
        }
        NSMutableString *contentStl = [[[NSMutableString alloc]initWithString:content]autorelease];
        [contentStl replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [contentStl length])];
        [contentStl replaceOccurrencesOfString:@"\r" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [contentStl length])];
        CGSize size = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(MAXFLOAT, 16.0f) withFont:[UIFont systemFontOfSize:16.0f] withString:contentStl];
        if (size.width<=240) {
            height = 16;
        }else{
            height = 40;
        }
        self.titleLabel.height = height+2;
        [self.titleLabel setText:contentStl];
        
        if ([theClass.img_middle isNotEmpty]) {
            [self.photoButton setHidden:NO];
            if (content==nil || [content isEqualToString:@""]) {
                self.photoButton.top = 30;
                height += 180-16;
            }else{
                self.photoButton.top = 30+height+10;
                height += 190;
            }
            [self.photoButton setImageWithURL:[NSURL URLWithString:theClass.img_middle] placeholderImage:nil];
            
        }else{
            [self.photoButton setHidden:YES];
        }
        UIImage *image = [[UIImage imageNamed:@"recordMoonContentBg"] stretchableImageWithLeftCapWidth:20 topCapHeight:32];
        self.contentBgImageView.height = 20+height;
        [self.contentBgImageView setImage:image];
    }else{
         self.pointImageView.top = 32;
        [self.contentBgImageView setHidden:YES];
        [self.titleLabel setHidden:YES];
        [self.photoButton setHidden:YES];
         [self.timeBgImageView setHidden:NO];
        [self.thatAgeLabel setHidden:NO];
        [self.createTsLabel setHidden:NO];
        
        [self.thatAgeLabel setText:theClass.that_time_age];
        [self.createTsLabel setText:theClass.date];
        [self.pointImageView setImage:[UIImage imageNamed:@"recordMoonPoint1"]];
        
        
    }
}

- (IBAction)photoEvent:(id)sender {
    if (self.photoButton.imageView.image != nil) {
        [BBCacheData setCurrentTitle:@" "];
        NSString *photoUrl=self.theCurrentClass.img_big;
        CGRect rect = [self.photoButton  convertRect:self.photoButton.bounds toView:self.viewController.view ];
        PicReviewView *pView = [[[PicReviewView alloc] initWithRect:rect placeholderImage:self.photoButton.imageView.image] autorelease];
        pView.shareTypeMark = BBShareTypeRecord;
        [pView loadUrl:[NSURL URLWithString:photoUrl]];
        [self.viewController.view addSubview:pView];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [self.viewController.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

+ (CGFloat) cellHeight:(BBRecordClass *)theClass
{
    NSInteger height = 0;
    if (theClass.date == nil) {
        NSString *content=theClass.text;
        if (content==nil) {
            content = @"";
        }
        NSMutableString *contentStl = [[[NSMutableString alloc]initWithString:content]autorelease];
        [contentStl replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [contentStl length])];
        [contentStl replaceOccurrencesOfString:@"\r" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [contentStl length])];
        CGSize size = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(MAXFLOAT, 16.0) withFont:[UIFont systemFontOfSize:16.0f] withString:contentStl];
        if (size.width<=240) {
            height = 16;
        }else{
            height = 40;
        }
        if ([theClass.img_middle isNotEmpty]) {
            if (content==nil || [content isEqualToString:@""]) {
                height += 180-16;
            }else{
                height += 190;
            }
        }
        height+=30;
    }else{
        height = 56;
    }
    return height + 10;
}

@end
