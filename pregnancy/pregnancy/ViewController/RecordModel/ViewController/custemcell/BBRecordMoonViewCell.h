//
//  BBRecordMoonViewCell.h
//  pregnancy
//
//  Created by babytree on 13-9-27.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBRecordClass.h"

@interface BBRecordMoonViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *pointImageView;
@property (retain, nonatomic) IBOutlet UIImageView *contentBgImageView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIButton *photoButton;
@property (retain, nonatomic) IBOutlet UIImageView *timeBgImageView;
@property (retain, nonatomic) IBOutlet UILabel *thatAgeLabel;
@property (retain, nonatomic) IBOutlet UILabel *createTsLabel;
@property (nonatomic, strong) BBRecordClass *theCurrentClass;

- (void)setCellWithData:(BBRecordClass *)theClass;
- (IBAction)photoEvent:(id)sender;
+ (CGFloat) cellHeight:(BBRecordClass *)theClass;

@end
