/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Jamie Pinkham
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <TargetConditionals.h>

#ifdef __OBJC_GC__
#error SDWebImage does not support Objective-C Garbage Collection
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
#error SDWebImage doesn't support Deployement Target version < 5.0
#endif

#if !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#ifndef UIImage
#define UIImage NSImage
#endif
#ifndef UIImageView
#define UIImageView NSImageView
#endif
#else

#import <UIKit/UIKit.h>

#endif

#if ! __has_feature(objc_arc)
#define SDWIAutorelease(__v) ([__v autorelease]);
#define SDWIReturnAutoreleased SDWIAutorelease

#define SDWIRetain(__v) ([__v retain]);
#define SDWIReturnRetained SDWIRetain

#define SDWIRelease(__v) ([__v release]);
#define SDWISafeRelease(__v) ([__v release], __v = nil);
#define SDWISuperDealoc [super dealloc];

#define SDWIWeak
#else
// -fobjc-arc
#define SDWIAutorelease(__v)
#define SDWIReturnAutoreleased(__v) (__v)

#define SDWIRetain(__v)
#define SDWIReturnRetained(__v) (__v)

#define SDWIRelease(__v)
#define SDWISafeRelease(__v) (__v = nil);
#define SDWISuperDealoc

#define SDWIWeak __unsafe_unretained
#endif

/*
// add by DJ
enum SDImageType
{
    SDImageType_NONE = -1,
    SDImageType_BMP = 0,
    SDImageType_JPEG,
    SDImageType_GIF,
    SDImageType_PCX,
    SDImageType_PNG,
    SDImageType_PSD,
    SDImageType_RAS,
    SDImageType_SGI,
    SDImageType_TIFF
};

extern NSInteger SDgetImageType(NSData *image);
// end by DJ
*/

extern UIImage *SDScaledImageForPath(NSString *path, NSObject *imageOrData);
extern UIImage *SDScaledImageForKey(NSString *key, UIImage *image);

