//
//  BBRemindCellContentView.h
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-15.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBKonwlegdeModel.h"
#import "BBKnowledgeDateLabelView.h"

#define REMIND_FONT_CONTENT 14.

@interface BBRemindCellContentView : UIView
@property(nonatomic,strong)BBKonwlegdeModel * data;
@property UIImageView * line;
@property(nonatomic,strong)BBKnowledgeDateLabelView * dateView;
@end
