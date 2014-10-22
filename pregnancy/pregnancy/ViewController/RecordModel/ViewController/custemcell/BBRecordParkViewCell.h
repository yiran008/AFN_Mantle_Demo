//
//  BBRecordParkViewCell.h
//  pregnancy
//
//  Created by babytree on 13-9-27.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordConfig.h"

@interface BBRecordParkViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIButton *avatarButton;
@property (retain, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *contentBgImageView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIButton *photoButton;
@property (retain, nonatomic) IBOutlet UILabel *babyAgeLabel;
@property (retain, nonatomic) IBOutlet UILabel *createTsLabel;
@property (retain, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) NSDictionary *data;

- (void)setCellWithData:(NSDictionary *)dataDic;
- (IBAction)avatarEvent:(id)sender;
- (IBAction)photoEvent:(id)sender;
+ (CGFloat) cellHeight:(NSDictionary *)dataDic;
@end
