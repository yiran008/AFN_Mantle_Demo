//
//  BBImageScale.m
//  pregnancy
//
//  Created by Jun Wang on 12-5-21.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBImageScale.h"

@implementation BBImageScale

+ (UIImage *)imageScalingWithOriginImage:(UIImage *)sourceImage
{
    return [self imageScalingForSize:CGSizeMake(1280, 1280) withImage:sourceImage];
}

+ (UIImage *)imageScalingForSize:(CGSize)targetSize withImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    if (width <= targetWidth && height <= targetHeight) {
        return sourceImage;
    }
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        if (width > height) {
            scaleFactor = targetWidth / width;
        } else {
            scaleFactor = targetHeight / height;
        }

        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        @try {
            UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight)); 
            
            [sourceImage drawInRect:CGRectMake(0, 0, scaledWidth, scaledHeight)];
            
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();

        } @catch (NSException *exception) {
            return sourceImage;
        }
        return newImage;
    }      
    
    return sourceImage;
}

+ (UIImage *)imageScalingToSmallSize:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat targetWidth = 146;
    CGFloat targetHeight = 146;
    
    if (CGSizeEqualToSize(imageSize, CGSizeMake(146, 146)) == NO) {
        @try {
            UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight)); 
            
            [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
            
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
        } @catch (NSException *exception) {
            return sourceImage;
        }
        
        return newImage;
    }
    return sourceImage;
}

+ (UIImage *)imageScalingToBigSize:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = 0.0;
    CGFloat scaledHeight = 0.0;
    
    if (width <= 452) {
        return sourceImage;
    }
    
    scaleFactor = 452 / width;
    
    scaledWidth  = width * scaleFactor;
    scaledHeight = height * scaleFactor;
    
    @try {
        UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight)); 
        
        [sourceImage drawInRect:CGRectMake(0, 0, scaledWidth, scaledHeight)];
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    } @catch (NSException *exception) {
        return sourceImage;
    }
    
    return newImage;  
}

#pragma mark - deal with image orientation

+ (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = 960; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


+ (UIImage*)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent{
    
    CGSize imageSize = image.size;
    
    CGFloat width = imageSize.width;
    
    CGFloat height = imageSize.height;
    
    CGFloat scaleFactor = 0.0;
    
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    
    CGFloat widthFactor = thumbSize.width / width;
    
    CGFloat heightFactor = thumbSize.height / height;
    
    if (widthFactor > heightFactor)  {
        
        scaleFactor = widthFactor;
        
    }
    
    else {
        
        scaleFactor = heightFactor;
        
    }
    
    CGFloat scaledWidth  = width * scaleFactor;
    
    CGFloat scaledHeight = height * scaleFactor;
    
    if (widthFactor > heightFactor)
        
    {
        
        thumbPoint.y = (thumbSize.height - scaledHeight) * 0.5;
        
    }
    
    else if (widthFactor < heightFactor)
        
    {
        
        thumbPoint.x = (thumbSize.width - scaledWidth) * 0.5;
        
    }
    
    UIGraphicsBeginImageContext(thumbSize);
    
    CGRect thumbRect = CGRectZero;
    
    thumbRect.origin = thumbPoint;
    
    thumbRect.size.width  = scaledWidth;
    
    thumbRect.size.height = scaledHeight;
    
    [image drawInRect:thumbRect];
    
    
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return thumbImage;
}


+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

+ (CGSize)imageSmallSizeWithOriginImage:(UIImage *)image
{
    CGFloat max = 40.0f;
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGSize size = CGSizeMake(max, max);
    if (width>height)
    {
        size = CGSizeMake(max, max/width*height);
    }
    else if (width<height)
    {
        size = CGSizeMake(max*width/height, max);
    }
    return size;
}

@end
