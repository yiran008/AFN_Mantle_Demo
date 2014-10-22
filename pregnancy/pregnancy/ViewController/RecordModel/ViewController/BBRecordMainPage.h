//
//  BBRecordMainPage.h
//  pregnancy
//
//  Created by babytree on 13-9-26.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordConfig.h"
#import "BBRecordMoonView.h"
#import "BBRecordParkView.h"
#define UPADATE_RECORD_MOON_VIEW  (@"updateRecordMoonView")
#define UPADATE_RECORD_PARK_VIEW  (@"updateRecordParkView")

@interface BBRecordMainPage : BaseViewController

@property (retain, nonatomic) BBRecordMoonView *recordMoonView;
@property (retain, nonatomic) BBRecordParkView *recordParkView;

@end
