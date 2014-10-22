//
//  HMImageWallView.h
//  lama
//
//  Created by mac on 13-10-29.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HMImageWallView_DefaultCount        4
#define HMImageWallView_DefaultMaxCount     9

#define HMImageWallView_DefaultGap          8

#define HMImageWallView_StartTag            100

@protocol HMImageWallViewDelegate;

@interface HMImageWallView : UIView

@property (nonatomic, assign) id <HMImageWallViewDelegate> delegate;

@property (nonatomic, assign) NSInteger m_MaxCount;
@property (nonatomic, assign) NSInteger m_CountPerLine;

@property (nonatomic, retain) NSMutableArray *m_ImageDataArray;

- (void)drawWithArray:(NSArray *)array;

@end


@protocol HMImageWallViewDelegate <NSObject>

- (void)imageWallView:(UIImage *)image didSelecte:(NSInteger)index;

- (void)imageWallViewAddImage;

@end


