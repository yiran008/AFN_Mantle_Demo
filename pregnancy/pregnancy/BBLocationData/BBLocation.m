//
//  BBLocation.m
//  pregnancy
//
//  Created by Jun Wang on 12-4-27.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBLocation.h"

#define USER_LOCATION_GPS_LAT   @"user_location_gps_latitude"
#define USER_LOCATION_GPS_LON   @"user_location_gps_longitude"

@implementation BBLocation

+ (void)setCurrentLocationByGps:(CLLocation*)gps
{
    if (!([gps isKindOfClass:[CLLocation class]]||gps==nil)) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%f",gps.coordinate.longitude] forKey:USER_LOCATION_GPS_LON];
    [defaults setObject:[NSString stringWithFormat:@"%f",gps.coordinate.latitude] forKey:USER_LOCATION_GPS_LAT];
}

+ (NSString*)userLocationLongitude
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longitude = [defaults stringForKey:USER_LOCATION_GPS_LON];
    return longitude?longitude:@"";
}

+ (NSString*)userLocationLatitude
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *latitude = [defaults stringForKey:USER_LOCATION_GPS_LAT];
    return latitude?latitude:@"";
}

@end
