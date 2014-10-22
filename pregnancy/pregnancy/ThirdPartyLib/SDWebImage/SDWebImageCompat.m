//
//  SDWebImageCompat.m
//  SDWebImage
//
//  Created by Olivier Poitrey on 11/12/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import "SDWebImageCompat.h"

#if !__has_feature(objc_arc)
#error SDWebImage is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif

// add by DJ
#import "UIImage+MultiFormat.h"
#import "UIImage+GIF.h"
#import "NSData+ImageContentType.h"

/*
NSInteger SDgetImageType(NSData *image)
{
    NSInteger Result;
    NSInteger head;

    if ([image length] <= 2)
    {
        return SDImageType_NONE;
    }

    [image getBytes:&head range:NSMakeRange(0, 2)];

    head = head & 0x0000FFFF;
    //NSLog(@"%d, %x", head, head);
    switch (head)
    {
        case 0x4D42:
            Result = SDImageType_BMP;
            break;

        case 0xD8FF:
            Result = SDImageType_JPEG;
            break;

        case 0x4947:
            Result = SDImageType_GIF;
            break;

        case 0x050A:
            Result = SDImageType_PCX;
            break;

        case 0x5089:
            Result = SDImageType_PNG;
            break;

        case 0x4238:
            Result = SDImageType_PSD;
            break;

        case 0xA659:
            Result = SDImageType_RAS;
            break;

        case 0xDA01:
            Result = SDImageType_SGI;
            break;

        case 0x4949:
            Result = SDImageType_TIFF;
            break;

        default:
            Result = SDImageType_NONE;
            break;
    }

    return Result;
}
*/

UIImage *SDScaledImageForPath(NSString *path, NSObject *imageOrData)
{
    if (!imageOrData)
    {
        return nil;
    }

    UIImage *image = nil;
    if ([imageOrData isKindOfClass:[NSData class]])
    {
        // add by DJ
//        if (SDImageType_NONE == SDgetImageType((NSData *)imageOrData))
//        {
//            return nil;
//        }
        image = [UIImage sd_imageWithData:(NSData *)imageOrData];
        // end by DJ
        //image = [[UIImage alloc] initWithData:(NSData *)imageOrData];
    }
    else if ([imageOrData isKindOfClass:[UIImage class]])
    {
        image = SDWIReturnRetained((UIImage *)imageOrData);
    }
    else
    {
        return nil;
    }

//    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
//    {
//        CGFloat scale = 1.0;
//        if (path.length >= 8)
//        {
//            // Search @2x. at the end of the string, before a 3 to 4 extension length (only if key len is 8 or more @2x. + 4 len ext)
//            NSRange range = [path rangeOfString:@"@2x." options:0 range:NSMakeRange(path.length - 8, 5)];
//            if (range.location != NSNotFound)
//            {
//                scale = 2.0;
//            }
//        }
//
//        UIImage *scaledImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
//        SDWISafeRelease(image)
//        image = scaledImage;
//    }

    image = SDScaledImageForKey(path, image);

    return SDWIReturnAutoreleased(image);
}

inline UIImage *SDScaledImageForKey(NSString *key, UIImage *image) {
    if (!image) {
        return nil;
    }

    if ([image.images count] > 0) {
        NSMutableArray *scaledImages = [NSMutableArray array];

        for (UIImage *tempImage in image.images) {
            [scaledImages addObject:SDScaledImageForKey(key, tempImage)];
        }

        return [UIImage animatedImageWithImages:scaledImages duration:image.duration];
    }
    else {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            CGFloat scale = 1.0;
            if (key.length >= 8) {
                // Search @2x. at the end of the string, before a 3 to 4 extension length (only if key len is 8 or more @2x. + 4 len ext)
                NSRange range = [key rangeOfString:@"@2x." options:0 range:NSMakeRange(key.length - 8, 5)];
                if (range.location != NSNotFound) {
                    scale = 2.0;
                }
            }

            UIImage *scaledImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
            image = scaledImage;
        }
        return image;
    }
}
