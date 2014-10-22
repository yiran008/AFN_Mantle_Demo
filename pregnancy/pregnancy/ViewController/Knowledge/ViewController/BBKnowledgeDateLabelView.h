//
//  BBKnowledgeDateLabelView.h
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-30.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBKonwlegdeModel.h"

typedef enum
{
    labelTypePregNormal,
    labelTypePregWeek,
    labelTypePregBegin,
    labelTypePareNormal,
    labelTypePareDays,
    labelTypePareMonth
}labelType;

@interface BBKnowledgeDateLabelView : UIView
- (void)setDateData:(BBKonwlegdeModel *)data;
+ (void)setRoleState:(BBUserRoleState)state;
+ (void)setCurDays:(int)days;
@end
