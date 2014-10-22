//
//  BBSmartTakeWalkCell.h
//  pregnancy
//
//  Created by whl on 13-11-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSmartTakeWalkCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *targetLabel;
@property (nonatomic, strong) IBOutlet UILabel *actualLabel;
@property (nonatomic, strong) IBOutlet UILabel *durationLabel;

-(void)setupCell:(NSDictionary*)dicData;

@end
