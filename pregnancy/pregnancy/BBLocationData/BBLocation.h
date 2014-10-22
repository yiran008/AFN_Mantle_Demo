//
//  BBLocation.h
//  pregnancy
//
//  Created by Jun Wang on 12-4-27.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>



@interface BBLocation : NSObject

+ (void)setCurrentLocationByGps:(CLLocation *)gps;

+ (NSString*)userLocationLongitude;

+ (NSString*)userLocationLatitude;

@end
