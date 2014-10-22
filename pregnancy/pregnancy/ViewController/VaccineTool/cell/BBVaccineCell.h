//
//  BBVaccineCell.h
//  pregnancy
//
//  Created by Heyanyang on 14-9-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBVaccineClass.h"

@protocol BBVaccineCellDelegate <NSObject>

- (void)pressTagButtonWithClass:(BBVaccineClass *)vaccineClass updateSuccess:(void (^)(BOOL isSuccess))success;

@end

@interface BBVaccineCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *m_isNeedImageView;
@property (strong, nonatomic) IBOutlet UILabel *m_vaccineNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *m_doTimesStrLabel;
@property (strong, nonatomic) IBOutlet UILabel *m_remarkLabel;
@property (strong, nonatomic) IBOutlet UIButton *m_tagButton;
@property (strong, nonatomic) IBOutlet UIView *m_cellLine;

@property (assign) id<BBVaccineCellDelegate> delegate;

- (IBAction)tagButtonAction:(id)sender;

- (void)makeCellStyle;
- (void)setCellContent:(BBVaccineClass *)vaccineClass;

@end
