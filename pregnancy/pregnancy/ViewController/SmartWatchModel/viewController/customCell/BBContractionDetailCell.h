//
//  BBContractionDetailCell.h
//  pregnancy
//
//  Created by whl on 13-11-14.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBContractionDetailCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *startLabel;
@property (nonatomic, strong) IBOutlet UILabel *endLabel;
@property (nonatomic, strong) IBOutlet UILabel *durationLabel;

-(void)setupCell:(NSDictionary*)dicData;

@end
