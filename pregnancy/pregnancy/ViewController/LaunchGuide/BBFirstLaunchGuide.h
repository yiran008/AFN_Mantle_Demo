//
//  BBFirstLaunchGuide.h
//  babyrecord
//
//  Created by Wang Chris on 12-7-27.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBFirstLaunchGuide : BaseViewController <UIScrollViewDelegate> {
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    BOOL close;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (assign) BOOL isNewUser;
@end
