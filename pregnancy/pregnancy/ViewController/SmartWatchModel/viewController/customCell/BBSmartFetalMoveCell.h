//
//  BBSmartFetalMoveCell.h
//  pregnancy
//
//  Created by whl on 13-11-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSmartFetalMoveCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberLabel;


-(void)setupCell:(NSDictionary*)dicData;

@end
