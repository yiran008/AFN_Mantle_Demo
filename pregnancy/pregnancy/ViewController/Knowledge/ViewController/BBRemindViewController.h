//
//  BBRemindViewController.h
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

//宝宝发育和每日提醒用一个界面
typedef enum {
    RemindTypeRimind,
    RemindTypeBabyGrowth
}RemindType;

@interface BBRemindViewController : BaseViewController
- (id)initWithType:(RemindType)type;
@property(nonatomic,strong)NSString *startID;
@end
