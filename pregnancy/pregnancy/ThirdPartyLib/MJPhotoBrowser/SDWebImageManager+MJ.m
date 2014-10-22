//
//  SDWebImageManager+MJ.m
//  FingerNews
//
//  Created by mj on 13-9-23.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "SDWebImageManager+MJ.h"
#import "SDWebImageManager.h"

@implementation SDWebImageManager (MJ)
+ (void)downloadWithURL:(NSURL *)url
{
    [[SDWebImageManager sharedManager] downloadWithURL:url delegate:self options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil success:nil failure:nil];

    
//    // cmp不能为空
//    [[self sharedManager] downloadWithURL:url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//    
//    }];
    
}
@end
