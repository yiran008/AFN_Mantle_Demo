//
//  UILabel+TextAlignment.h
//  pregnancy
//
//  Created by zhangzhongfeng on 14-1-2.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TextAlignment)
- (void)setBBTextAlignment:(NSTextAlignment)alignment;
//内容靠顶
- (void)alignTop;
//内容靠底
- (void)alignBottom;
@end
