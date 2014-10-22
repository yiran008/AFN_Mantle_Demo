//
//  BBImageScale.h
//  pregnancy
//
//  Created by Jun Wang on 12-5-21.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBImageScale : NSObject

+ (UIImage *)imageScalingWithOriginImage:(UIImage *)sourceImage;

+ (UIImage *)imageScalingForSize:(CGSize)targetSize withImage:(UIImage *)sourceImage;

+ (UIImage *)imageScalingToSmallSize:(UIImage *)sourceImage;

+ (UIImage *)imageScalingToBigSize:(UIImage *)sourceImage;

+ (UIImage *)scaleAndRotateImage:(UIImage *)image;

+ (UIImage*)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent;

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (CGSize)imageSmallSizeWithOriginImage:(UIImage *)image;

@end
