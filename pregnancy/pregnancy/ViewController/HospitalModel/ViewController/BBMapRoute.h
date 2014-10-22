//
//  BBMapRoute.h
//  pregnancy
//
//  Created by babytree babytree on 12-10-25.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapView.h"
#import "Place.h"

@interface BBMapRoute : BaseViewController
{
    double hospitalLatitude;
    double hospitalLongitude;
    NSString *hospitalName;
}
@property(assign)double hospitalLatitude;
@property(assign)double hospitalLongitude;
@property(nonatomic,strong)NSString *hospitalName;
@end
