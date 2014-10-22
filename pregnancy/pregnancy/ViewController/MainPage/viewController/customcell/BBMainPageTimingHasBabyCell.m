//
//  BBMainPageTimingHasBabyCell.m
//  pregnancy
//
//  Created by liumiao on 4/9/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBMainPageTimingHasBabyCell.h"
#import "BBBabyAgeCalculation.h"
@implementation BBMainPageTimingHasBabyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //[self setBackgroundColor:[UIColor colorWithHex:0xff537b]];
        [self.contentView setBackgroundColor:[UIColor colorWithHex:0xff537b]];
        
        UIImageView *babySmileView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 6, 24, 24)];
        [babySmileView setImage:[UIImage imageNamed:@"mainPageBabySmile"]];
        [self.contentView addSubview:babySmileView];
        self.m_BabyGrowDaysLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 3, 275, 30)];
        [self.m_BabyGrowDaysLabel setTextColor:[UIColor whiteColor]];
        [self.m_BabyGrowDaysLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.m_BabyGrowDaysLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateUI
{
    //获取时间数据并更新UI
    
    NSInteger bornDays = [BBPregnancyInfo daysOfPregnancy]-1;
    NSDate *stopData = [[BBPregnancyInfo dateOfPregnancy] dateByAddingTimeInterval:bornDays*24*3600];
    NSString *babyAge = [BBBabyAgeCalculation babyAgeWithStartDate:[BBPregnancyInfo dateOfPregnancy] withStopDate:stopData];
    
    NSString *content = [NSString stringWithFormat:@"%@%@",@"宝宝",babyAge];
    NSArray *contentArray = [content componentsSeparatedByString:@";"];
    
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:[contentArray componentsJoinedByString:@""]];
    
    
    NSInteger startLength = 0;
    for (int i =0 ;i< [contentArray count];i++)
    {
        NSString *aStr = [contentArray objectAtIndex:i];
        NSInteger aLength = [aStr length];
        if (i%2 ==0)
        {
            //文字
            [contentText addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:12]
                                range:NSMakeRange(startLength,aLength)];
        }
        else
        {
            //数字
            [contentText addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:24]
                                range:NSMakeRange(startLength,aLength)];

        }
        startLength += aLength;
    }

    self.m_BabyGrowDaysLabel.attributedText = contentText;
}
@end
