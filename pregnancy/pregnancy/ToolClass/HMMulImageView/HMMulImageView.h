//
//  HMMulImageView.h
//  Test
//
//  Created by babytree on 1/6/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>


#define HMMulImageView_DefaultGap       6

@interface HMMulImageView : UIView

@property (nonatomic, retain) NSArray *imageArray;
@property (assign) BOOL isCenter;

- (void)refreshView:(NSArray *)array WithFrame:(CGRect)frame;

@end
