//
//  BBDeviceUtility
//
//  Created by Wang Jun on 2012-5-16.
//  Last Updated by Wang Jun on 2012-10-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBDeviceUtility.h"
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

#define DEVICE_MAC_ADDRESS @"BBMacAddress_deviceMacAddress"

#define DEVICE_MAC_ADDRESS_WITH_COLON @"BBMacAddress_deviceMacAddressWithColon"

@implementation BBDeviceUtility

+ (NSString *)queryDeviceAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

+ (NSString *)queryDeviceAddressWithColon
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}
+ (NSString *)macAddress
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:DEVICE_MAC_ADDRESS] != nil) {
        return [userDefaults objectForKey:DEVICE_MAC_ADDRESS];
    } else {
        NSString *deviceMacAddress = [self queryDeviceAddress];
        [userDefaults setObject:deviceMacAddress forKey:DEVICE_MAC_ADDRESS];
        return deviceMacAddress;
    }
}

+ (NSString *)macAddressWithColon
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:DEVICE_MAC_ADDRESS_WITH_COLON] != nil) {
        return [userDefaults objectForKey:DEVICE_MAC_ADDRESS_WITH_COLON];
    } else {
        NSString *deviceMacAddress = [self queryDeviceAddressWithColon];
        [userDefaults setObject:deviceMacAddress forKey:DEVICE_MAC_ADDRESS_WITH_COLON];
        return deviceMacAddress;
    }
}

@end
