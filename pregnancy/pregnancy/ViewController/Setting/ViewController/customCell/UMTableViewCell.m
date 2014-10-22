//
//  UMUFPTableViewCell.m
//  UFP
//
//  Created by liu yu on 2/13/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import "UMTableViewCell.h"
#import "UMUFPImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UMTableViewCell

@synthesize mImageView = _mImageView;
@synthesize mNewIcon = _mNewIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor darkGrayColor];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.textColor = [UIColor darkGrayColor];
        
        _mImageView = [[UMUFPImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"um_placeholder.png"]];
		self.mImageView.frame = CGRectMake(20.0f, 6.0f, 48.0f, 48.0f);
		[self.contentView addSubview:self.mImageView];
        
        _mNewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 35, 30, 27, 15)];
        _mNewIcon.image = [UIImage imageNamed:@"um_cell_new_icon.png"];
		[self addSubview:_mNewIcon];
        _mNewIcon.hidden = YES;
        
        UIView *bgimageSel = [[UIView alloc] initWithFrame:self.bounds];
        bgimageSel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.4];
        self.selectedBackgroundView = bgimageSel;
        [bgimageSel release];
    }
    return self;
}

- (void)setImageURL:(NSString*)urlStr {    
    
	self.mImageView.imageURL = [NSURL URLWithString:urlStr];
}

- (void)dealloc {
    [_mImageView release];
    _mImageView = nil;
    
    [_mNewIcon release];
    _mNewIcon = nil;
    
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float topMargin = (self.bounds.size.height - 48) / 2;
    
    self.mImageView.frame = CGRectMake(15, topMargin, 48, 48);
    CGRect imageViewFrame = self.mImageView.frame;
    self.mImageView.layer.cornerRadius = 9.0;
    self.mImageView.layer.masksToBounds = YES;
    
    if ([self.mImageView.layer respondsToSelector:@selector(setShouldRasterize:)]) 
    {
        [self.mImageView.layer setShouldRasterize:YES]; 
        self.mImageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    }
    
    if ([self.layer respondsToSelector:@selector(setShouldRasterize:)]) 
    {
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        [self.layer setShouldRasterize:YES];        
    }
    
    CGFloat leftMargin = imageViewFrame.origin.x + imageViewFrame.size.width + 15;
    
    self.textLabel.frame = CGRectMake(leftMargin, 
                                      topMargin, 
                                      self.bounds.size.width - 110, 17);
    
    CGRect textLableFrame = self.textLabel.frame;
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGFloat width = self.bounds.size.width - 120;
    if (_mNewIcon.hidden)
    {
        width += 30;
    }
    self.detailTextLabel.frame = CGRectMake(leftMargin, 
                                            textLableFrame.origin.y + textLableFrame.size.height + 4, 
                                            width, 28);
}

@end