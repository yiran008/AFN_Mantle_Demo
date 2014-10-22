//
//  BBMusicTypeCell.h
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-23.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBMusicTypeCell : UITableViewCell
@property (nonatomic, retain) NSDictionary *musicTypeInfo;
- (void)resetCell;
@end
