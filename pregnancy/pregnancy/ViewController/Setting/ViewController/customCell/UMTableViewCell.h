//
//  UMUFPTableViewCell.h
//  UFP
//
//  Created by liu yu on 2/13/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMUFPImageView;

@interface UMTableViewCell : UITableViewCell {
@private
	UMUFPImageView *_mImageView;
    UIImageView *_mNewIcon;
}

@property (nonatomic, retain) UMUFPImageView *mImageView;
@property (nonatomic, retain) UIImageView *mNewIcon;

- (void)setImageURL:(NSString*)urlStr;

@end