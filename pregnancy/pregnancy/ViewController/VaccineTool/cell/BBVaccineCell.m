//
//  BBVaccineCell.m
//  pregnancy
//
//  Created by Heyanyang on 14-9-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBVaccineCell.h"

@interface BBVaccineCell ()

@property (nonatomic,strong) BBVaccineClass *currentVaccineClass;

@end

@implementation BBVaccineCell
@synthesize currentVaccineClass;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)makeCellStyle
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.exclusiveTouch = YES;
    self.m_tagButton.exclusiveTouch = YES;
}

- (void)setCellContent:(BBVaccineClass *)vaccineClass
{
    self.currentVaccineClass = vaccineClass;
    
    self.m_isNeedImageView.hidden = YES;
    if (vaccineClass.m_isNeed)
    {
        self.m_isNeedImageView.hidden = NO;
    }
    
    self.m_cellLine.hidden = NO;
    if (vaccineClass.m_isHiddenCellLine)
    {
        self.m_cellLine.hidden = YES;
    }
    
    [self.m_tagButton setImage:[UIImage imageNamed:@"vaccine_icon_tagOff"] forState:UIControlStateNormal];
    if (vaccineClass.m_tag)
    {
        [self.m_tagButton setImage:[UIImage imageNamed:@"vaccine_icon_tagOn"] forState:UIControlStateNormal];
    }
    
    self.m_vaccineNameLabel.width = vaccineClass.m_vaccineNameStrWitdh;
    self.m_vaccineNameLabel.text = vaccineClass.m_vaccineName;
    self.m_doTimesStrLabel.left = self.m_vaccineNameLabel.right +10;
    self.m_doTimesStrLabel.text = vaccineClass.m_doTimesStr;
    self.m_remarkLabel.text = vaccineClass.m_remark;
}

#pragma mark -
#pragma mark buttonActions

- (IBAction)tagButtonAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pressTagButtonWithClass:updateSuccess:)])
    {
        [self.delegate pressTagButtonWithClass:self.currentVaccineClass updateSuccess:^(BOOL isSuccess) {
            NSString *imageNameStr = nil;
            if (isSuccess)
            {
                if (self.currentVaccineClass.m_tag)
                {
                    imageNameStr = @"vaccine_icon_tagOn";
                }
                else
                {
                    imageNameStr = @"vaccine_icon_tagOff";
                }
                [self.m_tagButton setImage:[UIImage imageNamed:imageNameStr] forState:UIControlStateNormal];
            }
        }];
    }
}
@end
